/// Create Event
sprite_index = choose(sprite_bush_1, sprite_bush_2, sprite_bush_3, sprite_bush_4);
image_speed = 0;

var _bush_key = string(room_get_name(room)) + "_" + string(x) + "_" + string(y);
if (variable_struct_exists(global.bush_harvested, _bush_key)) {
    has_fruit = false;
} else {
    has_fruit = ((global.day * 7919 + x * 13 + y * 7) mod 100 < 15);
}
image_index = has_fruit ? 0 : 1;
