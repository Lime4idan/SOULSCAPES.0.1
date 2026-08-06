if (!global.jogo_pausado) {
    exit;
}

draw_set_font(fnt_dialogo);

var mouse_gui_x = device_mouse_x_to_gui(0);
var mouse_gui_y = device_mouse_y_to_gui(0);


// ═════════════════════════════════════════════
// PALETA
// ═════════════════════════════════════════════
var cor_overlay =
    make_color_rgb(35, 49, 72);

var cor_painel =
    make_color_rgb(229, 231, 242);

var cor_interno =
    make_color_rgb(241, 241, 247);

var cor_borda =
    make_color_rgb(102, 108, 158);

var cor_texto =
    make_color_rgb(55, 63, 96);

var cor_normal =
    make_color_rgb(234, 235, 244);

var cor_hover =
    make_color_rgb(211, 214, 235);

var cor_sensorial =
    make_color_rgb(215, 217, 239);

var cor_sensorial_hover =
    make_color_rgb(188, 194, 227);

var cor_slider =
    make_color_rgb(145, 153, 207);

var cor_desativado =
    make_color_rgb(204, 207, 225);


// ═════════════════════════════════════════════
// FUNDO ESCURECIDO
// ═════════════════════════════════════════════
draw_set_alpha(
    global.config_baixo_estimulo
    ? 0.66
    : 0.50
);

draw_set_color(cor_overlay);

draw_rectangle(
    0,
    0,
    1280,
    811,
    false
);


// ═════════════════════════════════════════════
// PAINEL
// ═════════════════════════════════════════════
if (tela_pause == 2) {

    // Sombra
    draw_set_alpha(0.12);
    draw_set_color(cor_overlay);

    draw_roundrect(
        84,
        69,
        1204,
        755,
        false
    );

    // Painel
    draw_set_alpha(0.90);
    draw_set_color(cor_painel);

    draw_roundrect(
        76,
        60,
        1196,
        746,
        false
    );

    // Mancha interna
    draw_set_alpha(0.30);
    draw_set_color(cor_interno);

    draw_roundrect(
        92,
        76,
        1180,
        730,
        false
    );

    // Borda
    draw_set_alpha(0.42);
    draw_set_color(cor_borda);

    draw_roundrect(
        76,
        60,
        1196,
        746,
        true
    );
}
else {

    // Sombra
    draw_set_alpha(0.11);
    draw_set_color(cor_overlay);

    draw_roundrect(
        357,
        78,
        929,
        729,
        false
    );

    // Painel
    draw_set_alpha(0.86);
    draw_set_color(cor_painel);

    draw_roundrect(
        350,
        70,
        922,
        720,
        false
    );

    // Mancha interna
    draw_set_alpha(0.28);
    draw_set_color(cor_interno);

    draw_roundrect(
        365,
        85,
        907,
        705,
        false
    );

    // Borda
    draw_set_alpha(0.40);
    draw_set_color(cor_borda);

    draw_roundrect(
        350,
        70,
        922,
        720,
        true
    );
}


// ═════════════════════════════════════════════
// MENU PRINCIPAL
// ═════════════════════════════════════════════
if (tela_pause == 0) {
    draw_set_alpha(1);
    draw_set_color(cor_texto);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    // Título
    draw_text_transformed(
        636,
        125,
        "Pausa",
        1.52,
        1.52,
        0
    );

    // Linha decorativa
    draw_set_alpha(0.20);
    draw_set_color(cor_borda);

    draw_line(
        490,
        165,
        782,
        165
    );

    desenhar_folha_pause(
        474,
        165,
        0.36
    );

    desenhar_folha_pause(
        798,
        165,
        0.36
    );


    // Botões
    for (
        var menu_i = 0;
        menu_i < array_length(opcoes_pause);
        menu_i++
    ) {
        var menu_hover =
            hover_pause[menu_i];

        var menu_x1 =
            botao_pause_x1[menu_i];

        var menu_x2 =
            botao_pause_x2[menu_i];

        var menu_y1 =
            botao_pause_y[menu_i];

        var menu_y2 =
            menu_y1
            + botao_pause_h[menu_i];

        var menu_centro_x =
            (menu_x1 + menu_x2) / 2;

        var menu_centro_y =
            (menu_y1 + menu_y2) / 2;

        var menu_sensorial =
            menu_i == 0;

        var menu_expansao =
            menu_hover * 3;

        menu_x1 -= menu_expansao;
        menu_x2 += menu_expansao;

        menu_y1 -= menu_expansao * 0.35;
        menu_y2 += menu_expansao * 0.35;


        // Sombra
        draw_set_alpha(
            menu_sensorial
            ? 0.075
            : 0.045
        );

        draw_set_color(cor_overlay);

        draw_roundrect(
            menu_x1 + 2,
            menu_y1 + 3,
            menu_x2 + 2,
            menu_y2 + 3,
            false
        );


        // Fundo
        draw_set_alpha(
            menu_sensorial
            ? 0.82
            : 0.58
        );

        if (menu_sensorial) {
            draw_set_color(
                merge_color(
                    cor_sensorial,
                    cor_sensorial_hover,
                    menu_hover
                )
            );
        }
        else {
            draw_set_color(
                merge_color(
                    cor_normal,
                    cor_hover,
                    menu_hover
                )
            );
        }

        draw_roundrect(
            menu_x1,
            menu_y1,
            menu_x2,
            menu_y2,
            false
        );


        // Mancha interna sensorial
        if (menu_sensorial) {
            draw_set_alpha(
                0.035
                + menu_hover * 0.055
            );

            draw_set_color(cor_slider);

            draw_roundrect(
                menu_x1 + 7,
                menu_y1 + 6,
                menu_x2 - 7,
                menu_y2 - 7,
                false
            );
        }


        // Borda
        draw_set_alpha(
            menu_sensorial
            ? 0.55 + menu_hover * 0.30
            : 0.27 + menu_hover * 0.43
        );

        draw_set_color(cor_borda);

        draw_roundrect(
            menu_x1,
            menu_y1,
            menu_x2,
            menu_y2,
            true
        );


        // Texto
        draw_set_alpha(0.94);
        draw_set_color(cor_texto);

        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);

        draw_text_transformed(
            menu_centro_x,
            menu_centro_y,
            opcoes_pause[menu_i],
            menu_sensorial ? 1.15 : 1.02,
            menu_sensorial ? 1.15 : 1.02,
            0
        );


        // Folhinha selecionadora
        if (menu_i == opcao_pause) {
            var menu_movimento = 0;

            if (
                !global
                .config_reduzir_animacoes
            ) {
                menu_movimento =
                    sin(tempo_pause) * 2;
            }

            desenhar_folha_pause(
                menu_x1 - 25
                + menu_movimento,
                menu_centro_y,
                0.90
            );
        }
    }


    // Instrução inferior
    draw_set_alpha(0.45);
    draw_set_color(cor_texto);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_text(
        636,
        650,
        "Esc  voltar ao jogo"
    );
}


// ═════════════════════════════════════════════
// CONTROLES
// ═════════════════════════════════════════════
if (tela_pause == 1) {
    draw_set_alpha(1);
    draw_set_color(cor_texto);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_text_transformed(
        636,
        130,
        "Controles",
        1.52,
        1.52,
        0
    );

    draw_set_alpha(0.20);
    draw_set_color(cor_borda);

    draw_line(
        490,
        170,
        782,
        170
    );


    // Teclas
    desenhar_tecla_pause(
        415,
        220,
        "A",
        38
    );

    desenhar_tecla_pause(
        463,
        220,
        "D",
        38
    );

    desenhar_tecla_pause(
        415,
        280,
        "Shift",
        86
    );

    desenhar_tecla_pause(
        415,
        340,
        "Z",
        38
    );

    desenhar_tecla_pause(
        463,
        340,
        "X",
        38
    );

    desenhar_tecla_pause(
        415,
        400,
        "E",
        38
    );

    desenhar_tecla_pause(
        415,
        460,
        "Espaço",
        104
    );

    desenhar_tecla_pause(
        415,
        520,
        "Esc",
        68
    );


    // Ações
    draw_set_alpha(0.92);
    draw_set_color(cor_texto);

    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);

    draw_text(570, 237, "Mover");
    draw_text(570, 297, "Correr");
    draw_text(570, 357, "Pular");
    draw_text(570, 417, "Interagir");
    draw_text(570, 477, "Avançar diálogo");
    draw_text(570, 537, "Pausar ou voltar");


    // Botão voltar
    var controles_draw_x1 = 515;
    var controles_draw_y1 = 590;
    var controles_draw_x2 = 765;
    var controles_draw_y2 = 646;

    var controles_draw_mouse =
        point_in_rectangle(
            mouse_gui_x,
            mouse_gui_y,
            controles_draw_x1,
            controles_draw_y1,
            controles_draw_x2,
            controles_draw_y2
        );

    draw_set_alpha(0.74);

    draw_set_color(
        controles_draw_mouse
        ? cor_hover
        : cor_normal
    );

    draw_roundrect(
        controles_draw_x1,
        controles_draw_y1,
        controles_draw_x2,
        controles_draw_y2,
        false
    );

    draw_set_alpha(
        controles_draw_mouse
        ? 0.82
        : 0.38
    );

    draw_set_color(cor_borda);

    draw_roundrect(
        controles_draw_x1,
        controles_draw_y1,
        controles_draw_x2,
        controles_draw_y2,
        true
    );

    draw_set_alpha(1);
    draw_set_color(cor_texto);

    draw_set_halign(fa_center);

    draw_text(
        640,
        (
            controles_draw_y1
            + controles_draw_y2
        ) / 2,
        "Voltar"
    );
}


// ═════════════════════════════════════════════
// PAUSA SENSORIAL
// ═════════════════════════════════════════════
if (tela_pause == 3) {
    draw_set_alpha(1);
    draw_set_color(cor_texto);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_text_transformed(
        636,
        130,
        "Pausa sensorial",
        1.48,
        1.48,
        0
    );

    draw_set_alpha(0.20);
    draw_set_color(cor_borda);

    draw_line(
        470,
        170,
        802,
        170
    );


    // Ciclo de 12 segundos
    var ciclo_resp =
        resp_tempo mod 12;

    var texto_resp =
        "Inspire devagar";

    var progresso_resp = 0;

    if (ciclo_resp < 4) {
        texto_resp =
            "Inspire devagar";

        progresso_resp =
            ciclo_resp / 4;
    }
    else if (ciclo_resp < 6) {
        texto_resp =
            "Segure suavemente";

        progresso_resp = 1;
    }
    else {
        texto_resp =
            "Expire devagar";

        progresso_resp =
            1 - ((ciclo_resp - 6) / 6);
    }


    draw_set_alpha(0.88);
    draw_set_color(cor_texto);

    draw_text_transformed(
        636,
        225,
        texto_resp,
        1.12,
        1.12,
        0
    );


    // Círculos respiratórios
    var raio_resp =
        60
        + progresso_resp * 42;

    if (global.config_reduzir_animacoes) {
        raio_resp = 82;
    }

    draw_set_alpha(0.07);
    draw_set_color(cor_slider);

    draw_circle(
        636,
        390,
        raio_resp + 24,
        false
    );

    draw_set_alpha(0.13);

    draw_circle(
        636,
        390,
        raio_resp + 12,
        false
    );

    draw_set_alpha(0.19);

    draw_circle(
        636,
        390,
        raio_resp,
        false
    );

    draw_set_alpha(0.54);
    draw_set_color(cor_borda);

    draw_circle(
        636,
        390,
        raio_resp,
        true
    );


    draw_set_alpha(0.58);
    draw_set_color(cor_texto);

    draw_text(
        636,
        525,
        "Permaneça aqui pelo tempo que precisar."
    );


    // Botão voltar
    var sensorial_draw_x1 = 515;
    var sensorial_draw_y1 = 590;
    var sensorial_draw_x2 = 765;
    var sensorial_draw_y2 = 646;

    var sensorial_draw_mouse =
        point_in_rectangle(
            mouse_gui_x,
            mouse_gui_y,
            sensorial_draw_x1,
            sensorial_draw_y1,
            sensorial_draw_x2,
            sensorial_draw_y2
        );

    draw_set_alpha(0.74);

    draw_set_color(
        sensorial_draw_mouse
        ? cor_hover
        : cor_normal
    );

    draw_roundrect(
        sensorial_draw_x1,
        sensorial_draw_y1,
        sensorial_draw_x2,
        sensorial_draw_y2,
        false
    );

    draw_set_alpha(
        sensorial_draw_mouse
        ? 0.82
        : 0.38
    );

    draw_set_color(cor_borda);

    draw_roundrect(
        sensorial_draw_x1,
        sensorial_draw_y1,
        sensorial_draw_x2,
        sensorial_draw_y2,
        true
    );

    draw_set_alpha(1);
    draw_set_color(cor_texto);

    draw_text(
        640,
        (
            sensorial_draw_y1
            + sensorial_draw_y2
        ) / 2,
        "Voltar"
    );
}


// ═════════════════════════════════════════════
// CONFIGURAÇÕES
// ═════════════════════════════════════════════
if (tela_pause == 2) {
    var cfg_draw_y = [
        195,
        260,
        325,
        390,
        455,
        520,
        585,
        675
    ];

    var cfg_draw_barra_x1 = 650;
    var cfg_draw_barra_x2 = 1060;


    // Título
    draw_set_alpha(1);
    draw_set_color(cor_texto);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_text_transformed(
        636,
        105,
        "Configurações",
        1.50,
        1.50,
        0
    );

    draw_set_alpha(0.18);
    draw_set_color(cor_borda);

    draw_line(
        470,
        145,
        802,
        145
    );


    // Destaque da opção
    for (
        var cfg_draw_i = 0;
        cfg_draw_i < 7;
        cfg_draw_i++
    ) {
        if (
            config_opcao_atual
            == cfg_draw_i
        ) {
            draw_set_alpha(0.075);
            draw_set_color(cor_hover);

            draw_roundrect(
                130,
                cfg_draw_y[cfg_draw_i] - 25,
                1135,
                cfg_draw_y[cfg_draw_i] + 25,
                false
            );

            draw_set_alpha(0.14);
            draw_set_color(cor_borda);

            draw_roundrect(
                130,
                cfg_draw_y[cfg_draw_i] - 25,
                1135,
                cfg_draw_y[cfg_draw_i] + 25,
                true
            );
        }
    }


    // Textos
    draw_set_alpha(0.94);
    draw_set_color(cor_texto);

    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);

    draw_text_transformed(
        165,
        cfg_draw_y[0],
        "Volume da música",
        1.08,
        1.08,
        0
    );

    draw_text_transformed(
        165,
        cfg_draw_y[1],
        "Volume dos sons",
        1.08,
        1.08,
        0
    );

    draw_text_transformed(
        165,
        cfg_draw_y[2],
        "Modo baixo estímulo",
        1.08,
        1.08,
        0
    );

    draw_text_transformed(
        165,
        cfg_draw_y[3],
        "Reduzir animações",
        1.08,
        1.08,
        0
    );

    draw_text_transformed(
        165,
        cfg_draw_y[4],
        "Velocidade do texto",
        1.08,
        1.08,
        0
    );

    draw_text_transformed(
        165,
        cfg_draw_y[5],
        "Tamanho do texto",
        1.08,
        1.08,
        0
    );

    draw_text_transformed(
        165,
        cfg_draw_y[6],
        "Contraste",
        1.08,
        1.08,
        0
    );


    // Slider da música
    draw_set_alpha(0.58);
    draw_set_color(cor_desativado);

    draw_roundrect(
        cfg_draw_barra_x1,
        cfg_draw_y[0] - 4,
        cfg_draw_barra_x2,
        cfg_draw_y[0] + 4,
        false
    );

    var cfg_musica_x = lerp(
        cfg_draw_barra_x1,
        cfg_draw_barra_x2,
        global.config_volume_musica
    );

    draw_set_alpha(0.88);
    draw_set_color(cor_slider);

    draw_roundrect(
        cfg_draw_barra_x1,
        cfg_draw_y[0] - 4,
        cfg_musica_x,
        cfg_draw_y[0] + 4,
        false
    );

    draw_circle(
        cfg_musica_x,
        cfg_draw_y[0],
        12,
        false
    );

    draw_set_color(cor_borda);

    draw_circle(
        cfg_musica_x,
        cfg_draw_y[0],
        12,
        true
    );


    // Slider dos sons
    draw_set_alpha(0.58);
    draw_set_color(cor_desativado);

    draw_roundrect(
        cfg_draw_barra_x1,
        cfg_draw_y[1] - 4,
        cfg_draw_barra_x2,
        cfg_draw_y[1] + 4,
        false
    );

    var cfg_sons_x = lerp(
        cfg_draw_barra_x1,
        cfg_draw_barra_x2,
        global.config_volume_sons
    );

    draw_set_alpha(0.88);
    draw_set_color(cor_slider);

    draw_roundrect(
        cfg_draw_barra_x1,
        cfg_draw_y[1] - 4,
        cfg_sons_x,
        cfg_draw_y[1] + 4,
        false
    );

    draw_circle(
        cfg_sons_x,
        cfg_draw_y[1],
        12,
        false
    );

    draw_set_color(cor_borda);

    draw_circle(
        cfg_sons_x,
        cfg_draw_y[1],
        12,
        true
    );


    // Interruptores
    var cfg_switch_x1 = 955;
    var cfg_switch_x2 = 1050;
    var cfg_switch_h = 38;


    // Baixo estímulo
    draw_set_alpha(0.88);

    draw_set_color(
        global.config_baixo_estimulo
        ? cor_slider
        : cor_desativado
    );

    draw_roundrect(
        cfg_switch_x1,
        cfg_draw_y[2] - cfg_switch_h / 2,
        cfg_switch_x2,
        cfg_draw_y[2] + cfg_switch_h / 2,
        false
    );

    var cfg_estimulo_x =
        global.config_baixo_estimulo
        ? cfg_switch_x2 - 20
        : cfg_switch_x1 + 20;

    draw_set_color(cor_interno);

    draw_circle(
        cfg_estimulo_x,
        cfg_draw_y[2],
        15,
        false
    );

    draw_set_color(cor_borda);

    draw_circle(
        cfg_estimulo_x,
        cfg_draw_y[2],
        15,
        true
    );


    // Reduzir animações
    draw_set_color(
        global.config_reduzir_animacoes
        ? cor_slider
        : cor_desativado
    );

    draw_roundrect(
        cfg_switch_x1,
        cfg_draw_y[3] - cfg_switch_h / 2,
        cfg_switch_x2,
        cfg_draw_y[3] + cfg_switch_h / 2,
        false
    );

    var cfg_animacao_x =
        global.config_reduzir_animacoes
        ? cfg_switch_x2 - 20
        : cfg_switch_x1 + 20;

    draw_set_color(cor_interno);

    draw_circle(
        cfg_animacao_x,
        cfg_draw_y[3],
        15,
        false
    );

    draw_set_color(cor_borda);

    draw_circle(
        cfg_animacao_x,
        cfg_draw_y[3],
        15,
        true
    );


    // Textos das opções
    var cfg_textos_velocidade = [
        "Lenta",
        "Normal",
        "Rápida"
    ];

    var cfg_textos_tamanho = [
        "Pequeno",
        "Normal",
        "Grande"
    ];

    var cfg_textos_contraste = [
        "Normal",
        "Alto"
    ];

    draw_set_alpha(1);
    draw_set_color(cor_texto);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);


    // Velocidade
    draw_text_transformed(
        700,
        cfg_draw_y[4],
        "<",
        1.20,
        1.20,
        0
    );

    draw_text_transformed(
        855,
        cfg_draw_y[4],
        cfg_textos_velocidade[
            global.config_velocidade_texto
        ],
        1.06,
        1.06,
        0
    );

    draw_text_transformed(
        1010,
        cfg_draw_y[4],
        ">",
        1.20,
        1.20,
        0
    );


    // Tamanho
    draw_text_transformed(
        700,
        cfg_draw_y[5],
        "<",
        1.20,
        1.20,
        0
    );

    draw_text_transformed(
        855,
        cfg_draw_y[5],
        cfg_textos_tamanho[
            global.config_tamanho_texto
        ],
        1.06,
        1.06,
        0
    );

    draw_text_transformed(
        1010,
        cfg_draw_y[5],
        ">",
        1.20,
        1.20,
        0
    );


    // Contraste
    draw_text_transformed(
        700,
        cfg_draw_y[6],
        "<",
        1.20,
        1.20,
        0
    );

    draw_text_transformed(
        855,
        cfg_draw_y[6],
        cfg_textos_contraste[
            global.config_contraste
        ],
        1.06,
        1.06,
        0
    );

    draw_text_transformed(
        1010,
        cfg_draw_y[6],
        ">",
        1.20,
        1.20,
        0
    );


    // Botão voltar
    var cfg_draw_voltar_x1 = 515;
    var cfg_draw_voltar_y1 = 645;
    var cfg_draw_voltar_x2 = 765;
    var cfg_draw_voltar_y2 = 705;

    var cfg_draw_mouse_voltar =
        point_in_rectangle(
            mouse_gui_x,
            mouse_gui_y,
            cfg_draw_voltar_x1,
            cfg_draw_voltar_y1,
            cfg_draw_voltar_x2,
            cfg_draw_voltar_y2
        );

    draw_set_alpha(0.74);

    draw_set_color(
        cfg_draw_mouse_voltar
        ? cor_hover
        : cor_normal
    );

    draw_roundrect(
        cfg_draw_voltar_x1,
        cfg_draw_voltar_y1,
        cfg_draw_voltar_x2,
        cfg_draw_voltar_y2,
        false
    );

    draw_set_alpha(
        cfg_draw_mouse_voltar
        ? 0.82
        : 0.38
    );

    draw_set_color(cor_borda);

    draw_roundrect(
        cfg_draw_voltar_x1,
        cfg_draw_voltar_y1,
        cfg_draw_voltar_x2,
        cfg_draw_voltar_y2,
        true
    );

    draw_set_alpha(1);
    draw_set_color(cor_texto);

    draw_text(
        640,
        (
            cfg_draw_voltar_y1
            + cfg_draw_voltar_y2
        ) / 2,
        "Voltar"
    );
}


// ═════════════════════════════════════════════
// RESTAURAR
// ═════════════════════════════════════════════
draw_set_alpha(1);
draw_set_color(c_white);

draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_set_font(-1);