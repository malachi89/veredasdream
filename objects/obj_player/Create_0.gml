// Variables para controlar la animación de acción
is_riding = false;
action_sprite_skin = -1;
action_sprite_tool = -1;
action_sprite_hair = -1;
action_sprite_clothes = -1;
action_sprite_eyes = -1;
action_quality = 0;
frames_action = 6;

dir = DIR.DOWN;
state = STATE.IDLE;

frame_anim = 0;


move_speed = 1.3;
move_speed_run = move_speed * 1.5;


frames_idle = 4;
frames_walk = 6;
frames_run  = 8;

max_energy = 500;
energy = 500;

tool_cooldown = 0;