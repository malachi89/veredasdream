draw_sprite_ext(sprite_index, image_index, x + 1, y + 0.5, image_xscale, image_yscale, image_angle, c_black, 0.4);
draw_self();

var _lp = global.local_player;
if (!instance_exists(_lp)) exit;
if (point_distance(x, y, _lp.x, _lp.y) >= 48) exit;
if (_lp.shop_open || _lp.dialog_open) exit;

draw_set_halign(fa_left);
draw_set_valign(fa_top);
