# Sistema de Construcción del Establo

## Requerimientos

| Hito | Requisito | Recompensa |
|------|-----------|------------|
| Construir Establo | Matar 100 animales | 2 caballos |
| Desbloquear Oso | Matar 20 osos | 1 oso (se spawnea automáticamente) |

## Archivos a Modificar

### 1. `scripts/script_init/script_init.gml`
Agregar variables globales para tracking:
```gml
global.animals_killed = 0;
global.bears_killed = 0;
```

### 2. `objects/obj_wild_animal/Step_0.gml`
En el evento de muerte del animal (línea ~40), agregar:
```gml
global.animals_killed++;
if (animal_key == "bear") {
    global.bears_killed++;
    if (global.bears_killed >= 20 && instance_exists(obj_stable)) {
        var _stable = instance_find(obj_stable, 0);
        var _bear = instance_create_layer(_stable.x + 96, _stable.y + 64, "Instances", obj_horse1);
        _bear.is_bear = true;
    }
}
```

### 3. `scripts/script_player_actions/script_player_actions.gml` (líneas 788-794)
Modificar la construcción del establo:
- Verificar `global.animals_killed >= 100` antes de permitir construcción
- Solo spawnear 2 caballos (quitar spawn del oso)

```gml
// Cambiar de:
if (_building_name == "stable") {
    instance_create_layer(_x + 96, _y + 16, "Instances", obj_horse1);
    instance_create_layer(_x + 96, _y + 40, "Instances", obj_horse1);
    var _bear = instance_create_layer(_x + 96, _y + 64, "Instances", obj_horse1);
    _bear.is_bear = true;
}

// A:
if (_building_name == "stable") {
    if (global.animals_killed >= 100) {
        instance_create_layer(_x + 96, _y + 16, "Instances", obj_horse1);
        instance_create_layer(_x + 96, _y + 40, "Instances", obj_horse1);
    } else {
        // Mostrar mensaje de progreso
        scr_notify("Necesitas matar " + string(100 - global.animals_killed) + " animales más");
        return false;
    }
}
```

### 4. (Opcional) Verificar reseteo de monturas
El usuario menciona que al dormir las monturas se resetean al estado original. Necesita verificación adicional en `scr_sleep_and_save()`.

## Notas
- El oso se spawnea automáticamente al matar 20 osos, solo si el establo ya existe
- Los caballos y oso spawnan en las coordenadas relativas al establo: `_x + 96, _y + 16/40/64`
- El oso usa `obj_horse1` con la propiedad `is_bear = true`