// ─────────────────────────────────────────────
// FLUTUAÇÃO SUAVE
// ─────────────────────────────────────────────
var lorun_pausada =
    variable_global_exists("jogo_pausado")
    && global.jogo_pausado;

var lorun_reduzir_movimento =
    variable_global_exists("config_reduzir_animacoes")
    && global.config_reduzir_animacoes;

if (!lorun_pausada && !lorun_reduzir_movimento) {
    lorun_aura_tempo += lorun_flutuar_velocidade;
}

var lorun_flutuar_destino = lorun_reduzir_movimento
    ? 0
    : sin(lorun_aura_tempo) * lorun_flutuar_altura;

lorun_flutuar_y = lerp(
    lorun_flutuar_y,
    lorun_flutuar_destino,
    lorun_reduzir_movimento ? 0.12 : 0.18
);


// ─────────────────────────────────────────────
// DISTÂNCIA DE INTERAÇÃO
// ─────────────────────────────────────────────
pode_interagir = false;

if (instance_exists(obj_Kiran)) {
    var jogador = instance_nearest(x, y, obj_Kiran);
    var distancia = point_distance(x, y, jogador.x, jogador.y);
    pode_interagir = distancia <= distancia_interacao;
}

if (lorun_pausada) {
    exit;
}

var dialogo = instance_find(obj_dialogo, 0);

if (!instance_exists(dialogo)) {
    exit;
}


// ─────────────────────────────────────────────
// PRIMEIRO ENCONTRO
// ─────────────────────────────────────────────
if (
    etapa_conversa == 0
    && pode_interagir
    && !global.dialogue_open
    && (
        keyboard_check_pressed(ord("E"))
        || (variable_global_exists("mobile_interact_pressed") && global.mobile_interact_pressed)
    )
) {
    etapa_conversa = 1;
    global.lorun_apresentada = true;
    dialogo.iniciar_dialogo(lorun_intro);

    exit;
}


// Primeira escolha do roteiro novo.
if (
    etapa_conversa == 1
    && !global.dialogue_open
) {
    etapa_conversa = 2;
    dialogo.nome_falante = "Kiran";
    dialogo.texto = "O que Kiran pergunta?";
    dialogo.iniciar_escolha(lorun_opcoes1, lorun_rotas1, "lorun_primeira_escolha");
    exit;
}

// Todas as primeiras respostas retornam à reflexão sobre identidade.
if (
    etapa_conversa == 2
    && !global.dialogue_open
) {
    etapa_conversa = 3;
    dialogo.iniciar_dialogo(lorun_continuacao);
    exit;
}

// Segunda escolha do primeiro encontro.
if (
    etapa_conversa == 3
    && !global.dialogue_open
) {
    etapa_conversa = 4;
    dialogo.nome_falante = "Kiran";
    dialogo.texto = "O que Kiran sente sobre sua identidade?";
    dialogo.iniciar_escolha(lorun_opcoes2, lorun_rotas2, "lorun_identidade");
    exit;
}

// O vitral abre uma terceira escolha de identidade.
if (
    etapa_conversa == 4
    && !global.dialogue_open
) {
    etapa_conversa = 5;
    dialogo.iniciar_dialogo(lorun_vitral_intro);
    exit;
}

if (
    etapa_conversa == 5
    && !global.dialogue_open
) {
    etapa_conversa = 6;
    dialogo.nome_falante = "Kiran";
    dialogo.texto = "O que Kiran pensa sobre o vitral?";
    dialogo.iniciar_escolha(lorun_opcoes3, lorun_rotas3, "lorun_vitral");
    exit;
}

if (
    etapa_conversa == 6
    && !global.dialogue_open
) {
    etapa_conversa = 7;
    dialogo.iniciar_dialogo(lorun_oferendas_intro);
    exit;
}

if (
    etapa_conversa == 7
    && !global.dialogue_open
) {
    etapa_conversa = 8;
    dialogo.nome_falante = "Kiran";
    dialogo.texto = "O que Kiran pergunta sobre as oferendas?";
    dialogo.iniciar_escolha(lorun_opcoes4, lorun_rotas4, "lorun_oferendas");
    exit;
}

if (
    etapa_conversa == 8
    && !global.dialogue_open
) {
    etapa_conversa = 9;
    dialogo.iniciar_dialogo(lorun_final);
    exit;
}

if (
    etapa_conversa == 9
    && !global.dialogue_open
) {
    etapa_conversa = 10;
    conversa_finalizada = true;
}


// ─────────────────────────────────────────────
// CONVERSAS REPETÍVEIS
// ─────────────────────────────────────────────
if (
    etapa_conversa == 10
    && pode_interagir
    && !global.dialogue_open
    && (
        keyboard_check_pressed(ord("E"))
        || (variable_global_exists("mobile_interact_pressed") && global.mobile_interact_pressed)
    )
) {
    etapa_conversa = 11;
    abrir_assuntos_lorun(dialogo);
}

// Aguardar o assunto repetível e registrar a apresentação da lâmina.
if (
    etapa_conversa == 11
    && !global.dialogue_open
) {
    if (
        opcao_fragmento_indice >= 0
        && dialogo.ultima_escolha_contexto == "lorun_assuntos"
        && dialogo.ultima_opcao_escolhida == opcao_fragmento_indice
        && global.tem_fragmento
    ) {
        global.fragmento_reconhecido = true;
    }

    etapa_conversa = 10;
}
