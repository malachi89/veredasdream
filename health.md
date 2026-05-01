# Sistema de Salud (Player Health)

## Resumen
El jugador tiene 10 corazones de salud. Cada corazón equivale a 2 HP internos (max_hp = 20). Al inicio de cada día la salud se restaura completamente.

## Variables en `obj_player`

| Variable | Tipo | Descripción |
|---|---|---|
| `max_hp` | int | 20 (10 corazones × 2) |
| `hp` | int | Salud actual, 0-20 |
| `hurt_timer` | int | Frames de invencibilidad tras recibir daño (60 = 1 segundo) |

## UI

Los 10 corazones se dibujan en `obj_controller` Draw_64, debajo de la barra de ENERGÍA. Cada corazón usa `sprite_health`:

- **Frame 0** — Lleno (hp restante ≥ 2)
- **Frame 1** — Medio (hp restante = 1)
- **Frame 2** — Vacío (hp restante = 0)

Escala 2x, separación de 34px.

## Daño

| Fuente | Dónde | Efecto |
|---|---|---|
| Animales salvajes en FLEEING que tocan al jugador | `obj_player` Step, tras `move_and_collide` | -1 HP, hurt_timer = 60, suena `sound_hurt` |

Solo el jugador recibe daño (el animal no).

## Muerte (HP = 0)

Cuando `hp <= 0` en el Step del jugador:

1. HP restaurado a `max_hp`
2. Energía restaurada al máximo
3. Pierde 10% del dinero (redondeado hacia abajo)
4. Si existe `obj_bed` en la sala, teletransporta a la posición de la cama
5. Muestra notificación: "Te has desmayado! Has perdido MXN$ X"

## Parpadeo Rojo

Cuando `hurt_timer > 0` todas las capas del sprite del jugador se dibujan con combinación `c_red` en lugar de `c_white`. La sombra negra no se ve afectada. Funciona tanto para el jugador host como para el invitado en multijugador.

## Debug

| Comando | Descripción |
|---|---|
| `set_hp <n>` | Establece HP (0-20) |
| `heal` | Restaura energía y HP al máximo |

## Persistencia

- **Guardado**: `hp` se guarda en `scr_save_game()` dentro del struct de cada jugador.
- **Carga**: `scr_apply_loaded_game()` restaura `hp` si existe en los datos (retrocompatible con saves sin HP).
- **Multijugador**: El snapshot completo envía `hp: 20` inicial para player2.

## Reset Diario

`start_new_day()` en `obj_controller` restaura `global.local_player.hp = global.local_player.max_hp`.
