var _room = room_get_name(room);
var _moving = false;

if (walk_to_farm) {
    var _tx = -50;
    var _ty = 105;
    if (point_distance(x, y, _tx, _ty) < wander_speed) {
        instance_destroy();
        exit;
    }
    var _a = point_direction(x, y, _tx, _ty);
    wander_dx = lengthdir_x(1, _a);
    wander_dy = lengthdir_y(1, _a);
    dir = (abs(wander_dx) >= abs(wander_dy)) ? ((wander_dx > 0) ? DIR.RIGHT : DIR.LEFT) : ((wander_dy > 0) ? DIR.DOWN : DIR.UP);
    var _nx = x + wander_dx * wander_speed;
    var _ny = y + wander_dy * wander_speed;
    if (!place_meeting(_nx, _ny, obj_collision)) {
        x = _nx;
        y = _ny;
        _moving = true;
    } else {
        instance_destroy();
        exit;
    }
    frame_anim += 0.15;
    if (frame_anim >= frames_walk) frame_anim = 0;
    var _sra_dir_start = [0, 9, 6, 3];
    image_index = _sra_dir_start[dir] + floor(frame_anim);
    depth = -bbox_bottom;
    exit;
}

// Go to rest position on farm
if (go_to_rest) {
    if (_room != "farm") { instance_destroy(); exit; }
    var _tx = 670;
    var _ty = 120;
    if (point_distance(x, y, _tx, _ty) < wander_speed) {
        x = _tx;
        y = _ty;
        dir = DIR.DOWN;
        is_resting = true;
        go_to_rest = false;
    } else {
        var _a = point_direction(x, y, _tx, _ty);
        wander_dx = lengthdir_x(1, _a);
        wander_dy = lengthdir_y(1, _a);
        dir = (abs(wander_dx) >= abs(wander_dy)) ? ((wander_dx > 0) ? DIR.RIGHT : DIR.LEFT) : ((wander_dy > 0) ? DIR.DOWN : DIR.UP);
        var _nx = x + wander_dx * wander_speed;
        var _ny = y + wander_dy * wander_speed;
        if (!place_meeting(_nx, _ny, obj_collision)) {
            x = _nx; y = _ny; _moving = true;
        } else { _moving = false; }
    }
    frame_anim += _moving ? 0.15 : 0.1;
    if (frame_anim >= frames_walk) frame_anim = 0;
    var _sra_dir_start = [0, 9, 6, 3];
    image_index = _sra_dir_start[dir] + floor(frame_anim);
    depth = -bbox_bottom;
    exit;
}

// Bodyguard mode: follow player and attack on command
if (global.sra_rata_state.bodyguard && instance_exists(global.local_player)) {
    var _p = global.local_player;
    var _p_spd = _p.move_speed;
    if (_p.is_riding)
        _p_spd = (_p.state == STATE.RUN) ? _p.move_speed_run * 1.8 : _p.move_speed_run * 1.2;
    else
        _p_spd = (_p.state == STATE.RUN) ? _p.move_speed_run : _p.move_speed;
    var _bg_spd = _p_spd * 0.87;

    bodyguard_attack_timer--;
    var _target = global.sra_rata_bodyguard_target;
    if (_target != noone && instance_exists(_target) && variable_instance_exists(_target, "hp") && _target.hp > 0) {
        var _bd = point_distance(x, y, _target.x, _target.y);
        if (_bd > 30) {
            var _ba = point_direction(x, y, _target.x, _target.y);
            wander_dx = lengthdir_x(1, _ba);
            wander_dy = lengthdir_y(1, _ba);
            var _bnx = x + wander_dx * _bg_spd;
            var _bny = y + wander_dy * _bg_spd;
            if (!place_meeting(_bnx, _bny, obj_collision)) {
                x = _bnx; y = _bny; _moving = true;
                if (abs(wander_dx) >= abs(wander_dy))
                    dir = (wander_dx > 0) ? DIR.RIGHT : DIR.LEFT;
                else
                    dir = (wander_dy > 0) ? DIR.DOWN : DIR.UP;
            } else { _moving = false; }
        } else {
            _moving = false;
            if (bodyguard_attack_timer <= 0) {
                with (_target) { hp -= 9; hurt_flash_timer = 15; }
                bodyguard_attack_timer = 30;
            }
        }
    } else {
        global.sra_rata_bodyguard_target = noone;
        var _pd = point_distance(x, y, _p.x, _p.y);
        if (_pd > 48) {
            var _pa = point_direction(x, y, _p.x, _p.y);
            wander_dx = lengthdir_x(1, _pa);
            wander_dy = lengthdir_y(1, _pa);
            var _pnx = x + wander_dx * _bg_spd;
            var _pny = y + wander_dy * _bg_spd;
            if (!place_meeting(_pnx, _pny, obj_collision)) {
                x = _pnx; y = _pny; _moving = true;
                if (abs(wander_dx) >= abs(wander_dy))
                    dir = (wander_dx > 0) ? DIR.RIGHT : DIR.LEFT;
                else
                    dir = (wander_dy > 0) ? DIR.DOWN : DIR.UP;
            } else { _moving = false; }
        } else { _moving = false; }
    }
    frame_anim += _moving ? 0.15 : 0.1;
    if (frame_anim >= frames_walk) frame_anim = 0;
    var _sra_dir_start = [0, 9, 6, 3];
    image_index = _sra_dir_start[dir] + floor(frame_anim);
    depth = -bbox_bottom;
    exit;
}

if (_room == "farm") {
    if (global.sra_rata_state.contract_type == "none" ||
        (global.sra_rata_state.contract_type == "daily" && global.day != global.sra_rata_state.hired_on_day)) {
        instance_destroy();
        exit;
    }

    if (work_fail_timer > 0) {
        work_fail_timer--;
        if (work_fail_timer <= 0) work_fail_target = noone;
    }

    if (!is_resting) {
        if (is_working) {
            if (!instance_exists(work_target)) {
                is_working = false;
                work_target = noone;
                work_progress = 0;
                work_stuck_time = 0;
            } else {
                    var _wd = point_distance(x, y, work_target.x, work_target.y);
                if (_wd > 24) {
                    var _a = point_direction(x, y, work_target.x, work_target.y);
                    wander_dx = lengthdir_x(1, _a);
                    wander_dy = lengthdir_y(1, _a);
                    var _nx = x + wander_dx * wander_speed;
                    var _ny = y + wander_dy * wander_speed;
                    if (!place_meeting(_nx, _ny, obj_collision)) {
                        work_stuck_time = 0;
                        x = _nx;
                        y = _ny;
                        _moving = true;
                        if (abs(wander_dx) >= abs(wander_dy))
                            dir = (wander_dx > 0) ? DIR.RIGHT : DIR.LEFT;
                        else
                            dir = (wander_dy > 0) ? DIR.DOWN : DIR.UP;
                    } else {
                        work_stuck_time++;
                        if (work_stuck_time > 60) {
                            work_fail_target = work_target;
                            work_fail_timer = 300;
                            is_working = false;
                            work_target = noone;
                            work_progress = 0;
                            work_stuck_time = 0;
                            work_scan_timer = 0;
                        }
                    }
                } else {
                    _moving = false;
                    wander_dx = 0;
                    wander_dy = 0;
                    work_stuck_time = 0;
                    work_progress += 1 / work_duration;
                    if (work_progress >= 1) {
                        work_fail_target = noone;
                        work_fail_timer = 0;
                        var _map_w = -1;
                        if (layer_exists("Tiles_tilled_watered"))
                            _map_w = layer_tilemap_get_id("Tiles_tilled_watered");
                        switch (work_type) {
                            case "water":
                                with (work_target) {
                                    is_watered = true;
                                    if (_map_w != -1) {
                                        var _t = tilemap_get_at_pixel(_map_w, x, y);
                                        if (_t == 72) tilemap_set_at_pixel(_map_w, 168, x, y);
                                    }
                                }
                                break;
                            case "rock":
                                with (work_target) {
                                    inventory_drop_item("stone", irandom_range(1, 3), x, y, 15);
                                    instance_destroy(id);
                                }
                                break;
                            case "weed":
                                with (work_target) instance_destroy(id);
                                break;
                            case "tree":
                                with (work_target) {
                                    inventory_drop_item("wood", irandom_range(3, 5), x, y, 15);
                                    instance_destroy(id);
                                }
                                break;
                        }
                        is_working = false;
                        work_target = noone;
                        work_progress = 0;
                        work_stuck_time = 0;
                    }
                }
            }
        }

        if (!is_working) {
            work_scan_timer--;
            if (work_scan_timer <= 0) {
                work_scan_timer = 15;
                var _near = noone;
                var _near_d = 999999;
                var _near_t = "";

                with (obj_crop) {
                    if (!is_watered) {
                        var _d = point_distance(other.x, other.y, x, y);
                        if (_d < _near_d && _d < 320 && !collision_line(other.x, other.y, x, y, obj_collision, false, true)) { _near = id; _near_d = _d; _near_t = "water"; }
                    }
                }
                if (_near == noone) {
                    with (obj_rock) {
                        var _d = point_distance(other.x, other.y, x, y);
                        if (_d < _near_d && _d < 320 && !collision_line(other.x, other.y, x, y, obj_collision, false, true)) { _near = id; _near_d = _d; _near_t = "rock"; }
                    }
                }
                if (_near == noone) {
                    with (obj_weed) {
                        var _d = point_distance(other.x, other.y, x, y);
                        if (_d < _near_d && _d < 320 && !collision_line(other.x, other.y, x, y, obj_collision, false, true)) { _near = id; _near_d = _d; _near_t = "weed"; }
                    }
                }
                if (_near == noone) {
                    with (obj_common_tree) {
                        var _d = point_distance(other.x, other.y, x, y);
                        if (_d < _near_d && _d < 320 && !collision_line(other.x, other.y, x, y, obj_collision, false, true)) { _near = id; _near_d = _d; _near_t = "tree"; }
                    }
                }

                if (_near != noone && _near == work_fail_target) {
                    _near = noone;
                    _near_t = "";
                }

                if (_near != noone) {
                    is_working = true;
                    work_target = _near;
                    work_type = _near_t;
                    work_progress = 0;
                    work_stuck_time = 0;
                    switch (_near_t) {
                        case "water": work_duration = 3 * 60; break;
                        case "rock":  work_duration = 15 * 60; break;
                        case "weed":  work_duration = 15 * 60; break;
                        case "tree":  work_duration = 30 * 60; break;
                    }
                }
            }

            if (!is_working) {
                wander_timer--;
                if (wander_timer <= 0) {
                    if (wander_resting) {
                        wander_resting = false;
                        wander_timer = irandom_range(60, 180);
                        var _angle = irandom(7) * 45;
                        wander_dx = lengthdir_x(1, _angle);
                        wander_dy = lengthdir_y(1, _angle);
                    } else {
                        if (irandom(4) < 2) {
                            wander_resting = true;
                            wander_timer = irandom_range(40, 120);
                            wander_dx = 0;
                            wander_dy = 0;
                        } else {
                            wander_timer = irandom_range(60, 180);
                            var _angle = irandom(7) * 45;
                            wander_dx = lengthdir_x(1, _angle);
                            wander_dy = lengthdir_y(1, _angle);
                        }
                    }
                }

                var _nx = x + wander_dx * wander_speed;
                var _ny = y + wander_dy * wander_speed;
                var _blocked = place_meeting(_nx, _ny, obj_collision);
                if (!_blocked) {
                    x = _nx;
                    y = _ny;
                    _moving = (wander_dx != 0 || wander_dy != 0);
                    if (_moving) {
                        if (abs(wander_dx) >= abs(wander_dy))
                            dir = (wander_dx > 0) ? DIR.RIGHT : DIR.LEFT;
                        else
                            dir = (wander_dy > 0) ? DIR.DOWN : DIR.UP;
                    }
                } else {
                    wander_timer = 0;
                    wander_dx = 0;
                    wander_dy = 0;
                }
            }
        }
    }
} else if (_room == "forest") {
    if (global.sra_rata_state.contract_type == "lifetime" ||
        (global.sra_rata_state.contract_type == "daily" && global.day == global.sra_rata_state.hired_on_day)) {
        instance_destroy();
        exit;
    }
}

frame_anim += _moving ? 0.15 : 0.1;
if (frame_anim >= frames_walk) frame_anim = 0;

var _sra_dir_start = [0, 9, 6, 3];
image_index = _sra_dir_start[dir] + floor(frame_anim);

depth = -bbox_bottom;
