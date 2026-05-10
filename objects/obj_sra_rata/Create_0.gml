sprite_index = sprite_sra_rata;
image_speed = 0;
image_xscale = 0.67;
image_yscale = 0.67;

dir = DIR.DOWN;
frame_anim = 0;
frames_walk = 3;

is_resting = false;

wander_speed   = 0.5;
wander_timer   = 0;
wander_dx      = 0;
wander_dy      = 0;
wander_resting = false;

is_working      = false;
work_target     = noone;
work_type       = "";
work_progress   = 0;
work_duration   = 0;
work_scan_timer = 0;
work_stuck_time = 0;
work_fail_target = noone;
work_fail_timer = 0;
