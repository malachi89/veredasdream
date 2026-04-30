if (room_get_name(room) == "rm_main_menu") exit;

var _gui_w = display_get_gui_width();
var _hour_str = string(global.game_hour);
if (global.game_hour < 10) _hour_str = "0" + _hour_str;
var _min_str = string(global.game_minute);
if (global.game_minute < 10) _min_str = "0" + _min_str;
var _time_text = _hour_str + ":" + _min_str;
var _total_days = ((global.year - 1) * 4 * global.days_per_season) + (global.season_index * global.days_per_season) + global.day;
var _day_name = global.day_names[(_total_days - 1) mod 7];
var _date_text = global.season_names[$ global.season] + " " + string(global.day) + " " + _day_name;
var _lp = global.local_player;
var _money_text = instance_exists(_lp) ? "MXN$ " + string(_lp.money) : "MXN$ 0";

// --- ENERGY BAR (Top-Left) ---
if (instance_exists(_lp)) {
    var _p = _lp;
    var _ebx = 20;
    var _eby = 20;
    var _ebw = 200;
    var _ebh = 24;
    
    // Background
    draw_set_alpha(0.5);
    draw_rectangle_color(_ebx, _eby, _ebx + _ebw, _eby + _ebh, c_black, c_black, c_black, c_black, false);
    draw_set_alpha(1.0);
    draw_rectangle_color(_ebx, _eby, _ebx + _ebw, _eby + _ebh, c_white, c_white, c_white, c_white, true);
    
    // Energy Fill
    var _fill_ratio = clamp(_p.energy / _p.max_energy, 0, 1);
    var _fill_w = _fill_ratio * _ebw;
    
    var _col = c_lime;
    if (_p.energy <= 150) _col = c_yellow; // 70% used (30% left)
    if (_p.energy <= 50) _col = c_red;    // 90% used (10% left)
    
    if (_fill_w > 0) {
        draw_rectangle_color(_ebx + 2, _eby + 2, _ebx + _fill_w - 2, _eby + _ebh - 2, _col, _col, _col, _col, false);
    }
    
    // Label
    draw_set_font(fnt_pixel_operator);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_text_transformed_color(_ebx + 5, _eby + _ebh + 5, "ENERGIA", 1.5, 1.5, 0, c_white, c_white, c_white, c_white, 1.0);

    // Multiplayer role badge
    if (global.net_role != NET_ROLE.NONE) {
        var _role_text = (global.net_role == NET_ROLE.HOST) ? "ANFITRION" : "INVITADO";
        var _role_col  = (global.net_role == NET_ROLE.HOST) ? c_lime : c_aqua;
        draw_text_transformed_color(_ebx + 5, _eby + _ebh + 22, _role_text, 1.5, 1.5, 0, _role_col, _role_col, _role_col, _role_col, 0.9);
    }
}

draw_set_font(fnt_pixel_operator);
draw_set_halign(fa_right);
draw_set_valign(fa_top);

var _padding = 10;
var _text_w = max(string_width(_time_text) * 3.0, string_width(_date_text) * 2.0, string_width(_money_text) * 2.0);
if (global.mine_state.active) {
    var _mine_name = global.quality_names[global.mine_state.ore_type + 1];
    var _mine_text = "Mina de " + _mine_name + " - Nivel " + string(global.mine_state.floor);
    var _mw = string_width(_mine_text) * 1.5;
    if (_mw > _text_w) _text_w = _mw;
}
var _rx = _gui_w - 20;
var _ry = 20;

draw_set_alpha(0.5);
draw_roundrect_color_ext(_rx - _text_w - _padding, _ry - _padding, _rx + _padding, _ry + 170, 10, 10, c_black, c_black, false);
draw_set_alpha(1.0);
draw_text_transformed_color(_rx + 2, _ry + 2, _time_text, 3.0, 3.0, 0, c_black, c_black, c_black, c_black, 0.5);
draw_text_transformed_color(_rx, _ry, _time_text, 3.0, 3.0, 0, c_yellow, c_yellow, c_orange, c_orange, 1.0);
draw_text_transformed_color(_rx + 1, _ry + 56, _date_text, 2.0, 2.0, 0, c_black, c_black, c_black, c_black, 0.5);
draw_text_transformed_color(_rx, _ry + 55, _date_text, 2.0, 2.0, 0, c_white, c_white, c_white, c_white, 1.0);
draw_text_transformed_color(_rx + 1, _ry + 96, _money_text, 2.0, 2.0, 0, c_black, c_black, c_black, c_black, 0.5);
draw_text_transformed_color(_rx, _ry + 95, _money_text, 2.0, 2.0, 0, c_lime, c_lime, c_green, c_green, 1.0);

// --- MINE INFO (below money, only when inside a mine) ---
if (global.mine_state.active) {
    var _cr = room_get_name(room);
    if (string_length(_cr) == 6 && string_pos("cave_", _cr) == 1) {
        var _mine_name = global.quality_names[global.mine_state.ore_type + 1];
        var _mine_text = "Mina de " + _mine_name + " - Nivel " + string(global.mine_state.floor);
        draw_text_transformed_color(_rx + 1, _ry + 136, _mine_text, 1.5, 1.5, 0, c_black, c_black, c_black, c_black, 0.5);
        draw_text_transformed_color(_rx, _ry + 135, _mine_text, 1.5, 1.5, 0, c_aqua, c_aqua, c_aqua, c_aqua, 1.0);
    }
}

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

// --- HOST-INITIATED SLEEP PROMPT (client side) ---
if (sleep_prompt_open) {
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
    draw_set_font(fnt_pixel_operator);
    draw_text_transformed(_cx, _cy - 35, "El anfitrion quiere dormir", 2, 2, 0);
    draw_text_transformed(_cx, _cy - 2, "Quieres terminar el dia?", 1.2, 1.2, 0);
    var _yes_col2 = (sleep_prompt_selection == 0) ? c_lime : c_white;
    var _no_col2  = (sleep_prompt_selection == 1) ? c_red  : c_white;
    draw_text_transformed_color(_cx - 70, _cy + 48, "SI", 2, 2, 0, _yes_col2, _yes_col2, _yes_col2, _yes_col2, 1);
    draw_text_transformed_color(_cx + 70, _cy + 48, "NO", 2, 2, 0, _no_col2,  _no_col2,  _no_col2,  _no_col2,  1);
}

// --- MINE PROMPT (ladder down / exit) ---
if (mine_prompt_open) {
    var _pcx = display_get_gui_width() * 0.5;
    var _pcy = display_get_gui_height() * 0.5;
    var _prompt_title = (mine_prompt_type == "down") ? "Bajar al siguiente nivel?" : "Salir de la mina?";

    draw_set_alpha(0.65);
    draw_rectangle_color(0, 0, display_get_gui_width(), display_get_gui_height(), c_black, c_black, c_black, c_black, false);
    draw_set_alpha(1.0);
    draw_set_alpha(0.92);
    draw_roundrect_color_ext(_pcx - 210, _pcy - 85, _pcx + 210, _pcy + 85, 12, 12, c_dkgray, c_dkgray, false);
    draw_set_alpha(1.0);
    draw_roundrect_color_ext(_pcx - 210, _pcy - 85, _pcx + 210, _pcy + 85, 12, 12, c_white, c_white, true);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_font(fnt_pixel_operator);
    draw_text_transformed(_pcx, _pcy - 35, _prompt_title, 2, 2, 0);

    var _yes_col = (mine_prompt_selection == 0) ? c_lime : c_white;
    var _no_col  = (mine_prompt_selection == 1) ? c_red  : c_white;
    draw_text_transformed_color(_pcx - 70, _pcy + 48, "SI", 2, 2, 0, _yes_col, _yes_col, _yes_col, _yes_col, 1);
    draw_text_transformed_color(_pcx + 70, _pcy + 48, "NO", 2, 2, 0, _no_col,  _no_col,  _no_col,  _no_col,  1);
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
draw_set_valign(fa_bottom);
var _gui_h = display_get_gui_height();
for (var i = 0; i < ds_list_size(notifications); i++) {
    var _notif = notifications[| i];
    var _ny = _gui_h - 150 - (i * 30);
    draw_text_transformed_color(20, _ny, _notif.text, 1.5, 1.5, 0, c_white, c_white, c_white, c_white, _notif.alpha);
}

// --- DEBUG CONSOLE / CHAT ---
if (chat_open) {
    var _cw = display_get_gui_width();
    var _ch = display_get_gui_height();
    var _box_w = 400;
    var _box_h = 40;
    var _box_x = 20;
    var _box_y = _ch - 100; // Un poco arriba de la hotbar si es necesario

    draw_set_alpha(0.8);
    draw_rectangle_color(_box_x, _box_y, _box_x + _box_w, _box_y + _box_h, c_black, c_black, c_black, c_black, false);
    draw_set_alpha(1.0);
    draw_rectangle_color(_box_x, _box_y, _box_x + _box_w, _box_y + _box_h, c_white, c_white, c_white, c_white, true);

    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    var _display_text = "> " + chat_text;
    if (current_time mod 1000 < 500) _display_text += "|";

    draw_text_transformed_color(_box_x + 10, _box_y + (_box_h / 2), _display_text, 1.5, 1.5, 0, c_white, c_white, c_white, c_white, 1.0);
}

// --- PAUSE MENU ---
if (pause_menu_open) {
    var _pcx = display_get_gui_width()  * 0.5;
    var _pcy = display_get_gui_height() * 0.5;

    draw_set_alpha(0.65);
    draw_rectangle_color(0, 0, display_get_gui_width(), display_get_gui_height(), c_black, c_black, c_black, c_black, false);
    draw_set_alpha(1.0);

    draw_set_alpha(0.92);
    draw_roundrect_color_ext(_pcx - 160, _pcy - 100, _pcx + 160, _pcy + 150, 12, 12, c_dkgray, c_dkgray, false);
    draw_set_alpha(1.0);
    draw_roundrect_color_ext(_pcx - 160, _pcy - 100, _pcx + 160, _pcy + 150, 12, 12, c_white, c_white, true);

    draw_set_font(fnt_pixel_operator);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(_pcx, _pcy - 68, "PAUSA", 2.5, 2.5, 0);

    var _labels    = ["Continuar", "Menu Principal", "Salir"];
    var _opt_y_off = [-20, 36, 92];

    for (var _i = 0; _i < 3; _i++) {
        var _oy    = _pcy + _opt_y_off[_i];
        var _opt_w = 260;
        var _opt_h = 44;
        if (pause_menu_selection == _i) {
            draw_set_alpha(0.85);
            draw_roundrect_color_ext(_pcx - (_opt_w * 0.5), _oy, _pcx + (_opt_w * 0.5), _oy + _opt_h, 8, 8, c_navy, c_navy, false);
            draw_set_alpha(1.0);
            draw_text_transformed_color(_pcx, _oy + (_opt_h * 0.5), _labels[_i], 1.8, 1.8, 0, c_white, c_white, c_white, c_white, 1);
        } else {
            draw_set_alpha(1.0);
            draw_text_transformed_color(_pcx, _oy + (_opt_h * 0.5), _labels[_i], 1.8, 1.8, 0, c_ltgray, c_ltgray, c_ltgray, c_ltgray, 1);
        }
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1.0);
}