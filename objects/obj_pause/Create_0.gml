display_set_gui_size(1280, 811);

// O jogo sempre começa despausado
global.jogo_pausado = false;


// ═════════════════════════════════════════════
// CONFIGURAÇÕES GLOBAIS
// ═════════════════════════════════════════════
if (!variable_global_exists("config_volume_musica")) {
    global.config_volume_musica = 0.80;
}

if (!variable_global_exists("config_volume_sons")) {
    global.config_volume_sons = 0.70;
}

if (!variable_global_exists("config_baixo_estimulo")) {
    global.config_baixo_estimulo = false;
}

if (!variable_global_exists("config_reduzir_animacoes")) {
    global.config_reduzir_animacoes = false;
}

if (!variable_global_exists("config_velocidade_texto")) {
    global.config_velocidade_texto = 1;
}

if (!variable_global_exists("config_tamanho_texto")) {
    global.config_tamanho_texto = 1;
}

if (!variable_global_exists("config_contraste")) {
    global.config_contraste = 0;
}


// ═════════════════════════════════════════════
// TELAS
// ═════════════════════════════════════════════
tela_pause = 0;

// 0 = menu principal
// 1 = controles
// 2 = configurações
// 3 = pausa sensorial

opcao_pause = 0;
mouse_pause = -1;

tempo_pause = 0;
resp_tempo = 0;


// ═════════════════════════════════════════════
// BOTÕES DO MENU PRINCIPAL
// ═════════════════════════════════════════════
opcoes_pause = [
    "Pausa sensorial",
    "Continuar",
    "Controles",
    "Configurações",
    "Voltar ao menu"
];

botao_pause_y = [
    205,
    305,
    370,
    435,
    500
];

botao_pause_x1 = [
    405,
    475,
    475,
    475,
    475
];

botao_pause_x2 = [
    875,
    805,
    805,
    805,
    805
];

botao_pause_h = [
    70,
    50,
    50,
    50,
    50
];

hover_pause = [
    0,
    0,
    0,
    0,
    0
];


// ═════════════════════════════════════════════
// CONFIGURAÇÕES
// ═════════════════════════════════════════════
config_opcao_atual = 0;
config_mouse_sobre = -1;
config_arrastando = -1;


// ═════════════════════════════════════════════
// DESENHAR FOLHINHA
// ═════════════════════════════════════════════
desenhar_folha_pause = function(
    _x,
    _y,
    _alpha
) {
    var cor_folha = make_color_rgb(78, 105, 125);
    var cor_nervura = make_color_rgb(58, 82, 105);

    // Caule
    draw_set_alpha(_alpha * 0.80);
    draw_set_color(cor_nervura);

    draw_line_width(
        _x,
        _y + 10,
        _x + 2,
        _y - 10,
        1
    );

    // Folha esquerda
    draw_set_alpha(_alpha);
    draw_set_color(cor_folha);

    draw_ellipse(
        _x - 10,
        _y - 7,
        _x + 1,
        _y + 3,
        false
    );

    // Folha direita
    draw_ellipse(
        _x,
        _y - 13,
        _x + 12,
        _y - 2,
        false
    );

    // Nervuras
    draw_set_alpha(_alpha * 0.48);
    draw_set_color(cor_nervura);

    draw_line(
        _x - 7,
        _y - 3,
        _x,
        _y
    );

    draw_line(
        _x + 2,
        _y - 7,
        _x + 9,
        _y - 10
    );
};


// ═════════════════════════════════════════════
// DESENHAR TECLA
// ═════════════════════════════════════════════
desenhar_tecla_pause = function(
    _x,
    _y,
    _texto,
    _largura
) {
    var altura = 34;

    var cor_fundo_tecla =
        make_color_rgb(228, 230, 242);

    var cor_borda_tecla =
        make_color_rgb(101, 107, 157);

    var cor_texto_tecla =
        make_color_rgb(55, 63, 96);

    // Sombra
    draw_set_alpha(0.08);
    draw_set_color(cor_borda_tecla);

    draw_roundrect(
        _x + 2,
        _y + 3,
        _x + _largura + 2,
        _y + altura + 3,
        false
    );

    // Fundo
    draw_set_alpha(0.82);
    draw_set_color(cor_fundo_tecla);

    draw_roundrect(
        _x,
        _y,
        _x + _largura,
        _y + altura,
        false
    );

    // Borda
    draw_set_alpha(0.56);
    draw_set_color(cor_borda_tecla);

    draw_roundrect(
        _x,
        _y,
        _x + _largura,
        _y + altura,
        true
    );

    // Texto
    draw_set_alpha(1);
    draw_set_color(cor_texto_tecla);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_text(
        _x + _largura / 2,
        _y + altura / 2,
        _texto
    );
};