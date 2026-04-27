if (has_hit) {
    hspeed = 0;
    vspeed = 0;
    hit_timer++;
    image_index = 4 + min(hit_timer, 3);
    if (hit_timer >= 4) instance_destroy();
    exit;
}

// Despawn when out of room
if (x < 0 || x > room_width || y < 0 || y > room_height) {
    instance_destroy();
    exit;
}

// Wall collision
if (instance_place(x, y, obj_collision)) {
    audio_play_sound(sound_arrow_hit, 1, false);
    has_hit = true;
    exit;
}

// Wild animal collision — explicit loop avoids with-block scoping issues
var _hit = noone;
var _cx  = x + 8;
var _cy  = y + 8;
for (var _i = instance_number(obj_wild_animal) - 1; _i >= 0; _i--) {
    var _an = instance_find(obj_wild_animal, _i);
    var _sw = sprite_get_width(_an.sprite_index);
    var _sh = sprite_get_height(_an.sprite_index);
    if (point_in_rectangle(_cx, _cy, _an.x, _an.y, _an.x + _sw - 1, _an.y + _sh - 1)) {
        _hit = _an;
        break;
    }
}
if (_hit != noone) {
    audio_play_sound(sound_arrow_hit, 1, false);
    _hit.hp -= damage;
    _hit.hurt_flash_timer = 15;
    if (_hit.state != ANIMAL_STATE.FLEEING) {
        _hit.state      = ANIMAL_STATE.FLEEING;
        _hit.flee_timer = 90;
        var _fdir = point_direction(x, y, _hit.x, _hit.y);
        if (_fdir >= 45 && _fdir < 135)       _hit.dir = DIR.UP;
        else if (_fdir >= 135 && _fdir < 225) _hit.dir = DIR.LEFT;
        else if (_fdir >= 225 && _fdir < 315) _hit.dir = DIR.DOWN;
        else                                   _hit.dir = DIR.RIGHT;
    }
    has_hit = true;
    exit;
}
