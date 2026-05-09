function scr_populate_road_to_cave() {
    var _x1 = 32;
    var _y1 = 32;
    var _x2 = room_width  - 32;
    var _y2 = room_height - 32;
    var _count        = irandom_range(6, 10);
    var _max_attempts = 40;

    for (var i = 0; i < _count; i++) {
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
