// --- VARIABLES DE INSTANCIA PARA CULTIVOS ---
days_passed = 0;
growth_stage = 0;
is_watered = false;
persistent_water = false;
skip_blank_frame = false;
crop_type = "";
days_to_grow = 1;
max_stages = 1;

// Asignar máscara de colisión (usamos los iconos que son 16x16)
mask_index = asset_get_index("sprite_crops_icons");

// --- LÓGICA DE CRECIMIENTO ---
grow = function() {
    if (is_watered) {
        days_passed += 1; 

        // Cálculo de etapa basado en el tiempo transcurrido
        var _ideal_stage = floor((days_passed / days_to_grow) * max_stages);
        growth_stage = clamp(_ideal_stage, 0, max_stages);

        // Evitar frame blanco en ciertos sprites (Pumpkin/Grapes)
        if (skip_blank_frame && growth_stage == 1) {
            image_index = 0; 
        } else {
            image_index = growth_stage;
        }

        is_watered = persistent_water;
    }
}