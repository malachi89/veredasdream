if (room_get_name(room) == "rm_main_menu") exit;

if (!variable_instance_exists(id, "season")) season = 0;

if (load_needs_apply) {
    if (!instance_exists(obj_inventory)) instance_create_layer(0, 0, "Instances", obj_inventory);

    scr_apply_loaded_game(pending_loaded_game);
    pending_loaded_game = undefined;
    load_needs_apply = false;
}

// Mantener global.local_player apuntando al jugador local y vincular obj_inventory y camara.
if (!instance_exists(global.local_player) && instance_exists(obj_player)) {
    global.local_player = obj_player;
    obj_player.is_local = true;
    obj_player.is_host  = true;
}
if (instance_exists(obj_inventory) && instance_exists(global.local_player)) {
    obj_inventory.local_player = global.local_player;
}
if (instance_exists(obj_camera) && instance_exists(global.local_player)) {
    obj_camera.target = global.local_player;
}

// Populate farm with trees and rocks on first visit (fresh game only)
if (!global.farm_populated && room_get_name(room) == "farm"
        && instance_exists(global.local_player) && instance_exists(obj_inventory)) {
    global.farm_populated = true;
    scr_populate_farm();
    scr_capture_current_room_state();
}

var _room_name = room_get_name(room);
if (current_room_name != _room_name) {
    current_room_name = _room_name;
    room_change_pending = false;

    // Position player before camera snap to avoid one-frame glitch
    if (global.pending_player_room_name == _room_name && instance_exists(global.local_player)) {
        global.local_player.x        = global.pending_player_x;
        global.local_player.y        = global.pending_player_y;
        global.local_player.dir      = global.pending_player_dir;
        global.local_player.is_riding = false;
        global.local_player.mount_is_bear = false;
        global.pending_player_room_name = "";
        if (global.mine_state.active && instance_exists(obj_ladder_exit)) {
            global.local_player.x = obj_ladder_exit.x + 8;
            global.local_player.y = obj_ladder_exit.y + sprite_get_height(obj_ladder_exit.sprite_index) + 16;
        }
    }

    // Snap camera to player on room entry
    if (instance_exists(obj_camera) && instance_exists(global.local_player)) {
        var _cam_w = obj_camera.cam_width;
        var _cam_h = obj_camera.cam_height;
        var _snap_x = clamp(global.local_player.x - _cam_w / 2, 0, max(0, room_width  - _cam_w));
        var _snap_y = clamp(global.local_player.y - _cam_h / 2, 0, max(0, room_height - _cam_h));
        camera_set_view_pos(obj_camera.cam, _snap_x, _snap_y);
    }

    var _state_key = global.mine_state.active
        ? ("mine_" + string(global.mine_state.door_index) + "_floor_" + string(global.mine_state.floor))
        : _room_name;
    scr_restore_room_state(_state_key);
    scr_restore_room_drops(_state_key);
    if (_room_name == "forest" && !global.forest_needs_repopulate) {
        scr_restore_forest_insects();
        scr_restore_forest_wild_animals();
        scr_restore_forest_enemies();
    }
    
    update_tilesets();
    scr_setup_forest_trees();
}

if (global.forest_needs_repopulate && _room_name == "forest"
        && instance_exists(global.local_player) && instance_exists(obj_inventory)) {
    global.forest_needs_repopulate = false;
    scr_populate_forest();
    scr_capture_current_room_state();
}

if (struct_exists(global.cave_repopulate, _room_name)
        && global.cave_repopulate[$ _room_name]
        && instance_exists(global.local_player)
        && instance_exists(obj_inventory)
        && global.net_role != NET_ROLE.CLIENT) {
    global.cave_repopulate[$ _room_name] = false;
    if (global.mine_state.active) {
        scr_populate_cave(global.mine_state.ore_type, global.mine_state.floor);
        scr_capture_current_room_state();
    } else {
        scr_populate_cave();
        scr_capture_current_room_state();
    }
    if (global.net_role == NET_ROLE.HOST && instance_exists(obj_net) && obj_net.is_connected) {
        var _state_key = global.mine_state.active
            ? "mine_" + string(global.mine_state.door_index) + "_floor_" + string(global.mine_state.floor)
            : _room_name;
        net_broadcast_room_state(_state_key);
    }
}

// Room change detection now handles pending player positioning above.
// Keep this as a safety fallback for edge cases (e.g. save load with same room).
if (global.pending_player_room_name == _room_name && instance_exists(global.local_player) && current_room_name == _room_name) {
    global.local_player.x        = global.pending_player_x;
    global.local_player.y        = global.pending_player_y;
    global.local_player.dir      = global.pending_player_dir;
    global.local_player.is_riding = false;
    global.local_player.mount_is_bear = false;
    global.pending_player_room_name = "";
}

// Time is authoritative on the host. Client receives TIME_UPDATE packets instead.
if (global.net_role != NET_ROLE.CLIENT && !pause_menu_open) {
    time_tick_counter += 1;
    if (time_tick_counter >= time_frames_per_minute) {
        time_tick_counter = 0;
        global.game_minute += 1;
        if (global.game_minute >= 60) {
            global.game_minute = 0;
            global.game_hour += 1;
            if (global.game_hour >= 24) start_new_day();
        }
        if (global.net_role == NET_ROLE.HOST && instance_exists(obj_net) && obj_net.is_connected) {
            net_send_time_update();
        }
    }
}


// Fade in effect
if (is_fading_in) {
    fade_alpha -= fade_speed;
    if (fade_alpha <= 0) {
        fade_alpha = 0;
        is_fading_in = false;
    }
}

// --- DEBUG CONSOLE / CHAT ---
if (keyboard_check_pressed(vk_enter) && !chat_open && !sleep_menu_open && !shipping_summary_open) {
    chat_open = true;
    keyboard_string = "";
    chat_text = "";
}
else if (chat_open) {
    chat_text = keyboard_string;
    if (keyboard_check_pressed(vk_enter)) {
        var _input = string_trim(chat_text);
        if (_input != "") {
            var _parts = string_split(_input, " ");
            var _cmd = _parts[0];
            
            if (_cmd == "add_item" && array_length(_parts) >= 3) {
                var _item = _parts[1];
                var _qty = real(_parts[2]);
                if (instance_exists(global.local_player)) {
                    if (global.local_player.add_item(_item, _qty)) {
                        scr_notify("Agregado: " + string(_qty) + " " + _item);
                    } else {
                        scr_notify("Inventario lleno");
                    }
                }
            } else if (_cmd == "add_animal" && array_length(_parts) >= 2) {
                var _animal = _parts[1];
                scr_add_animal(_animal);
            } else if (_cmd == "upgrade_tool" && array_length(_parts) >= 2) {
                var _item = _parts[1];
                if (global.net_role == NET_ROLE.CLIENT && instance_exists(obj_net) && obj_net.is_connected) {
                    net_send_upgrade_tool(_item);
                } else {
                    scr_upgrade_tool(_item);
                }
            } else if (_cmd == "buy_building" && array_length(_parts) >= 2) {
                var _bname = _parts[1];
                if (global.net_role == NET_ROLE.CLIENT && instance_exists(obj_net) && obj_net.is_connected) {
                    net_send_buy_building(_bname);
                } else {
                    scr_buy_building(_bname);
                }
            } else if (_cmd == "set_money" && array_length(_parts) >= 2) {
                if (instance_exists(global.local_player)) {
                    global.local_player.money = real(_parts[1]);
                    scr_notify("Dinero: MXN$ " + string(global.local_player.money));
                }
            } else if (_cmd == "set_energy" && array_length(_parts) >= 2) {
                if (instance_exists(global.local_player)) {
                    global.local_player.energy = clamp(real(_parts[1]), 0, global.local_player.max_energy);
                    scr_notify("Energia: " + string(global.local_player.energy));
                }
            } else if (_cmd == "set_hp" && array_length(_parts) >= 2) {
                if (instance_exists(global.local_player)) {
                    global.local_player.hp = clamp(real(_parts[1]), 0, global.local_player.max_hp);
                    scr_notify("HP: " + string(global.local_player.hp));
                }
            } else if (_cmd == "heal") {
                if (instance_exists(global.local_player)) {
                    global.local_player.energy = global.local_player.max_energy;
                    global.local_player.hp = global.local_player.max_hp;
                    scr_notify("Energia y salud restauradas");
                }
            } else if (_cmd == "set_day" && array_length(_parts) >= 2) {
                if (global.net_role == NET_ROLE.CLIENT) {
                    scr_notify("Solo el host puede cambiar el tiempo");
                } else {
                    global.day = clamp(real(_parts[1]), 1, global.days_per_season);
                    scr_notify("Dia: " + string(global.day));
                    if (global.net_role == NET_ROLE.HOST && instance_exists(obj_net) && obj_net.is_connected) net_send_time_update();
                }
            } else if (_cmd == "set_hour" && array_length(_parts) >= 2) {
                if (global.net_role == NET_ROLE.CLIENT) {
                    scr_notify("Solo el host puede cambiar el tiempo");
                } else {
                    global.game_hour   = clamp(real(_parts[1]), 0, 23);
                    global.game_minute = 0;
                    scr_notify("Hora: " + string(global.game_hour) + ":00");
                    if (global.net_role == NET_ROLE.HOST && instance_exists(obj_net) && obj_net.is_connected) net_send_time_update();
                }
            } else if (_cmd == "set_season" && array_length(_parts) >= 2) {
                if (global.net_role == NET_ROLE.CLIENT) {
                    scr_notify("Solo el host puede cambiar el tiempo");
                } else {
                    var _sname = _parts[1];
                    var _sidx = -1;
                    for (var _si = 0; _si < 4; _si++) {
                        if (global.season_list[_si] == _sname) { _sidx = _si; break; }
                    }
                    if (_sidx != -1) {
                        global.season_index = _sidx;
                        global.season = global.season_list[_sidx];
                        update_tilesets();
                        scr_notify("Estacion: " + global.season_names[$ global.season]);
                        if (global.net_role == NET_ROLE.HOST && instance_exists(obj_net) && obj_net.is_connected) net_send_time_update();
                    } else {
                        scr_notify("Estacion invalida. Usa: spring summer fall winter");
                    }
                }
            } else if (_cmd == "spawn_enemy" && array_length(_parts) >= 2) {
                var _ename = _parts[1];
                var _edata = global.enemy_data[$ _ename];
                if (_edata != undefined && variable_struct_exists(_edata, "object")) {
                    var _eobj = _edata.object;
                    var _ex = floor(mouse_x / 16) * 16 + 8;
                    var _ey = floor(mouse_y / 16) * 16 + 8;
                    if (!instance_position(_ex, _ey, obj_collision)) {
                        var _inst = instance_create_layer(_ex, _ey, "Instances", _eobj);
                        scr_notify("Generado: " + _edata.name + " en (" + string(_ex) + ", " + string(_ey) + ")");
                    } else {
                        scr_notify("No hay espacio disponible");
                    }
                } else {
                    scr_notify("Enemigo desconocido: " + _ename);
                }
            } else if (_cmd == "spawn_player2") {
                // Phase 2 test harness: spawn a second player (non-local) at the cursor.
                var _p2 = noone;
                with (obj_player) {
                    if (player_id == 2) { _p2 = id; break; }
                }
                if (_p2 != noone) {
                    scr_notify("Jugador 2 ya existe");
                } else {
                    _p2 = instance_create_layer(mouse_x, mouse_y, "Instances", obj_player);
                    _p2.player_id = 2;
                    _p2.is_local  = false;
                    _p2.is_host   = false;
                    // Give player 2 independent starter equipment
                    _p2.add_item("watering_can", 1);
                    _p2.add_item("pickaxe", 1);
                    _p2.add_item("axe", 1);
                    _p2.add_item("sickle", 1);
                    _p2.add_item("hoe", 1);
                    _p2.add_item("shovel", 1);
                    _p2.add_item("fishing_rod", 1);
                    _p2.add_item("bugnet", 1);
                    _p2.add_item("sword_1", 1);
                    _p2.add_item("bow_1", 1);
                    _p2.add_item("parsnip_seeds", 10);
                    scr_notify("Jugador 2 generado en (" + string(mouse_x) + ", " + string(mouse_y) + ")");
                }
            } else if (_cmd == "focus_player" && array_length(_parts) >= 2) {
                // Switch camera to follow player 1 or 2.
                var _target_id = real(_parts[1]);
                var _found = noone;
                with (obj_player) {
                    if (player_id == _target_id) { _found = id; break; }
                }
                if (_found != noone) {
                    global.local_player = _found;
                    if (instance_exists(obj_camera)) obj_camera.target = _found;
                    if (instance_exists(obj_inventory)) obj_inventory.local_player = _found;
                    scr_notify("Camara en jugador " + string(_target_id));
                } else {
                    scr_notify("Jugador " + string(_target_id) + " no encontrado");
                }
            } else if (_cmd == "test_animals" && array_length(_parts) >= 2) {
                var _sub = _parts[1];
                if (_sub == "on") {
                    global.debug_test_animals = true;
                    global.farm_needs_repopulate_test_animals = true;
                    if (room_get_name(room) == "farm") {
                        scr_populate_test_animals();
                        scr_capture_current_room_state();
                        scr_notify("Test animals enabled and spawned.");
                    } else {
                        scr_notify("Test animals enabled (will spawn on farm entry).");
                    }
                } else if (_sub == "off") {
                    global.debug_test_animals = false;
                    global.farm_needs_repopulate_test_animals = false;
                    if (room_get_name(room) == "farm") {
                        with (obj_wild_animal) { if (is_test_animal) instance_destroy(); }
                        scr_capture_current_room_state();
                        scr_notify("Test animals disabled and removed.");
                    } else {
                        scr_notify("Test animals disabled.");
                    }
                }
            } else if (_cmd == "debug_mp") {
                var _role_str = "NONE";
                if (global.net_role == NET_ROLE.HOST)   _role_str = "HOST";
                if (global.net_role == NET_ROLE.CLIENT) _role_str = "CLIENT";
                show_debug_message("=== MP DEBUG ===");
                show_debug_message("net_role: " + _role_str);
                if (instance_exists(obj_net)) {
                    show_debug_message("obj_net.is_connected: " + string(obj_net.is_connected));
                    show_debug_message("obj_net.connect_state: " + obj_net.connect_state);
                } else {
                    show_debug_message("obj_net: not present");
                }
                if (instance_exists(global.local_player)) {
                    var _lp = global.local_player;
                    show_debug_message("local_player id=" + string(_lp) +
                        " player_id=" + string(_lp.player_id) +
                        " is_local=" + string(_lp.is_local) +
                        " is_host=" + string(_lp.is_host));
                    show_debug_message("local_player x=" + string(_lp.x) +
                        " y=" + string(_lp.y) +
                        " state=" + string(_lp.state));
                } else {
                    show_debug_message("local_player: NONE");
                }
                with (obj_player) {
                    show_debug_message("obj_player inst=" + string(id) +
                        " pid=" + string(player_id) +
                        " is_local=" + string(is_local) +
                        " x=" + string(x) + " y=" + string(y));
                }
                show_debug_message("================");
                scr_notify("MP debug impreso en consola");
            } else if (_cmd == "unlock" && array_length(_parts) >= 2) {
                var _unlock_idx = real(_parts[1]);
                if (_unlock_idx >= 0 && _unlock_idx < 8) {
                    global.mine_unlocks[_unlock_idx] = true;
                    scr_notify("Puerta " + string(_unlock_idx) + " desbloqueada");
                } else {
                    scr_notify("Indice de puerta invalido (0-7)");
                }
            } else {
                scr_notify("Comando desconocido: " + _cmd);
            }
        }
        chat_open = false;
        keyboard_string = "";
    }
    if (keyboard_check_pressed(vk_escape)) {
        chat_open = false;
        keyboard_string = "";
    }
    exit; // Skip further input processing while chat is open
}

// --- PAUSE MENU ---
if (keyboard_check_pressed(vk_escape)) {
    if (pause_menu_open) {
        pause_menu_open = false;
    } else {
        var _lp_chk = global.local_player;
        var _any_ui_open =
            sleep_menu_open        ||
            sleep_prompt_open      ||
            shipping_summary_open  ||
            (instance_exists(_lp_chk) && (
                _lp_chk.show_backpack ||
                _lp_chk.show_shipping ||
                _lp_chk.show_chest    ||
                _lp_chk.shop_open     ||
                _lp_chk.dialog_open
            ));
        if (!_any_ui_open) {
            pause_menu_open = true;
            pause_menu_selection = 0;
        }
    }
}

if (pause_menu_open) {
    if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) {
        pause_menu_selection = (pause_menu_selection - 1 + 3) mod 3;
    }
    if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
        pause_menu_selection = (pause_menu_selection + 1) mod 3;
    }

    var _pmx = device_mouse_x_to_gui(0);
    var _pmy = device_mouse_y_to_gui(0);
    var _pcx = display_get_gui_width()  * 0.5;
    var _pcy = display_get_gui_height() * 0.5;

    var _opt_w  = 260;
    var _opt_h  = 44;
    var _opt_x1 = _pcx - (_opt_w * 0.5);
    var _opt_x2 = _pcx + (_opt_w * 0.5);
    var _opt_y  = [_pcy - 20, _pcy + 36, _pcy + 92];

    for (var _i = 0; _i < 3; _i++) {
        if (point_in_rectangle(_pmx, _pmy, _opt_x1, _opt_y[_i], _opt_x2, _opt_y[_i] + _opt_h)) {
            pause_menu_selection = _i;
        }
    }

    var _confirm = keyboard_check_pressed(vk_enter)
                || keyboard_check_pressed(ord("E"))
                || (mouse_check_button_pressed(mb_left)
                    && point_in_rectangle(_pmx, _pmy,
                           _opt_x1, _opt_y[pause_menu_selection],
                           _opt_x2, _opt_y[pause_menu_selection] + _opt_h));

    if (_confirm) {
        switch (pause_menu_selection) {
            case 0: // Continuar
                pause_menu_open = false;
                break;
            case 1: // Menu Principal
                pause_menu_open = false;
                if (instance_exists(global.local_player)) instance_destroy(global.local_player);
                global.local_player = noone;
                if (instance_exists(obj_inventory)) instance_destroy(obj_inventory);
                if (instance_exists(obj_camera)) instance_destroy(obj_camera);
                pending_loaded_game = scr_read_save_game();
                room_goto(rm_main_menu);
                break;
            case 2: // Salir
                game_end();
                break;
        }
    }

    exit; // Block all further Step processing while paused
}

if (keyboard_check_pressed(ord("P"))) {
    global.season_index = (global.season_index + 1) mod 4;
    global.season = global.season_list[global.season_index];
    update_tilesets();
    show_debug_message("Estacion: " + global.season_names[$ global.season]);
    if (global.net_role == NET_ROLE.HOST && instance_exists(obj_net) && obj_net.is_connected) net_send_time_update();
}

if (keyboard_check_pressed(ord("O"))) start_new_day();

if (keyboard_check_pressed(ord("Y"))) {
    if (!instance_exists(obj_minigame_timing)) {
        var _inst = instance_create_depth(0, 0, 0, obj_minigame_timing);
        _inst.difficulty = minigame_difficulty;
        
        var _diff_names = ["FACIL", "MODERADO", "DIFICIL", "EXTREMO"];
        scr_notify("Minijuego: " + _diff_names[minigame_difficulty]);
        
        // Cycle difficulty for next time
        minigame_difficulty = (minigame_difficulty + 1) mod 4;
    }
}

if (keyboard_check_pressed(ord("U"))) {
    if (instance_exists(global.local_player)) {
        inventory_drop_item("tomato_seeds", 5, global.local_player.x, global.local_player.y);
        show_debug_message("Drop: 5 Tomato Seeds");
    }
}

var _lp = global.local_player;
if (instance_exists(_lp)) {
    var _bed = collision_rectangle(_lp.bbox_left, _lp.bbox_top, _lp.bbox_right, _lp.bbox_bottom, obj_bed, false, true);
    var _touching_bed = (_bed != noone);
    if (_touching_bed && !bed_overlap_previous && !sleep_menu_open) {
        sleep_menu_open = true;
        sleep_menu_selection = 0;
        _lp.show_backpack = false;
        _lp.show_shipping = false;
        _lp.held_item = -1;
    }
    bed_overlap_previous = _touching_bed;
}

if (sleep_menu_open) {
    if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A")) || keyboard_check_pressed(ord("S"))) sleep_menu_selection = 0;
    if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D")) || keyboard_check_pressed(ord("N"))) sleep_menu_selection = 1;

    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);
    var _cx = display_get_gui_width() * 0.5;
    var _cy = display_get_gui_height() * 0.5;
    var _yes_x1 = _cx - 120;
    var _yes_y1 = _cy + 20;
    var _yes_x2 = _cx - 20;
    var _yes_y2 = _cy + 78;
    var _no_x1 = _cx + 20;
    var _no_y1 = _cy + 20;
    var _no_x2 = _cx + 120;
    var _no_y2 = _cy + 78;

    if (point_in_rectangle(_mx, _my, _yes_x1, _yes_y1, _yes_x2, _yes_y2)) sleep_menu_selection = 0;
    if (point_in_rectangle(_mx, _my, _no_x1, _no_y1, _no_x2, _no_y2)) sleep_menu_selection = 1;

    if (mouse_check_button_pressed(mb_left)) {
        if (point_in_rectangle(_mx, _my, _yes_x1, _yes_y1, _yes_x2, _yes_y2)) {
            sleep_menu_open = false;
            if (instance_exists(_lp)) _lp.tool_locked_frames = 5;
            scr_on_sleep_yes();
        } else if (point_in_rectangle(_mx, _my, _no_x1, _no_y1, _no_x2, _no_y2)) {
            sleep_menu_open = false;
            if (instance_exists(_lp)) _lp.tool_locked_frames = 5;
        }
    }

    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("E"))) {
        if (sleep_menu_selection == 0) {
            sleep_menu_open = false;
            scr_on_sleep_yes();
        } else {
            sleep_menu_open = false;
        }
    }

    if (keyboard_check_pressed(vk_escape)) sleep_menu_open = false;
}

// Client-side sleep confirmation when host initiates sleep
if (sleep_prompt_open) {
    var _mx2 = device_mouse_x_to_gui(0);
    var _my2 = device_mouse_y_to_gui(0);
    var _cx2 = display_get_gui_width() * 0.5;
    var _cy2 = display_get_gui_height() * 0.5;
    var _yes_x1b = _cx2 - 120; var _yes_y1b = _cy2 + 20;
    var _yes_x2b = _cx2 - 20;  var _yes_y2b = _cy2 + 78;
    var _no_x1b  = _cx2 + 20;  var _no_y1b  = _cy2 + 20;
    var _no_x2b  = _cx2 + 120; var _no_y2b  = _cy2 + 78;

    if (point_in_rectangle(_mx2, _my2, _yes_x1b, _yes_y1b, _yes_x2b, _yes_y2b)) sleep_prompt_selection = 0;
    if (point_in_rectangle(_mx2, _my2, _no_x1b, _no_y1b, _no_x2b, _no_y2b))     sleep_prompt_selection = 1;
    if (keyboard_check_pressed(vk_left)  || keyboard_check_pressed(ord("A")) || keyboard_check_pressed(ord("S"))) sleep_prompt_selection = 0;
    if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D")) || keyboard_check_pressed(ord("N"))) sleep_prompt_selection = 1;

    if (mouse_check_button_pressed(mb_left)) {
        if (point_in_rectangle(_mx2, _my2, _yes_x1b, _yes_y1b, _yes_x2b, _yes_y2b)) {
            sleep_prompt_open = false;
            if (instance_exists(global.local_player)) global.local_player.tool_locked_frames = 5;
            sent_sleep_request = true;
            net_send_sleep_response(true);
            scr_notify("Esperando nuevo dia...");
        } else if (point_in_rectangle(_mx2, _my2, _no_x1b, _no_y1b, _no_x2b, _no_y2b)) {
            sleep_prompt_open = false;
            if (instance_exists(global.local_player)) global.local_player.tool_locked_frames = 5;
            net_send_sleep_response(false);
        }
    }

    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("E"))) {
        if (sleep_prompt_selection == 0) {
            sleep_prompt_open = false;
            sent_sleep_request = true;
            net_send_sleep_response(true);
            scr_notify("Esperando nuevo dia...");
        } else {
            sleep_prompt_open = false;
            net_send_sleep_response(false);
        }
    }
    if (keyboard_check_pressed(vk_escape)) {
        sleep_prompt_open = false;
        net_send_sleep_response(false);
    }
}

// --- MINE PROMPT (ladder down / exit) ---
if (mine_prompt_open) {
    var _mx3 = device_mouse_x_to_gui(0);
    var _my3 = device_mouse_y_to_gui(0);
    var _cx3 = display_get_gui_width() * 0.5;
    var _cy3 = display_get_gui_height() * 0.5;
    var _yes_x3 = _cx3 - 120; var _yes_y3 = _cy3 + 20;
    var _yes_x4 = _cx3 - 20;  var _yes_y4 = _cy3 + 78;
    var _no_x3  = _cx3 + 20;  var _no_y3  = _cy3 + 20;
    var _no_x4  = _cx3 + 120; var _no_y4  = _cy3 + 78;

    if (point_in_rectangle(_mx3, _my3, _yes_x3, _yes_y3, _yes_x4, _yes_y4)) mine_prompt_selection = 0;
    if (point_in_rectangle(_mx3, _my3, _no_x3, _no_y3, _no_x4, _no_y4))     mine_prompt_selection = 1;
    if (keyboard_check_pressed(vk_left)  || keyboard_check_pressed(ord("A"))) mine_prompt_selection = 0;
    if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"))) mine_prompt_selection = 1;

    if (mouse_check_button_pressed(mb_left)) {
        if (point_in_rectangle(_mx3, _my3, _yes_x3, _yes_y3, _yes_x4, _yes_y4)) {
            mine_prompt_open = false;
            if (mine_prompt_type == "down") {
                scr_go_deeper();
            } else if (mine_prompt_type == "exit") {
                scr_exit_mine();
            }
        } else if (point_in_rectangle(_mx3, _my3, _no_x3, _no_y3, _no_x4, _no_y4)) {
            mine_prompt_open = false;
            if (instance_exists(global.local_player)) global.local_player.tool_locked_frames = 5;
        }
    }

    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("E"))) {
        if (mine_prompt_selection == 0) {
            mine_prompt_open = false;
            if (mine_prompt_type == "down") {
                scr_go_deeper();
            } else if (mine_prompt_type == "exit") {
                scr_exit_mine();
            }
        } else {
            mine_prompt_open = false;
            if (instance_exists(global.local_player)) global.local_player.tool_locked_frames = 5;
        }
    }
    if (keyboard_check_pressed(vk_escape)) {
        mine_prompt_open = false;
        if (instance_exists(global.local_player)) global.local_player.tool_locked_frames = 5;
    }
}

if (shipping_summary_open) {
    if (shipping_summary_pending_close) {
        shipping_summary_open = false;
        shipping_summary_pending_close = false;
        if (instance_exists(global.local_player)) global.local_player.tool_locked_frames = 5;
        sent_sleep_request  = false;
        host_wants_sleep    = false;
        client_wants_sleep  = false;
        sleep_prompt_sent   = false;
        start_new_day();
        if (global.net_role != NET_ROLE.CLIENT) scr_save_game();
        scr_notify("Nuevo dia comenzado");
    } else {
        var _mx = device_mouse_x_to_gui(0);
        var _my = device_mouse_y_to_gui(0);
        var _cx = display_get_gui_width() * 0.5;
        var _cy = display_get_gui_height() * 0.5;

        // Boton "Continuar" (Debe coincidir EXACTAMENTE con el Draw Event)
        var _tw = 450;
        var _th = 550;
        var _ty2 = _cy + (_th / 2) - 40;

        var _btn_w = 240;
        var _btn_h = 60;
        var _btn_x1 = _cx - (_btn_w / 2);
        var _btn_y1 = _ty2 + 40;
        var _btn_x2 = _cx + (_btn_w / 2);
        var _btn_y2 = _btn_y1 + _btn_h;

        if (mouse_check_button_pressed(mb_left)) {
            if (point_in_rectangle(_mx, _my, _btn_x1, _btn_y1, _btn_x2, _btn_y2)) {
                shipping_summary_pending_close = true;
                if (instance_exists(global.local_player)) global.local_player.tool_locked_frames = 5;
            }
        }

        if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_space)) {
            shipping_summary_pending_close = true;
        }
    }
}

gx = floor(mouse_x / 16) * 16;
gy = floor(mouse_y / 16) * 16;
show_selector = false;

var _lp = global.local_player;
if (instance_exists(_lp) && !sleep_menu_open && !_lp.show_backpack) {
    var _slot_content = _lp.inventory_array[_lp.selected_slot];
    var _item_key = is_struct(_slot_content) ? _slot_content.key : _slot_content;
    if (_item_key != -1 && _item_key != "") {
        var _is_tool = variable_struct_exists(global.tool_data, _item_key);
        var _is_seed = variable_struct_exists(global.seed_data, _item_key);
        var _is_placeable = variable_struct_exists(global.placeable_data, _item_key);
        
        var _is_aoe_tool = _is_tool && (_item_key == "hoe" || _item_key == "watering_can" ||
                           _item_key == "shovel" || _item_key == "sickle" ||
                           _item_key == "pickaxe" || _item_key == "axe");
        if (_is_seed || _is_placeable || _is_aoe_tool) {
            show_selector = true;
            // Compute selector size from tier stats, swapped for UP/DOWN facing
            selector_w = 1;
            selector_h = 1;
            if (variable_struct_exists(global.tool_progression, _item_key)) {
                var _prog = global.tool_progression[$ _item_key];
                var _q = (is_struct(_slot_content) && variable_struct_exists(_slot_content, "quality")) ? _slot_content.quality : QUALITY.OXIDADO;
                if (_q >= 0 && _q < array_length(_prog)) {
                    var _ts = _prog[_q];
                    var _facing_vertical = instance_exists(_lp) && (_lp.dir == DIR.UP || _lp.dir == DIR.DOWN);
                    selector_w = _facing_vertical ? _ts.area_height : _ts.area_width;
                    selector_h = _facing_vertical ? _ts.area_width  : _ts.area_height;
                }
            }
            if (instance_exists(_lp)) {
                var _p_cx = (_lp.bbox_left + _lp.bbox_right) / 2;
                var _p_cy = (_lp.bbox_top + _lp.bbox_bottom) / 2;
                var _actual_dist = point_distance(_p_cx, _p_cy, gx + 8, gy + 8);
                
                // --- Re-fetch map IDs, as they might be -1 if not in the room ---
                var _layer_tilled = layer_get_id("Tiles_tilled_watered");
                var _map_id = (_layer_tilled != -1) ? layer_tilemap_get_id(_layer_tilled) : -1;
                var _layer_details = layer_get_id("Tiles_details");
                var _map_id_details = (_layer_details != -1) ? layer_tilemap_get_id(_layer_details) : -1;
                // --- End Re-fetch ---

                // NEW: Check if the seed is for a tree
                var _selected_item_data = (is_struct(_slot_content)) ? scr_get_item_data(_item_key) : undefined;
                var _is_fruit_tree_seed = variable_struct_exists(_selected_item_data, "is_fruit_tree") && _selected_item_data.is_fruit_tree;

                var _is_placeable_data = _is_placeable ? global.placeable_data[$ _item_key] : undefined;
                var _placeable_tiles_w = 1;
                var _placeable_tiles_h = 1;
                if (_is_placeable_data != undefined && _is_placeable_data.sprite != undefined) {
                    _placeable_tiles_w = ceil(sprite_get_width(_is_placeable_data.sprite) / 16);
                    _placeable_tiles_h = ceil(sprite_get_height(_is_placeable_data.sprite) / 16);
                }

                var _can_actually_place = false;

                if (_is_fruit_tree_seed) {
                    // For trees, check 2x3 area
                    var _tree_width_tiles = 2; // 32px / 16px
                    var _tree_height_tiles = 3; // 48px / 16px

                    var _gx_end = gx + (_tree_width_tiles * 16) - 1;
                    var _gy_end = gy + (_tree_height_tiles * 16) - 1;

                    // Check boundaries and collisions in the 2x3 area
                    var _tree_area_in_bounds = gx >= 0 && gy >= 0 && _gx_end < room_width && _gy_end < room_height;
                    var _tree_area_clear = _tree_area_in_bounds;

                    if (_tree_area_clear) {
                        for (var xx = gx; xx < gx + (_tree_width_tiles * 16); xx += 16) {
                            for (var yy = gy; yy < gy + (_tree_height_tiles * 16); yy += 16) {
                                if (instance_position(xx + 8, yy + 8, obj_crop) ||
instance_position(xx + 8, yy + 8, obj_tree) ||
                                    instance_position(xx + 8, yy + 8, obj_collision) ||
                                    instance_position(xx + 8, yy + 8, obj_item_parent) ||
                                    collision_rectangle(xx, yy, xx + 15, yy + 15, obj_player, false, true) || // Player collision in each tile
                                    (_map_id_details != -1 && tilemap_get_at_pixel(_map_id_details, xx, yy) != 0)) {
                                    _tree_area_clear = false;
                                    break;
            }
            if (_is_placeable) {
                var _pdata = global.placeable_data[$ _item_key];
                if (_pdata != undefined && _pdata.sprite != undefined) {
                    selector_w = variable_struct_exists(_pdata, "tile_w") ? _pdata.tile_w : ceil(sprite_get_width(_pdata.sprite) / 16);
                    selector_h = variable_struct_exists(_pdata, "tile_h") ? _pdata.tile_h : ceil(sprite_get_height(_pdata.sprite) / 16);
                }
            }
                            }
                            if (!_tree_area_clear) break;
                        }
                    }
                    _can_actually_place = _tree_area_clear && (_actual_dist <= 32); // Add distance check for trees
                } else {
                    // Existing logic for normal crops and placeable objects
                    var _tw = _is_placeable ? _placeable_tiles_w : 1;
                    var _th = _is_placeable ? _placeable_tiles_h : 1;
                    if (_is_placeable) {
                        selector_w = _placeable_tiles_w;
                        selector_h = _placeable_tiles_h;
                    }
                    var _px_end = gx + _tw * 16;
                    var _py_end = gy + _th * 16;

                    var _occupied = false;
                    for (var _tx = gx; _tx < _px_end; _tx += 16) {
                        for (var _ty = gy; _ty < _py_end; _ty += 16) {
                            if (instance_position(_tx + 8, _ty + 8, obj_collision) ||
                                instance_position(_tx + 8, _ty + 8, obj_crop) ||
                                instance_position(_tx + 8, _ty + 8, obj_tree) ||
                                instance_position(_tx + 8, _ty + 8, obj_item_parent)) {
                                _occupied = true;
                                break;
                            }
                        }
                        if (_occupied) break;
                    }
                    
                    var _collides_with_player = collision_rectangle(gx, gy, _px_end - 1, _py_end - 1, obj_player, false, true);
                    
                    var _in_bounds = gx >= 0 && gy >= 0 && _px_end <= room_width && _py_end <= room_height;
                    
                    var _current_tile_at_gxgy = (_map_id != -1) ? tilemap_get_at_pixel(_map_id, gx, gy) : 0; // Use _gx, _gy directly
                    var _is_tillable_ground = (_map_id != -1 && (_current_tile_at_gxgy == 72 || _current_tile_at_gxgy == 168)) && (_map_id_details != -1 && tilemap_get_at_pixel(_map_id_details, gx, gy) == 0);
                    
                    _can_actually_place = (_actual_dist <= 32 || _is_placeable) && !_occupied && !_collides_with_player && _in_bounds;
                    
                    if (_is_seed && !_is_placeable) { // Only if it's a normal seed, it needs tilled soil
                        _can_actually_place = _can_actually_place && _is_tillable_ground;
                    }
                }
                
                if (_is_seed || _is_placeable) { // Selector only applies to seeds and placeables
                    selector_color = _can_actually_place ? c_green : c_red;
                } else {
                    selector_color = c_green; // Other tools always show green
                }
            }
        }
    }
}

var _sc = global.sound_clips;
for (var _i = array_length(_sc) - 1; _i >= 0; _i--) {
    _sc[_i].timer--;
    if (_sc[_i].timer <= 0) {
        if (audio_is_playing(_sc[_i].id)) {
            audio_stop_sound(_sc[_i].id);
        }
        array_delete(_sc, _i, 1);
    }
}

for (var i = 0; i < ds_list_size(notifications); i++) {
    var _notif = notifications[| i];
    _notif.timer -= 1;
    if (_notif.timer < 30) _notif.alpha -= 0.03;
    if (_notif.timer <= 0) {
        ds_list_delete(notifications, i);
        i--;
    }
}
