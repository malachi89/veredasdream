if (instance_exists(obj_player)) {
    var _dist = point_distance(x, y, obj_player.x, obj_player.y);
    
    if (_dist < 48) {
        if (keyboard_check_pressed(ord("E"))) {
            with(obj_inventory) {
                show_shipping = !show_shipping;
                show_backpack = show_shipping; // Siempre abrir mochila si abrimos shipping
                
                // Si cerramos, devolvemos item en mano
                if (!show_shipping && held_item != -1) {
                    add_item(held_item.key, held_item.quantity);
                    held_item = -1;
                }
            }
        }
    } else {
        // Si el jugador se aleja demasiado, cerrar el menú
        with(obj_inventory) {
            if (show_shipping) {
                show_shipping = false;
                show_backpack = false;
                if (held_item != -1) {
                    add_item(held_item.key, held_item.quantity);
                    held_item = -1;
                }
            }
        }
    }
}
