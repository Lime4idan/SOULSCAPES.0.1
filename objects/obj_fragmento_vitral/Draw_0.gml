if (false) {
var indice_seguro = clamp(
    indice_fragmento,
    0,
    3
);

var cor_fragmento =
    cores_fragmentos[indice_seguro];

var reduzir_animacoes =
    variable_global_exists("config_reduzir_animacoes")
    && global.config_reduzir_animacoes;

var baixo_estimulo =
    variable_global_exists("config_baixo_estimulo")
    && global.config_baixo_estimulo;

var intensidade_brilho = baixo_estimulo ? 0.42 : 1;

var flutuar =
    reduzir_animacoes
    ? 0
    : sin(tempo_animacao) * (baixo_estimulo ? 2 : 5);

var fx = x;
var fy = y + flutuar;

var alpha_fragmento = 1;


// Animação de coleta
if (coletando) {
    alpha_fragmento = clamp(
        tempo_coleta / 45,
        0,
        1
    );

    fy -= (45 - tempo_coleta) * 0.8;
}


// ═════════════════════════════════════════════
// BRILHO GRANDE
// ═════════════════════════════════════════════
draw_set_alpha(
    alpha_fragmento * 0.10 * intensidade_brilho
);

draw_set_color(cor_fragmento);

draw_circle(
    fx,
    fy,
    48 + (reduzir_animacoes ? 0 : sin(tempo_animacao) * 4),
    false
);


draw_set_alpha(
    alpha_fragmento * 0.18 * intensidade_brilho
);

draw_circle(
    fx,
    fy,
    36,
    false
);


// ═════════════════════════════════════════════
// CORPO DO CACO
// ═════════════════════════════════════════════
draw_set_alpha(
    alpha_fragmento * 0.95
);

draw_set_color(cor_fragmento);


// Metade esquerda
draw_triangle(
    fx,
    fy - 34,
    fx - 25,
    fy + 3,
    fx + 3,
    fy + 29,
    false
);


// Metade direita
draw_triangle(
    fx,
    fy - 34,
    fx + 27,
    fy - 2,
    fx + 3,
    fy + 29,
    false
);


// ═════════════════════════════════════════════
// CONTORNO
// ═════════════════════════════════════════════
draw_set_alpha(
    alpha_fragmento * 0.82
);

draw_set_color(
    make_color_rgb(68, 83, 112)
);

draw_line_width(
    fx,
    fy - 34,
    fx - 25,
    fy + 3,
    2
);

draw_line_width(
    fx - 25,
    fy + 3,
    fx + 3,
    fy + 29,
    2
);

draw_line_width(
    fx + 3,
    fy + 29,
    fx + 27,
    fy - 2,
    2
);

draw_line_width(
    fx + 27,
    fy - 2,
    fx,
    fy - 34,
    2
);


// ═════════════════════════════════════════════
// REFLEXO
// ═════════════════════════════════════════════
draw_set_alpha(
    alpha_fragmento * 0.60
);

draw_set_color(c_white);

draw_line_width(
    fx - 3,
    fy - 23,
    fx - 11,
    fy + 1,
    2
);


// Ponto brilhante
draw_set_alpha(
    alpha_fragmento * 0.72 * (baixo_estimulo ? 0.65 : 1)
);

draw_circle(
    fx - 6,
    fy - 14,
    3,
    false
);


// Restaurar
draw_set_alpha(1);
draw_set_color(c_white);
}

// Estátua provisória. Trocar este bloco por sprites depois não altera a lógica.
var estd_indice = clamp(indice_fragmento, 0, 3);
var estd_cor = cores_fragmentos[estd_indice];
var estd_reduzir = global.config_reduzir_animacoes;
var estd_baixo = global.config_baixo_estimulo;
var estd_intensidade = estd_baixo ? 0.55 : 1;
var estd_flutuar = estd_reduzir ? 0 : sin(tempo_animacao) * 3;
var estd_alpha = 1;
var estd_fragmento_alpha = coletando ? clamp(tempo_coleta / 60, 0, 1) : 1;
var estd_subir = coletando ? (60 - tempo_coleta) * 0.75 : 0;
var estd_fx = x;
var estd_fy = y - 83 + estd_flutuar - estd_subir;
var estd_sprite = fragmento_liberado
    ? estatua_sprite_sem_fragmento
    : estatua_sprite_com_fragmento;

// Artes definitivas das quatro estátuas que guardam os cacos. A escolha é
// feita no Draw porque o índice também pode ser definido no Creation Code da
// instância depois do Create Event.
var estd_sprites_padrao = [
    spr_estatua1,
    spr_estatua2,
    spr_estatua3,
    spr_estatua4
];

if (estd_sprite == -1) {
    estd_sprite = estd_sprites_padrao[estd_indice];
}

if (!fragmento_liberado && estd_sprite == -1 && estatua_sprite_personalizado != -1) {
    estd_sprite = estatua_sprite_personalizado;
}
if (!fragmento_liberado && estd_sprite == -1 && sprite_index != -1) {
    estd_sprite = sprite_index;
}

if (estd_sprite != -1 && sprite_exists(estd_sprite)) {
    var estd_sprite_w = max(1, sprite_get_width(estd_sprite));
    var estd_sprite_h = max(1, sprite_get_height(estd_sprite));
    var estd_escala_final = min(190 / estd_sprite_w, 220 / estd_sprite_h)
        * estatua_escala_sprite;
    var estd_sprite_x = x + estatua_offset_sprite_x
        + (sprite_get_xoffset(estd_sprite) - estd_sprite_w * 0.5)
        * estd_escala_final;
    var estd_sprite_y = y + estatua_offset_sprite_y + 28
        + (sprite_get_yoffset(estd_sprite) - estd_sprite_h)
        * estd_escala_final;

    draw_set_alpha(estd_alpha * 0.12 * estd_intensidade);
    draw_set_color(estd_cor);
    draw_circle(x, y - 55, 74, false);
    draw_set_alpha(estd_alpha);
    draw_sprite_ext(
        estd_sprite,
        floor(tempo_animacao * 4) mod max(1, sprite_get_number(estd_sprite)),
        estd_sprite_x,
        estd_sprite_y,
        estd_escala_final,
        estd_escala_final,
        0,
        fragmento_liberado
            ? make_color_rgb(218, 222, 225)
            : c_white,
        estd_alpha
    );
    draw_set_alpha(1);
    draw_set_color(c_white);
    exit;
}

draw_set_alpha(estd_alpha * 0.09 * estd_intensidade);
draw_set_color(estd_cor);
draw_circle(x, y - 66, 70, false);
draw_set_alpha(estd_alpha * 0.15 * estd_intensidade);
draw_circle(x, y - 66, 51, false);

// Monumento provisório limpo: base, coluna e nicho arredondado.
draw_set_alpha(estd_alpha * 0.96);
draw_set_color(make_color_rgb(203, 210, 224));
draw_roundrect(x - 58, y + 9, x + 58, y + 29, false);
draw_set_color(make_color_rgb(218, 222, 233));
draw_roundrect(x - 48, y - 4, x + 48, y + 17, false);
draw_set_color(make_color_rgb(230, 233, 241));
draw_roundrect(x - 37, y - 105, x + 37, y + 9, false);
draw_set_color(make_color_rgb(242, 243, 248));
draw_circle(x, y - 83, 31, false);

draw_set_alpha(estd_alpha * 0.72);
draw_set_color(make_color_rgb(91, 97, 137));
draw_roundrect(x - 58, y + 9, x + 58, y + 29, true);
draw_roundrect(x - 48, y - 4, x + 48, y + 17, true);
draw_roundrect(x - 37, y - 105, x + 37, y + 9, true);
draw_circle(x, y - 83, 31, true);

// Folhas esculpidas no pedestal.
draw_set_alpha(estd_alpha * 0.48);
draw_set_color(make_color_rgb(139, 164, 158));
draw_ellipse(x - 28, y - 1, x - 6, y + 11, false);
draw_ellipse(x + 6, y - 1, x + 28, y + 11, false);
draw_line(x, y + 15, x, y - 5);

// Fragmento guardado no nicho. Depois da coleta, apenas a estátua permanece.
if (!fragmento_liberado || coletando) {
    draw_set_alpha(estd_fragmento_alpha * 0.95);
    draw_set_color(estd_cor);
    draw_triangle(estd_fx, estd_fy - 25, estd_fx - 20, estd_fy + 2, estd_fx + 2, estd_fy + 23, false);
    draw_triangle(estd_fx, estd_fy - 25, estd_fx + 21, estd_fy, estd_fx + 2, estd_fy + 23, false);
    draw_set_alpha(estd_fragmento_alpha * 0.82);
    draw_set_color(make_color_rgb(68, 83, 112));
    draw_line_width(estd_fx, estd_fy - 25, estd_fx - 20, estd_fy + 2, 2);
    draw_line_width(estd_fx - 20, estd_fy + 2, estd_fx + 2, estd_fy + 23, 2);
    draw_line_width(estd_fx + 2, estd_fy + 23, estd_fx + 21, estd_fy, 2);
    draw_line_width(estd_fx + 21, estd_fy, estd_fx, estd_fy - 25, 2);
    draw_set_alpha(estd_fragmento_alpha * 0.64);
    draw_set_color(c_white);
    draw_line_width(estd_fx - 3, estd_fy - 16, estd_fx - 9, estd_fy + 1, 2);
}

draw_set_alpha(1);
draw_set_color(c_white);
