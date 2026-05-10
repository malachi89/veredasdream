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
        growth_stage = days_passed; // Mantener 1:1 para lógica de cosecha
        is_watered = persistent_water;
    }
}