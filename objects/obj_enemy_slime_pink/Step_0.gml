var _hurt_just_started = (hurt_anim_timer == 15);
event_inherited();
if (hurt_anim_timer > 0) hurt_anim_timer -= 1;
if (_hurt_just_started || is_dying == death_anim_frames) frame_anim = 0;
