// 1. Dibujo del Cursor Fantasma (Siempre visible para orientar al jugador)
draw_set_alpha(0.15);
draw_rectangle_color(gx, gy, gx + 15, gy + 15, c_white, c_white, c_white, c_white, true);
draw_set_alpha(1.0);

// 2. Dibujo del Selector de Rango (Solo si es herramienta/semilla válida)
if (show_selector) {
    // Relleno suave
    draw_set_alpha(0.3);
    draw_rectangle_color(gx, gy, gx + 15, gy + 15, selector_color, selector_color, selector_color, selector_color, false);
    
    // Borde más marcado
    draw_set_alpha(0.8);
    draw_rectangle_color(gx, gy, gx + 15, gy + 15, selector_color, selector_color, selector_color, selector_color, true);
    
    draw_set_alpha(1.0);
}