var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

// --- ESTILO VISUAL ---
var _c_base   = c_dkgray;
var _c_border = c_silver;
var _c_sel    = c_white;
var _alpha    = 0.6;
var _rad      = 8 * gui_scale;

// === 1. FONDO OSCURO (Si la mochila está abierta) ===
if (show_backpack) {
    draw_set_alpha(0.7);
    draw_rectangle_color(0, 0, display_get_gui_width(), display_get_gui_height(), c_black, c_black, c_black, c_black, false);
    draw_set_alpha(1.0);
}

// === 2. BARRA RÁPIDA (HOTBAR) ===
var _icon_scale = gui_scale * 1.8; 
var _off        = 7.2 * _icon_scale; 

for (var i = 0; i < total_slots; i++) {
    var _cx = menu_x_start + (i * (slot_size + spacing));
    var _cy = menu_y_start;
    
    var _hover = (_mx >= _cx && _mx <= _cx + slot_size && _my >= _cy && _my <= _cy + slot_size);
    var _current_bg_col = (i == selected_slot || _hover) ? c_gray : _c_base;
    var _col_border     = (i == selected_slot || _hover) ? c_white : _c_border;
    var _current_alpha  = (i == selected_slot || _hover) ? 0.9 : _alpha;

    draw_set_alpha(_current_alpha);
    draw_roundrect_color_ext(_cx, _cy, _cx + slot_size, _cy + slot_size, _rad, _rad, _current_bg_col, _current_bg_col, false);
    draw_set_alpha(1.0);
    draw_roundrect_color_ext(_cx, _cy, _cx + slot_size, _cy + slot_size, _rad, _rad, _col_border, _col_border, true);
    
    // --- LÓGICA DE STRUCT ---
    var _slot_data = inventory_array[i];
    if (is_struct(_slot_data)) {
        var _key = _slot_data.key;
        var _qty = _slot_data.quantity;
        
        var _data = undefined;
        var _is_t = false;
        if (variable_struct_exists(global.tool_data, _key)) { _data = global.tool_data[$ _key]; _is_t = true; }
        else if (variable_struct_exists(global.seed_data, _key)) { _data = global.seed_data[$ _key]; }
        else if (variable_struct_exists(global.crop_data, _key)) { _data = global.crop_data[$ _key]; }

        if (_data != undefined) {
            var _f = variable_struct_exists(_data, "row") ? (_data.row * 3) + _data.subimg : _data.subimg;
            if (_is_t && i == selected_slot && _data.sprite == sprite_tools) _f += 9;
            var _cc = slot_size / 2;
            draw_sprite_ext(_data.sprite, _f, _cx + _cc - _off, _cy + _cc - _off, _icon_scale, _icon_scale, 0, c_white, 1);
            
            // DIBUJAR CANTIDAD
            if (_qty > 1) {
                draw_set_halign(fa_right);
                draw_set_valign(fa_bottom);
                draw_text_transformed(_cx + slot_size - 4, _cy + slot_size - 2, string(_qty), 1, 1, 0);
            }
        }
    }
}

// === 3. CUADRÍCULA DE LA MOCHILA ===
if (show_backpack) {
    var _cols = 16;
    var _rows = ceil(max_backpack_slots / _cols);
    var _bp_s = 32 * gui_scale; 
    var _sp   = 2;
    var _bw = (_cols * _bp_s) + ((_cols - 1) * _sp);
    var _bh = (_rows * _bp_s) + ((_rows - 1) * _sp);
    var _bx = (display_get_gui_width() / 2) - (_bw / 2);
    var _by = (display_get_gui_height() * 0.45) - (_bh / 2);

    for (var i = 0; i < max_backpack_slots; i++) {
        var _sx = _bx + (i % _cols * (_bp_s + _sp));
        var _sy = _by + (i div _cols * (_bp_s + _sp));
        var _b_hover = (_mx >= _sx && _mx <= _sx + _bp_s && _my >= _sy && _my <= _sy + _bp_s);
        var _bg_col = (_b_hover) ? c_gray : _c_base;
        var _bd_col = (_b_hover) ? c_white : _c_border;
        var _bp_alpha = (_b_hover) ? 0.9 : _alpha;
    
        draw_set_alpha(_bp_alpha);
        draw_roundrect_color_ext(_sx, _sy, _sx + _bp_s, _sy + _bp_s, 6, 6, _bg_col, _bg_col, false);
        draw_set_alpha(1.0);
        draw_roundrect_color_ext(_sx, _sy, _sx + _bp_s, _sy + _bp_s, 6, 6, _bd_col, _bd_col, true);
        
        // --- LÓGICA DE STRUCT ---
        var _b_slot = backpack_array[i];
        if (is_struct(_b_slot)) {
            var _b_key = _b_slot.key;
            var _b_qty = _b_slot.quantity;
            
            var _b_data = undefined;
            if (variable_struct_exists(global.tool_data, _b_key)) _b_data = global.tool_data[$ _b_key];
            else if (variable_struct_exists(global.seed_data, _b_key)) _b_data = global.seed_data[$ _b_key];
            else if (variable_struct_exists(global.crop_data, _b_key)) _b_data = global.crop_data[$ _b_key];

            if (_b_data != undefined) {
                var _iscl = (_bp_s / 32) * 1.6;
                var _ioff = 7.2 * _iscl;
                var _f    = variable_struct_exists(_b_data, "row") ? (_b_data.row * 3) + _b_data.subimg : _b_data.subimg;
                draw_sprite_ext(_b_data.sprite, _f, _sx + (_bp_s/2) - _ioff, _sy + (_bp_s/2) - _ioff, _iscl, _iscl, 0, c_white, 1);
                
                // DIBUJAR CANTIDAD
                if (_b_qty > 1) {
                    draw_set_halign(fa_right);
                    draw_set_valign(fa_bottom);
                    draw_text_transformed(_sx + _bp_s - 2, _sy + _bp_s - 2, string(_b_qty), 0.8, 0.8, 0);
                }
            }
        }
    }
}

// === 4. ÍTEM EN MANO ===
if (is_struct(held_item)) {
    var _h_key = held_item.key;
    var _h_qty = held_item.quantity;
    
    var _h_data = undefined;
    if (variable_struct_exists(global.tool_data, _h_key)) _h_data = global.tool_data[$ _h_key];
    else if (variable_struct_exists(global.seed_data, _h_key)) _h_data = global.seed_data[$ _h_key];
    else if (variable_struct_exists(global.crop_data, _h_key)) _h_data = global.crop_data[$ _h_key];

    if (_h_data != undefined) {
        var _h_scl = gui_scale * 1.8;
        var _h_off = 7.2 * _h_scl;
        var _f     = variable_struct_exists(_h_data, "row") ? (_h_data.row * 3) + _h_data.subimg : _h_data.subimg;
        draw_sprite_ext(_h_data.sprite, _f, _mx - _h_off, _my - _h_off, _h_scl, _h_scl, 0, c_white, 0.8);
        
        // DIBUJAR CANTIDAD EN MANO
        if (_h_qty > 1) {
            draw_set_halign(fa_right);
            draw_text(_mx + 10, _my + 10, string(_h_qty));
        }
    }
}

// === 5. NOTIFICACIONES (Copiadas del Controller para consistencia) ===
if (instance_exists(obj_controller)) {
    var _notif_list = obj_controller.notifications;
    var _yy = display_get_gui_height() * 0.7;
    var _xx = 20;

    draw_set_font(-1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_bottom);

    for (var i = 0; i < ds_list_size(_notif_list); i++) {
        var _n = _notif_list[| i];
        draw_set_alpha(_n.alpha * 0.5);
        draw_text_color(_xx + 1, _yy + 1, _n.text, c_black, c_black, c_black, c_black, _n.alpha * 0.5);
        draw_set_alpha(_n.alpha);
        draw_text_color(_xx, _yy, _n.text, c_white, c_white, c_white, c_white, _n.alpha);
        _yy -= 20;
    }
    draw_set_alpha(1.0);
}