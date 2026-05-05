# Sound System

## Reproducir un segmento de un clip

Usa `scr_play_sound_clip(sound, start_sec, end_sec)` para reproducir solo una porción de un archivo de audio.

Ejemplos:
```gml
scr_play_sound_clip(sound_item_pickup, 0.75, 1.00);
scr_play_sound_clip(sound_arrow_shoot, 1.85, 2.00);
```

- El sonido se inicia en `start_sec` y se detiene automáticamente en `end_sec`.
- Devuelve el `_id` del sonido, o `-1` si falla.
- El cleanup lo maneja `obj_controller` Step mediante `global.sound_clips` (array de `{ id, timer }`).
- No necesita variables auxiliares ni timers manuales en cada objeto.

## Función

`scripts/scr_play_sound_clip/scr_play_sound_clip.gml`
