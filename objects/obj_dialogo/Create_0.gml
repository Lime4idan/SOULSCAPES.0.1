// ═════════════════════════════════════════════
// CONTROLE GLOBAL DO DIÁLOGO
// ═════════════════════════════════════════════

// Ao criar um novo controlador de diálogo,
// ele começa sempre fechado.
global.dialogue_open = false;


// Controla se a fala inicial já apareceu
if (!variable_global_exists("dialogo_inicial_mostrado")) {
    global.dialogo_inicial_mostrado = false;
}

if (!variable_global_exists("tutorial_controles_mostrado")) {
    global.tutorial_controles_mostrado = false;
}

if (!variable_global_exists("tutorial_controles_pendente")) {
    global.tutorial_controles_pendente = false;
}


// ═════════════════════════════════════════════
// VARIÁVEIS DO SISTEMA
// ═════════════════════════════════════════════
nome_falante = "";

ativo = false;

falas = [];
fala_atual = 0;
texto = "";
texto_visivel = "";
caracteres_visiveis = 0;
revelacao_acumulada = 0;
texto_completo = true;


// Preparar uma nova fala para a velocidade de texto escolhida.
preparar_texto_dialogo = function(_novo_texto) {
    texto = _novo_texto;
    caracteres_visiveis = 0;
    revelacao_acumulada = 0;
    texto_visivel = "";
    texto_completo = string_length(texto) <= 0;

    if (
        variable_global_exists("config_reduzir_animacoes")
        && global.config_reduzir_animacoes
    ) {
        caracteres_visiveis = string_length(texto);
        revelacao_acumulada = caracteres_visiveis;
        texto_visivel = texto;
        texto_completo = true;
    }
};


// ═════════════════════════════════════════════
// SISTEMA DE ESCOLHAS
// ═════════════════════════════════════════════
escolha_ativa = false;

opcoes = [];
respostas_opcoes = [];
opcoes_metadados = [];

opcao_atual = 0;
escolha_contexto = "";
ultima_escolha_contexto = "";
ultima_opcao_escolhida = -1;
bloqueio_entrada_escolha = 0;


// ═════════════════════════════════════════════
// INICIAR QUALQUER DIÁLOGO
// ═════════════════════════════════════════════
iniciar_dialogo = function(_falas) {
    // Evita erro caso receba uma lista vazia
    if (array_length(_falas) <= 0) {
        exit;
    }

    falas = _falas;
    fala_atual = 0;

    escolha_ativa = false;

    var primeira_fala = falas[fala_atual];


    // A fala pode ter nome e texto próprios
    if (is_struct(primeira_fala)) {
        nome_falante = primeira_fala.nome;
        preparar_texto_dialogo(primeira_fala.texto);
    }
    else {
        preparar_texto_dialogo(primeira_fala);
    }


    ativo = true;
    global.dialogue_open = true;
};


// ═════════════════════════════════════════════
// INICIAR DIÁLOGO COM UM NOME FIXO
// ═════════════════════════════════════════════
iniciar_dialogo_com_nome = function(
    _nome,
    _falas
) {
    nome_falante = _nome;

    iniciar_dialogo(_falas);
};


// ═════════════════════════════════════════════
// INICIAR ESCOLHA
// ═════════════════════════════════════════════
iniciar_escolha = function(
    _opcoes,
    _respostas,
    _contexto
) {
    opcoes = [];
    opcoes_metadados = [];
    for (var escolha_dado_i = 0; escolha_dado_i < array_length(_opcoes); escolha_dado_i++) {
        var escolha_dado = _opcoes[escolha_dado_i];
        if (is_struct(escolha_dado)) {
            array_push(opcoes, escolha_dado.texto);
            array_push(opcoes_metadados, escolha_dado);
        }
        else {
            array_push(opcoes, escolha_dado);
            array_push(opcoes_metadados, undefined);
        }
    }
    respostas_opcoes = _respostas;

    opcao_atual = 0;
    escolha_contexto = argument_count >= 3 ? _contexto : "";
    ultima_escolha_contexto = "";
    ultima_opcao_escolhida = -1;
    bloqueio_entrada_escolha = 1;
    escolha_ativa = true;

    ativo = true;
    global.dialogue_open = true;
};


// ═════════════════════════════════════════════
// DIÁLOGO INICIAL DO JOGO
// ═════════════════════════════════════════════

// Só acontece na floresta inicial
// e somente uma vez durante a partida.
if (
    room == Room1
    && !global.dialogo_inicial_mostrado
) {
    global.dialogo_inicial_mostrado = true;
    global.tutorial_controles_pendente = !global.tutorial_controles_mostrado;

    iniciar_dialogo_com_nome(
        "???",
        [
            "Where... am I?",
            "I cannot remember anything...",
            "Maybe I should explore this place."
        ]
    );
}
