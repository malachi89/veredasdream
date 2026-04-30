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

    // --- Insects ---
    with (obj_insect) instance_destroy();
    global.forest_insects = [];

    var _ins_spawn_count = irandom_range(5, 10);
    var _ikeys      = variable_struct_get_names(global.insect_data);
    var _ipool      = [];
    var _iweights   = [];
    var _itotal     = 0;
    var _irare_pool = [];
    for (var i = 0; i < array_length(_ikeys); i++) {
        var _entry   = global.insect_data[$ _ikeys[i]];
        var _weight  = 51 - _entry.rarity;
        array_push(_ipool,    _ikeys[i]);
        array_push(_iweights, _weight);
        _itotal += _weight;
        if (_entry.rarity <= 1) array_push(_irare_pool, _ikeys[i]);
    }

    var _iplaced       = [];
    var _ispawned_rare = false;

    for (var i = 0; i < _ins_spawn_count; i++) {
        var _roll   = random(_itotal);
        var _cursor = 0;
        var _chosen = _ipool[0];
        for (var k = 0; k < array_length(_ipool); k++) {
            _cursor += _iweights[k];
            if (_roll < _cursor) { _chosen = _ipool[k]; break; }
        }
        if (global.insect_data[$ _chosen].rarity <= 1) _ispawned_rare = true;

        for (var attempt = 0; attempt < _max_attempts; attempt++) {
            var _px = floor(random_range(_x1, _x2 - 1) / 16) * 16;
            var _py = floor(random_range(_y1, _y2 - 1) / 16) * 16;
            var _ok = true;
            for (var j = 0; j < array_length(_iplaced); j++) {
                if (point_distance(_px, _py, _iplaced[j].x, _iplaced[j].y) < _min_dist) { _ok = false; break; }
            }
            if (!_ok) continue;
            if (instance_position(_px + 8, _py + 8, obj_collision)) continue;
            var _inst        = instance_create_layer(_px, _py, "Instances", obj_insect);
            _inst.insect_key = _chosen;
            _inst.sprite_index = global.insect_data[$ _chosen].sprite;
            array_push(_iplaced, { x: _px, y: _py });
            array_push(global.forest_insects, { key: _chosen, x: _px, y: _py });
            break;
        }
    }

    global.forest_days_since_rare_insect += 1;
    if (_ispawned_rare) {
        global.forest_days_since_rare_insect = 0;
    } else if (global.forest_days_since_rare_insect >= 3) {
        global.forest_days_since_rare_insect = 0;
        var _chosen = _irare_pool[irandom(array_length(_irare_pool) - 1)];
        for (var attempt = 0; attempt < _max_attempts; attempt++) {
            var _px = floor(random_range(_x1, _x2 - 1) / 16) * 16;
            var _py = floor(random_range(_y1, _y2 - 1) / 16) * 16;
            if (instance_position(_px + 8, _py + 8, obj_collision)) continue;
            var _inst        = instance_create_layer(_px, _py, "Instances", obj_insect);
            _inst.insect_key = _chosen;
            _inst.sprite_index = global.insect_data[$ _chosen].sprite;
            array_push(global.forest_insects, { key: _chosen, x: _px, y: _py });
            break;
        }
    }

    // --- Wild Animals ---
    with (obj_wild_animal) instance_destroy();
    global.forest_wild_animals = [];

    var _wild_keys  = variable_struct_get_names(global.wild_animal_data);
    var _is_saturday = ((global.day - 1) mod 7) == 5;
    if (!_is_saturday) {
        _wild_keys = array_filter(_wild_keys, function(_k) { return _k != "bear"; });
    }
    var _wild_count = irandom_range(10, 15);
    var _wplaced    = [];

    for (var i = 0; i < _wild_count; i++) {
        var _key  = _wild_keys[irandom(array_length(_wild_keys) - 1)];
        var _data = global.wild_animal_data[$ _key];
        for (var attempt = 0; attempt < _max_attempts; attempt++) {
            var _px = floor(random_range(_x1, _x2 - 1) / 16) * 16;
            var _py = floor(random_range(_y1, _y2 - 1) / 16) * 16;
            var _ok = true;
            for (var j = 0; j < array_length(_wplaced); j++) {
                if (point_distance(_px, _py, _wplaced[j].x, _wplaced[j].y) < _min_dist) { _ok = false; break; }
            }
            if (!_ok) continue;
            if (instance_position(_px + 8, _py + 8, obj_collision)) continue;
            var _inst            = instance_create_layer(_px, _py, "Instances", obj_wild_animal);
            _inst.animal_key     = _key;
            _inst.is_farm_animal = false;
            _inst.sprite_index   = _data.sprite;
            _inst.move_speed     = _data.move_speed;
            _inst.hp             = _data.hp;
            _inst.max_hp         = _data.max_hp;
            array_push(_wplaced, { x: _px, y: _py });
            array_push(global.forest_wild_animals, { key: _key, x: _px, y: _py, sprite: _data.sprite, move_speed: _data.move_speed, hp: _data.hp, max_hp: _data.max_hp });
            break;
        }
    }

    // --- Farm Animals in Forest (1-3 per day) ---
    var _farm_keys        = variable_struct_get_names(global.animal_data);
    var _farm_spawn_count = irandom_range(1, 3);

    for (var i = 0; i < _farm_spawn_count; i++) {
        var _farm_key = _farm_keys[irandom(array_length(_farm_keys) - 1)];
        var _fdata    = global.animal_data[$ _farm_key];
        var _variant  = _fdata.variants[irandom(array_length(_fdata.variants) - 1)];
        var _fspr     = asset_get_index("sprite_" + _farm_key + "_" + _variant);
        if (_fspr == -1) _fspr = sprite_chicken_white;
        for (var attempt = 0; attempt < _max_attempts; attempt++) {
            var _px = floor(random_range(_x1, _x2 - 1) / 16) * 16;
            var _py = floor(random_range(_y1, _y2 - 1) / 16) * 16;
            if (instance_position(_px + 8, _py + 8, obj_collision)) continue;
            var _inst            = instance_create_layer(_px, _py, "Instances", obj_wild_animal);
            _inst.animal_key     = _farm_key;
            _inst.is_farm_animal = true;
            _inst.sprite_index   = _fspr;
            _inst.move_speed     = _fdata.move_speed;
            _inst.hp             = _fdata.hp;
            _inst.max_hp         = _fdata.max_hp;
            array_push(global.forest_wild_animals, { key: _farm_key, x: _px, y: _py, sprite: _fspr, move_speed: _fdata.move_speed, hp: _fdata.hp, max_hp: _fdata.max_hp });
            break;
        }
    }

    // --- Lumber area: daily tree replenishment ---
    var _lx1          = 2970;
    var _ly1          = 778;
    var _lx2          = 3876;
    var _ly2          = 1313;
    var _lumber_max   = 20;
    var _lumber_daily = 4;
    var _tree_radius  = 24;
    var _tree_types   = ["birch", "mahogany", "pine", "maple"];

    var _existing_count = 0;
    var _lumber_placed  = [];
    with (obj_common_tree) {
        if (x >= _lx1 && x <= _lx2 && y >= _ly1 && y <= _ly2) {
            _existing_count += 1;
            array_push(_lumber_placed, { x: x, y: y, r: _tree_radius });
        }
    }

    var _is_first_time = (_existing_count == 0);
    var _spawn_limit   = _is_first_time ? 12 : _lumber_daily;
    var _to_spawn      = min(_spawn_limit, _lumber_max - _existing_count);

    for (var i = 0; i < _to_spawn; i++) {
        for (var attempt = 0; attempt < 40; attempt++) {
            var _px = floor(random_range(_lx1, _lx2 - 1) / 16) * 16;
            var _py = floor(random_range(_ly1, _ly2 - 1) / 16) * 16;
            var _ok = true;
            for (var j = 0; j < array_length(_lumber_placed); j++) {
                if (point_distance(_px, _py, _lumber_placed[j].x, _lumber_placed[j].y) < (_tree_radius + _lumber_placed[j].r)) {
                    _ok = false;
                    break;
                }
            }
            if (!_ok) continue;
            if (instance_position(_px + 8, _py + 8, obj_collision)) continue;

            var _inst = instance_create_layer(_px, _py, "Instances", obj_common_tree);
            _inst.tree_type    = _tree_types[irandom(3)];
            _inst.growth_stage = _is_first_time ? ((random(1) < 0.7) ? 4 : irandom_range(1, 3)) : 1;
            array_push(_lumber_placed, { x: _px, y: _py, r: _tree_radius });
            break;
        }
    }
}

