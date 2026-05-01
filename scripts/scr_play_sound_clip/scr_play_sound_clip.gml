function scr_play_sound_clip(_sound, _start, _end) {
    if (_start >= _end) return -1;
    var _id = audio_play_sound(_sound, 1, false);
    if (_id == -1) return -1;
    audio_sound_set_track_position(_id, _start);
    var _frames = ceil((_end - _start) * room_speed);
    array_push(global.sound_clips, { id: _id, timer: _frames });
    return _id;
}
