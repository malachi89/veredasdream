// --- EVENTO STEP DE OBJ_INVENTORY ---

// 1. Selección por Teclado
for (var i = 0; i < 9; i++) {
    // Usamos selected_slot en lugar de selected_tool_index
    if (keyboard_check_pressed(ord(string(i + 1)))) selected_slot = i;
}
if (keyboard_check_pressed(ord("0"))) selected_slot = 9;

// 2. Selección por Rueda
// Usamos total_slots y selected_slot
if (mouse_wheel_up())   selected_slot = (selected_slot - 1 + total_slots) % total_slots;
if (mouse_wheel_down()) selected_slot = (selected_slot + 1) % total_slots;

// 3. Selección por Clic
if (mouse_check_button_pressed(mb_left)) {
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);
    
    // Verificamos si el clic está en la franja horizontal del menú
    if (_my >= menu_y_start && _my <= menu_y_start + slot_size) {
        for (var i = 0; i < total_slots; i++) {
            var _x1 = menu_x_start + (i * (slot_size + spacing));
            var _x2 = _x1 + slot_size;
            
            if (_mx >= _x1 && _mx <= _x2) {
                selected_slot = i;
                break; 
            }
        }
    }
}