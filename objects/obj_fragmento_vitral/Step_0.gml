if (false) {
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
if (
    !variable_global_exists("config_reduzir_animacoes")
    || !global.config_reduzir_animacoes
) {
    tempo_animacao += 0.07;
}


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
    && (
        keyboard_check_pressed(ord("E"))
        || (variable_global_exists("mobile_interact_pressed") && global.mobile_interact_pressed)
    )
) {
    global.fragmentos_vitral[indice_fragmento] = true;

    coletando = true;
    perto_do_fragmento = false;

    tempo_coleta = 45;
}
}

// Fluxo novo: a estátua só entrega o fragmento ao receber sua oferenda.
if (!inicializado) {
    indice_fragmento = clamp(indice_fragmento, 0, 3);
    fragmento_liberado = global.fragmentos_vitral[indice_fragmento];
    inicializado = true;
}

if (global.jogo_pausado) {
    exit;
}

if (coletando) {
    tempo_coleta--;

    if (tempo_coleta <= 0) {
        coletando = false;
        fragmento_liberado = true;
    }

    exit;
}

fragmento_liberado = global.fragmentos_vitral[indice_fragmento];

if (!global.config_reduzir_animacoes) {
    tempo_animacao += 0.07;
}

if (tempo_mensagem_estatua > 0) {
    tempo_mensagem_estatua--;
}

if (!instance_exists(obj_Kiran)) {
    perto_do_fragmento = false;
    exit;
}

var est_jogador = instance_nearest(x, y, obj_Kiran);
perto_do_fragmento = point_distance(x, y, est_jogador.x, est_jogador.y) <= distancia_interacao;

if (global.dialogue_open) {
    perto_do_fragmento = false;
    exit;
}

var est_oferenda = global.oferendas_estatuas[indice_fragmento];
tem_oferenda = false;

if (variable_global_exists("inventario_quantidade_item")) {
    tem_oferenda = global.inventario_quantidade_item(est_oferenda) > 0;
}
else if (variable_global_exists("inventario_itens")) {
    for (var est_item_i = 0; est_item_i < array_length(global.inventario_itens); est_item_i++) {
        if (
            global.inventario_itens[est_item_i].nome == est_oferenda
            && global.inventario_itens[est_item_i].quantidade > 0
        ) {
            tem_oferenda = true;
        }
    }
}

if (
    perto_do_fragmento
    && (
        keyboard_check_pressed(ord("E"))
        || (variable_global_exists("mobile_interact_pressed") && global.mobile_interact_pressed)
    )
) {
    if (fragmento_liberado) {
        mensagem_estatua = "O nicho está vazio, mas a pedra ainda guarda um calor suave.";
        tempo_mensagem_estatua = 150;
    }
    else if (tem_oferenda) {
        if (variable_global_exists("inventario_remover_item")) {
            global.inventario_remover_item(est_oferenda);
        }

        global.fragmentos_vitral[indice_fragmento] = true;
        fragmento_liberado = true;
        coletando = true;
        perto_do_fragmento = false;
        tempo_coleta = 60;
        mensagem_estatua = "Oferenda aceita. O fragmento foi libertado!";
        tempo_mensagem_estatua = 120;
    }
    else {
        mensagem_estatua = "Oferenda necessária: " + est_oferenda
            + ". Um guarda da Rainha carrega este item.";
        tempo_mensagem_estatua = 180;
    }
}
