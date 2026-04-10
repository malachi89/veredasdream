/// @description Atributos base de cualquier ítem

// Identificación
item_id = -1;           // ID numérica o string para la base de datos
item_name = "";         // Nombre para mostrar
item_description = "";  // Texto de ayuda
item_sprite = noone;    // El sprite que se dibujará
item_quality = "";

// Clasificación (Reglas)
item_type = "material"; // "tool", "seed", "food", "weapon"
is_stackable = true;    // ¿Se pueden tener muchos en un mismo slot?
quantity = 1;           // Cantidad actual

// Comportamiento (Flags)
can_be_dropped = true;  // ¿Se puede tirar al suelo?
can_be_sold = true;     // ¿El mercader lo acepta?
item_price = 0;         // Valor en monedas

// Estadísticas de uso (opcional, según el tipo)
energy_restore = 0;     // Si es comida
tool_power = 0;         // Si es herramienta (ej: nivel de hacha)