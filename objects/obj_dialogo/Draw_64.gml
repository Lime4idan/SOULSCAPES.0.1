if (ativo) {
    draw_set_font(fnt_dialogo);

    var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();

    var tamanho_texto_indice =
        variable_global_exists("config_tamanho_texto")
        ? clamp(global.config_tamanho_texto, 0, 2)
        : 1;

    var escalas_texto = [0.88, 1.0, 1.16];
    var escala_texto = escalas_texto[tamanho_texto_indice];
    var interface_mobile = variable_global_exists("mobile_mode")
        && global.mobile_mode;
    if (interface_mobile) escala_texto = max(1.22, escala_texto);

    var total_opcoes = escolha_ativa ? array_length(opcoes) : 0;
    var altura_opcao_mobile = total_opcoes >= 4 ? 104 : 120;

    var caixa_w = interface_mobile
        ? gui_w - 64
        : min(980, gui_w - 144);
    var caixa_h = 190 + max(0, escala_texto - 1) * 70;

    if (escolha_ativa) {
        if (interface_mobile) {
            caixa_h = 154 + total_opcoes * altura_opcao_mobile
                + max(0, total_opcoes - 1) * 12;
        }
        else {
            caixa_h = 375
                + max(0, array_length(opcoes) - 3) * 72
                + max(0, escala_texto - 1) * 110;
        }
    }
    var x1 = (gui_w - caixa_w) / 2;
    var y1 = max(100, gui_h - caixa_h - 78);
    var x2 = x1 + caixa_w;
    var y2 = y1 + caixa_h;

    var baixo_estimulo =
        variable_global_exists("config_baixo_estimulo")
        && global.config_baixo_estimulo;

    var reduzir_animacoes =
        variable_global_exists("config_reduzir_animacoes")
        && global.config_reduzir_animacoes;

    var alto_contraste =
        variable_global_exists("config_contraste")
        && global.config_contraste >= 1;

    var pulso = reduzir_animacoes
        ? 0
        : sin(current_time * 0.0045);

    // Paleta pastel encantada.
    var cor_sombra       = alto_contraste
        ? make_color_rgb(18, 20, 35)
        : make_color_rgb(66, 61, 96);
    var cor_caixa        = alto_contraste
        ? c_white
        : make_color_rgb(250, 246, 251);
    var cor_interno      = make_color_rgb(255, 252, 253);
    var cor_borda        = alto_contraste
        ? make_color_rgb(49, 39, 88)
        : make_color_rgb(137, 119, 181);
    var cor_borda_clara  = make_color_rgb(215, 201, 236);
    var cor_texto        = alto_contraste
        ? make_color_rgb(22, 22, 35)
        : make_color_rgb(59, 61, 91);
    var cor_texto_suave  = alto_contraste
        ? make_color_rgb(52, 45, 76)
        : make_color_rgb(104, 96, 133);
    var cor_rosa         = make_color_rgb(242, 207, 226);
    var cor_lilas        = make_color_rgb(225, 216, 245);
    var cor_menta        = make_color_rgb(204, 239, 225);
    var cor_azul         = make_color_rgb(216, 232, 248);


    // ─────────────────────────────────────────
    // CAIXA PRINCIPAL
    // ─────────────────────────────────────────
    draw_set_alpha(alto_contraste ? 0.42 : 0.22);
    draw_set_color(cor_sombra);
    draw_roundrect(x1 + 6, y1 + 8, x2 + 6, y2 + 8, false);

    draw_set_alpha(0.97);
    draw_set_color(cor_caixa);
    draw_roundrect(x1, y1, x2, y2, false);

    // Mancha interna muito suave.
    draw_set_alpha(baixo_estimulo ? 0.20 : 0.42);
    draw_set_color(cor_interno);
    draw_roundrect(x1 + 12, y1 + 12, x2 - 12, y2 - 12, false);

    draw_set_alpha(alto_contraste ? 1 : 0.84);
    draw_set_color(cor_borda);
    draw_roundrect(x1, y1, x2, y2, true);

    draw_set_alpha(0.50);
    draw_set_color(cor_borda_clara);
    draw_roundrect(x1 + 8, y1 + 8, x2 - 8, y2 - 8, true);

    // Confetes delicados nos cantos.
    var decor_alpha = baixo_estimulo ? 0.28 : 0.72;
    draw_set_alpha(decor_alpha);
    draw_set_color(cor_rosa);
    draw_circle(x2 - 28, y1 + 24, 5, false);
    draw_circle(x2 - 44, y1 + 17, 2.5, false);
    draw_set_color(cor_menta);
    draw_circle(x2 - 18, y1 + 39, 3, false);
    draw_set_color(cor_azul);
    draw_circle(x1 + 25, y2 - 22, 3, false);


    // ─────────────────────────────────────────
    // ABA DO NOME
    // ─────────────────────────────────────────
    if (nome_falante != "") {
        var nome_w = clamp(string_width(nome_falante) + 74, 170, 270);
        var nome_x1 = x1 + 28;
        var nome_y1 = y1 - 27;
        var nome_x2 = nome_x1 + nome_w;
        var nome_y2 = y1 + 20;
        var cor_aba = nome_falante == "Lorun" ? cor_menta : cor_rosa;

        draw_set_alpha(0.18);
        draw_set_color(cor_sombra);
        draw_roundrect(nome_x1 + 3, nome_y1 + 4, nome_x2 + 3, nome_y2 + 4, false);

        draw_set_alpha(0.98);
        draw_set_color(cor_aba);
        draw_roundrect(nome_x1, nome_y1, nome_x2, nome_y2, false);

        draw_set_alpha(0.82);
        draw_set_color(cor_borda);
        draw_roundrect(nome_x1, nome_y1, nome_x2, nome_y2, true);

        // Bolinha decorativa antes do nome.
        draw_set_alpha(0.88);
        draw_set_color(nome_falante == "Lorun" ? cor_rosa : cor_menta);
        draw_circle(nome_x1 + 23, (nome_y1 + nome_y2) / 2, 6, false);

        draw_set_alpha(1);
        draw_set_color(cor_texto);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(
            (nome_x1 + 32 + nome_x2) / 2,
            (nome_y1 + nome_y2) / 2,
            nome_falante
        );
    }


    // ─────────────────────────────────────────
    // TEXTO DA FALA
    // ─────────────────────────────────────────
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(cor_texto);

    draw_text_ext_transformed(
        x1 + 48,
        y1 + 49,
        escolha_ativa ? texto : texto_visivel,
        30 / escala_texto,
        (caixa_w - 96) / escala_texto,
        escala_texto,
        escala_texto,
        0
    );


    // ─────────────────────────────────────────
    // OPÇÕES DE RESPOSTA
    // ─────────────────────────────────────────
    if (escolha_ativa) {
        var opcao_x1 = x1 + (interface_mobile ? 28 : 48);
        var opcao_x2 = x2 - (interface_mobile ? 28 : 48);
        var opcao_y_inicial = y1 + (interface_mobile ? 92 : 100);
        var opcao_h = interface_mobile
            ? altura_opcao_mobile
            : 60 + max(0, escala_texto - 1) * 30;
        var espaco = 12;

        for (var i = 0; i < array_length(opcoes); i++) {
            var oy1 = opcao_y_inicial + i * (opcao_h + espaco);
            var oy2 = oy1 + opcao_h;
            var selecionada = i == opcao_atual;

            // Sombra individual.
            draw_set_alpha(selecionada ? 0.19 : 0.10);
            draw_set_color(cor_sombra);
            draw_roundrect(
                opcao_x1 + 2,
                oy1 + 3,
                opcao_x2 + 2,
                oy2 + 3,
                false
            );

            draw_set_alpha(selecionada ? 0.98 : 0.82);
            draw_set_color(
                selecionada
                ? cor_menta
                : (i mod 2 == 0 ? cor_lilas : cor_azul)
            );
            draw_roundrect(opcao_x1, oy1, opcao_x2, oy2, false);

            draw_set_alpha(selecionada ? 0.92 : 0.48);
            draw_set_color(cor_borda);
            draw_roundrect(opcao_x1, oy1, opcao_x2, oy2, true);

            // Pequena faixa rosa marca a resposta atual.
            if (selecionada) {
                draw_set_alpha(0.78 + pulso * 0.08);
                draw_set_color(cor_rosa);
                draw_roundrect(
                    opcao_x1 + 8,
                    oy1 + 9,
                    opcao_x1 + 15,
                    oy2 - 9,
                    false
                );
            }

            // Número da resposta em uma bolinha pastel.
            draw_set_alpha(0.92);
            draw_set_color(selecionada ? cor_rosa : cor_interno);
            var numero_x = opcao_x1 + (interface_mobile ? 50 : 38);
            var numero_raio = interface_mobile ? 24 : 16;
            draw_circle(numero_x, (oy1 + oy2) / 2, numero_raio, false);

            draw_set_alpha(0.72);
            draw_set_color(cor_borda);
            draw_circle(numero_x, (oy1 + oy2) / 2, numero_raio, true);

            draw_set_alpha(1);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_color(cor_texto_suave);
            draw_text(numero_x, (oy1 + oy2) / 2, string(i + 1));

            draw_set_halign(fa_left);
            draw_set_color(cor_texto);
            draw_text_transformed(
                opcao_x1 + (interface_mobile ? 94 : 68),
                (oy1 + oy2) / 2,
                opcoes[i],
                escala_texto,
                escala_texto,
                0
            );
        }

        // Instrução compacta dentro da própria caixa de respostas.
        draw_set_alpha(0.78);
        draw_set_color(cor_texto_suave);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        var instrucao_escolha = (
            variable_global_exists("mobile_mode")
            && global.mobile_mode
        )
            ? "Toque em uma resposta para escolher"
            : "Setas: escolher   |   Espaço: confirmar";

        draw_text_transformed(
            (x1 + x2) / 2,
            y2 - 22,
            instrucao_escolha,
            0.82,
            0.82,
            0
        );
    }
    else {
        // Tecla e ação ficam separadas, seguindo as plaquinhas de interação.
        var avancar_y = y2 - 27;
        var tecla_x2 = x2 - 118;
        var tecla_x1 = tecla_x2 - 86;

        draw_set_alpha(0.94);
        draw_set_color(cor_lilas);
        draw_roundrect(tecla_x1, avancar_y - 16, tecla_x2, avancar_y + 16, false);

        draw_set_alpha(0.76);
        draw_set_color(cor_borda);
        draw_roundrect(tecla_x1, avancar_y - 16, tecla_x2, avancar_y + 16, true);

        draw_set_alpha(1);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(cor_texto);
        var tecla_avancar = (
            variable_global_exists("mobile_mode")
            && global.mobile_mode
        ) ? "Toque" : "Espaço";
        draw_text((tecla_x1 + tecla_x2) / 2, avancar_y, tecla_avancar);

        draw_set_halign(fa_left);
        draw_set_color(cor_texto_suave);
        draw_text(
            tecla_x2 + 12,
            avancar_y,
            texto_completo ? "avançar" : "mostrar tudo"
        );
    }


    // Restaurar configurações.
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(-1);
}
