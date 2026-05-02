var _spr = asset_get_index("sprite_tree_" + tree_type);
if (growth_stage <= 3) {
    draw_sprite(_spr, growth_stage - 1, x, y);
} else if (growth_stage == 8) {
    draw_sprite(_spr, 7, x, y);
} else {
    var _season_idx = 0;
    if (global.season == "summer") _season_idx = 1;
    else if (global.season == "fall") _season_idx = 2;
    else if (global.season == "winter") _season_idx = 3;

    var _full_h = sprite_get_height(_spr);
    var _trunk_h = 16;
    var _canopy_h = _full_h - _trunk_h;
    draw_sprite_part(_spr, 3 + _season_idx, 0, _canopy_h, sprite_get_width(_spr), _trunk_h, x, y + _canopy_h);
}



