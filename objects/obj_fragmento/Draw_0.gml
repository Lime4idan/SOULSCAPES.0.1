// Este é o fragmento livre da Room1 que se transforma na espada.
// Ele não pertence ao conjunto das quatro estátuas do vitral.
draw_self();

var aviso_bloqueado =
    (
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

if (pode_interagir && !aviso_bloqueado) {
    var aviso_cx = x;
    var aviso_cy = y - 155;
    var aviso_x1 = aviso_cx - 96;
    var aviso_y1 = aviso_cy - 22;
    var aviso_x2 = aviso_cx + 96;
    var aviso_y2 = aviso_cy + 22;

    draw_set_font(fnt_dialogo);

    // Sombra e cartão pastel.
    draw_set_alpha(0.18);
    draw_set_color(make_color_rgb(73, 70, 110));
    draw_roundrect(aviso_x1 + 3, aviso_y1 + 4, aviso_x2 + 3, aviso_y2 + 4, false);

    draw_set_alpha(0.94);
    draw_set_color(aviso_alto_contraste ? c_white : make_color_rgb(249, 244, 251));
    draw_roundrect(aviso_x1, aviso_y1, aviso_x2, aviso_y2, false);

    draw_set_alpha(0.76);
    draw_set_color(aviso_alto_contraste ? make_color_rgb(43, 34, 79) : make_color_rgb(139, 122, 185));
    draw_roundrect(aviso_x1, aviso_y1, aviso_x2, aviso_y2, true);

    // Tecla E destacada.
    draw_set_alpha(0.96);
    draw_set_color(make_color_rgb(222, 211, 244));
    draw_roundrect(aviso_x1 + 9, aviso_y1 + 7, aviso_x1 + 47, aviso_y2 - 7, false);

    draw_set_alpha(0.86);
    draw_set_color(make_color_rgb(121, 105, 171));
    draw_roundrect(aviso_x1 + 9, aviso_y1 + 7, aviso_x1 + 47, aviso_y2 - 7, true);

    draw_set_alpha(1);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(aviso_alto_contraste ? make_color_rgb(20, 20, 32) : make_color_rgb(76, 69, 119));
    draw_text(aviso_x1 + 28, aviso_cy, (variable_global_exists("mobile_mode") && global.mobile_mode) ? "!" : "E");

    draw_set_color(aviso_alto_contraste ? make_color_rgb(20, 20, 32) : make_color_rgb(64, 67, 101));
    draw_text((aviso_x1 + 51 + aviso_x2) / 2, aviso_cy, "Interagir");

    // Pequenos pontos de brilho.
    draw_set_alpha(0.78);
    draw_set_color(make_color_rgb(238, 196, 222));
    draw_circle(aviso_x2 - 12, aviso_y1 + 10, 3, false);
    draw_set_color(make_color_rgb(191, 235, 220));
    draw_circle(aviso_x2 - 8, aviso_y1 + 18, 2, false);
}

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
