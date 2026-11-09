pode_interagir = false;

var jogador = instance_nearest(x, y, obj_Kiran);

if (instance_exists(jogador)) {
    var distancia = point_distance(x, y, jogador.x, jogador.y);

    if (distancia <= distancia_interacao) {
        pode_interagir = true;
    }
}

if (
    pode_interagir
    && (
        keyboard_check_pressed(ord("E"))
        || (variable_global_exists("mobile_interact_pressed") && global.mobile_interact_pressed)
    )
    && !global.dialogue_open
) {
    global.tem_fragmento = true;
    global.tem_espada_fragmento = true;

    if (!variable_global_exists("inventario_armas")) {
        global.inventario_armas = [];
    }

    var arma_ja_guardada = false;

    for (var arma_i = 0; arma_i < array_length(global.inventario_armas); arma_i++) {
        if (global.inventario_armas[arma_i].nome == "Lâmina do Fragmento") {
            arma_ja_guardada = true;
        }
    }

    if (!arma_ja_guardada) {
        array_push(global.inventario_armas, {
            nome: "Lâmina do Fragmento",
            descricao: "O fragmento respondeu à coragem de Kiran e tomou a forma de uma espada luminosa.",
            detalhe: "Arma equipada • Poder 20",
            quantidade: 1,
            cor: make_color_rgb(205, 228, 245),
            icone: "espada",
            bloqueado: false,
            categoria: "arma",
            consumivel: false,
            cura: 0,
            usavel_mapa: false,
            usavel_batalha: false,
            raridade: "Única",
            sprite_item: spr_espada
        });
    }

    with (obj_dialogo) {
        iniciar_dialogo([
            "Um fragmento de vidro...? Ele está reagindo à presença de Kiran.",
            "A luz se alonga entre suas mãos e assume a forma de uma lâmina.",
            "Lâmina do Fragmento adquirida! Agora Kiran pode se defender e lutar."
        ]);
    }

    instance_destroy();
}
