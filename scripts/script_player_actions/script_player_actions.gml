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
    var _view_x = (_item_key == "bow") ? mouse_x : _target_x;
    var _view_y = (_item_key == "bow") ? mouse_y : _target_y;
    var _diff_x = _view_x - _p_center_x;
    var _diff_y = _view_y - _p_center_y;

    if (abs(_diff_x) > abs(_diff_y)) {
        other.dir = (_diff_x > 0) ? DIR.RIGHT : DIR.LEFT;
    } else {
        other.dir = (_diff_y > 0) ? DIR.DOWN : DIR.UP;
    }
    
    // 4. Referencias de Mapa
    var _map_id = layer_tilemap_get_id(layer_get_id("Tiles_tilled_watered"));

    // --- LÓGICA DE COSECHA (Hoz o Mano) ---
    var _crop = instance_position(_target_x, _target_y, obj_crop);
    if (_crop != noone) {
        // Un cultivo está maduro si growth_stage alcanzó su máximo (days_to_grow/max_stages)
        // Según obj_crop, growth_stage se clampa a max_stages.
        if (_crop.growth_stage >= _crop.max_stages) {
            // Solo se cosecha con la mano (vacio) o con la hoz
            if (_item_key == "" || _item_key == "sickle") {
                // Si es la hoz, activamos animación
                if (_item_key == "sickle") {
                    other.state = STATE.ACTING;
                    other.frame_anim = 0;
                    other.frames_action = 6;
                    other.action_sprite_tool = sprite_player_sickle_axe_sickle;
                    scr_set_player_action_sprites(sprite_player_skin_axe_sickle, sprite_player_hair_axe_sickle, sprite_player_clothes_axe_sickle, sprite_player_eyes_axe_sickle);
                }

                // Dropear el item del fruto
                inventory_drop_item(_crop.crop_type, 1, _crop.x + 8, _crop.y + 8);
                
                // Destruir planta
                instance_destroy(_crop);
                
                // (Opcional) El suelo vuelve a estar arado pero seco (72) ya se hace al avanzar el día si estaba regado
                // pero si se cosecha el mismo día que se regó, podemos forzarlo o dejarlo.
                exit; // Salimos para no intentar "usar" el item en el mismo click
            }
        }
    }

    // --- A. LÓGICA DE HERRAMIENTAS ---
    if (_item_key != "" && variable_struct_exists(global.tool_data, _item_key)) {
        other.state = STATE.ACTING; 
        other.frame_anim = 0;

        switch (_item_key) {
            case "hoe":
                var _current_tile = tilemap_get_at_pixel(_map_id, _gx, _gy);
                // Si no es tierra arada (72) ni regada (168), entonces lo aramos (72)
                if (_current_tile != 72 && _current_tile != 168) {
                    tilemap_set_at_pixel(_map_id, 72, _gx, _gy);
                }
                other.frames_action = 6;
                other.action_sprite_tool = sprite_player_hoe_pickaxe_hoe_insects;
                scr_set_player_action_sprites(sprite_player_skin_pickaxe_hoe_insects, sprite_player_hair_pickaxe_hoe_insects, sprite_player_clothes_pickaxe_hoe_insects, sprite_player_eyes_pickaxe_hoe_insects);
            break;

            case "watering_can":
                if (tilemap_get_at_pixel(_map_id, _gx, _gy) == 72) tilemap_set_at_pixel(_map_id, 168, _gx, _gy);
                
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
        var _current_tile = tilemap_get_at_pixel(_map_id, _target_x, _target_y);

        // Suelo arado (72) o regado (168)
        if (_current_tile == 72 || _current_tile == 168) {
            if (!instance_position(_gx + 8, _gy + 8, obj_crop)) {
                
                var _seed_info = global.seed_data[$ _item_key];
                var _new_crop  = instance_create_layer(_gx, _gy, "Instances_Crops", obj_crop);
                
                with(_new_crop) {
                    var _asset_name = "sprite_crop_" + _seed_info.crop_base_name;
                    sprite_index = asset_get_index(_asset_name);
                    crop_type    = _seed_info.crop_base_name; // Guardamos que fruto es
                    days_to_grow = _seed_info.growth_time;
                    max_stages   = _seed_info.growth_time; 
                    if (_seed_info.crop_base_name == "pumpkin" || _seed_info.crop_base_name == "grapes") skip_blank_frame = true;
                    image_index = 0;
                    image_speed = 0;
                }
                
                // Gastar item del inventario
                var _inv_slot = obj_inventory.inventory_array[obj_inventory.selected_slot];
                if (is_struct(_inv_slot)) {
                    _inv_slot.quantity -= 1;
                    if (_inv_slot.quantity <= 0) obj_inventory.inventory_array[obj_inventory.selected_slot] = -1;
                }
            }
        }
    }

    // --- C. LÓGICA DE OBJETOS COLOCABLES (Cofres, etc.) ---
    else if (_item_key != "" && variable_struct_exists(global.placeable_data, _item_key)) {
        // Bloquear si el selector está en rojo (distancia o colisión con jugador)
        if (instance_exists(obj_controller) && obj_controller.selector_color == c_red) exit;

        var _can_place = !instance_position(_gx + 8, _gy + 8, obj_collision) && 
                         !instance_position(_gx + 8, _gy + 8, obj_crop) && 
                         !instance_position(_gx + 8, _gy + 8, obj_item_parent);
                         
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
