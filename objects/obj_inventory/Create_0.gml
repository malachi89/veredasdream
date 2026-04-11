display_set_gui_size(window_get_width(), window_get_height());

gui_scale = 1.7; 
slot_size = 32 * gui_scale; 
spacing = 2 * gui_scale;    
margin_bottom = 10 * gui_scale; 

inventory_array = [
    "watering_can", 
    "pickaxe", 
    "axe", 
    "sickle", 
    "hoe", 
    "bow", 
    "shovel", 
    "sword", 
    "bugnet", 
    "tomato_seeds"
]; 

total_slots = array_length(inventory_array);
selected_slot = 0; 

// Centrado
var _menu_total_width = (total_slots * slot_size) + ((total_slots - 1) * spacing);
menu_x_start = (display_get_gui_width() / 2) - (_menu_total_width / 2);
menu_y_start = display_get_gui_height() - slot_size - margin_bottom;