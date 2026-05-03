partRain_sys = part_system_create();

partRain = part_type_create();
part_type_shape(partRain, pt_shape_line);
part_type_size(partRain, 0.2, 0.3, 0, 0);
part_type_color2(partRain, c_teal, c_white);
part_type_alpha2(partRain, 0.5, 0.1);
part_type_gravity(partRain, 0.1, 290);
part_type_speed(partRain, 0.5, 0.5, 0, 0);
part_type_direction(partRain, 250, 330, 0, 1);
part_type_orientation(partRain, 290, 290, 0, 0, 0);
part_type_life(partRain, 20, 150);

partRain_emit = part_emitter_create(partRain_sys);
part_emitter_region(partRain_sys, partRain_emit, view_xview[0] - 400, view_wview[0], view_yview[0] - 100, view_yview[0] - 100, ps_shape_line, ps_distr_linear);
part_emitter_stream(partRain_sys, partRain_emit, partRain, 5);

rain_audio = audio_play_sound(sound_rain_and_thunder, 10, true);
audio_sound_gain(rain_audio, 0.7, 0);
