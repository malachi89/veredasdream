draw_sprite_ext(sprite_index, image_index, x + 1, y + 0.5, image_xscale, image_yscale, image_angle, c_black, 0.4);
draw_self();

var _lp = global.local_player;
if (!instance_exists(_lp)) exit;
if (point_distance(x, y, _lp.x, _lp.y) >= 48) exit;
if (_lp.shop_open || _lp.dialog_open) exit;

draw_set_font(fnt_pixel_operator);
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_set_color(c_white);
draw_text(x, bbox_top - 4, "[E] Donar");
draw_set_halign(fa_left);
draw_set_valign(fa_top);
