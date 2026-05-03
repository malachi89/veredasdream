if (part_emitter_exists(partRain_sys, partRain_emit))
    part_emitter_destroy(partRain_sys, partRain_emit);
part_type_destroy(partRain);
part_system_destroy(partRain_sys);

if (audio_is_playing(rain_audio))
    audio_stop_sound(rain_audio);
