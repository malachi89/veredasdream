var _blend = (hurt_flash_timer > 0) ? c_red : c_white;
var _frame = floor(frame_anim);

draw_sprite_ext(sprite_index, _frame, x + 1.2, y + 1, 1, 1, 0, c_black, 0.4);
draw_sprite_ext(sprite_index, _frame, x, y, 1, 1, 0, _blend, 1);

if (hp < max_hp) {
    var _bar_w = 20;
    var _bar_h = 2;
    var _px = x + (sprite_width / 2) - (_bar_w / 2);
    var _py = bbox_top - 8;

    draw_set_color(c_black);
    draw_rectangle(_px - 1, _py - 1, _px + _bar_w + 1, _py + _bar_h + 1, false);

    draw_set_color(c_red);
    draw_rectangle(_px, _py, _px + _bar_w, _py + _bar_h, false);

    draw_set_color(c_lime);
    var _fill_w = (hp / max_hp) * _bar_w;
    if (_fill_w > 0) draw_rectangle(_px, _py, _px + _fill_w, _py + _bar_h, false);

    draw_set_color(c_white);
}
