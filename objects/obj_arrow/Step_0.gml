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

// Animal collision - use instance_place for better accuracy and mask support
var _hit = instance_place(x, y, obj_wild_animal);
if (_hit == noone) _hit = instance_place(x, y, obj_farm_animal);

if (_hit != noone) {
    audio_play_sound(sound_arrow_hit, 1, false);
    _hit.hp -= damage;
    _hit.hurt_flash_timer = 15;
    
    // Forest animals panic and run faster when hit
    if (object_get_name(_hit.object_index) == "obj_wild_animal") {
        _hit.is_panicked = true;
        _hit.flee_timer = 180; // Panicked flee lasts longer
    } else {
        _hit.flee_timer = 90;
    }
    
    _hit.state = ANIMAL_STATE.FLEEING;
    var _fdir = point_direction(x, y, _hit.x, _hit.y);
    if (_fdir >= 45 && _fdir < 135)       _hit.dir = DIR.UP;
    else if (_fdir >= 135 && _fdir < 225) _hit.dir = DIR.LEFT;
    else if (_fdir >= 225 && _fdir < 315) _hit.dir = DIR.DOWN;
    else                                   _hit.dir = DIR.RIGHT;
    
    has_hit = true;
    exit;
}

// Wall collision
if (instance_place(x, y, obj_collision)) {
    audio_play_sound(sound_arrow_hit, 1, false);
    has_hit = true;
    exit;
}
