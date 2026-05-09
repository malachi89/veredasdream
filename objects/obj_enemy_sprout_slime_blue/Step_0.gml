var _hurt_just_started = (hurt_anim_timer == 15);
var _prev_dying        = is_dying;

var _active_spr;
if (is_dying > 0)             _active_spr = sprite_dead;
else if (hurt_anim_timer > 0) _active_spr = sprite_damage;
else if (state == ANIMAL_STATE.CHASING || state == ANIMAL_STATE.WANDERING) _active_spr = sprite_walk;
else                          _active_spr = sprite_idle;
anim_frames = sprite_get_number(_active_spr) / 3;

event_inherited();
if (hurt_anim_timer > 0) hurt_anim_timer -= 1;
if (_hurt_just_started || is_dying == death_anim_frames) frame_anim = 0;
if (state == ANIMAL_STATE.IDLE && hurt_anim_timer <= 0 && is_dying <= 0) frame_anim = 0;

// Aggro proactivo
if (is_dying <= 0 && state != ANIMAL_STATE.CHASING && instance_exists(obj_player)
        && point_distance(x, y, obj_player.x, obj_player.y) < 200) {
    state       = ANIMAL_STATE.CHASING;
    chase_timer = chase_timer_max;
}

// Sonido movimiento (timer propio, snd_move no definido en enemy_data)
if (state == ANIMAL_STATE.CHASING) {
    if (sprout_move_snd_timer > 0) sprout_move_snd_timer--;
    if (sprout_move_snd_timer <= 0) {
        scr_play_sound_clip(sound_sprout_slime, 2.50, 3.00);
        sprout_move_snd_timer = 90;
    }
} else {
    sprout_move_snd_timer = 0;
}

if (_hurt_just_started)              scr_play_sound_clip(sound_sprout_slime, 0.25, 1.00);
if (is_dying > 0 && _prev_dying == 0) scr_play_sound_clip(sound_sprout_slime, 4.20, 5.00);
