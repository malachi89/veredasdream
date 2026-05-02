var _hurt_just_started = (hurt_anim_timer == 15);

// Sincronizar anim_frames con el sprite activo ANTES de que el padre avance frame_anim
var _active_spr;
if (is_dying > 0) {
    _active_spr = sprite_dead;
} else if (hurt_anim_timer > 0) {
    _active_spr = sprite_damage;
} else if (state == ANIMAL_STATE.CHASING) {
    if (instance_exists(obj_player) && point_distance(x, y, obj_player.x, obj_player.y) < attack_range + 16) {
        _active_spr = sprite_attack;
    } else {
        _active_spr = sprite_run;
    }
} else if (state == ANIMAL_STATE.WANDERING) {
    _active_spr = sprite_walk;
} else {
    _active_spr = sprite_idle;
}
anim_frames = sprite_get_number(_active_spr) / 3;

event_inherited();
if (hurt_anim_timer > 0) hurt_anim_timer -= 1;

// Resetear frame al inicio de muerte o daño para que arranquen desde frame 0
if (_hurt_just_started || is_dying == death_anim_frames) frame_anim = 0;
