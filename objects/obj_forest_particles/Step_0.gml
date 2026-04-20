var _cam = view_camera[0];
var _vx = camera_get_view_x(_cam);
var _vy = camera_get_view_y(_cam);
var _vw = camera_get_view_width(_cam);

part_emitter_region(particle_sys, emitter, _vx, _vx + _vw, _vy - 16, _vy, ps_shape_rectangle, ps_distr_linear);
part_emitter_burst(particle_sys, emitter, leaf_type, 1);
