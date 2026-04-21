// Layout (must match Draw event)
var _cx = display_get_gui_width() * 0.5;
var _cy = display_get_gui_height() * 0.5;
var _start_y = _cy - 50;
var _spacing = 40;

// Mouse hover — update selected_index when cursor is over an option
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _hit_w = 300;
var _hit_h = 32;
var _mouse_on_option = false;

for (var i = 0; i < array_length(options); i++) {
    var _oy = _start_y + i * _spacing;
    if (_mx >= _cx - _hit_w * 0.5 && _mx <= _cx + _hit_w * 0.5 &&
        _my >= _oy - _hit_h * 0.5 && _my <= _oy + _hit_h * 0.5) {
        selected_index = i;
        _mouse_on_option = true;
        break;
    }
}

// Navegación con teclado
if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) {
    selected_index -= 1;
    if (selected_index < 0) selected_index = array_length(options) - 1;
}
if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
    selected_index += 1;
    if (selected_index >= array_length(options)) selected_index = 0;
}

// Confirmar con teclado o clic sobre la opción resaltada
var _confirm = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)
             || (_mouse_on_option && mouse_check_button_pressed(mb_left));

if (_confirm) {
    var _choice = options[selected_index];

    switch (_choice) {
        case "Nueva Granja":
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
