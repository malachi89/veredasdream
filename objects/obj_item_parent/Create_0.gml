/// @description Contenedor fisico del item
item_key = "";
quantity = 1;
float_timer = irandom(100);

// Variables de dibujo que se llenaran solas
item_sprite = noone;
row = 0;
subimg = 0;
is_initialized = false;

// Guardamos la Y inicial para el "suelo" de la fisica de caida
ystart_pos = y;

// Tiempo de espera antes de que se pueda recoger
collect_delay = 15;
magnetic_range = 24;

// Persistencia del item tirado
persistent_drop_id = -1;
source_room_name = room_get_name(room);
