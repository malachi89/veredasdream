// --- IP entry mode (shown after "Unirse" is chosen) ---
if (ip_entry_mode) {
    // Strip non-digits and cap at 3 characters (last octet only).
    var _filtered = "";
    for (var _ci = 1; _ci <= string_length(keyboard_string); _ci++) {
        var _ch = string_char_at(keyboard_string, _ci);
        if (_ch >= "0" && _ch <= "9") _filtered += _ch;
    }
    if (string_length(_filtered) > 3) _filtered = string_copy(_filtered, 1, 3);
    keyboard_string = _filtered;
    ip_text = "192.168.100." + keyboard_string;

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
            global.net_role = NET_ROLE.NONE;
            if (instance_exists(obj_controller)) {
                obj_controller.pending_loaded_game = undefined;
                obj_controller.load_needs_apply = false;
            }
            room_goto(farm);
            break;

        case "Hospedar":
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
            keyboard_string = "";
            ip_text         = "";
            notif_text      = "";
            notif_timer     = 0;
            break;

        case "Continuar":
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
