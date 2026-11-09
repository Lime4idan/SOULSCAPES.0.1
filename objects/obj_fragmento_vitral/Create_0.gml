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

// "indice_fragmento" é editável em cada instância no Room Editor.
// Use valores de 0 a 3 para escolher qual fragmento a estátua guarda.

// Arte futura: sobrescreva no Creation Code da instância ou atribua um sprite
// diretamente ao objeto. Escala e deslocamentos não afetam a interação.
if (!variable_instance_exists(id, "indice_fragmento")) indice_fragmento = 0;
if (!variable_instance_exists(id, "estatua_sprite_com_fragmento")) estatua_sprite_com_fragmento = -1;
if (!variable_instance_exists(id, "estatua_sprite_sem_fragmento")) estatua_sprite_sem_fragmento = -1;
if (!variable_instance_exists(id, "estatua_escala_sprite")) estatua_escala_sprite = 1;
estatua_sprite_personalizado = estatua_sprite_com_fragmento;
estatua_offset_sprite_x = 0;
estatua_offset_sprite_y = 0;

distancia_interacao = 85;

perto_do_fragmento = false;
coletando = false;

tempo_animacao = random(100);
tempo_coleta = 0;

inicializado = false;
fragmento_liberado = false;


// ═════════════════════════════════════════════
// CORES DOS QUATRO FRAGMENTOS
// ═════════════════════════════════════════════
cores_fragmentos = [
    make_color_rgb(139, 181, 194),
    make_color_rgb(163, 174, 207),
    make_color_rgb(174, 194, 163),
    make_color_rgb(194, 166, 193)
];

// Dados provisórios das estátuas guardiãs.
if (!variable_global_exists("oferendas_estatuas")) {
    global.oferendas_estatuas = [
        "Essência de Orvalho",
        "Semente Estelar",
        "Pétala Lunar",
        "Cristal Sereno"
    ];
}

if (!variable_global_exists("inimigos_derrotados")) {
    global.inimigos_derrotados = [false, false, false, false];
}

distancia_interacao = 105;
tem_oferenda = false;
mensagem_estatua = "";
tempo_mensagem_estatua = 0;
