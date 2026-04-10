
// --- EVENTO DRAW DEL OBJ_CONTROLLER ---

var _tile_size = 16;
var _gx = floor(mouse_x / _tile_size) * _tile_size;
var _gy = floor(mouse_y / _tile_size) * _tile_size;

// --- MEJORA: CURSOR FANTASMA (Siempre visible) ---
draw_set_alpha(0.15);
draw_rectangle_color(_gx, _gy, _gx + 15, _gy + 15, c_white, c_white, c_white, c_white, true);
draw_set_alpha(1.0);

// --- LÓGICA DE INTERACCIÓN ---
var _show_selector = false;
var _selected_item = -1;

// 1. Verificación de Inventario usando las nuevas variables
if (instance_exists(obj_inventory)) {
    _selected_item = obj_inventory.inventory_array[obj_inventory.selected_slot];
    
    // El selector se activa si es la azada O si es cualquier semilla
    var _is_hoe   = (_selected_item == "hoe");
    var _is_seed  = variable_struct_exists(global.seed_data, _selected_item);
    
    if (_is_hoe || _is_seed) {
        _show_selector = true;
    }
}

// 2. Dibujo del selector (Verde/Rojo)
if (_show_selector && instance_exists(obj_player)) {
    var _dist_max = 32; 

    // Centros para el cálculo de distancia
    var _tile_center_x = _gx + 8;
    var _tile_center_y = _gy + 8;
    
    var _player_center_x = (obj_player.bbox_left + obj_player.bbox_right) / 2;
    var _player_center_y = (obj_player.bbox_top + obj_player.bbox_bottom) / 2;

    var _actual_dist = point_distance(_player_center_x, _player_center_y, _tile_center_x, _tile_center_y);

    // Color dinámico según distancia
    var _color = (_actual_dist <= _dist_max) ? c_green : c_red;

    // Dibujo del rectángulo relleno (suave)
    draw_set_alpha(0.3);
    draw_rectangle_color(_gx, _gy, _gx + 15, _gy + 15, _color, _color, _color, _color, false);
    
    // Dibujo del borde (más marcado)
    draw_set_alpha(0.8);
    draw_rectangle_color(_gx, _gy, _gx + 15, _gy + 15, _color, _color, _color, _color, true);
    
    // --- RESETEAR ESTADO DE DIBUJO ---
    draw_set_alpha(1.0);
}