// ─────────────────────────────────────────────
// REVELAÇÃO DO TEXTO
// ─────────────────────────────────────────────
if (ativo && !escolha_ativa && !texto_completo) {
    var reduzir_texto =
        variable_global_exists("config_reduzir_animacoes")
        && global.config_reduzir_animacoes;

    if (reduzir_texto) {
        caracteres_visiveis = string_length(texto);
    }
    else {
        var velocidade_escolhida = variable_global_exists("config_velocidade_texto")
            ? clamp(global.config_velocidade_texto, 0, 2)
            : 1;

        var caracteres_por_frame = [0.48, 0.92, 1.75];
        revelacao_acumulada += caracteres_por_frame[velocidade_escolhida];
        caracteres_visiveis = min(
            string_length(texto),
            floor(revelacao_acumulada)
        );
    }

    texto_visivel = string_copy(texto, 1, caracteres_visiveis);

    if (caracteres_visiveis >= string_length(texto)) {
        texto_visivel = texto;
        texto_completo = true;
    }
}

// ─────────────────────────────────────────────
// ESCOLHAS
// ─────────────────────────────────────────────
if (ativo && escolha_ativa) {

    // Evita que o E usado para falar com a Lorun confirme imediatamente
    // a primeira resposta no mesmo frame.
    if (bloqueio_entrada_escolha > 0) {
        bloqueio_entrada_escolha--;
        global.dialogue_open = true;
        exit;
    }

    // No celular, cada cartão é uma área de toque direta. As dimensões são as
    // mesmas usadas no Draw GUI para o toque acompanhar a interface em qualquer
    // resolução.
    var confirmou_por_toque = false;
    if (
        variable_global_exists("mobile_mode")
        && global.mobile_mode
    ) {
        var toque_gui_w = display_get_gui_width();
        var toque_gui_h = display_get_gui_height();
        var toque_total = array_length(opcoes);
        var toque_opcao_h = toque_total >= 4 ? 104 : 120;
        var toque_caixa_w = toque_gui_w - 64;
        var toque_caixa_h = 154 + toque_total * toque_opcao_h
            + max(0, toque_total - 1) * 12;
        var toque_x1 = (toque_gui_w - toque_caixa_w) / 2;
        var toque_y1 = max(100, toque_gui_h - toque_caixa_h - 78);
        var toque_opcao_x1 = toque_x1 + 28;
        var toque_opcao_x2 = toque_x1 + toque_caixa_w - 28;
        var toque_opcao_y = toque_y1 + 92;
        var toque_espaco = 12;

        for (var toque_dedo = 0; toque_dedo < 5; toque_dedo++) {
            if (!device_mouse_check_button_pressed(toque_dedo, mb_left)) continue;

            var toque_x = device_mouse_x_to_gui(toque_dedo);
            var toque_y = device_mouse_y_to_gui(toque_dedo);

            for (var toque_i = 0; toque_i < toque_total; toque_i++) {
                var toque_linha_y1 = toque_opcao_y
                    + toque_i * (toque_opcao_h + toque_espaco);
                var toque_linha_y2 = toque_linha_y1 + toque_opcao_h;

                if (point_in_rectangle(
                    toque_x,
                    toque_y,
                    toque_opcao_x1,
                    toque_linha_y1,
                    toque_opcao_x2,
                    toque_linha_y2
                )) {
                    opcao_atual = toque_i;
                    confirmou_por_toque = true;
                    break;
                }
            }

            if (confirmou_por_toque) break;
        }
    }

    // Subir
    if (
        keyboard_check_pressed(vk_up)
        || keyboard_check_pressed(ord("W"))
    ) {
        opcao_atual--;

        if (opcao_atual < 0) {
            opcao_atual = array_length(opcoes) - 1;
        }
    }

    // Descer
    if (
        keyboard_check_pressed(vk_down)
        || keyboard_check_pressed(ord("S"))
    ) {
        opcao_atual++;

        if (opcao_atual >= array_length(opcoes)) {
            opcao_atual = 0;
        }
    }

    // Confirmar escolha
    if (
        keyboard_check_pressed(vk_space)
        || keyboard_check_pressed(vk_enter)
        || keyboard_check_pressed(ord("E"))
        || confirmou_por_toque
    ) {
        // Guarda a sequência antes de limpar as opções
        ultima_opcao_escolhida = opcao_atual;
        ultima_escolha_contexto = escolha_contexto;
        var sequencia_escolhida = respostas_opcoes[opcao_atual];
        var metadado_escolhido = opcoes_metadados[opcao_atual];

        if (
            is_struct(metadado_escolhido)
            && variable_global_exists("adicionar_ponto_rota")
        ) {
            global.adicionar_ponto_rota(
                metadado_escolhido.rota,
                metadado_escolhido.pontos,
                metadado_escolhido.id
            );
        }

        if (variable_global_exists("tocar_som_ui")) {
            global.tocar_som_ui(1.10);
        }

        escolha_ativa = false;
        opcoes = [];
        opcoes_metadados = [];
        respostas_opcoes = [];

        // Abre a pergunta do ??? e a resposta do Lorun
        iniciar_dialogo(sequencia_escolhida);

        global.dialogue_open = true;

        // Impede o mesmo botão de avançar duas vezes
        exit;
    }
}

// ─────────────────────────────────────────────
// DIÁLOGO NORMAL
// ─────────────────────────────────────────────
if (
    ativo
    && !escolha_ativa
    && (
        keyboard_check_pressed(vk_space)
        || keyboard_check_pressed(vk_enter)
        || (
            variable_global_exists("mobile_mode")
            && global.mobile_mode
            && device_mouse_check_button_pressed(0, mb_left)
        )
    )
) {
    // O primeiro toque mostra a fala inteira; o seguinte avança.
    if (!texto_completo) {
        caracteres_visiveis = string_length(texto);
        revelacao_acumulada = caracteres_visiveis;
        texto_visivel = texto;
        texto_completo = true;

        if (variable_global_exists("tocar_som_ui")) {
            global.tocar_som_ui(1.04);
        }

        exit;
    }

    if (variable_global_exists("tocar_som_ui")) {
        global.tocar_som_ui(1.10);
    }

    fala_atual++;

    if (fala_atual < array_length(falas)) {
        var fala = falas[fala_atual];

        if (is_struct(fala)) {
            nome_falante = fala.nome;
            preparar_texto_dialogo(fala.texto);
        } else {
            preparar_texto_dialogo(fala);
        }
    } else {
        ativo = false;
        nome_falante = "";
        texto = "";
        texto_visivel = "";
        texto_completo = true;

        // O tutorial aparece somente depois do diálogo inicial terminar.
        if (
            variable_global_exists("tutorial_controles_pendente")
            && global.tutorial_controles_pendente
            && !instance_exists(obj_tutorial_controles)
        ) {
            instance_create_depth(0, 0, -100000, obj_tutorial_controles);
            global.tutorial_controles_pendente = false;
            global.tutorial_controles_mostrado = true;
        }
    }
}

global.dialogue_open = ativo;
