var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

hovered_item_data = undefined;
hovered_item_slot_data = undefined;

// --- ESTILO VISUAL ---
var _c_base   = c_dkgray;
var _c_border = c_silver;
var _c_sel    = c_white;
var _alpha    = 0.6;
var _rad      = 8 * gui_scale;

// === 1. FONDO OSCURO (Si la mochila o el shipping estan abiertos) ===
if (show_backpack || show_shipping) {
    draw_set_alpha(0.7);
    draw_rectangle_color(0, 0, display_get_gui_width(), display_get_gui_height(), c_black, c_black, c_black, c_black, false);
    draw_set_alpha(1.0);
}

// === 2. BARRA RAPIDA (HOTBAR) ===
var _icon_scale = gui_scale * 1.8; 
var _off        = 7.2 * _icon_scale; 

for (var i = 0; i < total_slots; i++) {
    var _cx = menu_x_start + (i * (slot_size + spacing));
    var _cy = menu_y_start;
    
    var _hover = (_mx >= _cx && _mx <= _cx + slot_size && _my >= _cy && _my <= _cy + slot_size);
    if (_hover) {
        var _s_data = inventory_array[i];
        if (is_struct(_s_data)) {
            hovered_item_slot_data = _s_data;
            hovered_item_data = scr_get_item_data(_s_data.key);
        }
    }
    var _current_bg_col = (i == selected_slot || _hover) ? c_gray : _c_base;
    var _col_border     = (i == selected_slot || _hover) ? c_white : _c_border;
    var _current_alpha  = (i == selected_slot || _hover) ? 0.9 : _alpha;

    draw_set_alpha(_current_alpha);
    draw_roundrect_color_ext(_cx, _cy, _cx + slot_size, _cy + slot_size, _rad, _rad, _current_bg_col, _current_bg_col, false);
    draw_set_alpha(1.0);
    draw_roundrect_color_ext(_cx, _cy, _cx + slot_size, _cy + slot_size, _rad, _rad, _col_border, _col_border, true);
    
    // --- LOGICA DE STRUCT ---
    var _slot_data = inventory_array[i];
    if (is_struct(_slot_data)) {
        var _key = _slot_data.key;
        var _qty = _slot_data.quantity;
        
        var _data = scr_get_item_data(_key);
        var _is_t = variable_struct_exists(global.tool_data, _key);

        if (_data != undefined) {
            var _f = variable_struct_exists(_data, "row") ? (_data.row * 3) + _data.subimg : _data.subimg;
            
            // Si es herramienta (y no es espada/arco), aplicar offset de calidad
            if (_is_t && _key != "sword" && _key != "bow" && variable_struct_exists(_slot_data, "quality")) {
                _f += _slot_data.quality;
            }

            if (_is_t && i == selected_slot && _data.sprite == sprite_tools) _f += 9;
            var _cc = slot_size / 2;
            
            // Ajuste para centrar el icono
            var _draw_off_x = _off;
            
            draw_sprite_ext(_data.sprite, _f, _cx + _cc - _draw_off_x, _cy + _cc - _off, _icon_scale, _icon_scale, 0, c_white, 1);
            
            // DIBUJAR CANTIDAD
            if (_qty > 1) {
                draw_set_halign(fa_right);
                draw_set_valign(fa_bottom);
                draw_set_color(c_white);
                draw_text_transformed(_cx + slot_size - 4, _cy + slot_size - 2, string(_qty), 1.2, 1.2, 0);
            }
        }
    }
}

// === CALCULOS DE POSICION PARA GRIDS ===
var _cols = 8;
var _grid_slot_size = slot_size; // Usar el mismo que la Hotbar
var _grid_sp = spacing;         // Usar el mismo que la Hotbar
var _grid_w = (_cols * _grid_slot_size) + ((_cols - 1) * _grid_sp);

var _gap = 40 * gui_scale; // Espacio entre mochila y shipping bin
var _total_w = _grid_w;
if (show_shipping || show_chest) _total_w = (_grid_w * 2) + _gap;

var _base_x = (display_get_gui_width() / 2) - (_total_w / 2);
var _base_y = (display_get_gui_height() * 0.45);

// === 3. CUADRICULA DE LA MOCHILA ===
if (show_backpack) {
    var _rows = ceil(max_backpack_slots / _cols);
    var _bh = (_rows * _grid_slot_size) + ((_rows - 1) * _grid_sp);
    var _bx = _base_x;
    var _by = _base_y - (_bh / 2);

    // Titulo Mochila
    draw_set_halign(fa_center);
    var _title_y = _by - 40;
    draw_text_transformed(_bx + _grid_w/2, _title_y, "MOCHILA", 1.5, 1.5, 0);

    for (var i = 0; i < max_backpack_slots; i++) {
        var _sx = _bx + (i % _cols * (_grid_slot_size + _grid_sp));
        var _sy = _by + (i div _cols * (_grid_slot_size + _grid_sp));
        var _b_hover = (_mx >= _sx && _mx <= _sx + _grid_slot_size && _my >= _sy && _my <= _sy + _grid_slot_size);
        if (_b_hover) {
            var _s_data = backpack_array[i];
            if (is_struct(_s_data)) {
                hovered_item_slot_data = _s_data;
                hovered_item_data = scr_get_item_data(_s_data.key);
            }
        }
        var _bg_col = (_b_hover) ? c_gray : _c_base;
        var _bd_col = (_b_hover) ? c_white : _c_border;
        var _bp_alpha = (_b_hover) ? 0.9 : _alpha;
    
        draw_set_alpha(_bp_alpha);
        draw_roundrect_color_ext(_sx, _sy, _sx + _grid_slot_size, _sy + _grid_slot_size, _rad, _rad, _bg_col, _bg_col, false);
        draw_set_alpha(1.0);
        draw_roundrect_color_ext(_sx, _sy, _sx + _grid_slot_size, _sy + _grid_slot_size, _rad, _rad, _bd_col, _bd_col, true);
        
        var _b_slot = backpack_array[i];
        if (is_struct(_b_slot)) {
            var _b_key = _b_slot.key;
            var _b_qty = _b_slot.quantity;
            var _b_data = scr_get_item_data(_b_key);

            if (_b_data != undefined) {
                var _f = variable_struct_exists(_b_data, "row") ? (_b_data.row * 3) + _b_data.subimg : _b_data.subimg;

                // Offset de calidad para herramientas
                var _is_tool_b = variable_struct_exists(global.tool_data, _b_key);
                if (_is_tool_b && _b_key != "sword" && _b_key != "bow" && variable_struct_exists(_b_slot, "quality")) {
                    _f += _b_slot.quality;
                }

                var _cc = _grid_slot_size / 2;
                
                var _draw_off_x = _off;
                
                draw_sprite_ext(_b_data.sprite, _f, _sx + _cc - _draw_off_x, _sy + _cc - _off, _icon_scale, _icon_scale, 0, c_white, 1);
                
                if (_b_qty > 1) {
                    draw_set_halign(fa_right);
                    draw_set_valign(fa_bottom);
                    draw_set_color(c_white);
                    draw_text_transformed(_sx + _grid_slot_size - 4, _sy + _grid_slot_size - 2, string(_b_qty), 1.1, 1.1, 0);
                }
            }
        }
    }
}

// === 3.5 CUADRICULA DEL SHIPPING BIN ===
if (show_shipping) {
    var _s_rows = 8;
    var _sh = (_s_rows * _grid_slot_size) + ((_s_rows - 1) * _grid_sp);
    var _sx_base = _base_x + _grid_w + _gap;
    var _sy_base = _base_y - (_sh / 2);

    // Titulo Contenedor de Envios
    draw_set_halign(fa_center);
    var _title_y = _sy_base - 40;
    draw_text_transformed(_sx_base + _grid_w/2, _title_y, "CONTENEDOR DE ENVIOS", 1.5, 1.5, 0);

    var _len = array_length(shipping_array);
    for (var i = 0; i < _len; i++) {
        var _sx = _sx_base + (i % _cols * (_grid_slot_size + _grid_sp));
        var _sy = _sy_base + (i div _cols * (_grid_slot_size + _grid_sp));
        
        var _s_hover = (_mx >= _sx && _mx <= _sx + _grid_slot_size && _my >= _sy && _my <= _sy + _grid_slot_size);
        if (_s_hover) {
            var _s_data = shipping_array[i];
            if (is_struct(_s_data)) {
                hovered_item_slot_data = _s_data;
                hovered_item_data = scr_get_item_data(_s_data.key);
            }
        }
        var _bg_col = (_s_hover) ? c_gray : _c_base;
        var _bd_col = (_s_hover) ? c_white : _c_border;
        var _s_alpha = (_s_hover) ? 0.9 : _alpha;

        draw_set_alpha(_s_alpha);
        draw_roundrect_color_ext(_sx, _sy, _sx + _grid_slot_size, _sy + _grid_slot_size, _rad, _rad, _bg_col, _bg_col, false);
        draw_set_alpha(1.0);
        draw_roundrect_color_ext(_sx, _sy, _sx + _grid_slot_size, _sy + _grid_slot_size, _rad, _rad, _bd_col, _bd_col, true);

        var _s_slot = shipping_array[i];
        if (is_struct(_s_slot)) {
            var _s_key = _s_slot.key;
            var _s_qty = _s_slot.quantity;
            var _s_data = scr_get_item_data(_s_key);

            if (_s_data != undefined) {
                var _f    = variable_struct_exists(_s_data, "row") ? (_s_data.row * 3) + _s_data.subimg : _s_data.subimg;
                
                // Offset de calidad
                var _is_tool_s = variable_struct_exists(global.tool_data, _s_key);
                if (_is_tool_s && _s_key != "sword" && _s_key != "bow" && variable_struct_exists(_s_slot, "quality")) {
                    _f += _s_slot.quality;
                }

                var _cc = _grid_slot_size / 2;

                var _draw_off_x = _off;

                draw_sprite_ext(_s_data.sprite, _f, _sx + _cc - _draw_off_x, _sy + _cc - _off, _icon_scale, _icon_scale, 0, c_white, 1);

                
                if (_s_qty > 1) {
                    draw_set_halign(fa_right);
                    draw_set_valign(fa_bottom);
                    draw_set_color(c_white);
                    draw_text_transformed(_sx + _grid_slot_size - 4, _sy + _grid_slot_size - 2, string(_s_qty), 1.1, 1.1, 0);
                }
            }
        }
    }
}

// === 3.6 CUADRICULA DEL COFRE ===
if (show_chest && instance_exists(current_chest_id)) {
    var _c_rows = 8;
    var _ch = (_c_rows * _grid_slot_size) + ((_c_rows - 1) * _grid_sp);
    var _cx_base = _base_x + _grid_w + _gap;
    var _cy_base = _base_y - (_ch / 2);

    // Titulo Cofre
    draw_set_halign(fa_center);
    var _c_title_y = _cy_base - 40;
    draw_text_transformed(_cx_base + _grid_w/2, _c_title_y, "COFRE", 1.5, 1.5, 0);

    for (var i = 0; i < 64; i++) {
        var _sx = _cx_base + (i % _cols * (_grid_slot_size + _grid_sp));
        var _sy = _cy_base + (i div _cols * (_grid_slot_size + _grid_sp));
        
        var _c_hover = (_mx >= _sx && _mx <= _sx + _grid_slot_size && _my >= _sy && _my <= _sy + _grid_slot_size);
        if (_c_hover) {
            var _s_data = current_chest_id.storage_array[i];
            if (is_struct(_s_data)) {
                hovered_item_slot_data = _s_data;
                hovered_item_data = scr_get_item_data(_s_data.key);
            }
        }
        var _bg_col = (_c_hover) ? c_gray : _c_base;
        var _bd_col = (_c_hover) ? c_white : _c_border;
        var _c_alpha = (_c_hover) ? 0.9 : _alpha;

        draw_set_alpha(_c_alpha);
        draw_roundrect_color_ext(_sx, _sy, _sx + _grid_slot_size, _sy + _grid_slot_size, _rad, _rad, _bg_col, _bg_col, false);
        draw_set_alpha(1.0);
        draw_roundrect_color_ext(_sx, _sy, _sx + _grid_slot_size, _sy + _grid_slot_size, _rad, _rad, _bd_col, _bd_col, true);

        var _s_slot = current_chest_id.storage_array[i];
        if (is_struct(_s_slot)) {
            var _s_key = _s_slot.key;
            var _s_qty = _s_slot.quantity;
            var _s_data = scr_get_item_data(_s_key);

            if (_s_data != undefined) {
                var _f    = variable_struct_exists(_s_data, "row") ? (_s_data.row * 3) + _s_data.subimg : _s_data.subimg;
                
                // Offset de calidad
                var _is_tool_s = variable_struct_exists(global.tool_data, _s_key);
                if (_is_tool_s && _s_key != "sword" && _s_key != "bow" && variable_struct_exists(_s_slot, "quality")) {
                    _f += _s_slot.quality;
                }

                var _cc = _grid_slot_size / 2;

                var _draw_off_x = _off;

                draw_sprite_ext(_s_data.sprite, _f, _sx + _cc - _draw_off_x, _sy + _cc - _off, _icon_scale, _icon_scale, 0, c_white, 1);

                
                if (_s_qty > 1) {
                    draw_set_halign(fa_right);
                    draw_set_valign(fa_bottom);
                    draw_set_color(c_white);
                    draw_text_transformed(_sx + _grid_slot_size - 4, _sy + _grid_slot_size - 2, string(_s_qty), 1.1, 1.1, 0);
                }
            }
        }
    }
}

// === 4. ITEM EN MANO ===
if (is_struct(held_item)) {
    var _h_key = held_item.key;
    var _h_qty = held_item.quantity;
    
    var _h_data = scr_get_item_data(_h_key);

    if (_h_data != undefined) {
        var _h_scl = gui_scale * 1.8;
        var _h_off = 7.2 * _h_scl;
        var _f     = variable_struct_exists(_h_data, "row") ? (_h_data.row * 3) + _h_data.subimg : _h_data.subimg;
        
        // Offset de calidad
        var _is_tool_h = variable_struct_exists(global.tool_data, _h_key);
        if (_is_tool_h && _h_key != "sword" && _h_key != "bow" && variable_struct_exists(held_item, "quality")) {
            _f += held_item.quality;
        }

        var _draw_h_off_x = _h_off;
        
        draw_sprite_ext(_h_data.sprite, _f, _mx - _draw_h_off_x, _my - _h_off, _h_scl, _h_scl, 0, c_white, 0.8);
        
        // DIBUJAR CANTIDAD EN MANO
        if (_h_qty > 1) {
            draw_set_halign(fa_right);
            draw_set_valign(fa_bottom);
            draw_set_color(c_white);
            draw_text_transformed(_mx + 15, _my + 15, string(_h_qty), 1.1, 1.1, 0);
        }
    }
}

// === 5. NOTIFICACIONES (Copiadas del Controller para consistencia) ===
if (instance_exists(obj_controller)) {
    var _notif_list = obj_controller.notifications;
    var _yy = display_get_gui_height() * 0.7;
    var _xx = 20;

    draw_set_font(fnt_pixel_operator);
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
// === 6. DIBUJAR TOOLTIP ===
if (is_struct(hovered_item_data) && !is_struct(held_item)) {
    var _name = hovered_item_data.name;
    var _qty  = hovered_item_slot_data.quantity;
    var _type = (variable_struct_exists(hovered_item_data, "type")) ? hovered_item_data.type : -1;
    
    var _tooltip_text = _name;
    if (_qty > 1) _tooltip_text += "\nCantidad: " + string(_qty);
    
    // Agregar calidad y nivel para herramientas
    if (_type == ITEM_TYPE.TOOL || _type == ITEM_TYPE.WEAPON) {
        if (variable_struct_exists(hovered_item_slot_data, "quality")) {
            var _qual_idx = hovered_item_slot_data.quality;
            if (_qual_idx >= 0 && _qual_idx < array_length(global.quality_names)) {
                _tooltip_text += "\nCalidad: " + global.quality_names[_qual_idx];
            }
        }
        
        var _level = 1;
        if (variable_struct_exists(hovered_item_slot_data, "quality")) {
            _level = hovered_item_slot_data.quality + 1;
        } else if (variable_struct_exists(hovered_item_data, "level")) {
            _level = hovered_item_data.level;
        }
        
        _tooltip_text += "\nNivel: " + string(_level);
    }

    draw_set_font(fnt_pixel_operator);
    var _tw = (string_width(_tooltip_text) + 16) * 1.2;
    var _th = (string_height(_tooltip_text) + 16) * 1.2;
    
    var _tx = _mx + 20;
    var _ty = _my + 20;
    
    // Mantener dentro de la pantalla
    if (_tx + _tw > display_get_gui_width()) _tx = _mx - _tw - 8;
    if (_ty + _th > display_get_gui_height()) _ty = _my - _th - 8;
    
    // Dibujar fondo
    draw_set_alpha(0.9);
    draw_roundrect_color_ext(_tx, _ty, _tx + _tw, _ty + _th, 8, 8, c_dkgray, c_dkgray, false);
    draw_roundrect_color_ext(_tx, _ty, _tx + _tw, _ty + _th, 8, 8, c_silver, c_silver, true);
    draw_set_alpha(1.0);
    
    // Dibujar texto
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_text_transformed(_tx + 8, _ty + 8, _tooltip_text, 1.2, 1.2, 0);
}

