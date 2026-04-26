var _blend = (hurt_flash_timer > 0) ? c_red : c_white;

if (is_farm_animal) {
    // Farm animals use 4 frames per direction for walking, and have idle offsets
    var _offset = 0;
    var _frame  = floor(frame_anim) mod 4;
    
    if (state == ANIMAL_STATE.WANDERING || state == ANIMAL_STATE.FLEEING) {
        switch (dir) {
            case DIR.LEFT:  _offset = 0;  break;
            case DIR.RIGHT: _offset = 4;  break;
            case DIR.DOWN:  _offset = 8;  break;
            case DIR.UP:    _offset = 12; break;
        }
    } else {
        _offset = 16; // Default idle
    }
    draw_sprite_ext(sprite_index, _offset + _frame, x, y, 1, 1, 0, _blend, 1);
} else {
    // Forest animals use 4-block mapping: LEFT, RIGHT, DOWN, UP
    var _frame_count = sprite_get_number(sprite_index);
    var _frames_per_dir = _frame_count / 4;
    var _dir_map = [2, 3, 1, 0]; // Mapping DIR enum (DOWN=0, UP=1, RIGHT=2, LEFT=3) to blocks (LEFT=0, RIGHT=1, DOWN=2, UP=3)
    var _dir_index = _dir_map[dir];

    var _frame = floor(frame_anim % _frames_per_dir) + (_dir_index * _frames_per_dir);
    draw_sprite_ext(sprite_index, _frame, x, y, 1, 1, 0, _blend, 1);
}
