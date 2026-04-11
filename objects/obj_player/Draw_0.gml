
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
var _skin_s    = get_sprite_set(sprite_player_idle,         sprite_player_walk,         sprite_player_run,         action_sprite_skin);
var _clothes_s = get_sprite_set(sprite_player_clothes_idle, sprite_player_clothes_walk, sprite_player_clothes_run, action_sprite_clothes);
var _eyes_s    = get_sprite_set(sprite_player_eyes_idle,    sprite_player_eyes_walk,    sprite_player_eyes_run,    action_sprite_eyes);
var _hair_s    = get_sprite_set(sprite_player_hair_idle,    sprite_player_hair_walk,    sprite_player_hair_run,    action_sprite_hair);

// 1. Dibujar Piel (Capa base)
draw_sprite(_skin_s, image_index, x, y);

// 2. Dibujar Ojos
draw_sprite(_eyes_s, image_index, x, y);

// 3. Dibujar Ropa
draw_sprite(_clothes_s, image_index, x, y);

// 4. Dibujar Pelo
draw_sprite(_hair_s, image_index, x, y);

// 5. Dibujar Herramienta (Solo si está en estado ACTING)
if (state == STATE.ACTING) {
    draw_sprite(action_sprite_tool, image_index, x, y);
}