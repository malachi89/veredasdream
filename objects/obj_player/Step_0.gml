// Solo el jugador local procesa input de teclado/raton.
if (!is_local) {
    depth = -bbox_bottom;
    exit;
}

if (dialog_open) {
    if (keyboard_check_pressed(ord("E"))) dialog_open = false;
    state = STATE.IDLE;
    frame_anim = 0;
    image_speed = 0;
    depth = -bbox_bottom;
    exit;
}

if ((instance_exists(obj_controller) && (obj_controller.sleep_menu_open || obj_controller.chat_open || obj_controller.shipping_summary_open))
    || shop_open) {
    state = STATE.IDLE;
    frame_anim = 0;
    image_speed = 0;
    depth = -bbox_bottom;
    exit;
}

var _h   = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var _v   = keyboard_check(ord("S")) - keyboard_check(ord("W"));
var _run = keyboard_check(vk_shift);
var _mag = point_distance(0, 0, _h, _v);
var _prev_state = state;

if (keyboard_check_pressed(ord("F"))) {
    if (is_riding) {
        is_riding = false;
        frames_idle = 4;
        frames_walk = 6;
        frames_run  = 8;
        var _ox = 0;
        var _oy = 0;
        if (dir == DIR.LEFT) _ox = 16;
        if (dir == DIR.LEFT) _oy = -24;
        if (dir == DIR.RIGHT) _ox = 16;
        if (dir == DIR.RIGHT) _oy = -24;
        var _h_dir = dir;
        if (dir == DIR.UP) _h_dir = DIR.DOWN;
        else if (dir == DIR.DOWN) _h_dir = DIR.UP;
        var _horse_inst = instance_create_layer(x + _ox, y + _oy, "Instances", obj_horse1);
        _horse_inst.dir = _h_dir;
        _horse_inst.x_start = x + _ox;
        _horse_inst.y_start = y + _oy;
    } else {
        var _horse = instance_nearest(x, y, obj_horse1);
        if (_horse != noone && point_distance(x, y, _horse.x, _horse.y) < 40) {
            is_riding = true;
            frames_idle = 2;
            frames_walk = 4;
            frames_run  = 6;
            instance_destroy(_horse);
        }
    }
}

if (keyboard_check_pressed(ord("E")) && !show_backpack) {
    var _npc = instance_nearest(x, y, obj_npc);
    if (_npc != noone && point_distance(x, y, _npc.x, _npc.y) < 48) {
        var _shop_entry = global.shop_data[$ _npc.npc_key];
        if (_shop_entry != undefined) {
            shop_open      = true;
            shop_npc_key   = _npc.npc_key;
            shop_scroll    = 0;
            shop_msg       = "";
            shop_msg_timer = 0;
        } else {
            if (dialog_open) {
                dialog_open = false;
            } else {
                dialog_open     = true;
                dialog_npc_name = global.npc_data[$ _npc.npc_key].name;
                dialog_text     = "Hola campeon, echele ganas";
            }
        }
    } else if (dialog_open) {
        dialog_open = false;
    }
}

if (tool_cooldown > 0) tool_cooldown--;

if (mouse_check_button_pressed(mb_left) && state != STATE.ACTING && state != STATE.FISHING && tool_cooldown <= 0) {
    var _selected_item = inventory_array[selected_slot];
    var _item_key = (is_struct(_selected_item)) ? _selected_item.key : _selected_item;
    var _gx = floor(mouse_x / 16) * 16;
    var _gy = floor(mouse_y / 16) * 16;
    var _p_cx = (bbox_left + bbox_right) / 2;
    var _p_cy = (bbox_top + bbox_bottom) / 2;
    var _actual_dist = point_distance(_p_cx, _p_cy, _gx + 8, _gy + 8);

    var _is_placeable = variable_struct_exists(global.placeable_data, _item_key);

    if ((_actual_dist <= 32 || _item_key == "bow" || _item_key == "sickle" || _item_key == "bugnet" || _is_placeable) && !show_backpack) {
        scr_use_item(_selected_item, _gx, _gy);
        tool_cooldown = 50;
    }
}

var _mx = 0;
var _my = 0;

if (state != STATE.ACTING && state != STATE.FISHING) {
    if (_mag == 0) {
        state = STATE.IDLE;
    } else {
        if (is_riding) state = _run ? STATE.WALK : STATE.RUN;
        else state = _run ? STATE.RUN : STATE.WALK;
        if (abs(_h) > abs(_v)) dir = (_h > 0) ? DIR.RIGHT : DIR.LEFT;
        else dir = (_v > 0) ? DIR.DOWN : DIR.UP;
    }

    var _spd = move_speed;
    if (is_riding) _spd = (state == STATE.RUN) ? move_speed_run * 1.8 : move_speed_run * 1.2;
    else _spd = (state == STATE.RUN) ? move_speed_run : move_speed;
    _mx = (_mag != 0) ? (_h / _mag) * _spd : 0;
    _my = (_mag != 0) ? (_v / _mag) * _spd : 0;
}

move_and_collide(_mx, _my, [obj_collision, obj_chest], 4, 0, 0, -1, -1);

if (state != _prev_state) frame_anim = 0;

if (state == STATE.ACTING) {
    frame_anim += 0.2;

    if (!bugnet_caught && floor(frame_anim) >= 5) {
        var _held     = inventory_array[selected_slot];
        var _held_key = is_struct(_held) ? _held.key : _held;
        if (_held_key == "bugnet") {
            bugnet_caught = true;
            var _nearest = instance_nearest(mouse_x, mouse_y, obj_insect);
            if (_nearest != noone && point_distance(mouse_x, mouse_y, _nearest.x, _nearest.y) <= 40) {
                var _ikey  = _nearest.insect_key;
                var _idata = global.insect_data[$ _ikey];
                add_item(_ikey, 1);
                scr_notify("¡Atrapaste un " + _idata.name + "!");
                instance_destroy(_nearest);
            } else {
                scr_notify("¡Fallaste!");
            }
        }
    }

    if (frame_anim >= frames_action) {
        state = STATE.IDLE;
        frame_anim = 0;
    }

    var _quality_offset = action_quality * (4 * frames_action);
    image_index = _quality_offset + (dir * frames_action) + floor(frame_anim);
} else if (state == STATE.FISHING) {
    if (mouse_check_button_pressed(mb_right)) {
        state = STATE.IDLE;
        frame_anim = 0;
    } else {
        var _anim_speed = (fishing_substate == FISHING_STATE.WAITING) ? 0.05 : 0.2;
        frame_anim += _anim_speed;

        switch (fishing_substate) {
            case FISHING_STATE.CASTING:
                if (frame_anim >= 15) {
                    fishing_substate = FISHING_STATE.WAITING;
                    frame_anim = 0;
                    fishing_wait_timer = irandom_range(180, 480);
                    action_sprite_tool = sprite_player_fishing_wait_weapon;
                    scr_set_player_action_sprites(
                        sprite_player_fishing_wait_skins_2,
                        sprite_player_fishing_wait_hairs_fawn_black,
                        sprite_player_fishing_wait_clothes_purple,
                        sprite_player_fishing_wait_eyes_female_brown
                    );
                }
            break;

            case FISHING_STATE.WAITING:
                if (frame_anim >= 4) frame_anim = 0;
                fishing_wait_timer--;
                if (fishing_wait_timer <= 0) {
                    fishing_substate = FISHING_STATE.BITE;
                    frame_anim = 0;
                    fishing_bite_timer = 120;
                    action_sprite_tool = sprite_player_fishing_bite_weapon;
                    scr_set_player_action_sprites(
                        sprite_player_fishing_bite_skins_2,
                        sprite_player_fishing_bite_hairs_fawn_black,
                        sprite_player_fishing_bite_clothes_purple,
                        sprite_player_fishing_bite_eyes_female_brown
                    );
                    scr_notify("¡Mordió! ¡Haz clic para pescar!");
                }
            break;

            case FISHING_STATE.BITE:
                if (frame_anim >= 8) frame_anim = 7;
                fishing_bite_timer--;
                if (mouse_check_button_pressed(mb_left) || keyboard_check_pressed(vk_space)) {
                    fishing_substate = FISHING_STATE.REELING;
                    frame_anim = 0;
                    action_sprite_tool = sprite_player_fishing_reel_weapon;
                    scr_set_player_action_sprites(
                        sprite_player_fishing_reel_skins_2,
                        sprite_player_fishing_reel_hairs_fawn_black,
                        sprite_player_fishing_reel_clothes_purple,
                        -1
                    );
                } else if (fishing_bite_timer <= 0) {
                    fishing_substate = FISHING_STATE.WAITING;
                    frame_anim = 0;
                    fishing_wait_timer = irandom_range(180, 480);
                    action_sprite_tool = sprite_player_fishing_wait_weapon;
                    scr_set_player_action_sprites(
                        sprite_player_fishing_wait_skins_2,
                        sprite_player_fishing_wait_hairs_fawn_black,
                        sprite_player_fishing_wait_clothes_purple,
                        sprite_player_fishing_wait_eyes_female_brown
                    );
                }
            break;

            case FISHING_STATE.REELING:
                if (frame_anim >= 4) {
                    fishing_substate = FISHING_STATE.CATCHING;
                    frame_anim = 0;
                    action_sprite_tool = sprite_player_fishing_catch_weapon;
                    scr_set_player_action_sprites(
                        sprite_player_fishing_catch_skins_2,
                        sprite_player_fishing_catch_hairs_fawn_black,
                        sprite_player_fishing_catch_clothes_purple,
                        sprite_player_fishing_catch_eyes_female_brown
                    );
                }
            break;

            case FISHING_STATE.CATCHING:
                if (frame_anim >= 4) {
                    var _fish_key = global.fish_pool[irandom(array_length(global.fish_pool) - 1)];
                    var _fish_data = global.fish_data[$ _fish_key];
                    add_item(_fish_key, 1);
                    energy -= 10;
                    scr_notify("¡Atrapaste un " + _fish_data.name + "!");
                    state = STATE.IDLE;
                    frame_anim = 0;
                }
            break;
        }

        var _fpd = 15;
        switch (fishing_substate) {
            case FISHING_STATE.WAITING:  _fpd = 4; break;
            case FISHING_STATE.BITE:     _fpd = 8; break;
            case FISHING_STATE.REELING:  _fpd = 4; break;
            case FISHING_STATE.CATCHING: _fpd = 4; break;
        }
        image_index = (dir * _fpd) + floor(frame_anim);
    }
} else {
    var _s_idle = is_riding ? sprite_player_horse1_body_idle : sprite_player_idle;
    var _s_walk = is_riding ? sprite_player_horse1_body_walk : sprite_player_walk;
    var _s_run = is_riding ? sprite_player_horse1_body_run : sprite_player_run;
    var _anim_data = [
        [_s_idle, 0.1, frames_idle],
        [_s_walk, 0.15, frames_walk],
        [_s_run, 0.25, frames_run]
    ];
    var _current = _anim_data[state];
    sprite_index = _current[0];

    var _prev_frame = floor(frame_anim);
    frame_anim += _current[1];
    if (frame_anim >= _current[2]) frame_anim = 0;
    var _curr_frame = floor(frame_anim);

    if (_curr_frame != _prev_frame) {
        if (state == STATE.WALK || state == STATE.RUN) {
            var _f1 = 1;
            var _f2 = (state == STATE.WALK) ? 4 : 5;
            if (_curr_frame == _f1 || _curr_frame == _f2) {
                audio_play_sound(choose(walk1, walk2, walk3), 1, false);
            }
        }
    }

    var _dir_idx = dir;
    if (is_riding) {
        if (state == STATE.IDLE) _dir_idx = dir;
        else {
            if (dir == DIR.DOWN) _dir_idx = 0;
            else if (dir == DIR.UP) _dir_idx = 1;
        }
    }
    image_index = (_dir_idx * _current[2]) + floor(frame_anim);
}

// PLAYER_STATE broadcast at 15 Hz for multiplayer position sync
if (global.net_role != NET_ROLE.NONE && instance_exists(obj_net) && obj_net.is_connected) {
    net_state_timer += 1;
    if (net_state_timer >= 4) {
        net_state_timer = 0;
        net_send_player_state();
    }
}

image_speed = 0;
depth = -bbox_bottom;
