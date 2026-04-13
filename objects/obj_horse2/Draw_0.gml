var _sprite = sprite_idle;
var _saddle = saddle_idle;
var _subimg = 0;
var _xscale = 1;

switch (state) {
    case HORSE_STATE.PACING:
        _sprite = sprite_walk;
        _saddle = saddle_walk;
        switch (dir) {
            case HORSE_DIR.DOWN:  _subimg = 0 + floor(frame_anim); break; // Frames 0-5
            case HORSE_DIR.UP:    _subimg = 6 + floor(frame_anim); break; // Frames 6-11
            case HORSE_DIR.RIGHT: _subimg = 12 + floor(frame_anim); break; // Frames 12-17
            case HORSE_DIR.LEFT: 
                _subimg = 12 + floor(frame_anim); 
                _xscale = -1; 
            break;
        }
    break;

    case HORSE_STATE.PREPARING_TO_EAT:
    case HORSE_STATE.EATING:
        _sprite = (state == HORSE_STATE.PREPARING_TO_EAT) ? sprite_prepare : sprite_eating;
        _saddle = (state == HORSE_STATE.PREPARING_TO_EAT) ? saddle_prepare : saddle_eating;
        
        // Eating sprites: 0-3 Right, 4-7 Down
        if (dir == HORSE_DIR.DOWN) {
            _subimg = 4 + floor(frame_anim);
        } else if (dir == HORSE_DIR.RIGHT) {
            _subimg = 0 + floor(frame_anim);
        } else if (dir == HORSE_DIR.LEFT) {
            _subimg = 0 + floor(frame_anim);
            _xscale = -1;
        } else { // UP direction for eating is not defined, default to idle
            _sprite = sprite_idle;
            _saddle = saddle_idle;
            _subimg = 0; // Default to first idle frame
        }
    break;

    default: // IDLE
        _sprite = sprite_idle;
        _saddle = saddle_idle;
        switch (dir) {
            case HORSE_DIR.UP:    _subimg = 0 + floor(frame_anim); break; // Frames 0-1
            case HORSE_DIR.DOWN:  _subimg = 2 + floor(frame_anim); break; // Frames 2-3
            case HORSE_DIR.RIGHT: _subimg = 4 + floor(frame_anim); break; // Frames 4-5
            case HORSE_DIR.LEFT: 
                _subimg = 4 + floor(frame_anim); 
                _xscale = -1; 
            break;
        }
    break;
}

// Dibujar Caballo
draw_sprite_ext(_sprite, _subimg, x, y, _xscale, 1, 0, c_white, 1);
// Dibujar Montura (encima)
draw_sprite_ext(_saddle, _subimg, x, y, _xscale, 1, 0, c_white, 1);