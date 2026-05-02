var _music_volume = clamp(global.music_volume, 0, 1);
var _room = room_get_name(room);

var _in_main_area = (_room != "forest" && string_pos("cave_", _room) != 1);
var _season_track = music_map[$ global.season];
var _use_sequence = _in_main_area && is_array(_season_track);

var _advance_track = false;
if (_use_sequence && current_music_instance != noone) {
    if (!audio_is_playing(current_music_instance)) {
        _advance_track = true;
        current_track_index = (current_track_index + 1) % array_length(_season_track);
    }
}

var _target_track;
if (_room == "forest") {
    _target_track = sound_music_enchanted_forest;
} else if (string_pos("cave_", _room) == 1) {
    _target_track = sound_music_mines;
} else if (_use_sequence) {
    _target_track = _season_track[current_track_index];
} else {
    _target_track = _season_track;
}

if (_music_volume <= 0) {
    if (current_music_instance != noone) {
        audio_stop_sound(current_music_instance);
        current_music_instance = noone;
    }

    current_track = noone;
    exit;
}

if (current_track != _target_track || current_music_instance == noone || _advance_track) {
    if (current_music_instance != noone) {
        audio_stop_sound(current_music_instance);
    }

    current_track = _target_track;
    current_music_instance = noone;

    if (audio_exists(current_track)) {
        current_music_instance = audio_play_sound(current_track, 10, !_use_sequence);
    }
}

if (current_music_instance != noone) {
    audio_sound_gain(current_music_instance, _music_volume, 0);
}
