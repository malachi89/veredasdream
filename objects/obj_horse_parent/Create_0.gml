state = HORSE_STATE.IDLE;
dir = HORSE_DIR.DOWN; 
move_speed = 0.5;
frame_anim = 0;

// Sprites (A definir en los hijos)
sprite_walk    = noone;
sprite_idle    = noone;
sprite_prepare = noone;
sprite_eating  = noone;

saddle_walk    = noone;
saddle_idle    = noone;
saddle_prepare = noone;
saddle_eating  = noone;

// Lógica de comer
eat_timer = irandom_range(120, 300); 
eat_loop_count = 0;
max_eat_loops = 3;

// Lógica simple de paseo (pacing)
x_start = x;
y_start = y;
pacing_dist = 64;
