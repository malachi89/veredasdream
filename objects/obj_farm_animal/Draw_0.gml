var _offset = 0;
var _frame  = floor(frame_anim) mod 4;

switch (state) {
    case ANIMAL_STATE.WANDERING:
    case ANIMAL_STATE.FLEEING:
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

var _blend = (hurt_flash_timer > 0) ? c_red : c_white;

// Draw shadow
draw_sprite_ext(sprite_anim, _offset + _frame, x + 1.2, y + 1, 1, 1, 0, c_black, 0.4);

draw_sprite_ext(sprite_anim, _offset + _frame, x, y, 1, 1, 0, _blend, 1);

// Draw health bar if damaged
if (hp < max_hp) {
    var _bar_w = 20;
    var _bar_h = 2;
    var _px = x + (sprite_width / 2) - (_bar_w / 2);
    var _py = bbox_top - 8;
    
    // Background
    draw_set_color(c_black);
    draw_rectangle(_px - 1, _py - 1, _px + _bar_w + 1, _py + _bar_h + 1, false);
    
    // Health (Red background)
    draw_set_color(c_red);
    draw_rectangle(_px, _py, _px + _bar_w, _py + _bar_h, false);
    
    // Health (Green fill)
    draw_set_color(c_lime);
    var _fill_w = (hp / max_hp) * _bar_w;
    if (_fill_w > 0) {
        draw_rectangle(_px, _py, _px + _fill_w, _py + _bar_h, false);
    }
    
    draw_set_color(c_white); // Reset color
}
