if (!instance_exists(target)) exit;

// posición objetivo (centrada)
var target_x = target.x - cam_width / 2;
var target_y = target.y - cam_height / 2;

// posición actual
var current_x = camera_get_view_x(cam);
var current_y = camera_get_view_y(cam);

// suavizado
var new_x = lerp(current_x, target_x, smooth);
var new_y = lerp(current_y, target_y, smooth);

// limitar al room (con soporte para rooms pequeñas)
if (room_width <= cam_width) {
    new_x = (room_width - cam_width) / 2;
} else {
    new_x = clamp(new_x, 0, room_width - cam_width);
}

if (room_height <= cam_height) {
    new_y = (room_height - cam_height) / 2;
} else {
    new_y = clamp(new_y, 0, room_height - cam_height);
}

// aplicar
camera_set_view_pos(cam, new_x, new_y);