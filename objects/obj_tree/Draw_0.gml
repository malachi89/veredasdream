var _draw_x = x;
var _draw_y = y;
var _current_sprite_index = -1;
var _current_image_index = image_index;

// Determine the tree sprite name
var _intended_sprite_name = "sprite_tree_" + crop_type;
var _intended_sprite_idx = asset_get_index(_intended_sprite_name);

if (_intended_sprite_idx != -1) { 
    _current_sprite_index = _intended_sprite_idx;
} else {
    _current_sprite_index = asset_get_index("sprite_crops_icons"); // Fallback
}

// Ensure the object uses its sprite for collisions
sprite_index = _current_sprite_index;

// Control image_index to show fruit or not
if (sprite_exists(_current_sprite_index)) {
    var _num_frames = sprite_get_number(_current_sprite_index);
    
    if (has_fruit && days_passed >= max_stages) {
        _current_image_index = _num_frames - 1; // Last frame usually has fruit
    } else {
        // Growth stages or mature without fruit
        if (days_passed < max_stages) {
            _current_image_index = clamp(floor((days_passed / max_stages) * (_num_frames - 1)), 0, _num_frames - 2);
        } else {
            _current_image_index = _num_frames - 2; // Mature frame without fruit
        }
    }
}

// Draw the tree
if (sprite_exists(_current_sprite_index)) {
    draw_sprite(_current_sprite_index, _current_image_index, _draw_x, _draw_y);
} else {
    draw_rectangle_color(x-8, y-32, x+8, y+16, c_red, c_red, c_red, c_red, false); 
}

// Draw health bar if damaged
if (hits_remaining < 10) {
    var _bar_w = 20;
    var _bar_h = 2;
    var _px = x + (sprite_width / 2) - (_bar_w / 2);
    var _py = bbox_top - 8;

    draw_set_color(c_black);
    draw_rectangle(_px - 1, _py - 1, _px + _bar_w + 1, _py + _bar_h + 1, false);

    draw_set_color(c_green);
    var _fill_w = (hits_remaining / 10) * _bar_w;
    if (_fill_w > 0) {
        draw_rectangle(_px, _py, _px + _fill_w, _py + _bar_h, false);
    }

    draw_set_color(c_white);
}
