var _p = local_player;
if (!instance_exists(_p)) exit;
if (instance_exists(obj_controller) && obj_controller.pause_menu_open) exit;

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

_p.hovered_item_data = undefined;
_p.hovered_item_slot_data = undefined;

// --- ESTILO VISUAL ---
var _c_base   = c_dkgray;
var _c_border = c_silver;
var _c_sel    = c_white;
var _alpha    = 0.6;
var _rad      = 8 * gui_scale;

// === 1. FONDO OSCURO ===
if (_p.show_backpack || _p.show_shipping) {
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
        var _s_data = _p.inventory_array[i];
        if (is_struct(_s_data)) {
            _p.hovered_item_slot_data = _s_data;
            _p.hovered_item_data = scr_get_item_data(_s_data.key);
        }
    }
    var _current_bg_col = (i == _p.selected_slot || _hover) ? c_gray : _c_base;
    var _col_border     = (i == _p.selected_slot || _hover) ? c_white : _c_border;
    var _current_alpha  = (i == _p.selected_slot || _hover) ? 0.9 : _alpha;

    draw_set_alpha(_current_alpha);
    draw_roundrect_color_ext(_cx, _cy, _cx + slot_size, _cy + slot_size, _rad, _rad, _current_bg_col, _current_bg_col, false);
    draw_set_alpha(1.0);
    draw_roundrect_color_ext(_cx, _cy, _cx + slot_size, _cy + slot_size, _rad, _rad, _col_border, _col_border, true);

    var _slot_data = _p.inventory_array[i];
    if (is_struct(_slot_data)) {
        var _key = _slot_data.key;
        var _qty = _slot_data.quantity;
        var _data = scr_get_item_data(_key);
        var _is_t = variable_struct_exists(global.tool_data, _key);

        if (_data != undefined) {
            var _f = variable_struct_exists(_data, "row") ? (_data.row * 3) + _data.subimg : _data.subimg;
            if (_is_t && _key != "sword" && _key != "bow" && variable_struct_exists(_slot_data, "quality")) {
                _f += _slot_data.quality;
            }
            if (_is_t && i == _p.selected_slot && _data.sprite == sprite_tools) _f += 9;
            var _cc = slot_size / 2;
            var _sz    = 16 / max(sprite_get_width(_data.sprite), sprite_get_height(_data.sprite));
            var _cox   = (sprite_get_width(_data.sprite)  / 2 - sprite_get_xoffset(_data.sprite)) * _sz * _icon_scale;
            var _coy   = (sprite_get_height(_data.sprite) / 2 - sprite_get_yoffset(_data.sprite)) * _sz * _icon_scale;
            draw_sprite_ext(_data.sprite, _f, _cx + _cc - _cox, _cy + _cc - _coy, _icon_scale * _sz, _icon_scale * _sz, 0, c_white, 1);
            if (variable_struct_exists(_slot_data, "weight") && _slot_data.weight > 0) {
                draw_set_halign(fa_right);
                draw_set_valign(fa_bottom);
                draw_set_color(c_white);
                draw_text_transformed(_cx + slot_size - 4, _cy + slot_size - 2, scr_format_weight(_slot_data.weight), 1.0, 1.0, 0);
            } else if (_qty > 1) {
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
var _grid_slot_size = slot_size;
var _grid_sp = spacing;
var _grid_w = (_cols * _grid_slot_size) + ((_cols - 1) * _grid_sp);
var _gap = 40 * gui_scale;
var _total_w = _grid_w;
if (_p.show_shipping || _p.show_chest) _total_w = (_grid_w * 2) + _gap;
var _base_x = (display_get_gui_width() / 2) - (_total_w / 2);
var _base_y = (display_get_gui_height() * 0.45);

// === 3. CUADRICULA DE LA MOCHILA ===
if (_p.show_backpack) {
    var _rows = ceil(max_backpack_slots / _cols);
    var _bh = (_rows * _grid_slot_size) + ((_rows - 1) * _grid_sp);
    var _bx = _base_x;
    var _by = _base_y - (_bh / 2);

    draw_set_halign(fa_center);
    var _title_y = _by - 40;
    draw_text_transformed(_bx + _grid_w/2, _title_y, "MOCHILA", 1.5, 1.5, 0);

    for (var i = 0; i < max_backpack_slots; i++) {
        var _sx = _bx + (i % _cols * (_grid_slot_size + _grid_sp));
        var _sy = _by + (i div _cols * (_grid_slot_size + _grid_sp));
        var _b_hover = (_mx >= _sx && _mx <= _sx + _grid_slot_size && _my >= _sy && _my <= _sy + _grid_slot_size);
        if (_b_hover) {
            var _s_data = _p.backpack_array[i];
            if (is_struct(_s_data)) {
                _p.hovered_item_slot_data = _s_data;
                _p.hovered_item_data = scr_get_item_data(_s_data.key);
            }
        }
        var _bg_col = (_b_hover) ? c_gray : _c_base;
        var _bd_col = (_b_hover) ? c_white : _c_border;
        var _bp_alpha = (_b_hover) ? 0.9 : _alpha;

        draw_set_alpha(_bp_alpha);
        draw_roundrect_color_ext(_sx, _sy, _sx + _grid_slot_size, _sy + _grid_slot_size, _rad, _rad, _bg_col, _bg_col, false);
        draw_set_alpha(1.0);
        draw_roundrect_color_ext(_sx, _sy, _sx + _grid_slot_size, _sy + _grid_slot_size, _rad, _rad, _bd_col, _bd_col, true);

        var _b_slot = _p.backpack_array[i];
        if (is_struct(_b_slot)) {
            var _b_key = _b_slot.key;
            var _b_qty = _b_slot.quantity;
            var _b_data = scr_get_item_data(_b_key);
            if (_b_data != undefined) {
                var _f = variable_struct_exists(_b_data, "row") ? (_b_data.row * 3) + _b_data.subimg : _b_data.subimg;
                var _is_tool_b = variable_struct_exists(global.tool_data, _b_key);
                if (_is_tool_b && _b_key != "sword" && _b_key != "bow" && variable_struct_exists(_b_slot, "quality")) {
                    _f += _b_slot.quality;
                }
                var _cc = _grid_slot_size / 2;
                var _sz  = 16 / max(sprite_get_width(_b_data.sprite), sprite_get_height(_b_data.sprite));
                var _cox = (sprite_get_width(_b_data.sprite)  / 2 - sprite_get_xoffset(_b_data.sprite)) * _sz * _icon_scale;
                var _coy = (sprite_get_height(_b_data.sprite) / 2 - sprite_get_yoffset(_b_data.sprite)) * _sz * _icon_scale;
                draw_sprite_ext(_b_data.sprite, _f, _sx + _cc - _cox, _sy + _cc - _coy, _icon_scale * _sz, _icon_scale * _sz, 0, c_white, 1);
                if (variable_struct_exists(_b_slot, "weight") && _b_slot.weight > 0) {
                    draw_set_halign(fa_right);
                    draw_set_valign(fa_bottom);
                    draw_set_color(c_white);
                    draw_text_transformed(_sx + _grid_slot_size - 4, _sy + _grid_slot_size - 2, scr_format_weight(_b_slot.weight), 1.0, 1.0, 0);
                } else if (_b_qty > 1) {
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
if (_p.show_shipping) {
    var _s_rows = 8;
    var _sh = (_s_rows * _grid_slot_size) + ((_s_rows - 1) * _grid_sp);
    var _sx_base = _base_x + _grid_w + _gap;
    var _sy_base = _base_y - (_sh / 2);

    draw_set_halign(fa_center);
    var _title_y = _sy_base - 40;
    draw_text_transformed(_sx_base + _grid_w/2, _title_y, "CONTENEDOR DE ENVIOS", 1.5, 1.5, 0);

    var _len = array_length(_p.shipping_array);
    for (var i = 0; i < _len; i++) {
        var _sx = _sx_base + (i % _cols * (_grid_slot_size + _grid_sp));
        var _sy = _sy_base + (i div _cols * (_grid_slot_size + _grid_sp));
        var _s_hover = (_mx >= _sx && _mx <= _sx + _grid_slot_size && _my >= _sy && _my <= _sy + _grid_slot_size);
        if (_s_hover) {
            var _s_data = _p.shipping_array[i];
            if (is_struct(_s_data)) {
                _p.hovered_item_slot_data = _s_data;
                _p.hovered_item_data = scr_get_item_data(_s_data.key);
            }
        }
        var _bg_col = (_s_hover) ? c_gray : _c_base;
        var _bd_col = (_s_hover) ? c_white : _c_border;
        var _s_alpha = (_s_hover) ? 0.9 : _alpha;

        draw_set_alpha(_s_alpha);
        draw_roundrect_color_ext(_sx, _sy, _sx + _grid_slot_size, _sy + _grid_slot_size, _rad, _rad, _bg_col, _bg_col, false);
        draw_set_alpha(1.0);
        draw_roundrect_color_ext(_sx, _sy, _sx + _grid_slot_size, _sy + _grid_slot_size, _rad, _rad, _bd_col, _bd_col, true);

        var _s_slot = _p.shipping_array[i];
        if (is_struct(_s_slot)) {
            var _s_key = _s_slot.key;
            var _s_qty = _s_slot.quantity;
            var _s_data = scr_get_item_data(_s_key);
            if (_s_data != undefined) {
                var _f    = variable_struct_exists(_s_data, "row") ? (_s_data.row * 3) + _s_data.subimg : _s_data.subimg;
                var _is_tool_s = variable_struct_exists(global.tool_data, _s_key);
                if (_is_tool_s && _s_key != "sword" && _s_key != "bow" && variable_struct_exists(_s_slot, "quality")) {
                    _f += _s_slot.quality;
                }
                var _cc = _grid_slot_size / 2;
                var _sz  = 16 / max(sprite_get_width(_s_data.sprite), sprite_get_height(_s_data.sprite));
                var _cox = (sprite_get_width(_s_data.sprite)  / 2 - sprite_get_xoffset(_s_data.sprite)) * _sz * _icon_scale;
                var _coy = (sprite_get_height(_s_data.sprite) / 2 - sprite_get_yoffset(_s_data.sprite)) * _sz * _icon_scale;
                draw_sprite_ext(_s_data.sprite, _f, _sx + _cc - _cox, _sy + _cc - _coy, _icon_scale * _sz, _icon_scale * _sz, 0, c_white, 1);
                if (variable_struct_exists(_s_slot, "weight") && _s_slot.weight > 0) {
                    draw_set_halign(fa_right);
                    draw_set_valign(fa_bottom);
                    draw_set_color(c_white);
                    draw_text_transformed(_sx + _grid_slot_size - 4, _sy + _grid_slot_size - 2, scr_format_weight(_s_slot.weight), 1.0, 1.0, 0);
                } else if (_s_qty > 1) {
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
if (_p.show_chest && instance_exists(_p.current_chest_id)) {
    var _c_rows = 8;
    var _ch = (_c_rows * _grid_slot_size) + ((_c_rows - 1) * _grid_sp);
    var _cx_base = _base_x + _grid_w + _gap;
    var _cy_base = _base_y - (_ch / 2);

    draw_set_halign(fa_center);
    var _c_title_y = _cy_base - 40;
    draw_text_transformed(_cx_base + _grid_w/2, _c_title_y, "COFRE", 1.5, 1.5, 0);

    for (var i = 0; i < 64; i++) {
        var _sx = _cx_base + (i % _cols * (_grid_slot_size + _grid_sp));
        var _sy = _cy_base + (i div _cols * (_grid_slot_size + _grid_sp));
        var _c_hover = (_mx >= _sx && _mx <= _sx + _grid_slot_size && _my >= _sy && _my <= _sy + _grid_slot_size);
        if (_c_hover) {
            var _s_data = _p.current_chest_id.storage_array[i];
            if (is_struct(_s_data)) {
                _p.hovered_item_slot_data = _s_data;
                _p.hovered_item_data = scr_get_item_data(_s_data.key);
            }
        }
        var _bg_col = (_c_hover) ? c_gray : _c_base;
        var _bd_col = (_c_hover) ? c_white : _c_border;
        var _c_alpha = (_c_hover) ? 0.9 : _alpha;

        draw_set_alpha(_c_alpha);
        draw_roundrect_color_ext(_sx, _sy, _sx + _grid_slot_size, _sy + _grid_slot_size, _rad, _rad, _bg_col, _bg_col, false);
        draw_set_alpha(1.0);
        draw_roundrect_color_ext(_sx, _sy, _sx + _grid_slot_size, _sy + _grid_slot_size, _rad, _rad, _bd_col, _bd_col, true);

        var _s_slot = _p.current_chest_id.storage_array[i];
        if (is_struct(_s_slot)) {
            var _s_key = _s_slot.key;
            var _s_qty = _s_slot.quantity;
            var _s_data = scr_get_item_data(_s_key);
            if (_s_data != undefined) {
                var _f    = variable_struct_exists(_s_data, "row") ? (_s_data.row * 3) + _s_data.subimg : _s_data.subimg;
                var _is_tool_s = variable_struct_exists(global.tool_data, _s_key);
                if (_is_tool_s && _s_key != "sword" && _s_key != "bow" && variable_struct_exists(_s_slot, "quality")) {
                    _f += _s_slot.quality;
                }
                var _cc = _grid_slot_size / 2;
                var _sz  = 16 / max(sprite_get_width(_s_data.sprite), sprite_get_height(_s_data.sprite));
                var _cox = (sprite_get_width(_s_data.sprite)  / 2 - sprite_get_xoffset(_s_data.sprite)) * _sz * _icon_scale;
                var _coy = (sprite_get_height(_s_data.sprite) / 2 - sprite_get_yoffset(_s_data.sprite)) * _sz * _icon_scale;
                draw_sprite_ext(_s_data.sprite, _f, _sx + _cc - _cox, _sy + _cc - _coy, _icon_scale * _sz, _icon_scale * _sz, 0, c_white, 1);
                if (variable_struct_exists(_s_slot, "weight") && _s_slot.weight > 0) {
                    draw_set_halign(fa_right);
                    draw_set_valign(fa_bottom);
                    draw_set_color(c_white);
                    draw_text_transformed(_sx + _grid_slot_size - 4, _sy + _grid_slot_size - 2, scr_format_weight(_s_slot.weight), 1.0, 1.0, 0);
                } else if (_s_qty > 1) {
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
if (is_struct(_p.held_item)) {
    var _h_key = _p.held_item.key;
    var _h_qty = _p.held_item.quantity;
    var _h_data = scr_get_item_data(_h_key);
    if (_h_data != undefined) {
        var _h_scl = gui_scale * 1.8;
        var _h_off = 7.2 * _h_scl;
        var _f     = variable_struct_exists(_h_data, "row") ? (_h_data.row * 3) + _h_data.subimg : _h_data.subimg;
        var _is_tool_h = variable_struct_exists(global.tool_data, _h_key);
        if (_is_tool_h && _h_key != "sword" && _h_key != "bow" && variable_struct_exists(_p.held_item, "quality")) {
            _f += _p.held_item.quality;
        }
        var _sz  = 16 / max(sprite_get_width(_h_data.sprite), sprite_get_height(_h_data.sprite));
        var _cox = (sprite_get_width(_h_data.sprite)  / 2 - sprite_get_xoffset(_h_data.sprite)) * _sz * _h_scl;
        var _coy = (sprite_get_height(_h_data.sprite) / 2 - sprite_get_yoffset(_h_data.sprite)) * _sz * _h_scl;
        draw_sprite_ext(_h_data.sprite, _f, _mx - _cox, _my - _coy, _h_scl * _sz, _h_scl * _sz, 0, c_white, 0.8);
        if (_h_qty > 1) {
            draw_set_halign(fa_right);
            draw_set_valign(fa_bottom);
            draw_set_color(c_white);
            draw_text_transformed(_mx + 15, _my + 15, string(_h_qty), 1.1, 1.1, 0);
        }
    }
}

// === 5. NOTIFICACIONES ===
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

// === 6. TOOLTIP ===
if (is_struct(_p.hovered_item_data) && !is_struct(_p.held_item)) {
    var _name = _p.hovered_item_data.name;
    var _qty  = _p.hovered_item_slot_data.quantity;
    var _type = (variable_struct_exists(_p.hovered_item_data, "type")) ? _p.hovered_item_data.type : -1;
    var _tooltip_text = _name;
    if (_qty > 1) _tooltip_text += "\nCantidad: " + string(_qty);
    if (variable_struct_exists(_p.hovered_item_slot_data, "weight") && _p.hovered_item_slot_data.weight > 0) {
        var _wgt = _p.hovered_item_slot_data.weight;
        _tooltip_text += "\nPeso: " + scr_format_weight(_wgt);
        if (variable_struct_exists(_p.hovered_item_data, "base_sell_price")) {
            _tooltip_text += "\nVenta: $" + string(floor(_p.hovered_item_data.base_sell_price * _wgt));
        }
    }
    if (_type == ITEM_TYPE.TOOL || _type == ITEM_TYPE.WEAPON) {
        if (variable_struct_exists(_p.hovered_item_slot_data, "quality")) {
            var _qual_idx = _p.hovered_item_slot_data.quality;
            if (_qual_idx >= 0 && _qual_idx < array_length(global.quality_names)) {
                _tooltip_text += "\nCalidad: " + global.quality_names[_qual_idx];
            }
        }
        var _level = 1;
        if (variable_struct_exists(_p.hovered_item_slot_data, "quality")) {
            _level = _p.hovered_item_slot_data.quality + 1;
        } else if (variable_struct_exists(_p.hovered_item_data, "level")) {
            _level = _p.hovered_item_data.level;
        }
        _tooltip_text += "\nNivel: " + string(_level);
    }
    draw_set_font(fnt_pixel_operator);
    var _tw = (string_width(_tooltip_text) + 16) * 1.2;
    var _th = (string_height(_tooltip_text) + 16) * 1.2;
    var _tx = _mx + 20;
    var _ty = _my + 20;
    if (_tx + _tw > display_get_gui_width()) _tx = _mx - _tw - 8;
    if (_ty + _th > display_get_gui_height()) _ty = _my - _th - 8;
    draw_set_alpha(0.9);
    draw_roundrect_color_ext(_tx, _ty, _tx + _tw, _ty + _th, 8, 8, c_dkgray, c_dkgray, false);
    draw_roundrect_color_ext(_tx, _ty, _tx + _tw, _ty + _th, 8, 8, c_silver, c_silver, true);
    draw_set_alpha(1.0);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_text_transformed(_tx + 8, _ty + 8, _tooltip_text, 1.2, 1.2, 0);
}

// === DIALOGO NPC ===
if (_p.dialog_open) {
    var _dgw   = display_get_gui_width();
    var _dgh   = display_get_gui_height();
    var _dbw   = _dgw - 80;
    var _lines = string_split(_p.dialog_text, "\n");
    var _dbh   = (array_length(_lines) > 1) ? 180 : 110;
    var _dbx1  = 40;
    var _dby1  = _dgh - _dbh - 20;
    var _dbx2  = _dbx1 + _dbw;
    var _dby2  = _dby1 + _dbh;
    draw_set_alpha(0.88);
    draw_roundrect_color_ext(_dbx1, _dby1, _dbx2, _dby2, 10, 10, c_dkgray, c_dkgray, false);
    draw_set_alpha(1.0);
    draw_roundrect_color_ext(_dbx1, _dby1, _dbx2, _dby2, 10, 10, c_white, c_white, true);
    draw_set_font(fnt_pixel_operator);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_text_transformed_color(_dbx1 + 16, _dby1 + 12, _p.dialog_npc_name, 1.8, 1.8, 0, c_yellow, c_yellow, c_orange, c_orange, 1.0);
    draw_set_color(c_white);
    draw_line(_dbx1 + 10, _dby1 + 42, _dbx2 - 10, _dby1 + 42);
    draw_set_valign(fa_middle);
    for (var _li = 0; _li < array_length(_lines); _li++) {
        draw_text_transformed_color(_dbx1 + 16, _dby1 + 56 + _li * 44, _lines[_li], 1.3, 1.3, 0, c_white, c_white, c_white, c_white, 1.0);
    }
    draw_set_halign(fa_right);
    draw_set_color(c_silver);
    draw_text_transformed(_dbx2 - 14, _dby2 - 18, "[E] Cerrar", 1.1, 1.1, 0);
}

// === TIENDA ===
if (_p.shop_open) {
    var _gw  = display_get_gui_width();
    var _gh  = display_get_gui_height();
    var _pw  = 520;
    var _ph  = 460;
    var _px1 = (_gw - _pw) / 2;
    var _py1 = _gh * 0.12;
    var _px2 = _px1 + _pw;
    var _py2 = _py1 + _ph;

    var _shop    = global.shop_data[$ _p.shop_npc_key];
    var _sitems  = (_shop != undefined && _shop.available) ? _shop.items : [];
    var _sn      = array_length(_sitems);
    var _visible = 8;
    var _row     = 44;
    var _clerk   = variable_struct_exists(global.npc_data, _p.shop_npc_key) ? global.npc_data[$ _p.shop_npc_key].name : _p.shop_npc_key;

    draw_set_alpha(0.72);
    draw_rectangle_color(0, 0, _gw, _gh, c_black, c_black, c_black, c_black, false);
    draw_set_alpha(1.0);
    draw_set_alpha(0.93);
    draw_roundrect_color_ext(_px1, _py1, _px2, _py2, 12, 12, c_dkgray, c_dkgray, false);
    draw_set_alpha(1.0);
    draw_roundrect_color_ext(_px1, _py1, _px2, _py2, 12, 12, c_silver, c_silver, true);

    draw_set_font(fnt_pixel_operator);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_text_transformed_color(_px1 + _pw / 2, _py1 + 10, _clerk, 2.2, 2.2, 0, c_yellow, c_yellow, c_orange, c_orange, 1.0);
    draw_set_color(c_silver);
    draw_line(_px1 + 10, _py1 + 46, _px2 - 10, _py1 + 46);
    draw_set_halign(fa_right);
    draw_set_color(c_silver);
    draw_text_transformed(_px2 - 14, _py1 + 14, "[ESC] Cerrar", 1.1, 1.1, 0);

    var _list_y = _py1 + 52;
    var _dmx    = device_mouse_x_to_gui(0);
    var _dmy    = device_mouse_y_to_gui(0);

    if (_shop == undefined || !_shop.available) {
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text_transformed_color(_px1 + _pw / 2, _py1 + _ph / 2, "Proximamente...", 1.8, 1.8, 0, c_silver, c_silver, c_silver, c_silver, 1.0);
    } else if (_sn == 0) {
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text_transformed_color(_px1 + _pw / 2, _py1 + _ph / 2, "Sin articulos", 1.8, 1.8, 0, c_silver, c_silver, c_silver, c_silver, 1.0);
    } else {
        for (var _i = 0; _i < _visible; _i++) {
            var _idx  = _i + _p.shop_scroll;
            if (_idx >= _sn) break;
            var _entry   = _sitems[_idx];
            var _idata   = scr_get_item_data(_entry.item_key);
            var _ry      = _list_y + _i * _row;
            var _hovered = (_dmx >= _px1 + 6 && _dmx <= _px2 - 6 && _dmy >= _ry && _dmy <= _ry + _row - 2);
            if (_hovered) {
                draw_set_alpha(0.35);
                draw_roundrect_color_ext(_px1 + 6, _ry, _px2 - 6, _ry + _row - 2, 6, 6, c_white, c_white, false);
                draw_set_alpha(1.0);
            }
            if (_idata != undefined) {
                var _f = variable_struct_exists(_idata, "row") ? (_idata.row * 3) + _idata.subimg : _idata.subimg;
                var _sz = 16 / sprite_get_width(_idata.sprite);
                draw_sprite_ext(_idata.sprite, _f, _px1 + 26, _ry + _row / 2, 1.4 * _sz, 1.4 * _sz, 0, c_white, 1.0);
                draw_set_halign(fa_left);
                draw_set_valign(fa_middle);
                draw_text_transformed_color(_px1 + 50, _ry + _row / 2, _idata.name, 1.4, 1.4, 0, c_white, c_white, c_white, c_white, 1.0);
            }
            var _price_str = "MXN$ " + string(_entry.price_money);
            for (var _j = 0; _j < array_length(_entry.price_items); _j++) {
                var _req      = _entry.price_items[_j];
                var _req_data = scr_get_item_data(_req.key);
                var _req_name = (_req_data != undefined) ? _req_data.name : _req.key;
                _price_str   += " + " + string(_req.qty) + " " + _req_name;
            }
            var _can_afford = _p.money >= _entry.price_money;
            var _price_col  = _can_afford ? c_lime : c_red;
            draw_set_halign(fa_right);
            draw_set_valign(fa_middle);
            draw_text_transformed_color(_px2 - 14, _ry + _row / 2, _price_str, 1.3, 1.3, 0, _price_col, _price_col, _price_col, _price_col, 1.0);
        }
        if (_p.shop_scroll > 0) {
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text_transformed_color(_px1 + _pw / 2, _list_y - 14, "^", 1.6, 1.6, 0, c_silver, c_silver, c_silver, c_silver, 1.0);
        }
        if (_p.shop_scroll + _visible < _sn) {
            draw_set_halign(fa_center);
            draw_text_transformed_color(_px1 + _pw / 2, _list_y + _visible * _row, "v", 1.6, 1.6, 0, c_silver, c_silver, c_silver, c_silver, 1.0);
        }
    }

    draw_set_color(c_silver);
    draw_line(_px1 + 10, _py2 - 38, _px2 - 10, _py2 - 38);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_text_transformed_color(_px1 + 14, _py2 - 19, "MXN$ " + string(_p.money), 1.4, 1.4, 0, c_lime, c_lime, c_green, c_green, 1.0);

    if (_p.shop_msg_timer > 0) {
        var _msg_alpha = min(1.0, _p.shop_msg_timer / 20.0);
        draw_set_halign(fa_right);
        draw_text_transformed_color(_px2 - 14, _py2 - 19, _p.shop_msg, 1.4, 1.4, 0, c_yellow, c_yellow, c_yellow, c_yellow, _msg_alpha);
    }
}
