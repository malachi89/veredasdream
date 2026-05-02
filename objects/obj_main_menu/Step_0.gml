// --- IP entry mode (shown after "Unirse" is chosen) ---
if (ip_entry_mode) {
    // Allow digits, dots, and letters (for "localhost" / hostnames).
    var _filtered = "";
    for (var _ci = 1; _ci <= string_length(keyboard_string); _ci++) {
        var _ch = string_char_at(keyboard_string, _ci);
        if ((_ch >= "0" && _ch <= "9") || _ch == "."
            || (_ch >= "a" && _ch <= "z") || (_ch >= "A" && _ch <= "Z")) {
            _filtered += _ch;
        }
    }
    if (string_length(_filtered) > 40) _filtered = string_copy(_filtered, 1, 40);
    keyboard_string = _filtered;
    ip_text = keyboard_string;

    if (keyboard_check_pressed(vk_enter) && string_length(keyboard_string) > 0) {
        var _ip = ip_text;
        keyboard_string = "";
        ip_entry_mode   = false;
        connect_waiting = true;
        notif_text  = "Conectando a " + _ip + "...";
        notif_timer = 300;
        net_join_game(_ip);
        // Once obj_net receives FULL_SNAPSHOT it will room_goto itself.
        // We just wait here; the snapshot handler will leave this room.
    }
    if (keyboard_check_pressed(vk_escape)) {
        ip_entry_mode   = false;
        keyboard_string = "";
        notif_text  = "";
        notif_timer = 0;
    }

    // If snapshot was received we'll have changed rooms — nothing else to do here.
    exit;
}

// While waiting for snapshot, just wait (room change happens from net handler)
if (connect_waiting) {
    if (instance_exists(obj_net) && obj_net.connect_state == "failed") {
        connect_waiting = false;
        notif_text  = "No se pudo conectar.";
        notif_timer = 120;
    }
    exit;
}

// --- Options menu ---
if (options_menu_open) {
    var _cx = display_get_gui_width() * 0.5;
    var _cy = display_get_gui_height() * 0.5;
    var _item_count = array_length(settings_items);
    var _total_rows = _item_count + 2;
    var _spacing = 38;
    var _start_y = _cy - 70;

    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);
    var _hit_w = 500;
    var _hit_h = 32;
    var _mouse_on_option = false;

    for (var i = 0; i < _total_rows; i++) {
        var _oy = _start_y + i * _spacing;
        if (_mx >= _cx - _hit_w * 0.5 && _mx <= _cx + _hit_w * 0.5 &&
            _my >= _oy - _hit_h * 0.5 && _my <= _oy + _hit_h * 0.5) {
            options_selection = i;
            _mouse_on_option = true;
            break;
        }
    }

    if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) {
        options_selection -= 1;
        if (options_selection < 0) options_selection = _total_rows - 1;
    }
    if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
        options_selection += 1;
        if (options_selection >= _total_rows) options_selection = 0;
    }

    if (options_selection < _item_count && array_length(settings_items[options_selection].values) > 1) {
        if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"))) {
            var _item = settings_items[options_selection];
            _item[$ "value_index"] = (_item.value_index - 1 + array_length(_item.values)) % array_length(_item.values);
        }
        if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"))) {
            var _item = settings_items[options_selection];
            _item[$ "value_index"] = (_item.value_index + 1) % array_length(_item.values);
        }
    }

    var _confirm = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)
                 || (_mouse_on_option && mouse_check_button_pressed(mb_left));

    if (_confirm) {
        if (options_selection == _item_count) {
            ini_open("settings.ini");
            for (var _i = 0; _i < _item_count; _i++) {
                var _item = settings_items[_i];
                var _val = _item.values[_item.value_index];
                ini_write_real(_item.section, _item.key, _val);
                switch (_item.key) {
                    case "MusicVolume": global.music_volume = _val; break;
                    case "TimeSpeedMultiplier":
                        global.time_multiplier = _val;
                        if (instance_exists(obj_controller)) {
                            obj_controller.time_frames_per_minute = 360 / _val;
                        }
                        break;
                    case "DaysPerSeason": global.days_per_season = _val; break;
                }
            }
            ini_close();
            options_menu_open = false;
            notif_text = "Opciones guardadas.";
            notif_timer = 120;
        } else if (options_selection == _item_count + 1) {
            options_menu_open = false;
        }
    }

    if (keyboard_check_pressed(vk_escape)) {
        options_menu_open = false;
    }

    exit;
}

// --- Normal menu navigation ---
var _cx = display_get_gui_width() * 0.5;
var _cy = display_get_gui_height() * 0.5;
var _start_y = _cy - 50;
var _spacing = 40;

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _hit_w = 300;
var _hit_h = 32;
var _mouse_on_option = false;

for (var i = 0; i < array_length(options); i++) {
    var _oy = _start_y + i * _spacing;
    if (_mx >= _cx - _hit_w * 0.5 && _mx <= _cx + _hit_w * 0.5 &&
        _my >= _oy - _hit_h * 0.5 && _my <= _oy + _hit_h * 0.5) {
        selected_index = i;
        _mouse_on_option = true;
        break;
    }
}

if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) {
    selected_index -= 1;
    if (selected_index < 0) selected_index = array_length(options) - 1;
}
if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
    selected_index += 1;
    if (selected_index >= array_length(options)) selected_index = 0;
}

var _confirm = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)
             || (_mouse_on_option && mouse_check_button_pressed(mb_left));

if (_confirm) {
    var _choice = options[selected_index];

    switch (_choice) {
        case "Nueva Granja":
            audio_stop_sound(menu_music);
            global.net_role = NET_ROLE.NONE;
            global.farm_populated = false;
            global.room_states = {};
            global.room_drops = {};
            global.next_drop_uid = 0;
            global.day = 1;
            global.year = 1;
            global.game_hour = 6;
            global.game_minute = 0;
            global.season_index = 0;
            global.season = "spring";
            global.forest_needs_repopulate = true;
            global.forest_days_since_rare = 0;
            global.forest_days_since_rare_insect = 0;
            global.forest_insects = [];
            global.forest_wild_animals = [];
            global.pending_player_room_name = "";
            if (instance_exists(obj_controller)) {
                obj_controller.pending_loaded_game = undefined;
                obj_controller.load_needs_apply = false;
                obj_controller.current_room_name = "";
                obj_controller.time_tick_counter = 0;
                obj_controller.sleep_menu_open = false;
                obj_controller.shipping_summary_open = false;
            }
            room_goto(farm);
            break;

        case "Hospedar":
            audio_stop_sound(menu_music);
            if (net_host_game()) {
                // Start single-player flow, but with server running.
                // Load existing save if available, otherwise fresh farm.
                if (save_exists) {
                    var _data = scr_read_save_game();
                    if (is_struct(_data)) {
                        if (instance_exists(obj_controller)) {
                            obj_controller.pending_loaded_game = _data;
                            obj_controller.load_needs_apply = true;
                        }
                        var _room_name = (_data.version == 2)
                            ? _data.players[0].room_name
                            : _data.player.room_name;
                        var _target_room = asset_get_index(_room_name);
                        if (_target_room != -1) {
                            room_goto(_target_room);
                        } else {
                            room_goto(farm);
                        }
                    } else {
                        room_goto(farm);
                    }
                } else {
                    room_goto(farm);
                }
                notif_text  = "Servidor iniciado en puerto " + string(net_read_port());
                notif_timer = 120;
            } else {
                notif_text  = "Error al abrir puerto " + string(net_read_port());
                notif_timer = 120;
            }
            break;

        case "Unirse":
            // Enter IP address
            ip_entry_mode   = true;
            keyboard_string = "192.168.100.";
            ip_text         = "192.168.100.";
            notif_text      = "";
            notif_timer     = 0;
            break;

        case "Continuar":
            audio_stop_sound(menu_music);
            if (save_exists) {
                global.net_role = NET_ROLE.NONE;
                var _data = scr_read_save_game();
                if (is_struct(_data)) {
                    if (instance_exists(obj_controller)) {
                        obj_controller.pending_loaded_game = _data;
                        obj_controller.load_needs_apply = true;
                    }
                    var _room_name = (_data.version == 2)
                        ? _data.players[0].room_name
                        : _data.player.room_name;
                    var _target_room = asset_get_index(_room_name);
                    if (_target_room != -1) {
                        room_goto(_target_room);
                    } else {
                        room_goto(farm);
                    }
                }
            } else {
                notif_text  = "No se encontró partida guardada.";
                notif_timer = 120;
            }
            break;

        case "Borrar Granja":
            if (save_exists) {
                file_delete(global.save_file_path);
                save_exists = false;
                if (instance_exists(obj_controller)) {
                    obj_controller.pending_loaded_game = undefined;
                    obj_controller.load_needs_apply = false;
                }
                notif_text  = "Partida borrada con éxito.";
                notif_timer = 120;
            } else {
                notif_text  = "No hay partida que borrar.";
                notif_timer = 120;
            }
            break;

        case "Opciones":
            options_menu_open = true;
            options_selection = 0;
            // Refresh current values from global state
            var _current_music = global.music_volume;
            var _current_time  = global.time_multiplier;
            var _current_days  = global.days_per_season;
            ini_open("settings.ini");
            var _current_port  = ini_read_real("Network", "Port", 7777);
            ini_close();
            for (var _i = 0; _i < array_length(settings_items); _i++) {
                var _item = settings_items[_i];
                var _current = 1.0;
                switch (_item.key) {
                    case "MusicVolume": _current = _current_music; break;
                    case "TimeSpeedMultiplier": _current = _current_time; break;
                    case "DaysPerSeason": _current = _current_days; break;
                    case "Port": _current = _current_port; break;
                }
                _item[$ "value_index"] = 0;
                for (var _j = 0; _j < array_length(_item.values); _j++) {
                    if (_item.values[_j] == _current) {
                        _item[$ "value_index"] = _j;
                        break;
                    }
                }
            }
            notif_text  = "";
            notif_timer = 0;
            break;

        case "Salir":
            game_end();
            break;
    }
}

if (notif_timer > 0) {
    notif_timer -= 1;
} else {
    notif_text = "";
}
