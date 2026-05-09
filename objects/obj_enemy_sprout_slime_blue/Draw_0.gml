var _blend   = (hurt_flash_timer > 0) ? c_red : c_white;
var _xscale  = 1;
var _dir_idx = 0;
switch (dir) {
    case DIR.DOWN:  _dir_idx = 0; break;
    case DIR.UP:    _dir_idx = 1; break;
    case DIR.RIGHT: _dir_idx = 2; break;
    case DIR.LEFT:  _dir_idx = 2; _xscale = -1; break;
}

var _sprite;
if (is_dying > 0)             _sprite = sprite_dead;
else if (hurt_anim_timer > 0) _sprite = sprite_damage;
else if (state == ANIMAL_STATE.CHASING || state == ANIMAL_STATE.WANDERING) _sprite = sprite_walk;
else                          _sprite = sprite_idle;

var _fpd   = sprite_get_number(_sprite) / 3;
var _frame = floor(frame_anim) mod max(1, _fpd);
var _si    = _dir_idx * _fpd + _frame;

draw_sprite_ext(_sprite, _si, x + 2, y + 1.5, _xscale, 1, 0, c_black, 0.4);
draw_sprite_ext(_sprite, _si, x,     y,       _xscale, 1, 0, _blend,   1);

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
