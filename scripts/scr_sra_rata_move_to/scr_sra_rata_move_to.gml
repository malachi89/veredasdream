function scr_sra_rata_move_to(_target_x, _target_y, _speed) {
    var _dist = point_distance(x, y, _target_x, _target_y);
    if (_dist <= _speed) {
        x = _target_x;
        y = _target_y;
        return true;
    }
    
    var _angle = point_direction(x, y, _target_x, _target_y);
    var _dx = lengthdir_x(1, _angle);
    var _dy = lengthdir_y(1, _angle);
    
    var _nx = x + _dx * _speed;
    var _ny = y + _dy * _speed;
    if (!place_meeting(_nx, _ny, obj_collision)) {
        x = _nx;
        y = _ny;
        return true;
    }
    
    var _moved = false;
    _nx = x + _dx * _speed;
    if (!place_meeting(_nx, y, obj_collision)) {
        x = _nx;
        _moved = true;
    }
    _ny = y + _dy * _speed;
    if (!place_meeting(x, _ny, obj_collision)) {
        y = _ny;
        _moved = true;
    }
    if (_moved) return true;
    
    for (var _i = 1; _i <= 3; _i++) {
        var _a = _i * 15;
        var _off_dx = lengthdir_x(_speed, _angle - _a);
        var _off_dy = lengthdir_y(_speed, _angle - _a);
        if (!place_meeting(x + _off_dx, y + _off_dy, obj_collision)) {
            x += _off_dx;
            y += _off_dy;
            return true;
        }
        _off_dx = lengthdir_x(_speed, _angle + _a);
        _off_dy = lengthdir_y(_speed, _angle + _a);
        if (!place_meeting(x + _off_dx, y + _off_dy, obj_collision)) {
            x += _off_dx;
            y += _off_dy;
            return true;
        }
    }
    
    return false;
}
