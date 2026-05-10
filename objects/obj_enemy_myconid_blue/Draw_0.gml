var _blend = (hurt_flash_timer > 0) ? c_red : c_white;

var _sprite = sprite_idle;
if (is_dying > 0) {
    _sprite = sprite_dead;
} else if (hurt_anim_timer > 0) {
    _sprite = sprite_damage;
} else if (state == ANIMAL_STATE.WANDERING) {
    _sprite = sprite_walk;
} else if (state == ANIMAL_STATE.CHASING) {
    if (instance_exists(obj_player) && point_distance(x, y, obj_player.x, obj_player.y) < attack_range + 16) {
        _sprite = sprite_attack;
    } else {
        _sprite = sprite_walk;
    }
}

var _fpd = sprite_get_number(_sprite) / 4;
var _dir_index = 0;
switch (dir) {
    case DIR.DOWN:  _dir_index = 0; break;
    case DIR.UP:    _dir_index = 1; break;
    case DIR.RIGHT: _dir_index = 2; break;
    case DIR.LEFT:  _dir_index = 3; break;
}

var _frame = floor(frame_anim) mod _fpd;
if (_frame < 0) _frame += _fpd;
var _si = _dir_index * _fpd + _frame;

draw_sprite_ext(_sprite, _si, x + 1.2, y + 1, 1, 1, 0, c_black, 0.4);
draw_sprite_ext(_sprite, _si, x, y, 1, 1, 0, _blend, 1);

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
