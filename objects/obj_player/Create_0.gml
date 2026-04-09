enum DIR {
    DOWN = 0,
    UP = 1,
    RIGHT = 2,
    LEFT = 3
}

enum STATE {
    IDLE,
    WALK,
    RUN
}

dir = DIR.DOWN;
state = STATE.IDLE;

frame_anim = 0;

// velocidades
move_speed = 1.3;
move_speed_run = move_speed * 1.5;

// frames
frames_idle = 4;
frames_walk = 6;
frames_run  = 8;