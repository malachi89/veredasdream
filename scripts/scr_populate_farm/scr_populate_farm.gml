function scr_daily_farm_spawn(_is_season_change = false) {
    var _tree_spawn = _is_season_change ? irandom_range(3, 5) : irandom(2);
    var _rock_spawn = _is_season_change ? irandom_range(3, 5) : irandom(2);
    var _weed_spawn = _is_season_change ? irandom_range(2, 4) : irandom(2);
    if (_tree_spawn == 0 && _rock_spawn == 0 && _weed_spawn == 0) return;

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
        for (var i = 0; i < _weed_spawn; i++) {
            for (var attempt = 0; attempt < _max_attempts; attempt++) {
                var _px = floor(random_range(_x1, _x2 - 1) / 16) * 16;
                var _py = floor(random_range(_y1, _y2 - 1) / 16) * 16;
                if (!instance_position(_px + 8, _py + 8, obj_crop) &&
                    !instance_position(_px + 8, _py + 8, obj_common_tree) &&
                    !instance_position(_px + 8, _py + 8, obj_rock) &&
                    !instance_position(_px + 8, _py + 8, obj_weed) &&
                    !instance_position(_px + 8, _py + 8, obj_tree) &&
                    !instance_position(_px + 8, _py + 8, obj_collision) &&
                    !instance_position(_px + 8, _py + 8, obj_item_parent)) {
                    instance_create_layer(_px, _py, "Instances", obj_weed);
                    break;
                }
            }
        }
    }

    var _farm_state = scr_get_room_state("farm");
    var _occupied = {};
    var _arrays = ["crops", "common_trees", "rocks", "weeds"];
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

    if (!variable_struct_exists(_farm_state, "weeds")) _farm_state.weeds = [];
    for (var i = 0; i < _weed_spawn; i++) {
        for (var attempt = 0; attempt < _max_attempts; attempt++) {
            var _px = floor(random_range(_x1, _x2 - 1) / 16) * 16;
            var _py = floor(random_range(_y1, _y2 - 1) / 16) * 16;
            var _key = string(_px) + "_" + string(_py);
            if (!variable_struct_exists(_occupied, _key)) {
                _occupied[$ _key] = true;
                array_push(_farm_state.weeds, { x: _px, y: _py });
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
    
    // Randomize total counts
    var _tree_count    = irandom_range(60, 90);
    var _rock_count    = irandom_range(100, 160);
    
    var _max_attempts  = 40;
    var _tree_radius   = 24; // Half-width of a tree sprite (~48px wide)
    var _rock_radius   = 8; // Half-width of a rock sprite (16px wide)
    var _placed        = [];

    var _player_ref = obj_player;
    var _player_cx = instance_exists(_player_ref) ? _player_ref.x : -9999;
    var _player_cy = instance_exists(_player_ref) ? _player_ref.y : -9999;
    var _player_clearance = 64; // Increased clearance for new farm

    // Helper function for collision check
    var _check_ok = function(_px, _py, _radius, _placed_list, _pcx, _pcy, _pclearance) {
        // Player clearance
        if (point_distance(_px, _py, _pcx, _pcy) < (_radius + _pclearance)) return false;
        
        // Boundaries
        if (_px < 48 || _px > 1440 - 16 || _py < 96 || _py > 848 - 16) return false;

        // Overlap with other placed objects
        for (var j = 0; j < array_length(_placed_list); j++) {
            if (point_distance(_px, _py, _placed_list[j].x, _placed_list[j].y) < (_radius + _placed_list[j].r)) {
                return false;
            }
        }
        
        // Static collisions
        if (instance_position(_px + 8, _py + 8, obj_collision)) return false;
        
        return true;
    };

    // --- Spawn trees in clusters ---
    var _trees_to_spawn = _tree_count;
    var _t_attempts = 100;
    while (_trees_to_spawn > 0 && _t_attempts > 0) {
        // Pick a cluster seed
        var _sx = floor(random_range(_x1, _x2 - 1) / 16) * 16;
        var _sy = floor(random_range(_y1, _y2 - 1) / 16) * 16;
        
        if (_check_ok(_sx, _sy, _tree_radius, _placed, _player_cx, _player_cy, _player_clearance)) {
            var _cluster_size = irandom_range(1, 4);
            for (var c = 0; c < _cluster_size && _trees_to_spawn > 0; c++) {
                var _tx, _ty;
                if (c == 0) {
                    _tx = _sx; _ty = _sy;
                } else {
                    // Try to place near the seed
                    var _angle = random(360);
                    var _dist = random_range(32, 64);
                    _tx = floor((_sx + lengthdir_x(_dist, _angle)) / 16) * 16;
                    _ty = floor((_sy + lengthdir_y(_dist, _angle)) / 16) * 16;
                }
                
                if (_check_ok(_tx, _ty, _tree_radius, _placed, _player_cx, _player_cy, _player_clearance)) {
                    var _inst = instance_create_layer(_tx, _ty, "Instances", obj_common_tree);
                    _inst.tree_type    = _tree_types[irandom(3)];
                    _inst.growth_stage = (random(1) < 0.7) ? 4 : irandom_range(1, 3);
                    array_push(_placed, { x: _tx, y: _ty, r: _tree_radius });
                    _trees_to_spawn--;
                }
            }
        }
        _t_attempts--;
    }

    // --- Spawn rocks in clusters ---
    var _rocks_to_spawn = _rock_count;
    var _r_attempts = 150;
    while (_rocks_to_spawn > 0 && _r_attempts > 0) {
        var _sx = floor(random_range(_x1, _x2 - 1) / 16) * 16;
        var _sy = floor(random_range(_y1, _y2 - 1) / 16) * 16;
        
        if (_check_ok(_sx, _sy, _rock_radius, _placed, _player_cx, _player_cy, _player_clearance)) {
            var _cluster_size = irandom_range(1, 6);
            for (var c = 0; c < _cluster_size && _rocks_to_spawn > 0; c++) {
                var _rx, _ry;
                if (c == 0) {
                    _rx = _sx; _ry = _sy;
                } else {
                    var _angle = random(360);
                    var _dist = random_range(16, 32);
                    _rx = floor((_sx + lengthdir_x(_dist, _angle)) / 16) * 16;
                    _ry = floor((_sy + lengthdir_y(_dist, _angle)) / 16) * 16;
                }
                
                if (_check_ok(_rx, _ry, _rock_radius, _placed, _player_cx, _player_cy, _player_clearance)) {
                    instance_create_layer(_rx, _ry, "Instances", obj_rock);
                    array_push(_placed, { x: _rx, y: _ry, r: _rock_radius });
                    _rocks_to_spawn--;
                }
            }
        }
        _r_attempts--;
    }

    // --- Spawn weeds scattered ---
    var _weeds_to_spawn = irandom_range(20, 40);
    var _weed_radius   = 8;
    var _w_attempts    = 80;
    while (_weeds_to_spawn > 0 && _w_attempts > 0) {
        var _sx = floor(random_range(_x1, _x2 - 1) / 16) * 16;
        var _sy = floor(random_range(_y1, _y2 - 1) / 16) * 16;

        if (_check_ok(_sx, _sy, _weed_radius, _placed, _player_cx, _player_cy, _player_clearance)) {
            var _cluster_size = irandom_range(1, 4);
            for (var c = 0; c < _cluster_size && _weeds_to_spawn > 0; c++) {
                var _wx, _wy;
                if (c == 0) {
                    _wx = _sx; _wy = _sy;
                } else {
                    var _angle = random(360);
                    var _dist = random_range(16, 32);
                    _wx = floor((_sx + lengthdir_x(_dist, _angle)) / 16) * 16;
                    _wy = floor((_sy + lengthdir_y(_dist, _angle)) / 16) * 16;
                }

                if (_check_ok(_wx, _wy, _weed_radius, _placed, _player_cx, _player_cy, _player_clearance)) {
                    instance_create_layer(_wx, _wy, "Instances", obj_weed);
                    array_push(_placed, { x: _wx, y: _wy, r: _weed_radius });
                    _weeds_to_spawn--;
                }
            }
        }
        _w_attempts--;
    }
}
