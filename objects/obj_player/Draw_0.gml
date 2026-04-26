// Función para obtener el sprite correcto según el estado
function get_sprite_set(_idle, _walk, _run, _action)
{
    switch (state)
    {
        case STATE.IDLE:    return _idle;
        case STATE.WALK:    return _walk;
        case STATE.RUN:     return _run;
        case STATE.ACTING:  return _action;
        case STATE.FISHING: return (_action != -1) ? _action : _idle;
        default:            return _idle;
    }
}

var _skin_s, _clothes_s, _eyes_s, _hair_s;
var _horse_s  = noone;
var _saddle_s = noone;

if (global.net_role == NET_ROLE.CLIENT) {
    // Guest player: draw with sprite_player2_* sprites
    var _tool_s = -1;

    if (is_riding) {
        switch (state) {
            case STATE.WALK:
                _skin_s    = sprite_player2_horse1_body_walk;
                _clothes_s = sprite_player2_horse1_clothes_walk;
                _eyes_s    = sprite_player2_horse1_eyes_walk;
                _hair_s    = sprite_player2_horse1_hair_walk;
                _horse_s   = sprite_player2_horse1_horse_walk;
                _saddle_s  = sprite_player2_horse1_saddle_walk;
                break;
            case STATE.RUN:
                _skin_s    = sprite_player2_horse1_body_run;
                _clothes_s = sprite_player2_horse1_clothes_run;
                _eyes_s    = sprite_player2_horse1_eyes_run;
                _hair_s    = sprite_player2_horse1_hair_run;
                _horse_s   = sprite_player2_horse1_horse_run;
                _saddle_s  = sprite_player2_horse1_saddle_run;
                break;
            default:
                _skin_s    = sprite_player2_horse1_body_idle;
                _clothes_s = sprite_player2_horse1_clothes_idle;
                _eyes_s    = sprite_player2_horse1_eyes_idle;
                _hair_s    = sprite_player2_horse1_hair_idle;
                _horse_s   = sprite_player2_horse1_horse_idle;
                _saddle_s  = sprite_player2_horse1_saddle_idle;
                break;
        }
    } else {
        switch (state) {
            case STATE.ACTING:
                if (action_sprite_tool == sprite_player_watering_can_watering) {
                    _skin_s    = sprite_player2_skin_watering;
                    _clothes_s = sprite_player2_clothes_watering;
                    _eyes_s    = sprite_player2_eyes_watering;
                    _hair_s    = sprite_player2_hair_watering;
                    _tool_s    = sprite_player2_watering_can_watering;
                } else if (action_sprite_tool == sprite_player_hoe_pickaxe_hoe_insects) {
                    _skin_s    = sprite_player2_skin_pickaxe_hoe_insects;
                    _clothes_s = sprite_player2_clothes_pickaxe_hoe_insects;
                    _eyes_s    = sprite_player2_eyes_pickaxe_hoe_insects;
                    _hair_s    = sprite_player2_hair_pickaxe_hoe_insects;
                    _tool_s    = sprite_player2_hoe_pickaxe_hoe_insects;
                } else if (action_sprite_tool == sprite_player_pickaxe_pickaxe_hoe_insects) {
                    _skin_s    = sprite_player2_skin_pickaxe_hoe_insects;
                    _clothes_s = sprite_player2_clothes_pickaxe_hoe_insects;
                    _eyes_s    = sprite_player2_eyes_pickaxe_hoe_insects;
                    _hair_s    = sprite_player2_hair_pickaxe_hoe_insects;
                    _tool_s    = sprite_player2_pickaxe_pickaxe_hoe_insects;
                } else if (action_sprite_tool == sprite_player_bugnet_pickaxe_hoe_insects) {
                    _skin_s    = sprite_player2_skin_pickaxe_hoe_insects;
                    _clothes_s = sprite_player2_clothes_pickaxe_hoe_insects;
                    _eyes_s    = sprite_player2_eyes_pickaxe_hoe_insects;
                    _hair_s    = sprite_player2_hair_pickaxe_hoe_insects;
                    _tool_s    = sprite_player2_bugnet_pickaxe_hoe_insects;
                } else if (action_sprite_tool == sprite_player_axe_axe_sickle) {
                    _skin_s    = sprite_player2_skin_axe_sickle;
                    _clothes_s = sprite_player2_clothes_axe_sickle;
                    _eyes_s    = sprite_player2_eyes_axe_sickle;
                    _hair_s    = sprite_player2_hair_axe_sickle;
                    _tool_s    = sprite_player2_axe_axe_sickle;
                } else if (action_sprite_tool == sprite_player_sickle_axe_sickle) {
                    _skin_s    = sprite_player2_skin_axe_sickle;
                    _clothes_s = sprite_player2_clothes_axe_sickle;
                    _eyes_s    = sprite_player2_eyes_axe_sickle;
                    _hair_s    = sprite_player2_hair_axe_sickle;
                    _tool_s    = sprite_player2_sickle_axe_sickle;
                } else if (action_sprite_tool == sprite_player_shovel_shovel) {
                    _skin_s    = sprite_player2_skin_shovel;
                    _clothes_s = sprite_player2_clothes_shovel;
                    _eyes_s    = sprite_player2_eyes_shovel;
                    _hair_s    = sprite_player2_hair_shovel;
                    _tool_s    = sprite_player2_shovel_shovel;
                } else if (action_sprite_tool == sprite_player_sword_sword) {
                    _skin_s    = sprite_player2_skin_sword;
                    _clothes_s = sprite_player2_clothes_sword;
                    _eyes_s    = sprite_player2_eyes_sword;
                    _hair_s    = sprite_player2_hair_sword_split40;
                    _tool_s    = sprite_player2_sword_sword;
                } else if (action_sprite_tool == sprite_player_bow_archer) {
                    _skin_s    = sprite_player2_skin_archer;
                    _clothes_s = sprite_player2_clothes_archer;
                    _eyes_s    = sprite_player2_eyes_archer;
                    _hair_s    = sprite_player2_hair_archer;
                    _tool_s    = sprite_player2_bow_archer;
                } else {
                    _skin_s    = sprite_player2_idle;
                    _clothes_s = sprite_player2_clothes_idle;
                    _eyes_s    = sprite_player2_eyes_idle;
                    _hair_s    = sprite_player2_hair_idle;
                }
                break;
            case STATE.FISHING:
                if (action_sprite_tool == sprite_player_fishing_cast_weapon) {
                    _skin_s    = sprite_player2_fishing_cast_skins_3;
                    _clothes_s = sprite_player2_fishing_cast_clothes_blue;
                    _eyes_s    = sprite_player2_fishing_cast_eyes_male_brown;
                    _hair_s    = sprite_player2_fishing_cast_hairs_josh_brown;
                    _tool_s    = sprite_player2_fishing_cast_weapon;
                } else if (action_sprite_tool == sprite_player_fishing_bite_weapon) {
                    _skin_s    = sprite_player2_fishing_bite_skins_3;
                    _clothes_s = sprite_player2_fishing_bite_clothes_blue;
                    _eyes_s    = sprite_player2_fishing_bite_eyes_male_brown;
                    _hair_s    = sprite_player2_fishing_bite_hairs_josh_brown;
                    _tool_s    = sprite_player2_fishing_bite_weapon;
                } else if (action_sprite_tool == sprite_player_fishing_reel_weapon) {
                    _skin_s    = sprite_player2_fishing_reel_skins_3;
                    _clothes_s = sprite_player2_fishing_reel_clothes_blue;
                    _eyes_s    = -1; // no eyes layer for reel animation
                    _hair_s    = sprite_player2_fishing_reel_hairs_josh_brown;
                    _tool_s    = sprite_player2_fishing_reel_weapon;
                } else if (action_sprite_tool == sprite_player_fishing_catch_weapon) {
                    _skin_s    = sprite_player2_fishing_catch_skins_3;
                    _clothes_s = sprite_player2_fishing_catch_clothes_blue;
                    _eyes_s    = sprite_player2_fishing_catch_eyes_male_brown;
                    _hair_s    = sprite_player2_fishing_catch_hairs_josh_brown;
                    _tool_s    = sprite_player2_fishing_catch_weapon;
                } else {
                    _skin_s    = sprite_player2_fishing_wait_skins_3;
                    _clothes_s = sprite_player2_fishing_wait_clothes_blue;
                    _eyes_s    = sprite_player2_fishing_wait_eyes_male_brown;
                    _hair_s    = sprite_player2_fishing_wait_hairs_josh_brown;
                    _tool_s    = sprite_player2_fishing_wait_weapon;
                }
                break;
            case STATE.WALK:
                _skin_s    = sprite_player2_walk;
                _clothes_s = sprite_player2_clothes_walk;
                _eyes_s    = sprite_player2_eyes_walk;
                _hair_s    = sprite_player2_hair_walk;
                break;
            case STATE.RUN:
                _skin_s    = sprite_player2_run;
                _clothes_s = sprite_player2_clothes_run;
                _eyes_s    = sprite_player2_eyes_run;
                _hair_s    = sprite_player2_hair_run;
                break;
            default:
                _skin_s    = sprite_player2_idle;
                _clothes_s = sprite_player2_clothes_idle;
                _eyes_s    = sprite_player2_eyes_idle;
                _hair_s    = sprite_player2_hair_idle;
                break;
        }
    }

    if (is_riding && _horse_s != noone) draw_sprite(_horse_s,   image_index, x, y);
    draw_sprite(_skin_s,    image_index, x, y);
    if (_eyes_s >= 0)                   draw_sprite(_eyes_s,    image_index, x, y);
    draw_sprite(_clothes_s, image_index, x, y);
    draw_sprite(_hair_s,    image_index, x, y);
    if (is_riding && _saddle_s != noone) draw_sprite(_saddle_s, image_index, x, y);
    if (!is_riding && _tool_s >= 0)      draw_sprite(_tool_s,   image_index, x, y);

} else {
    // Host player: draw with original sprite_player_* sprites
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

    if (is_riding && _horse_s != noone) draw_sprite(_horse_s,   image_index, x, y);
    draw_sprite(_skin_s,    image_index, x, y);
    draw_sprite(_eyes_s,    image_index, x, y);
    draw_sprite(_clothes_s, image_index, x, y);
    draw_sprite(_hair_s,    image_index, x, y);
    if (is_riding && _saddle_s != noone) draw_sprite(_saddle_s, image_index, x, y);
    if ((state == STATE.ACTING || state == STATE.FISHING) && !is_riding) {
        draw_sprite(action_sprite_tool, image_index, x, y);
    }
}
