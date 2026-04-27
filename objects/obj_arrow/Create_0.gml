sprite_index = sprite_arrow;
image_speed  = 0;
damage       = 1; // overwritten by spawner (bow quality + 1)
depth        = -9999;

var _angle = point_direction(x, y, mouse_x, mouse_y);
hspeed = lengthdir_x(5, _angle);
vspeed = lengthdir_y(5, _angle);

// Pick directional sprite frame (GML: 0=right, 90=up, 180=left, 270=down)
if (_angle >= 45 && _angle < 135)       image_index = 0; // up
else if (_angle >= 225 && _angle < 315) image_index = 1; // down
else if (_angle >= 135 && _angle < 225) image_index = 3; // left
else                                     image_index = 2; // right

has_hit   = false;
hit_timer = 0;
