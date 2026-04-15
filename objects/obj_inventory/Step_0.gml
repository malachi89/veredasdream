if (instance_exists(obj_controller) && (obj_controller.sleep_menu_open || obj_controller.chat_open)) {
    exit;
}

if (display_get_gui_width() != window_get_width() || display_get_gui_height() != window_get_height()) {
    display_set_gui_size(window_get_width(), window_get_height());
    update_gui_positions();
}

for (var i = 0; i < 9; i++) {
    if (keyboard_check_pressed(ord(string(i + 1)))) selected_slot = i;
}
if (keyboard_check_pressed(ord("0"))) selected_slot = 9;

var _press_open = keyboard_check_pressed(ord("I"));
var _press_close = keyboard_check_pressed(vk_escape);

if (_press_close && (show_backpack || show_shipping || show_chest)) {
    show_backpack = false;
    show_shipping = false;
    show_chest    = false;
    if (instance_exists(current_chest_id)) current_chest_id.is_open = false;
    current_chest_id = noone;
    
    if (held_item != -1) {
        add_item(held_item.key, held_item.quantity);
        held_item = -1;
    }
}

if (_press_open) {
    if (show_shipping || show_chest) {
        show_shipping = false;
        show_chest    = false;
        if (instance_exists(current_chest_id)) current_chest_id.is_open = false;
        current_chest_id = noone;
        show_backpack = false;
    } else {
        show_backpack = !show_backpack;
    }
    if (!show_backpack && held_item != -1) {
        add_item(held_item.key, held_item.quantity);
        held_item = -1;
    }
}

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _cols = 8;
var _grid_slot_size = 32 * gui_scale;
var _grid_sp = 2;
var _grid_w = (_cols * _grid_slot_size) + ((_cols - 1) * _grid_sp);
var _gap = 40 * gui_scale;
var _total_w = (show_shipping || show_chest) ? (_grid_w * 2) + _gap : _grid_w;
var _base_x = (display_get_gui_width() / 2) - (_total_w / 2);
var _base_y = (display_get_gui_height() * 0.45);

var _l_press = mouse_check_button_pressed(mb_left);
var _r_press = mouse_check_button_pressed(mb_right);
var _r_held  = mouse_check_button(mb_right);

if (_l_press || _r_press || _r_held) {
    var _clicked_on_ui = false;
    
    // Si mantenemos presionado el derecho, usamos el timer para ir sacando de 1 en 1
    var _do_split = _r_press;
    if (_r_held && !_r_press) {
        split_timer += 1;
        if (split_timer >= split_delay) {
            _do_split = true;
            split_timer = 0;
        }
    } else if (!_r_held) {
        split_timer = 0;
    }

    if (_my >= menu_y_start && _my <= menu_y_start + slot_size) {
        for (var i = 0; i < total_slots; i++) {
            var _x1 = menu_x_start + (i * (slot_size + spacing));
            if (_mx >= _x1 && _mx <= _x1 + slot_size) {
                _clicked_on_ui = true;
                if (_l_press) {
                    if (is_struct(held_item) || show_backpack || show_shipping || show_chest) scr_inventory_swap(inventory_array, i);
                    else selected_slot = i;
                } else if (_do_split) {
                    scr_inventory_split(inventory_array, i);
                }
                break;
            }
        }
    }

    if (show_backpack) {
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
                    if (_l_press) scr_inventory_swap(backpack_array, i);
                    else if (_do_split) scr_inventory_split(backpack_array, i);
                    break;
                }
            }
        }
    }

    if (show_shipping) {
        var _sh = (8 * _grid_slot_size) + (7 * _grid_sp);
        var _sx_base = _base_x + _grid_w + _gap;
        var _sy_base = _base_y - (_sh / 2);
        if (point_in_rectangle(_mx, _my, _sx_base, _sy_base, _sx_base + _grid_w, _sy_base + _sh)) {
            _clicked_on_ui = true;
            for (var i = 0; i < max_shipping_slots; i++) {
                var _sx = _sx_base + (i mod _cols * (_grid_slot_size + _grid_sp));
                var _sy = _sy_base + (i div _cols * (_grid_slot_size + _grid_sp));
                if (point_in_rectangle(_mx, _my, _sx, _sy, _sx + _grid_slot_size, _sy + _grid_slot_size)) {
                    if (_l_press) scr_inventory_swap(shipping_array, i);
                    else if (_do_split) scr_inventory_split(shipping_array, i);
                    break;
                }
            }
        }
    }
    
    if (show_chest && instance_exists(current_chest_id)) {
        var _sh = (8 * _grid_slot_size) + (7 * _grid_sp);
        var _sx_base = _base_x + _grid_w + _gap;
        var _sy_base = _base_y - (_sh / 2);
        if (point_in_rectangle(_mx, _my, _sx_base, _sy_base, _sx_base + _grid_w, _sy_base + _sh)) {
            _clicked_on_ui = true;
            for (var i = 0; i < 64; i++) {
                var _sx = _sx_base + (i mod _cols * (_grid_slot_size + _grid_sp));
                var _sy = _sy_base + (i div _cols * (_grid_slot_size + _grid_sp));
                if (point_in_rectangle(_mx, _my, _sx, _sy, _sx + _grid_slot_size, _sy + _grid_slot_size)) {
                    if (_l_press) scr_inventory_swap(current_chest_id.storage_array, i);
                    else if (_do_split) scr_inventory_split(current_chest_id.storage_array, i);
                    break;
                }
            }
        }
    }

    if (!_clicked_on_ui && _l_press && is_struct(held_item)) {
        if (instance_exists(obj_player)) {
            var _item_data = scr_get_item_data(held_item.key);
            if (is_struct(_item_data) && variable_struct_exists(_item_data, "droppable") && _item_data.droppable == false) {
                scr_notify("Este objeto no se puede tirar");
            } else {
                inventory_drop_item(held_item.key, held_item.quantity, obj_player.x, obj_player.y, 60);
                held_item = -1;
            }
        }
    }
}

if (!show_backpack && !show_shipping && !show_chest) {
    if (mouse_wheel_up()) selected_slot = (selected_slot - 1 + total_slots) mod total_slots;
    if (mouse_wheel_down()) selected_slot = (selected_slot + 1) mod total_slots;
    if (keyboard_check_pressed(ord("Q"))) {
        var _slot_data = inventory_array[selected_slot];
        if (is_struct(_slot_data) && instance_exists(obj_player)) {
            var _item_data = scr_get_item_data(_slot_data.key);
            if (is_struct(_item_data) && variable_struct_exists(_item_data, "droppable") && _item_data.droppable == false) {
                scr_notify("Este objeto no se puede tirar");
            } else {
                inventory_drop_item(_slot_data.key, _slot_data.quantity, obj_player.x, obj_player.y, 60);
                inventory_array[selected_slot] = -1;
            }
        }
    }
}
