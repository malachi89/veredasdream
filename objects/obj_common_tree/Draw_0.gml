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



