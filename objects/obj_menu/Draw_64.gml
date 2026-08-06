draw_set_font(fnt_dialogo);

var cor_texto = make_color_rgb(55, 63, 96);
var cor_borda = make_color_rgb(91, 100, 157);

var cor_normal = make_color_rgb(242, 241, 248);
var cor_selecionado = make_color_rgb(218, 220, 240);

var cor_folha = make_color_rgb(75, 103, 126);


for (var i = 0; i < array_length(botao_texto); i++) {
    var hover = hover_anim[i];
    var clique = click_anim[i];
    var ativo = botao_ativo[i];

    // Movimento bem discreto
    var subir = hover * 2;
    var reduzir = clique * 2;

    var largura_atual =
        botao_w
        + hover * 4
        - reduzir;

    var altura_atual =
        botao_h
        + hover * 2
        - reduzir;

    var x1 =
        menu_centro_x
        - largura_atual / 2;

    var x2 =
        menu_centro_x
        + largura_atual / 2;

    var y1 =
        botao_y[i]
        - subir;

    var y2 =
        y1
        + altura_atual;

    var centro_y = (y1 + y2) / 2;


    // ─────────────────────────────────────────
    // BRILHO DIFUSO APENAS NO SELECIONADO
    // ─────────────────────────────────────────
    if (hover > 0.01) {
        draw_set_color(cor_selecionado);

        draw_set_alpha(0.045 * hover);

        draw_roundrect(
            x1 - 4,
            y1 - 4,
            x2 + 4,
            y2 + 4,
            false
        );

        draw_set_alpha(0.055 * hover);

        draw_roundrect(
            x1 - 2,
            y1 - 2,
            x2 + 2,
            y2 + 2,
            false
        );
    }


    // ─────────────────────────────────────────
    // FUNDO SUAVE DO BOTÃO
    // ─────────────────────────────────────────
    var cor_fundo = merge_color(
        cor_normal,
        cor_selecionado,
        hover
    );

    draw_set_color(cor_fundo);

    if (ativo) {
        draw_set_alpha(0.72 + hover * 0.14);
    } else {
        draw_set_alpha(0.22);
    }

    draw_roundrect(
        x1,
        y1,
        x2,
        y2,
        false
    );


    // Segunda mancha transparente, tipo aquarela
    draw_set_color(cor_selecionado);

    if (ativo) {
        draw_set_alpha(0.035 + hover * 0.035);
    } else {
        draw_set_alpha(0.015);
    }

    draw_roundrect(
        x1 + 5,
        y1 + 4,
        x2 - 4,
        y2 - 5,
        false
    );


    // ─────────────────────────────────────────
    // BORDA DELICADA
    // ─────────────────────────────────────────
    draw_set_color(cor_borda);

    if (ativo) {
        draw_set_alpha(0.42 + hover * 0.42);
    } else {
        draw_set_alpha(0.15);
    }

    draw_roundrect(
        x1,
        y1,
        x2,
        y2,
        true
    );

    // Pequena irregularidade na borda selecionada
    if (hover > 0.01) {
        draw_set_alpha(0.14 * hover);

        draw_roundrect(
            x1 + 1,
            y1 - 1,
            x2 - 1,
            y2,
            true
        );
    }


    // ─────────────────────────────────────────
    // FOLHINHA SELECIONADORA
    // ─────────────────────────────────────────
    if (i == opcao_atual && ativo) {
        var movimento =
            sin(tempo_menu) * 2;

        var folha_x =
            x1 - 23
            + movimento;

        var folha_y =
            centro_y + 1;

        draw_set_color(cor_folha);
        draw_set_alpha(0.90);

        // Caule
        draw_line_width(
            folha_x,
            folha_y + 8,
            folha_x + 2,
            folha_y - 8,
            1.5
        );

        // Folha esquerda
        desenhar_folha(
            folha_x - 3,
            folha_y - 2,
            215,
            13,
            7,
            cor_folha,
            0.90
        );

        // Folha direita
        desenhar_folha(
            folha_x + 4,
            folha_y - 6,
            325,
            14,
            7,
            cor_folha,
            0.90
        );
    }


    // ─────────────────────────────────────────
    // TEXTO
    // ─────────────────────────────────────────
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(cor_texto);

    if (ativo) {
        draw_set_alpha(0.90 + hover * 0.10);
    } else {
        draw_set_alpha(0.27);
    }

    draw_text_transformed(
        menu_centro_x,
        centro_y,
        botao_texto[i],
        1.35,
        1.35,
        0
    );
}


// Restaurar configurações
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);

// ─────────────────────────────────────────────
// DESENHAR TELA DE CRÉDITOS
// ─────────────────────────────────────────────
if (mostrando_creditos) {
    draw_set_font(fnt_dialogo);

    var cor_caixa = make_color_rgb(239, 239, 247);
    var cor_borda = make_color_rgb(91, 100, 157);
    var cor_texto = make_color_rgb(55, 63, 96);
    var cor_titulo = make_color_rgb(70, 82, 145);

    // Escurece suavemente o fundo
    draw_set_alpha(0.38);
    draw_set_color(make_color_rgb(35, 48, 72));
    draw_rectangle(0, 0, 1280, 811, false);

    // Caixa principal
    draw_set_alpha(0.96);
    draw_set_color(cor_caixa);

    draw_roundrect(
        300,
        155,
        980,
        650,
        false
    );

    // Borda
    draw_set_alpha(0.85);
    draw_set_color(cor_borda);

    draw_roundrect(
        300,
        155,
        980,
        650,
        true
    );

    // Título
    draw_set_alpha(1);
    draw_set_color(cor_titulo);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_text_transformed(
        640,
        215,
        "Créditos",
        1.8,
        1.8,
        0
    );

    // Conteúdo
    draw_set_color(cor_texto);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);

    draw_text_ext(
        640,
        285,
        "SOULSCAPES\n\nDesenvolvimento, arte e roteiro:\nAlicia\n\nProjeto desenvolvido como trabalho escolar.\n\nAgradecimentos aos professores,\norientadores e participantes da pesquisa.",
        32,
        570
    );

    // Botão Voltar
    var voltar_x1 = 515;
    var voltar_y1 = 570;
    var voltar_x2 = 765;
    var voltar_y2 = 625;

    var mouse_x_gui = device_mouse_x_to_gui(0);
    var mouse_y_gui = device_mouse_y_to_gui(0);

    var mouse_sobre_voltar = point_in_rectangle(
        mouse_x_gui,
        mouse_y_gui,
        voltar_x1,
        voltar_y1,
        voltar_x2,
        voltar_y2
    );

    draw_set_color(
        mouse_sobre_voltar
        ? make_color_rgb(211, 214, 239)
        : make_color_rgb(230, 230, 244)
    );

    draw_set_alpha(0.95);

    draw_roundrect(
        voltar_x1,
        voltar_y1,
        voltar_x2,
        voltar_y2,
        false
    );

    draw_set_color(cor_borda);
    draw_set_alpha(mouse_sobre_voltar ? 1 : 0.65);

    draw_roundrect(
        voltar_x1,
        voltar_y1,
        voltar_x2,
        voltar_y2,
        true
    );

    draw_set_alpha(1);
    draw_set_color(cor_texto);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_text(
        640,
        (voltar_y1 + voltar_y2) / 2,
        "Voltar"
    );

    // Restaurar
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(-1);
}
// ─────────────────────────────────────────────
// TELA DE CONFIGURAÇÕES
// ─────────────────────────────────────────────
if (mostrando_configuracoes) {
    draw_set_font(fnt_dialogo);

    var cfg_mx = device_mouse_x_to_gui(0);
    var cfg_my = device_mouse_y_to_gui(0);

    var cfg_y = [
        205,
        275,
        345,
        415,
        485,
        555,
        625,
        710
    ];

    var barra_x1 = 650;
    var barra_x2 = 1060;

    // Paleta
    var cor_overlay = make_color_rgb(42, 55, 84);
    var cor_painel = make_color_rgb(235, 235, 246);
    var cor_painel_interno = make_color_rgb(244, 243, 249);

    var cor_texto = make_color_rgb(57, 66, 107);
    var cor_texto_claro = make_color_rgb(91, 97, 137);

    var cor_borda = make_color_rgb(100, 106, 165);
    var cor_destaque = make_color_rgb(178, 183, 225);
    var cor_slider = make_color_rgb(143, 151, 212);
    var cor_desativado = make_color_rgb(203, 205, 226);

    // Fundo escurecido
    draw_set_alpha(0.48);
    draw_set_color(cor_overlay);
    draw_rectangle(0, 0, 1280, 811, false);

    // Sombra do painel
    draw_set_alpha(0.14);
    draw_set_color(make_color_rgb(32, 41, 68));

    draw_roundrect(
        107,
        78,
        1177,
        758,
        false
    );

    // Painel principal
    draw_set_alpha(1);
    draw_set_color(cor_painel);

    draw_roundrect(
        100,
        70,
        1170,
        750,
        false
    );

    // Painel interno
    draw_set_alpha(0.72);
    draw_set_color(cor_painel_interno);

    draw_roundrect(
        118,
        88,
        1152,
        732,
        false
    );

    // Borda externa
    draw_set_alpha(0.70);
    draw_set_color(cor_borda);

    draw_roundrect(
        100,
        70,
        1170,
        750,
        true
    );

    // Linha decorativa abaixo do título
    draw_set_alpha(0.30);
    draw_line_width(
        285,
        158,
        995,
        158,
        1
    );

    // Título
    draw_set_alpha(1);
    draw_set_color(cor_texto);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_text_transformed(
        635,
        120,
        "Configurações",
        1.65,
        1.65,
        0
    );

    // Destaque da opção selecionada
    for (var i = 0; i < 7; i++) {
        if (config_opcao_atual == i) {
            draw_set_alpha(0.10);
            draw_set_color(cor_destaque);

            draw_roundrect(
                135,
                cfg_y[i] - 27,
                1135,
                cfg_y[i] + 27,
                false
            );

            draw_set_alpha(0.22);
            draw_set_color(cor_borda);

            draw_roundrect(
                135,
                cfg_y[i] - 27,
                1135,
                cfg_y[i] + 27,
                true
            );
        }
    }

    // Textos das opções
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_set_color(cor_texto);
    draw_set_alpha(0.95);

    draw_text_transformed(165, cfg_y[0], "Volume da música", 1.12, 1.12, 0);
    draw_text_transformed(165, cfg_y[1], "Volume dos sons", 1.12, 1.12, 0);
    draw_text_transformed(165, cfg_y[2], "Modo baixo estímulo", 1.12, 1.12, 0);
    draw_text_transformed(165, cfg_y[3], "Reduzir animações", 1.12, 1.12, 0);
    draw_text_transformed(165, cfg_y[4], "Velocidade do texto", 1.12, 1.12, 0);
    draw_text_transformed(165, cfg_y[5], "Tamanho do texto", 1.12, 1.12, 0);
    draw_text_transformed(165, cfg_y[6], "Contraste", 1.12, 1.12, 0);


    // ─────────────────────────────────────────
    // SLIDERS
    // ─────────────────────────────────────────

    // Música
    draw_set_alpha(0.70);
    draw_set_color(cor_desativado);

    draw_roundrect(
        barra_x1,
        cfg_y[0] - 4,
        barra_x2,
        cfg_y[0] + 4,
        false
    );

    var musica_x = lerp(
        barra_x1,
        barra_x2,
        config_volume_musica
    );

    draw_set_alpha(0.95);
    draw_set_color(cor_slider);

    draw_roundrect(
        barra_x1,
        cfg_y[0] - 4,
        musica_x,
        cfg_y[0] + 4,
        false
    );

    draw_circle(
        musica_x,
        cfg_y[0],
        12,
        false
    );

    draw_set_color(cor_borda);
    draw_circle(
        musica_x,
        cfg_y[0],
        12,
        true
    );

    // Sons
    draw_set_alpha(0.70);
    draw_set_color(cor_desativado);

    draw_roundrect(
        barra_x1,
        cfg_y[1] - 4,
        barra_x2,
        cfg_y[1] + 4,
        false
    );

    var sons_x = lerp(
        barra_x1,
        barra_x2,
        config_volume_sons
    );

    draw_set_alpha(0.95);
    draw_set_color(cor_slider);

    draw_roundrect(
        barra_x1,
        cfg_y[1] - 4,
        sons_x,
        cfg_y[1] + 4,
        false
    );

    draw_circle(
        sons_x,
        cfg_y[1],
        12,
        false
    );

    draw_set_color(cor_borda);
    draw_circle(
        sons_x,
        cfg_y[1],
        12,
        true
    );


    // ─────────────────────────────────────────
    // INTERRUPTORES
    // ─────────────────────────────────────────
    var switch_x1 = 958;
    var switch_x2 = 1052;
    var switch_altura = 38;

    // Baixo estímulo
    draw_set_alpha(0.95);
    draw_set_color(
        config_baixo_estimulo
        ? cor_slider
        : cor_desativado
    );

    draw_roundrect(
        switch_x1,
        cfg_y[2] - switch_altura / 2,
        switch_x2,
        cfg_y[2] + switch_altura / 2,
        false
    );

    var estimulo_x =
        config_baixo_estimulo
        ? switch_x2 - 20
        : switch_x1 + 20;

    draw_set_color(cor_painel_interno);

    draw_circle(
        estimulo_x,
        cfg_y[2],
        15,
        false
    );

    draw_set_color(cor_borda);

    draw_circle(
        estimulo_x,
        cfg_y[2],
        15,
        true
    );

    // Reduzir animações
    draw_set_color(
        config_reduzir_animacoes
        ? cor_slider
        : cor_desativado
    );

    draw_roundrect(
        switch_x1,
        cfg_y[3] - switch_altura / 2,
        switch_x2,
        cfg_y[3] + switch_altura / 2,
        false
    );

    var animacao_x =
        config_reduzir_animacoes
        ? switch_x2 - 20
        : switch_x1 + 20;

    draw_set_color(cor_painel_interno);

    draw_circle(
        animacao_x,
        cfg_y[3],
        15,
        false
    );

    draw_set_color(cor_borda);

    draw_circle(
        animacao_x,
        cfg_y[3],
        15,
        true
    );


    // ─────────────────────────────────────────
    // OPÇÕES COM SETAS
    // ─────────────────────────────────────────
    var textos_velocidade = [
        "Lenta",
        "Normal",
        "Rápida"
    ];

    var textos_tamanho = [
        "Pequeno",
        "Normal",
        "Grande"
    ];

    var textos_contraste = [
        "Normal",
        "Alto"
    ];

    draw_set_alpha(1);
    draw_set_color(cor_texto);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    // Velocidade
    draw_text_transformed(700, cfg_y[4], "<", 1.25, 1.25, 0);

    draw_text_transformed(
        855,
        cfg_y[4],
        textos_velocidade[config_velocidade_texto],
        1.12,
        1.12,
        0
    );

    draw_text_transformed(1010, cfg_y[4], ">", 1.25, 1.25, 0);

    // Tamanho
    draw_text_transformed(700, cfg_y[5], "<", 1.25, 1.25, 0);

    draw_text_transformed(
        855,
        cfg_y[5],
        textos_tamanho[config_tamanho_texto],
        1.12,
        1.12,
        0
    );

    draw_text_transformed(1010, cfg_y[5], ">", 1.25, 1.25, 0);

    // Contraste
    draw_text_transformed(700, cfg_y[6], "<", 1.25, 1.25, 0);

    draw_text_transformed(
        855,
        cfg_y[6],
        textos_contraste[config_contraste],
        1.12,
        1.12,
        0
    );

    draw_text_transformed(1010, cfg_y[6], ">", 1.25, 1.25, 0);


    // ─────────────────────────────────────────
    // BOTÃO VOLTAR
    // ─────────────────────────────────────────
    var voltar_x1 = 520;
    var voltar_y1 = cfg_y[7] - 27;
    var voltar_x2 = 750;
    var voltar_y2 = cfg_y[7] + 27;

    var sobre_voltar = point_in_rectangle(
        cfg_mx,
        cfg_my,
        voltar_x1,
        voltar_y1,
        voltar_x2,
        voltar_y2
    );

    draw_set_alpha(0.92);
    draw_set_color(
        sobre_voltar
        ? cor_destaque
        : cor_desativado
    );

    draw_roundrect(
        voltar_x1,
        voltar_y1,
        voltar_x2,
        voltar_y2,
        false
    );

    draw_set_alpha(sobre_voltar ? 0.95 : 0.60);
    draw_set_color(cor_borda);

    draw_roundrect(
        voltar_x1,
        voltar_y1,
        voltar_x2,
        voltar_y2,
        true
    );

    draw_set_alpha(1);
    draw_set_color(cor_texto);

    draw_text_transformed(
        635,
        cfg_y[7],
        "Voltar",
        1.15,
        1.15,
        0
    );

    // Restaurar
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(-1);
}
