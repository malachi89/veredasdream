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
    var _layer_tilled = layer_get_id("Tiles_tilled_watered");
    var _map_id = (_layer_tilled != -1) ? layer_tilemap_get_id(_layer_tilled) : -1;
    var _layer_details = layer_get_id("Tiles_details");
    var _map_id_details = (_layer_details != -1) ? layer_tilemap_get_id(_layer_details) : -1;

    // --- LÓGICA DE COSECHA (Hoz o Mano) ---
    var _crop_instance_found = instance_position(_target_x, _target_y, obj_crop); // Use a new variable name to avoid conflict
    if (_crop_instance_found != noone) {
        // Check if it's a fruit tree
        if (_crop_instance_found.is_fruit_tree) {
            if (_crop_instance_found.has_fruit) {
                // Only harvest fruit if it's a fruit tree and has fruit
                if (_item_key == "" || _item_key == "sickle") {
                    // If it's the sickle, activate animation
                    if (_item_key == "sickle") {
                        other.state = STATE.ACTING;
                        other.frame_anim = 0;
                        other.frames_action = 6;
                        other.action_sprite_tool = sprite_player_sickle_axe_sickle;
                        scr_set_player_action_sprites(sprite_player_skin_axe_sickle, sprite_player_hair_axe_sickle, sprite_player_clothes_axe_sickle, sprite_player_eyes_axe_sickle);
                    }

                    // Drop the fruit item
                    inventory_drop_item(_crop_instance_found.fruit_item, 1, _crop_instance_found.x + 16, _crop_instance_found.y + 32); // Drop fruit in the bottom center of the tree
                    
                    // Reset fruit cycle
                    _crop_instance_found.has_fruit = false;
                    _crop_instance_found.days_since_harvest = 0;
                    // image_index will be updated in the Draw event
                    
                    exit; // Exit to not try to "use" the item in the same click
                }
            }
        } else { // Existing logic for regular crops
            // A crop is mature if growth_stage reached its maximum (days_to_grow/max_stages)
            // According to obj_crop, growth_stage is clamped to max_stages.
            if (_crop_instance_found.growth_stage >= _crop_instance_found.max_stages) {
                // Only harvest with hand (empty) or sickle
                if (_item_key == "" || _item_key == "sickle") {
                    // If it's the sickle, activate animation
                    if (_item_key == "sickle") {
                        other.state = STATE.ACTING;
                        other.frame_anim = 0;
                        other.frames_action = 6;
                        other.action_sprite_tool = sprite_player_sickle_axe_sickle;
                        scr_set_player_action_sprites(sprite_player_skin_axe_sickle, sprite_player_hair_axe_sickle, sprite_player_clothes_axe_sickle, sprite_player_eyes_axe_sickle);
                    }

                    // Drop the fruit item
                    inventory_drop_item(_crop_instance_found.crop_type, 1, _crop_instance_found.x + 8, _crop_instance_found.y + 8);
                    
                    // Destroy plant
                    instance_destroy(_crop_instance_found);
                    
                    // (Optional) The soil goes back to tilled but dry (72) this is already done by advancing the day if it was watered
                    // but if harvested the same day it was watered, we can force it or leave it.
                    exit; // Exit to not try to "use" the item in the same click
                }
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
                    var _fruit_tree_to_remove = noone;
                    var _bbox_left = _target_x - 8; // Convert to top-left corner coord of the tile
                    var _bbox_top = _target_y - 8;
                    var _bbox_right = _target_x + 8;
                    var _bbox_bottom = _target_y + 8;

                    // Search for a fruit tree that overlaps with the clicked tile
                    with (obj_crop) {
                        if (is_fruit_tree) {
                            // Tree's coordinates are its top-left corner
                            // Its area is x,y to x+31, y+47
                            if (bbox_left < _bbox_right && bbox_right > _bbox_left &&
                                bbox_top < _bbox_bottom && bbox_bottom > _bbox_top) {
                                _fruit_tree_to_remove = id;
                                break;
                            }
                        }
                    }

                    if (_fruit_tree_to_remove != noone) {
                        inventory_drop_item("wood", 1, _fruit_tree_to_remove.x + 16, _fruit_tree_to_remove.y + 32); // Drop wood when chopping down tree
                        instance_destroy(_fruit_tree_to_remove);
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

        var _can_plant_here = false; // Flag to determine if planting is allowed at _gx, _gy

        if (_is_fruit_tree_seed) {
            // Check for fruit tree placement (2x3 area)
            var _tree_width_tiles = 2; // 32px / 16px
            var _tree_height_tiles = 3; // 48px / 16px

            var _gx_end = _gx + (_tree_width_tiles * 16) - 1;
            var _gy_end = _gy + (_tree_height_tiles * 16) - 1;

            // Check if entire 2x3 area is within room boundaries
            var _in_bounds = _gx >= 0 && _gy >= 0 && _gx_end < room_width && _gy_end < room_height;
            
            _can_plant_here = _in_bounds;

            if (_can_plant_here) {
                // Check if all 2x3 tiles are clear of collisions, crops, items, and Tiles_details
                for (var xx = _gx; xx < _gx + (_tree_width_tiles * 16); xx += 16) {
                    for (var yy = _gy; yy < _gy + (_tree_height_tiles * 16); yy += 16) {
                        if (instance_position(xx + 8, yy + 8, obj_crop) || // Check center of the tile
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
            // Existing logic for regular crops (1x1 area)
            var _current_tile_at_gxgy = tilemap_get_at_pixel(_map_id, _gx, _gy); // Use _gx, _gy directly
            // Tilled soil (72) or watered (168) and no tile on Tiles_details
            _can_plant_here = ((_current_tile_at_gxgy == 72 || _current_tile_at_gxgy == 168) && (_map_id_details != -1 && tilemap_get_at_pixel(_map_id_details, _gx, _gy) == 0));
        }

        if (_can_plant_here) {
            var _new_crop  = instance_create_layer(_gx, _gy, "Instances_Crops", obj_crop);
            
            with(_new_crop) {
                crop_type    = _seed_info.crop_base_name;
                days_to_grow = _seed_info.growth_time;
                max_stages   = _seed_info.growth_time; 
                is_fruit_tree = _is_fruit_tree_seed; // Pass the flag to the crop instance
                fruit_item = _seed_info.fruit_item; // Ensure fruit_item is copied if it exists in seed_info

                // Sprite assignment logic
                if (is_fruit_tree) {
                    // Tree sprites will be updated seasonally in the Draw event
                    // Here, only initialize with the current season's sprite
                    var _tree_sprite_name = "sprite_" + crop_type + "_" + global.season; // e.g., sprite_orange_tree_summer
                    sprite_index = asset_get_index(_tree_sprite_name);
                    image_index = 0; // Default to first frame (non-fruiting)
                    image_speed = 0;
                    // Additional tree-specific setup
                    fruit_cycle_days = 2; // Fruits every 2 days after maturing
                    days_since_harvest = 0; // Days since last harvest (or initial planting)
                    has_fruit = false; // Initial state: no fruit
                    // sprite_width and sprite_height properties will be read from global.crop_data in Draw
                } else {
                    var _asset_name = "sprite_crop_" + _seed_info.crop_base_name;
                    sprite_index = asset_get_index(_asset_name);
                    if (_seed_info.crop_base_name == "pumpkin" || _seed_info.crop_base_name == "grapes") skip_blank_frame = true;
                    image_index = 0;
                    image_speed = 0;
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
