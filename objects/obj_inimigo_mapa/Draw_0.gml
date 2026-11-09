if (global.inimigos_derrotados[inimigo_indice]) {
    exit;
}

var inimigo_sprite_mapa = sprite_mapa_personalizado;
if ((inimigo_sprite_mapa == -1 || !sprite_exists(inimigo_sprite_mapa))
    && sprite_index != -1 && sprite_exists(sprite_index)) {
    inimigo_sprite_mapa = sprite_index;
}
var controlador_visual = instance_find(obj_pause, 0);

if (
    (inimigo_sprite_mapa == -1 || !sprite_exists(inimigo_sprite_mapa))
    && instance_exists(controlador_visual)
) {
    inimigo_sprite_mapa = controlador_visual.sprites_mapa_inimigos[inimigo_indice];
}

var flutuar_inimigo = global.config_reduzir_animacoes
    ? 0
    : sin(tempo_visual) * 3;

draw_set_alpha(0.17);
draw_set_color(make_color_rgb(38, 45, 70));
draw_ellipse(x - 48, y + 51, x + 48, y + 68, false);

if (inimigo_sprite_mapa != -1 && sprite_exists(inimigo_sprite_mapa)) {
    var inimigo_w = max(1, sprite_get_width(inimigo_sprite_mapa));
    var inimigo_h = max(1, sprite_get_height(inimigo_sprite_mapa));
    var inimigo_escala_configurada = escala_mapa_personalizada;

    // Escala 1 no painel significa usar a configuração automática do índice.
    // Isso deixa os guardas grandes sem impedir ajustes manuais futuros.
    if (
        abs(inimigo_escala_configurada - 1) <= 0.001
        && instance_exists(controlador_visual)
    ) {
        inimigo_escala_configurada =
            controlador_visual.escalas_mapa_inimigos[inimigo_indice];
    }

    var inimigo_escala = min(120 / inimigo_w, 145 / inimigo_h)
        * inimigo_escala_configurada;
    var inimigo_x = x
        + (sprite_get_xoffset(inimigo_sprite_mapa) - inimigo_w * 0.5)
        * inimigo_escala;
    var inimigo_y = y + 65 + flutuar_inimigo
        + (sprite_get_yoffset(inimigo_sprite_mapa) - inimigo_h)
        * inimigo_escala;

    draw_set_alpha(1);
    draw_sprite_ext(
        inimigo_sprite_mapa,
        floor(tempo_visual) mod max(1, sprite_get_number(inimigo_sprite_mapa)),
        inimigo_x,
        inimigo_y,
        inimigo_escala,
        inimigo_escala,
        0,
        c_white,
        1
    );
}
else {
    var inimigo_cor = instance_exists(controlador_visual)
        ? controlador_visual.cores_inimigos[inimigo_indice]
        : make_color_rgb(205, 215, 242);

    draw_set_alpha(0.98);
    draw_set_color(make_color_rgb(247, 239, 244));
    draw_circle(x, y - 37 + flutuar_inimigo, 24, false);
    draw_set_color(inimigo_cor);
    draw_roundrect(x - 25, y - 10 + flutuar_inimigo,
        x + 25, y + 45 + flutuar_inimigo, false);
    draw_set_alpha(0.85);
    draw_set_color(make_color_rgb(72, 73, 111));
    draw_circle(x, y - 37 + flutuar_inimigo, 24, true);
    draw_roundrect(x - 25, y - 10 + flutuar_inimigo,
        x + 25, y + 45 + flutuar_inimigo, true);
}

draw_set_alpha(1);
draw_set_color(c_white);
