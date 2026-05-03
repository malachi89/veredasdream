if (global.weather_today != "rain" || !scr_is_outdoor_room()) {
    if (part_emitter_exists(partRain_sys, partRain_emit))
        part_emitter_destroy(partRain_sys, partRain_emit);
    exit;
}

if (!part_emitter_exists(partRain_sys, partRain_emit))
    partRain_emit = part_emitter_create(partRain_sys);

part_emitter_region(partRain_sys, partRain_emit, view_xview[0] - 400, view_wview[0], view_yview[0] - 100, view_yview[0] - 100, ps_shape_line, ps_distr_linear);
part_emitter_stream(partRain_sys, partRain_emit, partRain, 5);
