// --- 1. SELECCIÓN DE SLOT (TECLADO) ---
for (var i = 0; i < 9; i++) {
    if (keyboard_check_pressed(ord(string(i + 1)))) selected_slot = i;
}
if (keyboard_check_pressed(ord("0"))) selected_slot = 9;

// --- 2. GESTIÓN DE APERTURA/CIERRE ---
var _press_open  = keyboard_check_pressed(ord("I"));
var _press_close = keyboard_check_pressed(vk_escape);

if (_press_open || (show_backpack && _press_close)) {
    show_backpack = !show_backpack;
    
    // Al cerrar, si tenemos algo en la mano, lo devolvemos al inventario
    if (!show_backpack && held_item != -1) {
        add_item(held_item);
        held_item = -1;
    }
}

// --- 3. LÓGICA DE CLICS (Mochila Abierta o Cerrada) ---
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

if (mouse_check_button_pressed(mb_left)) {
    
    // A. CLIC EN LA BARRA RÁPIDA (Siempre detectable)
    if (_my >= menu_y_start && _my <= menu_y_start + slot_size) {
        for (var i = 0; i < total_slots; i++) {
            var _x1 = menu_x_start + (i * (slot_size + spacing));
            if (_mx >= _x1 && _mx <= _x1 + slot_size) {
                if (show_backpack) {
                    scr_inventory_swap(inventory_array, i); // Intercambiar si está abierto
                } else {
                    selected_slot = i; // Solo seleccionar si está cerrado
                }
                break;
            }
        }
    }
    
    // B. CLIC EN LA MOCHILA (Solo si está abierta)
    if (show_backpack) {
        var _cols = 16;
        var _bp_s = 32 * gui_scale; 
        var _sp   = 2;
        var _bw   = (_cols * _bp_s) + ((_cols - 1) * _sp);
        var _rows = ceil(max_backpack_slots / _cols);
        var _bh   = (_rows * _bp_s) + ((_rows - 1) * _sp);
        var _bx   = (display_get_gui_width() / 2) - (_bw / 2);
        var _by   = (display_get_gui_height() * 0.45) - (_bh / 2);

        if (point_in_rectangle(_mx, _my, _bx, _by, _bx + _bw, _by + _bh)) {
            for (var i = 0; i < max_backpack_slots; i++) {
                var _sx = _bx + (i % _cols * (_bp_s + _sp));
                var _sy = _by + (i div _cols * (_bp_s + _sp));

                if (point_in_rectangle(_mx, _my, _sx, _sy, _sx + _bp_s, _sy + _bp_s)) {
                    scr_inventory_swap(backpack_array, i);
                    break; 
                }
            }
        }
    }
}

// --- 4. RUEDA DEL RATÓN (Solo si la mochila está cerrada) ---
if (!show_backpack) {
    if (mouse_wheel_up())   selected_slot = (selected_slot - 1 + total_slots) % total_slots;
    if (mouse_wheel_down()) selected_slot = (selected_slot + 1) % total_slots;
}