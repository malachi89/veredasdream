
// INPUT
var _horizontal_input = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var _vertical_input   = keyboard_check(ord("S")) - keyboard_check(ord("W"));
var _is_running       = keyboard_check(vk_shift);

// SPEED
var _current_movement_speed = _is_running ? move_speed_run : move_speed;

// Normalize input
var _input_magnitude = point_distance(0, 0, _horizontal_input, _vertical_input);

// MOVEMENT
if (_input_magnitude != 0)
{
    var _move_x = (_horizontal_input / _input_magnitude) * _current_movement_speed;
    var _move_y = (_vertical_input   / _input_magnitude) * _current_movement_speed;

    move_and_collide(_move_x, _move_y, obj_collision);

    // -------- ANIMATION (WALK / RUN) --------
    if (abs(_horizontal_input) > abs(_vertical_input))
    {
        if (_horizontal_input > 0)
            sprite_index = female_walk_right;
        else
            sprite_index = female_walk_left;
    }
    else
    {
        if (_vertical_input > 0)
            sprite_index = female_walk_down;
        else
            sprite_index = female_walk_up;
    }

    // Running = faster animation (same sprites)
    image_speed = _is_running ? 1.5 : 1;
}
else
{
    // -------- IDLE --------
    image_speed = 0;

    if (sprite_index == female_walk_left)
        sprite_index = female_idle_left;
    else if (sprite_index == female_walk_right)
        sprite_index = female_idle_right;
}