function scr_populate_cave() {
    with (obj_rock) instance_destroy();

    var _margin   = 32;
    var _spawn_safe_radius = 192;
    var _num_form = irandom_range(160, 300);
    var _dirs     = [[16, 0], [-16, 0], [0, 16], [0, -16]];

    var _layer_walls = layer_get_id("Tiles_walls");
    var _map_walls = (_layer_walls != -1) ? layer_tilemap_get_id(_layer_walls) : -1;

    var _spawn_point = instance_find(obj_ladder_exit, 0);
    var _spawn_x = (_spawn_point != noone) ? _spawn_point.x : -1;
    var _spawn_y = (_spawn_point != noone) ? _spawn_point.y : -1;

    for (var _f = 0; _f < _num_form; _f++) {
        // Find a valid seed position on 16-px grid
        var _placed  = [];
        var _found   = false;

        repeat (100) {
            var _gx = _margin + (irandom((room_width  - 2 * _margin) div 16 - 1)) * 16;
            var _gy = _margin + (irandom((room_height - 2 * _margin) div 16 - 1)) * 16;
            var _has_wall = (_map_walls != -1) && (tilemap_get_at_pixel(_map_walls, _gx + 8, _gy + 8) != 0);
            var _near_spawn = (_spawn_x != -1) && (distance_to_point(_gx, _gy) < _spawn_safe_radius);
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

        // Grow formation (up to 5 extra rocks)
        var _size = irandom_range(1, 6);
        for (var _i = 0; _i < _size - 1; _i++) {
            var _base = _placed[irandom(array_length(_placed) - 1)];

            // Shuffle direction indices
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
                var _near_spawn = (_spawn_x != -1) && (distance_to_point(_nx, _ny) < _spawn_safe_radius);

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

        // Spawn obj_rock at each position
        for (var _i = 0; _i < array_length(_placed); _i++) {
            instance_create_layer(_placed[_i].x, _placed[_i].y, "Instances", obj_rock);
        }
    }
}
