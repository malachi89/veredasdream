
function get_sprite_set(_idle, _walk, _run)
{
    switch (state)
    {
        case STATE.IDLE: return _idle;
        case STATE.WALK: return _walk;
        case STATE.RUN:  return _run;
    }
}


draw_self();


var clothes_sprite = get_sprite_set(
    sprite_player_clothes_idle,
    sprite_player_clothes_walk,
    sprite_player_clothes_run
);

var hair_sprite = get_sprite_set(
    sprite_player_hair_idle,
    sprite_player_hair_walk,
    sprite_player_hair_run
);

var eyes_sprite = get_sprite_set(
    sprite_player_eyes_idle,
    sprite_player_eyes_walk,
    sprite_player_eyes_run
);


draw_sprite(clothes_sprite, image_index, x, y);
draw_sprite(eyes_sprite, image_index, x, y);
draw_sprite(hair_sprite, image_index, x, y);