
var _horizontal_input = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var _vertical_input   = keyboard_check(ord("S")) - keyboard_check(ord("W"));
var _is_running       = keyboard_check(vk_shift);

var _current_movement_speed = _is_running ? move_speed_run : move_speed;


var _input_magnitude = point_distance(0, 0, _horizontal_input, _vertical_input);


if (_input_magnitude != 0) 
{
 
    var _normalized_velocity_x = (_horizontal_input / _input_magnitude) * _current_movement_speed;
    var _normalized_velocity_y = (_vertical_input / _input_magnitude) * _current_movement_speed;
    
    move_and_collide(_normalized_velocity_x, _normalized_velocity_y, obj_collision);
}