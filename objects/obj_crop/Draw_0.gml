var _draw_x = x;
var _draw_y = y;
var _current_sprite_index = sprite_index;
var _current_image_index = image_index;

if (is_fruit_tree) {
    var _tree_data = global.crop_data[$ crop_type]; // Get tree data
    
    // Determine current season's sprite for the tree
    var _tree_sprite_name_base = "sprite_" + crop_type; // e.g., sprite_orange_tree
    var _tree_sprite_name_seasonal = _tree_sprite_name_base + "_" + global.season; // e.g., sprite_orange_tree_summer

    if (asset_exists(asset_get_index(_tree_sprite_name_seasonal))) {
        _current_sprite_index = asset_get_index(_tree_sprite_name_seasonal);
    } else if (asset_exists(asset_get_index(_tree_sprite_name_base))) {
        _current_sprite_index = asset_get_index(_tree_sprite_name_base); // Fallback to base sprite if seasonal not found
    }
    // else: use current sprite_index (from the seed) if nothing is found, which shouldn't happen.

    // Adjust drawing position for 32x48 sprite
    // Assuming the origin of the 32x48 sprite is at (16, 40) to center it on the bottom-middle tile of the 2x3 area.
    // Or if the origin is (0,0) and we want the base of the tree at y, and x to be the center.
    // For simplicity, if x, y is the top-left corner of the 2x3 area (32x48):
    _draw_x = x;
    _draw_y = y - (_tree_data.sprite_height - 16); // So that the base is at y, and it occupies 48px upwards
    
    // Control image_index to show fruit or not
    if (has_fruit && days_passed >= max_stages) {
        _current_image_index = sprite_get_number(_current_sprite_index) - 1; // Last frame for fruit
    } else {
        // Growth animation or mature state without fruit
        if (days_passed < max_stages) {
            _current_image_index = floor((days_passed / max_stages) * (sprite_get_number(_current_sprite_index) - 1));
        } else {
            _current_image_index = sprite_get_number(_current_sprite_index) - 2; // Second to last frame for mature without fruit
        }
    }
} else {
    // Existing drawing logic for regular crops
    // Aseguramos que el frame visual sea el de la etapa actual
    _current_image_index = growth_stage;
}

// Dibujar el sprite
draw_sprite(_current_sprite_index, _current_image_index, _draw_x, _draw_y);