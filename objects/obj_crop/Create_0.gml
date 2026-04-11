// --- VARIABLES DE INSTANCIA (Valores por defecto) ---
// Esto evita el error de "variable not set"
days_passed = 0;
growth_stage = 0;
is_watered = false;
skip_blank_frame = false; // <--- Fundamental para que no truene
crop_type = "";
days_to_grow = 1; 
max_stages = 1;

// --- FUNCIÓN GROW (Lógica de tiempo total) ---
grow = function() {
    if (is_watered) {
        days_passed += 1; 

        // Regla de tres: porcentaje de tiempo transcurrido por etapas totales
        var _ideal_stage = floor((days_passed / days_to_grow) * max_stages);
        
        // Asegurar que no exceda el límite de frames del sprite
        growth_stage = clamp(_ideal_stage, 0, max_stages);

        // Lógica visual para evitar el frame blanco (Pumpkin/Grapes)
        if (skip_blank_frame && growth_stage == 1) {
            image_index = 0; 
        } else {
            image_index = growth_stage;
        }

        show_debug_message("Planta: " + crop_type + " | Día: " + string(days_passed) + "/" + string(days_to_grow) + " | Stage: " + string(growth_stage));
        
        is_watered = false; // Se seca para el siguiente día
    }
}