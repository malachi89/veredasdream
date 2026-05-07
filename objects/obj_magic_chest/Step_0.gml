var _lp = global.local_player;
if (instance_exists(_lp) && !is_open) {
    if (point_distance(x + 8, y + 8, _lp.x, _lp.y) < 48
        && keyboard_check_pressed(ord("E"))) {
        is_open = true;
        var _inv_full = false;
        for (var i = 0; i < array_length(loot); i++) {
            var _item  = loot[i];
            var _added = false;
            with (_lp) { _added = add_item(_item.key, _item.quantity); }
            if (_added) {
                var _data = scr_get_item_data(_item.key);
                if (_data != undefined) scr_notify_item(_item.quantity, _data.name);
            } else {
                _inv_full = true;
            }
        }
        if (_inv_full) scr_notify("Inventario lleno");
    }
}
depth = -bbox_bottom;
