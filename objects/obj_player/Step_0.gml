// INPUT
var _h = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var _v = keyboard_check(ord("S")) - keyboard_check(ord("W"));
var _run = keyboard_check(vk_shift);

// NORMALIZAR
var _mag = point_distance(0, 0, _h, _v);

// -------- ESTADO --------
var prev_state = state;

if (_mag == 0)
{
    state = STATE.IDLE;
}
else
{
    state = _run ? STATE.RUN : STATE.WALK;
}

// -------- DIRECCIÓN --------
if (_mag != 0)
{
    if (abs(_h) > abs(_v))
        dir = (_h > 0) ? DIR.RIGHT : DIR.LEFT;
    else
        dir = (_v > 0) ? DIR.DOWN : DIR.UP;
}

// -------- MOVIMIENTO --------
if (_mag != 0)
{
    var spd = (_run ? move_speed_run : move_speed);

    var mx = (_h / _mag) * spd;
    var my = (_v / _mag) * spd;

    // 🔥 IMPORTANTE: guardar dirección para la cámara
    hspeed = mx;
    vspeed = my;

    move_and_collide(mx, my, obj_collision);
}
else
{
    // 🔥 IMPORTANTE: detener look-ahead de la cámara
    hspeed = 0;
    vspeed = 0;
}

// -------- CAMBIO DE ESTADO --------
if (state != prev_state)
{
    frame_anim = 0;
}

// -------- ANIMACIÓN --------
switch (state)
{
    case STATE.IDLE:
        sprite_index = sprite_player_idle;

        frame_anim += 0.05;
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

        frame_anim += 0.4;
        if (frame_anim >= frames_run) frame_anim = 0;

        image_index = dir * frames_run + floor(frame_anim);
    break;
}

image_speed = 0;