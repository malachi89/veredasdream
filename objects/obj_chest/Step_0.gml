/// @description Interaccion con el cofre
var _lp = global.local_player;
if (instance_exists(_lp)) {
    var _dist = point_distance(x + 16, y + 8, _lp.x, _lp.y);

    if (_dist < 40) {
        if (keyboard_check_pressed(ord("E"))) {
            is_open = !is_open;
            if (is_open) {
                _lp.show_backpack    = true;
                _lp.show_shipping    = false;
                _lp.show_chest       = true;
                _lp.current_chest_id = id;
            } else {
                _lp.show_backpack    = false;
                _lp.show_chest       = false;
                _lp.current_chest_id = noone;

                if (_lp.held_item != -1) {
                    with (_lp) add_item(held_item.key, held_item.quantity);
                    _lp.held_item = -1;
                }
                if (global.net_role == NET_ROLE.HOST
                    && instance_exists(obj_net) && obj_net.is_connected) {
                    scr_capture_current_room_state();
                    net_broadcast_room_state(room_get_name(room));
                }
            }
        }

        if (mouse_check_button_pressed(mb_right) && !_lp.show_backpack) {
            var _is_empty = true;
            for (var i = 0; i < 64; i++) {
                if (storage_array[i] != -1) { _is_empty = false; break; }
            }

            if (_is_empty) {
                if (_lp.add_item("chest", 1)) {
                    scr_notify("Cofre recogido");
                    instance_destroy();
                } else {
                    scr_notify("Inventario lleno");
                }
            } else {
                scr_notify("Vacia el cofre antes de recogerlo");
            }
        }
    } else if (is_open) {
        is_open = false;
        if (_lp.current_chest_id == id) {
            _lp.show_backpack    = false;
            _lp.show_chest       = false;
            _lp.current_chest_id = noone;

            if (_lp.held_item != -1) {
                with (_lp) add_item(held_item.key, held_item.quantity);
                _lp.held_item = -1;
            }
            if (global.net_role == NET_ROLE.HOST
                && instance_exists(obj_net) && obj_net.is_connected) {
                scr_capture_current_room_state();
                net_broadcast_room_state(room_get_name(room));
            }
        }
    }
}

image_speed = 0;
image_index = is_open ? 8 : 0;
depth = -bbox_bottom;
