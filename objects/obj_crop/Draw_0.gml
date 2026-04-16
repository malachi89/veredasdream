var _draw_x = x;
var _draw_y = y;
var _current_sprite_index = -1;
var _current_image_index = growth_stage;

// Determine the crop sprite name
var _intended_sprite_name = "sprite_crop_" + crop_type;
var _intended_sprite_idx = asset_get_index(_intended_sprite_name);

if (_intended_sprite_idx != -1) { 
    _current_sprite_index = _intended_sprite_idx;
} else {
    _current_sprite_index = asset_get_index("sprite_crops_icons"); // Fallback
}

// Dibujar el cultivo
if (sprite_exists(_current_sprite_index)) {
    draw_sprite(_current_sprite_index, _current_image_index, _draw_x, _draw_y);
} else {
    // Fallback drawing (red square)
    draw_rectangle_color(x, y, x+15, y+15, c_red, c_red, c_red, c_red, false); 
}
