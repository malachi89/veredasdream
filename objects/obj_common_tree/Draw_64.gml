var _cam = view_camera[0];
var _cam_x = camera_get_view_x(_cam);
var _cam_y = camera_get_view_y(_cam);
var _scale = display_get_gui_width() / camera_get_view_width(_cam);

if (hits_remaining < 10) {
    var _bar_w = 20;
    var _bar_h = 2;
    var _px = x + (sprite_width / 2) - (_bar_w / 2);
    var _py = bbox_top - 8;

    var _gx = (_px - _cam_x) * _scale;
    var _gy = (_py - _cam_y) * _scale;
    var _gw = _bar_w * _scale;
    var _gh = _bar_h * _scale;

    draw_set_color(c_black);
    draw_rectangle(_gx - 1 * _scale, _gy - 1 * _scale, _gx + _gw + 1 * _scale, _gy + _gh + 1 * _scale, false);

    draw_set_color(c_green);
    var _fill_w = (hits_remaining / 10) * _gw;
    if (_fill_w > 0) {
        draw_rectangle(_gx, _gy, _gx + _fill_w, _gy + _gh, false);
    }

    draw_set_color(c_white);
}
