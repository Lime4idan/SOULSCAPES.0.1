// ═════════════════════════════════════════════
// TELA DE CONFIGURAÇÕES
// ═════════════════════════════════════════════
if (mostrando_configuracoes) {
    var cfg_mx = device_mouse_x_to_gui(0);
    var cfg_my = device_mouse_y_to_gui(0);

    var cfg_y = [
        205, // Volume da música
        275, // Volume dos sons
        345, // Modo baixo estímulo
        415, // Reduzir animações
        485, // Velocidade do texto
        555, // Tamanho do texto
        625, // Contraste
        720  // Voltar
    ];

    var cfg_barra_x1 = 650;
    var cfg_barra_x2 = 1060;

    config_mouse_sobre = -1;


    // ─────────────────────────────────────────
    // DETECTAR LINHA SOB O MOUSE
    // ─────────────────────────────────────────
    for (
        var cfg_i = 0;
        cfg_i < array_length(cfg_y);
        cfg_i++
    ) {
        if (
            point_in_rectangle(
                cfg_mx,
                cfg_my,
                90,
                cfg_y[cfg_i] - 28,
                1130,
                cfg_y[cfg_i] + 28
            )
        ) {
            config_mouse_sobre = cfg_i;
            config_opcao_atual = cfg_i;
        }
    }


    // ─────────────────────────────────────────
    // NAVEGAÇÃO VERTICAL
    // ─────────────────────────────────────────
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


    // ─────────────────────────────────────────
    // COMEÇAR A ARRASTAR SLIDER
    // ─────────────────────────────────────────
    if (mouse_check_button_pressed(mb_left)) {
        if (
            point_in_rectangle(
                cfg_mx,
                cfg_my,
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
                cfg_mx,
                cfg_my,
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


    // ─────────────────────────────────────────
    // ATUALIZAR SLIDERS
    // ─────────────────────────────────────────
    if (mouse_check_button(mb_left)) {
        if (config_arrastando == 0) {
            config_volume_musica = clamp(
                (cfg_mx - cfg_barra_x1)
                / (cfg_barra_x2 - cfg_barra_x1),
                0,
                1
            );
        }

        if (config_arrastando == 1) {
            config_volume_sons = clamp(
                (cfg_mx - cfg_barra_x1)
                / (cfg_barra_x2 - cfg_barra_x1),
                0,
                1
            );
        }
    }
    else {
        config_arrastando = -1;
    }


    // ─────────────────────────────────────────
    // ALTERAR OPÇÕES COM A/D OU SETAS
    // ─────────────────────────────────────────
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
                config_volume_musica = clamp(
                    config_volume_musica
                    + cfg_direcao * 0.05,
                    0,
                    1
                );
            break;

            case 1:
                config_volume_sons = clamp(
                    config_volume_sons
                    + cfg_direcao * 0.05,
                    0,
                    1
                );
            break;

            case 2:
                config_baixo_estimulo =
                    !config_baixo_estimulo;
            break;

            case 3:
                config_reduzir_animacoes =
                    !config_reduzir_animacoes;
            break;

            case 4:
                config_velocidade_texto = clamp(
                    config_velocidade_texto
                    + cfg_direcao,
                    0,
                    2
                );
            break;

            case 5:
                config_tamanho_texto = clamp(
                    config_tamanho_texto
                    + cfg_direcao,
                    0,
                    2
                );
            break;

            case 6:
                config_contraste = clamp(
                    config_contraste
                    + cfg_direcao,
                    0,
                    1
                );
            break;
        }
    }


    // ─────────────────────────────────────────
    // CLIQUES NOS INTERRUPTORES
    // ─────────────────────────────────────────
    if (mouse_check_button_pressed(mb_left)) {
        if (
            point_in_rectangle(
                cfg_mx,
                cfg_my,
                930,
                cfg_y[2] - 25,
                1060,
                cfg_y[2] + 25
            )
        ) {
            config_baixo_estimulo =
                !config_baixo_estimulo;
        }

        if (
            point_in_rectangle(
                cfg_mx,
                cfg_my,
                930,
                cfg_y[3] - 25,
                1060,
                cfg_y[3] + 25
            )
        ) {
            config_reduzir_animacoes =
                !config_reduzir_animacoes;
        }
    }


    // ─────────────────────────────────────────
    // CLIQUES NAS SETAS DAS OPÇÕES
    // ─────────────────────────────────────────
    if (mouse_check_button_pressed(mb_left)) {

        // Velocidade do texto: esquerda
        if (
            point_in_rectangle(
                cfg_mx,
                cfg_my,
                640,
                cfg_y[4] - 25,
                725,
                cfg_y[4] + 25
            )
        ) {
            config_velocidade_texto = max(
                0,
                config_velocidade_texto - 1
            );
        }

        // Velocidade do texto: direita
        if (
            point_in_rectangle(
                cfg_mx,
                cfg_my,
                970,
                cfg_y[4] - 25,
                1055,
                cfg_y[4] + 25
            )
        ) {
            config_velocidade_texto = min(
                2,
                config_velocidade_texto + 1
            );
        }


        // Tamanho do texto: esquerda
        if (
            point_in_rectangle(
                cfg_mx,
                cfg_my,
                640,
                cfg_y[5] - 25,
                725,
                cfg_y[5] + 25
            )
        ) {
            config_tamanho_texto = max(
                0,
                config_tamanho_texto - 1
            );
        }

        // Tamanho do texto: direita
        if (
            point_in_rectangle(
                cfg_mx,
                cfg_my,
                970,
                cfg_y[5] - 25,
                1055,
                cfg_y[5] + 25
            )
        ) {
            config_tamanho_texto = min(
                2,
                config_tamanho_texto + 1
            );
        }


        // Contraste: esquerda
        if (
            point_in_rectangle(
                cfg_mx,
                cfg_my,
                640,
                cfg_y[6] - 25,
                725,
                cfg_y[6] + 25
            )
        ) {
            config_contraste = 0;
        }

        // Contraste: direita
        if (
            point_in_rectangle(
                cfg_mx,
                cfg_my,
                970,
                cfg_y[6] - 25,
                1055,
                cfg_y[6] + 25
            )
        ) {
            config_contraste = 1;
        }
    }


    // ─────────────────────────────────────────
    // ENTER OU E
    // ─────────────────────────────────────────
    if (
        keyboard_check_pressed(vk_enter)
        || keyboard_check_pressed(ord("E"))
    ) {
        switch (config_opcao_atual) {
            case 2:
                config_baixo_estimulo =
                    !config_baixo_estimulo;
            break;

            case 3:
                config_reduzir_animacoes =
                    !config_reduzir_animacoes;
            break;

            case 7:
                mostrando_configuracoes = false;
            break;
        }
    }


    // ─────────────────────────────────────────
    // BOTÃO VOLTAR COM O MOUSE
    // ─────────────────────────────────────────
    if (
        point_in_rectangle(
            cfg_mx,
            cfg_my,
            515,
            cfg_y[7] - 30,
            765,
            cfg_y[7] + 30
        )
        && mouse_check_button_pressed(mb_left)
    ) {
        mostrando_configuracoes = false;
    }


    // Voltar com Esc
    if (keyboard_check_pressed(vk_escape)) {
        mostrando_configuracoes = false;
    }


    // Atualizar o volume enquanto mexe no slider
    if (audio_is_playing(musica_menu_id)) {
        audio_sound_gain(
            musica_menu_id,
            config_volume_musica,
            0
        );
    }

    exit;
}


// ═════════════════════════════════════════════
// TELA DE CRÉDITOS
// ═════════════════════════════════════════════
if (mostrando_creditos) {
    var cred_mx = device_mouse_x_to_gui(0);
    var cred_my = device_mouse_y_to_gui(0);

    var cred_voltar_x1 = 515;
    var cred_voltar_y1 = 570;
    var cred_voltar_x2 = 765;
    var cred_voltar_y2 = 625;

    var cred_mouse_voltar = point_in_rectangle(
        cred_mx,
        cred_my,
        cred_voltar_x1,
        cred_voltar_y1,
        cred_voltar_x2,
        cred_voltar_y2
    );


    // Voltar pelo teclado
    if (
        keyboard_check_pressed(vk_escape)
        || keyboard_check_pressed(vk_backspace)
        || keyboard_check_pressed(ord("E"))
    ) {
        mostrando_creditos = false;
    }


    // Voltar pelo mouse
    if (
        cred_mouse_voltar
        && mouse_check_button_pressed(mb_left)
    ) {
        mostrando_creditos = false;
    }

    exit;
}


// ═════════════════════════════════════════════
// MENU PRINCIPAL
// ═════════════════════════════════════════════
tempo_menu += 0.07;

var menu_mx = device_mouse_x_to_gui(0);
var menu_my = device_mouse_y_to_gui(0);

mouse_sobre = -1;


// ─────────────────────────────────────────────
// DETECTAR MOUSE NOS BOTÕES
// ─────────────────────────────────────────────
for (
    var menu_i = 0;
    menu_i < array_length(botao_texto);
    menu_i++
) {
    var menu_x1 =
        menu_centro_x - botao_w / 2;

    var menu_y1 =
        botao_y[menu_i];

    var menu_x2 =
        menu_centro_x + botao_w / 2;

    var menu_y2 =
        menu_y1 + botao_h;

    if (
        point_in_rectangle(
            menu_mx,
            menu_my,
            menu_x1,
            menu_y1,
            menu_x2,
            menu_y2
        )
    ) {
        mouse_sobre = menu_i;

        if (botao_ativo[menu_i]) {
            opcao_atual = menu_i;
        }
    }
}


// ─────────────────────────────────────────────
// TECLADO: SUBIR
// ─────────────────────────────────────────────
if (
    keyboard_check_pressed(vk_up)
    || keyboard_check_pressed(ord("W"))
) {
    repeat (array_length(botao_texto)) {
        opcao_atual--;

        if (opcao_atual < 0) {
            opcao_atual =
                array_length(botao_texto) - 1;
        }

        if (botao_ativo[opcao_atual]) {
            break;
        }
    }
}


// ─────────────────────────────────────────────
// TECLADO: DESCER
// ─────────────────────────────────────────────
if (
    keyboard_check_pressed(vk_down)
    || keyboard_check_pressed(ord("S"))
) {
    repeat (array_length(botao_texto)) {
        opcao_atual++;

        if (
            opcao_atual
            >= array_length(botao_texto)
        ) {
            opcao_atual = 0;
        }

        if (botao_ativo[opcao_atual]) {
            break;
        }
    }
}


// ─────────────────────────────────────────────
// ANIMAÇÕES DOS BOTÕES
// ─────────────────────────────────────────────
for (
    var anim_i = 0;
    anim_i < array_length(botao_texto);
    anim_i++
) {
    var anim_selecionado =
        anim_i == opcao_atual
        && botao_ativo[anim_i];

    hover_anim[anim_i] = lerp(
        hover_anim[anim_i],
        anim_selecionado ? 1 : 0,
        0.16
    );

    var anim_clicando =
        mouse_sobre == anim_i
        && mouse_check_button(mb_left)
        && botao_ativo[anim_i];

    click_anim[anim_i] = lerp(
        click_anim[anim_i],
        anim_clicando ? 1 : 0,
        0.28
    );
}


// ═════════════════════════════════════════════
// DESCOBRIR QUAL BOTÃO FOI CONFIRMADO
// ═════════════════════════════════════════════
var opcao_confirmada = -1;


// Confirmar com teclado
if (
    keyboard_check_pressed(vk_enter)
    || keyboard_check_pressed(vk_space)
) {
    if (botao_ativo[opcao_atual]) {
        opcao_confirmada = opcao_atual;
    }
}


// Confirmar com mouse
if (
    mouse_check_button_pressed(mb_left)
    && mouse_sobre != -1
    && botao_ativo[mouse_sobre]
) {
    opcao_atual = mouse_sobre;
    opcao_confirmada = mouse_sobre;
}


// ═════════════════════════════════════════════
// EXECUTAR A OPÇÃO DO MENU
// ═════════════════════════════════════════════
if (opcao_confirmada != -1) {
    switch (opcao_confirmada) {

        // ─────────────────────────────────────
        // NOVO JOGO
        // ─────────────────────────────────────
        case 0:
            // Parar a música do menu
            if (audio_is_playing(musica_menu_id)) {
                audio_stop_sound(musica_menu_id);
            }

            // Salvar as configurações nas globais
            global.config_volume_musica =
                config_volume_musica;

            global.config_volume_sons =
                config_volume_sons;

            global.config_baixo_estimulo =
                config_baixo_estimulo;

            global.config_reduzir_animacoes =
                config_reduzir_animacoes;

            global.config_velocidade_texto =
                config_velocidade_texto;

            global.config_tamanho_texto =
                config_tamanho_texto;

            global.config_contraste =
                config_contraste;


            // Reiniciar o diálogo inicial
            global.dialogue_open = false;
            global.dialogo_inicial_mostrado = false;


            // Reiniciar a pausa
            global.jogo_pausado = false;


            // Reiniciar o progresso da demo
            global.tem_fragmento = false;
            global.fragmento_reconhecido = false;


            // Ir para a floresta inicial
            room_goto(Room1);

            exit;
        break;


        // ─────────────────────────────────────
        // CONTINUAR
        // Atualmente está desativado
        // ─────────────────────────────────────
        case 1:
        break;


        // ─────────────────────────────────────
        // CONFIGURAÇÕES
        // ─────────────────────────────────────
        case 2:
            mostrando_configuracoes = true;

            config_opcao_atual = 0;
            config_mouse_sobre = -1;
            config_arrastando = -1;
        break;


        // ─────────────────────────────────────
        // CRÉDITOS
        // ─────────────────────────────────────
        case 3:
            mostrando_creditos = true;
        break;
    }
}


// ═════════════════════════════════════════════
// ATUALIZAR VOLUME DA MÚSICA DO MENU
// ═════════════════════════════════════════════
if (audio_is_playing(musica_menu_id)) {
    audio_sound_gain(
        musica_menu_id,
        config_volume_musica,
        0
    );
}
global.vitral_resolvido = false;
global.fragmentos_vitral = [
    false,
    false,
    false,
    false
];