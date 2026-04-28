if (result == 0) {
    indicator_pos += indicator_speed * indicator_dir;
    
    if (indicator_pos >= 100) {
        indicator_pos = 100;
        indicator_dir = -1;
    } else if (indicator_pos <= 0) {
        indicator_pos = 0;
        indicator_dir = 1;
    }
    
    if (keyboard_check_pressed(vk_space) || keyboard_check_pressed(ord("Y"))) {
        var _hit = false;
        // Check current position
        if (abs(indicator_pos - hitbox_pos) <= hitbox_range) {
            _hit = true;
        } else {
            // Swept check: did we pass the hitbox in the last frame?
            // This ensures that at high speeds (like 24), we don't "jump" over the hitbox
            var _prev_pos = indicator_pos - (indicator_speed * indicator_dir);
            var _min_p = min(_prev_pos, indicator_pos);
            var _max_p = max(_prev_pos, indicator_pos);
            
            // If hitbox center is within the range of movement (expanded by hitbox_range)
            if (hitbox_pos >= _min_p - hitbox_range && hitbox_pos <= _max_p + hitbox_range) {
                _hit = true;
            }
        }
        
        if (_hit) {
            result = 1;
            if (script_exists(scr_notify)) {
                scr_notify("¡Excelente!");
            }
        } else {
            result = -1;
            if (script_exists(scr_notify)) {
                scr_notify("¡Fallaste!");
            }
        }
        timer_after = 60; // Wait 1 second before closing
    }
} else {
    timer_after--;
    if (timer_after <= 0) {
        instance_destroy();
    }
}
