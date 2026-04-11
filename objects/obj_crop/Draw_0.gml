// Aseguramos que el frame visual sea el de la etapa actual
image_index = growth_stage;

// Dibujar la planta
draw_self();

// DEBUG VISUAL (Opcional: borra esto cuando funcione)
draw_text(x, y - 16, string(growth_stage) + "/" + string(days_passed));