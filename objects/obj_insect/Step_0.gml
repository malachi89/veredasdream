depth = -bbox_bottom;

var _frame_count = sprite_get_number(sprite_index);
frame_anim += 0.15;
if (frame_anim >= _frame_count) frame_anim -= _frame_count;

switch (state) {
    case ANIMAL_STATE.IDLE:
        idle_timer -= 1;
        if (idle_timer <= 0) {
            state        = ANIMAL_STATE.WANDERING;
            dir          = choose(DIR.LEFT, DIR.RIGHT);
            wander_steps = max_wander_steps;
        }
    break;

    case ANIMAL_STATE.WANDERING:
        var _dx      = (dir == DIR.LEFT) ? -move_speed : move_speed;
        var _check_x = x + _dx + (dir == DIR.LEFT ? -4 : 4);
        if (!instance_position(_check_x, y, obj_collision)) {
            x += _dx;
        } else {
            dir = (dir == DIR.LEFT) ? DIR.RIGHT : DIR.LEFT;
        }
        wander_steps -= 1;
        if (wander_steps <= 0) {
            state            = ANIMAL_STATE.IDLE;
            idle_timer       = irandom_range(60, 240);
            max_wander_steps = irandom_range(30, 120);
        }
    break;
}
