image_angle = point_direction(0, 0, hspeed, vspeed);

if (x < 0 || x > room_width || y < 0 || y > room_height) {
    instance_destroy();
    exit;
}

if (place_meeting(x, y, obj_collision)) {
    instance_destroy();
    exit;
}

var _hit = instance_place(x, y, obj_player);
if (_hit != noone) {
    scr_player_take_damage(_hit, damage);
    audio_play_sound(sound_hurt, 1, false);
    instance_destroy();
    exit;
}
