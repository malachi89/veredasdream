// Verificar si existe partida para "Continuar"
save_exists = file_exists(global.save_file_path);

if (save_exists) {
    options = ["Continuar", "Nueva Granja", "Multijugador", "Borrar Granja", "Salir"];
} else {
    options = ["Nueva Granja", "Multijugador", "Continuar", "Borrar Granja", "Salir"];
}
selected_index = 0;

// Mensajes temporales
notif_text = "";
notif_timer = 0;
