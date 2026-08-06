display_set_gui_size(1280, 811);

// ─────────────────────────────────────────────
// POSIÇÃO GERAL DO MENU
// ─────────────────────────────────────────────
menu_centro_x = 665;

botao_w = 290;
botao_h = 58;

botao_y = [
    305, // Novo Jogo
    375, // Continuar
    445, // Configurações
    515  // Créditos
];

botao_texto = [
    "Novo Jogo",
    "Continuar",
    "Configurações",
    "Créditos"
];

// Continuar permanece bloqueado até criarmos o save
botao_ativo = [
    true,
    false,
    true,
    true
];

// ─────────────────────────────────────────────
// CONTROLE DO MENU
// ─────────────────────────────────────────────
opcao_atual = 0;
mouse_sobre = -1;

hover_anim = [0, 0, 0, 0];
click_anim = [0, 0, 0, 0];

tempo_menu = 0;

// Telas internas
mostrando_configuracoes = false;
mostrando_creditos = false;


// ─────────────────────────────────────────────
// CONFIGURAÇÕES
// ─────────────────────────────────────────────

// Volumes de 0 até 1
config_volume_musica = 0.80;
config_volume_sons = 0.70;

config_arrastando = -1;

// Opções de acessibilidade
config_baixo_estimulo = false;
config_reduzir_animacoes = false;

// 0 = Lenta | 1 = Normal | 2 = Rápida
config_velocidade_texto = 1;

// 0 = Pequeno | 1 = Normal | 2 = Grande
config_tamanho_texto = 1;

// 0 = Normal | 1 = Alto
config_contraste = 0;

// Linha atualmente selecionada
config_opcao_atual = 0;

// Detectar os controles com o mouse
config_mouse_sobre = -1;


// ─────────────────────────────────────────────
// MÚSICA DO MENU
// ─────────────────────────────────────────────
musica_menu_id = audio_play_sound(
    snd_musica_menu,
    0,
    true
);

audio_sound_gain(
    musica_menu_id,
    config_volume_musica,
    0
);


// ─────────────────────────────────────────────
// DESENHAR UMA FOLHA
// ─────────────────────────────────────────────
desenhar_folha = function(
    _cx,
    _cy,
    _angulo,
    _comprimento,
    _largura,
    _cor,
    _alpha
) {
    var dx = dcos(_angulo);
    var dy = dsin(_angulo);

    var nx = -dy;
    var ny = dx;

    var metade_comp = _comprimento / 2;
    var metade_larg = _largura / 2;

    var ponta_x = _cx + dx * metade_comp;
    var ponta_y = _cy + dy * metade_comp;

    var base_x = _cx - dx * metade_comp;
    var base_y = _cy - dy * metade_comp;

    var lado1_x = _cx + nx * metade_larg;
    var lado1_y = _cy + ny * metade_larg;

    var lado2_x = _cx - nx * metade_larg;
    var lado2_y = _cy - ny * metade_larg;

    draw_set_alpha(_alpha);
    draw_set_color(_cor);

    draw_triangle(
        ponta_x,
        ponta_y,
        lado1_x,
        lado1_y,
        base_x,
        base_y,
        false
    );

    draw_triangle(
        ponta_x,
        ponta_y,
        lado2_x,
        lado2_y,
        base_x,
        base_y,
        false
    );

    // Nervura da folha
    draw_set_alpha(_alpha * 0.65);

    draw_line_width(
        base_x,
        base_y,
        ponta_x,
        ponta_y,
        1
    );
};


// ─────────────────────────────────────────────
// AÇÃO DOS BOTÕES
// ─────────────────────────────────────────────
executar_opcao = function(_opcao) {
    switch (_opcao) {

        // NOVO JOGO
        case 0:
            global.dialogue_open = false;
            global.tem_fragmento = false;
            global.fragmento_reconhecido = false;

            // Parar a música do menu
            if (audio_is_playing(musica_menu_id)) {
                audio_stop_sound(musica_menu_id);
            }

            room_goto(Room1);
        break;


        // CONTINUAR
        case 1:
            // Será programado quando criarmos o save
        break;


        // CONFIGURAÇÕES
        case 2:
            mostrando_configuracoes = true;
            mostrando_creditos = false;
        break;


        // CRÉDITOS
        case 3:
            mostrando_creditos = true;
            mostrando_configuracoes = false;
        break;
    }
};