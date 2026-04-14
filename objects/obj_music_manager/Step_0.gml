var _music_volume = clamp(global.music_volume, 0, 1);
var _target_track = music_map[$ global.season];

if (_music_volume <= 0) {
    if (current_music_instance != noone) {
        audio_stop_sound(current_music_instance);
        current_music_instance = noone;
    }

    current_track = noone;
    exit;
}

if (current_track != _target_track || current_music_instance == noone) {
    if (current_music_instance != noone) {
        audio_stop_sound(current_music_instance);
    }

    current_track = _target_track;
    current_music_instance = noone;

    if (audio_exists(current_track)) {
        current_music_instance = audio_play_sound(current_track, 10, true);
    }
}

if (current_music_instance != noone) {
    audio_sound_gain(current_music_instance, _music_volume, 0);
}
