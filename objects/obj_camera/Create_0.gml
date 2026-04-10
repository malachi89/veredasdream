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
cam = camera_create_view(0, 0, cam_width, cam_height, 0, -1, -1, -1, -1);

// asignar al viewport
view_enabled = true;
view_visible[0] = true;
view_camera[0] = cam;