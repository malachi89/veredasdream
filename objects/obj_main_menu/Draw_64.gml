var _cx = display_get_gui_width() * 0.5;
var _cy = display_get_gui_height() * 0.5;

draw_set_font(fnt_pixel_operator);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

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

// --- Normal menu ---
var _start_y = _cy - 50;
var _spacing = 40;

for (var i = 0; i < array_length(options); i++) {
    var _opt   = options[i];
    var _col   = (selected_index == i) ? c_yellow : c_white;
    var _scale = (selected_index == i) ? 3.2 : 2.8;

    if (_opt == "Continuar" && !save_exists) _col = c_gray;

    draw_text_transformed_color(_cx, _start_y + (i * _spacing), _opt, _scale, _scale, 0, _col, _col, _col, _col, 1.0);
}

if (notif_text != "") {
    draw_text_transformed_color(_cx, _cy + 220, notif_text, 1.5, 1.5, 0, c_white, c_white, c_white, c_white, 1.0);
}


