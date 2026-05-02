if (parent_tree == noone || !instance_exists(parent_tree)) return;
if (parent_tree.growth_stage < 4 || parent_tree.growth_stage == 8) return;

var _spr = asset_get_index("sprite_tree_" + parent_tree.tree_type);
if (!sprite_exists(_spr)) return;

var _frame;
if (parent_tree.growth_stage <= 3) {
    _frame = parent_tree.growth_stage - 1;
} else if (parent_tree.growth_stage == 8) {
    _frame = 7;
} else {
    var _season_idx = 0;
    if (global.season == "summer") _season_idx = 1;
    else if (global.season == "fall") _season_idx = 2;
    else if (global.season == "winter") _season_idx = 3;
    _frame = 3 + _season_idx;
}

var _full_w = sprite_get_width(_spr);
var _full_h = sprite_get_height(_spr);
var _trunk_h = 16;
var _canopy_h = _full_h - _trunk_h;

draw_sprite_part(_spr, _frame, 0, 0, _full_w, _canopy_h, x, y);
