var _cx = display_get_gui_width() * 0.5;
var _cy = display_get_gui_height() * 0.5;

// Título
draw_set_font(fnt_pixel_operator);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_text_transformed_color(_cx, _cy - 200, "VEREDAS DREAM", 4.0, 4.0, 0, c_white, c_white, c_yellow, c_yellow, 1.0);

// Opciones
var _start_y = _cy - 50;
var _spacing = 40;

for (var i = 0; i < array_length(options); i++) {
    var _opt = options[i];
    var _col = (selected_index == i) ? c_yellow : c_white;
    var _scale = (selected_index == i) ? 2.2 : 1.8;
    
    // Si es "Continuar" y no hay guardado, dibujarlo atenuado?
    if (_opt == "Continuar" && !save_exists) {
        _col = c_gray;
    }
    
    draw_text_transformed_color(_cx, _start_y + (i * _spacing), _opt, _scale, _scale, 0, _col, _col, _col, _col, 1.0);
}

// Notificación
if (notif_text != "") {
    draw_text_transformed_color(_cx, _cy + 220, notif_text, 1.5, 1.5, 0, c_white, c_white, c_white, c_white, 1.0);
}
