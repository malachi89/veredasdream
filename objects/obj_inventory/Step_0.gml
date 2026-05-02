var _p = local_player;
if (!instance_exists(_p)) exit;

// === PANEL LETRERO ===
if (_p.sign_panel_open) {
    if (keyboard_check_pressed(vk_escape)) {
        _p.sign_panel_open = false;
        _p.sign_scroll     = 0;
    }
    var _sp_visible = 8;
    var _wheel = mouse_wheel_down() - mouse_wheel_up();
    _p.sign_scroll = clamp(_p.sign_scroll + _wheel, 0, max(0, array_length(_p.sign_panel_items) - _sp_visible));
    exit;
}

// === DIALOGO ===
if (_p.dialog_open) {
    if (keyboard_check_pressed(vk_escape)) _p.dialog_open = false;
    exit;
}

// === TIENDA ===
if (_p.shop_open) {
    if (_p.shop_msg_timer > 0) _p.shop_msg_timer--;

    if (keyboard_check_pressed(vk_escape)) {
        _p.shop_open    = false;
        _p.shop_npc_key = "";
        _p.shop_msg     = "";
    }

    var _shop    = global.shop_data[$ _p.shop_npc_key];
    var _sitems  = (_shop != undefined && _shop.available) ? _shop.items : [];
    var _sn      = array_length(_sitems);
    var _is_bs = (_p.shop_npc_key == "Carlos");
    var _visible = (_p.shop_npc_key == "workbench" || _is_bs) ? 7 : 8;

    var _wheel = mouse_wheel_down() - mouse_wheel_up();
    _p.shop_scroll = clamp(_p.shop_scroll + _wheel, 0, max(0, _sn - _visible));

    if (mouse_check_button_pressed(mb_left) && _shop != undefined && _shop.available) {
        var _smx  = device_mouse_x_to_gui(0);
        var _smy  = device_mouse_y_to_gui(0);
        var _sgw  = display_get_gui_width();
        var _sgh  = display_get_gui_height();
        var _is_wb = (_p.shop_npc_key == "workbench");
        var _wb_or_bs = _is_wb || _is_bs;
        var _spw  = _wb_or_bs ? 760 : 520;
        var _srow = _wb_or_bs ? 64 : 44;
        var _spx1 = (_sgw - _spw) / 2;
        var _spy_panel = _sgh * (_wb_or_bs ? 0.10 : 0.12);
        var _spy1 = _spy_panel + (_wb_or_bs ? 74 : 52);

        for (var _si = 0; _si < _visible; _si++) {
            var _sidx = _si + _p.shop_scroll;
            if (_sidx >= _sn) break;
            var _sry1 = _spy1 + _si * _srow;
            var _sry2 = _sry1 + _srow - 2;
            if (_smx >= _spx1 && _smx <= _spx1 + _spw && _smy >= _sry1 && _smy <= _sry2) {
                var _entry = _sitems[_sidx];
                if (_is_bs && variable_struct_exists(_entry, "is_upgrade") && _entry.is_upgrade) {
                    scr_blacksmith_upgrade(_entry.item_key, _p);
                } else {
                    var _can_afford = _p.money >= _entry.price_money;
                    var _items_ok   = true;
                    for (var _sj = 0; _sj < array_length(_entry.price_items); _sj++) {
                        var _req  = _entry.price_items[_sj];
                        var _have = variable_struct_exists(_req, "group_keys")
                            ? scr_count_item_group(_req.group_keys)
                            : scr_count_item(_req.key);
                        if (_have < _req.qty) { _items_ok = false; break; }
                    }
                    if (_can_afford && _items_ok) {
                        if (global.net_role == NET_ROLE.CLIENT && instance_exists(obj_net) && obj_net.is_connected) {
                            net_send_shop_buy(_p.shop_npc_key, _entry.item_key);
                            _p.shop_msg       = "Procesando...";
                            _p.shop_msg_timer = 90;
                        } else {
                            _p.money -= _entry.price_money;
                            for (var _sj = 0; _sj < array_length(_entry.price_items); _sj++) {
                                var _req = _entry.price_items[_sj];
                                if (variable_struct_exists(_req, "group_keys")) {
                                    scr_remove_items_from_group(_req.group_keys, _req.qty);
                                } else {
                                    scr_remove_item(_req.key, _req.qty);
                                }
                            }
                            with (_p) add_item(_entry.item_key, 1);
                            scr_play_sound_clip(sound_item_pickup, 0.75, 1.00);
                            if (_is_wb) {
                                var _idata_msg = scr_get_item_data(_entry.item_key);
                                var _iname_msg = (_idata_msg != undefined) ? _idata_msg.name : _entry.item_key;
                                _p.shop_msg = _iname_msg + " creado!";
                            } else {
                                _p.shop_msg = "Comprado!";
                            }
                            _p.shop_msg_timer = 90;
                        }
                    } else if (!_can_afford) {
                        _p.shop_msg       = "Fondos insuficientes";
                        _p.shop_msg_timer = 90;
                    } else {
                        _p.shop_msg       = "Te faltan materiales";
                        _p.shop_msg_timer = 90;
                    }
                }
                break;
            }
        }
    }
    exit;
}

if (instance_exists(obj_controller) && (obj_controller.sleep_menu_open || obj_controller.chat_open || obj_controller.pause_menu_open)) {
    exit;
}

if (display_get_gui_width() != window_get_width() || display_get_gui_height() != window_get_height()) {
    display_set_gui_size(window_get_width(), window_get_height());
    update_gui_positions();
}

for (var i = 0; i < 9; i++) {
    if (keyboard_check_pressed(ord(string(i + 1)))) _p.selected_slot = i;
}
if (keyboard_check_pressed(ord("0"))) _p.selected_slot = 9;

var _press_open = keyboard_check_pressed(ord("I"));
var _press_close = keyboard_check_pressed(vk_escape);

if (_press_close && (_p.show_backpack || _p.show_shipping || _p.show_chest)) {
    _p.show_backpack = false;
    _p.show_shipping = false;
    _p.show_chest    = false;
    if (instance_exists(_p.current_chest_id)) _p.current_chest_id.is_open = false;
    _p.current_chest_id = noone;

    if (_p.held_item != -1) {
        with (_p) add_item(held_item.key, held_item.quantity);
        _p.held_item = -1;
    }
}

if (_press_open) {
    if (_p.show_shipping || _p.show_chest) {
        _p.show_shipping = false;
        _p.show_chest    = false;
        if (instance_exists(_p.current_chest_id)) _p.current_chest_id.is_open = false;
        _p.current_chest_id = noone;
        _p.show_backpack = false;
    } else {
        _p.show_backpack = !_p.show_backpack;
    }
    if (!_p.show_backpack && _p.held_item != -1) {
        with (_p) add_item(held_item.key, held_item.quantity);
        _p.held_item = -1;
    }
}

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _cols = 8;
var _grid_slot_size = 32 * gui_scale;
var _grid_sp = 2;
var _grid_w = (_cols * _grid_slot_size) + ((_cols - 1) * _grid_sp);
var _gap = 40 * gui_scale;
var _total_w = (_p.show_shipping || _p.show_chest) ? (_grid_w * 2) + _gap : _grid_w;
var _base_x = (display_get_gui_width() / 2) - (_total_w / 2);
var _base_y = (display_get_gui_height() * 0.45);

var _l_press = mouse_check_button_pressed(mb_left);
var _r_press = mouse_check_button_pressed(mb_right);
var _r_held  = mouse_check_button(mb_right);

if (_l_press || _r_press || _r_held) {
    var _clicked_on_ui = false;

    var _do_split = _r_press;
    if (_r_held && !_r_press) {
        _p.split_timer += 1;
        if (_p.split_timer >= split_delay_frames()) {
            _do_split = true;
            _p.split_timer = 0;
        }
    } else if (!_r_held) {
        _p.split_timer = 0;
    }

    if (_my >= menu_y_start && _my <= menu_y_start + slot_size) {
        for (var i = 0; i < total_slots; i++) {
            var _x1 = menu_x_start + (i * (slot_size + spacing));
            if (_mx >= _x1 && _mx <= _x1 + slot_size) {
                _clicked_on_ui = true;
                if (_l_press) {
                    if (is_struct(_p.held_item) || _p.show_backpack || _p.show_shipping || _p.show_chest) with (_p) scr_inventory_swap(inventory_array, i);
                    else _p.selected_slot = i;
                } else if (_do_split) {
                    with (_p) scr_inventory_split(inventory_array, i);
                }
                break;
            }
        }
    }

    if (_p.show_backpack) {
        var _rows = ceil(max_backpack_slots / _cols);
        var _bh = (_rows * _grid_slot_size) + ((_rows - 1) * _grid_sp);
        var _bx = _base_x;
        var _by = _base_y - (_bh / 2);
        if (point_in_rectangle(_mx, _my, _bx, _by, _bx + _grid_w, _by + _bh)) {
            _clicked_on_ui = true;
            for (var i = 0; i < max_backpack_slots; i++) {
                var _sx = _bx + (i mod _cols * (_grid_slot_size + _grid_sp));
                var _sy = _by + (i div _cols * (_grid_slot_size + _grid_sp));
                if (point_in_rectangle(_mx, _my, _sx, _sy, _sx + _grid_slot_size, _sy + _grid_slot_size)) {
                    if (_l_press) with (_p) scr_inventory_swap(backpack_array, i);
                    else if (_do_split) with (_p) scr_inventory_split(backpack_array, i);
                    break;
                }
            }
        }
    }

    if (_p.show_shipping) {
        var _sh = (8 * _grid_slot_size) + (7 * _grid_sp);
        var _sx_base = _base_x + _grid_w + _gap;
        var _sy_base = _base_y - (_sh / 2);
        if (point_in_rectangle(_mx, _my, _sx_base, _sy_base, _sx_base + _grid_w, _sy_base + _sh)) {
            _clicked_on_ui = true;
            for (var i = 0; i < max_shipping_slots; i++) {
                var _sx = _sx_base + (i mod _cols * (_grid_slot_size + _grid_sp));
                var _sy = _sy_base + (i div _cols * (_grid_slot_size + _grid_sp));
                if (point_in_rectangle(_mx, _my, _sx, _sy, _sx + _grid_slot_size, _sy + _grid_slot_size)) {
                    if (_l_press) with (_p) scr_inventory_swap(shipping_array, i);
                    else if (_do_split) with (_p) scr_inventory_split(shipping_array, i);
                    break;
                }
            }
        }
    }

    if (_p.show_chest && instance_exists(_p.current_chest_id)) {
        var _sh = (8 * _grid_slot_size) + (7 * _grid_sp);
        var _sx_base = _base_x + _grid_w + _gap;
        var _sy_base = _base_y - (_sh / 2);
        if (point_in_rectangle(_mx, _my, _sx_base, _sy_base, _sx_base + _grid_w, _sy_base + _sh)) {
            _clicked_on_ui = true;
            for (var i = 0; i < 64; i++) {
                var _sx = _sx_base + (i mod _cols * (_grid_slot_size + _grid_sp));
                var _sy = _sy_base + (i div _cols * (_grid_slot_size + _grid_sp));
                if (point_in_rectangle(_mx, _my, _sx, _sy, _sx + _grid_slot_size, _sy + _grid_slot_size)) {
                    if (_l_press) with (_p) scr_inventory_swap(current_chest_id.storage_array, i);
                    else if (_do_split) with (_p) scr_inventory_split(current_chest_id.storage_array, i);
                    if (instance_exists(obj_net) && obj_net.is_connected) {
                        var _chest = _p.current_chest_id;
                        net_send_chest_slot(_chest.x, _chest.y, room_get_name(room),
                                            i, _chest.storage_array[i]);
                    }
                    break;
                }
            }
        }
    }

    if (!_clicked_on_ui && _l_press && is_struct(_p.held_item)) {
        var _item_data = scr_get_item_data(_p.held_item.key);
        if (is_struct(_item_data) && variable_struct_exists(_item_data, "droppable") && _item_data.droppable == false) {
            scr_notify("Este objeto no se puede tirar");
        } else {
            inventory_drop_item(_p.held_item.key, _p.held_item.quantity, _p.x, _p.y, 30);
            _p.held_item = -1;
        }
    }
}

if (!_p.show_backpack && !_p.show_shipping && !_p.show_chest) {
    if (mouse_wheel_up()) _p.selected_slot = (_p.selected_slot - 1 + total_slots) mod total_slots;
    if (mouse_wheel_down()) _p.selected_slot = (_p.selected_slot + 1) mod total_slots;
    if (keyboard_check_pressed(ord("Q"))) {
        var _slot_data = _p.inventory_array[_p.selected_slot];
        if (is_struct(_slot_data)) {
            var _item_data = scr_get_item_data(_slot_data.key);
            if (is_struct(_item_data) && variable_struct_exists(_item_data, "droppable") && _item_data.droppable == false) {
                scr_notify("Este objeto no se puede tirar");
            } else {
                inventory_drop_item(_slot_data.key, _slot_data.quantity, _p.x, _p.y, 30);
                _p.inventory_array[_p.selected_slot] = -1;
            }
        }
    }
}

// Helper local: el split_delay historico (constante).
function split_delay_frames() { return 10; }
