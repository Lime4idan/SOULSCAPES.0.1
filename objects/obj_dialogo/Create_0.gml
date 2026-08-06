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


// ═════════════════════════════════════════════
// VARIÁVEIS DO SISTEMA
// ═════════════════════════════════════════════
nome_falante = "";

ativo = false;

falas = [];
fala_atual = 0;
texto = "";


// ═════════════════════════════════════════════
// SISTEMA DE ESCOLHAS
// ═════════════════════════════════════════════
escolha_ativa = false;

opcoes = [];
respostas_opcoes = [];

opcao_atual = 0;


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
        texto = primeira_fala.texto;
    }
    else {
        texto = primeira_fala;
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
    _respostas
) {
    opcoes = _opcoes;
    respostas_opcoes = _respostas;

    opcao_atual = 0;
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

    iniciar_dialogo_com_nome(
        "???",
        [
            "Onde... eu estou?",
            "Eu não consigo me lembrar de nada...",
            "Talvez eu deva explorar este lugar."
        ]
    );
}