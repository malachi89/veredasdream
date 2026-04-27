if (result == 0) {
    indicator_pos += indicator_speed * direction;
    
    if (indicator_pos >= 100) {
        indicator_pos = 100;
        direction = -1;
        bounces++;
    } else if (indicator_pos <= 0) {
        indicator_pos = 0;
        direction = 1;
        bounces++;
    }
    
    // Auto-fail if player waits too long
    if (bounces >= max_bounces) {
        result = -1;
        if (script_exists(scr_notify)) {
            scr_notify("¡Muy lento!");
        }
        timer_after = 60;
    }
    
    if (keyboard_check_pressed(vk_space)) {
        if (abs(indicator_pos - hitbox_pos) <= hitbox_range) {
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
