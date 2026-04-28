function scr_populate_farm() {
    var _tree_types    = ["birch", "mahogany", "pine", "maple"];
    var _x1            = 60;
    var _y1            = 200;
    var _x2            = 1900;
    var _y2            = 1900;
    var _tree_count    = 250;
    var _rock_count    = 450;
    var _max_attempts  = 40;
    var _tree_radius   = 24; // Half-width of a tree sprite (~48px wide)
    var _rock_radius   = 12; // Half-width of a rock sprite (~24px wide)
    // Each placed entry: { x, y, r } — the required clearance radius
    // Minimum distance between two objects = r_new + r_existing
    var _placed        = [];

    // --- Spawn trees ---
    for (var i = 0; i < _tree_count; i++) {
        for (var attempt = 0; attempt < _max_attempts; attempt++) {
            var _px = floor(random_range(_x1, _x2 - 1) / 16) * 16;
            var _py = floor(random_range(_y1, _y2 - 1) / 16) * 16;
            var _ok = true;
            for (var j = 0; j < array_length(_placed); j++) {
                if (point_distance(_px, _py, _placed[j].x, _placed[j].y) < (_tree_radius + _placed[j].r)) {
                    _ok = false;
                    break;
                }
            }
            if (_ok) {
                var _inst = instance_create_layer(_px, _py, "Instances", obj_common_tree);
                _inst.tree_type    = _tree_types[irandom(3)];
                // 70% chance of spawning fully grown, 30% at an early stage (1–3)
                _inst.growth_stage = (random(1) < 0.7) ? 4 : irandom_range(1, 3);
                array_push(_placed, { x: _px, y: _py, r: _tree_radius });
                break;
            }
        }
    }

    // --- Spawn rocks ---
    for (var i = 0; i < _rock_count; i++) {
        for (var attempt = 0; attempt < _max_attempts; attempt++) {
            var _px = floor(random_range(_x1, _x2 - 1) / 16) * 16;
            var _py = floor(random_range(_y1, _y2 - 1) / 16) * 16;
            var _ok = true;
            for (var j = 0; j < array_length(_placed); j++) {
                if (point_distance(_px, _py, _placed[j].x, _placed[j].y) < (_rock_radius + _placed[j].r)) {
                    _ok = false;
                    break;
                }
            }
            if (_ok) {
                instance_create_layer(_px, _py, "Instances", obj_rock);
                array_push(_placed, { x: _px, y: _py, r: _rock_radius });
                break;
            }
        }
    }

    if (global.debug_test_animals) {
        scr_populate_test_animals();
    }
}
