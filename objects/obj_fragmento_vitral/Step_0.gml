// ═════════════════════════════════════════════
// INICIALIZAÇÃO DA INSTÂNCIA
// ═════════════════════════════════════════════
if (!inicializado) {
    indice_fragmento = clamp(
        indice_fragmento,
        0,
        3
    );

    // Se já foi coletado anteriormente,
    // não reaparece ao voltar para a room.
    if (global.fragmentos_vitral[indice_fragmento]) {
        instance_destroy();
        exit;
    }

    inicializado = true;
}


// ═════════════════════════════════════════════
// PAUSA
// ═════════════════════════════════════════════
if (global.jogo_pausado) {
    exit;
}


// ═════════════════════════════════════════════
// ANIMAÇÃO DE COLETA
// ═════════════════════════════════════════════
if (coletando) {
    tempo_coleta--;

    if (tempo_coleta <= 0) {
        instance_destroy();
    }

    exit;
}


// ═════════════════════════════════════════════
// ANIMAÇÃO NORMAL
// ═════════════════════════════════════════════
tempo_animacao += 0.07;


// ═════════════════════════════════════════════
// VERIFICAR KIRAN
// ═════════════════════════════════════════════
if (!instance_exists(obj_Kiran)) {
    perto_do_fragmento = false;
    exit;
}

var jogador = instance_nearest(
    x,
    y,
    obj_Kiran
);


// Verificar distância
perto_do_fragmento =
    point_distance(
        x,
        y,
        jogador.x,
        jogador.y
    )
    <= distancia_interacao;


// Não coletar durante diálogo
if (global.dialogue_open) {
    perto_do_fragmento = false;
    exit;
}


// ═════════════════════════════════════════════
// COLETAR COM E
// ═════════════════════════════════════════════
if (
    perto_do_fragmento
    && keyboard_check_pressed(ord("E"))
) {
    global.fragmentos_vitral[indice_fragmento] = true;

    coletando = true;
    perto_do_fragmento = false;

    tempo_coleta = 45;
}