if (global.lightning_flash > 0) {
    draw_set_alpha(0.6);
    draw_rectangle_color(0, 0, display_get_gui_width(), display_get_gui_height(), c_white, c_white, c_white, c_white, false);
    draw_set_alpha(1.0);
}
