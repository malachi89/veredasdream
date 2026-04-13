// === 1. RELOJ Y CALENDARIO (Top Right) ===
var _gui_w = display_get_gui_width();
var _hour_str = string(global.game_hour);
if (global.game_hour < 10) _hour_str = "0" + _hour_str;
var _min_str = string(global.game_minute);
if (global.game_minute < 10) _min_str = "0" + _min_str;

var _time_text = _hour_str + ":" + _min_str;

// Calcular día de la semana (Empezando en Lunes para Año 1, Día 1)
// Total de días = (Año - 1) * 4 estaciones * días_por_estación + (Estación_index) * días_por_estación + (Día actual)
var _total_days = ((global.year - 1) * 4 * global.days_per_season) + (global.season_index * global.days_per_season) + global.day;
var _day_of_week_index = (_total_days - 1) mod 7;
var _day_name = global.day_names[_day_of_week_index];

var _date_text = global.season_names[$ global.season] + " " + string(global.day) + " " + _day_name;
var _money_text = "MXN$ " + string(global.money);

draw_set_font(fnt_pixel_operator);
draw_set_halign(fa_right);
draw_set_valign(fa_top);

var _padding = 10;
var _text_w = max(string_width(_time_text) * 1.5, string_width(_date_text), string_width(_money_text));
var _text_h = 85; // Altura aumentada para el dinero

var _rx = _gui_w - 20;
var _ry = 20;

// Fondo oscuro para resaltar
draw_set_alpha(0.5);
draw_roundrect_color_ext(_rx - _text_w - _padding, _ry - _padding, _rx + _padding, _ry + _text_h, 10, 10, c_black, c_black, false);
draw_set_alpha(1.0);

// Sombra para el tiempo
draw_text_transformed_color(_rx + 2, _ry + 2, _time_text, 1.5, 1.5, 0, c_black, c_black, c_black, c_black, 0.5);
// Texto del tiempo
draw_text_transformed_color(_rx, _ry, _time_text, 1.5, 1.5, 0, c_yellow, c_yellow, c_orange, c_orange, 1.0);

// Sombra para la fecha
draw_text_color(_rx + 1, _ry + 35 + 1, _date_text, c_black, c_black, c_black, c_black, 0.5);
// Texto de la fecha
draw_text_color(_rx, _ry + 35, _date_text, c_white, c_white, c_white, c_white, 1.0);

// Texto del dinero (MXN$)
draw_text_color(_rx + 1, _ry + 60 + 1, _money_text, c_black, c_black, c_black, c_black, 0.5);
draw_text_color(_rx, _ry + 60, _money_text, c_lime, c_lime, c_green, c_green, 1.0);