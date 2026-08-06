draw_self();

if (pode_interagir) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_text(x, y - 60, "E - Interagir");

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}