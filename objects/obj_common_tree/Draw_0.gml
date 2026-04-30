/// Draw Event
var _spr = asset_get_index("sprite_tree_" + tree_type);
if (growth_stage <= 3) {
    draw_sprite(_spr, growth_stage - 1, x, y);
} else if (growth_stage == 8) {
    draw_sprite(_spr, 7, x, y);
} else {
    // Frames 4, 5, 6, 7 are seasonal
    var _season_idx = 0;
    if (global.season == "summer") _season_idx = 1;
    else if (global.season == "fall") _season_idx = 2;
    else if (global.season == "winter") _season_idx = 3;
    draw_sprite(_spr, 3 + _season_idx, x, y);
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

