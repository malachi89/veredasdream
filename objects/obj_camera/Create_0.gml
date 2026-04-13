if (instance_number(obj_camera) > 1) {
    instance_destroy();
    exit;
}

// target (a quién sigue)
target = obj_player;

// tamaño de cámara (16:9)
cam_width  = 640;
cam_height = 360;

// tamaño del viewport (MISMA proporción)
view_wport[0] = 1280;
view_hport[0] = 720;

// 🔥 MUY IMPORTANTE: igualar application_surface
surface_resize(application_surface, 1280, 720);

// opcional pero recomendado: tamaño de ventana
window_set_size(1280, 720);

// suavizado
smooth = 0.1;

// crear cámara
// Iniciarla centrada en el jugador de una vez
var _start_x = 0;
var _start_y = 0;

if (instance_exists(target)) {
    _start_x = clamp(target.x - cam_width/2, 0, room_width - cam_width);
    _start_y = clamp(target.y - cam_height/2, 0, room_height - cam_height);
}

cam = camera_create_view(_start_x, _start_y, cam_width, cam_height, 0, -1, -1, -1, -1);

// asignar al viewport
view_enabled = true;
view_visible[0] = true;
view_camera[0] = cam;