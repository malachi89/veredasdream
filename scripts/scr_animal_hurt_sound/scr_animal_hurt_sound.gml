function scr_animal_hurt_sound() {
    var _ranges = [[0.00, 0.40], [0.75, 1.10], [1.70, 2.10], [2.70, 4.18]];
    var _r = _ranges[irandom(3)];
    scr_play_sound_clip(sound_animals, _r[0], _r[1]);
}
