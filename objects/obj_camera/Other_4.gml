// Al iniciar el cuarto, saltar instantáneamente al jugador
if (instance_exists(target)) {
    var _target_x = target.x - cam_width / 2;
    var _target_y = target.y - cam_height / 2;
    
    // Soporte para rooms pequeñas
    if (room_width <= cam_width) {
        _target_x = (room_width - cam_width) / 2;
    } else {
        _target_x = clamp(_target_x, 0, room_width - cam_width);
    }
    
    if (room_height <= cam_height) {
        _target_y = (room_height - cam_height) / 2;
    } else {
        _target_y = clamp(_target_y, 0, room_height - cam_height);
    }
    
    camera_set_view_pos(cam, _target_x, _target_y);
}

// Reactivar viewport por si acaso
view_enabled = true;
view_visible[0] = true;
view_camera[0] = cam;