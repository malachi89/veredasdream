
var _h = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var _v = keyboard_check(ord("S")) - keyboard_check(ord("W"));
var _run = keyboard_check(vk_shift);

var _mag = point_distance(0, 0, _h, _v);
var prev_state = state;

if (_mag == 0) {
    state = STATE.IDLE;
} else {
    state = _run ? STATE.RUN : STATE.WALK;

    if (abs(_h) > abs(_v))
        dir = (_h > 0) ? DIR.RIGHT : DIR.LEFT;
    else
        dir = (_v > 0) ? DIR.DOWN : DIR.UP;
}

// ==========================================
// NUEVA MECÁNICA: ARAR EL SUELO
// ==========================================
if (keyboard_check_pressed(vk_space)) {
    var _dist = 16; // Distancia frente al jugador
    var _tx = x;
    var _ty = y;

    // Calculamos la posición según tu variable 'dir'
    switch(dir) {
        case DIR.RIGHT: _tx += _dist; break;
        case DIR.LEFT:  _tx -= _dist; break;
        case DIR.DOWN:  _ty += _dist; break;
        case DIR.UP:    _ty -= _dist; break;
    }

    var _lay_id = layer_get_id("Tiles_tilled_watered");
    var _map_id = layer_tilemap_get_id(_lay_id);

    // Colocamos el tile del autotile (usualmente el índice 1 es el primero)
    tilemap_set_at_pixel(_map_id, 72 , _tx, _ty);
}
// ==========================================

var mx = 0;
var my = 0;

if (_mag != 0) {
    var spd = (_run ? move_speed_run : move_speed);
    

    mx = (_h / _mag) * spd;
    my = (_v / _mag) * spd;
}


move_and_collide(mx, my, obj_collision, 4, 0, 0, -1, -1);

hspeed = mx;
vspeed = my;
x -= hspeed; 
y -= vspeed; 


if (state != prev_state) frame_anim = 0;

switch (state) {
    case STATE.IDLE:
        sprite_index = sprite_player_idle;
        frame_anim += 0.1; 
        if (frame_anim >= frames_idle) frame_anim = 0;
        image_index = dir * frames_idle + floor(frame_anim);
    break;

    case STATE.WALK:
        sprite_index = sprite_player_walk;
        frame_anim += 0.15;
        if (frame_anim >= frames_walk) frame_anim = 0;
        image_index = dir * frames_walk + floor(frame_anim);
    break;

    case STATE.RUN:
        sprite_index = sprite_player_run;
        frame_anim += 0.25;
        if (frame_anim >= frames_run) frame_anim = 0;
        image_index = dir * frames_run + floor(frame_anim);
    break;
}

image_speed = 0;