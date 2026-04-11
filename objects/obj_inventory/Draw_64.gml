var _bg_scale = gui_scale;
var _icon_scale = gui_scale * 1.5; 
var _offset = 7.2 * _icon_scale; 

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

for (var i = 0; i < total_slots; i++) {
    var _cx = menu_x_start + (i * (slot_size + spacing));
    var _cy = menu_y_start;

    // A. Fondo del Slot
    var _bg_frame = (i == selected_slot) ? 1 : 0;
    draw_sprite_ext(sprite_inventory_bar, _bg_frame, _cx, _cy, _bg_scale, _bg_scale, 0, c_white, 1);
    
    // B. Lógica de dibujado de Ítem
    var _item_key = inventory_array[i];
    
    if (_item_key != -1) {
        var _data = undefined;
        var _is_tool = false;

        // --- BÚSQUEDA TRIPLE ---
        if (variable_struct_exists(global.tool_data, _item_key)) {
            _data = global.tool_data[$ _item_key];
            _is_tool = true;
        } else if (variable_struct_exists(global.seed_data, _item_key)) {
            _data = global.seed_data[$ _item_key];
        } else if (variable_struct_exists(global.crop_data, _item_key)) {
            _data = global.crop_data[$ _item_key];
        }

        if (_data != undefined) {
            var _center = slot_size / 2;
            var _draw_x = _cx + _center;
            var _draw_y = _cy + _center;
            
            // Lógica de Frame:
            // Si tiene 'row', calculamos el frame basado en la fila del sprite (crops)
            // Si no, usamos 'subimg' directamente (tools)
            var _frame = variable_struct_exists(_data, "row") ? (_data.row * 3) + _data.subimg : _data.subimg;
            
            // Efecto visual para herramientas seleccionadas
            if (_is_tool && i == selected_slot) {
                // Solo aplicar si el sprite es el de herramientas (evita errores con la red de bichos)
                if (_data.sprite == sprite_tools) _frame += 9;
            }

            draw_sprite_ext(_data.sprite, _frame, _draw_x - _offset, _draw_y - _offset, _icon_scale, _icon_scale, 0, c_white, 1);
        }
    }
    
    // C. Hover
    if (_mx >= _cx && _mx <= _cx + slot_size && _my >= _cy && _my <= _cy + slot_size) {
        if (i != selected_slot) {
            draw_set_alpha(0.2);
            draw_rectangle(_cx, _cy, _cx + slot_size, _cy + slot_size, false);
            draw_set_alpha(1.0);
        }
    }
}