function scr_populate_forest() {
    var _room_name = "forest";
    var _x1 = 100;
    var _y1 = 100;
    var _x2 = 4900;
    var _y2 = 4900;
    var _spawn_count  = irandom_range(8, 15); // Daily item count: change range to adjust density
    var _max_attempts = 30;
    var _min_dist     = 24; // Minimum px between items: raise to spread out, lower to allow clusters

    // Clear previous day's forage drops from persistent storage
    if (variable_struct_exists(global.room_drops, _room_name)) {
        var _drops = global.room_drops[$ _room_name];
        var _kept  = [];
        for (var i = 0; i < array_length(_drops); i++) {
            if (!string_starts_with(_drops[i].item_key, "forage_")) {
                array_push(_kept, _drops[i]);
            }
        }
        global.room_drops[$ _room_name] = _kept;
    }

    // Destroy any live forage instances (room was just restored before this runs)
    with (obj_item_parent) {
        if (string_starts_with(item_key, "forage_")) instance_destroy();
    }

    // Build weighted pool: weight = (6 - rarity)
    var _keys      = variable_struct_get_names(global.forage_data);
    var _pool      = [];
    var _weights   = [];
    var _total     = 0;
    var _rare_pool = []; // rarity 4-5 keys for guaranteed spawn
    for (var i = 0; i < array_length(_keys); i++) {
        var _entry  = global.forage_data[$ _keys[i]];
        var _weight = 6 - _entry.rarity;
        array_push(_pool,    _keys[i]);
        array_push(_weights, _weight);
        _total += _weight;
        if (_entry.rarity >= 4) array_push(_rare_pool, _keys[i]);
    }

    // Track placed positions for minimum-distance check
    var _placed       = [];
    var _spawned_rare = false;

    for (var i = 0; i < _spawn_count; i++) {
        // Weighted random pick
        var _roll   = random(_total);
        var _cursor = 0;
        var _chosen = _pool[0];
        for (var k = 0; k < array_length(_pool); k++) {
            _cursor += _weights[k];
            if (_roll < _cursor) {
                _chosen = _pool[k];
                break;
            }
        }

        if (global.forage_data[$ _chosen].rarity >= 4) _spawned_rare = true;

        // Attempt placement
        for (var attempt = 0; attempt < _max_attempts; attempt++) {
            var _px = floor(random_range(_x1, _x2 - 1) / 16) * 16;
            var _py = floor(random_range(_y1, _y2 - 1) / 16) * 16;

            var _ok = true;
            for (var j = 0; j < array_length(_placed); j++) {
                if (point_distance(_px, _py, _placed[j].x, _placed[j].y) < _min_dist) {
                    _ok = false;
                    break;
                }
            }
            if (!_ok) continue;

            if (instance_position(_px + 8, _py + 8, obj_collision)) continue;
            if (instance_position(_px + 8, _py + 8, obj_item_parent)) continue;

            var _inst = instance_create_layer(_px, _py, "Instances", obj_item_parent);
            _inst.item_key = _chosen;
            _inst.collect_delay = 0;
            scr_register_room_drop(_inst, _room_name);
            array_push(_placed, { x: _px, y: _py });
            break;
        }
    }

    // Guarantee at least 1 rare item every 3 days
    global.forest_days_since_rare += 1;
    if (_spawned_rare) {
        global.forest_days_since_rare = 0;
    } else if (global.forest_days_since_rare >= 3) {
        global.forest_days_since_rare = 0;
        var _chosen = _rare_pool[irandom(array_length(_rare_pool) - 1)];
        for (var attempt = 0; attempt < _max_attempts; attempt++) {
            var _px = floor(random_range(_x1, _x2 - 1) / 16) * 16;
            var _py = floor(random_range(_y1, _y2 - 1) / 16) * 16;
            if (instance_position(_px + 8, _py + 8, obj_collision)) continue;
            if (instance_position(_px + 8, _py + 8, obj_item_parent)) continue;
            var _inst = instance_create_layer(_px, _py, "Instances", obj_item_parent);
            _inst.item_key = _chosen;
            _inst.collect_delay = 0;
            scr_register_room_drop(_inst, _room_name);
            break;
        }
    }
}
