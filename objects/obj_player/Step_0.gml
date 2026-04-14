if (instance_exists(obj_controller) && obj_controller.sleep_menu_open) {
    state = STATE.IDLE;
    frame_anim = 0;
    image_speed = 0;
    depth = -bbox_bottom;
    exit;
}

var _h   = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var _v   = keyboard_check(ord("S")) - keyboard_check(ord("W"));
var _run = keyboard_check(vk_shift);
var _mag = point_distance(0, 0, _h, _v);
var _prev_state = state;

if (keyboard_check_pressed(ord("E"))) {
    if (is_riding) {
        is_riding = false;
        frames_idle = 4;
        frames_walk = 6;
        frames_run  = 8;
        var _ox = 0;
        var _oy = 0;
        if (dir == DIR.LEFT) _ox = 16;
        if (dir == DIR.LEFT) _oy = -24;
        if (dir == DIR.RIGHT) _ox = 16;
        if (dir == DIR.RIGHT) _oy = -24;
        var _h_dir = dir;
        if (dir == DIR.UP) _h_dir = DIR.DOWN;
        else if (dir == DIR.DOWN) _h_dir = DIR.UP;
        var _horse_inst = instance_create_layer(x + _ox, y + _oy, "Instances", obj_horse1);
        _horse_inst.dir = _h_dir;
        _horse_inst.x_start = x + _ox;
        _horse_inst.y_start = y + _oy;
    } else {
        var _horse = instance_nearest(x, y, obj_horse1);
        if (_horse != noone && point_distance(x, y, _horse.x, _horse.y) < 40) {
            is_riding = true;
            frames_idle = 2;
            frames_walk = 4;
            frames_run  = 6;
            instance_destroy(_horse);
        }
    }
}

if (mouse_check_button_pressed(mb_left) && state != STATE.ACTING) {
    var _selected_item = obj_inventory.inventory_array[obj_inventory.selected_slot];
    var _item_key = (is_struct(_selected_item)) ? _selected_item.key : _selected_item;
    var _gx = floor(mouse_x / 16) * 16;
    var _gy = floor(mouse_y / 16) * 16;
    var _p_cx = (bbox_left + bbox_right) / 2;
    var _p_cy = (bbox_top + bbox_bottom) / 2;
    var _actual_dist = point_distance(_p_cx, _p_cy, _gx + 8, _gy + 8);
    if ((_actual_dist <= 32 || _item_key == "bow") && !obj_inventory.show_backpack) {
        scr_use_item(_selected_item, _gx, _gy);
    }
}

var _mx = 0;
var _my = 0;

if (state != STATE.ACTING) {
    if (_mag == 0) {
        state = STATE.IDLE;
    } else {
        if (is_riding) state = _run ? STATE.WALK : STATE.RUN;
        else state = _run ? STATE.RUN : STATE.WALK;
        if (abs(_h) > abs(_v)) dir = (_h > 0) ? DIR.RIGHT : DIR.LEFT;
        else dir = (_v > 0) ? DIR.DOWN : DIR.UP;
    }

    var _spd = move_speed;
    if (is_riding) _spd = (state == STATE.RUN) ? move_speed_run * 1.8 : move_speed_run * 1.2;
    else _spd = (state == STATE.RUN) ? move_speed_run : move_speed;
    _mx = (_mag != 0) ? (_h / _mag) * _spd : 0;
    _my = (_mag != 0) ? (_v / _mag) * _spd : 0;
}

move_and_collide(_mx, _my, [obj_collision, obj_chest], 4, 0, 0, -1, -1);

if (state != _prev_state) frame_anim = 0;

if (state == STATE.ACTING) {
    frame_anim += 0.2;
    if (frame_anim >= frames_action) {
        state = STATE.IDLE;
        frame_anim = 0;
    }
    image_index = (dir * frames_action) + floor(frame_anim);
} else {
    var _s_idle = is_riding ? sprite_player_horse1_body_idle : sprite_player_idle;
    var _s_walk = is_riding ? sprite_player_horse1_body_walk : sprite_player_walk;
    var _s_run = is_riding ? sprite_player_horse1_body_run : sprite_player_run;
    var _anim_data = [
        [_s_idle, 0.1, frames_idle],
        [_s_walk, 0.15, frames_walk],
        [_s_run, 0.25, frames_run]
    ];
    var _current = _anim_data[state];
    sprite_index = _current[0];
    frame_anim += _current[1];
    if (frame_anim >= _current[2]) frame_anim = 0;
    var _dir_idx = dir;
    if (is_riding) {
        if (state == STATE.IDLE) _dir_idx = dir;
        else {
            if (dir == DIR.DOWN) _dir_idx = 0;
            else if (dir == DIR.UP) _dir_idx = 1;
        }
    }
    image_index = (_dir_idx * _current[2]) + floor(frame_anim);
}

image_speed = 0;
depth = -bbox_bottom;
