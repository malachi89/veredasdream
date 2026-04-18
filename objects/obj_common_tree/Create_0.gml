/// Create Event
hits_remaining = 10;
tree_type    = "birch"; // Set by scr_populate_farm: "birch", "mahogany", "pine", "maple"
growth_stage = 1;        // 1=seed, 2-3=sapling, 4+=fully grown (seasonal)
max_stages   = 7;
image_speed  = 0;

grow = function() {
    if (growth_stage < 4) {
        growth_stage += 1;
    }
}
