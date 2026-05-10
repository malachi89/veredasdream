sprite_index = sprite_arrow;
image_speed  = 0;
damage       = 1; // overwritten by spawner (bow quality + 1)
depth        = -9999;

var _angle = point_direction(x, y, mouse_x, mouse_y);
hspeed = lengthdir_x(5, _angle);
vspeed = lengthdir_y(5, _angle);

// Pick directional sprite frame (8 directions)
if (_angle >= 67.5 && _angle < 112.5)       image_index = 0;  // up
else if (_angle >= 247.5 && _angle < 292.5) image_index = 1;  // down
else if (_angle >= 22.5 && _angle < 67.5)   image_index = 7;  // up-right
else if (_angle >= 112.5 && _angle < 157.5) image_index = 8;  // up-left
else if (_angle >= 202.5 && _angle < 247.5) image_index = 9;  // down-left
else if (_angle >= 292.5 && _angle < 337.5) image_index = 10; // down-right
else if (_angle >= 157.5 && _angle < 202.5) image_index = 3;  // left
else                                         image_index = 2;  // right

has_hit   = false;
hit_timer = 0;
