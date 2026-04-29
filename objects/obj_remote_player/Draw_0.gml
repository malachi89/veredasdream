// Draw remote player: host sees guest as player2, guest sees host as player1.
var _st = rem_state;
var _skin_s, _clothes_s, _eyes_s, _hair_s;
var _tool_s   = -1;
var _horse_s  = noone;
var _saddle_s = noone;

if (global.net_role == NET_ROLE.HOST) {
    // Remote player is the guest → sprite_player2_*
    if (is_riding) {
        switch (_st) {
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
        switch (_st) {
            case STATE.ACTING:
                if (act_tool == sprite_player_watering_can_watering) {
                    _skin_s    = sprite_player2_skin_watering;
                    _clothes_s = sprite_player2_clothes_watering;
                    _eyes_s    = sprite_player2_eyes_watering;
                    _hair_s    = sprite_player2_hair_watering;
                    _tool_s    = sprite_player2_watering_can_watering;
                } else if (act_tool == sprite_player_hoe_pickaxe_hoe_insects) {
                    _skin_s    = sprite_player2_skin_pickaxe_hoe_insects;
                    _clothes_s = sprite_player2_clothes_pickaxe_hoe_insects;
                    _eyes_s    = sprite_player2_eyes_pickaxe_hoe_insects;
                    _hair_s    = sprite_player2_hair_pickaxe_hoe_insects;
                    _tool_s    = sprite_player2_hoe_pickaxe_hoe_insects;
                } else if (act_tool == sprite_player_pickaxe_pickaxe_hoe_insects) {
                    _skin_s    = sprite_player2_skin_pickaxe_hoe_insects;
                    _clothes_s = sprite_player2_clothes_pickaxe_hoe_insects;
                    _eyes_s    = sprite_player2_eyes_pickaxe_hoe_insects;
                    _hair_s    = sprite_player2_hair_pickaxe_hoe_insects;
                    _tool_s    = sprite_player2_pickaxe_pickaxe_hoe_insects;
                } else if (act_tool == sprite_player_bugnet_pickaxe_hoe_insects) {
                    _skin_s    = sprite_player2_skin_pickaxe_hoe_insects;
                    _clothes_s = sprite_player2_clothes_pickaxe_hoe_insects;
                    _eyes_s    = sprite_player2_eyes_pickaxe_hoe_insects;
                    _hair_s    = sprite_player2_hair_pickaxe_hoe_insects;
                    _tool_s    = sprite_player2_bugnet_pickaxe_hoe_insects;
                } else if (act_tool == sprite_player_axe_axe_sickle) {
                    _skin_s    = sprite_player2_skin_axe_sickle;
                    _clothes_s = sprite_player2_clothes_axe_sickle;
                    _eyes_s    = sprite_player2_eyes_axe_sickle;
                    _hair_s    = sprite_player2_hair_axe_sickle;
                    _tool_s    = sprite_player2_axe_axe_sickle;
                } else if (act_tool == sprite_player_sickle_axe_sickle) {
                    _skin_s    = sprite_player2_skin_axe_sickle;
                    _clothes_s = sprite_player2_clothes_axe_sickle;
                    _eyes_s    = sprite_player2_eyes_axe_sickle;
                    _hair_s    = sprite_player2_hair_axe_sickle;
                    _tool_s    = sprite_player2_sickle_axe_sickle;
                } else if (act_tool == sprite_player_shovel_shovel) {
                    _skin_s    = sprite_player2_skin_shovel;
                    _clothes_s = sprite_player2_clothes_shovel;
                    _eyes_s    = sprite_player2_eyes_shovel;
                    _hair_s    = sprite_player2_hair_shovel;
                    _tool_s    = sprite_player2_shovel_shovel;
                } else if (act_tool == sprite_player_sword_sword) {
                    _skin_s    = sprite_player2_skin_sword;
                    _clothes_s = sprite_player2_clothes_sword;
                    _eyes_s    = sprite_player2_eyes_sword;
                    _hair_s    = sprite_player2_hair_sword_split40;
                    _tool_s    = sprite_player2_sword_sword;
                } else if (act_tool == sprite_player_bow_archer) {
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
                if (act_tool == sprite_player_fishing_cast_weapon) {
                    _skin_s    = sprite_player2_fishing_cast_skins_3;
                    _clothes_s = sprite_player2_fishing_cast_clothes_blue;
                    _eyes_s    = sprite_player2_fishing_cast_eyes_male_brown;
                    _hair_s    = sprite_player2_fishing_cast_hairs_josh_brown;
                    _tool_s    = sprite_player2_fishing_cast_weapon;
                } else if (act_tool == sprite_player_fishing_bite_weapon) {
                    _skin_s    = sprite_player2_fishing_bite_skins_3;
                    _clothes_s = sprite_player2_fishing_bite_clothes_blue;
                    _eyes_s    = sprite_player2_fishing_bite_eyes_male_brown;
                    _hair_s    = sprite_player2_fishing_bite_hairs_josh_brown;
                    _tool_s    = sprite_player2_fishing_bite_weapon;
                } else if (act_tool == sprite_player_fishing_reel_weapon) {
                    _skin_s    = sprite_player2_fishing_reel_skins_3;
                    _clothes_s = sprite_player2_fishing_reel_clothes_blue;
                    _eyes_s    = -1; // no eyes layer for reel animation
                    _hair_s    = sprite_player2_fishing_reel_hairs_josh_brown;
                    _tool_s    = sprite_player2_fishing_reel_weapon;
                } else if (act_tool == sprite_player_fishing_catch_weapon) {
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
} else {
    // Remote player is the host → sprite_player_*
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
                _tool_s    = act_tool;
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
}

var _f = rem_frame;

if (is_riding && _horse_s != noone) {
    draw_sprite_ext(_horse_s, _f, x + 1.2, y + 0.2, 1, 1, 0, c_black, 0.4);
    draw_sprite(_horse_s,   _f, x, y);
} else {
    draw_sprite_ext(_skin_s, _f, x + 1.2, y + 0.2, 1, 1, 0, c_black, 0.4);
}
draw_sprite(_skin_s,    _f, x, y);
if (_eyes_s >= 0)                   draw_sprite(_eyes_s,    _f, x, y);
draw_sprite(_clothes_s, _f, x, y);
draw_sprite(_hair_s,    _f, x, y);
if (is_riding && _saddle_s != noone) draw_sprite(_saddle_s, _f, x, y);
if (!is_riding && _tool_s >= 0)      draw_sprite(_tool_s,   _f, x, y);
