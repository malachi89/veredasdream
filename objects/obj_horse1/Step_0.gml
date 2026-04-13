// Inicialización de dirección si se pasó desde el room
if (init_dir != -1) {
    dir = init_dir;
    init_dir = -1;
}

// Animación constante
var _anim_speed = 0.1;
if (state == HORSE_STATE.EATING) _anim_speed = 0.15;
frame_anim += _anim_speed;

// Lógica según estado
switch (state) {
    case HORSE_STATE.IDLE:
        if (frame_anim >= 2) frame_anim = 0;
        
        // Solo intentamos comer si no estamos mirando hacia arriba
        if (dir != HORSE_DIR.UP) {
            eat_timer -= 1;
            if (eat_timer <= 0) {
                state = HORSE_STATE.PREPARING_TO_EAT;
                frame_anim = 0;
            }
        }
    break;

    case HORSE_STATE.PREPARING_TO_EAT:
        if (frame_anim >= 4) {
            state = HORSE_STATE.EATING;
            frame_anim = 0;
            eat_loop_count = 0;
        }
    break;

    case HORSE_STATE.EATING:
        if (frame_anim >= 4) {
            frame_anim = 0;
            eat_loop_count += 1;
            if (eat_loop_count >= max_eat_loops) {
                state = HORSE_STATE.IDLE;
                eat_timer = irandom_range(300, 600); // Esperar un poco más para la siguiente vez
            }
        }
    break;

    case HORSE_STATE.PACING:
        if (frame_anim >= 6) frame_anim = 0;
        if (dir == HORSE_DIR.RIGHT) {
            x += move_speed;
            if (x >= x_start + pacing_dist) dir = HORSE_DIR.LEFT;
        } else {
            x -= move_speed;
            if (x <= x_start) dir = HORSE_DIR.RIGHT;
        }
    break;
}

depth = -y;