var _offset = 0;
var _frame  = floor(frame_anim) mod 4;

switch (state) {
    case ANIMAL_STATE.WANDERING:
        switch (dir) {
            case DIR.LEFT:  _offset = 0;  break;
            case DIR.RIGHT: _offset = 4;  break;
            case DIR.DOWN:  _offset = 8;  break;
            case DIR.UP:    _offset = 12; break;
        }
    break;
    default: // IDLE
        switch (idle_type) {
            case 0: _offset = 16; break;
            case 1: _offset = 20; break;
            case 2: _offset = 24; break;
            case 3: _offset = 28; break;
            case 4: _offset = 32; break;
        }
    break;
}

draw_sprite_ext(sprite_anim, _offset + _frame, x, y, 1, 1, 0, c_white, 1);
