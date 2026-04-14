var _gui_w = display_get_gui_width();
var _hour_str = string(global.game_hour);
if (global.game_hour < 10) _hour_str = "0" + _hour_str;
var _min_str = string(global.game_minute);
if (global.game_minute < 10) _min_str = "0" + _min_str;
var _time_text = _hour_str + ":" + _min_str;
var _total_days = ((global.year - 1) * 4 * global.days_per_season) + (global.season_index * global.days_per_season) + global.day;
var _day_name = global.day_names[(_total_days - 1) mod 7];
var _date_text = global.season_names[$ global.season] + " " + string(global.day) + " " + _day_name;
var _money_text = "MXN$ " + string(global.money);

draw_set_font(fnt_pixel_operator);
draw_set_halign(fa_right);
draw_set_valign(fa_top);

var _padding = 10;
var _text_w = max(string_width(_time_text) * 3.0, string_width(_date_text) * 2.0, string_width(_money_text) * 2.0);
var _rx = _gui_w - 20;
var _ry = 20;

draw_set_alpha(0.5);
draw_roundrect_color_ext(_rx - _text_w - _padding, _ry - _padding, _rx + _padding, _ry + 135, 10, 10, c_black, c_black, false);
draw_set_alpha(1.0);
draw_text_transformed_color(_rx + 2, _ry + 2, _time_text, 3.0, 3.0, 0, c_black, c_black, c_black, c_black, 0.5);
draw_text_transformed_color(_rx, _ry, _time_text, 3.0, 3.0, 0, c_yellow, c_yellow, c_orange, c_orange, 1.0);
draw_text_transformed_color(_rx + 1, _ry + 56, _date_text, 2.0, 2.0, 0, c_black, c_black, c_black, c_black, 0.5);
draw_text_transformed_color(_rx, _ry + 55, _date_text, 2.0, 2.0, 0, c_white, c_white, c_white, c_white, 1.0);
draw_text_transformed_color(_rx + 1, _ry + 96, _money_text, 2.0, 2.0, 0, c_black, c_black, c_black, c_black, 0.5);
draw_text_transformed_color(_rx, _ry + 95, _money_text, 2.0, 2.0, 0, c_lime, c_lime, c_green, c_green, 1.0);

if (sleep_menu_open) {
    var _cx = display_get_gui_width() * 0.5;
    var _cy = display_get_gui_height() * 0.5;
    draw_set_alpha(0.65);
    draw_rectangle_color(0, 0, display_get_gui_width(), display_get_gui_height(), c_black, c_black, c_black, c_black, false);
    draw_set_alpha(1.0);
    draw_set_alpha(0.92);
    draw_roundrect_color_ext(_cx - 210, _cy - 85, _cx + 210, _cy + 85, 12, 12, c_dkgray, c_dkgray, false);
    draw_set_alpha(1.0);
    draw_roundrect_color_ext(_cx - 210, _cy - 85, _cx + 210, _cy + 85, 12, 12, c_white, c_white, true);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(_cx, _cy - 35, "Quieres irte a dormir?", 2, 2, 0);
    draw_text_transformed(_cx, _cy - 2, "Esto guardara el juego y avanzara un dia.", 1.2, 1.2, 0);
    var _yes_col = (sleep_menu_selection == 0) ? c_lime : c_white;
    var _no_col = (sleep_menu_selection == 1) ? c_red : c_white;
    draw_text_transformed_color(_cx - 70, _cy + 48, "SI", 2, 2, 0, _yes_col, _yes_col, _yes_col, _yes_col, 1);
    draw_text_transformed_color(_cx + 70, _cy + 48, "NO", 2, 2, 0, _no_col, _no_col, _no_col, _no_col, 1);
}
