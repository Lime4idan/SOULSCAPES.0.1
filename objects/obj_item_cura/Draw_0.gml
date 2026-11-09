var item_bob = global.config_reduzir_animacoes ? 0 : sin(tempo_item) * 5;
var item_y = y + item_bob;
var item_alpha = coletado
    ? clamp(tempo_coleta / 30, 0, 1)
    : 1;
var item_escala_coleta = coletado
    ? 1 + (1 - item_alpha) * 0.24
    : 1;
var item_baixo = global.config_baixo_estimulo;

// Aura discreta, menor em baixo estímulo.
draw_set_alpha(item_alpha * (item_baixo ? 0.06 : 0.11));
draw_set_color(cor_tematica);
draw_circle(x, item_y, 42 * item_escala_coleta, false);
draw_set_alpha(item_alpha * (item_baixo ? 0.10 : 0.18));
draw_circle(x, item_y, 27 * item_escala_coleta, false);

if (sprite_personalizado != -1 && sprite_exists(sprite_personalizado)) {
    draw_set_alpha(item_alpha);
    draw_sprite_ext(
        sprite_personalizado,
        floor(tempo_item * 4) mod max(1, sprite_get_number(sprite_personalizado)),
        x + offset_sprite_x,
        item_y + offset_sprite_y,
        escala_sprite * item_escala_coleta,
        escala_sprite * item_escala_coleta,
        0,
        c_white,
        item_alpha
    );
}
else {
    var item_contorno = make_color_rgb(73, 79, 119);
    var item_escala = item_escala_coleta;

    draw_set_alpha(item_alpha * 0.96);
    draw_set_color(cor_tematica);

    if (tipo_item == 0) {
        // Gota lapidada.
        draw_triangle(x, item_y - 27 * item_escala,
            x - 18 * item_escala, item_y + 6 * item_escala,
            x, item_y + 22 * item_escala, false);
        draw_triangle(x, item_y - 27 * item_escala,
            x + 18 * item_escala, item_y + 6 * item_escala,
            x, item_y + 22 * item_escala, false);
        draw_set_alpha(item_alpha * 0.48);
        draw_set_color(c_white);
        draw_triangle(x, item_y - 20 * item_escala,
            x - 11 * item_escala, item_y + 4 * item_escala,
            x, item_y + 2 * item_escala, false);
    }
    else if (tipo_item == 1) {
        // Fruto rosado com folha facetada.
        draw_circle(x - 7 * item_escala, item_y + 3 * item_escala, 17 * item_escala, false);
        draw_circle(x + 8 * item_escala, item_y + 4 * item_escala, 16 * item_escala, false);
        draw_set_color(make_color_rgb(134, 190, 157));
        draw_triangle(x, item_y - 11 * item_escala,
            x + 5 * item_escala, item_y - 28 * item_escala,
            x + 23 * item_escala, item_y - 21 * item_escala, false);
    }
    else {
        // Seiva em cristal estrelado.
        draw_triangle(x, item_y - 29 * item_escala,
            x - 14 * item_escala, item_y + 3 * item_escala,
            x, item_y + 25 * item_escala, false);
        draw_triangle(x, item_y - 29 * item_escala,
            x + 14 * item_escala, item_y + 3 * item_escala,
            x, item_y + 25 * item_escala, false);
        draw_triangle(x - 25 * item_escala, item_y - 2 * item_escala,
            x + 25 * item_escala, item_y - 2 * item_escala,
            x, item_y + 13 * item_escala, false);
    }

    draw_set_alpha(item_alpha * 0.82);
    draw_set_color(item_contorno);
    draw_circle(x, item_y, 25 * item_escala, true);
}

if (!item_baixo && !coletado) {
    draw_set_alpha(0.48 + sin(tempo_item * 1.7) * 0.12);
    draw_set_color(c_white);
    draw_circle(x - 29, item_y - 20, 2, false);
    draw_circle(x + 31, item_y - 4, 3, false);
    draw_circle(x + 20, item_y + 27, 2, false);
}

draw_set_alpha(1);
draw_set_color(c_white);
