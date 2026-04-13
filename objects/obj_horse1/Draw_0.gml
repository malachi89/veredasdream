var _sprite = sprite_idle;
var _saddle = saddle_idle;
var _subimg = 0;
var _xscale = 1;

switch (state) {
    case HORSE_STATE.PACING:
        _sprite = sprite_walk;
        _saddle = saddle_walk;
        switch (dir) {
            case HORSE_DIR.DOWN:  _subimg = 0 + floor(frame_anim); break;
            case HORSE_DIR.UP:    _subimg = 6 + floor(frame_anim); break;
            case HORSE_DIR.RIGHT: _subimg = 12 + floor(frame_anim); break;
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
        
        if (dir == HORSE_DIR.DOWN) {
            _subimg = 4 + floor(frame_anim);
        } else if (dir == HORSE_DIR.RIGHT) {
            _subimg = 0 + floor(frame_anim);
        } else if (dir == HORSE_DIR.LEFT) {
            _subimg = 0 + floor(frame_anim);
            _xscale = -1;
        } else {
            _sprite = sprite_idle;
            _saddle = saddle_idle;
            _subimg = 0;
        }
    break;

    default: // IDLE
        _sprite = sprite_idle;
        _saddle = saddle_idle;
        switch (dir) {
            case HORSE_DIR.UP:    _subimg = 0 + floor(frame_anim); break;
            case HORSE_DIR.DOWN:  _subimg = 2 + floor(frame_anim); break;
            case HORSE_DIR.RIGHT: _subimg = 4 + floor(frame_anim); break;
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