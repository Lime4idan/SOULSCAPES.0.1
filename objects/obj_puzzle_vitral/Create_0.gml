// ═════════════════════════════════════════════
// VARIÁVEIS GLOBAIS
// ═════════════════════════════════════════════
if (!variable_global_exists("vitral_resolvido")) {
    global.vitral_resolvido = false;
}

if (!variable_global_exists("fragmentos_vitral")) {
    global.fragmentos_vitral = [
        false,
        false,
        false,
        false
    ];
}

if (!variable_global_exists("dialogue_open")) {
    global.dialogue_open = false;
}

if (!variable_global_exists("config_reduzir_animacoes")) {
    global.config_reduzir_animacoes = false;
}


// ═════════════════════════════════════════════
// INTERAÇÃO COM KIRAN
// ═════════════════════════════════════════════
distancia_interacao = 115;

perto_do_vitral = false;
puzzle_ativo = false;


// ═════════════════════════════════════════════
// CONTROLE DO PUZZLE
// ═════════════════════════════════════════════
peca_arrastada = -1;

offset_mouse_x = 0;
offset_mouse_y = 0;

raio_clique = 64;
distancia_encaixe = 62;

tempo_puzzle = 0;

concluindo_puzzle = false;
tempo_conclusao = 0;


// ═════════════════════════════════════════════
// POSIÇÕES INICIAIS DAS PEÇAS
// Faixa inferior do puzzle
// ═════════════════════════════════════════════
peca_inicio_x = [
    400,
    560,
    720,
    880
];

peca_inicio_y = [
    620,
    620,
    620,
    620
];


// ═════════════════════════════════════════════
// POSIÇÕES CORRETAS NO VITRAL
// ═════════════════════════════════════════════
peca_alvo_x = [
    640, // superior
    525, // esquerda
    755, // direita
    640  // inferior
];

peca_alvo_y = [
    270,
    405,
    405,
    515
];


// ═════════════════════════════════════════════
// POSIÇÃO ATUAL DAS PEÇAS
// ═════════════════════════════════════════════
peca_x = [
    peca_inicio_x[0],
    peca_inicio_x[1],
    peca_inicio_x[2],
    peca_inicio_x[3]
];

peca_y = [
    peca_inicio_y[0],
    peca_inicio_y[1],
    peca_inicio_y[2],
    peca_inicio_y[3]
];


// ═════════════════════════════════════════════
// ESTADO DAS PEÇAS
// ═════════════════════════════════════════════
peca_colocada = [
    false,
    false,
    false,
    false
];


// ═════════════════════════════════════════════
// CORES DOS FRAGMENTOS
// ═════════════════════════════════════════════
cores_fragmentos = [
    make_color_rgb(145, 184, 196),
    make_color_rgb(170, 177, 207),
    make_color_rgb(173, 194, 176),
    make_color_rgb(192, 174, 203)
];


// ═════════════════════════════════════════════
// FUNÇÃO PARA DESENHAR FRAGMENTOS
// ═════════════════════════════════════════════
desenhar_fragmento = function(
    _indice,
    _x,
    _y,
    _cor,
    _alpha,
    _cor_borda,
    _alpha_borda
) {
    draw_set_alpha(_alpha);
    draw_set_color(_cor);

    switch (_indice) {

        // Fragmento superior
        case 0:
            draw_triangle(
                _x,
                _y - 54,
                _x - 42,
                _y + 15,
                _x,
                _y + 46,
                false
            );

            draw_triangle(
                _x,
                _y - 54,
                _x + 42,
                _y + 15,
                _x,
                _y + 46,
                false
            );
        break;


        // Fragmento esquerdo
        case 1:
            draw_triangle(
                _x - 52,
                _y - 28,
                _x + 17,
                _y - 46,
                _x + 40,
                _y + 24,
                false
            );

            draw_triangle(
                _x - 52,
                _y - 28,
                _x + 40,
                _y + 24,
                _x - 24,
                _y + 49,
                false
            );
        break;


        // Fragmento direito
        case 2:
            draw_triangle(
                _x + 52,
                _y - 28,
                _x - 17,
                _y - 46,
                _x - 40,
                _y + 24,
                false
            );

            draw_triangle(
                _x + 52,
                _y - 28,
                _x - 40,
                _y + 24,
                _x + 24,
                _y + 49,
                false
            );
        break;


        // Fragmento inferior
        case 3:
            draw_triangle(
                _x - 42,
                _y - 42,
                _x + 42,
                _y - 42,
                _x + 27,
                _y + 49,
                false
            );

            draw_triangle(
                _x - 42,
                _y - 42,
                _x + 27,
                _y + 49,
                _x - 27,
                _y + 49,
                false
            );
        break;
    }


    // Contorno
    draw_set_alpha(_alpha_borda);
    draw_set_color(_cor_borda);

    switch (_indice) {

        case 0:
            draw_line_width(
                _x,
                _y - 54,
                _x - 42,
                _y + 15,
                2
            );

            draw_line_width(
                _x - 42,
                _y + 15,
                _x,
                _y + 46,
                2
            );

            draw_line_width(
                _x,
                _y + 46,
                _x + 42,
                _y + 15,
                2
            );

            draw_line_width(
                _x + 42,
                _y + 15,
                _x,
                _y - 54,
                2
            );
        break;


        case 1:
            draw_line_width(
                _x - 52,
                _y - 28,
                _x + 17,
                _y - 46,
                2
            );

            draw_line_width(
                _x + 17,
                _y - 46,
                _x + 40,
                _y + 24,
                2
            );

            draw_line_width(
                _x + 40,
                _y + 24,
                _x - 24,
                _y + 49,
                2
            );

            draw_line_width(
                _x - 24,
                _y + 49,
                _x - 52,
                _y - 28,
                2
            );
        break;


        case 2:
            draw_line_width(
                _x + 52,
                _y - 28,
                _x - 17,
                _y - 46,
                2
            );

            draw_line_width(
                _x - 17,
                _y - 46,
                _x - 40,
                _y + 24,
                2
            );

            draw_line_width(
                _x - 40,
                _y + 24,
                _x + 24,
                _y + 49,
                2
            );

            draw_line_width(
                _x + 24,
                _y + 49,
                _x + 52,
                _y - 28,
                2
            );
        break;


        case 3:
            draw_line_width(
                _x - 42,
                _y - 42,
                _x + 42,
                _y - 42,
                2
            );

            draw_line_width(
                _x + 42,
                _y - 42,
                _x + 27,
                _y + 49,
                2
            );

            draw_line_width(
                _x + 27,
                _y + 49,
                _x - 27,
                _y + 49,
                2
            );

            draw_line_width(
                _x - 27,
                _y + 49,
                _x - 42,
                _y - 42,
                2
            );
        break;
    }


    // Reflexo interno delicado
    draw_set_alpha(_alpha * 0.28);
    draw_set_color(c_white);

    draw_line_width(
        _x - 8,
        _y - 24,
        _x + 5,
        _y + 13,
        2
    );
};


// ═════════════════════════════════════════════
// CARREGAR ESTADO RESOLVIDO
// ═════════════════════════════════════════════
if (global.vitral_resolvido) {
    for (
        var carregar_i = 0;
        carregar_i < array_length(peca_colocada);
        carregar_i++
    ) {
        peca_colocada[carregar_i] = true;

        peca_x[carregar_i] =
            peca_alvo_x[carregar_i];

        peca_y[carregar_i] =
            peca_alvo_y[carregar_i];
    }
}