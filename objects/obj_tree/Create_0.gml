// --- VARIABLES DE INSTANCIA PARA ÁRBOLES ---
hits_remaining = 10;
days_passed = 0;
crop_type = "";
days_to_grow = 1; 
max_stages = 1;

fruit_cycle_days = 2; // Number of days to produce fruit after harvest
days_since_harvest = 0; // Counter for the fruiting cycle
has_fruit = false; // Flag to indicate if the tree has fruit
fruit_item = ""; // The item the tree produces (e.g., "orange", "apple")

// --- LÓGICA DE CRECIMIENTO ---
grow = function() {
    if (days_passed < max_stages) { // Initial growth phase (until maturity)
        days_passed += 1;
    } else { // Mature tree, manage fruiting
        days_since_harvest += 1;
        if (!has_fruit && days_since_harvest >= fruit_cycle_days) {
            has_fruit = true;
        }
    }
}