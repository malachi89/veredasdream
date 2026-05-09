var _blend = (hurt_flash_timer > 0) ? c_red : c_white;
var _total = sprite_get_number(sprite_index);
var _frame = floor(frame_anim) mod max(1, _total);
if (_frame < 0) _frame = 0;

draw_sprite_ext(sprite_index, _frame, x + 2, y + 1.5, 1, 1, 0, c_black, 0.4);
draw_sprite_ext(sprite_index, _frame, x,     y,       1, 1, 0, _blend,   1);

if (hp < max_hp) {
    var _bw = 20;
    var _bh = 2;
    var _bx = x - _bw / 2;
    var _by = bbox_top - 8;
    draw_set_color(c_black);
    draw_rectangle(_bx - 1, _by - 1, _bx + _bw + 1, _by + _bh + 1, false);
    draw_set_color(c_red);
    draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);
    draw_set_color(c_lime);
    var _fw = (hp / max_hp) * _bw;
    if (_fw > 0) draw_rectangle(_bx, _by, _bx + _fw, _by + _bh, false);
    draw_set_color(c_white);
}
