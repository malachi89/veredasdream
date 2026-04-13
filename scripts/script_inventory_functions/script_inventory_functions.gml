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

/// @function scr_draw_interact_prompt(x, y, text)
function scr_draw_interact_prompt(_x, _y, _text) {
    draw_set_font(fnt_pixel_operator);
    var _tw = string_width(_text);
    var _th = string_height(_text);
    var _pad = 4;
    
    var _x1 = _x - (_tw / 2) - _pad;
    var _y1 = _y - _th - (_pad * 2) - 8; // Elevado un poco
    var _x2 = _x + (_tw / 2) + _pad;
    var _y2 = _y - 8;
    
    // Dibujar fondo del globo
    draw_set_alpha(0.8);
    draw_roundrect_color_ext(_x1, _y1, _x2, _y2, 8, 8, c_black, c_black, false);
    draw_set_alpha(1.0);
    draw_roundrect_color_ext(_x1, _y1, _x2, _y2, 8, 8, c_white, c_white, true);
    
    // Dibujar el pequeño triángulo (cola del globo)
    draw_primitive_begin(pr_trianglelist);
    draw_vertex_color(_x - 4, _y2, c_black, 0.8);
    draw_vertex_color(_x + 4, _y2, c_black, 0.8);
    draw_vertex_color(_x, _y2 + 6, c_black, 0.8);
    draw_primitive_end();
    
    // Dibujar texto
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_color(_x, (_y1 + _y2) / 2, _text, c_white, c_white, c_white, c_white, 1.0);
}

