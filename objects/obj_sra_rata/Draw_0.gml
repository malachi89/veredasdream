draw_sprite_ext(sprite_index, image_index, x + 1.2, y + 0.2, image_xscale, image_yscale, 0, c_black, 0.4);
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, 0, c_white, 1);

if (is_working && work_progress > 0 && instance_exists(work_target)) {
    var _bar_w = 24;
    var _bar_h = 3;
    var _cx = x + sprite_get_width(sprite_index) * image_xscale / 2;
    var _bar_x = _cx - _bar_w / 2;
    var _bar_y = y - 12;

    draw_set_color(c_black);
    draw_rectangle(_bar_x - 1, _bar_y - 1, _bar_x + _bar_w + 1, _bar_y + _bar_h + 1, false);

    draw_set_color(c_white);
    draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w, _bar_y + _bar_h, false);

    draw_set_color(c_lime);
    draw_rectangle(_bar_x + 1, _bar_y + 1, _bar_x + (_bar_w - 2) * work_progress, _bar_y + _bar_h - 1, false);
}
