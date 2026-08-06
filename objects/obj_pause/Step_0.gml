// ═════════════════════════════════════════════
// GARANTIR QUE A VARIÁVEL EXISTA
// ═════════════════════════════════════════════
if (!variable_global_exists("jogo_pausado")) {
    global.jogo_pausado = false;
}


// ═════════════════════════════════════════════
// ABRIR O MENU DE PAUSA
// ═════════════════════════════════════════════
if (!global.jogo_pausado) {
    if (keyboard_check_pressed(vk_escape)) {
        global.jogo_pausado = true;

        tela_pause = 0;
        opcao_pause = 0;
        mouse_pause = -1;

        config_arrastando = -1;
    }

    exit;
}


// ═════════════════════════════════════════════
// ANIMAÇÕES
// ═════════════════════════════════════════════
if (!global.config_reduzir_animacoes) {
    tempo_pause += 0.08;
}


// ═════════════════════════════════════════════
// MOUSE NA GUI
// ═════════════════════════════════════════════
var mouse_gui_x = device_mouse_x_to_gui(0);
var mouse_gui_y = device_mouse_y_to_gui(0);


// ═════════════════════════════════════════════
// TELA DE CONTROLES
// ═════════════════════════════════════════════
if (tela_pause == 1) {
    var controles_voltar_x1 = 515;
    var controles_voltar_y1 = 590;
    var controles_voltar_x2 = 765;
    var controles_voltar_y2 = 646;

    var controles_mouse_voltar = point_in_rectangle(
        mouse_gui_x,
        mouse_gui_y,
        controles_voltar_x1,
        controles_voltar_y1,
        controles_voltar_x2,
        controles_voltar_y2
    );

    if (
        keyboard_check_pressed(vk_escape)
        || keyboard_check_pressed(vk_backspace)
        || keyboard_check_pressed(ord("E"))
        || (
            controles_mouse_voltar
            && mouse_check_button_pressed(mb_left)
        )
    ) {
        tela_pause = 0;
        opcao_pause = 2;
    }

    exit;
}


// ═════════════════════════════════════════════
// TELA DA PAUSA SENSORIAL
// ═════════════════════════════════════════════
if (tela_pause == 3) {
    if (!global.config_reduzir_animacoes) {
        resp_tempo += 1 / room_speed;
    }

    var sensorial_voltar_x1 = 515;
    var sensorial_voltar_y1 = 590;
    var sensorial_voltar_x2 = 765;
    var sensorial_voltar_y2 = 646;

    var sensorial_mouse_voltar = point_in_rectangle(
        mouse_gui_x,
        mouse_gui_y,
        sensorial_voltar_x1,
        sensorial_voltar_y1,
        sensorial_voltar_x2,
        sensorial_voltar_y2
    );

    if (
        keyboard_check_pressed(vk_escape)
        || keyboard_check_pressed(vk_backspace)
        || keyboard_check_pressed(ord("E"))
        || (
            sensorial_mouse_voltar
            && mouse_check_button_pressed(mb_left)
        )
    ) {
        tela_pause = 0;
        opcao_pause = 0;
    }

    exit;
}


// ═════════════════════════════════════════════
// TELA DE CONFIGURAÇÕES
// ═════════════════════════════════════════════
if (tela_pause == 2) {
    var cfg_y = [
        195,
        260,
        325,
        390,
        455,
        520,
        585,
        675
    ];

    var cfg_barra_x1 = 650;
    var cfg_barra_x2 = 1060;

    config_mouse_sobre = -1;


    // Detectar a linha sob o mouse
    for (
        var cfg_i = 0;
        cfg_i < array_length(cfg_y);
        cfg_i++
    ) {
        if (
            point_in_rectangle(
                mouse_gui_x,
                mouse_gui_y,
                120,
                cfg_y[cfg_i] - 26,
                1140,
                cfg_y[cfg_i] + 26
            )
        ) {
            config_mouse_sobre = cfg_i;
            config_opcao_atual = cfg_i;
        }
    }


    // Navegação vertical
    if (
        keyboard_check_pressed(vk_up)
        || keyboard_check_pressed(ord("W"))
    ) {
        config_opcao_atual--;

        if (config_opcao_atual < 0) {
            config_opcao_atual = 7;
        }
    }

    if (
        keyboard_check_pressed(vk_down)
        || keyboard_check_pressed(ord("S"))
    ) {
        config_opcao_atual++;

        if (config_opcao_atual > 7) {
            config_opcao_atual = 0;
        }
    }


    // Começar a arrastar sliders
    if (mouse_check_button_pressed(mb_left)) {
        if (
            point_in_rectangle(
                mouse_gui_x,
                mouse_gui_y,
                cfg_barra_x1 - 15,
                cfg_y[0] - 22,
                cfg_barra_x2 + 15,
                cfg_y[0] + 22
            )
        ) {
            config_arrastando = 0;
            config_opcao_atual = 0;
        }
        else if (
            point_in_rectangle(
                mouse_gui_x,
                mouse_gui_y,
                cfg_barra_x1 - 15,
                cfg_y[1] - 22,
                cfg_barra_x2 + 15,
                cfg_y[1] + 22
            )
        ) {
            config_arrastando = 1;
            config_opcao_atual = 1;
        }
    }


    // Atualizar sliders
    if (mouse_check_button(mb_left)) {
        if (config_arrastando == 0) {
            global.config_volume_musica = clamp(
                (mouse_gui_x - cfg_barra_x1)
                / (cfg_barra_x2 - cfg_barra_x1),
                0,
                1
            );
        }

        if (config_arrastando == 1) {
            global.config_volume_sons = clamp(
                (mouse_gui_x - cfg_barra_x1)
                / (cfg_barra_x2 - cfg_barra_x1),
                0,
                1
            );
        }
    }
    else {
        config_arrastando = -1;
    }


    // Setas horizontais
    var cfg_esquerda =
        keyboard_check_pressed(vk_left)
        || keyboard_check_pressed(ord("A"));

    var cfg_direita =
        keyboard_check_pressed(vk_right)
        || keyboard_check_pressed(ord("D"));

    if (cfg_esquerda || cfg_direita) {
        var cfg_direcao = cfg_direita ? 1 : -1;

        switch (config_opcao_atual) {
            case 0:
                global.config_volume_musica = clamp(
                    global.config_volume_musica
                    + cfg_direcao * 0.05,
                    0,
                    1
                );
            break;

            case 1:
                global.config_volume_sons = clamp(
                    global.config_volume_sons
                    + cfg_direcao * 0.05,
                    0,
                    1
                );
            break;

            case 2:
                global.config_baixo_estimulo =
                    !global.config_baixo_estimulo;
            break;

            case 3:
                global.config_reduzir_animacoes =
                    !global.config_reduzir_animacoes;
            break;

            case 4:
                global.config_velocidade_texto = clamp(
                    global.config_velocidade_texto
                    + cfg_direcao,
                    0,
                    2
                );
            break;

            case 5:
                global.config_tamanho_texto = clamp(
                    global.config_tamanho_texto
                    + cfg_direcao,
                    0,
                    2
                );
            break;

            case 6:
                global.config_contraste = clamp(
                    global.config_contraste
                    + cfg_direcao,
                    0,
                    1
                );
            break;
        }
    }


    // Cliques nos interruptores
    if (mouse_check_button_pressed(mb_left)) {
        if (
            point_in_rectangle(
                mouse_gui_x,
                mouse_gui_y,
                940,
                cfg_y[2] - 25,
                1070,
                cfg_y[2] + 25
            )
        ) {
            global.config_baixo_estimulo =
                !global.config_baixo_estimulo;
        }

        if (
            point_in_rectangle(
                mouse_gui_x,
                mouse_gui_y,
                940,
                cfg_y[3] - 25,
                1070,
                cfg_y[3] + 25
            )
        ) {
            global.config_reduzir_animacoes =
                !global.config_reduzir_animacoes;
        }
    }


    // Cliques nas setas
    if (mouse_check_button_pressed(mb_left)) {

        // Velocidade esquerda
        if (
            point_in_rectangle(
                mouse_gui_x,
                mouse_gui_y,
                660,
                cfg_y[4] - 25,
                740,
                cfg_y[4] + 25
            )
        ) {
            global.config_velocidade_texto = max(
                0,
                global.config_velocidade_texto - 1
            );
        }

        // Velocidade direita
        if (
            point_in_rectangle(
                mouse_gui_x,
                mouse_gui_y,
                970,
                cfg_y[4] - 25,
                1050,
                cfg_y[4] + 25
            )
        ) {
            global.config_velocidade_texto = min(
                2,
                global.config_velocidade_texto + 1
            );
        }

        // Tamanho esquerda
        if (
            point_in_rectangle(
                mouse_gui_x,
                mouse_gui_y,
                660,
                cfg_y[5] - 25,
                740,
                cfg_y[5] + 25
            )
        ) {
            global.config_tamanho_texto = max(
                0,
                global.config_tamanho_texto - 1
            );
        }

        // Tamanho direita
        if (
            point_in_rectangle(
                mouse_gui_x,
                mouse_gui_y,
                970,
                cfg_y[5] - 25,
                1050,
                cfg_y[5] + 25
            )
        ) {
            global.config_tamanho_texto = min(
                2,
                global.config_tamanho_texto + 1
            );
        }

        // Contraste esquerda
        if (
            point_in_rectangle(
                mouse_gui_x,
                mouse_gui_y,
                660,
                cfg_y[6] - 25,
                740,
                cfg_y[6] + 25
            )
        ) {
            global.config_contraste = 0;
        }

        // Contraste direita
        if (
            point_in_rectangle(
                mouse_gui_x,
                mouse_gui_y,
                970,
                cfg_y[6] - 25,
                1050,
                cfg_y[6] + 25
            )
        ) {
            global.config_contraste = 1;
        }
    }


    // Enter ou E
    if (
        keyboard_check_pressed(vk_enter)
        || keyboard_check_pressed(ord("E"))
    ) {
        switch (config_opcao_atual) {
            case 2:
                global.config_baixo_estimulo =
                    !global.config_baixo_estimulo;
            break;

            case 3:
                global.config_reduzir_animacoes =
                    !global.config_reduzir_animacoes;
            break;

            case 7:
                tela_pause = 0;
                opcao_pause = 3;
            break;
        }
    }


    // Botão voltar
    var cfg_voltar_x1 = 515;
    var cfg_voltar_y1 = 645;
    var cfg_voltar_x2 = 765;
    var cfg_voltar_y2 = 705;

    var cfg_mouse_voltar = point_in_rectangle(
        mouse_gui_x,
        mouse_gui_y,
        cfg_voltar_x1,
        cfg_voltar_y1,
        cfg_voltar_x2,
        cfg_voltar_y2
    );

    if (
        cfg_mouse_voltar
        && mouse_check_button_pressed(mb_left)
    ) {
        tela_pause = 0;
        opcao_pause = 3;
    }

    if (keyboard_check_pressed(vk_escape)) {
        tela_pause = 0;
        opcao_pause = 3;
    }

    exit;
}


// ═════════════════════════════════════════════
// MENU PRINCIPAL
// ═════════════════════════════════════════════
mouse_pause = -1;


// Detectar mouse nos botões
for (
    var pause_i = 0;
    pause_i < array_length(opcoes_pause);
    pause_i++
) {
    var pause_x1 = botao_pause_x1[pause_i];
    var pause_x2 = botao_pause_x2[pause_i];

    var pause_y1 = botao_pause_y[pause_i];
    var pause_y2 =
        pause_y1
        + botao_pause_h[pause_i];

    if (
        point_in_rectangle(
            mouse_gui_x,
            mouse_gui_y,
            pause_x1,
            pause_y1,
            pause_x2,
            pause_y2
        )
    ) {
        mouse_pause = pause_i;
        opcao_pause = pause_i;
    }
}


// Navegar para cima
if (
    keyboard_check_pressed(vk_up)
    || keyboard_check_pressed(ord("W"))
) {
    opcao_pause--;

    if (opcao_pause < 0) {
        opcao_pause =
            array_length(opcoes_pause) - 1;
    }
}


// Navegar para baixo
if (
    keyboard_check_pressed(vk_down)
    || keyboard_check_pressed(ord("S"))
) {
    opcao_pause++;

    if (
        opcao_pause
        >= array_length(opcoes_pause)
    ) {
        opcao_pause = 0;
    }
}


// Atualizar animações
for (
    var hover_i = 0;
    hover_i < array_length(opcoes_pause);
    hover_i++
) {
    var hover_alvo =
        hover_i == opcao_pause
        ? 1
        : 0;

    hover_pause[hover_i] = lerp(
        hover_pause[hover_i],
        hover_alvo,
        global.config_reduzir_animacoes
        ? 1
        : 0.18
    );
}


// Confirmar
var confirmar_pause =
    keyboard_check_pressed(vk_enter)
    || keyboard_check_pressed(vk_space);

if (
    mouse_pause != -1
    && mouse_check_button_pressed(mb_left)
) {
    opcao_pause = mouse_pause;
    confirmar_pause = true;
}


// Executar opção
if (confirmar_pause) {
    switch (opcao_pause) {

        case 0:
            tela_pause = 3;
            resp_tempo = 0;
        break;

        case 1:
            global.jogo_pausado = false;
        break;

        case 2:
            tela_pause = 1;
        break;

        case 3:
            tela_pause = 2;
            config_opcao_atual = 0;
        break;

        case 4:
            global.jogo_pausado = false;

            if (
                variable_global_exists(
                    "dialogue_open"
                )
            ) {
                global.dialogue_open = false;
            }

            room_goto(rm_menu);
        break;
    }
}


// Esc fecha o menu principal
if (keyboard_check_pressed(vk_escape)) {
    global.jogo_pausado = false;
}