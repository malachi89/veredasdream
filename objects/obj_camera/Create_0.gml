// target (a quién sigue)
target = obj_player;

// tamaño de vista (zoom)
cam_width  = 640;
cam_height = 360;

// suavizado
smooth = 0.1;

// crear cámara
cam = camera_create_view(0, 0, cam_width, cam_height, 0, -1, -1, -1, -1);

// asignar al viewport
view_enabled = true;
view_visible[0] = true;
view_camera[0] = cam;