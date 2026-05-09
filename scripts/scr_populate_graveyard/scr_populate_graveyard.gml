function scr_populate_graveyard() {
    with (obj_enemy_skeleton) instance_destroy();
    with (obj_weed) instance_destroy();

    var _edata      = global.enemy_data[$ "skeleton"];
    if (_edata == undefined) exit;

    var _x1 = 96;
    var _y1 = 96;
    var _x2 = room_width  - 96;
    var _y2 = room_height - 96;

    var _count        = irandom_range(2, 4);
    var _placed       = [];
    var _min_dist     = 64;
    var _max_attempts = 30;

    for (var i = 0; i < _count; i++) {
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
            if (collision_rectangle(_px - 16, _py - 16, _px + 16, _py + 16, obj_collision, false, false) != noone) continue;

            instance_create_layer(_px, _py, "Instances", obj_enemy_skeleton);
            array_push(_placed, { x: _px, y: _py });
            break;
        }
    }

    var _weed_count = irandom_range(6, 12);
    for (var i = 0; i < _weed_count; i++) {
        for (var attempt = 0; attempt < _max_attempts; attempt++) {
            var _px = floor(random_range(_x1, _x2 - 1) / 16) * 16;
            var _py = floor(random_range(_y1, _y2 - 1) / 16) * 16;
            if (instance_position(_px + 8, _py + 8, obj_collision)) continue;
            if (instance_position(_px + 8, _py + 8, obj_weed))      continue;
            instance_create_layer(_px, _py, "Instances", obj_weed);
            break;
        }
    }
}
