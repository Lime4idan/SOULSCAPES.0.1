// ─────────────────────────────────────────────
// ESCOLHAS
// ─────────────────────────────────────────────
if (ativo && escolha_ativa) {

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
        keyboard_check_pressed(vk_enter)
        || keyboard_check_pressed(ord("E"))
    ) {
        // Guarda a sequência antes de limpar as opções
        var sequencia_escolhida = respostas_opcoes[opcao_atual];

        escolha_ativa = false;
        opcoes = [];
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
    && keyboard_check_pressed(vk_space)
) {
    fala_atual++;

    if (fala_atual < array_length(falas)) {
        var fala = falas[fala_atual];

        if (is_struct(fala)) {
            nome_falante = fala.nome;
            texto = fala.texto;
        } else {
            texto = fala;
        }
    } else {
        ativo = false;
        nome_falante = "";
        texto = "";
    }
}

global.dialogue_open = ativo;