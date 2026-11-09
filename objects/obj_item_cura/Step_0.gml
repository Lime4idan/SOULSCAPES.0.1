if (!inicializado_item) {
    inicializado_item = true;
    tipo_item = clamp(round(tipo_item), 0, 2);

    var item_ids = ["orvalho_lunar", "fruto_rosado", "seiva_estelar"];
    var item_nomes = ["Orvalho Lunar", "Fruto Rosado", "Seiva Estelar"];
    var item_descricoes = [
        "Orvalho recolhido antes do amanhecer. Sua luz acalma feridas leves.",
        "Um fruto macio de perfume adocicado, encontrado em recantos protegidos.",
        "Seiva rara que guarda o brilho das árvores mais antigas da floresta."
    ];
    var item_curas = [20, 40, 70];
    var item_raridades = ["Comum", "Incomum", "Raro"];
    var item_icones = ["orvalho", "fruto", "seiva"];
    var item_cores = [
        make_color_rgb(171, 218, 231),
        make_color_rgb(232, 157, 190),
        make_color_rgb(180, 164, 224)
    ];
    // As seis artes são distribuídas pelos pontos de cura. O tipo continua
    // definindo nome e quantidade curada; a variante muda a apresentação.
    var item_sprites = [
        spr_itemcura_esfera_de_agua,
        spr_itemcura_fruta,
        spr_itemcura_folha_com_gota,
        spr_itemcura_fruta2,
        spr_itemcura_flor,
        spr_itemcura_ervas
    ];

    if (nome_item == "") nome_item = item_nomes[tipo_item];
    if (descricao_item == "") descricao_item = item_descricoes[tipo_item];
    if (cura_item <= 0) cura_item = item_curas[tipo_item];
    if (raridade_item == "") raridade_item = item_raridades[tipo_item];
    if (icone_item == "") icone_item = item_icones[tipo_item];
    if (texto_interacao == "") texto_interacao = "Guardar na bolsa";
    if (cor_tematica == -1) cor_tematica = item_cores[tipo_item];
    if (sprite_personalizado == -1 || !sprite_exists(sprite_personalizado)) {
        var variante_escolhida = variante_sprite;
        if (variante_escolhida < 0) {
            // `room` é uma referência de asset nas versões atuais do
            // GameMaker, não um número seguro para operações aritméticas.
            // As coordenadas já produzem uma distribuição determinística.
            variante_escolhida = abs(round(x / 80) + round(y / 50)) mod 6;
        }
        variante_escolhida = clamp(round(variante_escolhida), 0, 5);
        sprite_personalizado = item_sprites[variante_escolhida];
    }
    // Mantém também o sprite nativo sincronizado para o Room Editor e para
    // qualquer sistema futuro que consulte sprite_index diretamente.
    sprite_index = sprite_personalizado;
    image_speed = 0;
    if (id_coleta == "") {
        id_coleta = item_ids[tipo_item] + "_"
            + room_get_name(room) + "_" + string(round(x)) + "_" + string(round(y));
    }

    if (!variable_global_exists("itens_curativos_coletados")) {
        global.itens_curativos_coletados = [];
    }

    if (coleta_unica) {
        for (var item_salvo_i = 0; item_salvo_i < array_length(global.itens_curativos_coletados); item_salvo_i++) {
            if (global.itens_curativos_coletados[item_salvo_i] == id_coleta) {
                instance_destroy();
                exit;
            }
        }
    }
}

if (!global.config_reduzir_animacoes) {
    tempo_item += 0.055;
}

if (coletado) {
    tempo_coleta--;

    if (tempo_coleta <= 0) {
        instance_destroy();
    }

    exit;
}

perto_item = false;

if (
    !global.jogo_pausado
    && !global.dialogue_open
    && instance_exists(obj_Kiran)
) {
    item_jogador = instance_nearest(x, y, obj_Kiran);
    perto_item = point_distance(x, y, item_jogador.x, item_jogador.y)
        <= distancia_interacao;
}

if (
    perto_item
    && current_time >= global.interacao_bloqueada_ate
    && (
        keyboard_check_pressed(ord("E"))
        || (variable_global_exists("mobile_interact_pressed") && global.mobile_interact_pressed)
    )
    && variable_global_exists("inventario_adicionar_consumivel")
) {
    global.interacao_bloqueada_ate = current_time + 100;
    global.inventario_adicionar_consumivel(
        tipo_item == 0 ? "orvalho_lunar" : (tipo_item == 1 ? "fruto_rosado" : "seiva_estelar"),
        nome_item,
        descricao_item,
        cura_item,
        raridade_item,
        cor_tematica,
        icone_item,
        sprite_personalizado,
        quantidade_item
    );

    if (coleta_unica) {
        array_push(global.itens_curativos_coletados, id_coleta);
    }

    coletado = true;
    perto_item = false;
    tempo_coleta = global.config_reduzir_animacoes ? 24 : 48;
    global.tocar_som_ui(1.14);
}
