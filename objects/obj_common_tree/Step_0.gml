depth = -bbox_bottom;

if (growth_stage >= 4 && growth_stage != 8 && !instance_exists(canopy_id)) {
    canopy_id = instance_create_layer(x, y, "Instances", obj_canopy);
    canopy_id.parent_tree = id;
}
