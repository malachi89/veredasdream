// Inherit the parent event
event_inherited();

if (item_sprite != noone) {
    // Calculamos la posición Y en la hoja de sprites
    var _y_offset = row * 16; 
    
    // Dibujamos solo el cuadrito de la semilla
    draw_sprite_part(
        item_sprite, 
        subimg, 
        0,          // X en la hoja (subimg 0 suele ser la semilla)
        _y_offset,  // Y en la hoja (la fila)
        16,         // Ancho del recorte
        16,         // Alto del recorte
        x - 8,      // Posición X en el mapa (centrado)
        y - 8       // Posición Y en el mapa (centrado)
    );
}

// Dibujar cantidad (Copiado del padre o mejorado)
if (quantity > 1) {
    draw_set_font(fnt_pixel_operator); // Usa la fuente pixelada personalizada
    draw_set_halign(fa_right);
    draw_text(x + 8, y, string(quantity));
}
