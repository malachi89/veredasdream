var _frame_count = sprite_get_number(sprite_index);
var _frames_per_dir = _frame_count / 4;
var _dir_map = [2, 3, 1, 0]; // DOWN, UP, RIGHT, LEFT -> Block indices
var _dir_index = _dir_map[dir];

var _frame = floor(frame_anim % _frames_per_dir) + (_dir_index * _frames_per_dir);
draw_sprite_ext(sprite_index, _frame, x, y, 1, 1, 0, c_white, 1);
