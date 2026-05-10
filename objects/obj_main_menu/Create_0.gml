menu_music = audio_play_sound(sound_main_menu_theme, 10, true);

notif_text  = "";
notif_timer = 0;

// IP entry state (shown when "Unirse" is selected)
ip_entry_mode = false;
ip_text       = "";
connect_waiting = false; // true while waiting for HANDSHAKE_ACK + snapshot

// Options menu state
options_menu_open = false;
options_selection = 0;
settings_items = [
    { label: "Volumen Musica", section: "Audio", key: "MusicVolume", values: [0.0, 0.25, 0.5, 0.75, 1.0], display: ["0%", "25%", "50%", "75%", "100%"] },
    { label: "Velocidad Tiempo", section: "Time", key: "TimeSpeedMultiplier", values: [0.25, 0.5, 1.0, 1.5, 2.0, 3.0], display: ["0.25x", "0.5x", "1.0x", "1.5x", "2.0x", "3.0x"] },
    { label: "Dias por Estacion", section: "Time", key: "DaysPerSeason", values: [7, 14, 28, 56], display: ["7", "14", "28", "56"] },
    { label: "Puerto Red", section: "Network", key: "Port", values: [7777], display: ["7777"] },
];
// Initialize current value indices from global state
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

// --- Save slot system ---
slot_select_mode = "";    // "", "new", "continue", "host", "delete"
slot_selected = 0;        // 0 = none, 1-3
slot_occupied = [false, false, false];
slot_info = [undefined, undefined, undefined];
// Populate slot info from save files
for (var _s = 0; _s < 3; _s++) {
    slot_occupied[_s] = scr_slot_is_occupied(_s + 1);
    if (slot_occupied[_s]) {
        slot_info[_s] = scr_slot_read_info(_s + 1);
    }
}

// Build menu options — "Continuar" first if any save exists
var _any_save = false;
for (var _s = 0; _s < 3; _s++) {
    if (slot_occupied[_s]) { _any_save = true; break; }
}
if (_any_save) {
    options = ["Continuar", "Nueva Granja", "Hospedar", "Unirse", "Opciones", "Borrar Granja", "Salir"];
} else {
    options = ["Nueva Granja", "Hospedar", "Unirse", "Opciones", "Borrar Granja", "Salir"];
}
selected_index = 0;

// Name entry state
name_entry_mode = false;
name_entry_field = 0; // 0 = farm name, 1 = player name
farm_name_input = "";
player_name_input = "";

// Confirmation dialogs
confirm_overwrite = false;
confirm_delete = false;
confirm_selection = 0; // 0 = No, 1 = Si
