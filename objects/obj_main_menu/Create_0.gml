menu_music = audio_play_sound(sound_main_menu_theme, 10, true);

save_exists = file_exists(global.save_file_path);

if (save_exists) {
    options = ["Continuar", "Nueva Granja", "Hospedar", "Unirse", "Opciones", "Borrar Granja", "Salir"];
} else {
    options = ["Nueva Granja", "Hospedar", "Unirse", "Opciones", "Borrar Granja", "Salir"];
}
selected_index = 0;

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
