function scr_use_item(_item_data, _gx, _gy) {
    // 1. Extraer Key (por si viene un struct o un string)
    var _item_key = is_struct(_item_data) ? _item_data.key : _item_data;
    if (_item_key == undefined || _item_key == -1) _item_key = "";

    // 2. Definición de Variables de Posición
    var _p_center_x = (other.bbox_left + other.bbox_right) / 2;
    var _p_center_y = (other.bbox_top + other.bbox_bottom) / 2;
    var _target_x = _gx + 8;
    var _target_y = _gy + 8;

    // 3. Reorientación del Jugador
    var _view_x = (_item_key == "bow" || _item_key == "sickle") ? mouse_x : _target_x;
    var _view_y = (_item_key == "bow" || _item_key == "sickle") ? mouse_y : _target_y;
    var _diff_x = _view_x - _p_center_x;
    var _diff_y = _view_y - _p_center_y;

    if (abs(_diff_x) > abs(_diff_y)) {
        other.dir = (_diff_x > 0) ? DIR.RIGHT : DIR.LEFT;
    } else {
        other.dir = (_diff_y > 0) ? DIR.DOWN : DIR.UP;
    }
    
    // 4. Referencias de Mapa
    var _layer_tilled = layer_get_id("Tiles_tilled_watered");
    var _map_id = (_layer_tilled != -1) ? layer_tilemap_get_id(_layer_tilled) : -1;
    var _layer_details = layer_get_id("Tiles_details");
    var _map_id_details = (_layer_details != -1) ? layer_tilemap_get_id(_layer_details) : -1;

    // --- LÓGICA DE COSECHA (Hoz o Mano) ---
    var _is_harvesting = false;
    
    if (_item_key == "sickle") {
        // Harvesting with Sickle (3x3 Area)
        var _x1 = _target_x - 24; 
        var _y1 = _target_y - 24;
        var _x2 = _target_x + 24;
        var _y2 = _target_y + 24;
        
        // Add distance check to prevent harvesting far away
        var _dist = point_distance(_p_center_x, _p_center_y, _target_x, _target_y);
        
        if (_dist <= 64) { // Only harvest if within reach (64px = 4 tiles)
            // Find all crops in area
            var _list = ds_list_create();
            var _count = collision_rectangle_list(_x1, _y1, _x2, _y2, obj_crop, false, true, _list, false);
            for (var i = 0; i < _count; i++) {
                var _inst = _list[| i];
                if (_inst.growth_stage >= _inst.max_stages) {
                    _is_harvesting = true;
                    inventory_drop_item(_inst.crop_type, 1, _inst.x + 8, _inst.y + 8);
                    instance_destroy(_inst);
                }
            }
            ds_list_clear(_list);
            
            // Find all trees in area
            _count = collision_rectangle_list(_x1, _y1, _x2, _y2, obj_tree, false, true, _list, false);
            for (var i = 0; i < _count; i++) {
                var _inst = _list[| i];
                if (_inst.has_fruit) {
                    _is_harvesting = true;
                    inventory_drop_item(_inst.fruit_item, 1, _inst.x, _inst.y);
                    _inst.has_fruit = false;
                    _inst.days_since_harvest = 0;
                }
            }
            ds_list_destroy(_list);
        }
    } else if (_item_key == "") {
        // Manual harvest (1x1 Area)
        var _crop_inst = instance_position(_target_x, _target_y, obj_crop);
        var _tree_inst = instance_position(_target_x, _target_y, obj_tree);
        
        if (_tree_inst != noone && _tree_inst.has_fruit) {
            _is_harvesting = true;
            inventory_drop_item(_tree_inst.fruit_item, 1, _tree_inst.x, _tree_inst.y);
            _tree_inst.has_fruit = false;
            _tree_inst.days_since_harvest = 0;
        }
        
        if (_crop_inst != noone && _crop_inst.growth_stage >= _crop_inst.max_stages) {
            _is_harvesting = true;
            inventory_drop_item(_crop_inst.crop_type, 1, _crop_inst.x + 8, _crop_inst.y + 8);
            instance_destroy(_crop_inst);
        }
    }

    if (_is_harvesting) {
        if (_item_key == "sickle") {
            other.state = STATE.ACTING;
            other.frame_anim = 0;
            other.frames_action = 6;
            other.action_sprite_tool = sprite_player_sickle_axe_sickle;
            scr_set_player_action_sprites(sprite_player_skin_axe_sickle, sprite_player_hair_axe_sickle, sprite_player_clothes_axe_sickle, sprite_player_eyes_axe_sickle);
        }
        exit;
    }

    // --- A. LÓGICA DE HERRAMIENTAS ---
    if (_item_key != "" && variable_struct_exists(global.tool_data, _item_key)) {
        other.state = STATE.ACTING; 
        other.frame_anim = 0;
        
        // Guardar calidad para la animación (excepto espada/arco)
        if (_item_key != "sword" && _item_key != "bow" && is_struct(_item_data) && variable_struct_exists(_item_data, "quality")) {
            other.action_quality = _item_data.quality;
        } else {
            other.action_quality = 0;
        }

        switch (_item_key) {
            case "hoe":
                var _current_tile = tilemap_get_at_pixel(_map_id, _gx, _gy);
                // Si no es tierra arada (72) ni regada (168), y no hay tile en Tiles_details, entonces lo aramos (72)
                if ((_current_tile != 72 && _current_tile != 168) && (_map_id_details != -1 && tilemap_get_at_pixel(_map_id_details, _gx, _gy) == 0)) {
                    tilemap_set_at_pixel(_map_id, 72, _gx, _gy);
                }
                other.frames_action = 6;
                other.action_sprite_tool = sprite_player_hoe_pickaxe_hoe_insects;
                scr_set_player_action_sprites(sprite_player_skin_pickaxe_hoe_insects, sprite_player_hair_pickaxe_hoe_insects, sprite_player_clothes_pickaxe_hoe_insects, sprite_player_eyes_pickaxe_hoe_insects);
            break;

            case "watering_can":
                if ((tilemap_get_at_pixel(_map_id, _gx, _gy) == 72) && (_map_id_details != -1 && tilemap_get_at_pixel(_map_id_details, _gx, _gy) == 0)) tilemap_set_at_pixel(_map_id, 168, _gx, _gy);
                
                var _watered_crop = instance_position(_gx + 8, _gy + 8, obj_crop);
                if (_watered_crop != noone) {
                    _watered_crop.is_watered = true;
                }

                other.frames_action = 8;
                other.action_sprite_tool = sprite_player_watering_can_watering;
                scr_set_player_action_sprites(sprite_player_skin_watering, sprite_player_hair_watering, sprite_player_clothes_watering, sprite_player_eyes_watering);
            break;

            case "axe":
            case "pickaxe":
                // Lógica para quitar cofres
                var _chest_to_remove = instance_position(_target_x, _target_y, obj_chest);
                if (_chest_to_remove != noone) {
                    var _is_empty = true;
                    for (var i = 0; i < 64; i++) {
                        if (_chest_to_remove.storage_array[i] != -1) {
                            _is_empty = false;
                            break;
                        }
                    }
                    
                    if (_is_empty) {
                        inventory_drop_item("chest", 1, _chest_to_remove.x + 8, _chest_to_remove.y + 8);
                        instance_destroy(_chest_to_remove);
                    } else {
                        scr_notify("No se pueden quitar cofres con articulos adentro");
                    }
                } else {
                    // NEW: Logic to remove fruit trees with axe
                    var _tree_to_remove = instance_position(_target_x, _target_y, obj_tree);

                    if (_tree_to_remove != noone) {
                        inventory_drop_item("wood", 1, _tree_to_remove.x, _tree_to_remove.y);
                        instance_destroy(_tree_to_remove);
                    }
                }

                other.frames_action = 6;
                other.action_sprite_tool = (_item_key == "axe") ? sprite_player_axe_axe_sickle : sprite_player_pickaxe_pickaxe_hoe_insects;
                if (_item_key == "axe") {
                    scr_set_player_action_sprites(sprite_player_skin_axe_sickle, sprite_player_hair_axe_sickle, sprite_player_clothes_axe_sickle, sprite_player_eyes_axe_sickle);
                } else {
                    scr_set_player_action_sprites(sprite_player_skin_pickaxe_hoe_insects, sprite_player_hair_pickaxe_hoe_insects, sprite_player_clothes_pickaxe_hoe_insects, sprite_player_eyes_pickaxe_hoe_insects);
                }
            break;

            case "sickle":
                other.frames_action = 6;
                other.action_sprite_tool = sprite_player_sickle_axe_sickle;
                scr_set_player_action_sprites(sprite_player_skin_axe_sickle, sprite_player_hair_axe_sickle, sprite_player_clothes_axe_sickle, sprite_player_eyes_axe_sickle);
            break;

            case "sword":
                other.frames_action = 10;
                other.action_sprite_tool = sprite_player_sword_sword;
                scr_set_player_action_sprites(sprite_player_skin_sword, sprite_player_hair_sword, sprite_player_clothes_sword, sprite_player_eyes_sword);
            break;

            case "bow":
                other.frames_action = 7;
                other.action_sprite_tool = sprite_player_bow_archer;
                scr_set_player_action_sprites(sprite_player_skin_archer, sprite_player_hair_archer, sprite_player_clothes_archer, sprite_player_eyes_archer);
            break;

            case "bugnet":
                other.frames_action = 6;
                other.action_sprite_tool = sprite_player_bugnet_pickaxe_hoe_insects;
                scr_set_player_action_sprites(sprite_player_skin_pickaxe_hoe_insects, sprite_player_hair_pickaxe_hoe_insects, sprite_player_clothes_pickaxe_hoe_insects, sprite_player_eyes_pickaxe_hoe_insects);
            break;
            
            case "shovel":
                other.frames_action = 6;
                other.action_sprite_tool = sprite_player_shovel_shovel; 
                scr_set_player_action_sprites(sprite_player_skin_shovel, sprite_player_hair_shovel, sprite_player_clothes_shovel, sprite_player_eyes_shovel);
            break;
        }
    }

    // --- B. LÓGICA DE SEMILLAS ---
    else if (_item_key != "" && variable_struct_exists(global.seed_data, _item_key)) {
        var _seed_info = global.seed_data[$ _item_key];
        var _is_fruit_tree_seed = variable_struct_exists(_seed_info, "is_fruit_tree") && _seed_info.is_fruit_tree;

        var _can_plant_here = false;

        if (_is_fruit_tree_seed) {
            // Check for fruit tree placement (2x3 area)
            var _tree_width_tiles = 2; 
            var _tree_height_tiles = 3; 

            var _gx_end = _gx + (_tree_width_tiles * 16) - 1;
            var _gy_end = _gy + (_tree_height_tiles * 16) - 1;

            _can_plant_here = _gx >= 0 && _gy >= 0 && _gx_end < room_width && _gy_end < room_height;

            if (_can_plant_here) {
                for (var xx = _gx; xx < _gx + (_tree_width_tiles * 16); xx += 16) {
                    for (var yy = _gy; yy < _gy + (_tree_height_tiles * 16); yy += 16) {
                        if (instance_position(xx + 8, yy + 8, obj_crop) || 
                            instance_position(xx + 8, yy + 8, obj_tree) || 
                            instance_position(xx + 8, yy + 8, obj_collision) ||
                            instance_position(xx + 8, yy + 8, obj_item_parent) ||
                            (_map_id_details != -1 && tilemap_get_at_pixel(_map_id_details, xx, yy) != 0)) {
                            _can_plant_here = false;
                            break;
                        }
                    }
                    if (!_can_plant_here) break;
                }
            }
        } else {
            var _current_tile_at_gxgy = tilemap_get_at_pixel(_map_id, _gx, _gy);
            _can_plant_here = ((_current_tile_at_gxgy == 72 || _current_tile_at_gxgy == 168) && 
                               (_map_id_details != -1 && tilemap_get_at_pixel(_map_id_details, _gx, _gy) == 0) &&
                               !instance_position(_gx + 8, _gy + 8, obj_crop) &&
                               !instance_position(_gx + 8, _gy + 8, obj_tree));
        }

        if (_can_plant_here) {
            var _obj_to_create = _is_fruit_tree_seed ? obj_tree : obj_crop;
            var _new_inst  = instance_create_layer(_gx, _gy, "Instances_Crops", _obj_to_create);
            
            with(_new_inst) {
                crop_type    = _seed_info.crop_base_name;
                days_to_grow = _seed_info.growth_time;
                max_stages   = _seed_info.growth_time; 
                
                if (_is_fruit_tree_seed) {
                    fruit_item = crop_type;
                    fruit_cycle_days = 2;
                    days_since_harvest = 0;
                    has_fruit = false;
                } else {
                    if (crop_type == "pumpkin" || crop_type == "grapes") skip_blank_frame = true;
                }
            }
            
            // Gastar item del inventario
            var _inv_slot = obj_inventory.inventory_array[obj_inventory.selected_slot];
            if (is_struct(_inv_slot)) {
                _inv_slot.quantity -= 1;
                if (_inv_slot.quantity <= 0) obj_inventory.inventory_array[obj_inventory.selected_slot] = -1;
            }
        }
    }

    // --- C. LÓGICA DE OBJETOS COLOCABLES (Cofres, etc.) ---
    else if (_item_key != "" && variable_struct_exists(global.placeable_data, _item_key)) {
        // Bloquear si el selector está en rojo (distancia o colisión con jugador)
        if (instance_exists(obj_controller) && obj_controller.selector_color == c_red) exit;

        var _can_place = !instance_position(_gx + 8, _gy + 8, obj_collision) && 
                         !instance_position(_gx + 8, _gy + 8, obj_crop) && 
                         !instance_position(_gx + 8, _gy + 8, obj_tree) && 
                         !instance_position(_gx + 8, _gy + 8, obj_item_parent) &&
                         _gx >= 0 && _gy >= 0 && _gx < room_width - 16 && _gy < room_height - 16;
                         
        // Verificar que el jugador no esté en el camino
        if (_can_place && instance_exists(obj_player)) {
            if (collision_rectangle(_gx, _gy, _gx + 15, _gy + 15, obj_player, false, true)) {
                _can_place = false;
            }
        }

        if (_can_place) {
            var _data = global.placeable_data[$ _item_key];
            var _off_x = variable_struct_exists(_data, "place_offset_x") ? _data.place_offset_x : 0;
            var _off_y = variable_struct_exists(_data, "place_offset_y") ? _data.place_offset_y : 0;
            
            var _inst = instance_create_layer(_gx + _off_x, _gy + _off_y, "Instances", obj_chest);
            
            // Gastar item del inventario
            var _inv_slot = obj_inventory.inventory_array[obj_inventory.selected_slot];
            if (is_struct(_inv_slot)) {
                _inv_slot.quantity -= 1;
                if (_inv_slot.quantity <= 0) obj_inventory.inventory_array[obj_inventory.selected_slot] = -1;
            }
        }
    }
}

// Función auxiliar para no repetir tanto código de sprites
function scr_set_player_action_sprites(_skin, _hair, _clothes, _eyes) {
    other.action_sprite_skin = _skin;
    other.action_sprite_hair = _hair;
    other.action_sprite_clothes = _clothes;
    other.action_sprite_eyes = _eyes;
}

function scr_buy_building(_building_name) {
    var _placeholder_obj = noone;
    var _actual_obj = noone;

    switch (_building_name) {
        case "chicken_coop":
            _placeholder_obj = obj_chicken_placeholder;
            _actual_obj = obj_chicken;
            break;
        case "barn":
            _placeholder_obj = obj_barn_placeholder;
            _actual_obj = obj_barn;
            break;
        case "stable":
            _placeholder_obj = obj_stable_placeholder;
            _actual_obj = obj_stable;
            break;
        case "mill":
            _placeholder_obj = obj_mill_placeholder;
            _actual_obj = obj_mill;
            break;
        case "greenhouse":
            _placeholder_obj = obj_greenhouse_placeholder;
            _actual_obj = obj_greenhouse;
            break;
        default:
            scr_notify("Edificio desconocido: " + _building_name);
            return false;
    }

    if (instance_exists(_placeholder_obj)) {
        var _inst = instance_find(_placeholder_obj, 0);
        var _x = _inst.x;
        var _y = _inst.y;
        var _layer = _inst.layer;

        instance_destroy(_inst);
        instance_create_layer(_x, _y, _layer, _actual_obj);
        
        if (_building_name == "stable") {
            // Spawn 2 horses outside the stable
            instance_create_layer(_x + 96, _y + 16, "Instances", obj_horse1);
            instance_create_layer(_x + 96, _y + 40, "Instances", obj_horse1);
        }
        
        scr_notify("!" + _building_name + " comprado!");
        return true;
    } else {
        scr_notify("No se encontro el lugar para " + _building_name);
        return false;
    }
}
