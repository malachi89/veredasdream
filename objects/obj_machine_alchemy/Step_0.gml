depth = -bbox_bottom;

var _lp = global.local_player;
if (instance_exists(_lp) && !_lp.shop_open) {
    var _dist = point_distance(x, y, _lp.x, _lp.y);
    if (_dist < 48 && keyboard_check_pressed(ord("E"))) {
        _lp.shop_open      = true;
        _lp.shop_npc_key   = "machine_alchemy";
        _lp.shop_scroll    = 0;
        _lp.shop_msg       = "";
        _lp.shop_msg_timer = 0;
    }
}
