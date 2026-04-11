// --- EVENTO DRAW DEL OBJ_CONTROLLER ---

// 1. Cálculos de posición de rejilla (Grid)
var _tile_size = 16;
var _gx = floor(mouse_x / _tile_size) * _tile_size;
var _gy = floor(mouse_y / _tile_size) * _tile_size;

// 2. Dibujo del Cursor Fantasma (Siempre visible para orientar al jugador)
draw_set_alpha(0.15);
draw_rectangle_color(_gx, _gy, _gx + 15, _gy + 15, c_white, c_white, c_white, c_white, true);
draw_set_alpha(1.0);

// 3. Variables de control
var _show_selector = false;
var _selected_item = -1;

// 4. Lógica de filtrado: ¿Qué tenemos en la mano?
if (instance_exists(obj_inventory)) {
    _selected_item = obj_inventory.inventory_array[obj_inventory.selected_slot];
    
    // Verificamos si el slot no está vacío (asumiendo que -1 o "" es vacío)
    if (_selected_item != -1 && _selected_item != "") {
        var _is_tool = variable_struct_exists(global.tool_data, _selected_item);
        var _is_seed = variable_struct_exists(global.seed_data, _selected_item);
        
        // Mostrar selector si es Semilla o Herramienta de tierra específica
        if (_is_seed) {
            _show_selector = true;
        } else if (_is_tool) {
            // Lista blanca de herramientas que usan rejilla
            if (_selected_item == "hoe" || _selected_item == "watering_can" || _selected_item == "shovel") {
                _show_selector = true;
            }
        }
    }
}

// 5. Dibujo del Selector de Rango (Solo si es herramienta/semilla válida y el jugador existe)
if (_show_selector && instance_exists(obj_player)) {
    var _dist_max = 32; 
    var _tile_center_x = _gx + 8;
    var _tile_center_y = _gy + 8;
    
    // Usamos el centro del bbox para mayor precisión en la distancia
    var _player_center_x = (obj_player.bbox_left + obj_player.bbox_right) / 2;
    var _player_center_y = (obj_player.bbox_top + obj_player.bbox_bottom) / 2;

    var _actual_dist = point_distance(_player_center_x, _player_center_y, _tile_center_x, _tile_center_y);
    
    // Verde si está en rango, Rojo si está lejos
    var _color = (_actual_dist <= _dist_max) ? c_green : c_red;

    // Relleno suave
    draw_set_alpha(0.3);
    draw_rectangle_color(_gx, _gy, _gx + 15, _gy + 15, _color, _color, _color, _color, false);
    
    // Borde más marcado
    draw_set_alpha(0.8);
    draw_rectangle_color(_gx, _gy, _gx + 15, _gy + 15, _color, _color, _color, _color, true);
    
    draw_set_alpha(1.0);
}