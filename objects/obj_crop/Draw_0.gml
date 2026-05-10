var _draw_x = x;
var _draw_y = y;
var _current_sprite_index = -1;
var _current_image_index = growth_stage;

// Determine the crop sprite name
var _intended_sprite_name = "sprite_crop_" + crop_type;
var _intended_sprite_idx = asset_get_index(_intended_sprite_name);

if (_intended_sprite_idx != -1) { 
    _current_sprite_index = _intended_sprite_idx;
} else {
    _current_sprite_index = asset_get_index("sprite_crops_icons"); // Fallback
}

// Dibujar el cultivo
if (sprite_exists(_current_sprite_index)) {
    var _target_frame = max_stages; // El frame de madurez definido por el usuario
    var _current_image_index = 0;
    
    // 1. Mapeo de días a frames según las reglas solicitadas
    var _effective_days = min(days_passed, days_to_grow);
    
    if (_effective_days >= days_to_grow) {
        _current_image_index = _target_frame; // _target_frame es Días - 1
    } else {
        // OFFSET: El primer día de crecimiento (Día 1) muestra el mismo frame que la siembra (Día 0)
        var _display_days = max(0, _effective_days - 1);

        if (days_to_grow > _target_frame + 1) { 
            // Caso A: Tarda más días que frames definidos (repetir penúltimo)
            _current_image_index = min(_display_days, _target_frame - 1);
        } else if (days_to_grow < _target_frame + 1) {
            // Caso B: Tarda menos días que frames definidos (saltar frames proporcionalmente)
            _current_image_index = floor((_display_days / (days_to_grow - 1)) * _target_frame);
        } else {
            // Caso C: 1 día = 1 frame (con el offset de -1 día)
            _current_image_index = _display_days;
        }
    }
    
    // 2. Fix para "frames vacíos" (Autumn crops como Beetroot, Pumpkin, Grapes)
    // El frame vacío suele ser el segundo (índice 1). Si es así, repetimos el frame 0.
    if (skip_blank_frame && _current_image_index == 1) {
        _current_image_index = 0;
    }

    draw_sprite(_current_sprite_index, _current_image_index, _draw_x, _draw_y);
} else {
    // Fallback drawing (red square)
    draw_rectangle_color(x, y, x+15, y+15, c_red, c_red, c_red, c_red, false); 
}
