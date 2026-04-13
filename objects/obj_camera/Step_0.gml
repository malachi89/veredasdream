if (!instance_exists(target)) exit;

// 1. Detección de redimensionamiento de ventana
var _win_w = window_get_width();
var _win_h = window_get_height();

// Ajustar el puerto de vista al tamaño de la ventana real
view_wport[0] = _win_w;
view_hport[0] = _win_h;
surface_resize(application_surface, _win_w, _win_h);

// 2. posición objetivo (centrada)
var target_x = target.x - cam_width / 2;
var target_y = target.y - cam_height / 2;

// 3. posición actual
var current_x = camera_get_view_x(cam);
var current_y = camera_get_view_y(cam);

// 4. suavizado
var new_x = lerp(current_x, target_x, smooth);
var new_y = lerp(current_y, target_y, smooth);

// 5. limitar al room
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

// 6. aplicar
camera_set_view_pos(cam, new_x, new_y);
