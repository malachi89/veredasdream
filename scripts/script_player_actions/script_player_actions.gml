
function scr_use_item(_item_key, _gx, _gy) {

    if (_item_key == undefined || _item_key == -1) return;

    // --- 1. DEFINICIÓN DE VARIABLES (Esto es lo que faltaba o fallaba) ---
    // Usamos el centro de la máscara de colisión del jugador
    var _p_center_x = (other.bbox_left + other.bbox_right) / 2;
    var _p_center_y = (other.bbox_top + other.bbox_bottom) / 2;
    
    // El objetivo es el centro del tile donde hicimos clic
    var _target_x = _gx + 8;
    var _target_y = _gy + 8;

    // --- 2. REORIENTACIÓN ---
    // Si es el arco, comparamos con el mouse exacto, si no, con el centro del tile
    var _view_x = (_item_key == "bow") ? mouse_x : _target_x;
    var _view_y = (_item_key == "bow") ? mouse_y : _target_y;

    var _diff_x = _view_x - _p_center_x;
    var _diff_y = _view_y - _p_center_y;

    if (abs(_diff_x) > abs(_diff_y)) {
        other.dir = (_diff_x > 0) ? DIR.RIGHT : DIR.LEFT;
    } else {
        other.dir = (_diff_y > 0) ? DIR.DOWN : DIR.UP;
    }
    
    // --- 3. VARIABLES AUXILIARES PARA TILES/SEMILLAS ---
    var _tile_cx = _target_x; 
    var _tile_cy = _target_y;
    
    // Capas de Tiles
    var _lay_id = layer_get_id("Tiles_tilled_watered");
    var _map_id = layer_tilemap_get_id(_lay_id);

    // --- A. ACCIONES TÉCNICAS Y CONFIGURACIÓN VISUAL ---
    if (variable_struct_exists(global.tool_data, _item_key)) {
        
        // El estado cambia a ACTING y reseteamos el frame
        other.state = STATE.ACTING; 
        other.frame_anim = 0;

        switch (_item_key) {
            case "hoe":
                // Lógica técnica
                if (tilemap_get_at_pixel(_map_id, _gx, _gy) != 72) {
                    tilemap_set_at_pixel(_map_id, 72, _gx, _gy);
                }
                // Configuración Visual
                other.frames_action = 6;
                other.action_sprite_skin = sprite_player_skin_pickaxe_hoe_insects;
                other.action_sprite_hair = sprite_player_hair_pickaxe_hoe_insects;
                other.action_sprite_clothes = sprite_player_clothes_pickaxe_hoe_insects;
                other.action_sprite_eyes = sprite_player_eyes_pickaxe_hoe_insects;
                other.action_sprite_tool = sprite_player_hoe_pickaxe_hoe_insects;
            break;

            case "watering_can":
                if (tilemap_get_at_pixel(_map_id, _gx, _gy) == 72) {
                    tilemap_set_at_pixel(_map_id, 168, _gx, _gy);
                }
                other.frames_action = 8;
                other.action_sprite_skin = sprite_player_skin_watering;
                other.action_sprite_hair = sprite_player_hair_watering;
                other.action_sprite_clothes = sprite_player_clothes_watering;
                other.action_sprite_eyes = sprite_player_eyes_watering;
                other.action_sprite_tool = sprite_player_watering_can_watering;
            break;

            case "axe":
            case "sickle":
                other.frames_action = 6;
                other.action_sprite_skin = sprite_player_skin_axe_sickle;
                other.action_sprite_hair = sprite_player_hair_axe_sickle;
                other.action_sprite_clothes = sprite_player_clothes_axe_sickle;
                other.action_sprite_eyes = sprite_player_eyes_axe_sickle;
                other.action_sprite_tool = (_item_key == "axe") ? sprite_player_axe_axe_sickle : sprite_player_sickle_axe_sickle;
            break;

            case "sword":
                other.frames_action = 10;
                other.action_sprite_skin = sprite_player_skin_sword;
                other.action_sprite_hair = sprite_player_hair_sword;
                other.action_sprite_clothes = sprite_player_clothes_sword;
                other.action_sprite_eyes = sprite_player_eyes_sword;
                other.action_sprite_tool = sprite_player_sword_sword;
            break;

            case "bow":
                other.frames_action = 7;
                other.action_sprite_skin = sprite_player_skin_archer;
                other.action_sprite_hair = sprite_player_hair_archer;
                other.action_sprite_clothes = sprite_player_clothes_archer;
                other.action_sprite_eyes = sprite_player_eyes_archer;
                other.action_sprite_tool = sprite_player_bow_archer;
            break;

            case "pickaxe":
            case "bugnet":
                other.frames_action = 6;
                other.action_sprite_skin = sprite_player_skin_pickaxe_hoe_insects;
                other.action_sprite_hair = sprite_player_hair_pickaxe_hoe_insects;
                other.action_sprite_clothes = sprite_player_clothes_pickaxe_hoe_insects;
                other.action_sprite_eyes = sprite_player_eyes_pickaxe_hoe_insects;
                other.action_sprite_tool = (_item_key == "pickaxe") ? sprite_player_pickaxe_pickaxe_hoe_insects : sprite_player_bugnet_pickaxe_hoe_insects;
            break;
            
            case "shovel":
                other.frames_action = 6;
                other.action_sprite_skin = sprite_player_skin_shovel;
                other.action_sprite_hair = sprite_player_hair_shovel;
                other.action_sprite_clothes = sprite_player_clothes_shovel;
                other.action_sprite_eyes = sprite_player_eyes_shovel;
                other.action_sprite_tool = sprite_player_shovel_shovel; 
            break;
        }
    }

  // --- B. ACCIONES DE SEMILLAS ---
else if (variable_struct_exists(global.seed_data, _item_key)) {
    var _tile_x = floor(_gx / 16) * 16;
    var _tile_y = floor(_gy / 16) * 16;
    
    // 1. Chequeo de suelo (Arado o Regado)
    var _current_tile = tilemap_get_at_pixel(_map_id, _tile_x + 8, _tile_y + 8);

    if (_current_tile == 72 || _current_tile == 168) {
        
        // 2. VALIDACIÓN FALTANTE: ¿Ya hay algo sembrado aquí?
        // Buscamos cualquier instancia de obj_crop en el centro de este tile
        var _is_occupied = instance_position(_tile_x + 8, _tile_y + 8, obj_crop);
        
        if (!_is_occupied) {
            
            // Si el suelo es apto Y NO está ocupado, procedemos a sembrar
            _target_x = _tile_x; 
            _target_y = _tile_y; 
            
            // ... (dentro del if (!_is_occupied))
            
            var _seed_info = global.seed_data[$ _item_key];
            var _base_name = _seed_info.crop_base_name;
            
            var _new_crop = instance_create_layer(_target_x, _target_y, "Instances_Crops", obj_crop);
            with(_new_crop) {
            var _asset_name = "sprite_crop_" + _base_name;
            sprite_index = asset_get_index(_asset_name);
            
            if (sprite_index == -1) {
                show_debug_message("!!! ERROR: No se encontró el sprite: " + _asset_name);
            } else {
                show_debug_message("Sprite asignado correctamente: " + _asset_name);
            }
                            
                            
            
            // Asignación directa desde la base de datos
            days_to_grow = _seed_info.growth_time;
            max_stages = _seed_info.growth_time; 
            
            // Lógica para Pumpkin y Grapes
            if (_base_name == "pumpkin" || _base_name == "grapes") {
                skip_blank_frame = true;
            }
            
            image_index = 0;
            image_speed = 0;
        }
            
            // --- DEBUG COMPLETO EN CONSOLA ---
            var _debug_msg = ">>> [SIEMBRA EXITOSA] <<<\n" +
                             "Item: " + _item_key + " (Base: " + _base_name + ")\n" +
                             "Posición: (" + string(_tile_x) + ", " + string(_tile_y) + ")\n" +
                             "Días para crecer: " + string(_seed_info.growth_time) + "\n" +
                             "Etapas de crecimiento: " + string(_seed_info.growth_time) + "\n" +
                             "Estado inicial: " + (_new_crop.is_watered ? "Regado" : "Seco") + "\n" +
                             "--------------------------";
            
            show_debug_message(_debug_msg);
            
            // inventory_remove_item(_item_key, 1);
        } else {
            // Opcional: Feedback de que ya hay algo ahí
            show_debug_message("No puedes sembrar aquí, ya hay un cultivo.");
        }
    }
}
}