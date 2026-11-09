if (pode_interagir) {

    var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();

    var cx = gui_w / 2;
    var cy = gui_h - 120;

    var caixa_w = 330;
    var caixa_h = 58;

    var x1 = cx - caixa_w / 2;
    var y1 = cy - caixa_h / 2;
    var x2 = cx + caixa_w / 2;
    var y2 = cy + caixa_h / 2;

    // sombra suave
    draw_set_alpha(0.15);
    draw_set_color(make_color_rgb(100, 115, 150));
    draw_roundrect(
        x1 + 2,
        y1 + 3,
        x2 + 2,
        y2 + 3,
        false
    );

    // fundo
    draw_set_alpha(0.88);
    draw_set_color(make_color_rgb(242, 245, 250));
    draw_roundrect(
        x1,
        y1,
        x2,
        y2,
        false
    );

    // borda
    draw_set_alpha(0.25);
    draw_set_color(make_color_rgb(145, 155, 185));
    draw_roundrect(
        x1,
        y1,
        x2,
        y2,
        true
    );

    // texto
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(75, 90, 125));

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_text(
        cx,
        cy,
        "E   Entrar"
    );

    // reset
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
    draw_set_color(c_white);
}
