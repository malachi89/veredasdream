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

// --- RESUMEN DE VENTAS (TICKET) ---
if (shipping_summary_open) {
    var _cx = display_get_gui_width() * 0.5;
    var _cy = display_get_gui_height() * 0.5;
    
    // Fondo oscuro detras del ticket
    draw_set_alpha(0.85);
    draw_rectangle_color(0, 0, display_get_gui_width(), display_get_gui_height(), c_black, c_black, c_black, c_black, false);
    draw_set_alpha(1.0);
    
    // Dimensiones del ticket
    var _tw = 450;
    var _th = 550;
    var _tx1 = _cx - (_tw / 2);
    var _ty1 = _cy - (_th / 2) - 40;
    var _tx2 = _cx + (_tw / 2);
    var _ty2 = _cy + (_th / 2) - 40;
    
    // Dibujar el papel del ticket (color crema/papel viejo)
    var _paper_col = make_color_rgb(245, 241, 222);
    draw_set_color(_paper_col);
    draw_rectangle(_tx1, _ty1, _tx2, _ty2, false);
    
    // Bordes del ticket
    draw_set_color(c_black);
    draw_rectangle(_tx1, _ty1, _tx2, _ty2, true);
    draw_rectangle(_tx1+2, _ty1+2, _tx2-2, _ty2-2, true); // Doble borde
    
    // Encabezado
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_text_transformed_color(_cx, _ty1 + 30, "VEREDAS DREAM - RECIBO", 2, 2, 0, c_black, c_black, c_black, c_black, 1);
    draw_text_transformed_color(_cx, _ty1 + 65, "--------------------------------", 1.5, 1.5, 0, c_black, c_black, c_black, c_black, 1);
    
    // Listado de items
    var _item_y = _ty1 + 100;
    var _items = shipping_summary_data.items;
    
    for (var i = 0; i < array_length(_items); i++) {
        var _it = _items[i];
        
        // Icono
        draw_sprite_ext(_it.sprite, _it.subimg, _tx1 + 40, _item_y + 12, 1.0, 1.0, 0, c_white, 1);
        
        // Texto del item
        draw_set_halign(fa_left);
        draw_text_transformed_color(_tx1 + 75, _item_y, _it.name, 1.2, 1.2, 0, c_black, c_black, c_black, c_black, 1);
        
        draw_set_halign(fa_right);
        draw_text_transformed_color(_tx1 + 280, _item_y, "x" + string(_it.quantity), 1.2, 1.2, 0, c_black, c_black, c_black, c_black, 1);
        draw_text_transformed_color(_tx2 - 40, _item_y, "$" + string(_it.subtotal), 1.2, 1.2, 0, c_black, c_black, c_black, c_black, 1);
        
        _item_y += 40;
        
        if (_item_y > _ty2 - 120) {
            draw_set_halign(fa_center);
            draw_text_transformed_color(_cx, _item_y, "... y mas ...", 1.2, 1.2, 0, c_black, c_black, c_black, c_black, 1);
            break;
        }
    }
    
    // Total
    draw_set_halign(fa_center);
    draw_text_transformed_color(_cx, _ty2 - 100, "================================", 1.5, 1.5, 0, c_black, c_black, c_black, c_black, 1);
    
    draw_set_halign(fa_left);
    draw_text_transformed_color(_tx1 + 50, _ty2 - 75, "TOTAL:", 1.8, 1.8, 0, c_black, c_black, c_black, c_black, 1);
    
    draw_set_halign(fa_right);
    draw_text_transformed_color(_tx2 - 50, _ty2 - 75, "MXN$ " + string(shipping_summary_data.total), 1.8, 1.8, 0, c_green, c_green, c_green, c_green, 1);
    
    // Boton Continuar
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);
    var _btn_w = 240;
    var _btn_h = 60;
    var _btn_x1 = _cx - (_btn_w / 2);
    var _btn_y1 = _ty2 + 40;
    var _btn_x2 = _cx + (_btn_w / 2);
    var _btn_y2 = _btn_y1 + _btn_h;
    
    var _hover = point_in_rectangle(_mx, _my, _btn_x1, _btn_y1, _btn_x2, _btn_y2);
    var _btn_col = _hover ? c_aqua : c_blue;
    var _txt_col = c_white;
    
    draw_set_alpha(1.0);
    draw_roundrect_color_ext(_btn_x1, _btn_y1, _btn_x2, _btn_y2, 12, 12, _btn_col, _btn_col, false);
    draw_roundrect_color_ext(_btn_x1, _btn_y1, _btn_x2, _btn_y2, 12, 12, c_black, c_black, true);
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed_color(_cx, _btn_y1 + (_btn_h / 2), "CONTINUAR", 1.8, 1.8, 0, _txt_col, _txt_col, _txt_col, _txt_col, 1);
}

// --- NOTIFICACIONES ---
draw_set_halign(fa_left);
draw_set_valign(fa_top);
for (var i = 0; i < ds_list_size(notifications); i++) {
    var _notif = notifications[| i];
    var _ny = 20 + (i * 30);
    draw_text_transformed_color(20, _ny, _notif.text, 1.5, 1.5, 0, c_white, c_white, c_white, c_white, _notif.alpha);
}