enum DIR {
    DOWN = 0,
    UP = 1,
    RIGHT = 2,
    LEFT = 3
}

enum STATE {
    IDLE,
    WALK,
    RUN,
    ACTING // Nuevo estado para usar herramientas
}

// Variables para controlar la animación de acción
action_sprite_skin = -1;
action_sprite_tool = -1;
action_sprite_hair = -1;
action_sprite_clothes = -1;
action_sprite_eyes = -1;
frames_action = 6;

dir = DIR.DOWN;
state = STATE.IDLE;

frame_anim = 0;


move_speed = 1.3;
move_speed_run = move_speed * 1.5;


frames_idle = 4;
frames_walk = 6;
frames_run  = 8;