function inventory_drop_item(_key, _qty, _px, _py, _delay = 15) {
    // 1. Crear el contenedor físico
    var _inst = instance_create_layer(_px, _py, "Instances", obj_item_parent);
    
    with(_inst) {
        item_key = _key;
        quantity = _qty;
        collect_delay = _delay; // Aplicar el delay personalizado
        
        // Definimos el "suelo" donde terminará el salto
        ystart_pos = _py; 
        
        // Físicas iniciales del "salto"
        vspeed = -2.5; 
        hspeed = random_range(-1, 1); 
        gravity = 0.15;
    }
}

function scr_notify(_text) {
    if (instance_exists(obj_controller)) {
        var _notif = {
            text: _text,
            timer: 120, // 2 segundos a 60fps
            alpha: 1.0
        };
        ds_list_add(obj_controller.notifications, _notif);
    }
}

