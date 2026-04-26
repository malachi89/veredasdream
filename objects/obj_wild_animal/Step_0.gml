depth = -bbox_bottom;

var _frame_count = sprite_get_number(sprite_index);
frame_anim += 0.15;
if (frame_anim >= _frame_count) frame_anim -= _frame_count;

if (hurt_flash_timer > 0) hurt_flash_timer -= 1;

if (hp <= 0) {
    instance_destroy();
    exit;
}

if (state != ANIMAL_STATE.FLEEING && instance_exists(obj_player)) {
    if (point_distance(x, y, obj_player.x, obj_player.y) < 80) {
        state      = ANIMAL_STATE.FLEEING;
        flee_timer = 90;
        // Flee in all 4 directions based on player position
        var _pdir = point_direction(obj_player.x, obj_player.y, x, y);
        if (_pdir >= 45 && _pdir < 135) dir = DIR.UP;
        else if (_pdir >= 135 && _pdir < 225) dir = DIR.LEFT;
        else if (_pdir >= 225 && _pdir < 315) dir = DIR.DOWN;
        else dir = DIR.RIGHT;
    }
}

switch (state) {
    case ANIMAL_STATE.IDLE:
        idle_timer -= 1;
        if (idle_timer <= 0) {
            state        = ANIMAL_STATE.WANDERING;
            dir          = choose(DIR.LEFT, DIR.RIGHT, DIR.UP, DIR.DOWN);
            wander_steps = max_wander_steps;
        }
    break;

    case ANIMAL_STATE.WANDERING:
        var _dx = 0;
        var _dy = 0;
        if (dir == DIR.LEFT) _dx = -move_speed;
        else if (dir == DIR.RIGHT) _dx = move_speed;
        else if (dir == DIR.UP) _dy = -move_speed;
        else if (dir == DIR.DOWN) _dy = move_speed;
        
        var _check_x = x + _dx + (dir == DIR.LEFT ? -4 : (dir == DIR.RIGHT ? 4 : 0));
        var _check_y = y + _dy + (dir == DIR.UP ? -4 : (dir == DIR.DOWN ? 4 : 0));
        
        if (!instance_position(_check_x, _check_y, obj_collision)) {
            x += _dx;
            y += _dy;
        } else {
            dir = choose(DIR.LEFT, DIR.RIGHT, DIR.UP, DIR.DOWN);
        }
        wander_steps -= 1;
        if (wander_steps <= 0) {
            state            = ANIMAL_STATE.IDLE;
            idle_timer       = irandom_range(60, 240);
            max_wander_steps = irandom_range(30, 120);
        }
    break;

    case ANIMAL_STATE.FLEEING:
        var _fspeed = move_speed * 2.5;
        var _fdx = 0;
        var _fdy = 0;
        if (dir == DIR.LEFT) _fdx = -_fspeed;
        else if (dir == DIR.RIGHT) _fdx = _fspeed;
        else if (dir == DIR.UP) _fdy = -_fspeed;
        else if (dir == DIR.DOWN) _fdy = _fspeed;

        var _check_fx = x + _fdx + (dir == DIR.LEFT ? -4 : (dir == DIR.RIGHT ? 4 : 0));
        var _check_fy = y + _fdy + (dir == DIR.UP ? -4 : (dir == DIR.DOWN ? 4 : 0));

        if (!instance_position(_check_fx, _check_fy, obj_collision)) {
            x += _fdx;
            y += _fdy;
        } else {
            dir = choose(DIR.LEFT, DIR.RIGHT, DIR.UP, DIR.DOWN);
        }
        flee_timer--;
        if (flee_timer <= 0) {
            state      = ANIMAL_STATE.IDLE;
            idle_timer = irandom_range(60, 240);
        }
    break;
}
