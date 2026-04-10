// Heredamos las variables del padre (id, name, etc.)
event_inherited();

// Variables específicas de semillas
item_type = ITEM_TYPE.SEED;
is_stackable = true;

// Función para inicializar los datos desde tu script_init
function init_item(_seed_key) {
    var _data = global.seed_data[$ _seed_key];
    
    if (_data != undefined) {
        item_id = _seed_key;
        item_name = _data.name;
        item_sprite = _data.sprite;
        row = _data.row;
        subimg = _data.subimg;
        
        // Aquí podrías añadir info extra si la ocupas, como el precio:
        item_price = 10; 
    } else {
        show_debug_message("Error: La semilla " + string(_seed_key) + " no existe en global.item_data");
        instance_destroy(); // Si no existe, mejor borrarla para evitar errores
    }
}