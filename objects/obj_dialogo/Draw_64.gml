if (ativo) {
    draw_set_font(fnt_dialogo);

    var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();

    // A caixa fica maior quando existem escolhas
    var caixa_w = 980;
    var caixa_h;

    if (escolha_ativa) {
        caixa_h = 350;
    } else {
        caixa_h = 170;
    }

    // Posição da caixa
    var x1 = (gui_w - caixa_w) / 2;
    var y1 = gui_h - caixa_h - 35;
    var x2 = x1 + caixa_w;
    var y2 = y1 + caixa_h;

    // Paleta
    var cor_caixa     = make_color_rgb(241, 239, 247);
    var cor_borda     = make_color_rgb(125, 123, 168);
    var cor_texto     = make_color_rgb(62, 68, 94);
    var cor_nome      = make_color_rgb(229, 227, 242);
    var cor_selecionada = make_color_rgb(202, 198, 231);

    // Caixa principal
    draw_set_alpha(0.94);
    draw_set_color(cor_caixa);
    draw_roundrect(x1, y1, x2, y2, false);

    // Borda da caixa
    draw_set_alpha(1);
    draw_set_color(cor_borda);
    draw_roundrect(x1, y1, x2, y2, true);

    // Aba do nome
    if (nome_falante != "") {
        var nome_x1 = x1 + 25;
        var nome_y1 = y1 - 28;
        var nome_x2 = nome_x1 + 180;
        var nome_y2 = y1 + 17;

        draw_set_color(cor_nome);
        draw_roundrect(
            nome_x1,
            nome_y1,
            nome_x2,
            nome_y2,
            false
        );

        draw_set_color(cor_borda);
        draw_roundrect(
            nome_x1,
            nome_y1,
            nome_x2,
            nome_y2,
            true
        );

        draw_set_color(cor_texto);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);

        draw_text(
            (nome_x1 + nome_x2) / 2,
            (nome_y1 + nome_y2) / 2,
            nome_falante
        );
    }

    // Texto principal
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(cor_texto);

    draw_text_ext(
        x1 + 45,
        y1 + 45,
        texto,
        30,
        caixa_w - 90
    );

    // Opções dentro da caixa
    if (escolha_ativa) {
        var opcao_x1 = x1 + 45;
        var opcao_x2 = x2 - 45;

        var opcao_y_inicial = y1 + 105;
        var opcao_h = 52;
        var espaco = 12;

        for (var i = 0; i < array_length(opcoes); i++) {
            var oy1 = opcao_y_inicial
                + i * (opcao_h + espaco);

            var oy2 = oy1 + opcao_h;

            // Fundo da opção
            if (i == opcao_atual) {
                draw_set_color(cor_selecionada);
            } else {
                draw_set_color(c_white);
            }

            draw_roundrect(
                opcao_x1,
                oy1,
                opcao_x2,
                oy2,
                false
            );

            // Borda da opção
            draw_set_color(cor_borda);
            draw_roundrect(
                opcao_x1,
                oy1,
                opcao_x2,
                oy2,
                true
            );

            // Texto da opção
            draw_set_color(cor_texto);
            draw_set_halign(fa_left);
            draw_set_valign(fa_middle);

            draw_text(
                opcao_x1 + 20,
                (oy1 + oy2) / 2,
                opcoes[i]
            );
        }
    }

    // Indicação de avanço apenas em diálogo normal
    if (!escolha_ativa) {
        draw_set_halign(fa_right);
        draw_set_valign(fa_bottom);
        draw_set_color(cor_borda);

        draw_text(
            x2 - 25,
            y2 - 18,
            "Espaço  >"
        );
    }

    // Restaurar configurações
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(-1);
}