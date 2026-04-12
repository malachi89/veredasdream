
var _target_track = music_map[$ global.season];


if (current_track != _target_track) {
    

    audio_stop_all(); 
    
    // Guardar y reproducir la nueva
    current_track = _target_track;
    
    if (audio_exists(current_track)) {
        var _music = audio_play_sound(current_track, 10, true);
        audio_sound_gain(_music, 0.6, 0); 
    }
}