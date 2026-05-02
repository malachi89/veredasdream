var _blend = (hurt_flash_timer > 0) ? c_red : c_white;

var _strip = 0;
var _xscale = 1;

if (is_dying > 0) {
    switch (dir) {
        case DIR.LEFT:  _strip = 36; break;
        case DIR.RIGHT: _strip = 36; _xscale = -1; break;
        case DIR.DOWN:  _strip = 40; break;
        case DIR.UP:    _strip = 40; break;
    }
} else if (hurt_anim_timer > 0) {
    switch (dir) {
        case DIR.LEFT:  _strip = 24; break;
        case DIR.RIGHT: _strip = 24; _xscale = -1; break;
        case DIR.DOWN:  _strip = 28; break;
        case DIR.UP:    _strip = 32; break;
    }
} else if (state == ANIMAL_STATE.CHASING) {
    switch (dir) {
        case DIR.LEFT:  _strip = 12; break;
        case DIR.RIGHT: _strip = 12; _xscale = -1; break;
        case DIR.DOWN:  _strip = 16; break;
        case DIR.UP:    _strip = 20; break;
    }
} else {
    switch (dir) {
        case DIR.LEFT:  _strip = 0; break;
        case DIR.RIGHT: _strip = 0; _xscale = -1; break;
        case DIR.DOWN:  _strip = 4; break;
        case DIR.UP:    _strip = 8; break;
    }
}

var _frame  = floor(frame_anim) mod 4;
var _si     = _strip + _frame;
image_index = _si;

var _spr_w  = sprite_get_width(sprite_index);
var _spr_ox = sprite_get_xoffset(sprite_index);
var _draw_x = (_xscale < 0) ? x + _spr_w - 2 * _spr_ox : x;

draw_sprite_ext(sprite_index, _si, _draw_x + 1.2, y + 1, _xscale, 1, 0, c_black, 0.4);
draw_sprite_ext(sprite_index, _si, _draw_x,       y,     _xscale, 1, 0, _blend,  1);

if (hp < max_hp) {
    var _bar_w = 20;
    var _bar_h = 2;
    var _px = x + _spr_w / 2 - _spr_ox - _bar_w / 2;
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
