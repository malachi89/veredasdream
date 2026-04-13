// Función para obtener el sprite correcto según el estado
function get_sprite_set(_idle, _walk, _run, _action)
{
    switch (state)
    {
        case STATE.IDLE:   return _idle;
        case STATE.WALK:   return _walk;
        case STATE.RUN:    return _run;
        case STATE.ACTING: return _action;
        default:           return _idle;
    }
}

// Seleccionar los sprites de las capas
var _skin_s, _clothes_s, _eyes_s, _hair_s;
var _horse_s = noone;
var _saddle_s = noone;

if (is_riding) {
    _skin_s    = get_sprite_set(sprite_player_horse1_body_idle,    sprite_player_horse1_body_walk,    sprite_player_horse1_body_run,    -1);
    _clothes_s = get_sprite_set(sprite_player_horse1_clothes_idle, sprite_player_horse1_clothes_walk, sprite_player_horse1_clothes_run, -1);
    _eyes_s    = get_sprite_set(sprite_player_horse1_eyes_idle,    sprite_player_horse1_eyes_walk,    sprite_player_horse1_eyes_run,    -1);
    _hair_s    = get_sprite_set(sprite_player_horse1_hair_idle,    sprite_player_horse1_hair_walk,    sprite_player_horse1_hair_run,    -1);
    _horse_s   = get_sprite_set(sprite_player_horse1_horse_idle,   sprite_player_horse1_horse_walk,   sprite_player_horse1_horse_run,   -1);
    _saddle_s  = get_sprite_set(sprite_player_horse1_saddle_idle,  sprite_player_horse1_saddle_walk,  sprite_player_horse1_saddle_run,  -1);
} else {
    _skin_s    = get_sprite_set(sprite_player_idle,         sprite_player_walk,         sprite_player_run,         action_sprite_skin);
    _clothes_s = get_sprite_set(sprite_player_clothes_idle, sprite_player_clothes_walk, sprite_player_clothes_run, action_sprite_clothes);
    _eyes_s    = get_sprite_set(sprite_player_eyes_idle,    sprite_player_eyes_walk,    sprite_player_eyes_run,    action_sprite_eyes);
    _hair_s    = get_sprite_set(sprite_player_hair_idle,    sprite_player_hair_walk,    sprite_player_hair_run,    action_sprite_hair);
}

// 0. Dibujar Caballo (si estamos montando)
if (is_riding && _horse_s != noone) {
    draw_sprite(_horse_s, image_index, x, y);
}

// 1. Dibujar Piel (Capa base)
draw_sprite(_skin_s, image_index, x, y);

// 2. Dibujar Ojos
draw_sprite(_eyes_s, image_index, x, y);

// 3. Dibujar Ropa
draw_sprite(_clothes_s, image_index, x, y);

// 4. Dibujar Pelo
draw_sprite(_hair_s, image_index, x, y);

// 5. Dibujar Montura (si estamos montando)
if (is_riding && _saddle_s != noone) {
    draw_sprite(_saddle_s, image_index, x, y);
}

// 6. Dibujar Herramienta (Solo si está en estado ACTING y no estamos montando)
if (state == STATE.ACTING && !is_riding) {
    draw_sprite(action_sprite_tool, image_index, x, y);
}