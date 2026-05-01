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

if ((instance_exists(obj_controller) && (obj_controller.sleep_menu_open || obj_controller.chat_open || obj_controller.shipping_summary_open || obj_controller.pause_menu_open || obj_controller.mine_prompt_open))
    || shop_open) {
    state = STATE.IDLE;
    frame_anim = 0;
    image_speed = 0;
    depth = -bbox_bottom;
    exit;
}

if (keyboard_check_pressed(vk_tab) && !shop_open && !dialog_open) {
    scr_inventory_cycle_hotbars(id);
    audio_play_sound(axe, 1, false);
}

var _h   = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var _v   = keyboard_check(ord("S")) - keyboard_check(ord("W"));
var _run = keyboard_check(vk_shift);
var _mag = point_distance(0, 0, _h, _v);
var _prev_state = state;

if (keyboard_check_pressed(ord("F"))) {
    if (is_riding) {
        var _was_bear = mount_is_bear;
        is_riding = false;
        mount_is_bear = false;
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
        var _mount_inst = instance_create_layer(x + _ox, y + _oy, "Instances", obj_horse1);
        _mount_inst.dir = _h_dir;
        _mount_inst.x_start = x + _ox;
        _mount_inst.y_start = y + _oy;
        _mount_inst.is_bear = _was_bear;
    } else {
        var _mount = instance_nearest(x, y, obj_horse_parent);
        if (_mount != noone && point_distance(x, y, _mount.x, _mount.y) < 40) {
            mount_is_bear = _mount.is_bear;
            is_riding = true;
            frames_idle = 2;
            frames_walk = 4;
            frames_run  = 6;
            instance_destroy(_mount);
        }
    }
}

if (keyboard_check_pressed(ord("E")) && !show_backpack) {
    var _sign = instance_nearest(x, y, obj_forest_sign);
    if (_sign != noone && point_distance(x, y, _sign.x, _sign.y) < 60) {
        if (dialog_open) {
            dialog_open = false;
        } else {
            var _animals = [];
            for (var _i = 0; _i < array_length(global.forest_wild_animals); _i++) {
                var _ak = global.forest_wild_animals[_i].key;
                var _adata = global.wild_animal_data[$ _ak];
                if (_adata == undefined) continue;
                var _an = _adata.name;
                var _dup = false;
                for (var _j = 0; _j < array_length(_animals); _j++) {
                    if (_animals[_j] == _an) { _dup = true; break; }
                }
                if (!_dup) array_push(_animals, _an);
            }

            var _forage = [];
            var _fcount = instance_number(obj_item_parent);
            for (var _i = 0; _i < _fcount; _i++) {
                var _fi = instance_find(obj_item_parent, _i);
                if (!string_starts_with(_fi.item_key, "forage_")) continue;
                var _fname = global.forage_data[$ _fi.item_key].name;
                var _dup = false;
                for (var _j = 0; _j < array_length(_forage); _j++) {
                    if (_forage[_j] == _fname) { _dup = true; break; }
                }
                if (!_dup) array_push(_forage, _fname);
            }

            var _max = 6;
            var _astr = "";
            for (var _i = 0; _i < min(array_length(_animals), _max); _i++) {
                if (_i > 0) _astr += ", ";
                _astr += _animals[_i];
            }
            if (array_length(_animals) > _max) _astr += "...";
            if (_astr == "") _astr = "ninguno";

            var _fstr = "";
            for (var _i = 0; _i < min(array_length(_forage), _max); _i++) {
                if (_i > 0) _fstr += ", ";
                _fstr += _forage[_i];
            }
            if (array_length(_forage) > _max) _fstr += "...";
            if (_fstr == "") _fstr = "ninguna";

            dialog_npc_name = "Tablón del Bosque";
            dialog_text = "Animales: " + _astr + "\nPlantas y setas: " + _fstr;
            dialog_open = true;
        }
        } else {
            var _did_interact = false;

            // Machine interaction
            if (!_did_interact) {
                var _machine = instance_nearest(x, y, obj_machine);
                if (_machine != noone && point_distance(x, y, _machine.x, _machine.y) < 48) {
                    if (_machine.state == 2) {
                        var _mw = (variable_struct_exists(_machine, "output_weight") && _machine.output_weight > 0) ? _machine.output_weight : undefined;
                        if (add_item(_machine.output_key, _machine.output_qty, _mw)) {
                            _machine.state = 0;
                            _machine.image_index = 0;
                            _machine.input_key = "";
                            var _out_name = "";
                            var _od = scr_get_item_data(_machine.output_key);
                            if (_od != undefined) _out_name = _od.name;
                            _machine.output_key = "";
                            _machine.output_qty = 0;
                            if (_machine.passive) _machine.passive_timer = 300;
                            if (_out_name != "") scr_notify(_out_name + " recogido");
                            else scr_notify("Producto recogido");
                        } else {
                            scr_notify("Inventario lleno");
                        }
                        _did_interact = true;
                    } else if (_machine.state == 0 && !_machine.passive) {
                        var _selected = inventory_array[selected_slot];
                        var _sk = is_struct(_selected) ? _selected.key : "";
                        if (_sk != "" && _sk != -1) {
                            var _md = global.machine_data[$ _machine.machine_type];
                            var _recipe = scr_match_machine_recipe(_machine.machine_type, _sk);
                            if (is_struct(_recipe)) {
                                if (is_struct(_selected)) {
                                    _selected.quantity -= 1;
                                    if (_selected.quantity <= 0) inventory_array[selected_slot] = -1;
                                }
                                _machine.input_key = _sk;
                                _machine.output_key = _recipe.output;
                                _machine.output_qty = _recipe.qty;
                                _machine.state = 1;
                                _machine.timer = _md.process_time;
                                _machine.image_speed = 0;
                                _machine.image_index = 1;
                                scr_notify("Procesando...");
                                _did_interact = true;
                            }
                        }
                    }
                }
            }

            // Cave door interaction (E key only for locked doors now; open doors auto-enter on collision)
            var _locked_door = instance_nearest(x, y, obj_cave_door_closed);
            if (_locked_door != noone && point_distance(x, y, _locked_door.x, _locked_door.y) < 40) {
                var _unlocked = (_locked_door.door_index >= 0 && global.mine_unlocks[_locked_door.door_index]);
                if (!_unlocked) {
                    _did_interact = true;
                    dialog_npc_name = "Puerta Bloqueada";
                    dialog_text = "Completa los 10 pisos de la mina anterior para desbloquear esta.";
                    dialog_open = true;
                }
            }

            // Mine ladder down (inside mine)
            if (!_did_interact && global.mine_state.active && global.mine_state.floor < 10) {
                var _ld = instance_nearest(x, y, obj_ladder_down);
                if (_ld != noone && point_distance(x, y, _ld.x, _ld.y) < 40) {
                    _did_interact = true;
                    if (instance_exists(obj_controller)) {
                        obj_controller.mine_prompt_open = true;
                        obj_controller.mine_prompt_type = "down";
                        obj_controller.mine_prompt_selection = 0;
                    }
                }
            }

            // Mine exit ladder (inside mine)
            if (!_did_interact && global.mine_state.active) {
                var _lex = instance_nearest(x, y, obj_ladder_exit);
                if (_lex != noone && point_distance(x, y, _lex.x, _lex.y) < 40) {
                    _did_interact = true;
                    if (instance_exists(obj_controller)) {
                        obj_controller.mine_prompt_open = true;
                        obj_controller.mine_prompt_type = "exit";
                        obj_controller.mine_prompt_selection = 0;
                    }
                }
            }

            // NPC interaction
            if (!_did_interact) {
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
        }
    }

if (tool_cooldown > 0) tool_cooldown--;

if (arrow_shoot_snd_timer > 0) {
    arrow_shoot_snd_timer--;
    if (arrow_shoot_snd_timer == 0 && arrow_shoot_snd_id != -1) {
        audio_stop_sound(arrow_shoot_snd_id);
        arrow_shoot_snd_id = -1;
    }
}

if (tool_locked_frames > 0) tool_locked_frames--;

var _mouse_over_ui = instance_exists(obj_inventory)
    && device_mouse_y_to_gui(0) >= obj_inventory.menu_y_start;

if (mouse_check_button_pressed(mb_left) && !_mouse_over_ui && state != STATE.ACTING && state != STATE.FISHING && tool_cooldown <= 0 && tool_locked_frames <= 0) {
    var _selected_item = inventory_array[selected_slot];
    var _item_key = (is_struct(_selected_item)) ? _selected_item.key : _selected_item;
    var _gx = floor(mouse_x / 16) * 16;
    var _gy = floor(mouse_y / 16) * 16;
    var _p_cx = (bbox_left + bbox_right) / 2;
    var _p_cy = (bbox_top + bbox_bottom) / 2;
    var _actual_dist = point_distance(_p_cx, _p_cy, _gx + 8, _gy + 8);

    var _is_placeable = variable_struct_exists(global.placeable_data, _item_key);

    if ((_actual_dist <= 32 || _item_key == "bow" || _item_key == "sickle" || _item_key == "bugnet" || _is_placeable) && !show_backpack) {
        if (_item_key == "bow") {
            // Stop any previous bow sound before starting a new draw
            if (bow_sound_id != -1 && audio_is_playing(bow_sound_id)) {
                audio_stop_sound(bow_sound_id);
            }
            // Play sound immediately on click, skipping 0.30s of silence
            bow_sound_id = audio_play_sound(sound_bow, 1, false);
            audio_sound_set_track_position(bow_sound_id, 0.30);
            // Start bow draw — animation only; arrow fires on LMB release
            scr_use_item(_selected_item, _gx, _gy, true);
            bow_drawing = true;
            bow_quality = (is_struct(_selected_item) && variable_struct_exists(_selected_item, "quality"))
                          ? _selected_item.quality : 0;
        } else if (global.net_role == NET_ROLE.CLIENT) {
            // Animate locally; host runs the authoritative mutation
            var _quality  = (is_struct(_selected_item) && variable_struct_exists(_selected_item, "quality"))
                            ? _selected_item.quality : 0;
            var _quantity = is_struct(_selected_item) ? _selected_item.quantity : 1;
            scr_use_item(_selected_item, _gx, _gy, true);
            net_send_use_item(_item_key, _quality, _quantity, selected_slot, _gx, _gy, dir);
        } else {
            scr_use_item(_selected_item, _gx, _gy);
            if (global.net_role == NET_ROLE.HOST && instance_exists(obj_net) && obj_net.is_connected) {
                scr_capture_current_room_state();
                net_broadcast_room_state(scr_current_room_key());
            }
        }
        tool_cooldown = 50;
    }
}

// Bow fire: runs every step — not gated on STATE.ACTING so it always catches the release
if (bow_drawing && !mouse_check_button(mb_left)) {
    bow_drawing = false;
    arrow_shoot_snd_id = audio_play_sound(sound_arrow_shoot, 1, false);
    audio_sound_set_track_position(arrow_shoot_snd_id, 1.85);
    arrow_shoot_snd_timer = 9; // stop at 2.00s (0.15s × 60fps)
    if (global.net_role != NET_ROLE.CLIENT) {
        energy -= 5;
        var _arr = instance_create_layer(x + 16, y + 16, "Instances", obj_arrow);
        _arr.damage = bow_quality + 1;
        if (global.net_role == NET_ROLE.HOST && instance_exists(obj_net) && obj_net.is_connected) {
            scr_capture_current_room_state();
            net_broadcast_room_state(scr_current_room_key());
        }
    } else {
        var _bow_item = inventory_array[selected_slot];
        var _qty = is_struct(_bow_item) ? _bow_item.quantity : 1;
        net_send_use_item("bow", bow_quality, _qty, selected_slot,
                          floor(mouse_x / 16) * 16, floor(mouse_y / 16) * 16, dir);
    }
}

var _mx = 0;
var _my = 0;

if (state != STATE.ACTING && state != STATE.FISHING) {
    if (_mag == 0) {
        state = STATE.IDLE;
    } else {
        if (is_riding) state = _run ? STATE.RUN : STATE.WALK;
        else state = _run ? STATE.WALK : STATE.RUN;
        if (abs(_h) > abs(_v)) dir = (_h > 0) ? DIR.RIGHT : DIR.LEFT;
        else dir = (_v > 0) ? DIR.DOWN : DIR.UP;
    }

    var _spd = move_speed;
    if (is_riding) _spd = (state == STATE.RUN) ? move_speed_run * 1.8 : move_speed_run * 1.2;
    else _spd = (state == STATE.RUN) ? move_speed_run : move_speed;
    _mx = (_mag != 0) ? (_h / _mag) * _spd : 0;
    _my = (_mag != 0) ? (_v / _mag) * _spd : 0;
}

move_and_collide(_mx, _my, [obj_collision, obj_chest, obj_forest_sign, obj_ladder_down, obj_ladder_exit], 4, 0, 0, -1, -1);

// Auto-enter open mine door when walking through it
if (!global.mine_state.active) {
    var _near_door = false;
    var _door_inst = instance_nearest(x, y, obj_cave_door_open);
    if (_door_inst != noone && point_distance(x, y, _door_inst.x, _door_inst.y) < 20) {
        _near_door = true;
        if (!prev_on_door) {
            scr_enter_cave_mine(_door_inst.door_index);
        }
    }
    if (!_near_door) {
        _door_inst = instance_nearest(x, y, obj_cave_door_closed);
        if (_door_inst != noone && _door_inst.door_index >= 0 && global.mine_unlocks[_door_inst.door_index]
                && point_distance(x, y, _door_inst.x, _door_inst.y) < 20) {
            _near_door = true;
            if (!prev_on_door) {
                scr_enter_cave_mine(_door_inst.door_index);
            }
        }
    }
    prev_on_door = _near_door;
}

if (state != _prev_state) frame_anim = 0;

if (state == STATE.ACTING) {
    if (bow_drawing) {
        // Hold: advance to pulled pose (frame 4) and track mouse direction
        frame_anim = min(frame_anim + 0.2, 3);
        var _dx = mouse_x - ((bbox_left + bbox_right) / 2);
        var _dy = mouse_y - ((bbox_top + bbox_bottom) / 2);
        if (abs(_dx) > abs(_dy)) {
            dir = (_dx > 0) ? DIR.RIGHT : DIR.LEFT;
        } else {
            dir = (_dy > 0) ? DIR.DOWN : DIR.UP;
        }
    } else {
        frame_anim += 0.2;
    }

    if (!bugnet_caught && floor(frame_anim) >= 5) {
        var _held     = inventory_array[selected_slot];
        var _held_key = is_struct(_held) ? _held.key : _held;
        if (_held_key == "bugnet") {
            bugnet_caught = true;
            // CLIENT: host resolved the catch via net_handle_use_item; just play animation.
            if (global.net_role != NET_ROLE.CLIENT) {
                var _nearest = instance_nearest(mouse_x, mouse_y, obj_insect);
                if (_nearest != noone && point_distance(mouse_x, mouse_y, _nearest.x, _nearest.y) <= 40) {
                    var _ikey  = _nearest.insect_key;
                    var _idata = global.insect_data[$ _ikey];
                    add_item(_ikey, 1);
                    scr_notify("¡Atrapaste un " + _idata.name + "!");
                    instance_destroy(_nearest);
                    if (global.net_role == NET_ROLE.HOST && instance_exists(obj_net) && obj_net.is_connected) {
                        scr_capture_current_room_state();
                        net_broadcast_room_state(scr_current_room_key());
                    }
                } else {
                    scr_notify("¡Fallaste!");
                }
            }
        }
    }

    if (frame_anim >= frames_action) {
        bow_sound_id = -1; // clear reference; sound plays to natural end
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
                    if (global.net_role == NET_ROLE.CLIENT) {
                        // Host resolves which fish is caught; result comes back as INVENTORY_UPDATE.
                        net_send_fish_reel();
                    } else {
                        var _fish_key  = global.fish_pool[irandom(array_length(global.fish_pool) - 1)];
                        var _fish_data = global.fish_data[$ _fish_key];
                        var _fw = undefined;
                        if (variable_struct_exists(_fish_data, "weight_min")) {
                            _fw = round(random_range(_fish_data.weight_min, _fish_data.weight_max) * 100) / 100;
                        }
                        add_item(_fish_key, 1, _fw);
                        energy -= 10;
                        var _fw_str = (_fw != undefined) ? " (" + scr_format_weight(_fw) + ")" : "";
                        scr_notify("¡Atrapaste un " + _fish_data.name + _fw_str + "!");
                    }
                    state      = STATE.IDLE;
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
    if (is_riding && mount_is_bear) {
        var _s_idle_b = sprite_player_bear_idle_bear_brown;
        var _s_walk_b = sprite_player_bear_walk_bear_brown;
        var _s_run_b  = sprite_player_bear_run_bear_brown;
        var _anim_data_b = [
            [_s_idle_b, 0.1, frames_idle],
            [_s_walk_b, 0.15, frames_walk],
            [_s_run_b,  0.25, frames_run]
        ];
        var _current_b = _anim_data_b[state];
        sprite_index = _current_b[0];
        var _prev_frame_b = floor(frame_anim);
        frame_anim += _current_b[1];
        if (frame_anim >= _current_b[2]) frame_anim = 0;
        var _curr_frame_b = floor(frame_anim);
        if (_curr_frame_b != _prev_frame_b) {
            if (state == STATE.WALK || state == STATE.RUN) {
                var _f1b = 1;
                var _f2b = (state == STATE.WALK) ? 2 : 3;
                if (_curr_frame_b == _f1b || _curr_frame_b == _f2b) {
                    audio_play_sound(choose(walk1, walk2, walk3), 1, false);
                }
            }
        }
        image_index = (dir * _current_b[2]) + floor(frame_anim);
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
