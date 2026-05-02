if (instance_number(obj_music_manager) > 1) {
    instance_destroy();
    exit;
}

// Estructura de musica por estacion
// Vinculamos cada estacion con su recurso de sonido
music_map = {
    spring : [sound_music_spring, sound_music_spring_2],
    summer : sound_music_summer,
    fall   : sound_music_fall,
    winter : sound_music_winter
};

persistent = true;

current_track = noone;
current_music_instance = noone;
current_track_index = 0;
