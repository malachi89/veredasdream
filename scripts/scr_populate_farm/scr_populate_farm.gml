function scr_daily_farm_spawn(_is_season_change = false) {
    var _tree_spawn = _is_season_change ? irandom_range(3, 5) : irandom(2);
    var _rock_spawn = _is_season_change ? irandom_range(3, 5) : irandom(2);
    if (_tree_spawn == 0 && _rock_spawn == 0) return;

    var _x1 = 48, _y1 = 96, _x2 = 1440, _y2 = 848;
    var _max_attempts = 20;
    var _tree_types = ["birch", "mahogany", "pine", "maple"];
    var _room_name = room_get_name(room);

    if (_room_name == "farm") {
        for (var i = 0; i < _tree_spawn; i++) {
            for (var attempt = 0; attempt < _max_attempts; attempt++) {
                var _px = floor(random_range(_x1, _x2 - 1) / 16) * 16;
                var _py = floor(random_range(_y1, _y2 - 1) / 16) * 16;
                if (!instance_position(_px + 8, _py + 8, obj_crop) &&
                    !instance_position(_px + 8, _py + 8, obj_common_tree) &&
                    !instance_position(_px + 8, _py + 8, obj_rock) &&
                    !instance_position(_px + 8, _py + 8, obj_tree) &&
                    !instance_position(_px + 8, _py + 8, obj_collision) &&
                    !instance_position(_px + 8, _py + 8, obj_item_parent)) {
                    var _inst = instance_create_layer(_px, _py, "Instances", obj_common_tree);
                    _inst.tree_type = _tree_types[irandom(3)];
                    _inst.growth_stage = 1;
                    break;
                }
            }
        }
        for (var i = 0; i < _rock_spawn; i++) {
            for (var attempt = 0; attempt < _max_attempts; attempt++) {
                var _px = floor(random_range(_x1, _x2 - 1) / 16) * 16;
                var _py = floor(random_range(_y1, _y2 - 1) / 16) * 16;
                if (!instance_position(_px + 8, _py + 8, obj_crop) &&
                    !instance_position(_px + 8, _py + 8, obj_common_tree) &&
                    !instance_position(_px + 8, _py + 8, obj_rock) &&
                    !instance_position(_px + 8, _py + 8, obj_tree) &&
                    !instance_position(_px + 8, _py + 8, obj_collision) &&
                    !instance_position(_px + 8, _py + 8, obj_item_parent)) {
                    instance_create_layer(_px, _py, "Instances", obj_rock);
                    break;
                }
            }
        }
    }

    var _farm_state = scr_get_room_state("farm");
    var _occupied = {};
    var _arrays = ["crops", "common_trees", "rocks"];
    for (var a = 0; a < array_length(_arrays); a++) {
        var _arr = _farm_state[$ _arrays[a]];
        if (!is_array(_arr)) continue;
        for (var i = 0; i < array_length(_arr); i++) {
            if (variable_struct_exists(_arr[i], "x") && variable_struct_exists(_arr[i], "y")) {
                _occupied[$ string(_arr[i].x) + "_" + string(_arr[i].y)] = true;
            }
        }
    }

    for (var i = 0; i < _tree_spawn; i++) {
        for (var attempt = 0; attempt < _max_attempts; attempt++) {
            var _px = floor(random_range(_x1, _x2 - 1) / 16) * 16;
            var _py = floor(random_range(_y1, _y2 - 1) / 16) * 16;
            var _key = string(_px) + "_" + string(_py);
            if (!variable_struct_exists(_occupied, _key)) {
                _occupied[$ _key] = true;
                array_push(_farm_state.common_trees, {
                    x: _px, y: _py, tree_type: _tree_types[irandom(3)],
                    growth_stage: 1, hits_remaining: 10
                });
                break;
            }
        }
    }

    for (var i = 0; i < _rock_spawn; i++) {
        for (var attempt = 0; attempt < _max_attempts; attempt++) {
            var _px = floor(random_range(_x1, _x2 - 1) / 16) * 16;
            var _py = floor(random_range(_y1, _y2 - 1) / 16) * 16;
            var _key = string(_px) + "_" + string(_py);
            if (!variable_struct_exists(_occupied, _key)) {
                _occupied[$ _key] = true;
                array_push(_farm_state.rocks, {
                    x: _px, y: _py, sprite_name: "sprite_rock1",
                    image_index: 0, hits_remaining: 10, max_hits: 10,
                    is_ore_rock: false, is_coal_rock: false, is_gemstone_rock: false,
                    ore_type_index: -1, ore_item_key: "", hit_counter: 0
                });
                break;
            }
        }
    }

    global.room_states[$ "farm"] = _farm_state;
}

function scr_remove_out_of_season_crops() {
    var _new_season = global.season_index;

    with (obj_crop) {
        var _c_info = global.crop_data[$ crop_type];
        if (_c_info != undefined) {
            var _ok = false;
            for (var i = 0; i < array_length(_c_info.seasons); i++) {
                if (_c_info.seasons[i] == SEASON.ALL || _c_info.seasons[i] == _new_season) {
                    _ok = true; break;
                }
            }
            if (!_ok) instance_destroy();
        }
    }

    var _rooms = variable_struct_get_names(global.room_states);
    for (var r = 0; r < array_length(_rooms); r++) {
        var _state = global.room_states[$ _rooms[r]];
        if (!is_array(_state.crops)) continue;
        var _kept = [];
        for (var i = 0; i < array_length(_state.crops); i++) {
            var _c = _state.crops[i];
            if (variable_struct_exists(_c, "type") && _c.type == "tree") {
                array_push(_kept, _c);
                continue;
            }
            var _ci = global.crop_data[$ _c.crop_type];
            if (_ci == undefined) { array_push(_kept, _c); continue; }
            var _ok = false;
            for (var s = 0; s < array_length(_ci.seasons); s++) {
                if (_ci.seasons[s] == SEASON.ALL || _ci.seasons[s] == _new_season) {
                    _ok = true; break;
                }
            }
            if (_ok) array_push(_kept, _c);
        }
        _state.crops = _kept;
        global.room_states[$ _rooms[r]] = _state;
    }
}

function scr_populate_farm() {
    var _tree_types    = ["birch", "mahogany", "pine", "maple"];
    var _x1            = 48;
    var _y1            = 96;
    var _x2            = 1440;
    var _y2            = 848;
    var _tree_count    = 84;
    var _rock_count    = 150;
    var _max_attempts  = 40;
    var _tree_radius   = 24; // Half-width of a tree sprite (~48px wide)
    var _rock_radius   = 8; // Half-width of a rock sprite (16px wide)
    // Each placed entry: { x, y, r } — the required clearance radius
    // Minimum distance between two objects = r_new + r_existing
    var _placed        = [];

    var _player_ref = obj_player;
    var _player_cx = instance_exists(_player_ref) ? _player_ref.x : -9999;
    var _player_cy = instance_exists(_player_ref) ? _player_ref.y : -9999;
    var _player_clearance = 48;

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
            if (_ok && point_distance(_px, _py, _player_cx, _player_cy) < (_tree_radius + _player_clearance)) {
                _ok = false;
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
            if (_ok && point_distance(_px, _py, _player_cx, _player_cy) < (_rock_radius + _player_clearance)) {
                _ok = false;
            }
            if (_ok) {
                instance_create_layer(_px, _py, "Instances", obj_rock);
                array_push(_placed, { x: _px, y: _py, r: _rock_radius });
                break;
            }
        }
    }
}
