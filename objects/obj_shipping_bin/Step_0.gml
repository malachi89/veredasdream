var _lp = global.local_player;
if (instance_exists(_lp)) {
    var _dist = point_distance(x, y, _lp.x, _lp.y);

    if (_dist < 48) {
        if (keyboard_check_pressed(ord("E"))) {
            _lp.show_shipping = !_lp.show_shipping;
            _lp.show_backpack = _lp.show_shipping;

            if (!_lp.show_shipping && _lp.held_item != -1) {
                with (_lp) add_item(held_item.key, held_item.quantity);
                _lp.held_item = -1;
            }
        }
    } else {
        if (_lp.show_shipping) {
            _lp.show_shipping = false;
            _lp.show_backpack = false;
            if (_lp.held_item != -1) {
                with (_lp) add_item(held_item.key, held_item.quantity);
                _lp.held_item = -1;
            }
        }
    }
}
