// Difficulty mapping
switch (animal_type) {
    case "chicken":
    case "duck":
        catch_difficulty = 0; // Easy
        break;
    case "goat":
    case "pig":
    case "sheep":
        catch_difficulty = 1; // Moderate
        break;
    case "cow":
    case "ostrich":
        catch_difficulty = 2; // Hard
        break;
    default:
        catch_difficulty = 0; // Default to Easy
}

animal_type = (init_animal_type != "") ? init_animal_type : "chicken";
variant     = (init_variant     != "") ? init_variant     : "white";

sprite_anim = asset_get_index("sprite_" + animal_type + "_" + variant);
if (sprite_anim == -1) {
    show_debug_message("obj_farm_animal: sprite no encontrado para " + animal_type + "_" + variant);
    sprite_anim = sprite_chicken_white;
}
frame_count = sprite_get_number(sprite_anim); // 36 o 32

state      = ANIMAL_STATE.IDLE;
dir        = DIR.DOWN;
frame_anim = 0;

var _data  = global.animal_data[$ animal_type];
move_speed = (_data != undefined) ? _data.move_speed : 0.6;

// idle_type: 0=Derecha, 1=Izquierda, 2=Tipo1, 3=Tipo2, 4=Tipo3 (solo strip36)
idle_type  = irandom(4);
if (frame_count == 32 && idle_type > 3) idle_type = 3;

idle_timer       = irandom_range(120, 300);
wander_steps     = 0;
max_wander_steps = irandom_range(60, 180);

hp               = 3;
max_hp           = 3;
flee_timer       = 0;
hurt_flash_timer = 0;
is_panicked      = false;
