// 1. Dibujo del Cursor Fantasma (Siempre visible para orientar al jugador)
draw_set_alpha(0.15);
draw_rectangle_color(gx, gy, gx + 15, gy + 15, c_white, c_white, c_white, c_white, true);
draw_set_alpha(1.0);

// 2. Dibujo del Selector de Rango (Solo si es herramienta/semilla válida)
if (show_selector) {
    // Relleno suave
    draw_set_alpha(0.3);
    draw_rectangle_color(gx, gy, gx + 15, gy + 15, selector_color, selector_color, selector_color, selector_color, false);

    // Borde más marcado
    draw_set_alpha(0.8);
    draw_rectangle_color(gx, gy, gx + 15, gy + 15, selector_color, selector_color, selector_color, selector_color, true);

    draw_set_alpha(1.0);

    // --- PREVIEW DE OBJETOS COLOCABLES (PLACEABLE) ---
    if (instance_exists(obj_inventory)) {
        var _slot = obj_inventory.inventory_array[obj_inventory.selected_slot];
        var _key = is_struct(_slot) ? _slot.key : "";
        if (_key != "" && variable_struct_exists(global.placeable_data, _key)) {
            var _data = global.placeable_data[$ _key];
            var _off_x = variable_struct_exists(_data, "place_offset_x") ? _data.place_offset_x : 0;
            var _off_y = variable_struct_exists(_data, "place_offset_y") ? _data.place_offset_y : 0;

            draw_set_alpha(0.5);

            draw_sprite(_data.sprite, _data.subimg, gx + _off_x, gy + _off_y);
            draw_set_alpha(1.0);
        }
    }
}

// Fade effect for day start
if (fade_alpha > 0) {
    draw_set_alpha(fade_alpha);
    draw_rectangle_color(0, 0, display_get_gui_width(), display_get_gui_height(), c_black, c_black, c_black, c_black, false);
    draw_set_alpha(1.0); // Reset alpha
}