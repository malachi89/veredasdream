particle_sys = part_system_create();
part_system_draw_order(particle_sys, true);

leaf_type = part_type_create();
part_type_sprite(leaf_type, sprite_leaf_particle, false, false, false);
part_type_size(leaf_type, 0.8, 1.4, 0, 0);
part_type_speed(leaf_type, 0.01, 0.15, 0, 0);
part_type_direction(leaf_type, 255, 285, 0, 2);
part_type_gravity(leaf_type, 0.001, 270);
part_type_orientation(leaf_type, 0, 359, 1, 1, false);
part_type_life(leaf_type, 360, 900);
part_type_alpha3(leaf_type, 0.9, 0.8, 0.0);
part_type_color3(leaf_type, $5FBF24, $A8C840, $C8A832);

emitter = part_emitter_create(particle_sys);
