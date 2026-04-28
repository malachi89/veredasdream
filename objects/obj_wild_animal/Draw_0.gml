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

