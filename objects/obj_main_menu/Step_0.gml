// Navegación
if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) {
    selected_index -= 1;
    if (selected_index < 0) selected_index = array_length(options) - 1;
}
if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
    selected_index += 1;
    if (selected_index >= array_length(options)) selected_index = 0;
}

// Selección
if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
    var _choice = options[selected_index];
    
    switch (_choice) {
        case "Nueva Granja":
            // Iniciar nueva partida
            if (instance_exists(obj_controller)) {
                obj_controller.pending_loaded_game = undefined;
                obj_controller.load_needs_apply = false;
            }
            room_goto(farm);
            break;
            
        case "Multijugador":
            notif_text = "Multijugador no implementado todavía.";
            notif_timer = 120;
            break;
            
        case "Continuar":
            if (save_exists) {
                var _data = scr_read_save_game();
                if (is_struct(_data)) {
                    if (instance_exists(obj_controller)) {
                        obj_controller.pending_loaded_game = _data;
                        obj_controller.load_needs_apply = true;
                    }
                    var _target_room = asset_get_index(_data.player.room_name);
                    if (_target_room != -1) {
                        room_goto(_target_room);
                    } else {
                        room_goto(farm);
                    }
                }
            } else {
                notif_text = "No se encontró partida guardada.";
                notif_timer = 120;
            }
            break;
            
        case "Borrar Granja":
            if (save_exists) {
                file_delete(global.save_file_path);
                save_exists = false;
                if (instance_exists(obj_controller)) {
                    obj_controller.pending_loaded_game = undefined;
                    obj_controller.load_needs_apply = false;
                }
                notif_text = "Partida borrada con éxito.";
                notif_timer = 120;
            } else {
                notif_text = "No hay partida que borrar.";
                notif_timer = 120;
            }
            break;
            
        case "Salir":
            game_end();
            break;
    }
}

// Actualizar notificación
if (notif_timer > 0) {
    notif_timer -= 1;
} else {
    notif_text = "";
}
