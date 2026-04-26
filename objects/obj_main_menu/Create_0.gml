save_exists = file_exists(global.save_file_path);

if (save_exists) {
    options = ["Continuar", "Nueva Granja", "Hospedar", "Unirse", "Borrar Granja", "Salir"];
} else {
    options = ["Nueva Granja", "Hospedar", "Unirse", "Borrar Granja", "Salir"];
}
selected_index = 0;

notif_text  = "";
notif_timer = 0;

// IP entry state (shown when "Unirse" is selected)
ip_entry_mode = false;
ip_text       = "";
connect_waiting = false; // true while waiting for HANDSHAKE_ACK + snapshot
