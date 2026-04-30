function scr_populate_cave(_ore_type = -1, _floor = 1) {
    with (obj_rock) instance_destroy();
    with (obj_ladder_down) instance_destroy();

    var _margin   = 32;
    var _spawn_safe_radius = 192;
    var _num_form = irandom_range(160, 300);
    var _dirs     = [[16, 0], [-16, 0], [0, 16], [0, -16]];

    var _layer_walls = layer_get_id("Tiles_walls");
    var _map_walls = (_layer_walls != -1) ? layer_tilemap_get_id(_layer_walls) : -1;

    var _spawn_point = instance_find(obj_ladder_exit, 0);
    var _spawn_x = (_spawn_point != noone) ? _spawn_point.x : -1;
    var _spawn_y = (_spawn_point != noone) ? _spawn_point.y : -1;

    var _ore_pct = (_ore_type >= 0) ? (5 + _floor * 3) : 0;
    var _coal_pct = (_ore_type >= 0) ? 4 : 0;
    var _gem_pct = (_ore_type >= 0) ? 1 : 0;

    for (var _f = 0; _f < _num_form; _f++) {
        var _placed  = [];
        var _found   = false;

        repeat (100) {
            var _gx = _margin + (irandom((room_width  - 2 * _margin) div 16 - 1)) * 16;
            var _gy = _margin + (irandom((room_height - 2 * _margin) div 16 - 1)) * 16;
            var _has_wall = (_map_walls != -1) && (tilemap_get_at_pixel(_map_walls, _gx + 8, _gy + 8) != 0);
            var _near_spawn = (_spawn_x != -1) && (point_distance(_spawn_x, _spawn_y, _gx, _gy) < _spawn_safe_radius);
            if (!_has_wall
                    && !_near_spawn
                    && !instance_position(_gx + 8, _gy + 8, obj_collision)
                    && !instance_position(_gx + 8, _gy + 8, obj_rock)) {
                _placed = [{x: _gx, y: _gy}];
                _found  = true;
                break;
            }
        }
        if (!_found) continue;

        var _size = irandom_range(1, 6);
        for (var _i = 0; _i < _size - 1; _i++) {
            var _base = _placed[irandom(array_length(_placed) - 1)];

            var _order = [0, 1, 2, 3];
            for (var _d = 3; _d > 0; _d--) {
                var _s   = irandom(_d);
                var _tmp = _order[_d];
                _order[_d] = _order[_s];
                _order[_s] = _tmp;
            }

            for (var _d = 0; _d < 4; _d++) {
                var _dir = _dirs[_order[_d]];
                var _nx  = _base.x + _dir[0];
                var _ny  = _base.y + _dir[1];
                var _has_wall = (_map_walls != -1) && (tilemap_get_at_pixel(_map_walls, _nx + 8, _ny + 8) != 0);
                var _near_spawn = (_spawn_x != -1) && (point_distance(_spawn_x, _spawn_y, _nx, _ny) < _spawn_safe_radius);

                var _overlap_placement = false;
                for (var _p = 0; _p < array_length(_placed); _p++) {
                    if (point_distance(_nx, _ny, _placed[_p].x, _placed[_p].y) < 32) {
                        _overlap_placement = true;
                        break;
                    }
                }

                if (_nx >= _margin && _nx < room_width  - _margin
                        && _ny >= _margin && _ny < room_height - _margin
                        && !_has_wall
                        && !_near_spawn
                        && !_overlap_placement
                        && !instance_position(_nx + 8, _ny + 8, obj_collision)
                        && !instance_position(_nx + 8, _ny + 8, obj_rock)) {
                    array_push(_placed, {x: _nx, y: _ny});
                    break;
                }
            }
        }

        for (var _i = 0; _i < array_length(_placed); _i++) {
            var _px = _placed[_i].x;
            var _py = _placed[_i].y;
            var _inst = instance_create_layer(_px, _py, "Instances", obj_rock);

            if (_ore_type >= 0) {
                var _roll = random(100);
                if (_roll < _gem_pct) {
                    _inst.is_gemstone_rock = true;
                    _inst.sprite_index = sprite_rock_ore_gemstone1;
                    _inst.hits_remaining = 15;
                    _inst.max_hits = 15;
                } else if (_roll < _gem_pct + _coal_pct) {
                    _inst.is_coal_rock = true;
                    _inst.sprite_index = sprite_rock_ore_coal;
                    _inst.hits_remaining = 8;
                    _inst.max_hits = 8;
                } else if (_roll < _gem_pct + _coal_pct + _ore_pct) {
                    _inst.is_ore_rock = true;
                    _inst.ore_type_index = _ore_type;
                    _inst.ore_item_key = "ore_" + global.ore_names[_ore_type];
                    _inst.sprite_index = global.ore_rock_sprites[_ore_type];
                    _inst.hits_remaining = 10 + _ore_type * 5;
                    _inst.max_hits = _inst.hits_remaining;
                }
            }
        }
    }
}
