/// @description Contenedor físico del ítem
item_key = "";     // Ejemplo: "onion_seeds"
quantity = 1;      // Cuántos hay en este montoncito
float_timer = irandom(100);

// Variables de dibujo que se llenarán solas
item_sprite = noone;
row = 0;
subimg = 0;
is_initialized = false;

// Guardamos la Y inicial para el "suelo" de la física de caída
ystart_pos = y;

// Tiempo de espera antes de que se pueda recoger (en frames, 60 fps aprox)
collect_delay = 15; 
magnetic_range = 24; // Radio de atracción magnética