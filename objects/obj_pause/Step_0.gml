// ═════════════════════════════════════════════
// GARANTIR QUE A VARIÁVEL EXISTA
// ═════════════════════════════════════════════
if (!variable_global_exists("jogo_pausado")) {
    global.jogo_pausado = false;
}

// O runner GX nem sempre converte toque em mouse no mesmo frame. Todas as
// telas do menu, inventário, configurações, encontro e batalha usam esta
// entrada unificada para manter o comportamento idêntico no desktop e mobile.
var ui_toque_pressionado = mouse_check_button_pressed(mb_left)
    || (
        variable_global_exists("mobile_mode")
        && global.mobile_mode
        && device_mouse_check_button_pressed(0, mb_left)
    );
var ui_toque_seguro = mouse_check_button(mb_left)
    || (
        variable_global_exists("mobile_mode")
        && global.mobile_mode
        && device_mouse_check_button(0, mb_left)
    );
var ui_toque_x = device_mouse_x_to_gui(0);
var ui_toque_y = device_mouse_y_to_gui(0);
// Os três atalhos superiores seguem a geometria das artes em aquarela
// desenhadas por obj_moldura_jogo.
var ui_mobile_rapido = ui_toque_pressionado;
var ui_atalho_y1 = 82;
var ui_atalho_y2 = 148;
var ui_atalho_largura = 128;
var ui_atalho_gap = 6;
var ui_atalho_direita = display_get_gui_width() - 60;
var ui_menu_x2 = ui_atalho_direita;
var ui_menu_x1 = ui_menu_x2 - ui_atalho_largura;
var ui_ajustes_x2 = ui_menu_x1 - ui_atalho_gap;
var ui_ajustes_x1 = ui_ajustes_x2 - ui_atalho_largura;
var ui_bolsa_x2 = ui_ajustes_x1 - ui_atalho_gap;
var ui_bolsa_x1 = ui_bolsa_x2 - ui_atalho_largura;
var ui_mobile_bolsa = ui_mobile_rapido && point_in_rectangle(
    ui_toque_x,
    ui_toque_y,
    ui_bolsa_x1,
    ui_atalho_y1,
    ui_bolsa_x2,
    ui_atalho_y2
);
var ui_mobile_ajustes = ui_mobile_rapido && point_in_rectangle(
    ui_toque_x,
    ui_toque_y,
    ui_ajustes_x1,
    ui_atalho_y1,
    ui_ajustes_x2,
    ui_atalho_y2
);
var ui_mobile_menu = ui_mobile_rapido && point_in_rectangle(
    ui_toque_x,
    ui_toque_y,
    ui_menu_x1,
    ui_atalho_y1,
    ui_menu_x2,
    ui_atalho_y2
);


// Salvar mudanças feitas no menu de pausa sem gravar no disco a cada frame
// enquanto um slider estiver sendo arrastado.
var configuracao_mudou =
    config_anterior_musica != global.config_volume_musica
    || config_anterior_sons != global.config_volume_sons
    || config_anterior_baixo != global.config_baixo_estimulo
    || config_anterior_animacoes != global.config_reduzir_animacoes
    || config_anterior_velocidade != global.config_velocidade_texto
    || config_anterior_tamanho != global.config_tamanho_texto
    || config_anterior_contraste != global.config_contraste;

if (configuracao_mudou) {
    config_anterior_musica = global.config_volume_musica;
    config_anterior_sons = global.config_volume_sons;
    config_anterior_baixo = global.config_baixo_estimulo;
    config_anterior_animacoes = global.config_reduzir_animacoes;
    config_anterior_velocidade = global.config_velocidade_texto;
    config_anterior_tamanho = global.config_tamanho_texto;
    config_anterior_contraste = global.config_contraste;
    config_salvar_atraso = max(1, round(room_speed * 0.25));
}

if (config_salvar_atraso > 0) {
    config_salvar_atraso--;

    if (config_salvar_atraso <= 0) {
        global.salvar_configuracoes();
    }
}


// ═════════════════════════════════════════════
// RETORNO VISUAL DE VIDA E MENSAGENS DA BOLSA
// ═════════════════════════════════════════════
var vida_atual_hud = clamp(global.vida_kiran, 0, global.vida_kiran_max);

if (vida_atual_hud != hud_vida_anterior) {
    hud_vida_feedback = vida_atual_hud > hud_vida_anterior ? 1 : -1;
    hud_vida_feedback_timer = hud_vida_feedback_total;
    hud_vida_anterior = vida_atual_hud;
}

if (hud_vida_feedback_timer > 0) {
    hud_vida_feedback_timer--;
}
else {
    hud_vida_feedback = 0;
}

if (global.config_reduzir_animacoes) {
    hud_vida_exibida = vida_atual_hud;
}
else {
    hud_vida_exibida = lerp(hud_vida_exibida, vida_atual_hud, 0.18);

    if (abs(hud_vida_exibida - vida_atual_hud) < 0.05) {
        hud_vida_exibida = vida_atual_hud;
    }
}

if (inventario_mensagem_timer > 0) {
    inventario_mensagem_timer--;
}

if (recompensa_toast_timer > 0 && !global.jogo_pausado) {
    recompensa_toast_timer--;
}

if (dialogo_pos_vitoria_timer > 0 && !global.jogo_pausado) {
    dialogo_pos_vitoria_timer--;

    if (dialogo_pos_vitoria_timer <= 0) {
        var dialogo_vitoria = instance_find(obj_dialogo, 0);

        if (
            instance_exists(dialogo_vitoria)
            && dialogo_pos_vitoria_indice >= 0
        ) {
            dialogo_vitoria.iniciar_escolha(
                opcoes_pos_vitoria_guardas[dialogo_pos_vitoria_indice],
                respostas_pos_vitoria_guardas[dialogo_pos_vitoria_indice],
                "pos_vitoria_" + string(dialogo_pos_vitoria_indice)
            );
        }

        dialogo_pos_vitoria_indice = -1;
    }
}


// ═════════════════════════════════════════════
// DUELO EM TURNOS CONTRA NPC
// ═════════════════════════════════════════════
if (tela_pause == 5) {
    var duelo_mouse_x = device_mouse_x_to_gui(0);
    var duelo_mouse_y = device_mouse_y_to_gui(0);

    batalha_animacao_ataque_kiran = max(0, batalha_animacao_ataque_kiran - 1);
    batalha_animacao_ataque_inimigo = max(0, batalha_animacao_ataque_inimigo - 1);

    if (!global.config_reduzir_animacoes) {
        tempo_pause += 0.08;
        tempo_inimigos += 0.055;
    }

    if (batalha_entrada_timer > 0) {
        batalha_entrada_timer--;
    }

    if (batalha_bloqueio > 0) {
        batalha_bloqueio--;
    }

    if (batalha_feedback_timer > 0) {
        batalha_feedback_timer--;
    }

    if (!global.config_reduzir_animacoes) {
        batalha_impacto_inimigo = lerp(batalha_impacto_inimigo, 0, 0.16);
        batalha_impacto_kiran = lerp(batalha_impacto_kiran, 0, 0.16);
    }
    else {
        batalha_impacto_inimigo = 0;
        batalha_impacto_kiran = 0;
    }

    if (batalha_fase == -4) {
        var roteiro_em_escolha = encontro_roteiro_bloco == 1
            || encontro_roteiro_bloco == 4;
        var roteiro_opcoes_atuais = encontro_roteiro_bloco == 1
            ? encontro_roteiro_opcoes1
            : encontro_roteiro_opcoes2;
        var roteiro_total_opcoes = max(1, array_length(roteiro_opcoes_atuais));

        if (roteiro_em_escolha) {
            if (
                keyboard_check_pressed(vk_left)
                || keyboard_check_pressed(ord("A"))
                || keyboard_check_pressed(vk_up)
                || keyboard_check_pressed(ord("W"))
            ) {
                encontro_roteiro_opcao = (encontro_roteiro_opcao + roteiro_total_opcoes - 1)
                    mod roteiro_total_opcoes;
                global.tocar_som_ui(1.02);
            }

            if (
                keyboard_check_pressed(vk_down)
                || keyboard_check_pressed(ord("S"))
                || keyboard_check_pressed(vk_right)
                || keyboard_check_pressed(ord("D"))
            ) {
                encontro_roteiro_opcao = (encontro_roteiro_opcao + 1)
                    mod roteiro_total_opcoes;
                global.tocar_som_ui(1.02);
            }

            encontro_roteiro_mouse = -1;

            for (var roteiro_mouse_i = 0;
                roteiro_mouse_i < roteiro_total_opcoes;
                roteiro_mouse_i++
            ) {
                var roteiro_mouse_x1 = 88;
                var roteiro_mouse_mobile = variable_global_exists("mobile_mode")
                    && global.mobile_mode;
                var roteiro_mouse_y1 = roteiro_mouse_mobile
                    ? 520 + roteiro_mouse_i * 58
                    : 558 + roteiro_mouse_i * 51;
                var roteiro_mouse_h = roteiro_mouse_mobile ? 54 : 46;

                if (point_in_rectangle(
                    duelo_mouse_x,
                    duelo_mouse_y,
                    roteiro_mouse_x1,
                    roteiro_mouse_y1,
                    1192,
                    roteiro_mouse_y1 + roteiro_mouse_h
                )) {
                    encontro_roteiro_mouse = roteiro_mouse_i;
                    encontro_roteiro_opcao = roteiro_mouse_i;
                }
            }
        }

        var roteiro_confirmar = batalha_bloqueio <= 0 && (
            keyboard_check_pressed(vk_space)
            || keyboard_check_pressed(vk_enter)
            || (
                ui_toque_pressionado
                && (!roteiro_em_escolha || encontro_roteiro_mouse >= 0)
            )
        );

        if (roteiro_confirmar) {
            if (roteiro_em_escolha) {
                var roteiro_metadados = encontro_roteiro_bloco == 1
                    ? encontro_roteiro_metadados1
                    : encontro_roteiro_metadados2;
                if (
                    encontro_roteiro_opcao < array_length(roteiro_metadados)
                    && is_struct(roteiro_metadados[encontro_roteiro_opcao])
                    && variable_global_exists("adicionar_ponto_rota")
                ) {
                    var roteiro_meta = roteiro_metadados[encontro_roteiro_opcao];
                    global.adicionar_ponto_rota(
                        roteiro_meta.rota,
                        roteiro_meta.pontos,
                        roteiro_meta.id
                    );
                }
                encontro_roteiro_linhas = encontro_roteiro_bloco == 1
                    ? encontro_roteiro_rotas1[encontro_roteiro_opcao]
                    : encontro_roteiro_rotas2[encontro_roteiro_opcao];
                encontro_roteiro_bloco = encontro_roteiro_bloco == 1 ? 2 : 5;
                encontro_roteiro_indice = 0;
                encontro_roteiro_opcao = 0;
                batalha_bloqueio = 5;
                global.tocar_som_ui(1.06);
            }
            else {
                encontro_roteiro_indice++;

                if (encontro_roteiro_indice >= array_length(encontro_roteiro_linhas)) {
                    switch (encontro_roteiro_bloco) {
                        case 0:
                            encontro_roteiro_bloco = 1;
                            encontro_roteiro_opcao = 0;
                        break;

                        case 2:
                            encontro_roteiro_bloco = 3;
                            encontro_roteiro_linhas = encontro_roteiro_comum;
                            encontro_roteiro_indice = 0;
                        break;

                        case 3:
                            if (encontro_roteiro_tem_segunda_escolha) {
                                encontro_roteiro_bloco = 4;
                                encontro_roteiro_opcao = 0;
                            }
                            else {
                                var roteiro_guarda_indice = clamp(batalha_inimigo, 0, 3);
                                global.guardas_roteiro_visto[roteiro_guarda_indice] = true;
                                encontro_roteiro_tipo = 0;
                                global.dialogue_open = false;
                                batalha_mensagem = falas_inicio_batalha[roteiro_guarda_indice];
                                batalha_fase = -3;
                                batalha_conversa_etapa = 0;
                                batalha_conversa_opcao = 0;
                                batalha_conversa_visitou_pergunta = false;
                            }
                        break;

                        case 5:
                            encontro_roteiro_bloco = 6;
                            if (
                                encontro_roteiro_tipo == 7
                                && array_length(encontro_roteiro_finais_rainha) >= 3
                                && variable_global_exists("obter_rota_atual")
                            ) {
                                var roteiro_rota_final = global.obter_rota_atual();
                                encontro_roteiro_final = encontro_roteiro_finais_rainha[
                                    roteiro_rota_final == "florakii"
                                        ? 0
                                        : (roteiro_rota_final == "dahlia" ? 1 : 2)
                                ];
                            }
                            encontro_roteiro_linhas = encontro_roteiro_final;
                            encontro_roteiro_indice = 0;
                        break;

                        case 6:
                            if (encontro_roteiro_tipo == 7) {
                                encontro_roteiro_tipo = 0;
                                global.dialogue_open = false;
                                global.capitulo_concluido = true;
                                global.jogo_pausado = true;
                                fim_capitulo_timer = 0;
                                tela_pause = 6;
                            }
                            else if (encontro_roteiro_tipo == 2) {
                                global.florakii_roteiro_visto = true;
                                encontro_roteiro_tipo = 0;
                                global.dialogue_open = false;
                                batalha_mensagem = "Lumi mantém a distância, mas já não confunde Kiran com um Dahlia comum.";
                                batalha_fase = -1;
                                batalha_opcao_confronto = 0;
                            }
                            else {
                                encontro_roteiro_tipo = 0;
                                global.dialogue_open = false;
                                global.jogo_pausado = false;
                                global.interacao_bloqueada_ate = current_time + 180;
                                tela_pause = 0;
                            }
                        break;
                    }
                }

                batalha_bloqueio = 4;
                global.tocar_som_ui(1.01);
            }
        }
    }
    else if (batalha_fase == -3) {
        var conversa_confirmar = batalha_bloqueio <= 0 && (
            keyboard_check_pressed(vk_space)
            || keyboard_check_pressed(vk_enter)
            || ui_toque_pressionado
        );

        if (batalha_conversa_etapa == 1) {
            if (
                keyboard_check_pressed(vk_left)
                || keyboard_check_pressed(ord("A"))
            ) {
                batalha_conversa_opcao--;

                if (batalha_conversa_opcao < 0) {
                    batalha_conversa_opcao = 2;
                }

                global.tocar_som_ui(0.98);
            }

            if (
                keyboard_check_pressed(vk_right)
                || keyboard_check_pressed(ord("D"))
            ) {
                batalha_conversa_opcao++;

                if (batalha_conversa_opcao > 2) {
                    batalha_conversa_opcao = 0;
                }

                global.tocar_som_ui(1.04);
            }

            batalha_conversa_mouse = -1;

            for (var conversa_i = 0; conversa_i < 3; conversa_i++) {
                var conversa_mobile = variable_global_exists("mobile_mode")
                    && global.mobile_mode;
                var conversa_x1 = conversa_mobile
                    ? 88
                    : 82 + conversa_i * 376;
                var conversa_y1 = conversa_mobile
                    ? 510 + conversa_i * 78
                    : 650;
                var conversa_x2 = conversa_mobile
                    ? 1192
                    : conversa_x1 + 350;
                var conversa_y2 = conversa_mobile
                    ? conversa_y1 + 72
                    : 718;

                if (point_in_rectangle(
                    duelo_mouse_x,
                    duelo_mouse_y,
                    conversa_x1,
                    conversa_y1,
                    conversa_x2,
                    conversa_y2
                )) {
                    batalha_conversa_mouse = conversa_i;
                    batalha_conversa_opcao = conversa_i;
                }
            }

            conversa_confirmar = batalha_bloqueio <= 0 && (
                keyboard_check_pressed(vk_space)
                || keyboard_check_pressed(vk_enter)
                || (
                    batalha_conversa_mouse >= 0
                    && ui_toque_pressionado
                )
            );
        }

        if (keyboard_check_pressed(vk_escape)) {
            global.guardas_recusados[batalha_inimigo]++;
            batalha_mensagem = falas_recuo[batalha_inimigo];
            batalha_fase = -2;
            batalha_bloqueio = 10;
            global.tocar_som_ui(0.94);
            exit;
        }

        if (conversa_confirmar) {
            switch (batalha_conversa_etapa) {
                case 0:
                    batalha_conversa_etapa = 1;
                    batalha_conversa_opcao = 0;
                    batalha_bloqueio = 5;
                    global.tocar_som_ui(1.03);
                break;

                case 1:
                    var conversa_meta = metadados_conversa_inimigos[
                        batalha_inimigo
                    ][batalha_conversa_opcao];
                    if (
                        is_struct(conversa_meta)
                        && variable_global_exists("adicionar_ponto_rota")
                    ) {
                        global.adicionar_ponto_rota(
                            conversa_meta.rota,
                            conversa_meta.pontos,
                            conversa_meta.id
                        );
                    }
                    batalha_mensagem = falas_escolha_conversa_inimigos[
                        batalha_inimigo
                    ][batalha_conversa_opcao];
                    batalha_conversa_etapa = 3;

                    batalha_bloqueio = 6;
                    global.tocar_som_ui(1.06);
                break;

                case 2:
                    batalha_conversa_etapa = 1;
                    batalha_bloqueio = 5;
                    global.tocar_som_ui(1.00);
                break;

                case 3:
                    batalha_fase = -1;
                    batalha_opcao_confronto = 0;
                    batalha_bloqueio = 6;
                    global.tocar_som_ui(1.08);
                break;

                case 4:
                    global.guardas_recusados[batalha_inimigo]++;
                    batalha_mensagem = falas_recuo[batalha_inimigo];
                    batalha_fase = -2;
                    batalha_bloqueio = 8;
                    global.tocar_som_ui(0.98);
                break;
            }
        }
    }
    else if (batalha_fase == -1) {
        var confronto_neutro_puro = global.rota_neutra_pura();
        var confronto_curativos = global.inventario_itens_curativos(false);
        var confronto_total_opcoes = confronto_neutro_puro ? 3 : 2;

        if (
            keyboard_check_pressed(vk_left)
            || keyboard_check_pressed(vk_up)
            || keyboard_check_pressed(ord("A"))
            || keyboard_check_pressed(ord("W"))
        ) {
            batalha_opcao_confronto = (
                batalha_opcao_confronto + confronto_total_opcoes - 1
            ) mod confronto_total_opcoes;
            global.tocar_som_ui(0.98);
        }

        if (
            keyboard_check_pressed(vk_right)
            || keyboard_check_pressed(vk_down)
            || keyboard_check_pressed(ord("D"))
            || keyboard_check_pressed(ord("S"))
        ) {
            batalha_opcao_confronto = (
                batalha_opcao_confronto + 1
            ) mod confronto_total_opcoes;
            global.tocar_som_ui(1.02);
        }

        batalha_mouse_opcao = -1;

        var confronto_inicio_y = confronto_total_opcoes == 3 ? 548 : 590;
        for (var confronto_mouse_i = 0; confronto_mouse_i < confronto_total_opcoes; confronto_mouse_i++) {
            var confronto_mouse_y1 = confronto_inicio_y + confronto_mouse_i * 62;
            if (point_in_rectangle(
                duelo_mouse_x,
                duelo_mouse_y,
                734,
                confronto_mouse_y1,
                1166,
                confronto_mouse_y1 + 50
            )) {
                batalha_mouse_opcao = confronto_mouse_i;
                batalha_opcao_confronto = confronto_mouse_i;
            }
        }

        if (keyboard_check_pressed(vk_escape)) {
            global.guardas_recusados[batalha_inimigo]++;
            batalha_mensagem = falas_recuo[batalha_inimigo];
            batalha_fase = -2;
            batalha_bloqueio = 10;
            global.tocar_som_ui(0.96);
            exit;
        }

        var confronto_confirmar = batalha_bloqueio <= 0 && (
            keyboard_check_pressed(vk_space)
            || keyboard_check_pressed(vk_enter)
            || (batalha_mouse_opcao >= 0 && ui_toque_pressionado)
        );

        if (confronto_confirmar) {
            var confronto_escolheu_troca = confronto_neutro_puro
                && batalha_opcao_confronto == 1;
            var confronto_escolheu_sair = confronto_neutro_puro
                ? batalha_opcao_confronto == 2
                : batalha_opcao_confronto == 1;

            if (confronto_escolheu_sair) {
                global.guardas_recusados[batalha_inimigo]++;
                batalha_mensagem = falas_recuo[batalha_inimigo];
                batalha_fase = -2;
                batalha_bloqueio = 10;
                global.tocar_som_ui(0.96);
            }
            else if (confronto_escolheu_troca) {
                if (array_length(confronto_curativos) <= 0) {
                    batalha_mensagem = "Kiran procura na bolsa, mas não possui nenhum item de cura para oferecer.";
                    batalha_bloqueio = 8;
                    global.tocar_som_ui(0.90);
                }
                else {
                    batalha_troca_item_opcao = 0;
                    batalha_mouse_opcao = -1;
                    batalha_fase = -5;
                    batalha_bloqueio = 6;
                    global.tocar_som_ui(1.06);
                }
            }
            else if (!global.tem_espada_fragmento) {
                batalha_mensagem = falas_sem_arma[batalha_inimigo];
                batalha_bloqueio = 8;
                global.tocar_som_ui(0.90);
            }
            else {
                iniciar_batalha(batalha_inimigo);
                global.tocar_som_ui(1.08);
            }
        }
    }
    else if (batalha_fase == -5) {
        var troca_curativos = global.inventario_itens_curativos(false);
        var troca_total = array_length(troca_curativos);

        if (troca_total <= 0) {
            batalha_fase = -1;
            batalha_opcao_confronto = 1;
            batalha_mensagem = "Não há mais itens de cura na bolsa para oferecer.";
            batalha_bloqueio = 8;
        }
        else {
            batalha_troca_item_opcao = clamp(
                batalha_troca_item_opcao,
                0,
                troca_total - 1
            );

            if (
                keyboard_check_pressed(vk_up)
                || keyboard_check_pressed(vk_left)
                || keyboard_check_pressed(ord("W"))
                || keyboard_check_pressed(ord("A"))
            ) {
                batalha_troca_item_opcao = (
                    batalha_troca_item_opcao + troca_total - 1
                ) mod troca_total;
                global.tocar_som_ui(0.98);
            }

            if (
                keyboard_check_pressed(vk_down)
                || keyboard_check_pressed(vk_right)
                || keyboard_check_pressed(ord("S"))
                || keyboard_check_pressed(ord("D"))
            ) {
                batalha_troca_item_opcao = (
                    batalha_troca_item_opcao + 1
                ) mod troca_total;
                global.tocar_som_ui(1.02);
            }

            batalha_mouse_opcao = -1;
            for (var troca_mouse_i = 0; troca_mouse_i < troca_total; troca_mouse_i++) {
                var troca_mouse_y1 = 558 + troca_mouse_i * 58;
                if (point_in_rectangle(
                    duelo_mouse_x,
                    duelo_mouse_y,
                    650,
                    troca_mouse_y1,
                    1168,
                    troca_mouse_y1 + 48
                )) {
                    batalha_mouse_opcao = troca_mouse_i;
                    batalha_troca_item_opcao = troca_mouse_i;
                }
            }

            if (keyboard_check_pressed(vk_escape)) {
                batalha_fase = -1;
                batalha_opcao_confronto = 1;
                batalha_bloqueio = 5;
                global.tocar_som_ui(0.96);
            }
            else {
                var troca_confirmar = batalha_bloqueio <= 0 && (
                    keyboard_check_pressed(vk_space)
                    || keyboard_check_pressed(vk_enter)
                    || (
                        batalha_mouse_opcao >= 0
                        && ui_toque_pressionado
                    )
                );

                if (troca_confirmar) {
                    var troca_item_escolhido = troca_curativos[
                        batalha_troca_item_opcao
                    ];
                    if (batalha_finalizar_troca(troca_item_escolhido)) {
                        if (variable_global_exists("tocar_sfx")) {
                            global.tocar_sfx(global.sfx_cura, 0.34, 1.08);
                        }
                    }
                }
            }
        }
    }
    else if (batalha_fase == -2) {
        if (
            batalha_bloqueio <= 0
            && (
                keyboard_check_pressed(vk_space)
                || keyboard_check_pressed(vk_enter)
                || keyboard_check_pressed(vk_escape)
                || ui_toque_pressionado
            )
        ) {
            encerrar_batalha();
        }
    }
    else if (batalha_fase == 6) {
        batalha_timer--;

        if (batalha_timer <= 0) {
            batalha_fase = 4;
            batalha_animacao_ataque_inimigo = global.config_reduzir_animacoes ? 10 : 28;
            if (variable_global_exists("tocar_sfx")) {
                global.tocar_sfx(
                    global.sfx_ataque_inimigo,
                    0.52,
                    random_range(0.92, 1.06)
                );
            }
        }
    }
    else if (batalha_fase == 4) {
        batalha_defesa_timer--;

        var defesa_confirmar = keyboard_check_pressed(vk_space)
            || keyboard_check_pressed(vk_enter)
            || ui_toque_pressionado;
        var defesa_resolver = false;
        // Escolher "Defender" consome o turno inteiro e, portanto, bloqueia
        // completamente o próximo golpe. A barra continua dando feedback de
        // timing, mas um erro nela não invalida a ação já escolhida.
        var defesa_multiplicador = batalha_defesa_preparada ? 0 : 1.15;
        var defesa_texto = batalha_defesa_preparada
            ? "A guarda bloqueou o golpe!"
            : "Sem defesa!";

        if (defesa_confirmar) {
            var defesa_progresso_atual = clamp(
                1 - batalha_defesa_timer / batalha_defesa_total,
                0,
                1
            );
            var defesa_distancia = abs(defesa_progresso_atual - batalha_defesa_alvo)
                * batalha_defesa_total;

            // Os valores também alimentam a largura real dos sprites no HUD.
            batalha_defesa_janela_perfeita = batalha_defesa_preparada ? 8 : 4;
            batalha_defesa_janela_boa = batalha_defesa_preparada ? 18 : 10;
            var defesa_janela_perfeita = batalha_defesa_janela_perfeita;
            var defesa_janela_boa = batalha_defesa_janela_boa;

            if (defesa_distancia <= defesa_janela_perfeita) {
                defesa_multiplicador = 0;
                defesa_texto = batalha_defesa_preparada
                    ? "Bloqueio perfeito!"
                    : "Defesa perfeita!";
            }
            else if (defesa_distancia <= defesa_janela_boa) {
                defesa_multiplicador = 0;
                defesa_texto = batalha_defesa_preparada
                    ? "Defesa completa!"
                    : "Boa defesa! O golpe foi bloqueado.";
            }
            else {
                defesa_multiplicador = batalha_defesa_preparada ? 0 : 1;
                defesa_texto = batalha_defesa_preparada
                    ? "A guarda bloqueou o golpe, apesar do timing tardio."
                    : "Defesa errada!";
            }

            defesa_resolver = true;
        }
        else if (batalha_defesa_timer <= 0) {
            defesa_resolver = true;
        }

        if (defesa_resolver) {
            var defesa_dano_final = round(batalha_dano_pendente * defesa_multiplicador);
            if (defesa_multiplicador > 0) {
                defesa_dano_final = max(1, defesa_dano_final);
            }
            batalha_serenidade = max(0, batalha_serenidade - defesa_dano_final);
            global.vida_kiran = batalha_serenidade;
            batalha_energia = min(batalha_energia_max, batalha_energia + 1);
            batalha_defesa_feedback = defesa_multiplicador <= 0.58 ? 1 : -1;
            batalha_defesa_posicao = clamp(
                1 - batalha_defesa_timer / batalha_defesa_total,
                0,
                1
            );
            batalha_mensagem = nomes_inimigos[batalha_inimigo]
                + " usou " + batalha_golpe_pendente + ". " + defesa_texto;
            if (defesa_dano_final <= 0) {
                batalha_mensagem += " Kiran não sofreu dano.";
            }
            else {
                batalha_mensagem += " Kiran sofreu "
                    + string(defesa_dano_final) + " de dano.";
            }
            batalha_feedback_timer = batalha_feedback_total;
            batalha_feedback_valor = defesa_dano_final;
            batalha_feedback_alvo = 0;
            batalha_feedback_tipo = batalha_defesa_feedback > 0 ? 4 : -1;
            batalha_impacto_kiran =
                global.config_reduzir_animacoes || defesa_dano_final <= 0
                    ? 0
                    : 1;
            batalha_defesa_preparada = false;

            batalha_derrota_pendente = batalha_serenidade <= 0;

            if (batalha_derrota_pendente) {
                batalha_mensagem_derrota = nomes_inimigos[batalha_inimigo]
                    + ": “" + falas_vitoria_guardas[batalha_inimigo]
                    + "”  Kiran precisa recuar.";
            }

            batalha_fase = 5;
            batalha_timer = global.config_reduzir_animacoes ? 34 : 68;

            if (variable_global_exists("tocar_sfx")) {
                if (defesa_multiplicador <= 0.58) {
                    global.tocar_sfx(global.sfx_defesa, 0.55, 1.04);
                }
                else {
                    global.tocar_sfx(global.sfx_dano, 0.58, 0.94);
                }
            }
            // O efeito próprio de defesa/dano já confirma o resultado; não
            // sobrepor também o bipe de interface deixa o som mais limpo.
        }
    }
    else if (batalha_fase == 5) {
        batalha_timer--;

        if (batalha_timer <= 0) {
            if (batalha_derrota_pendente) {
                batalha_fase = 3;
                batalha_mensagem = batalha_mensagem_derrota;
            }
            else {
                batalha_rodada++;
                batalha_fase = 0;
                batalha_menu = 0;
                batalha_acao_opcao = 0;
                batalha_status_inimigo = "";
                batalha_mensagem = "O que Kiran deve fazer?";
            }
        }
    }
    else if (batalha_fase == 1) {
        batalha_timer--;

        if (batalha_timer <= 0) {
            batalha_rodada++;
            batalha_fase = 0;
            batalha_menu = 0;
            batalha_acao_opcao = 0;
            batalha_mensagem = "O que Kiran deve fazer?";
        }
    }
    else if (batalha_fase == 0 && batalha_bloqueio <= 0) {
        var batalha_esquerda = keyboard_check_pressed(vk_left)
            || keyboard_check_pressed(ord("A"));
        var batalha_direita = keyboard_check_pressed(vk_right)
            || keyboard_check_pressed(ord("D"));
        var batalha_cima = keyboard_check_pressed(vk_up)
            || keyboard_check_pressed(ord("W"));
        var batalha_baixo = keyboard_check_pressed(vk_down)
            || keyboard_check_pressed(ord("S"));
        var batalha_confirmar_tecla = keyboard_check_pressed(vk_space)
            || keyboard_check_pressed(vk_enter);
        batalha_mouse_opcao = -1;

        if (batalha_menu == 0) {
            // Menu principal em grade 2x2, inspirado em RPGs clássicos.
            if (batalha_esquerda || batalha_direita) {
                batalha_acao_opcao = floor(batalha_acao_opcao / 2) * 2
                    + (1 - (batalha_acao_opcao mod 2));
                global.tocar_som_ui(1.02);
            }

            if (batalha_cima || batalha_baixo) {
                batalha_acao_opcao = (batalha_acao_opcao + 2) mod 4;
                global.tocar_som_ui(1.02);
            }

            for (var acao_mouse_i = 0; acao_mouse_i < 4; acao_mouse_i++) {
                var acao_mouse_col = acao_mouse_i mod 2;
                var acao_mouse_lin = floor(acao_mouse_i / 2);
                var acao_mouse_x1 = 728 + acao_mouse_col * 246;
                var acao_mouse_y1 = 592 + acao_mouse_lin * 72;

                if (point_in_rectangle(
                    duelo_mouse_x,
                    duelo_mouse_y,
                    acao_mouse_x1,
                    acao_mouse_y1,
                    acao_mouse_x1 + 232,
                    acao_mouse_y1 + 60
                )) {
                    batalha_mouse_opcao = acao_mouse_i;
                    batalha_acao_opcao = acao_mouse_i;
                }
            }

            if (keyboard_check_pressed(vk_escape)) {
                global.guardas_recusados[batalha_inimigo]++;
                batalha_mensagem = falas_recuo[batalha_inimigo];
                batalha_fase = -2;
                batalha_bloqueio = 10;
                global.tocar_som_ui(0.90);
                exit;
            }

            var acao_confirmar = batalha_confirmar_tecla
                || (
                    batalha_mouse_opcao >= 0
                    && ui_toque_pressionado
                );

            if (acao_confirmar) {
                switch (batalha_acao_opcao) {
                    case 0:
                        batalha_executar_golpe(0);
                    break;

                    case 1:
                        batalha_menu = 1;
                        batalha_tecnica_opcao = 0;
                        batalha_mensagem = "Escolha uma técnica da Lâmina do Fragmento.";
                        global.tocar_som_ui(1.06);
                    break;

                    case 2:
                        var curativos_abrir = global.inventario_itens_curativos(true);

                        if (array_length(curativos_abrir) <= 0) {
                            batalha_mensagem = "A bolsa não possui itens curativos.";
                            global.tocar_som_ui(0.90);
                        }
                        else {
                            batalha_menu = 2;
                            batalha_item_opcao = 0;
                            batalha_mensagem = "Escolha um item. Usá-lo consumirá este turno.";
                            global.tocar_som_ui(1.06);
                        }
                    break;

                    case 3:
                        batalha_assumir_guarda();
                    break;
                }
            }
        }
        else if (batalha_menu == 1) {
            // Técnicas especiais; o ataque básico permanece sempre disponível.
            if (batalha_cima || batalha_esquerda) {
                batalha_tecnica_opcao = (batalha_tecnica_opcao + 2) mod 3;
                global.tocar_som_ui(0.98);
            }

            if (batalha_baixo || batalha_direita) {
                batalha_tecnica_opcao = (batalha_tecnica_opcao + 1) mod 3;
                global.tocar_som_ui(1.04);
            }

            for (var tecnica_mouse_i = 0; tecnica_mouse_i < 3; tecnica_mouse_i++) {
                var tecnica_mouse_y1 = 578 + tecnica_mouse_i * 62;

                if (point_in_rectangle(
                    duelo_mouse_x,
                    duelo_mouse_y,
                    720,
                    tecnica_mouse_y1,
                    1206,
                    tecnica_mouse_y1 + 60
                )) {
                    batalha_mouse_opcao = tecnica_mouse_i;
                    batalha_tecnica_opcao = tecnica_mouse_i;
                }
            }

            if (keyboard_check_pressed(vk_escape)) {
                batalha_menu = 0;
                batalha_mensagem = "O que Kiran deve fazer?";
                global.tocar_som_ui(0.94);
            }
            else if (
                batalha_confirmar_tecla
                || (
                    batalha_mouse_opcao >= 0
                    && ui_toque_pressionado
                )
            ) {
                batalha_executar_golpe(batalha_tecnica_opcao + 1);
            }
        }
        else if (batalha_menu == 2) {
            var curativos_batalha = global.inventario_itens_curativos(true);
            var curativos_total = array_length(curativos_batalha);

            if (curativos_total <= 0) {
                batalha_menu = 0;
                batalha_item_opcao = 0;
                batalha_mensagem = "A bolsa ficou vazia.";
            }
            else {
                batalha_item_opcao = clamp(
                    batalha_item_opcao,
                    0,
                    curativos_total - 1
                );

                if (batalha_cima || batalha_esquerda) {
                    batalha_item_opcao--;
                    if (batalha_item_opcao < 0) batalha_item_opcao = curativos_total - 1;
                    global.tocar_som_ui(0.98);
                }

                if (batalha_baixo || batalha_direita) {
                    batalha_item_opcao++;
                    if (batalha_item_opcao >= curativos_total) batalha_item_opcao = 0;
                    global.tocar_som_ui(1.04);
                }

                var curativos_visiveis = min(curativos_total, 3);
                var curativos_inicio = clamp(
                    batalha_item_opcao - 2,
                    0,
                    max(0, curativos_total - curativos_visiveis)
                );
                for (var item_mouse_i = 0; item_mouse_i < curativos_visiveis; item_mouse_i++) {
                    var item_mouse_y1 = 582 + item_mouse_i * 58;

                    if (point_in_rectangle(
                        duelo_mouse_x,
                        duelo_mouse_y,
                        728,
                        item_mouse_y1,
                        1206,
                        item_mouse_y1 + 50
                    )) {
                        batalha_mouse_opcao = curativos_inicio + item_mouse_i;
                        batalha_item_opcao = curativos_inicio + item_mouse_i;
                    }
                }

                if (keyboard_check_pressed(vk_escape)) {
                    batalha_menu = 0;
                    batalha_mensagem = "O que Kiran deve fazer?";
                    global.tocar_som_ui(0.94);
                }
                else if (
                    batalha_confirmar_tecla
                    || (
                        batalha_mouse_opcao >= 0
                        && ui_toque_pressionado
                    )
                ) {
                    batalha_usar_consumivel(batalha_item_opcao);
                }
            }
        }
    }
    else if (batalha_fase == 0 && batalha_bloqueio <= 0 && false) {
        // Navegação em uma grade de quatro golpes, como em um RPG por turnos.
        if (
            keyboard_check_pressed(vk_left)
            || keyboard_check_pressed(vk_right)
            || keyboard_check_pressed(ord("A"))
            || keyboard_check_pressed(ord("D"))
        ) {
            batalha_opcao = floor(batalha_opcao / 2) * 2
                + (1 - (batalha_opcao mod 2));
            global.tocar_som_ui(1.02);
        }

        if (
            keyboard_check_pressed(vk_up)
            || keyboard_check_pressed(vk_down)
            || keyboard_check_pressed(ord("W"))
            || keyboard_check_pressed(ord("S"))
        ) {
            batalha_opcao = (batalha_opcao + 2) mod 4;
            global.tocar_som_ui(1.02);
        }

        batalha_mouse_opcao = -1;

        for (var duelo_mouse_i = 0; duelo_mouse_i < 4; duelo_mouse_i++) {
            var duelo_col = duelo_mouse_i mod 2;
            var duelo_lin = floor(duelo_mouse_i / 2);
            var duelo_x1 = 145 + duelo_col * 505;
            var duelo_y1 = 558 + duelo_lin * 76;
            var duelo_x2 = duelo_x1 + 485;
            var duelo_y2 = duelo_y1 + 58;

            if (point_in_rectangle(
                duelo_mouse_x, duelo_mouse_y,
                duelo_x1, duelo_y1, duelo_x2, duelo_y2
            )) {
                batalha_mouse_opcao = duelo_mouse_i;
                batalha_opcao = duelo_mouse_i;
            }
        }

        if (keyboard_check_pressed(vk_escape)) {
            global.guardas_recusados[batalha_inimigo]++;
            batalha_mensagem = falas_recuo[batalha_inimigo];
            batalha_fase = -2;
            batalha_bloqueio = 10;
            global.tocar_som_ui(0.90);
            exit;
        }

        var duelo_confirmar =
            keyboard_check_pressed(vk_space)
            || keyboard_check_pressed(vk_enter)
            || (
                batalha_mouse_opcao >= 0
                && ui_toque_pressionado
            );

        if (duelo_confirmar) {
            var duelo_custo = batalha_custos_golpes[batalha_opcao];

            if (batalha_energia < duelo_custo) {
                batalha_mensagem = "Energia insuficiente. Use Corte Prismático para recuperá-la.";
                global.tocar_som_ui(0.90);
            }
            else {
                batalha_energia -= duelo_custo;

                var duelo_tipo = batalha_tipos_golpes[batalha_opcao];
                var duelo_multiplicador = 1;
                batalha_ultimo_foi_fraqueza = duelo_tipo == fraquezas_inimigos[batalha_inimigo];

                if (batalha_ultimo_foi_fraqueza) {
                    duelo_multiplicador = 1.65;
                }
                else if (duelo_tipo == tipos_inimigos[batalha_inimigo]) {
                    duelo_multiplicador = 0.72;
                }

                var duelo_critico = batalha_opcao == 3 && irandom(3) == 0;
                if (duelo_critico) {
                    duelo_multiplicador *= 1.45;
                }

                var duelo_dano = max(1, round(
                    batalha_poder_golpes[batalha_opcao]
                    * duelo_multiplicador
                    * random_range(0.92, 1.08)
                ));

                batalha_corrupcao = max(0, batalha_corrupcao - duelo_dano);

                var duelo_cura = 0;

                if (batalha_opcao == 1) {
                    var duelo_hp_antes = batalha_serenidade;
                    batalha_serenidade = min(global.vida_kiran_max, batalha_serenidade + 12);
                    duelo_cura = batalha_serenidade - duelo_hp_antes;
                    global.vida_kiran = batalha_serenidade;
                }

                if (batalha_opcao == 2) {
                    batalha_npc_enfraquecido = true;
                }

                batalha_mensagem = "Kiran usou " + batalha_opcoes[batalha_opcao]
                    + " e causou " + string(duelo_dano) + " de dano.";

                if (duelo_cura > 0) {
                    batalha_mensagem += " Kiran recuperou "
                        + string(duelo_cura) + " de HP.";
                }

                if (batalha_ultimo_foi_fraqueza) {
                    batalha_mensagem += " Super efetivo!";
                }
                else if (duelo_multiplicador < 1) {
                    batalha_mensagem += " Não foi muito efetivo.";
                }

                if (duelo_critico) {
                    batalha_mensagem += " Acerto crítico!";
                }

                if (batalha_corrupcao <= 0) {
                    batalha_fase = 2;
                    batalha_mensagem = nomes_inimigos[batalha_inimigo]
                        + ": “" + falas_derrota_guardas[batalha_inimigo]
                        + "”  Oferenda recebida: "
                        + global.oferendas_estatuas[batalha_inimigo] + ".";

                    if (!batalha_recompensa_recebida) {
                        batalha_recompensa_recebida = true;
                        global.inimigos_derrotados[batalha_inimigo] = true;
                        recompensa_nome = global.oferendas_estatuas[batalha_inimigo];
                        recompensa_descricao = descricoes_oferendas[batalha_inimigo];
                        recompensa_sprite = sprites_oferendas[batalha_inimigo];
                        recompensa_toast_pendente = true;
                        global.inventario_adicionar_item(
                            global.oferendas_estatuas[batalha_inimigo],
                            descricoes_oferendas[batalha_inimigo],
                            cores_inimigos[batalha_inimigo],
                            "flor",
                            sprites_oferendas[batalha_inimigo]
                        );
                    }
                }
                else {
                    var duelo_usar_golpe_forte = irandom(1) == 1;
                    var duelo_bonus_elite = 0;

                    if (
                        batalha_inimigo == 3
                        && batalha_corrupcao <= batalha_hp_max_inimigo * 0.5
                    ) {
                        duelo_usar_golpe_forte = true;
                        duelo_bonus_elite = 4;

                        if (!batalha_elite_desperto) {
                            batalha_elite_desperto = true;
                            batalha_mensagem += " Orion rompeu o selo da armadura: os golpes dele ficaram mais fortes!";
                        }
                    }

                    batalha_golpe_pendente = duelo_usar_golpe_forte
                        ? golpes_inimigos_fortes[batalha_inimigo]
                        : golpes_inimigos[batalha_inimigo];
                    batalha_dano_pendente = irandom_range(
                        dano_min_inimigos[batalha_inimigo],
                        dano_max_inimigos[batalha_inimigo]
                    ) + duelo_bonus_elite;

                    if (batalha_npc_enfraquecido) {
                        batalha_dano_pendente = max(1, batalha_dano_pendente - 6);
                        batalha_npc_enfraquecido = false;
                    }

                    batalha_defesa_timer = batalha_defesa_total;
                    batalha_fase = 4;
                    batalha_mensagem += " " + nomes_inimigos[batalha_inimigo]
                        + " prepara " + batalha_golpe_pendente
                        + ". Acerte o centro para se defender!";
                }

                global.tocar_som_ui(1.08);
            }
        }
    }
    else if (
        (batalha_fase == 2 || batalha_fase == 3)
        && batalha_bloqueio <= 0
        && (
            keyboard_check_pressed(vk_space)
            || keyboard_check_pressed(vk_enter)
            || keyboard_check_pressed(vk_escape)
            || ui_toque_pressionado
        )
    ) {
        encerrar_batalha();
    }

    exit;
}

// Versão anterior mantida sem execução durante a troca do protótipo.
if (tela_pause == 5 && false) {
    var batalha_mouse_x = device_mouse_x_to_gui(0);
    var batalha_mouse_y = device_mouse_y_to_gui(0);

    if (batalha_bloqueio > 0) {
        batalha_bloqueio--;
    }

    if (batalha_fase == 1) {
        batalha_timer--;

        if (batalha_timer <= 0) {
            batalha_emocao = (batalha_emocao + irandom_range(1, 2)) mod 3;
            batalha_rodada++;
            batalha_fase = 0;
            batalha_mensagem = "O sentimento mudou. Observe antes de escolher.";
        }
    }
    else if (batalha_fase == 0 && batalha_bloqueio <= 0) {
        // Três respostas diretas: cada sentimento possui um acolhimento correto.
        if (
            keyboard_check_pressed(vk_left)
            || keyboard_check_pressed(ord("A"))
        ) {
            batalha_opcao = (batalha_opcao + 2) mod 3;
            global.tocar_som_ui(0.96);
        }

        if (
            keyboard_check_pressed(vk_right)
            || keyboard_check_pressed(ord("D"))
        ) {
            batalha_opcao = (batalha_opcao + 1) mod 3;
            global.tocar_som_ui(1.04);
        }

        if (
            keyboard_check_pressed(vk_up)
            || keyboard_check_pressed(ord("W"))
        ) {
            batalha_opcao = (batalha_opcao + 2) mod 3;
        }

        if (
            keyboard_check_pressed(vk_down)
            || keyboard_check_pressed(ord("S"))
        ) {
            batalha_opcao = (batalha_opcao + 1) mod 3;
        }

        batalha_mouse_opcao = -1;

        for (var batalha_mouse_i = 0; batalha_mouse_i < 3; batalha_mouse_i++) {
            var batalha_botao_x1 = 145 + batalha_mouse_i * 335;
            var batalha_botao_y1 = 596;
            var batalha_botao_x2 = batalha_botao_x1 + 320;
            var batalha_botao_y2 = 662;

            if (point_in_rectangle(
                batalha_mouse_x,
                batalha_mouse_y,
                batalha_botao_x1,
                batalha_botao_y1,
                batalha_botao_x2,
                batalha_botao_y2
            )) {
                batalha_mouse_opcao = batalha_mouse_i;
                batalha_opcao = batalha_mouse_i;
            }
        }

        var batalha_confirmar =
            keyboard_check_pressed(vk_space)
            || keyboard_check_pressed(vk_enter)
            || (
                batalha_mouse_opcao >= 0
                && ui_toque_pressionado
            );

        if (keyboard_check_pressed(vk_escape)) {
            batalha_mensagem = "Você se afastou para recuperar o fôlego.";
            encerrar_batalha();
            exit;
        }

        if (batalha_confirmar) {
            var batalha_acertou = batalha_opcao == batalha_emocao;
            var batalha_reduzir = batalha_acertou ? 50 : 35;
            var batalha_dano = batalha_acertou ? 2 : 12;

            if (batalha_acertou) {
                batalha_mensagem = "Você acolheu "
                    + string_lower(batalha_emocoes[batalha_emocao])
                    + " da maneira certa. A névoa se desfaz!";
            }
            else {
                batalha_mensagem = "Quase! Observe o símbolo: cada emoção pede um cuidado diferente.";
            }

            batalha_corrupcao = max(0, batalha_corrupcao - batalha_reduzir);

            if (batalha_corrupcao <= 0) {
                batalha_fase = 2;
                batalha_mensagem = nomes_inimigos[batalha_inimigo]
                    + " foi purificado e deixou uma oferenda!";

                if (!batalha_recompensa_recebida) {
                    batalha_recompensa_recebida = true;
                    global.inimigos_derrotados[batalha_inimigo] = true;
                    recompensa_nome = global.oferendas_estatuas[batalha_inimigo];
                    recompensa_descricao = descricoes_oferendas[batalha_inimigo];
                    recompensa_sprite = sprites_oferendas[batalha_inimigo];
                    recompensa_toast_pendente = true;
                    global.inventario_adicionar_item(
                        global.oferendas_estatuas[batalha_inimigo],
                        descricoes_oferendas[batalha_inimigo],
                        cores_inimigos[batalha_inimigo],
                        "flor",
                        sprites_oferendas[batalha_inimigo]
                    );
                }
            }
            else {
                batalha_serenidade = max(0, batalha_serenidade - batalha_dano);

                if (batalha_serenidade <= 0) {
                    batalha_fase = 3;
                    batalha_mensagem = "Kiran precisa descansar antes de tentar novamente.";
                }
                else {
                    batalha_fase = 1;
                    batalha_timer = global.config_reduzir_animacoes ? 7 : 22;
                }
            }

            global.tocar_som_ui(1.08);
        }
    }
    else if (
        (batalha_fase == 2 || batalha_fase == 3)
        && batalha_bloqueio <= 0
        && (
            keyboard_check_pressed(vk_space)
            || keyboard_check_pressed(vk_enter)
            || keyboard_check_pressed(vk_escape)
            || ui_toque_pressionado
        )
    ) {
        encerrar_batalha();
    }

    exit;
}


// ═════════════════════════════════════════════
// FINAL DO CAPÍTULO E ACESSO À RAINHA
// ═════════════════════════════════════════════

// A interação da Rainha vive no controlador que já possui Step registrado.
// Isso não depende dos eventos de Obj_rainha, que o Room Editor havia salvo
// como uma lista vazia.
if (
    room == Room6
    && !global.jogo_pausado
    && !global.dialogue_open
    && !global.encontro_rainha_iniciado
    && !global.capitulo_concluido
    && instance_exists(obj_Kiran)
    && instance_exists(Obj_rainha)
) {
    var rainha_interacao = instance_find(Obj_rainha, 0);
    var kiran_rainha = instance_nearest(rainha_interacao.x, rainha_interacao.y, obj_Kiran);
    var rainha_perto = point_distance(
        rainha_interacao.x,
        rainha_interacao.y,
        kiran_rainha.x,
        kiran_rainha.y
    ) <= 400;

    if (
        rainha_perto
        && (
            keyboard_check_pressed(ord("E"))
            || (variable_global_exists("mobile_interact_pressed") && global.mobile_interact_pressed)
        )
    ) {
        global.encontro_rainha_iniciado = true;
        iniciar_encontro_roteiro(7);
        exit;
    }
}

if (tela_pause == 6) {
    fim_capitulo_timer++;

    if (
        fim_capitulo_timer >= 45
        && (
            keyboard_check_pressed(vk_space)
            || keyboard_check_pressed(vk_enter)
            || ui_toque_pressionado
        )
    ) {
        global.jogo_pausado = false;
        global.dialogue_open = false;
        global.salvar_configuracoes();
        room_goto(rm_menu);
    }

    exit;
}


// Depois que a comandante parte, a extremidade direita de Room1 representa
// o primeiro degrau. Kiran sobe para a sala da Rainha; a audiência só começa
// quando o jogador interagir com ela dentro de Room6.
if (
    room == Room1
    && !global.jogo_pausado
    && !global.dialogue_open
    && global.comandante_partiu
    && !global.encontro_rainha_iniciado
    && instance_exists(obj_Kiran)
) {
    var escada_pronta = true;

    for (var escada_i = 0; escada_i < 4; escada_i++) {
        if (!global.fragmentos_vitral[escada_i]) escada_pronta = false;
    }

    var kiran_escada = instance_nearest(5850, 485, obj_Kiran);

    if (
        escada_pronta
        && point_distance(kiran_escada.x, kiran_escada.y, 5850, 485) <= 145
        && current_time >= global.interacao_bloqueada_ate
        && (
            keyboard_check_pressed(ord("E"))
            || (variable_global_exists("mobile_interact_pressed") && global.mobile_interact_pressed)
        )
    ) {
        global.encontro_rainha_iniciado = false;
        global.interacao_bloqueada_ate = current_time + 180;
        room_goto(Room6);
        exit;
    }
}


// ═════════════════════════════════════════════
// ENCONTROS NO MAPA
// ═════════════════════════════════════════════
inimigo_proximo = -1;

if (!global.config_reduzir_animacoes) {
    tempo_inimigos += 0.055;
}

if (
    !global.jogo_pausado
    && !global.dialogue_open
    && instance_exists(obj_Kiran)
    && (
        !object_exists(obj_inimigo_mapa)
        || instance_number(obj_inimigo_mapa) <= 0
    )
) {
    var jogador_encontro = instance_nearest(x, y, obj_Kiran);
    var menor_distancia_encontro = 95;

    for (var encontro_i = 0; encontro_i < array_length(inimigos_sala_indices); encontro_i++) {
        var encontro_indice = inimigos_sala_indices[encontro_i];

        if (!global.inimigos_derrotados[encontro_indice]) {
            var encontro_distancia = point_distance(
                jogador_encontro.x,
                jogador_encontro.y,
                inimigos_sala_x[encontro_i],
                inimigos_sala_y[encontro_i]
            );

            if (encontro_distancia <= menor_distancia_encontro) {
                menor_distancia_encontro = encontro_distancia;
                inimigo_proximo = encontro_indice;
            }
        }
    }

    if (
        inimigo_proximo >= 0
        && current_time >= global.interacao_bloqueada_ate
        && (
            keyboard_check_pressed(ord("E"))
            || (variable_global_exists("mobile_interact_pressed") && global.mobile_interact_pressed)
        )
    ) {
        global.interacao_bloqueada_ate = current_time + 100;
        if (
            inimigo_proximo != 2
            && !global.guardas_roteiro_visto[inimigo_proximo]
        ) {
            iniciar_encontro_roteiro(3 + inimigo_proximo);
        }
        else if (inimigo_proximo == 2 && !global.florakii_roteiro_visto) {
            iniciar_encontro_roteiro(2);
        }
        else {
            iniciar_confronto(inimigo_proximo);
        }
        exit;
    }
}


// ═════════════════════════════════════════════
// ABRIR O MENU DE PAUSA
// ═════════════════════════════════════════════
if (!global.jogo_pausado) {
    if (
        ui_mobile_bolsa
        || (
            variable_global_exists("mobile_inventory_pressed")
            && global.mobile_inventory_pressed
        )
    ) {
        global.jogo_pausado = true;
        global.tocar_som_ui(1.08);

        tela_pause = 4;
        opcao_pause = 2;
        mouse_pause = -1;
        config_arrastando = -1;
    }
    else if (
        ui_mobile_ajustes
        || (
            variable_global_exists("mobile_settings_pressed")
            && global.mobile_settings_pressed
        )
    ) {
        global.jogo_pausado = true;
        global.tocar_som_ui(1.06);

        tela_pause = 2;
        opcao_pause = 4;
        config_opcao_atual = 0;
        mouse_pause = -1;
        config_arrastando = -1;
    }
    else if (keyboard_check_pressed(vk_tab)) {
        global.jogo_pausado = true;
        global.tocar_som_ui(1.08);

        tela_pause = 4;
        opcao_pause = 2;
        mouse_pause = -1;
        config_arrastando = -1;
    }
    else if (
        keyboard_check_pressed(vk_escape)
        || ui_mobile_menu
        || (
            variable_global_exists("mobile_pause_pressed")
            && global.mobile_pause_pressed
        )
    ) {
        global.jogo_pausado = true;
        global.tocar_som_ui(1.02);

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


// Tab abre o inventário a partir de qualquer tela da pausa e fecha o
// inventário diretamente para o jogo quando pressionado novamente.
if (keyboard_check_pressed(vk_tab)) {
    global.tocar_som_ui(tela_pause == 4 ? 0.94 : 1.08);

    if (tela_pause == 4) {
        tela_pause = 0;
        global.jogo_pausado = false;
        global.mobile_inventory_pressed = false;
        global.mobile_settings_pressed = false;
        global.mobile_pause_pressed = false;
    }
    else {
        tela_pause = 4;
        opcao_pause = 2;
        mouse_pause = -1;
        config_arrastando = -1;
    }

    exit;
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
            && ui_toque_pressionado
        )
    ) {
        tela_pause = 0;
        opcao_pause = 3;
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
            && ui_toque_pressionado
        )
    ) {
        tela_pause = 0;
        opcao_pause = 0;
    }

    exit;
}


// ═════════════════════════════════════════════
// TELA DO INVENTÁRIO
// ═════════════════════════════════════════════
if (tela_pause == 4) {
    var inventario_voltar_x1 = 527;
    var inventario_voltar_y1 = 680;
    var inventario_voltar_x2 = 753;
    var inventario_voltar_y2 = 720;

    var inventario_mouse_voltar = point_in_rectangle(
        mouse_gui_x,
        mouse_gui_y,
        inventario_voltar_x1,
        inventario_voltar_y1,
        inventario_voltar_x2,
        inventario_voltar_y2
    );

    // Q e E funcionam como os botões de ombro da referência e trocam
    // de categoria sem disputar as setas usadas na grade de itens.
    var inventario_trocar_aba = 0;

    if (keyboard_check_pressed(ord("Q"))) {
        inventario_trocar_aba = -1;
    }

    if (keyboard_check_pressed(ord("E"))) {
        inventario_trocar_aba = 1;
    }

    // As quatro abas também respondem ao mouse.
    inventario_mouse_aba = -1;

    for (var inv_aba_i = 0; inv_aba_i < 4; inv_aba_i++) {
        var inv_aba_x1 = 252 + inv_aba_i * 201;
        var inv_aba_x2 = inv_aba_x1 + 190;

        if (
            point_in_rectangle(
                mouse_gui_x,
                mouse_gui_y,
                inv_aba_x1,
                90,
                inv_aba_x2,
                161
            )
        ) {
            inventario_mouse_aba = inv_aba_i;

            if (ui_toque_pressionado) {
                inventario_aba = inv_aba_i;
                inventario_slot = 0;
                global.tocar_som_ui(1.04);
            }
        }
    }

    if (inventario_trocar_aba != 0) {
        inventario_aba += inventario_trocar_aba;

        if (inventario_aba < 0) {
            inventario_aba = 3;
        }

        if (inventario_aba > 3) {
            inventario_aba = 0;
        }

        inventario_slot = 0;
        global.tocar_som_ui(inventario_trocar_aba > 0 ? 1.08 : 0.92);
    }

    // Quantidade de entradas reais em cada categoria.
    var inventario_total = 0;

    switch (inventario_aba) {
        case 0:
            inventario_total = array_length(global.inventario_itens);
        break;

        case 1:
            inventario_total = array_length(global.inventario_armas);
            for (var inv_total_caco = 0; inv_total_caco < 4; inv_total_caco++) {
                if (global.fragmentos_vitral[inv_total_caco]) inventario_total++;
            }
        break;

        case 2:
            inventario_total = array_length(global.inventario_roupas);
        break;

        case 3:
            // Duas missões acompanham o progresso atual da história.
            inventario_total = 2
                + array_length(global.inventario_missoes);
        break;
    }

    var inventario_limite_visivel = inventario_aba == 3 ? 4 : 8;
    inventario_total = min(inventario_total, inventario_limite_visivel);

    if (inventario_total > 0) {
        inventario_slot = clamp(inventario_slot, 0, inventario_total - 1);

        var inventario_colunas = inventario_aba == 3 ? 1 : 4;
        var inventario_slot_anterior = inventario_slot;

        if (keyboard_check_pressed(vk_left)) {
            inventario_slot--;
        }

        if (keyboard_check_pressed(vk_right)) {
            inventario_slot++;
        }

        if (keyboard_check_pressed(vk_up)) {
            inventario_slot -= inventario_colunas;
        }

        if (keyboard_check_pressed(vk_down)) {
            inventario_slot += inventario_colunas;
        }

        inventario_slot = clamp(inventario_slot, 0, inventario_total - 1);

        if (inventario_slot != inventario_slot_anterior) {
            global.tocar_som_ui(inventario_slot > inventario_slot_anterior ? 1.06 : 0.94);
        }
    }
    else {
        inventario_slot = 0;
    }

    // Seleção por mouse: grade nas quatro primeiras abas e lista em Missões.
    inventario_mouse_slot = -1;

    if (inventario_aba == 3) {
        for (var inv_missao_i = 0; inv_missao_i < inventario_total; inv_missao_i++) {
            var inv_missao_y1 = 276 + inv_missao_i * 86;

            if (
                point_in_rectangle(
                    mouse_gui_x,
                    mouse_gui_y,
                    154,
                    inv_missao_y1,
                    538,
                    inv_missao_y1 + 72
                )
            ) {
                inventario_mouse_slot = inv_missao_i;
            }
        }
    }
    else {
        for (var inv_slot_i = 0; inv_slot_i < inventario_total; inv_slot_i++) {
            var inv_slot_coluna = inv_slot_i mod 4;
            var inv_slot_linha = floor(inv_slot_i / 4);
            var inv_slot_x1 = 146 + inv_slot_coluna * 111;
            var inv_slot_y1 = 242 + inv_slot_linha * 116;

            if (
                point_in_rectangle(
                    mouse_gui_x,
                    mouse_gui_y,
                    inv_slot_x1,
                    inv_slot_y1,
                    inv_slot_x1 + 96,
                    inv_slot_y1 + 99
                )
            ) {
                inventario_mouse_slot = inv_slot_i;
            }
        }
    }

    if (
        inventario_mouse_slot >= 0
        && ui_toque_pressionado
    ) {
        inventario_slot = inventario_mouse_slot;
        global.tocar_som_ui(1.02);
    }

    // Consumíveis podem ser usados sem sair do inventário. O clique só ativa
    // o item no botão dedicado, evitando consumir algo ao selecionar um slot.
    var inventario_mouse_usar = point_in_rectangle(
        mouse_gui_x,
        mouse_gui_y,
        756,
        596,
        968,
        642
    );
    var inventario_confirmar_uso =
        keyboard_check_pressed(vk_space)
        || keyboard_check_pressed(vk_enter)
        || (inventario_mouse_usar && ui_toque_pressionado);

    if (
        inventario_confirmar_uso
        && inventario_aba == 0
        && inventario_total > 0
        && inventario_slot < array_length(global.inventario_itens)
    ) {
        var inventario_item_usar = global.inventario_itens[inventario_slot];
        var inventario_eh_cura =
            variable_struct_exists(inventario_item_usar, "consumivel")
            && inventario_item_usar.consumivel
            && variable_struct_exists(inventario_item_usar, "cura")
            && inventario_item_usar.cura > 0
            && variable_struct_exists(inventario_item_usar, "usavel_mapa")
            && inventario_item_usar.usavel_mapa;

        if (!inventario_eh_cura) {
            inventario_mensagem = "Este item não pode ser usado agora.";
            inventario_mensagem_timer = 100;
            global.tocar_som_ui(0.90);
        }
        else if (global.vida_kiran >= global.vida_kiran_max) {
            inventario_mensagem = "Kiran já está com a vida completa.";
            inventario_mensagem_timer = 100;
            global.tocar_som_ui(0.92);
        }
        else {
            var inventario_vida_antes = global.vida_kiran;
            global.vida_kiran = min(
                global.vida_kiran_max,
                global.vida_kiran + inventario_item_usar.cura
            );
            var inventario_cura_real = global.vida_kiran - inventario_vida_antes;
            var inventario_id_usar = variable_struct_exists(inventario_item_usar, "id")
                ? inventario_item_usar.id
                : inventario_item_usar.nome;

            global.inventario_remover_item_id(inventario_id_usar);
            inventario_mensagem = inventario_item_usar.nome
                + " restaurou " + string(inventario_cura_real) + " de vida.";
            inventario_mensagem_timer = 130;
            hud_vida_feedback = 1;
            hud_vida_feedback_timer = hud_vida_feedback_total;
            global.tocar_som_ui(1.12);
        }
    }

    if (
        keyboard_check_pressed(vk_escape)
        || keyboard_check_pressed(vk_tab)
        || keyboard_check_pressed(vk_backspace)
        || (
            inventario_mouse_voltar
            && ui_toque_pressionado
        )
    ) {
        tela_pause = 0;
        opcao_pause = 0;
        global.jogo_pausado = false;
        global.mobile_inventory_pressed = false;
        global.mobile_settings_pressed = false;
        global.mobile_pause_pressed = false;
        global.tocar_som_ui(0.94);
    }

    exit;
}


// ═════════════════════════════════════════════
// TELA DE CONFIGURAÇÕES
// ═════════════════════════════════════════════
if (tela_pause == 2) {
    var cfg_y = [
        205,
        275,
        345,
        415,
        485,
        555,
        625,
        720
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


    // Navegação vertical
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


    // Começar a arrastar sliders
    if (ui_toque_pressionado) {
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
    if (ui_toque_seguro) {
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
        if (config_arrastando == 1) {
            global.tocar_som_ui(1.10);
        }

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

        global.tocar_som_ui(cfg_direita ? 1.08 : 0.92);
    }


    // Cliques nos interruptores
    if (ui_toque_pressionado) {
        if (
            point_in_rectangle(
                mouse_gui_x,
                mouse_gui_y,
                930,
                cfg_y[2] - 25,
                1060,
                cfg_y[2] + 25
            )
        ) {
            global.config_baixo_estimulo =
                !global.config_baixo_estimulo;
            global.tocar_som_ui(1.05);
        }

        if (
            point_in_rectangle(
                mouse_gui_x,
                mouse_gui_y,
                930,
                cfg_y[3] - 25,
                1060,
                cfg_y[3] + 25
            )
        ) {
            global.config_reduzir_animacoes =
                !global.config_reduzir_animacoes;
            global.tocar_som_ui(1.05);
        }
    }


    // Cliques nas setas
    if (ui_toque_pressionado) {

        // Velocidade esquerda
        if (
            point_in_rectangle(
                mouse_gui_x,
                mouse_gui_y,
                640,
                cfg_y[4] - 25,
                725,
                cfg_y[4] + 25
            )
        ) {
            global.config_velocidade_texto = max(
                0,
                global.config_velocidade_texto - 1
            );
            global.tocar_som_ui(0.92);
        }

        // Velocidade direita
        if (
            point_in_rectangle(
                mouse_gui_x,
                mouse_gui_y,
                970,
                cfg_y[4] - 25,
                1055,
                cfg_y[4] + 25
            )
        ) {
            global.config_velocidade_texto = min(
                2,
                global.config_velocidade_texto + 1
            );
            global.tocar_som_ui(1.08);
        }

        // Tamanho esquerda
        if (
            point_in_rectangle(
                mouse_gui_x,
                mouse_gui_y,
                640,
                cfg_y[5] - 25,
                725,
                cfg_y[5] + 25
            )
        ) {
            global.config_tamanho_texto = max(
                0,
                global.config_tamanho_texto - 1
            );
            global.tocar_som_ui(0.92);
        }

        // Tamanho direita
        if (
            point_in_rectangle(
                mouse_gui_x,
                mouse_gui_y,
                970,
                cfg_y[5] - 25,
                1055,
                cfg_y[5] + 25
            )
        ) {
            global.config_tamanho_texto = min(
                2,
                global.config_tamanho_texto + 1
            );
            global.tocar_som_ui(1.08);
        }

        // Contraste esquerda
        if (
            point_in_rectangle(
                mouse_gui_x,
                mouse_gui_y,
                640,
                cfg_y[6] - 25,
                725,
                cfg_y[6] + 25
            )
        ) {
            global.config_contraste = 0;
            global.tocar_som_ui(0.92);
        }

        // Contraste direita
        if (
            point_in_rectangle(
                mouse_gui_x,
                mouse_gui_y,
                970,
                cfg_y[6] - 25,
                1055,
                cfg_y[6] + 25
            )
        ) {
            global.config_contraste = 1;
            global.tocar_som_ui(1.08);
        }
    }


    // Espaço, Enter ou E
    if (
        keyboard_check_pressed(vk_space)
        || keyboard_check_pressed(vk_enter)
        || keyboard_check_pressed(ord("E"))
    ) {
        switch (config_opcao_atual) {
            case 2:
                global.config_baixo_estimulo =
                    !global.config_baixo_estimulo;
                global.tocar_som_ui(1.05);
            break;

            case 3:
                global.config_reduzir_animacoes =
                    !global.config_reduzir_animacoes;
                global.tocar_som_ui(1.05);
            break;

            case 7:
                tela_pause = 0;
                opcao_pause = 0;
                global.jogo_pausado = false;
                config_arrastando = -1;
                global.mobile_inventory_pressed = false;
                global.mobile_settings_pressed = false;
                global.mobile_pause_pressed = false;
                global.salvar_configuracoes();
                global.tocar_som_ui(0.94);
            break;
        }
    }


    // Botão voltar
    var cfg_voltar_x1 = 515;
    var cfg_voltar_y1 = cfg_y[7] - 30;
    var cfg_voltar_x2 = 765;
    var cfg_voltar_y2 = cfg_y[7] + 30;

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
        && ui_toque_pressionado
    ) {
        tela_pause = 0;
        opcao_pause = 0;
        global.jogo_pausado = false;
        config_arrastando = -1;
        global.mobile_inventory_pressed = false;
        global.mobile_settings_pressed = false;
        global.mobile_pause_pressed = false;
        global.salvar_configuracoes();
        global.tocar_som_ui(0.94);
    }

    if (
        keyboard_check_pressed(vk_escape)
        || keyboard_check_pressed(vk_backspace)
    ) {
        tela_pause = 0;
        opcao_pause = 0;
        global.jogo_pausado = false;
        config_arrastando = -1;
        global.mobile_inventory_pressed = false;
        global.mobile_settings_pressed = false;
        global.mobile_pause_pressed = false;
        global.salvar_configuracoes();
        global.tocar_som_ui(0.94);
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

    global.tocar_som_ui(0.94);
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

    global.tocar_som_ui(1.06);
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
    && ui_toque_pressionado
) {
    opcao_pause = mouse_pause;
    confirmar_pause = true;
}


// Executar opção
if (confirmar_pause) {
    global.tocar_som_ui(1.12);

    switch (opcao_pause) {

        case 0:
            tela_pause = 3;
            resp_tempo = 0;
        break;

        case 1:
            global.jogo_pausado = false;
        break;

        case 2:
            tela_pause = 4;
        break;

        case 3:
            tela_pause = 1;
        break;

        case 4:
            tela_pause = 2;
            config_opcao_atual = 0;
        break;

        case 5:
            global.jogo_pausado = false;
            global.salvar_configuracoes();

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
