var _hurt_just_started = (hurt_anim_timer == 15);

var _active_spr;
if (is_dying > 0) {
    _active_spr = sprite_dead;
} else if (hurt_anim_timer > 0) {
    _active_spr = sprite_damage;
} else if (state == ANIMAL_STATE.CHASING) {
    if (instance_exists(obj_player) && point_distance(x, y, obj_player.x, obj_player.y) < attack_range + 16) {
        _active_spr = sprite_attack;
    } else {
        _active_spr = sprite_walk;
    }
} else if (state == ANIMAL_STATE.WANDERING) {
    _active_spr = sprite_walk;
} else {
    _active_spr = sprite_idle;
}
anim_frames = sprite_get_number(_active_spr);

event_inherited();
if (hurt_anim_timer > 0) hurt_anim_timer -= 1;

if (_hurt_just_started || is_dying == death_anim_frames) frame_anim = 0;

// Freeze on frame 0 when truly idle (not moving), animate when walking/chasing
if (state == ANIMAL_STATE.IDLE && hurt_anim_timer <= 0 && is_dying <= 0) frame_anim = 0;

if (is_dying <= 0) {
    // Agresivo: detecta al jugador sin necesidad de ser golpeado
    if (state != ANIMAL_STATE.CHASING && instance_exists(obj_player)
            && point_distance(x, y, obj_player.x, obj_player.y) < 220) {
        state = ANIMAL_STATE.CHASING;
        chase_timer = chase_timer_max;
    }

    // Sonido de pasos al caminar (WANDERING), misma logica que CHASING en base
    if (state == ANIMAL_STATE.WANDERING && snd_move != undefined) {
        if (snd_timer <= 0) {
            audio_play_sound(snd_move, 1, false);
            snd_timer = 90;
        }
    }

    // Sonido general al recibir daño
    if (_hurt_just_started && snd_hurt != undefined) {
        audio_play_sound(snd_hurt, 1, false);
    }
}
