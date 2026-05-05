var _cx = display_get_gui_width() * 0.5;
var _cy = display_get_gui_height() * 0.5;

draw_set_font(fnt_pixel_operator);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// === NAME ENTRY SCREEN (checked first to override slot selection) ===
if (name_entry_mode) {
    draw_set_alpha(0.7);
    draw_rectangle_color(0, 0, display_get_gui_width(), display_get_gui_height(), c_black, c_black, c_black, c_black, false);
    draw_set_alpha(1.0);

    draw_text_transformed_color(_cx, _cy - 110, "NUEVA GRANJA", 2.5, 2.5, 0, c_white, c_white, c_white, c_white, 1.0);

    // Farm name field
    draw_set_halign(fa_right);
    draw_set_valign(fa_middle);
    draw_text_transformed_color(_cx - 20, _cy - 40, "Nombre de la granja:", 1.6, 1.6, 0, c_white, c_white, c_white, c_white, 1.0);

    var _fn_bx = _cx + 10;
    var _fn_by = _cy - 56;
    var _fn_bw = 320;
    var _fn_bh = 36;
    var _fn_col = (name_entry_field == 0) ? make_color_rgb(50, 80, 50) : c_dkgray;
    draw_set_alpha(0.85);
    draw_roundrect_color_ext(_fn_bx, _fn_by, _fn_bx + _fn_bw, _fn_by + _fn_bh, 6, 6, _fn_col, _fn_col, false);
    draw_set_alpha(1.0);
    draw_roundrect_color_ext(_fn_bx, _fn_by, _fn_bx + _fn_bw, _fn_by + _fn_bh, 6, 6, make_color_rgb(100, 140, 80), make_color_rgb(100, 140, 80), true);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    var _fn_display = farm_name_input;
    if (name_entry_field == 0 && current_time mod 800 < 400) _fn_display += "|";
    draw_text_transformed_color(_fn_bx + 10, _fn_by + _fn_bh * 0.5, _fn_display, 1.6, 1.6, 0, c_lime, c_lime, c_lime, c_lime, 1.0);

    // Player name field
    draw_set_halign(fa_right);
    draw_set_valign(fa_middle);
    draw_text_transformed_color(_cx - 20, _cy + 30, "Nombre del jugador:", 1.6, 1.6, 0, c_white, c_white, c_white, c_white, 1.0);

    var _pn_bx = _cx + 10;
    var _pn_by = _cy + 14;
    var _pn_bw = 320;
    var _pn_bh = 36;
    var _pn_col = (name_entry_field == 1) ? make_color_rgb(50, 80, 50) : c_dkgray;
    draw_set_alpha(0.85);
    draw_roundrect_color_ext(_pn_bx, _pn_by, _pn_bx + _pn_bw, _pn_by + _pn_bh, 6, 6, _pn_col, _pn_col, false);
    draw_set_alpha(1.0);
    draw_roundrect_color_ext(_pn_bx, _pn_by, _pn_bx + _pn_bw, _pn_by + _pn_bh, 6, 6, make_color_rgb(100, 140, 80), make_color_rgb(100, 140, 80), true);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    var _pn_display = player_name_input;
    if (name_entry_field == 1 && current_time mod 800 < 400) _pn_display += "|";
    draw_text_transformed_color(_pn_bx + 10, _pn_by + _pn_bh * 0.5, _pn_display, 1.6, 1.6, 0, c_lime, c_lime, c_lime, c_lime, 1.0);

    // Confirm button
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);
    var _btn_w = 240;
    var _btn_h = 50;
    var _btn_x1 = _cx - _btn_w * 0.5;
    var _btn_y1 = _cy + 100;
    var _btn_x2 = _btn_x1 + _btn_w;
    var _btn_y2 = _btn_y1 + _btn_h;

    var _btn_hover = point_in_rectangle(_mx, _my, _btn_x1, _btn_y1, _btn_x2, _btn_y2);
    var _btn_col = _btn_hover ? make_color_rgb(85, 120, 80) : make_color_rgb(65, 90, 60);
    var _border_col = _btn_hover ? make_color_rgb(140, 200, 120) : make_color_rgb(100, 140, 80);
    var _can_confirm = (farm_name_input != "" && player_name_input != "");
    if (!_can_confirm) { _btn_col = c_dkgray; _border_col = c_gray; }

    draw_set_alpha(0.3);
    draw_roundrect_color_ext(_btn_x1, _btn_y1, _btn_x2, _btn_y2, 10, 10, _btn_col, _btn_col, false);
    draw_set_alpha(1.0);
    draw_roundrect_color_ext(_btn_x1, _btn_y1, _btn_x2, _btn_y2, 10, 10, _border_col, _border_col, true);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed_color(_cx, _btn_y1 + _btn_h * 0.5, "CONFIRMAR", 1.8, 1.8, 0, c_white, c_white, c_white, c_white, 1.0);

    // Hint text
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_text_transformed_color(_cx, display_get_gui_height() - 30, "[Tab] Cambiar campo  [Enter] Confirmar  [Esc] Volver", 1.2, 1.2, 0, c_silver, c_silver, c_silver, c_silver, 1.0);

    if (notif_text != "") {
        draw_text_transformed_color(_cx, _cy + 175, notif_text, 1.2, 1.2, 0, c_red, c_red, c_red, c_red, 1.0);
    }

    exit;
}

// === CONFIRM OVERWRITE ===
if (confirm_overwrite) {
    draw_set_alpha(0.7);
    draw_rectangle_color(0, 0, display_get_gui_width(), display_get_gui_height(), c_black, c_black, c_black, c_black, false);
    draw_set_alpha(1.0);

    draw_text_transformed_color(_cx, _cy - 20, "ESTE SLOT YA TIENE UNA PARTIDA", 2.0, 2.0, 0, c_red, c_red, c_red, c_red, 1.0);
    draw_text_transformed_color(_cx, _cy + 15, "SE BORRARAN LOS DATOS EXISTENTES", 1.6, 1.6, 0, c_red, c_red, c_red, c_red, 1.0);
    draw_text_transformed_color(_cx, _cy + 50, "Quieres sobrescribir?", 1.4, 1.4, 0, c_white, c_white, c_white, c_white, 1.0);

    var _btn_w = 120;
    var _btn_h = 40;
    var _no_x1 = _cx - _btn_w - 10;
    var _no_y1 = _cy + 80;
    var _yes_x1 = _cx + 10;
    var _yes_y1 = _cy + 80;
    var _no_x2 = _no_x1 + _btn_w;
    var _no_y2 = _no_y1 + _btn_h;
    var _yes_x2 = _yes_x1 + _btn_w;
    var _yes_y2 = _yes_y1 + _btn_h;

    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);

    // No button
    var _no_hover = point_in_rectangle(_mx, _my, _no_x1, _no_y1, _no_x2, _no_y2);
    var _no_col = (confirm_selection == 0) ? ( _no_hover ? c_red : c_maroon ) : c_dkgray;
    draw_roundrect_color_ext(_no_x1, _no_y1, _no_x2, _no_y2, 6, 6, _no_col, _no_col, false);
    draw_roundrect_color_ext(_no_x1, _no_y1, _no_x2, _no_y2, 6, 6, c_white, c_white, true);
    draw_text_transformed_color((_no_x1 + _no_x2) * 0.5, (_no_y1 + _no_y2) * 0.5, "No", 1.6, 1.6, 0, c_white, c_white, c_white, c_white, 1.0);

    // Yes button
    var _yes_hover = point_in_rectangle(_mx, _my, _yes_x1, _yes_y1, _yes_x2, _yes_y2);
    var _yes_col = (confirm_selection == 1) ? ( _yes_hover ? c_lime : c_green ) : c_dkgray;
    draw_roundrect_color_ext(_yes_x1, _yes_y1, _yes_x2, _yes_y2, 6, 6, _yes_col, _yes_col, false);
    draw_roundrect_color_ext(_yes_x1, _yes_y1, _yes_x2, _yes_y2, 6, 6, c_white, c_white, true);
    draw_text_transformed_color((_yes_x1 + _yes_x2) * 0.5, (_yes_y1 + _yes_y2) * 0.5, "Si", 1.6, 1.6, 0, c_black, c_black, c_black, c_black, 1.0);

    exit;
}

// === CONFIRM DELETE ===
if (confirm_delete) {
    draw_set_alpha(0.7);
    draw_rectangle_color(0, 0, display_get_gui_width(), display_get_gui_height(), c_black, c_black, c_black, c_black, false);
    draw_set_alpha(1.0);

    draw_text_transformed_color(_cx, _cy - 10, "SE BORRARA ESTA PARTIDA", 2.0, 2.0, 0, c_red, c_red, c_red, c_red, 1.0);
    draw_text_transformed_color(_cx, _cy + 30, "Quieres borrar esta partida?", 1.4, 1.4, 0, c_white, c_white, c_white, c_white, 1.0);

    var _btn_w = 120;
    var _btn_h = 40;
    var _no_x1 = _cx - _btn_w - 10;
    var _no_y1 = _cy + 70;
    var _yes_x1 = _cx + 10;
    var _yes_y1 = _cy + 70;
    var _no_x2 = _no_x1 + _btn_w;
    var _no_y2 = _no_y1 + _btn_h;
    var _yes_x2 = _yes_x1 + _btn_w;
    var _yes_y2 = _yes_y1 + _btn_h;

    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);

    var _no_hover = point_in_rectangle(_mx, _my, _no_x1, _no_y1, _no_x2, _no_y2);
    var _no_col = (confirm_selection == 0) ? ( _no_hover ? c_red : c_maroon ) : c_dkgray;
    draw_roundrect_color_ext(_no_x1, _no_y1, _no_x2, _no_y2, 6, 6, _no_col, _no_col, false);
    draw_roundrect_color_ext(_no_x1, _no_y1, _no_x2, _no_y2, 6, 6, c_white, c_white, true);
    draw_text_transformed_color((_no_x1 + _no_x2) * 0.5, (_no_y1 + _no_y2) * 0.5, "No", 1.6, 1.6, 0, c_white, c_white, c_white, c_white, 1.0);

    var _yes_hover = point_in_rectangle(_mx, _my, _yes_x1, _yes_y1, _yes_x2, _yes_y2);
    var _yes_col = (confirm_selection == 1) ? ( _yes_hover ? c_lime : c_green ) : c_dkgray;
    draw_roundrect_color_ext(_yes_x1, _yes_y1, _yes_x2, _yes_y2, 6, 6, _yes_col, _yes_col, false);
    draw_roundrect_color_ext(_yes_x1, _yes_y1, _yes_x2, _yes_y2, 6, 6, c_white, c_white, true);
    draw_text_transformed_color((_yes_x1 + _yes_x2) * 0.5, (_yes_y1 + _yes_y2) * 0.5, "Si", 1.6, 1.6, 0, c_black, c_black, c_black, c_black, 1.0);

    exit;
}

// === SLOT SELECTION SCREEN ===
if (slot_select_mode != "") {
    draw_set_alpha(0.7);
    draw_rectangle_color(0, 0, display_get_gui_width(), display_get_gui_height(), c_black, c_black, c_black, c_black, false);
    draw_set_alpha(1.0);

    // Title
    var _title = "";
    if (slot_select_mode == "new") _title = "SELECCIONA UN SLOT PARA TU NUEVA GRANJA";
    else if (slot_select_mode == "continue") _title = "SELECCIONA UNA PARTIDA";
    else if (slot_select_mode == "host") _title = "SELECCIONA UN SLOT PARA HOSPEDAR";
    else if (slot_select_mode == "delete") _title = "SELECCIONA LA PARTIDA A BORRAR";
    draw_text_transformed_color(_cx, _cy - 160, _title, 1.8, 1.8, 0, c_white, c_white, c_white, c_white, 1.0);

    var _box_w = 400;
    var _box_h = 80;
    var _spacing = 12;
    var _start_y = _cy - ((3 * _box_h + 2 * _spacing) * 0.5) - 40;

    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);

    for (var _i = 0; _i < 3; _i++) {
        var _bx1 = _cx - _box_w * 0.5;
        var _by1 = _start_y + _i * (_box_h + _spacing);
        var _bx2 = _bx1 + _box_w;
        var _by2 = _by1 + _box_h;

        var _is_hover = (_mx >= _bx1 && _mx <= _bx2 && _my >= _by1 && _my <= _by2);
        var _is_selected = (slot_selected == _i + 1);

        // Box background
        var _box_col = c_dkgray;
        if (_is_selected && _is_hover) _box_col = make_color_rgb(80, 100, 80);
        else if (_is_selected) _box_col = make_color_rgb(60, 80, 60);
        else if (_is_hover) _box_col = make_color_rgb(60, 60, 70);

        draw_set_alpha(0.9);
        draw_roundrect_color_ext(_bx1, _by1, _bx2, _by2, 8, 8, _box_col, _box_col, false);
        draw_set_alpha(1.0);

        // Border
        var _border_col = _is_selected ? c_lime : c_white;
        draw_roundrect_color_ext(_bx1, _by1, _bx2, _by2, 8, 8, _border_col, _border_col, true);

        // Slot number
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        draw_text_transformed_color(_bx1 + 20, _by1 + _box_h * 0.5, string(_i + 1) + ".", 2.0, 2.0, 0, _border_col, _border_col, _border_col, _border_col, 1.0);

        if (slot_occupied[_i] && is_struct(slot_info[_i])) {
            var _info = slot_info[_i];
            var _fname = (_info.farm_name != "") ? _info.farm_name : "Granja sin nombre";
            var _pname = (_info.player_name != "") ? _info.player_name : "Jugador";
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
            draw_text_transformed_color(_bx1 + 60, _by1 + 12, _fname, 1.6, 1.6, 0, c_yellow, c_yellow, c_orange, c_orange, 1.0);
            var _season_name = global.season_names[$ _info.season];
            draw_text_transformed_color(_bx1 + 60, _by1 + 42, _pname + " - Dia " + string(_info.day) + " de " + _season_name + ", Ano " + string(_info.year), 1.2, 1.2, 0, c_silver, c_silver, c_silver, c_silver, 1.0);
        } else {
            draw_set_halign(fa_left);
            draw_set_valign(fa_middle);
            draw_set_color(c_gray);
            draw_text_transformed(_bx1 + 60, _by1 + _box_h * 0.5, "Vacio", 1.6, 1.6, 0);
        }
    }

    // Back button
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(c_silver);
    draw_text_transformed_color(_cx, display_get_gui_height() - 30, "[Esc] Volver", 1.4, 1.4, 0, c_silver, c_silver, c_silver, c_silver, 1.0);

    if (notif_text != "") {
        draw_text_transformed_color(_cx, _cy + 200, notif_text, 1.5, 1.5, 0, c_white, c_white, c_white, c_white, 1.0);
    }

    exit;
}

// --- IP entry overlay ---
if (ip_entry_mode) {
    draw_set_alpha(0.7);
    draw_rectangle_color(0, 0, display_get_gui_width(), display_get_gui_height(), c_black, c_black, c_black, c_black, false);
    draw_set_alpha(1.0);

    draw_text_transformed_color(_cx, _cy - 60, "IP del anfitrion:", 2.5, 2.5, 0, c_white, c_white, c_white, c_white, 1.0);

    var _bw = 420;
    var _bh = 50;
    var _bx1 = _cx - _bw / 2;
    var _by1 = _cy - _bh / 2;
    draw_set_alpha(0.8);
    draw_rectangle_color(_bx1, _by1, _bx1 + _bw, _by1 + _bh, c_dkgray, c_dkgray, c_dkgray, c_dkgray, false);
    draw_set_alpha(1.0);
    draw_rectangle_color(_bx1, _by1, _bx1 + _bw, _by1 + _bh, c_white, c_white, c_white, c_white, true);

    var _scale  = 2.2;
    var _display = keyboard_string;
    if (current_time mod 800 < 400) _display += "|";
    draw_text_transformed_color(_cx, _cy, _display, _scale, _scale, 0, c_lime, c_lime, c_lime, c_lime, 1.0);

    draw_text_transformed_color(_cx, _cy + 55, "[Enter] Conectar   [Esc] Cancelar", 1.4, 1.4, 0, c_silver, c_silver, c_silver, c_silver, 1.0);
    exit;
}

// --- Waiting for connection ---
if (connect_waiting) {
    draw_text_transformed_color(_cx, _cy, "Conectando...", 3.0, 3.0, 0, c_yellow, c_yellow, c_orange, c_orange, 1.0);
    exit;
}

// --- Options menu ---
if (options_menu_open) {
    var _cx = display_get_gui_width() * 0.5;
    var _cy = display_get_gui_height() * 0.5;

    draw_set_alpha(0.7);
    draw_rectangle_color(0, 0, display_get_gui_width(), display_get_gui_height(), c_black, c_black, c_black, c_black, false);
    draw_set_alpha(1.0);

    draw_set_alpha(0.92);
    draw_roundrect_color_ext(_cx - 300, _cy - 130, _cx + 300, _cy + 150, 12, 12, c_dkgray, c_dkgray, false);
    draw_set_alpha(1.0);
    draw_roundrect_color_ext(_cx - 300, _cy - 130, _cx + 300, _cy + 150, 12, 12, c_white, c_white, true);

    draw_set_font(fnt_pixel_operator);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed_color(_cx, _cy - 105, "OPCIONES", 2.5, 2.5, 0, c_white, c_white, c_white, c_white, 1.0);

    var _item_count = array_length(settings_items);
    var _total_rows = _item_count + 2;
    var _spacing = 38;
    var _start_y = _cy - 70;

    for (var i = 0; i < _total_rows; i++) {
        var _oy = _start_y + i * _spacing;
        var _is_selected = (options_selection == i);

        if (i < _item_count) {
            var _item = settings_items[i];
            draw_set_halign(fa_left);
            draw_text_transformed_color(_cx - 270, _oy, _item.label, 1.4, 1.4, 0, c_white, c_white, c_white, c_white, 1.0);

            draw_set_halign(fa_right);
            var _val_text = _item.display[_item.value_index];
            if (_is_selected && array_length(_item.values) > 1) {
                draw_text_transformed_color(_cx + 270, _oy, "< " + _val_text + " >", 1.4, 1.4, 0, c_yellow, c_yellow, c_yellow, c_yellow, 1.0);
            } else {
                draw_text_transformed_color(_cx + 270, _oy, _val_text, 1.4, 1.4, 0, c_white, c_white, c_white, c_white, 1.0);
            }
        } else {
            draw_set_halign(fa_center);
            var _btn_text = (i == _item_count) ? "Guardar y Volver" : "Volver";
            var _btn_col = _is_selected ? c_yellow : c_white;
            draw_text_transformed_color(_cx, _oy, _btn_text, 1.6, 1.6, 0, _btn_col, _btn_col, _btn_col, _btn_col, 1.0);
        }
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1.0);
    exit;
}

// --- Normal menu ---
var _start_y = _cy - 50;
var _spacing = 40;

for (var i = 0; i < array_length(options); i++) {
    var _opt   = options[i];
    var _col   = (selected_index == i) ? c_yellow : c_white;
    var _scale = (selected_index == i) ? 3.2 : 2.8;

    draw_text_transformed_color(_cx, _start_y + (i * _spacing), _opt, _scale, _scale, 0, _col, _col, _col, _col, 1.0);
}

if (notif_text != "") {
    draw_text_transformed_color(_cx, _cy + 220, notif_text, 1.5, 1.5, 0, c_white, c_white, c_white, c_white, 1.0);
}
