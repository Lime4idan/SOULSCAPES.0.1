var indice_seguro = clamp(
    indice_fragmento,
    0,
    3
);

var cor_fragmento =
    cores_fragmentos[indice_seguro];

var flutuar =
    sin(tempo_animacao) * 5;

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
    alpha_fragmento * 0.10
);

draw_set_color(cor_fragmento);

draw_circle(
    fx,
    fy,
    48 + sin(tempo_animacao) * 4,
    false
);


draw_set_alpha(
    alpha_fragmento * 0.18
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
    alpha_fragmento * 0.72
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