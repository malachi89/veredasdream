// === NAME ENTRY MODE (checked first to override slot selection) ===
if (name_entry_mode) {
    // Filter keyboard input for farm/player names
    var _filtered = "";
    for (var _ci = 1; _ci <= string_length(keyboard_string); _ci++) {
        var _ch = string_char_at(keyboard_string, _ci);
        if ((_ch >= "a" && _ch <= "z") || (_ch >= "A" && _ch <= "Z")
            || (_ch >= "0" && _ch <= "9") || _ch == " " || _ch == "." || _ch == "," || _ch == "'") {
            _filtered += _ch;
        }
    }
    if (string_length(_filtered) > 30) _filtered = string_copy(_filtered, 1, 30);
    keyboard_string = _filtered;

    if (name_entry_field == 0) {
        farm_name_input = keyboard_string;
    } else {
        player_name_input = keyboard_string;
    }

    // Handle field switching and confirmation
    if (keyboard_check_pressed(vk_tab)) {
        name_entry_field = (name_entry_field + 1) % 2;
        keyboard_string = (name_entry_field == 0) ? farm_name_input : player_name_input;
    }
    if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) {
        name_entry_field = 0;
        keyboard_string = farm_name_input;
    }
    if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
        name_entry_field = 1;
        keyboard_string = player_name_input;
    }

    // Confirm button via mouse
    var _cx = display_get_gui_width() * 0.5;
    var _cy = display_get_gui_height() * 0.5;
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);
    var _btn_w = 240;
    var _btn_h = 50;
    var _btn_x1 = _cx - _btn_w * 0.5;
    var _btn_y1 = _cy + 130;
    var _btn_x2 = _btn_x1 + _btn_w;
    var _btn_y2 = _btn_y1 + _btn_h;

    if (_mx >= _btn_x1 && _mx <= _btn_x2 && _my >= _btn_y1 && _my <= _btn_y2) {
        if (mouse_check_button_pressed(mb_left)) {
            if (farm_name_input != "" && player_name_input != "") {
                audio_stop_sound(menu_music);
                global.player_name = player_name_input;
                global.farm_name = farm_name_input;
                scr_set_save_slot(slot_selected);
                if (slot_select_mode == "host") {
                    if (!net_host_game()) {
                        notif_text = "Error al abrir puerto " + string(net_read_port());
                        notif_timer = 120;
                        exit;
                    }
                } else {
                    global.net_role = NET_ROLE.NONE;
                }
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
            } else {
                notif_text = "Ambos campos son obligatorios.";
                notif_timer = 120;
            }
        }
    }

    if (keyboard_check_pressed(vk_enter)) {
        if (farm_name_input != "" && player_name_input != "") {
            audio_stop_sound(menu_music);
            global.player_name = player_name_input;
            global.farm_name = farm_name_input;
            scr_set_save_slot(slot_selected);
            if (slot_select_mode == "host") {
                if (!net_host_game()) {
                    notif_text = "Error al abrir puerto " + string(net_read_port());
                    notif_timer = 120;
                    exit;
                }
                notif_text = "Servidor iniciado en puerto " + string(net_read_port());
                notif_timer = 120;
            } else {
                global.net_role = NET_ROLE.NONE;
            }
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
        } else {
            notif_text = "Ambos campos son obligatorios.";
            notif_timer = 120;
        }
    }

    if (keyboard_check_pressed(vk_escape)) {
        name_entry_mode = false;
        slot_select_mode = "";
        keyboard_string = "";
    }

    exit;
}

// === CONFIRM OVERWRITE ===
if (confirm_overwrite) {
    var _cx = display_get_gui_width() * 0.5;
    var _cy = display_get_gui_height() * 0.5;
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);

    var _btn_w = 120;
    var _btn_h = 40;
    var _no_x1 = _cx - _btn_w - 10;
    var _yes_x1 = _cx + 10;
    var _btn_y1 = _cy + 30;
    var _no_x2 = _no_x1 + _btn_w;
    var _yes_x2 = _yes_x1 + _btn_w;
    var _btn_y2 = _btn_y1 + _btn_h;

    if (_mx >= _no_x1 && _mx <= _no_x2 && _my >= _btn_y1 && _my <= _btn_y2) {
        confirm_selection = 0;
        if (mouse_check_button_pressed(mb_left)) {
            confirm_overwrite = false;
        }
    }
    if (_mx >= _yes_x1 && _mx <= _yes_x2 && _my >= _btn_y1 && _my <= _btn_y2) {
        confirm_selection = 1;
        if (mouse_check_button_pressed(mb_left)) {
            confirm_overwrite = false;
            name_entry_mode = true;
            name_entry_field = 0;
            farm_name_input = "";
            player_name_input = "";
        }
    }

    if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"))) {
        confirm_selection = 0;
    }
    if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"))) {
        confirm_selection = 1;
    }
    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
        if (confirm_selection == 1) {
            confirm_overwrite = false;
            name_entry_mode = true;
            name_entry_field = 0;
            farm_name_input = "";
            player_name_input = "";
        } else {
            confirm_overwrite = false;
        }
    }
    if (keyboard_check_pressed(vk_escape)) {
        confirm_overwrite = false;
    }

    exit;
}

// === CONFIRM DELETE ===
if (confirm_delete) {
    var _cx = display_get_gui_width() * 0.5;
    var _cy = display_get_gui_height() * 0.5;
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);

    var _btn_w = 120;
    var _btn_h = 40;
    var _no_x1 = _cx - _btn_w - 10;
    var _yes_x1 = _cx + 10;
    var _btn_y1 = _cy + 30;
    var _no_x2 = _no_x1 + _btn_w;
    var _yes_x2 = _yes_x1 + _btn_w;
    var _btn_y2 = _btn_y1 + _btn_h;

    if (_mx >= _no_x1 && _mx <= _no_x2 && _my >= _btn_y1 && _my <= _btn_y2) {
        confirm_selection = 0;
        if (mouse_check_button_pressed(mb_left)) {
            confirm_delete = false;
        }
    }
    if (_mx >= _yes_x1 && _mx <= _yes_x2 && _my >= _btn_y1 && _my <= _btn_y2) {
        confirm_selection = 1;
        if (mouse_check_button_pressed(mb_left)) {
            scr_delete_save_slot(slot_selected);
            slot_occupied[slot_selected - 1] = false;
            slot_info[slot_selected - 1] = undefined;
            confirm_delete = false;
            notif_text = "Partida borrada con exito.";
            notif_timer = 120;
        }
    }

    if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"))) {
        confirm_selection = 0;
    }
    if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"))) {
        confirm_selection = 1;
    }
    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
        if (confirm_selection == 1) {
            scr_delete_save_slot(slot_selected);
            slot_occupied[slot_selected - 1] = false;
            slot_info[slot_selected - 1] = undefined;
            confirm_delete = false;
            notif_text = "Partida borrada con exito.";
            notif_timer = 120;
        } else {
            confirm_delete = false;
        }
    }
    if (keyboard_check_pressed(vk_escape)) {
        confirm_delete = false;
    }

    exit;
}

// === SLOT SELECTION MODE (Nueva Granja / Continuar / Hospedar / Borrar Granja) ===
if (slot_select_mode != "") {
    var _cx = display_get_gui_width() * 0.5;
    var _cy = display_get_gui_height() * 0.5;
    var _box_w = 400;
    var _box_h = 80;
    var _spacing = 12;
    var _start_y = _cy - ((3 * _box_h + 2 * _spacing) * 0.5) - 40;

    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);

    // Detect mouse hover/click on slots
    for (var _i = 0; _i < 3; _i++) {
        var _bx1 = _cx - _box_w * 0.5;
        var _by1 = _start_y + _i * (_box_h + _spacing);
        var _bx2 = _bx1 + _box_w;
        var _by2 = _by1 + _box_h;

        if (_mx >= _bx1 && _mx <= _bx2 && _my >= _by1 && _my <= _by2) {
            slot_selected = _i + 1;
            if (mouse_check_button_pressed(mb_left)) {
                var _occ = slot_occupied[_i];
                if (slot_select_mode == "delete") {
                    if (_occ) {
                        confirm_delete = true;
                        confirm_selection = 0;
                    } else {
                        notif_text = "Slot vacio, no hay partida que borrar.";
                        notif_timer = 120;
                    }
                } else if (slot_select_mode == "new") {
                    if (_occ) {
                        confirm_overwrite = true;
                        confirm_selection = 0;
                    } else {
                        // Start name entry for empty slot
                        name_entry_mode = true;
                        name_entry_field = 0;
                        farm_name_input = "";
                        player_name_input = "";
                    }
                } else if (slot_select_mode == "continue") {
                    if (_occ) {
                        audio_stop_sound(menu_music);
                        scr_set_save_slot(_i + 1);
                        var _data = scr_read_save_game();
                        if (is_struct(_data)) {
                            if (instance_exists(obj_controller)) {
                                obj_controller.pending_loaded_game = _data;
                                obj_controller.load_needs_apply = true;
                            }
                            var _room_name = variable_struct_exists(_data, "players")
                                ? _data.players[0].room_name
                                : _data.player.room_name;
                            var _target_room = asset_get_index(_room_name);
                            if (_target_room != -1) {
                                room_goto(_target_room);
                            } else {
                                room_goto(farm);
                            }
                        } else {
                            notif_text = "Error al cargar la partida.";
                            notif_timer = 120;
                        }
                    } else {
                        notif_text = "No hay partida en este slot.";
                        notif_timer = 120;
                    }
                } else if (slot_select_mode == "host") {
                    if (_occ) {
                        audio_stop_sound(menu_music);
                        scr_set_save_slot(_i + 1);
                        var _data = scr_read_save_game();
                        if (is_struct(_data) && net_host_game()) {
                            if (instance_exists(obj_controller)) {
                                obj_controller.pending_loaded_game = _data;
                                obj_controller.load_needs_apply = true;
                            }
                            var _room_name = variable_struct_exists(_data, "players")
                                ? _data.players[0].room_name
                                : _data.player.room_name;
                            var _target_room = asset_get_index(_room_name);
                            if (_target_room != -1) room_goto(_target_room);
                            else room_goto(farm);
                            notif_text = "Servidor iniciado en puerto " + string(net_read_port());
                            notif_timer = 120;
                        } else {
                            notif_text = "Error al abrir puerto " + string(net_read_port());
                            notif_timer = 120;
                        }
                    } else {
                        // Host mode: start fresh with name entry
                        name_entry_mode = true;
                        name_entry_field = 0;
                        farm_name_input = "";
                        player_name_input = "";
                    }
                }
            }
        }
    }

    // Keyboard navigation for slot selection
    if (keyboard_check_pressed(ord("1"))) { slot_selected = 1; }
    if (keyboard_check_pressed(ord("2"))) { slot_selected = 2; }
    if (keyboard_check_pressed(ord("3"))) { slot_selected = 3; }

    if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) {
        slot_selected = max(1, slot_selected - 1);
    }
    if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
        slot_selected = min(3, slot_selected + 1);
    }

    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
        if (slot_selected >= 1 && slot_selected <= 3) {
            var _idx = slot_selected - 1;
            var _occ = slot_occupied[_idx];
            if (slot_select_mode == "delete") {
                if (_occ) {
                    confirm_delete = true;
                    confirm_selection = 0;
                } else {
                    notif_text = "Slot vacio, no hay partida que borrar.";
                    notif_timer = 120;
                }
            } else if (slot_select_mode == "new") {
                if (_occ) {
                    confirm_overwrite = true;
                    confirm_selection = 0;
                } else {
                    name_entry_mode = true;
                    name_entry_field = 0;
                    farm_name_input = "";
                    player_name_input = "";
                }
            } else if (slot_select_mode == "continue") {
                if (_occ) {
                    audio_stop_sound(menu_music);
                    scr_set_save_slot(_idx + 1);
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
                        if (_target_room != -1) room_goto(_target_room);
                        else room_goto(farm);
                    } else {
                        notif_text = "Error al cargar la partida.";
                        notif_timer = 120;
                    }
                } else {
                    notif_text = "No hay partida en este slot.";
                    notif_timer = 120;
                }
            } else if (slot_select_mode == "host") {
                if (_occ) {
                    audio_stop_sound(menu_music);
                    scr_set_save_slot(_idx + 1);
                    var _data = scr_read_save_game();
                    if (is_struct(_data) && net_host_game()) {
                        if (instance_exists(obj_controller)) {
                            obj_controller.pending_loaded_game = _data;
                            obj_controller.load_needs_apply = true;
                        }
                        var _room_name = (_data.version == 2)
                            ? _data.players[0].room_name
                            : _data.player.room_name;
                        if (asset_get_index(_room_name) != -1) room_goto(_room_name);
                        else room_goto(farm);
                        notif_text = "Servidor iniciado en puerto " + string(net_read_port());
                        notif_timer = 120;
                    } else {
                        notif_text = "Error al abrir puerto " + string(net_read_port());
                        notif_timer = 120;
                    }
                } else {
                    name_entry_mode = true;
                    name_entry_field = 0;
                    farm_name_input = "";
                    player_name_input = "";
                }
            }
        }
    }

    if (keyboard_check_pressed(vk_escape)) {
        slot_select_mode = "";
        slot_selected = 0;
        confirm_overwrite = false;
        confirm_delete = false;
    }

    exit;
}

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
    }
    if (keyboard_check_pressed(vk_escape)) {
        ip_entry_mode   = false;
        keyboard_string = "";
        notif_text  = "";
        notif_timer = 0;
    }

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
            slot_select_mode = "new";
            slot_selected = 0;
            break;

        case "Hospedar":
            slot_select_mode = "host";
            slot_selected = 0;
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
            slot_select_mode = "continue";
            slot_selected = 0;
            break;

        case "Borrar Granja":
            slot_select_mode = "delete";
            slot_selected = 0;
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
