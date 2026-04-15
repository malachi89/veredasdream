// --- VARIABLES DE INSTANCIA ---
days_passed = 0;
growth_stage = 0;
is_watered = false;
skip_blank_frame = false; 
crop_type = "";
days_to_grow = 1; 
max_stages = 1;

is_fruit_tree = false;
fruit_cycle_days = 0; // Number of days to produce fruit after harvest
days_since_harvest = 0; // Counter for the fruiting cycle
has_fruit = false; // Flag to indicate if the tree has fruit
fruit_item = ""; // The item the tree produces (e.g., "orange", "apple")

// --- LÓGICA DE CRECIMIENTO ---
grow = function() {
    if (is_fruit_tree) {
        if (days_passed < max_stages) { // Initial growth phase (until maturity)
            days_passed += 1;
            // Sprite not updated here, done in Draw event.
        } else { // Mature tree, manage fruiting
            days_since_harvest += 1;
            if (!has_fruit && days_since_harvest >= fruit_cycle_days) {
                has_fruit = true;
                // Sprite not updated here, done in Draw event.
            }
        }
    } else {
        // Existing crop growth logic
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

            is_watered = false; 
        }
    }
}