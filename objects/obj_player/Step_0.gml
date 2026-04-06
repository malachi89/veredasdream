input_left = keyboard_check(ord("A"));
input_right = keyboard_check(ord("D"));
input_up = keyboard_check(ord("W"));
input_down = keyboard_check(ord("S"));

var _horizontal_movement = input_right - input_left;
var _vertical_movement = input_down - input_up;

move_and_collide(_horizontal_movement * move_speed, _vertical_movement * move_speed, tile_col);