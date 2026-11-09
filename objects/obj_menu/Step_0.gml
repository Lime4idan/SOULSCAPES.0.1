// Manter as preferências globais atualizadas enquanto o jogador mexe nelas.
// F10 permite testar todo o fluxo de toque no computador sem mudar o build.
if (keyboard_check_pressed(vk_f10)) {
    global.mobile_mode = !global.mobile_mode;
}

// Navegadores só aceitam a solicitação de tela cheia a partir de um gesto do
// jogador. O primeiro toque no menu é esse gesto e continua executando o botão
// normalmente no mesmo frame.
if (
    global.mobile_mode
    && variable_global_exists("mobile_browser")
    && global.mobile_browser
    && !global.mobile_fullscreen_solicitado
    && device_mouse_check_button_pressed(0, mb_left)
) {
    window_set_fullscreen(true);
    global.mobile_fullscreen_solicitado = true;
}

var menu_toque_pressionado = mouse_check_button_pressed(mb_left)
    || (
        global.mobile_mode
        && device_mouse_check_button_pressed(0, mb_left)
    );
var menu_toque_seguro = mouse_check_button(mb_left)
    || (
        global.mobile_mode
        && device_mouse_check_button(0, mb_left)
    );

// O botao acompanha tanto o save local quanto a copia baixada do Supabase.
botao_ativo[1] = variable_global_exists("soul_save_exists")
    && global.soul_save_exists;

global.config_volume_musica = config_volume_musica;
global.config_volume_sons = config_volume_sons;
global.config_baixo_estimulo = config_baixo_estimulo;
global.config_reduzir_animacoes = config_reduzir_animacoes;
global.config_velocidade_texto = config_velocidade_texto;
global.config_tamanho_texto = config_tamanho_texto;
global.config_contraste = config_contraste;

var configuracao_mudou =
    config_anterior_musica != config_volume_musica
    || config_anterior_sons != config_volume_sons
    || config_anterior_baixo != config_baixo_estimulo
    || config_anterior_animacoes != config_reduzir_animacoes
    || config_anterior_velocidade != config_velocidade_texto
    || config_anterior_tamanho != config_tamanho_texto
    || config_anterior_contraste != config_contraste;

if (configuracao_mudou) {
    config_anterior_musica = config_volume_musica;
    config_anterior_sons = config_volume_sons;
    config_anterior_baixo = config_baixo_estimulo;
    config_anterior_animacoes = config_reduzir_animacoes;
    config_anterior_velocidade = config_velocidade_texto;
    config_anterior_tamanho = config_tamanho_texto;
    config_anterior_contraste = config_contraste;
    config_salvar_atraso = max(1, round(room_speed * 0.25));
}

if (config_salvar_atraso > 0) {
    config_salvar_atraso--;

    if (config_salvar_atraso <= 0) {
        global.salvar_configuracoes();
    }
}

// ═════════════════════════════════════════════
// CONTA OPCIONAL E SAVE NA NUVEM
// ═════════════════════════════════════════════
if (mostrando_conta) {
    var conta_mx = device_mouse_x_to_gui(0);
    var conta_my = device_mouse_y_to_gui(0);
    var conta_conectada = variable_global_exists("soul_account_guest")
        && !global.soul_account_guest;
    var conta_ocupada = variable_global_exists("soul_account_busy")
        && global.soul_account_busy;

    conta_mouse_sobre = -1;

    if (!conta_conectada) {
        if (point_in_rectangle(conta_mx, conta_my, 336, 308, 944, 386)) conta_mouse_sobre = 0;
        if (point_in_rectangle(conta_mx, conta_my, 336, 398, 944, 476)) conta_mouse_sobre = 1;
        if (point_in_rectangle(conta_mx, conta_my, 410, 500, 604, 568)) conta_mouse_sobre = 2;
        if (point_in_rectangle(conta_mx, conta_my, 680, 500, 876, 568)) conta_mouse_sobre = 3;
        if (point_in_rectangle(conta_mx, conta_my, 465, 712, 815, 752)) conta_mouse_sobre = 6;
        if (point_in_rectangle(conta_mx, conta_my, 455, 590, 826, 658)) conta_mouse_sobre = 4;

        if (menu_toque_pressionado) {
            if (conta_mouse_sobre == 0) {
                conta_campo_ativo = 0;
                keyboard_string = conta_email;
            }
            else if (conta_mouse_sobre == 1) {
                conta_campo_ativo = 1;
                keyboard_string = conta_senha;
            }
            else if (!conta_ocupada && conta_mouse_sobre == 2) {
                global.soul_account_sign_in(conta_email, conta_senha);
            }
            else if (!conta_ocupada && conta_mouse_sobre == 3) {
                global.soul_account_sign_up(conta_email, conta_senha);
            }
            else if (!conta_ocupada && conta_mouse_sobre == 6) {
                global.soul_account_resend(conta_email);
            }
            else if (conta_mouse_sobre == 4) {
                mostrando_conta = false;
                conta_campo_ativo = -1;
                conta_senha = "";
                keyboard_string = "";
            }
        }

        if (keyboard_check_pressed(vk_tab)) {
            conta_campo_ativo = conta_campo_ativo == 0 ? 1 : 0;
            keyboard_string = conta_campo_ativo == 0 ? conta_email : conta_senha;
            global.tocar_som_ui(1.03);
        }

        if (conta_campo_ativo == 0) {
            conta_email = string_copy(keyboard_string, 1, 80);
        }
        else if (conta_campo_ativo == 1) {
            conta_senha = string_copy(keyboard_string, 1, 64);
        }

        if (keyboard_check_pressed(vk_enter) && !conta_ocupada) {
            global.soul_account_sign_in(conta_email, conta_senha);
        }
    }
    else {
        conta_campo_ativo = -1;
        conta_senha = "";
        keyboard_string = "";
        if (point_in_rectangle(conta_mx, conta_my, 340, 530, 590, 610)) conta_mouse_sobre = 5;
        if (point_in_rectangle(conta_mx, conta_my, 710, 530, 960, 610)) conta_mouse_sobre = 4;

        if (menu_toque_pressionado && conta_mouse_sobre == 5 && !conta_ocupada) {
            global.soul_account_logout();
        }
        else if (menu_toque_pressionado && conta_mouse_sobre == 4) {
            mostrando_conta = false;
        }
    }

    if (keyboard_check_pressed(vk_escape) || keyboard_check_pressed(vk_backspace) && conta_campo_ativo == -1) {
        mostrando_conta = false;
        conta_campo_ativo = -1;
        conta_senha = "";
        keyboard_string = "";
    }

    exit;
}


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

        global.tocar_som_ui(0.94);
    }

    if (
        keyboard_check_pressed(vk_down)
        || keyboard_check_pressed(ord("S"))
    ) {
        config_opcao_atual++;

        if (config_opcao_atual > 7) {
            config_opcao_atual = 0;
        }

        global.tocar_som_ui(1.06);
    }


    // ─────────────────────────────────────────
    // COMEÇAR A ARRASTAR SLIDER
    // ─────────────────────────────────────────
    if (menu_toque_pressionado) {
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
    if (menu_toque_seguro) {
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
        if (config_arrastando == 1) {
            global.config_volume_sons = config_volume_sons;
            global.tocar_som_ui(1.10);
        }

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

        global.config_volume_sons = config_volume_sons;
        global.tocar_som_ui(cfg_direita ? 1.08 : 0.92);
    }


    // ─────────────────────────────────────────
    // CLIQUES NOS INTERRUPTORES
    // ─────────────────────────────────────────
    if (menu_toque_pressionado) {
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
            global.tocar_som_ui(1.05);
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
            global.tocar_som_ui(1.05);
        }
    }


    // ─────────────────────────────────────────
    // CLIQUES NAS SETAS DAS OPÇÕES
    // ─────────────────────────────────────────
    if (menu_toque_pressionado) {

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
            global.tocar_som_ui(0.92);
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
            global.tocar_som_ui(1.08);
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
            global.tocar_som_ui(0.92);
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
            global.tocar_som_ui(1.08);
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
            global.tocar_som_ui(0.92);
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
            global.tocar_som_ui(1.08);
        }
    }


    // ─────────────────────────────────────────
    // ESPAÇO, ENTER OU E
    // ─────────────────────────────────────────
    if (
        keyboard_check_pressed(vk_space)
        || keyboard_check_pressed(vk_enter)
        || keyboard_check_pressed(ord("E"))
    ) {
        switch (config_opcao_atual) {
            case 2:
                config_baixo_estimulo =
                    !config_baixo_estimulo;
                global.tocar_som_ui(1.05);
            break;

            case 3:
                config_reduzir_animacoes =
                    !config_reduzir_animacoes;
                global.tocar_som_ui(1.05);
            break;

            case 7:
                mostrando_configuracoes = false;
                global.salvar_configuracoes();
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
        && menu_toque_pressionado
    ) {
        mostrando_configuracoes = false;
        global.salvar_configuracoes();
    }


    // Voltar com Esc
    if (keyboard_check_pressed(vk_escape)) {
        mostrando_configuracoes = false;
        global.salvar_configuracoes();
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

    var cred_voltar_x1 = 455;
    var cred_voltar_y1 = 620;
    var cred_voltar_x2 = 850;
    var cred_voltar_y2 = 705;

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
        && menu_toque_pressionado
    ) {
        mostrando_creditos = false;
    }

    exit;
}


// ═════════════════════════════════════════════
// MENU PRINCIPAL
// ═════════════════════════════════════════════
if (!config_reduzir_animacoes) {
    tempo_menu += 0.07;
}

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

    global.tocar_som_ui(0.94);
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

    global.tocar_som_ui(1.06);
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
        config_reduzir_animacoes ? 1 : 0.16
    );

    var anim_clicando =
        mouse_sobre == anim_i
        && menu_toque_seguro
        && botao_ativo[anim_i];

    click_anim[anim_i] = lerp(
        click_anim[anim_i],
        anim_clicando ? 1 : 0,
        config_reduzir_animacoes ? 1 : 0.28
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
    menu_toque_pressionado
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
    global.tocar_som_ui(1.12);

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

            global.salvar_configuracoes();


            // Reiniciar o diálogo inicial
            global.dialogue_open = false;
            global.dialogo_inicial_mostrado = false;
            global.tutorial_controles_mostrado = false;
            global.tutorial_controles_pendente = false;


            // Reiniciar a pausa
            global.jogo_pausado = false;


            // Reiniciar o progresso da demo
            global.tem_fragmento = false;
            global.tem_espada_fragmento = false;
            global.vida_kiran_max = 100;
            global.vida_kiran = 100;
            global.guardas_recusados = [0, 0, 0, 0];
            global.fragmento_reconhecido = false;
            global.lorun_apresentada = false;
            global.florakii_roteiro_visto = false;
            global.guardas_roteiro_visto = [false, false, false, false];
            global.vitral_resolvido = false;
            global.fragmentos_vitral = [false, false, false, false];
            global.voltando_do_templo = false;
            global.inventario_itens = [];
            global.inventario_armas = [];
            global.inventario_roupas = [];
            global.inventario_colecionaveis = [];
            global.inventario_missoes = [];
            global.inimigos_derrotados = [false, false, false, false];
            global.itens_curativos_coletados = [];
            global.comandante_partiu = false;
            global.comandante_conhecida = false;
            global.encontro_rainha_iniciado = false;
            global.capitulo_concluido = false;
            global.pontos_florakii = 0;
            global.pontos_dahlia = 0;
            global.pontos_neutro = 0;
            global.escolhas_rota_usadas = [];
            global.rotas_identidade_carregadas = true;
            ini_open("soulscapes_rotas.ini");
            ini_section_delete("rotas");
            ini_section_delete("escolhas");
            ini_write_real("rotas", "florakii", 0);
            ini_write_real("rotas", "dahlia", 0);
            ini_write_real("rotas", "neutro", 0);
            ini_close();

            if (variable_global_exists("soul_prepare_new_game")) {
                global.soul_prepare_new_game();
            }


            // Ir para a floresta inicial
            room_goto(Room1);

            exit;
        break;


        // ─────────────────────────────────────
        // CONTINUAR
        // ─────────────────────────────────────
        case 1:
            if (
                variable_global_exists("soul_continue_game")
                && global.soul_continue_game()
            ) {
                if (audio_is_playing(musica_menu_id)) {
                    audio_stop_sound(musica_menu_id);
                }
            }
        break;


        // ─────────────────────────────────────
        // CONTA
        // ─────────────────────────────────────
        case 2:
            mostrando_conta = true;
            conta_campo_ativo = -1;
            conta_mouse_sobre = -1;
            keyboard_string = "";
        break;


        // ─────────────────────────────────────
        // CONFIGURAÇÕES
        // ─────────────────────────────────────
        case 3:
            mostrando_configuracoes = true;

            config_opcao_atual = 0;
            config_mouse_sobre = -1;
            config_arrastando = -1;
        break;


        // ─────────────────────────────────────
        // CRÉDITOS
        // ─────────────────────────────────────
        case 4:
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
