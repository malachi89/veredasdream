image_speed = 0;
depth = -bbox_bottom;

var _col_layer = layer_get_id("Instances_collision");
if (_col_layer == -1) _col_layer = layer_get_id("Instances");
col_companion = instance_create_layer(x, y, _col_layer, obj_collision);
col_companion.image_xscale = 6;
col_companion.image_yscale = 5;
col_companion.is_town_building_collision = true;
