hits_remaining = 10;
tree_type    = "birch";
growth_stage = 1;
max_stages   = 7;
image_speed  = 0;

canopy_id = noone;
if (growth_stage >= 4 && growth_stage != 8) {
    canopy_id = instance_create_layer(x, y, "Instances", obj_canopy);
    canopy_id.parent_tree = id;
}

grow = function() {
    if (growth_stage < 4) {
        growth_stage += 1;
        if (growth_stage == 4 && !instance_exists(canopy_id)) {
            canopy_id = instance_create_layer(x, y, "Instances", obj_canopy);
            canopy_id.parent_tree = id;
        }
    }
}
