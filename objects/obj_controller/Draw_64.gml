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

    // --- HEALTH HEARTS ---
    var _hhx = _ebx;
    var _hhy = _eby + _ebh + 4;
    var _hp_rem = _p.hp;
    var _heart_count = _p.max_hp div 2;
    for (var i = 0; i < _heart_count; i++) {
        var _frame;
        if (_hp_rem >= 2)      { _frame = 0; _hp_rem -= 2; }
        else if (_hp_rem == 1) { _frame = 1; _hp_rem -= 1; }
        else                     _frame = 2;
        var _row = i div 10;
        var _col = i mod 10;
        draw_sprite_ext(sprite_health, _frame, _hhx + _col * 34, _hhy + _row * 40, 2, 2, 0, c_white, 1);
    }

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
    var _can_nap = (24 - global.game_hour > 5);

    draw_set_alpha(0.65);
    draw_rectangle_color(0, 0, display_get_gui_width(), display_get_gui_height(), c_black, c_black, c_black, c_black, false);
    draw_set_alpha(1.0);
    draw_set_alpha(0.92);
    draw_roundrect_color_ext(_cx - 210, _cy - 90, _cx + 210, _cy + 90, 12, 12, c_dkgray, c_dkgray, false);
    draw_set_alpha(1.0);
    draw_roundrect_color_ext(_cx - 210, _cy - 90, _cx + 210, _cy + 90, 12, 12, c_white, c_white, true);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(_cx, _cy - 45, "Elige una opcion:", 2, 2, 0);
    draw_text_transformed(_cx, _cy - 18, "Dormir: termina el dia y guarda.", 1.2, 1.2, 0);
    if (_can_nap) {
        draw_text_transformed(_cx, _cy + 2, "Siesta: recupera energia (+5h).", 1.2, 1.2, 0);
    }
    var _sleep_col = (sleep_menu_selection == 0) ? c_lime : c_white;
    var _nap_col = (_can_nap && sleep_menu_selection == 1) ? c_yellow : c_white;
    var _no_col = (sleep_menu_selection == (_can_nap ? 2 : 1)) ? c_red : c_white;
    draw_text_transformed_color(_cx - 130, _cy + 52, "DORMIR", 2, 2, 0, _sleep_col, _sleep_col, _sleep_col, _sleep_col, 1);
    if (_can_nap) draw_text_transformed_color(_cx, _cy + 52, "SIESTA", 2, 2, 0, _nap_col, _nap_col, _nap_col, _nap_col, 1);
    draw_text_transformed_color(_cx + 130, _cy + 52, "NO", 2, 2, 0, _no_col, _no_col, _no_col, _no_col, 1);
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
    var _receipt_header = (global.farm_name != "") ? global.farm_name + " - NOTA DE VENTA" : "VEREDAS DREAM - NOTA DE VENTA";
    draw_text_transformed_color(_cx, _ty1 + 30, _receipt_header, 2, 2, 0, c_black, c_black, c_black, c_black, 1);
    draw_text_transformed_color(_cx, _ty1 + 65, "--------------------------------", 1.5, 1.5, 0, c_black, c_black, c_black, c_black, 1);
    
    // Listado de items (con scroll)
    var _items = shipping_summary_data.items;
    var _n = array_length(_items);
    var _visible = 8;
    var _item_y = _ty1 + 100;
    
    for (var _i = 0; _i < _visible; _i++) {
        var _idx = _i + shipping_summary_scroll;
        if (_idx >= _n) break;
        var _it = _items[_idx];
        
        // Icono
        draw_sprite_ext(_it.sprite, _it.subimg, _tx1 + 40, _item_y + 12, 1.0, 1.0, 0, c_white, 1);
        
        // Texto del item
        draw_set_halign(fa_left);
        draw_text_transformed_color(_tx1 + 75, _item_y, _it.name, 1.2, 1.2, 0, c_black, c_black, c_black, c_black, 1);
        
        draw_set_halign(fa_right);
        draw_text_transformed_color(_tx1 + 280, _item_y, "x" + string(_it.quantity), 1.2, 1.2, 0, c_black, c_black, c_black, c_black, 1);
        draw_text_transformed_color(_tx2 - 40, _item_y, "$" + string(_it.subtotal), 1.2, 1.2, 0, c_black, c_black, c_black, c_black, 1);
        
        _item_y += 40;
    }
    
    // Indicadores de scroll
    if (_n > _visible) {
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        if (shipping_summary_scroll > 0) {
            draw_text_transformed_color(_cx, _ty1 + 85, "^", 1.5, 1.5, 0, c_black, c_black, c_black, c_black, 1);
        }
        if (shipping_summary_scroll + _visible < _n) {
            draw_text_transformed_color(_cx, _ty2 - 125, "v", 1.5, 1.5, 0, c_black, c_black, c_black, c_black, 1);
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

// --- COLLECTION CATALOG ---
if (collection_menu_open) {
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    var _cx = _gw * 0.5;
    var _cy = _gh * 0.5;
    var _pw = 920;
    var _ph = 640;
    var _px1 = _cx - _pw/2;
    var _py1 = _cy - _ph/2;
    var _px2 = _cx + _pw/2;
    var _py2 = _cy + _ph/2;

    draw_set_alpha(0.75);
    draw_rectangle_color(0, 0, _gw, _gh, c_black, c_black, c_black, c_black, false);
    draw_set_alpha(1.0);

    draw_set_alpha(0.94);
    draw_roundrect_color_ext(_px1, _py1, _px2, _py2, 12, 12, c_dkgray, c_dkgray, false);
    draw_set_alpha(1.0);
    draw_roundrect_color_ext(_px1, _py1, _px2, _py2, 12, 12, c_silver, c_silver, true);

    draw_set_font(fnt_pixel_operator);

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_text_transformed_color(_cx, _py1 + 16, "CATALOGO DE COLECCION", 2.5, 2.5, 0, c_white, c_white, c_yellow, c_yellow, 1.0);

    draw_set_halign(fa_right);
    draw_text_transformed_color(_px2 - 12, _py1 + 20, "[M] Cerrar", 1.2, 1.2, 0, c_ltgray, c_ltgray, c_ltgray, c_ltgray, 0.6);

    var _cats = scr_get_collection_categories();
    var _num_cats = array_length(_cats);

    // ---- SIDEBAR ----
    var _sidebar_w = 240;
    var _cat_h = 34;
    var _cat_x1 = _px1 + 12;
    var _cat_x2 = _px1 + _sidebar_w;
    var _cat_start_y = _py1 + 74;

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    for (var _ci = 0; _ci < _num_cats; _ci++) {
        var _cat_y1 = _cat_start_y + _ci * _cat_h;
        var _is_active = (_ci == collection_category);
        var _total = array_length(variable_struct_get_names(_cats[_ci].db));
        var _collected = scr_count_collected_in_category(_cats[_ci].db);

        if (_is_active) {
            draw_set_alpha(0.3);
            draw_roundrect_color_ext(_cat_x1, _cat_y1, _cat_x2, _cat_y1 + _cat_h - 2, 4, 4, c_navy, c_navy, false);
            draw_set_alpha(1.0);
        }

        var _name_col = _is_active ? c_white : c_ltgray;
        draw_text_transformed_color(_cat_x1 + 8, _cat_y1 + 3, _cats[_ci].name, 1.3, 1.3, 0, _name_col, _name_col, _name_col, _name_col, 1.0);

        draw_set_halign(fa_right);
        var _count_col = (_collected == _total) ? c_lime : c_yellow;
        draw_text_transformed_color(_cat_x2 - 8, _cat_y1 + 5, string(_collected) + "/" + string(_total), 1.0, 1.0, 0, _count_col, _count_col, _count_col, _count_col, 0.9);
        draw_set_halign(fa_left);
    }

    // Separator
    draw_set_alpha(0.4);
    draw_set_color(c_silver);
    draw_line(_cat_x2 + 10, _py1 + 50, _cat_x2 + 10, _py2 - 14);
    draw_set_alpha(1.0);

    // ---- RIGHT AREA ----
    var _cat_db = _cats[collection_category].db;
    var _keys = scr_get_collection_keys(_cat_db);
    var _total_items = array_length(_keys);
    var _right_cx = _cat_x2 + 10 + (_px2 - _cat_x2 - 10) / 2;

    // Category title
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_text_transformed_color(_right_cx, _cat_start_y, _cats[collection_category].name, 1.8, 1.8, 0, c_aqua, c_aqua, c_aqua, c_aqua, 1.0);

    var _cat_collected = scr_count_collected_in_category(_cat_db);
    draw_text_transformed_color(_right_cx, _cat_start_y + 40, "Progreso: " + string(_cat_collected) + " / " + string(_total_items), 1.2, 1.2, 0, c_ltgray, c_ltgray, c_ltgray, c_ltgray, 0.7);

    // ---- ITEM GRID ----
    var _grid_x1 = _cat_x2 + 20;
    var _grid_y1 = _cat_start_y + 80;

    var _cols = 9;
    var _rows = 5;
    var _per_page = _cols * _rows;
    var _max_page = max(0, ceil(_total_items / _per_page) - 1);
    if (collection_page > _max_page) collection_page = _max_page;
    var _start_idx = collection_page * _per_page;

    var _slot_size = 54;
    var _slot_gap = 5;
    var _name_height = 14;
    var _cell_w = _slot_size + _slot_gap;
    var _cell_h = _slot_size + _slot_gap + _name_height;

    var _grid_total_w = _cols * _cell_w - _slot_gap;
    var _grid_avail_w = _px2 - _grid_x1 - 14;
    var _grid_offset_x = _grid_x1 + (_grid_avail_w - _grid_total_w) / 2;

    // Track hover for tooltip
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);
    var _hovered_key = "";
    var _hovered_idx = -1;

    for (var _gi = 0; _gi < _per_page; _gi++) {
        var _idx = _start_idx + _gi;
        if (_idx >= _total_items) break;
        var _key = _keys[_idx];
        var _data = scr_get_item_data(_key);
        if (_data == undefined) continue;

        var _col = _gi mod _cols;
        var _row = floor(_gi / _cols);

        var _sx = _grid_offset_x + _col * _cell_w;
        var _sy = _grid_y1 + _row * _cell_h;

        var _is_collected = variable_struct_exists(global.collected_items, _key);

        // Check hover
        if (point_in_rectangle(_mx, _my, _sx, _sy, _sx + _slot_size, _sy + _slot_size)) {
            _hovered_key = _key;
            _hovered_idx = _idx;
        }

        // Slot background
        if (_hovered_key == _key) {
            draw_set_alpha(0.35);
            draw_roundrect_color_ext(_sx - 1, _sy - 1, _sx + _slot_size + 1, _sy + _slot_size + 1, 6, 6, c_white, c_white, false);
            draw_set_alpha(1.0);
            draw_roundrect_color_ext(_sx - 1, _sy - 1, _sx + _slot_size + 1, _sy + _slot_size + 1, 6, 6, c_lime, c_lime, true);
        } else {
            draw_set_alpha(0.15);
            draw_roundrect_color_ext(_sx, _sy, _sx + _slot_size, _sy + _slot_size, 4, 4, c_white, c_white, false);
            draw_set_alpha(1.0);
            draw_roundrect_color_ext(_sx, _sy, _sx + _slot_size, _sy + _slot_size, 4, 4, c_silver, c_silver, true);
        }

        // Draw icon
        var _sz = 44 / max(sprite_get_width(_data.sprite), sprite_get_height(_data.sprite));
        var _icon_x = _sx + _slot_size/2;
        var _icon_y = _sy + _slot_size/2;
        var _cox = (sprite_get_width(_data.sprite) / 2 - sprite_get_xoffset(_data.sprite)) * _sz;
        var _coy = (sprite_get_height(_data.sprite) / 2 - sprite_get_yoffset(_data.sprite)) * _sz;

        var _col_color = _is_collected ? c_white : c_black;
        var _col_alpha = _is_collected ? 1.0 : 0.35;
        draw_set_alpha(_col_alpha);
        draw_sprite_ext(_data.sprite, _data.subimg, _icon_x - _cox, _icon_y - _coy, _sz, _sz, 0, _col_color, 1);
        draw_set_alpha(1.0);

        // Name label (solo no recolectados)
        draw_set_halign(fa_center);
        if (!_is_collected) {
            draw_text_transformed_color(_sx + _slot_size/2, _sy + _slot_size + 3, "???", 0.9, 0.9, 0, c_dkgray, c_dkgray, c_dkgray, c_dkgray, 0.6);
        }
    }

    // ---- TOOLTIP ----
    if (_hovered_key != "") {
        var _tt_data = scr_get_item_data(_hovered_key);
        if (_tt_data != undefined) {
            var _is_collected = variable_struct_exists(global.collected_items, _hovered_key);
            var _tt_w = 220;
            var _tt_h = 80;
            var _tt_x = _mx + 16;
            var _tt_y = _my - _tt_h/2;

            // Build drops text for enemies/animals (needed before positioning)
            var _drop_names = "";
            if (_is_collected) {
                if (variable_struct_exists(global.enemy_data, _hovered_key)) {
                    var _ed = global.enemy_data[$ _hovered_key];
                    for (var _di = 0; _di < array_length(_ed.product_drops); _di++) {
                        if (_drop_names != "") _drop_names += ", ";
                        var _dd = scr_get_item_data(_ed.product_drops[_di]);
                        _drop_names += (_dd != undefined) ? _dd.name : _ed.product_drops[_di];
                    }
                } else if (variable_struct_exists(global.wild_animal_data, _hovered_key)) {
                    var _wd = global.wild_animal_data[$ _hovered_key];
                    for (var _di = 0; _di < array_length(_wd.product_drops); _di++) {
                        if (_drop_names != "") _drop_names += ", ";
                        var _dd = scr_get_item_data(_wd.product_drops[_di]);
                        _drop_names += (_dd != undefined) ? _dd.name : _wd.product_drops[_di];
                    }
                } else if (string_pos("farm_", _hovered_key) == 1) {
                    var _fk = string_copy(_hovered_key, 6, string_length(_hovered_key) - 5);
                    if (variable_struct_exists(global.animal_data, _fk)) {
                        var _fad = global.animal_data[$ _fk];
                        for (var _di = 0; _di < array_length(_fad.product_drops); _di++) {
                            if (_drop_names != "") _drop_names += ", ";
                            var _dd = scr_get_item_data(_fad.product_drops[_di]);
                            _drop_names += (_dd != undefined) ? _dd.name : _fad.product_drops[_di];
                        }
                        if (array_length(_fad.crafting_drops) > 0) {
                            _drop_names += " | +50% material";
                        }
                    }
                }

                if (_drop_names != "") {
                    // Word-wrap drops text into lines
                    var _drop_parts = string_split(_drop_names, ", ");
                    var _wrap_lines = [];
                    var _cur_line = "";
                    var _max_lw = 280;
                    var _scl = 0.8;
                    for (var _wpi = 0; _wpi < array_length(_drop_parts); _wpi++) {
                        if (_cur_line == "") {
                            _cur_line = _drop_parts[_wpi];
                        } else {
                            var _test = _cur_line + ", " + _drop_parts[_wpi];
                            if (string_width(_test) * _scl > _max_lw) {
                                array_push(_wrap_lines, _cur_line);
                                _cur_line = _drop_parts[_wpi];
                            } else {
                                _cur_line = _test;
                            }
                        }
                    }
                    if (_cur_line != "") array_push(_wrap_lines, _cur_line);

                    _tt_w = 300;
                    _tt_h = 55 + array_length(_wrap_lines) * 18;
                }
            }

            _tt_x = _mx + 16;
            _tt_y = _my - _tt_h/2;
            if (_tt_x + _tt_w > _px2) _tt_x = _mx - _tt_w - 16;
            if (_tt_y < _py1 + 10) _tt_y = _py1 + 10;
            if (_tt_y + _tt_h > _py2 - 10) _tt_y = _py2 - 10 - _tt_h;

            draw_set_alpha(0.92);
            draw_roundrect_color_ext(_tt_x, _tt_y, _tt_x + _tt_w, _tt_y + _tt_h, 8, 8, c_black, c_black, false);
            draw_set_alpha(1.0);
            draw_roundrect_color_ext(_tt_x, _tt_y, _tt_x + _tt_w, _tt_y + _tt_h, 8, 8, c_white, c_white, true);

            draw_set_halign(fa_left);
            draw_set_valign(fa_top);

            if (_is_collected) {
                draw_text_transformed_color(_tt_x + 10, _tt_y + 8, _tt_data.name, 1.3, 1.3, 0, c_white, c_white, c_white, c_white, 1.0);

                if (_drop_names != "") {
                    draw_text_transformed_color(_tt_x + 10, _tt_y + 36, "Suelta:", 0.8, 0.8, 0, c_lime, c_lime, c_lime, c_lime, 1.0);
                    for (var _dli = 0; _dli < array_length(_wrap_lines); _dli++) {
                        draw_text_transformed_color(_tt_x + 10, _tt_y + 36 + (_dli + 1) * 18, _wrap_lines[_dli], 0.8, 0.8, 0, c_lime, c_lime, c_lime, c_lime, 1.0);
                    }
                } else {
                    var _sell = variable_struct_exists(_tt_data, "base_sell_price") ? _tt_data.base_sell_price : 0;
                    draw_text_transformed_color(_tt_x + 10, _tt_y + 36, "Precio venta: $" + string(_sell), 1.0, 1.0, 0, c_lime, c_lime, c_lime, c_lime, 1.0);
                }

                if (variable_struct_exists(_tt_data, "type")) {
                    var _type_str = "";
                    switch (_tt_data.type) {
                        case ITEM_TYPE.CROP: _type_str = "Cultivo"; break;
                        case ITEM_TYPE.FISH: _type_str = "Pescado"; break;
                        case ITEM_TYPE.INSECT: _type_str = "Insecto"; break;
                        case ITEM_TYPE.MATERIAL: _type_str = "Material"; break;
                        case ITEM_TYPE.FOOD: _type_str = "Producto"; break;
                        case ITEM_TYPE.ORE: _type_str = "Mineral"; break;
                        case ITEM_TYPE.BAR: _type_str = "Lingote"; break;
                        case ITEM_TYPE.JAM: _type_str = "Mermelada"; break;
                        case ITEM_TYPE.SEED: _type_str = "Semilla"; break;
                    }
                    if (_type_str != "") {
                        draw_text_transformed_color(_tt_x + 10, _tt_y + 56, _type_str, 1.0, 1.0, 0, c_aqua, c_aqua, c_aqua, c_aqua, 0.8);
                    }
                }
            } else {
                draw_text_transformed_color(_tt_x + 10, _tt_y + 20, "???", 1.5, 1.5, 0, c_dkgray, c_dkgray, c_dkgray, c_dkgray, 0.8);
                draw_text_transformed_color(_tt_x + 10, _tt_y + 48, "Aun no recolectado", 1.0, 1.0, 0, c_ltgray, c_ltgray, c_ltgray, c_ltgray, 0.6);
            }
        }
    }

    // ---- PAGE NAVIGATION ----
    var _btn_w = 150;
    var _btn_h = 34;
    var _btn_y1 = _py2 - 44;
    var _btn_y2 = _btn_y1 + _btn_h;

    if (_max_page > 0) {
        // Page indicator above buttons
        var _page_text = "Pagina " + string(collection_page + 1) + " de " + string(_max_page + 1);
        draw_set_halign(fa_center);
        draw_set_valign(fa_bottom);
        draw_text_transformed_color(_right_cx, _btn_y1 - 6, _page_text, 1.2, 1.2, 0, c_ltgray, c_ltgray, c_ltgray, c_ltgray, 0.8);

        // Previous button
        var _prev_x1 = _right_cx - _btn_w - 10;
        var _prev_x2 = _right_cx - 10;
        var _prev_hover = point_in_rectangle(_mx, _my, _prev_x1, _btn_y1, _prev_x2, _btn_y2);
        draw_set_alpha(_prev_hover ? 0.4 : 0.2);
        draw_roundrect_color_ext(_prev_x1, _btn_y1, _prev_x2, _btn_y2, 6, 6, c_white, c_white, false);
        draw_set_alpha(1.0);
        draw_roundrect_color_ext(_prev_x1, _btn_y1, _prev_x2, _btn_y2, 6, 6, c_silver, c_silver, true);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text_transformed_color((_prev_x1 + _prev_x2) / 2, (_btn_y1 + _btn_y2) / 2, "< ANTERIOR", 1.0, 1.0, 0, _prev_hover ? c_white : c_ltgray, _prev_hover ? c_white : c_ltgray, _prev_hover ? c_white : c_ltgray, _prev_hover ? c_white : c_ltgray, 1.0);

        // Next button
        var _next_x1 = _right_cx + 10;
        var _next_x2 = _right_cx + _btn_w + 10;
        var _next_hover = point_in_rectangle(_mx, _my, _next_x1, _btn_y1, _next_x2, _btn_y2);
        draw_set_alpha(_next_hover ? 0.4 : 0.2);
        draw_roundrect_color_ext(_next_x1, _btn_y1, _next_x2, _btn_y2, 6, 6, c_white, c_white, false);
        draw_set_alpha(1.0);
        draw_roundrect_color_ext(_next_x1, _btn_y1, _next_x2, _btn_y2, 6, 6, c_silver, c_silver, true);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text_transformed_color((_next_x1 + _next_x2) / 2, (_btn_y1 + _btn_y2) / 2, "SIGUIENTE >", 1.0, 1.0, 0, _next_hover ? c_white : c_ltgray, _next_hover ? c_white : c_ltgray, _next_hover ? c_white : c_ltgray, _next_hover ? c_white : c_ltgray, 1.0);
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1.0);
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

// === CROP / TREE HOVER TOOLTIP ===
if (crop_hover_show && instance_exists(_lp) && !is_struct(_lp.held_item)) {
    draw_set_font(fnt_pixel_operator);
    var _tw = (string_width(crop_hover_tooltip_text) + 16) * 1.2;
    var _th = (string_height(crop_hover_tooltip_text) + 16) * 1.2;
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);
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
    draw_text_transformed(_tx + 8, _ty + 8, crop_hover_tooltip_text, 1.2, 1.2, 0);
}