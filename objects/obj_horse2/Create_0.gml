event_inherited();

state = HORSE_STATE.IDLE;
dir = HORSE_DIR.DOWN; // Valor por defecto
move_speed = 0.5;
frame_anim = 0;

// Configuración de Sprites Base
sprite_walk    = sprite_horse_2_run;
sprite_idle    = sprite_horse_2_idle;
sprite_prepare = sprite_horse_2_preparing_to_eat;
sprite_eating  = sprite_horse_2_eating;

// Configuración de Sprites de Montura (Saddle)
saddle_walk    = sprite_horse_2_saddle_run;
saddle_idle    = sprite_horse_2_saddle_idle;
saddle_prepare = sprite_horse_2_saddle_preparing_to_eat;
saddle_eating  = sprite_horse_2_saddle_eating;

// Lógica de comer
eat_timer = irandom_range(120, 300); 
eat_loop_count = 0;
max_eat_loops = 3;

// Lógica simple de paseo (pacing)
x_start = x;
y_start = y;
pacing_dist = 64;

// Nota: init_dir ya está definida en las "Variable Definitions" del objeto (.yy)
// No la inicializamos aquí para no sobreescribir el valor del editor de niveles.