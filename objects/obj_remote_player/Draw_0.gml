// Draw remote player using the same layered sprites as obj_player.
// rem_state and rem_frame come from PLAYER_STATE packets.
var _st = rem_state;
var _skin_s, _clothes_s, _eyes_s, _hair_s;
var _horse_s  = noone;
var _saddle_s = noone;

if (is_riding) {
    switch (_st) {
        case STATE.WALK:
            _skin_s    = sprite_player_horse1_body_walk;
            _clothes_s = sprite_player_horse1_clothes_walk;
            _eyes_s    = sprite_player_horse1_eyes_walk;
            _hair_s    = sprite_player_horse1_hair_walk;
            _horse_s   = sprite_player_horse1_horse_walk;
            _saddle_s  = sprite_player_horse1_saddle_walk;
            break;
        case STATE.RUN:
            _skin_s    = sprite_player_horse1_body_run;
            _clothes_s = sprite_player_horse1_clothes_run;
            _eyes_s    = sprite_player_horse1_eyes_run;
            _hair_s    = sprite_player_horse1_hair_run;
            _horse_s   = sprite_player_horse1_horse_run;
            _saddle_s  = sprite_player_horse1_saddle_run;
            break;
        default:
            _skin_s    = sprite_player_horse1_body_idle;
            _clothes_s = sprite_player_horse1_clothes_idle;
            _eyes_s    = sprite_player_horse1_eyes_idle;
            _hair_s    = sprite_player_horse1_hair_idle;
            _horse_s   = sprite_player_horse1_horse_idle;
            _saddle_s  = sprite_player_horse1_saddle_idle;
            break;
    }
} else {
    switch (_st) {
        case STATE.ACTING:
        case STATE.FISHING:
            _skin_s    = (act_skin    >= 0) ? act_skin    : sprite_player_idle;
            _clothes_s = (act_clothes >= 0) ? act_clothes : sprite_player_clothes_idle;
            _eyes_s    = (act_eyes    >= 0) ? act_eyes    : sprite_player_eyes_idle;
            _hair_s    = (act_hair    >= 0) ? act_hair    : sprite_player_hair_idle;
            break;
        case STATE.WALK:
            _skin_s    = sprite_player_walk;
            _clothes_s = sprite_player_clothes_walk;
            _eyes_s    = sprite_player_eyes_walk;
            _hair_s    = sprite_player_hair_walk;
            break;
        case STATE.RUN:
            _skin_s    = sprite_player_run;
            _clothes_s = sprite_player_clothes_run;
            _eyes_s    = sprite_player_eyes_run;
            _hair_s    = sprite_player_hair_run;
            break;
        default:
            _skin_s    = sprite_player_idle;
            _clothes_s = sprite_player_clothes_idle;
            _eyes_s    = sprite_player_eyes_idle;
            _hair_s    = sprite_player_hair_idle;
            break;
    }
}

var _f = rem_frame;

if (is_riding && _horse_s != noone)  draw_sprite(_horse_s,   _f, x, y);
draw_sprite(_skin_s,    _f, x, y);
draw_sprite(_eyes_s,    _f, x, y);
draw_sprite(_clothes_s, _f, x, y);
draw_sprite(_hair_s,    _f, x, y);
if (is_riding && _saddle_s != noone) draw_sprite(_saddle_s,  _f, x, y);
if ((_st == STATE.ACTING || _st == STATE.FISHING) && !is_riding && act_tool >= 0) {
    draw_sprite(act_tool, _f, x, y);
}
