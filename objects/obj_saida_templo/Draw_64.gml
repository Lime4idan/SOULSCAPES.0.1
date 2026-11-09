var aviso_bloqueado =
    !pode_sair
    || (
        variable_global_exists("jogo_pausado")
        && global.jogo_pausado
    )
    || (
        variable_global_exists("dialogue_open")
        && global.dialogue_open
    );

var aviso_alto_contraste =
    variable_global_exists("config_contraste")
    && global.config_contraste >= 1;

if (!aviso_bloqueado) {
    var cx = display_get_gui_width() / 2;
    var cy = display_get_gui_height() - 120;
    var caixa_w = 350;
    var caixa_h = 58;
    var x1 = cx - caixa_w / 2;
    var y1 = cy - caixa_h / 2;
    var x2 = cx + caixa_w / 2;
    var y2 = cy + caixa_h / 2;

    draw_set_font(fnt_dialogo);

    draw_set_alpha(0.18);
    draw_set_color(make_color_rgb(73, 70, 110));
    draw_roundrect(x1 + 3, y1 + 4, x2 + 3, y2 + 4, false);

    draw_set_alpha(0.94);
    draw_set_color(aviso_alto_contraste ? c_white : make_color_rgb(249, 244, 251));
    draw_roundrect(x1, y1, x2, y2, false);

    draw_set_alpha(0.76);
    draw_set_color(aviso_alto_contraste ? make_color_rgb(43, 34, 79) : make_color_rgb(139, 122, 185));
    draw_roundrect(x1, y1, x2, y2, true);

    draw_set_alpha(0.96);
    draw_set_color(make_color_rgb(222, 211, 244));
    draw_roundrect(x1 + 12, y1 + 10, x1 + 56, y2 - 10, false);

    draw_set_alpha(0.86);
    draw_set_color(make_color_rgb(121, 105, 171));
    draw_roundrect(x1 + 12, y1 + 10, x1 + 56, y2 - 10, true);

    draw_set_alpha(1);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(aviso_alto_contraste ? make_color_rgb(20, 20, 32) : make_color_rgb(76, 69, 119));
    draw_text(x1 + 34, cy, (variable_global_exists("mobile_mode") && global.mobile_mode) ? "!" : "E");

    draw_set_color(aviso_alto_contraste ? make_color_rgb(20, 20, 32) : make_color_rgb(64, 67, 101));
    draw_text((x1 + 60 + x2) / 2, cy, "Sair do templo");

    draw_set_alpha(0.78);
    draw_set_color(make_color_rgb(238, 196, 222));
    draw_circle(x2 - 14, y1 + 12, 4, false);
    draw_set_color(make_color_rgb(191, 235, 220));
    draw_circle(x2 - 9, y1 + 22, 2, false);
}

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
