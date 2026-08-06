// ═════════════════════════════════════════════
// VARIÁVEIS GLOBAIS
// ═════════════════════════════════════════════
if (!variable_global_exists("fragmentos_vitral")) {
    global.fragmentos_vitral = [
        false,
        false,
        false,
        false
    ];
}

if (!variable_global_exists("dialogue_open")) {
    global.dialogue_open = false;
}

if (!variable_global_exists("jogo_pausado")) {
    global.jogo_pausado = false;
}


// ═════════════════════════════════════════════
// CONFIGURAÇÕES
// ═════════════════════════════════════════════

// Esse valor será alterado em cada instância da room
indice_fragmento = 0;

distancia_interacao = 85;

perto_do_fragmento = false;
coletando = false;

tempo_animacao = random(100);
tempo_coleta = 0;

inicializado = false;


// ═════════════════════════════════════════════
// CORES DOS QUATRO FRAGMENTOS
// ═════════════════════════════════════════════
cores_fragmentos = [
    make_color_rgb(139, 181, 194),
    make_color_rgb(163, 174, 207),
    make_color_rgb(174, 194, 163),
    make_color_rgb(194, 166, 193)
];