/// @description Interaccion con el cofre
if (instance_exists(obj_player)) {
    var _dist = point_distance(x + 8, y + 8, obj_player.x, obj_player.y);
    
    if (_dist < 32) {
        // Abrir/Cerrar con E
        if (keyboard_check_pressed(ord("E"))) {
            is_open = !is_open;
            if (is_open) {
                obj_inventory.show_backpack = true;
                obj_inventory.show_shipping = false;
                obj_inventory.show_chest = true;
                obj_inventory.current_chest_id = id;
            } else {
                obj_inventory.show_backpack = false;
                obj_inventory.show_chest = false;
                obj_inventory.current_chest_id = noone;
                
                // Devolver item en mano si existe
                if (obj_inventory.held_item != -1) {
                    obj_inventory.add_item(obj_inventory.held_item.key, obj_inventory.held_item.quantity);
                    obj_inventory.held_item = -1;
                }
            }
        }
        
        // Recoger con Click Derecho si esta vacio
        if (mouse_check_button_pressed(mb_right) && !obj_inventory.show_backpack) {
            var _is_empty = true;
            for (var i = 0; i < 64; i++) {
                if (storage_array[i] != -1) {
                    _is_empty = false;
                    break;
                }
            }
            
            if (_is_empty) {
                if (obj_inventory.add_item("chest", 1)) {
                    scr_notify("Cofre recogido");
                    instance_destroy();
                } else {
                    scr_notify("Inventario lleno");
                }
            } else {
                scr_notify("Vacia el cofre antes de recogerlo");
            }
        }
    } else if (is_open) {
        // Cerrar si se aleja
        is_open = false;
        if (obj_inventory.current_chest_id == id) {
            obj_inventory.show_backpack = false;
            obj_inventory.show_chest = false;
            obj_inventory.current_chest_id = noone;
            
            // Devolver item en mano si existe
            if (obj_inventory.held_item != -1) {
                obj_inventory.add_item(obj_inventory.held_item.key, obj_inventory.held_item.quantity);
                obj_inventory.held_item = -1;
            }
        }
    }
}

image_speed = 0;
image_index = is_open ? 8 : 0;
depth = -bbox_bottom;
