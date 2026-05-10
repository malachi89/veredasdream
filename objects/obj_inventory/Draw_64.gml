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

// 2.0 INDICADOR DE FILA (HOTBAR INDEX) - LADO IZQUIERDO
var _ix = menu_x_start;
var _iy = menu_y_start;
draw_set_alpha(_alpha);
draw_roundrect_color_ext(_ix, _iy, _ix + slot_size, _iy + slot_size, _rad, _rad, c_green, c_green, false);
draw_set_alpha(1.0);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(fnt_pixel_operator);
var _h_num = string(_p.current_hotbar_index + 1);
draw_text_transformed_color(_ix + slot_size/2, _iy + slot_size/2, _h_num, 1.5, 1.5, 0, c_white, c_white, c_white, c_white, 1.0);

for (var i = 0; i < total_slots; i++) {
    var _cx = menu_x_start + ((i + 1) * (slot_size + spacing));
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

// === 2.5 ARMOR SLOTS ===
if (_p.show_backpack) {
    var _armor_count = 4;
    var _armor_panel_h = _armor_count * _grid_slot_size + (_armor_count - 1) * _grid_sp;
    var _armor_x = _base_x - _gap - _grid_slot_size;
    var _armor_y_start = _base_y - _armor_panel_h / 2;

    draw_set_halign(fa_center);
    draw_text_transformed(_armor_x + _grid_slot_size/2, _armor_y_start - 40, "ARMADURA", 1.5, 1.5, 0);

    for (var _ai = 0; _ai < _armor_count; _ai++) {
        var _asx = _armor_x;
        var _asy = _armor_y_start + _ai * (_grid_slot_size + _grid_sp);
        var _a_hover = (_mx >= _asx && _mx <= _asx + _grid_slot_size && _my >= _asy && _my <= _asy + _grid_slot_size);

        var _armor_vars = ["armor_casco", "armor_peto", "armor_perneras", "armor_botas"];
        var _a_var = _armor_vars[_ai];
        var _a_names = ["Casco", "Peto", "Pernerass", "Botas"];
        var _equipped_key = variable_instance_exists(_p, _a_var) ? _p[$ _a_var] : "";
        var _has_item = (_equipped_key != "");

        var _bg_col = _a_hover ? c_gray : _c_base;
        var _bd_col = _a_hover ? c_white : _c_border;
        var _ap_alpha = _a_hover ? 0.9 : _alpha;

        draw_set_alpha(_ap_alpha);
        draw_roundrect_color_ext(_asx, _asy, _asx + _grid_slot_size, _asy + _grid_slot_size, _rad, _rad, _bg_col, _bg_col, false);
        draw_set_alpha(1.0);
        draw_roundrect_color_ext(_asx, _asy, _asx + _grid_slot_size, _asy + _grid_slot_size, _rad, _rad, _bd_col, _bd_col, true);

        if (_has_item) {
            var _a_data = scr_get_item_data(_equipped_key);
            if (_a_data != undefined) {
                var _f  = variable_struct_exists(_a_data, "row") ? (_a_data.row * 3) + _a_data.subimg : _a_data.subimg;
                var _sz = 16 / max(sprite_get_width(_a_data.sprite), sprite_get_height(_a_data.sprite));
                var _cox = (sprite_get_width(_a_data.sprite)  / 2 - sprite_get_xoffset(_a_data.sprite)) * _sz * _icon_scale;
                var _coy = (sprite_get_height(_a_data.sprite) / 2 - sprite_get_yoffset(_a_data.sprite)) * _sz * _icon_scale;
                draw_sprite_ext(_a_data.sprite, _f, _asx + _grid_slot_size/2 - _cox, _asy + _grid_slot_size/2 - _coy, _icon_scale * _sz, _icon_scale * _sz, 0, c_white, 1);
            }
        } else {
            var _a_data = global.armor_data[$ _a_var];
            if (_a_data != undefined) {
                var _f  = variable_struct_exists(_a_data, "row") ? (_a_data.row * 3) + _a_data.subimg : _a_data.subimg;
                var _sz = 16 / max(sprite_get_width(_a_data.sprite), sprite_get_height(_a_data.sprite));
                var _cox = (sprite_get_width(_a_data.sprite)  / 2 - sprite_get_xoffset(_a_data.sprite)) * _sz * _icon_scale;
                var _coy = (sprite_get_height(_a_data.sprite) / 2 - sprite_get_yoffset(_a_data.sprite)) * _sz * _icon_scale;
                draw_sprite_ext(_a_data.sprite, _f, _asx + _grid_slot_size/2 - _cox, _asy + _grid_slot_size/2 - _coy, _icon_scale * _sz, _icon_scale * _sz, 0, c_black, 0.35);
            }
        }

        if (_a_hover) {
            if (_has_item) {
                var _a_data = scr_get_item_data(_equipped_key);
                _p.hovered_item_slot_data = { key: _equipped_key, quantity: 1 };
                _p.hovered_item_data = _a_data;
            } else {
                draw_set_halign(fa_center);
                draw_set_valign(fa_top);
                draw_set_color(c_white);
                draw_text_transformed(_asx + _grid_slot_size/2, _asy + _grid_slot_size + 4, _a_names[_ai], 1.1, 1.1, 0);
                draw_set_color(c_silver);
                draw_text_transformed(_asx + _grid_slot_size/2, _asy + _grid_slot_size + 22, "Vacío", 0.9, 0.9, 0);
            }
        }
    }
}

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
// Las notificaciones las dibuja obj_controller/Draw_64

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
    if (_type == ITEM_TYPE.ARMOR && variable_struct_exists(_p.hovered_item_data, "defense")) {
        var _def_pct = _p.hovered_item_data.defense * 100;
        _tooltip_text += "\nDefensa: " + string(_def_pct) + "%";
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

// === PANEL LETRERO ===
if (_p.sign_panel_open) {
    var _gw  = display_get_gui_width();
    var _gh  = display_get_gui_height();
    var _pw  = 480;
    var _ph  = 560;
    var _px1 = (_gw - _pw) * 0.5;
    var _py1 = _gh * 0.10;
    var _px2 = _px1 + _pw;
    var _py2 = _py1 + _ph;

    draw_set_alpha(0.92);
    draw_roundrect_color_ext(_px1, _py1, _px2, _py2, 12, 12, make_color_rgb(28, 28, 32), make_color_rgb(28, 28, 32), false);
    draw_set_alpha(1.0);
    draw_roundrect_color_ext(_px1, _py1, _px2, _py2, 12, 12, c_white, c_white, true);

    draw_set_font(fnt_pixel_operator);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_text_transformed_color(_px1 + 16, _py1 + 14, _p.sign_panel_title, 1.8, 1.8, 0, c_yellow, c_yellow, c_orange, c_orange, 1.0);
    draw_set_color(c_white);
    draw_line(_px1 + 10, _py1 + 48, _px2 - 10, _py1 + 48);

    var _sp_row     = 56;
    var _sp_visible = 8;
    var _list_y     = _py1 + 56;
    var _items      = _p.sign_panel_items;
    var _n          = array_length(_items);

    for (var _i = 0; _i < _sp_visible; _i++) {
        var _idx = _i + _p.sign_scroll;
        if (_idx >= _n) break;
        var _item    = _items[_idx];
        var _ry      = _list_y + _i * _sp_row;
        var _row_col = (_i mod 2 == 0) ? make_color_rgb(50, 50, 55) : make_color_rgb(38, 38, 42);
        draw_set_alpha(0.7);
        draw_set_color(_row_col);
        draw_roundrect_color_ext(_px1 + 8, _ry, _px2 - 8, _ry + _sp_row - 2, 4, 4, _row_col, _row_col, false);
        draw_set_alpha(1.0);

        var _spr = _item.sprite;
        var _sub = _item.subimg;
        var _sz  = 40.0 / max(sprite_get_width(_spr), sprite_get_height(_spr));
        draw_sprite_ext(_spr, _sub, _px1 + 16, _ry + _sp_row * 0.5 - 21, _sz, _sz, 0, c_white, 1.0);

        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        draw_set_color(c_white);
        draw_text_transformed(_px1 + 62, _ry + _sp_row * 0.5, _item.name, 1.5, 1.5, 0);
    }

    draw_set_halign(fa_right);
    draw_set_valign(fa_bottom);
    draw_set_color(c_silver);
    var _sp_hint = (_n > _sp_visible) ? "Rueda: scroll  [E] Cerrar" : "[E] Cerrar";
    draw_text_transformed(_px2 - 14, _py2 - 14, _sp_hint, 1.1, 1.1, 0);
}

// === DIALOGO NPC ===
if (_p.dialog_open) {
    var _dgw   = display_get_gui_width();
    var _dgh   = display_get_gui_height();
    var _dbw   = _dgw - 80;
    // Replace placeholders in dialogue text
    var _display_text = string_replace_all(_p.dialog_text, "{player_name}", global.player_name);
    _display_text = string_replace_all(_display_text, "{farm_name}", global.farm_name);
    var _lines = string_split(_display_text, "\n");
    var _dbh   = (array_length(_lines) > 1) ? 190 : 120;
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
    draw_line(_dbx1 + 10, _dby1 + 50, _dbx2 - 10, _dby1 + 50);
    draw_set_valign(fa_middle);
    for (var _li = 0; _li < array_length(_lines); _li++) {
        draw_text_transformed_color(_dbx1 + 16, _dby1 + 66 + _li * 44, _lines[_li], 1.3, 1.3, 0, c_white, c_white, c_white, c_white, 1.0);
    }
    draw_set_halign(fa_right);
    draw_set_color(c_silver);
    draw_text_transformed(_dbx2 - 14, _dby2 - 18, "[E] Cerrar", 1.1, 1.1, 0);
}

// === SEÑORA RATA DIALOG ===
if (_p.sra_dialog_open) {
    var _dgw   = display_get_gui_width();
    var _dgh   = display_get_gui_height();
    var _dbw   = _dgw - 80;
    var _dbx1  = 40;
    var _dby1  = _dgh - 260;
    var _dbx2  = _dbx1 + _dbw;
    var _dby2  = _dby1 + 240;

    draw_set_alpha(0.88);
    draw_roundrect_color_ext(_dbx1, _dby1, _dbx2, _dby2, 10, 10, c_dkgray, c_dkgray, false);
    draw_set_alpha(1.0);
    draw_roundrect_color_ext(_dbx1, _dby1, _dbx2, _dby2, 10, 10, c_white, c_white, true);
    draw_set_font(fnt_pixel_operator);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_yellow);
    draw_text_transformed_color(_dbx1 + 16, _dby1 + 12, "La Señora Rata", 1.8, 1.8, 0, c_yellow, c_yellow, c_orange, c_orange, 1.0);
    draw_set_color(c_white);
    draw_line(_dbx1 + 10, _dby1 + 50, _dbx2 - 10, _dby1 + 50);

    if (_p.sra_dialog_stage == 0) {
        draw_set_valign(fa_top);
        var _greeting = global.sra_rata_dialogs.greeting;
        draw_text_transformed_color(_dbx1 + 16, _dby1 + 70, _greeting, 1.3, 1.3, 0, c_white, c_white, c_white, c_white, 1.0);
        draw_set_halign(fa_right);
        draw_set_valign(fa_bottom);
        draw_set_color(c_silver);
        draw_text_transformed(_dbx2 - 14, _dby2 - 18, "[E] Continuar", 1.1, 1.1, 0);
    } else if (_p.sra_dialog_stage == 1) {
        draw_set_valign(fa_top);
        var _offer = global.sra_rata_dialogs.offer;
        draw_text_transformed_color(_dbx1 + 16, _dby1 + 70, _offer, 1.3, 1.3, 0, c_white, c_white, c_white, c_white, 1.0);
        draw_set_color(c_aqua);
        draw_text_transformed_color(_dbx1 + 16, _dby1 + 155, global.sra_rata_dialogs.daily_option, 1.3, 1.3, 0, c_aqua, c_aqua, c_white, c_white, 1.0);
        draw_text_transformed_color(_dbx1 + 16, _dby1 + 185, global.sra_rata_dialogs.lifetime_option, 1.3, 1.3, 0, c_aqua, c_aqua, c_white, c_white, 1.0);
        draw_set_halign(fa_right);
        draw_set_valign(fa_bottom);
        draw_set_color(c_silver);
        draw_text_transformed(_dbx2 - 14, _dby2 - 18, "[Esc] Salir", 1.1, 1.1, 0);
    } else if (_p.sra_dialog_stage == 2) {
        draw_set_valign(fa_top);
        draw_set_color(c_lime);
        draw_text_transformed_color(_dbx1 + 16, _dby1 + 70, global.sra_rata_dialogs.hired_daily, 1.3, 1.3, 0, c_lime, c_lime, c_white, c_white, 1.0);
        draw_set_halign(fa_right);
        draw_set_valign(fa_bottom);
        draw_set_color(c_silver);
        draw_text_transformed(_dbx2 - 14, _dby2 - 18, "[Esc] Cerrar", 1.1, 1.1, 0);
    } else if (_p.sra_dialog_stage == 6) {
        draw_set_valign(fa_top);
        draw_set_color(c_lime);
        draw_text_transformed_color(_dbx1 + 16, _dby1 + 70, global.sra_rata_dialogs.hired_lifetime, 1.3, 1.3, 0, c_lime, c_lime, c_white, c_white, 1.0);
        draw_set_halign(fa_right);
        draw_set_valign(fa_bottom);
        draw_set_color(c_silver);
        draw_text_transformed(_dbx2 - 14, _dby2 - 18, "[Esc] Cerrar", 1.1, 1.1, 0);
    } else if (_p.sra_dialog_stage == 3) {
        draw_set_valign(fa_top);
        draw_text_transformed_color(_dbx1 + 16, _dby1 + 70, global.sra_rata_dialogs.decline, 1.3, 1.3, 0, c_white, c_white, c_white, c_white, 1.0);
        draw_set_halign(fa_right);
        draw_set_valign(fa_bottom);
        draw_set_color(c_silver);
        draw_text_transformed(_dbx2 - 14, _dby2 - 18, "[Esc] Cerrar", 1.1, 1.1, 0);
    } else if (_p.sra_dialog_stage == 4) {
        draw_set_valign(fa_top);
        draw_text_transformed_color(_dbx1 + 16, _dby1 + 70, global.sra_rata_dialogs.already_hired, 1.3, 1.3, 0, c_white, c_white, c_white, c_white, 1.0);
        draw_set_halign(fa_right);
        draw_set_valign(fa_bottom);
        draw_set_color(c_silver);
        draw_text_transformed(_dbx2 - 14, _dby2 - 18, "[Esc] Cerrar", 1.1, 1.1, 0);
    } else if (_p.sra_dialog_stage == 5) {
        draw_set_valign(fa_top);
        draw_set_color(c_red);
        draw_text_transformed_color(_dbx1 + 16, _dby1 + 70, global.sra_rata_dialogs.no_money, 1.3, 1.3, 0, c_red, c_red, c_white, c_white, 1.0);
        draw_set_halign(fa_right);
        draw_set_valign(fa_bottom);
        draw_set_color(c_silver);
        draw_text_transformed(_dbx2 - 14, _dby2 - 18, "[Esc] Cerrar", 1.1, 1.1, 0);
    } else if (_p.sra_dialog_stage == 10) {
        draw_set_valign(fa_top);
        draw_text_transformed_color(_dbx1 + 16, _dby1 + 70, global.sra_rata_dialogs.farm_ask, 1.3, 1.3, 0, c_white, c_white, c_white, c_white, 1.0);
        draw_set_color(c_aqua);
        draw_text_transformed_color(_dbx1 + 16, _dby1 + 120, global.sra_rata_dialogs.farm_rest_option, 1.3, 1.3, 0, c_aqua, c_aqua, c_white, c_white, 1.0);
        draw_text_transformed_color(_dbx1 + 16, _dby1 + 150, global.sra_rata_dialogs.farm_work_option, 1.3, 1.3, 0, c_aqua, c_aqua, c_white, c_white, 1.0);
        draw_set_halign(fa_right);
        draw_set_valign(fa_bottom);
        draw_set_color(c_silver);
        draw_text_transformed(_dbx2 - 14, _dby2 - 18, "[Esc] Salir", 1.1, 1.1, 0);
    } else if (_p.sra_dialog_stage == 11) {
        draw_set_valign(fa_top);
        draw_set_color(c_orange);
        draw_text_transformed_color(_dbx1 + 16, _dby1 + 70, global.sra_rata_dialogs.farm_rest, 1.3, 1.3, 0, c_orange, c_orange, c_white, c_white, 1.0);
        draw_set_halign(fa_right);
        draw_set_valign(fa_bottom);
        draw_set_color(c_silver);
        draw_text_transformed(_dbx2 - 14, _dby2 - 18, "[E] Cerrar", 1.1, 1.1, 0);
    } else if (_p.sra_dialog_stage == 12) {
        draw_set_valign(fa_top);
        draw_set_color(c_red);
        draw_text_transformed_color(_dbx1 + 16, _dby1 + 70, global.sra_rata_dialogs.farm_work, 1.3, 1.3, 0, c_red, c_red, c_white, c_white, 1.0);
        draw_set_halign(fa_right);
        draw_set_valign(fa_bottom);
        draw_set_color(c_silver);
        draw_text_transformed(_dbx2 - 14, _dby2 - 18, "[E] Cerrar", 1.1, 1.1, 0);
    }
}

// === TIENDA ===
if (_p.shop_open) {
    var _gw  = display_get_gui_width();
    var _gh  = display_get_gui_height();
    var _is_workbench = (_p.shop_npc_key == "workbench" || _p.shop_npc_key == "machine_alchemy");
    var _is_bs = (_p.shop_npc_key == "Carlos");
    var _wb_or_bs = _is_workbench || _is_bs;
    var _pw  = _wb_or_bs ? 760 : 520;
    var _ph  = _wb_or_bs ? 580 : 460;
    var _px1 = (_gw - _pw) / 2;
    var _py1 = _gh * 0.10;
    var _px2 = _px1 + _pw;
    var _py2 = _py1 + _ph;

    var _shop    = global.shop_data[$ _p.shop_npc_key];
    var _sitems  = (_shop != undefined && _shop.available) ? _shop.items : [];
    if (_p.shop_npc_key == "Miraculos") _sitems = scr_get_miraculos_shop_items();
    var _sn      = array_length(_sitems);
    var _visible = _wb_or_bs ? 7 : 8;
    var _row     = _wb_or_bs ? 64 : 44;
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
    var _header_line_y = _py1 + (_wb_or_bs ? 66 : 54);
    draw_set_color(c_silver);
    draw_line(_px1 + 10, _header_line_y, _px2 - 10, _header_line_y);
    draw_set_halign(fa_right);
    draw_set_color(c_silver);
    draw_text_transformed(_px2 - 14, _py1 + 14, "[ESC] Cerrar", 1.1, 1.1, 0);

    var _list_y = _header_line_y + 8;
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
            if (_wb_or_bs) {
                var _row_col = (_i mod 2 == 0) ? make_color_rgb(50, 50, 55) : make_color_rgb(38, 38, 42);
                draw_set_alpha(_hovered ? 0.7 : 0.4);
                draw_roundrect_color_ext(_px1 + 6, _ry, _px2 - 6, _ry + _row - 2, 6, 6, _row_col, _row_col, false);
                draw_set_alpha(1.0);
                if (_hovered) {
                    draw_roundrect_color_ext(_px1 + 6, _ry, _px2 - 6, _ry + _row - 2, 6, 6, c_silver, c_silver, true);
                }
            } else if (_hovered) {
                draw_set_alpha(0.35);
                draw_roundrect_color_ext(_px1 + 6, _ry, _px2 - 6, _ry + _row - 2, 6, 6, c_white, c_white, false);
                draw_set_alpha(1.0);
            }
            // --- Nombre e icono del resultado ---
            if (_idata != undefined) {
                var _f  = variable_struct_exists(_idata, "row") ? (_idata.row * 3) + _idata.subimg : _idata.subimg;
                var _sz = 16 / max(sprite_get_width(_idata.sprite), sprite_get_height(_idata.sprite));
                var _sox = (_p.shop_npc_key == "Miraculos") ? -16 : (_is_bs ? -20 : 0);
                var _soy = (_p.shop_npc_key == "Miraculos") ? -16 : (_is_bs ? -12 : 0);
                if (_is_bs && variable_struct_exists(_entry, "is_upgrade") && _entry.is_upgrade) {
                    var _tq = scr_get_tool_quality(_entry.item_key, _p);
                    if (_tq >= 0 && _tq < QUALITY.VITOLANIO) _f += _tq + 1;
                }
                if (_is_workbench) {
                    var _spw = sprite_get_width(_idata.sprite);
                    var _sph = sprite_get_height(_idata.sprite);
                    var _scl = 2.4 * _sz;
                    var _ox_off = (sprite_get_xoffset(_idata.sprite) - _spw / 2) * _scl;
                    var _oy_off = (sprite_get_yoffset(_idata.sprite) - _sph / 2) * _scl;
                    draw_sprite_ext(_idata.sprite, _f, _px1 + 26 + _ox_off, _ry + _row / 2 - 6 + _oy_off, _scl, _scl, 0, c_white, 1.0);
                } else {
                    var _scl_mult = (_p.shop_npc_key == "Miraculos") ? 2.2 : (_is_bs ? 2.4 : 1.8);
                    draw_sprite_ext(_idata.sprite, _f, _px1 + 26 + _sox, _ry + _row / 2 + _soy, _scl_mult * _sz, _scl_mult * _sz, 0, c_white, 1.0);
                }
                draw_set_halign(fa_left);
                draw_set_valign(fa_middle);
                    var _name_scale = _wb_or_bs ? 1.7 : 1.4;
                var _ny = _ry + _row / 2;
                if (_is_workbench || (_is_bs && variable_struct_exists(_entry, "is_upgrade") && _entry.is_upgrade)) _ny -= 12;
                draw_text_transformed_color(_px1 + 52, _ny, _idata.name, _name_scale, _name_scale, 0, c_white, c_white, c_white, c_white, 1.0);
            }

            if (_is_workbench) {
                // --- Requisito de coleccion ---
                if (variable_struct_exists(_entry, "collection_req")) {
                    var _cr = _entry.collection_req;
                    var _cats = scr_get_collection_categories();
                    var _cat = _cats[_cr.cat];
                    var _collected = scr_count_collected_in_category(_cat.db);
                    var _coll_ok = (_collected >= _cr.min);
                    draw_set_halign(fa_left);
                    draw_set_valign(fa_middle);
                    draw_text_transformed_color(_px1 + 52, _ry + _row / 2 + 16,
                        "Requiere " + string(_collected) + "/" + string(_cr.min) + " " + _cat.name,
                        1.1, 1.1, 0,
                        _coll_ok ? c_lime : c_red, _coll_ok ? c_lime : c_red,
                        c_white, c_white, 1.0);
                }
                // --- Ingredientes como cajas de sprite ---
                var _bw   = 96;
                var _bh   = 48;
                var _gap  = 6;
                var _n    = array_length(_entry.price_items);
                var _ingr_total_w = _n * _bw + (_n - 1) * _gap;
                var _ix0  = _px2 - 14 - _ingr_total_w;
                var _iy0  = _ry + (_row - _bh) / 2;
                var _tooltip_str = "";
                var _tooltip_x   = 0;
                var _tooltip_y   = 0;

                for (var _j = 0; _j < _n; _j++) {
                    var _req  = _entry.price_items[_j];
                    var _lkey = variable_struct_exists(_req, "group_keys") ? _req.group_keys[0] : _req.key;
                    var _rid  = scr_get_item_data(_lkey);
                    var _have = variable_struct_exists(_req, "group_keys")
                        ? scr_count_item_group(_req.group_keys, _p)
                        : scr_count_item(_req.key, _p);
                    var _ok   = (_have >= _req.qty);
                    var _bx   = _ix0 + _j * (_bw + _gap);
                    var _by   = _iy0;

                    // fondo
                    draw_set_alpha(0.45);
                    draw_roundrect_color_ext(_bx, _by, _bx + _bw, _by + _bh, 5, 5,
                        _ok ? make_color_rgb(10,40,10) : make_color_rgb(50,10,10),
                        _ok ? make_color_rgb(10,40,10) : make_color_rgb(50,10,10), false);
                    draw_set_alpha(1.0);
                    draw_roundrect_color_ext(_bx, _by, _bx + _bw, _by + _bh, 5, 5,
                        _ok ? c_lime : c_red, _ok ? c_lime : c_red, true);

                    // sprite — mitad izquierda
                    if (_rid != undefined) {
                        var _rf  = variable_struct_exists(_rid, "row") ? (_rid.row * 3) + _rid.subimg : _rid.subimg;
                        var _rsz = 16 / max(sprite_get_width(_rid.sprite), sprite_get_height(_rid.sprite));
                        draw_sprite_ext(_rid.sprite, _rf, _bx + 10, _by + _bh / 2 - 17, 2.4 * _rsz, 2.4 * _rsz, 0, c_white, 1.0);
                    }

                    // cantidad — mitad derecha
                    draw_set_font(fnt_pixel_operator);
                    draw_set_halign(fa_center);
                    draw_set_valign(fa_middle);
                    draw_set_color(_ok ? c_lime : c_red);
                    draw_text_transformed(_bx + 68, _by + _bh / 2, string(_req.qty), 1.6, 1.6, 0);

                    // hover — preparar tooltip
                    if (_dmx >= _bx && _dmx <= _bx + _bw && _dmy >= _by && _dmy <= _by + _bh) {
                        var _item_name = variable_struct_exists(_req, "name") ? _req.name
                                       : (_rid != undefined ? _rid.name : _req.key);
                        if (variable_struct_exists(_req, "group_keys")) {
                            _tooltip_str = string(_req.qty) + " " + _item_name + " (cualquier tipo o color)";
                        } else {
                            _tooltip_str = string(_req.qty) + " piezas de " + _item_name;
                        }
                        _tooltip_x = _dmx;
                        _tooltip_y = _by - 6;
                    }
                }

                // dibujar tooltip encima de todo
                if (_tooltip_str != "") {
                    draw_set_font(fnt_pixel_operator);
                    var _tw = string_width(_tooltip_str) * 1.3 + 16;
                    var _th = 24;
                    var _tx = clamp(_tooltip_x - _tw / 2, _px1 + 6, _px2 - _tw - 6);
                    var _ty = _tooltip_y - _th;
                    draw_set_alpha(0.88);
                    draw_roundrect_color_ext(_tx, _ty, _tx + _tw, _ty + _th, 4, 4, c_black, c_black, false);
                    draw_set_alpha(1.0);
                    draw_roundrect_color_ext(_tx, _ty, _tx + _tw, _ty + _th, 4, 4, c_silver, c_silver, true);
                    draw_set_halign(fa_center);
                    draw_set_valign(fa_middle);
                    draw_set_color(c_white);
                    draw_text_transformed(_tx + _tw / 2, _ty + _th / 2, _tooltip_str, 1.3, 1.3, 0);
                }
            } else if (_is_bs && variable_struct_exists(_entry, "is_upgrade") && _entry.is_upgrade) {
                // --- Herreria: mejora de herramientas con cajas dinamicas ---
                var _tool_key     = _entry.item_key;
                var _tool_quality = scr_get_tool_quality(_tool_key, _p);
                var _tool_data    = scr_get_item_data(_tool_key);

                // Informacion de calidad debajo del nombre
                if (_tool_data != undefined) {
                    if (_tool_quality >= 0 && _tool_quality < QUALITY.VITOLANIO) {
                        draw_set_halign(fa_left);
                        draw_set_valign(fa_middle);
                        draw_text_transformed_color(_px1 + 52, _ry + _row / 2 + 14, 
                            global.quality_names[_tool_quality] + " > " + global.quality_names[_tool_quality + 1],
                            1.2, 1.2, 0, c_yellow, c_yellow, c_orange, c_orange, 1.0);
                    } else if (_tool_quality >= QUALITY.VITOLANIO) {
                        draw_set_halign(fa_left);
                        draw_set_valign(fa_middle);
                        draw_text_transformed_color(_px1 + 52, _ry + _row / 2 + 14,
                            global.quality_names[QUALITY.VITOLANIO] + " (MAX)",
                            1.2, 1.2, 0, c_yellow, c_yellow, c_orange, c_orange, 1.0);
                    }
                }

                var _can_upgrade = (_tool_quality >= 0 && _tool_quality < QUALITY.VITOLANIO);
                var _reqs = _can_upgrade ? scr_get_upgrade_requirements(_tool_quality) : undefined;

                if (_reqs != undefined) {
                    var _can_afford_money  = (_p.money >= _reqs.price_money);
                    var _bw   = 96;
                    var _bh   = 48;
                    var _gap  = 6;
                    var _n_ingr = array_length(_reqs.price_items);
                    var _ingr_total_w = (_n_ingr + 1) * _bw + _n_ingr * _gap;
                    var _ix0  = _px2 - 14 - _ingr_total_w;
                    var _iy0  = _ry + (_row - _bh) / 2;
                    var _tooltip_str = "";
                    var _tooltip_x   = 0;
                    var _tooltip_y   = 0;

                    // caja de dinero
                    var _mx_box = _ix0 + _n_ingr * (_bw + _gap);
                    draw_set_alpha(0.45);
                    draw_roundrect_color_ext(_mx_box, _iy0, _mx_box + _bw, _iy0 + _bh, 5, 5,
                        _can_afford_money ? make_color_rgb(10,40,10) : make_color_rgb(50,10,10),
                        _can_afford_money ? make_color_rgb(10,40,10) : make_color_rgb(50,10,10), false);
                    draw_set_alpha(1.0);
                    draw_roundrect_color_ext(_mx_box, _iy0, _mx_box + _bw, _iy0 + _bh, 5, 5,
                        _can_afford_money ? c_lime : c_red, _can_afford_money ? c_lime : c_red, true);
                    draw_set_halign(fa_center);
                    draw_set_valign(fa_middle);
                    draw_set_color(_can_afford_money ? c_lime : c_red);
                    draw_set_font(fnt_pixel_operator);
                    draw_text_transformed(_mx_box + _bw / 2, _iy0 + _bh / 2 - 6, "MXN$", 1.2, 1.2, 0);
                    draw_text_transformed(_mx_box + _bw / 2, _iy0 + _bh / 2 + 10, string(_reqs.price_money), 1.4, 1.4, 0);

                    if (_dmx >= _mx_box && _dmx <= _mx_box + _bw && _dmy >= _iy0 && _dmy <= _iy0 + _bh) {
                        _tooltip_str = "MXN$ " + string(_reqs.price_money);
                        _tooltip_x = _dmx;
                        _tooltip_y = _iy0 - 6;
                    }

                    // cajas de ingredientes
                    for (var _j = 0; _j < _n_ingr; _j++) {
                        var _req  = _reqs.price_items[_j];
                        var _rid  = scr_get_item_data(_req.key);
                        var _have = scr_count_item(_req.key, _p);
                        var _ok   = (_have >= _req.qty);
                        var _bx   = _ix0 + _j * (_bw + _gap);
                        var _by   = _iy0;

                        draw_set_alpha(0.45);
                        draw_roundrect_color_ext(_bx, _by, _bx + _bw, _by + _bh, 5, 5,
                            _ok ? make_color_rgb(10,40,10) : make_color_rgb(50,10,10),
                            _ok ? make_color_rgb(10,40,10) : make_color_rgb(50,10,10), false);
                        draw_set_alpha(1.0);
                        draw_roundrect_color_ext(_bx, _by, _bx + _bw, _by + _bh, 5, 5,
                            _ok ? c_lime : c_red, _ok ? c_lime : c_red, true);

                        if (_rid != undefined) {
                            var _rf  = variable_struct_exists(_rid, "row") ? (_rid.row * 3) + _rid.subimg : _rid.subimg;
                            var _rsz = 16 / max(sprite_get_width(_rid.sprite), sprite_get_height(_rid.sprite));
                            draw_sprite_ext(_rid.sprite, _rf, _bx + 10, _by + _bh / 2 - 17, 2.4 * _rsz, 2.4 * _rsz, 0, c_white, 1.0);
                        }

                        draw_set_font(fnt_pixel_operator);
                        draw_set_halign(fa_center);
                        draw_set_valign(fa_middle);
                        draw_set_color(_ok ? c_lime : c_red);
                        draw_text_transformed(_bx + 68, _by + _bh / 2, string(_req.qty), 1.6, 1.6, 0);

                        if (_dmx >= _bx && _dmx <= _bx + _bw && _dmy >= _by && _dmy <= _by + _bh) {
                            var _item_name = _rid != undefined ? _rid.name : _req.key;
                            _tooltip_str = string(_req.qty) + " piezas de " + _item_name;
                            _tooltip_x = _dmx;
                            _tooltip_y = _by - 6;
                        }
                    }

                    if (_tooltip_str != "") {
                        draw_set_font(fnt_pixel_operator);
                        var _tw = string_width(_tooltip_str) * 1.3 + 16;
                        var _th = 24;
                        var _tx = clamp(_tooltip_x - _tw / 2, _px1 + 6, _px2 - _tw - 6);
                        var _ty = _tooltip_y - _th;
                        draw_set_alpha(0.88);
                        draw_roundrect_color_ext(_tx, _ty, _tx + _tw, _ty + _th, 4, 4, c_black, c_black, false);
                        draw_set_alpha(1.0);
                        draw_roundrect_color_ext(_tx, _ty, _tx + _tw, _ty + _th, 4, 4, c_silver, c_silver, true);
                        draw_set_halign(fa_center);
                        draw_set_valign(fa_middle);
                        draw_set_color(c_white);
                        draw_text_transformed(_tx + _tw / 2, _ty + _th / 2, _tooltip_str, 1.3, 1.3, 0);
                    }
                } else {
                    // Sin mejora disponible
                    draw_set_halign(fa_right);
                    draw_set_valign(fa_middle);
                    if (_tool_quality < 0) {
                        draw_set_color(c_red);
                        draw_text_transformed(_px2 - 14, _ry + _row / 2, "No tienes esta herramienta", 1.3, 1.3, 0);
                    } else if (_tool_quality >= QUALITY.VITOLANIO) {
                        draw_set_color(c_yellow);
                        draw_text_transformed(_px2 - 14, _ry + _row / 2, "MAXIMO", 1.3, 1.3, 0);
                    }
                }
            } else {
                // --- Precio en texto para tiendas NPC ---
                var _price_str = (_entry.price_money > 0) ? "MXN$ " + string(_entry.price_money) : "";
                for (var _j = 0; _j < array_length(_entry.price_items); _j++) {
                    var _req      = _entry.price_items[_j];
                    var _req_name = variable_struct_exists(_req, "name") ? _req.name
                                  : (scr_get_item_data(_req.key) != undefined ? scr_get_item_data(_req.key).name : _req.key);
                    if (_price_str != "") _price_str += " + ";
                    _price_str += string(_req.qty) + " " + _req_name;
                }
                var _can_afford = _p.money >= _entry.price_money;
                var _draw_items_ok = true;
                for (var _dj = 0; _dj < array_length(_entry.price_items); _dj++) {
                    var _dreq  = _entry.price_items[_dj];
                    var _dhave = variable_struct_exists(_dreq, "group_keys")
                        ? scr_count_item_group(_dreq.group_keys, _p)
                        : scr_count_item(_dreq.key, _p);
                    if (_dhave < _dreq.qty) { _draw_items_ok = false; break; }
                }
                var _price_col = (_can_afford && _draw_items_ok) ? c_lime : c_red;
                draw_set_halign(fa_right);
                draw_set_valign(fa_middle);
                draw_text_transformed_color(_px2 - 14, _ry + _row / 2, _price_str, 1.3, 1.3, 0, _price_col, _price_col, _price_col, _price_col, 1.0);
            }
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

    var _footer_line_y = _py2 - (_wb_or_bs ? 50 : 38);
    draw_set_color(c_silver);
    draw_line(_px1 + 10, _footer_line_y, _px2 - 10, _footer_line_y);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_text_transformed_color(_px1 + 14, _footer_line_y + 16, "MXN$ " + string(_p.money), 1.4, 1.4, 0, c_lime, c_lime, c_green, c_green, 1.0);

    if (_p.shop_msg_timer > 0) {
        var _msg_alpha = min(1.0, _p.shop_msg_timer / 20.0);
        draw_set_halign(fa_right);
        draw_text_transformed_color(_px2 - 14, _footer_line_y + 16, _p.shop_msg, 1.4, 1.4, 0, c_yellow, c_yellow, c_yellow, c_yellow, _msg_alpha);
    }
}

// === DONATIVO TOWN ===
if (_p.donation_box_open) {
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    var _pw = 720;
    var _ph = 600;
    var _px1 = (_gw - _pw) / 2;
    var _py1 = _gh * 0.08;
    var _px2 = _px1 + _pw;
    var _py2 = _py1 + _ph;

    // Fondo overlay
    draw_set_alpha(0.72);
    draw_rectangle_color(0, 0, _gw, _gh, c_black, c_black, c_black, c_black, false);
    draw_set_alpha(1.0);

    // Panel
    draw_set_alpha(0.93);
    draw_roundrect_color_ext(_px1, _py1, _px2, _py2, 12, 12, c_dkgray, c_dkgray, false);
    draw_set_alpha(1.0);
    draw_roundrect_color_ext(_px1, _py1, _px2, _py2, 12, 12, c_silver, c_silver, true);

    // Header
    var _stage = global.town_stage;
    var _stage_name = scr_get_town_stage_name(_stage);
    draw_set_font(fnt_pixel_operator);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_text_transformed_color(_px1 + _pw / 2, _py1 + 12, "Donativos: " + _stage_name, 2.0, 2.0, 0, c_yellow, c_yellow, c_orange, c_orange, 1.0);

    var _header_line_y = _py1 + 60;
    draw_set_color(c_silver);
    draw_line(_px1 + 10, _header_line_y, _px2 - 10, _header_line_y);

    // ESC hint
    draw_set_halign(fa_right);
    draw_set_valign(fa_top);
    draw_set_color(c_silver);
    draw_text_transformed(_px2 - 14, _py1 + 16, "[ESC] Cerrar", 1.1, 1.1, 0);

    // Lista de requirements
    var _reqs = scr_get_town_stage_donations(_stage);
    var _req_keys = variable_struct_get_names(_reqs);
    var _row_h = 56;
    var _list_y = _header_line_y + 8;

    var _dmx = device_mouse_x_to_gui(0);
    var _dmy = device_mouse_y_to_gui(0);

    var _click = mouse_check_button_pressed(mb_left);
    var _row_clicked = -1;

    for (var _ri = 0; _ri < array_length(_req_keys); _ri++) {
        var _rk     = _req_keys[_ri];
        var _need   = _reqs[$ _rk];
        var _have   = scr_get_donation_progress(_rk);
        var _ok     = (_have >= _need);
        var _ry     = _list_y + _ri * _row_h;
        var _hovered = (_dmx >= _px1 + 8 && _dmx <= _px2 - 8 && _dmy >= _ry && _dmy <= _ry + _row_h - 4);

        // Fila background
        var _row_col = (_ri mod 2 == 0) ? make_color_rgb(50, 50, 55) : make_color_rgb(38, 38, 42);
        if (_ok) _row_col = make_color_rgb(20, 60, 20);
        draw_set_alpha(_hovered && !_ok ? 0.85 : 0.5);
        draw_roundrect_color_ext(_px1 + 8, _ry, _px2 - 8, _ry + _row_h - 4, 6, 6, _row_col, _row_col, false);
        draw_set_alpha(1.0);
        if (_hovered && !_ok) {
            draw_roundrect_color_ext(_px1 + 8, _ry, _px2 - 8, _ry + _row_h - 4, 6, 6, c_white, c_white, true);
            if (_click) _row_clicked = _ri;
        }

        // Checkbox
        var _cb_size = 24;
        var _cb_x = _px1 + 20;
        var _cb_y = _ry + (_row_h - 4 - _cb_size) / 2;
        draw_set_alpha(1.0);
        draw_rectangle_color(_cb_x, _cb_y, _cb_x + _cb_size, _cb_y + _cb_size, c_black, c_black, c_black, c_black, false);
        var _cb_border = _ok ? c_lime : c_silver;
        draw_rectangle_color(_cb_x, _cb_y, _cb_x + _cb_size, _cb_y + _cb_size, _cb_border, _cb_border, _cb_border, _cb_border, true);
        if (_ok) {
            draw_set_color(c_lime);
            draw_line_width(_cb_x + 5, _cb_y + 12, _cb_x + 10, _cb_y + 18, 3);
            draw_line_width(_cb_x + 10, _cb_y + 18, _cb_x + 19, _cb_y + 6, 3);
        }

        // Icono y nombre
        var _disp = scr_get_donation_target_display(_rk);
        var _icon_x = _cb_x + _cb_size + 16;
        var _icon_y = _ry + (_row_h - 4) / 2;
        if (_disp.sprite != -1) {
            var _scl = 32 / max(sprite_get_width(_disp.sprite), sprite_get_height(_disp.sprite));
            draw_sprite_ext(_disp.sprite, _disp.subimg, _icon_x - 11, _icon_y - 13, _scl, _scl, 0, c_white, 1.0);
        }

        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        draw_set_color(_ok ? c_lime : c_white);
        draw_text_transformed(_icon_x + 24, _icon_y, _disp.name, 1.4, 1.4, 0);

        // Progreso
        draw_set_halign(fa_right);
        draw_set_color(_ok ? c_lime : c_white);
        var _prog_str = string(_have) + " / " + string(_need);
        draw_text_transformed(_px2 - 24, _icon_y, _prog_str, 1.6, 1.6, 0);

        // Indicador "[Donar]" si aplica
        if (!_ok && _hovered) {
            var _avail = 0;
            // contar items aplicables del jugador
            var _arrs = [_p.inventory_array, _p.backpack_array];
            for (var _ai = 0; _ai < array_length(_arrs); _ai++) {
                var _arr = _arrs[_ai];
                for (var _si = 0; _si < array_length(_arr); _si++) {
                    var _slot = _arr[_si];
                    if (is_struct(_slot) && scr_match_donation_key(_rk, _slot.key)) {
                        _avail += _slot.quantity;
                    }
                }
            }
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            var _hint = (_avail > 0) ? "[Click] Donar (" + string(_avail) + " disp.)" : "Sin items";
            draw_text_transformed_color(_px1 + _pw / 2, _ry + _row_h - 12, _hint, 1.0, 1.0, 0, c_yellow, c_yellow, c_yellow, c_yellow, 0.85);
        }
    }

    // Footer
    var _footer_line_y = _py2 - 40;
    draw_set_color(c_silver);
    draw_line(_px1 + 10, _footer_line_y, _px2 - 10, _footer_line_y);

    if (_p.donation_msg_timer > 0) {
        var _alpha2 = min(1.0, _p.donation_msg_timer / 20.0);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text_transformed_color(_px1 + _pw / 2, _footer_line_y + 14, _p.donation_msg, 1.4, 1.4, 0, c_yellow, c_yellow, c_yellow, c_yellow, _alpha2);
        _p.donation_msg_timer -= 1;
    }

    // Procesar click
    if (_row_clicked != -1) {
        var _target = _req_keys[_row_clicked];
        var _res = scr_donate_specific_target(_target, _p);
        if (_res.completed) {
            _p.donation_msg = "Etapa completada!";
            _p.donation_msg_timer = 90;
            _p.donation_box_open = false;
            scr_notify("Etapa completada: " + _stage_name);
        } else if (_res.donated) {
            _p.donation_msg = "Donados " + string(_res.items_donated);
            _p.donation_msg_timer = 60;
        } else {
            _p.donation_msg = "No tienes items para donar.";
            _p.donation_msg_timer = 60;
        }
    }

    // ESC para cerrar
    if (keyboard_check_pressed(vk_escape)) {
        _p.donation_box_open = false;
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_set_alpha(1.0);
}
