// --- script_player_actions ---
// No pongas nada arriba de esto

function scr_use_item(_item_key, _gx, _gy) {
    
    // 1. Validar que la _item_key sea válida
    if (_item_key == undefined || _item_key == -1) return;

    // Coordenadas auxiliares para centrar objetos
    var _tile_cx = _gx + 8;
    var _tile_cy = _gy + 8;
    
    // Capas de Tiles
    var _lay_id = layer_get_id("Tiles_tilled_watered");
    var _map_id = layer_tilemap_get_id(_lay_id);

    // --- A. ACCIONES DE HERRAMIENTAS ---
    if (variable_struct_exists(global.tool_data, _item_key)) {
        
        switch (_item_key) {
            case "hoe":
                // Si el tile no es tierra arada (ID 72), lo aramos
                if (tilemap_get_at_pixel(_map_id, _gx, _gy) != 72) {
                    tilemap_set_at_pixel(_map_id, 72, _gx, _gy);
                }
            break;

            case "watering_can":
                 // Si el tile tierra arada (ID 72), lo mojamos
                if (tilemap_get_at_pixel(_map_id, _gx, _gy) == 72) {
                    tilemap_set_at_pixel(_map_id, 168, _gx, _gy);
                }
            break;
        }
    }

    // --- B. ACCIONES DE SEMILLAS ---
    else if (variable_struct_exists(global.seed_data, _item_key)) {
        
        // Solo sembrar si hay tierra arada (ID 72)
        if (tilemap_get_at_pixel(_map_id, _gx, _gy) == 72) {
            
            // Si NO hay una planta ya puesta ahí
            if (!position_meeting(_tile_cx, _tile_cy, obj_crop_controller)) {
                var _inst = instance_create_layer(_tile_cx, _tile_cy, "Instances", obj_crop_controller);
                with(_inst) {
                    init_crop(_item_key); 
                }
                
                // Opcional: Quitar una semilla del inventario
                // obj_inventory.inventory_array[obj_inventory.selected_slot] = -1;
            }
        }
    }
}