draw_set_font(fnt_dialogo);

var menu_alto_contraste = config_contraste >= 1;
var menu_baixo_estimulo = config_baixo_estimulo;
var menu_decoracao = menu_baixo_estimulo ? 0.38 : 1;

var cor_texto = menu_alto_contraste
    ? make_color_rgb(20, 22, 34)
    : make_color_rgb(55, 63, 96);
var cor_borda = menu_alto_contraste
    ? make_color_rgb(48, 38, 86)
    : make_color_rgb(121, 111, 164);
var cor_papel = menu_alto_contraste
    ? c_white
    : make_color_rgb(255, 249, 239);
var cor_papel_sombra = make_color_rgb(221, 207, 207);
var cor_rosa = make_color_rgb(239, 205, 226);
var cor_lilas = make_color_rgb(220, 212, 244);
var cor_menta = make_color_rgb(198, 237, 220);
var cor_azul = make_color_rgb(205, 228, 245);
var cor_folha = make_color_rgb(79, 128, 112);
var cor_folha_clara = make_color_rgb(151, 201, 171);

var cores_detalhe = [
    cor_rosa,
    cor_azul,
    cor_menta,
    cor_lilas,
    cor_rosa
];


for (var i = 0; i < array_length(botao_texto); i++) {
    var hover = hover_anim[i];
    var clique = click_anim[i];
    var ativo = botao_ativo[i];
    var cor_detalhe = cores_detalhe[i];

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
    // BRILHO PASTEL DO BOTÃO SELECIONADO
    // ─────────────────────────────────────────
    if (hover > 0.01) {
        draw_set_color(cor_detalhe);

        draw_set_alpha(0.12 * hover * menu_decoracao);

        draw_roundrect(
            x1 - 8,
            y1 - 7,
            x2 + 8,
            y2 + 8,
            false
        );

        draw_set_alpha(0.16 * hover * menu_decoracao);

        draw_roundrect(
            x1 - 4,
            y1 - 3,
            x2 + 4,
            y2 + 4,
            false
        );
    }


    // ─────────────────────────────────────────
    // BOTÃO DE PAPEL CREME
    // ─────────────────────────────────────────
    draw_set_color(cor_papel_sombra);
    draw_set_alpha(ativo ? 0.24 + hover * 0.08 : 0.10);
    draw_roundrect(
        x1 + 3,
        y1 + 5,
        x2 + 3,
        y2 + 5,
        false
    );

    draw_set_color(merge_color(cor_papel, cor_detalhe, hover * 0.18));
    if (ativo) {
        draw_set_alpha(0.92 + hover * 0.06);
    } else {
        draw_set_alpha(0.40);
    }

    draw_roundrect(
        x1,
        y1,
        x2,
        y2,
        false
    );


    // Mancha interna de aquarela.
    draw_set_color(cor_detalhe);

    if (ativo) {
        draw_set_alpha(0.10 + hover * 0.12);
    } else {
        draw_set_alpha(0.035);
    }

    draw_roundrect(
        x1 + 7,
        y1 + 6,
        x2 - 7,
        y2 - 6,
        false
    );


    // ─────────────────────────────────────────
    // BORDA DELICADA
    // ─────────────────────────────────────────
    draw_set_color(merge_color(cor_borda, cor_detalhe, 0.38));

    if (ativo) {
        draw_set_alpha(0.54 + hover * 0.34);
    } else {
        draw_set_alpha(0.20);
    }

    draw_roundrect(
        x1,
        y1,
        x2,
        y2,
        true
    );

    // Segunda linha lembra a borda de uma página pintada à mão.
    if (hover > 0.01) {
        draw_set_alpha(0.28 * hover);

        draw_roundrect(
            x1 + 3,
            y1 + 3,
            x2 - 3,
            y2 - 3,
            true
        );
    }

    // Fitinha pastel e dois confetes, sem competir com o texto.
    draw_set_color(cor_detalhe);
    draw_set_alpha(ativo ? 0.70 : 0.20);
    draw_roundrect(x1 + 17, y1 - 3, x1 + 57, y1 + 8, false);

    draw_set_alpha(((ativo ? 0.72 : 0.18) + hover * 0.16) * menu_decoracao);
    draw_circle(x2 - 20, centro_y - 8, 3, false);
    draw_set_color(i mod 2 == 0 ? cor_menta : cor_rosa);
    draw_circle(x2 - 14, centro_y + 7, 2, false);


    // ─────────────────────────────────────────
    // RAMINHO SELECIONADOR
    // ─────────────────────────────────────────
    if (i == opcao_atual && ativo) {
        var movimento =
            (config_reduzir_animacoes ? 0 : sin(tempo_menu) * 2);

        var respirar =
            1
            + (config_reduzir_animacoes
                ? 0
                : sin(tempo_menu * 0.75) * 0.06);

        var folha_x =
            x1 - 30
            + movimento;

        var folha_y =
            centro_y + 1;

        // Halo de luz de fada atrás do raminho.
        draw_set_color(cor_menta);
        draw_set_alpha((0.12 + hover * 0.06) * menu_decoracao);
        draw_circle(folha_x, folha_y, 22 * respirar, false);

        draw_set_color(cor_folha_clara);
        draw_set_alpha(0.24);
        draw_circle(folha_x, folha_y, 15 * respirar, false);

        // Caule
        draw_set_color(cor_folha);
        draw_set_alpha(0.94);
        draw_line_width(
            folha_x - 7,
            folha_y + 13,
            folha_x + 8,
            folha_y - 12,
            2
        );

        // Três folhas em tons diferentes dão volume ao seletor.
        desenhar_folha(
            folha_x - 7,
            folha_y + 4,
            205,
            17 * respirar,
            10 * respirar,
            cor_folha_clara,
            0.98
        );

        desenhar_folha(
            folha_x + 3,
            folha_y - 2,
            325,
            18 * respirar,
            10 * respirar,
            cor_folha,
            0.98
        );

        desenhar_folha(
            folha_x + 8,
            folha_y - 10,
            275,
            14 * respirar,
            8 * respirar,
            cor_folha_clara,
            0.94
        );

        // Gota de luz na ponta do ramo.
        draw_set_color(c_white);
        draw_set_alpha(0.76);
        draw_circle(folha_x + 11, folha_y - 14, 2.2, false);
        draw_set_color(cor_rosa);
        draw_set_alpha(0.70);
        draw_circle(folha_x - 10, folha_y + 12, 2.6, false);
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
        draw_set_alpha(0.34);
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
// CONTA OPCIONAL E SAVE NA NUVEM
// ─────────────────────────────────────────────
if (mostrando_conta) {
    // Interface ilustrada da conta. Os textos digitados ficam por cima dos
    // campos para preservar a arte sem transformar a tela em imagem estatica.
    draw_set_font(fnt_dialogo);

    var nova_cor_texto = make_color_rgb(61, 64, 105);
    var nova_cor_erro = make_color_rgb(160, 67, 91);
    var nova_conectada = variable_global_exists("soul_account_guest")
        && !global.soul_account_guest;
    var nova_ocupada = variable_global_exists("soul_account_busy")
        && global.soul_account_busy;

    draw_set_alpha(0.50);
    draw_set_color(make_color_rgb(30, 45, 72));
    draw_rectangle(0, 0, 1280, 811, false);
    draw_set_alpha(1);
    draw_set_color(c_white);

    draw_sprite_ext(spr_ui_conta_painel, 0, 110, 18, 0.734, 0.734, 0, c_white, 1);
    draw_sprite_ext(spr_ui_conta_titulo, 0, 250, 20, 0.36, 0.36, 0, c_white, 1);
    draw_sprite_ext(spr_ui_conta_subtitulo, 0, 250, 145, 0.36, 0.36, 0, c_white, 1);

    if (!nova_conectada) {
        draw_sprite_ext(spr_ui_conta_email, 0, 336, 250, 0.28, 0.28, 0, c_white, 1);
        draw_sprite_ext(spr_ui_conta_senha, 0, 336, 340, 0.28, 0.28, 0, c_white, 1);

        // Realce de foco seguindo o contorno visivel dos campos.
        if (conta_campo_ativo >= 0 && conta_campo_ativo <= 1) {
            var nova_foco_y = conta_campo_ativo == 0 ? 308 : 398;
            draw_set_alpha(0.42);
            draw_set_color(make_color_rgb(129, 196, 174));
            draw_roundrect(336, nova_foco_y, 944, nova_foco_y + 78, true);
            draw_set_alpha(1);
        }

        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        var nova_cor_placeholder = make_color_rgb(143, 139, 170);
        if (string_length(conta_email) > 0) {
            draw_set_color(nova_cor_texto);
            draw_text_transformed(496, 346, conta_email, 0.82, 0.82, 0);
        }
        else {
            draw_set_color(nova_cor_placeholder);
            draw_text_transformed(496, 346, "voce@exemplo.com", 0.76, 0.76, 0);
        }

        if (string_length(conta_senha) > 0) {
            var nova_senha_visual = "";
            repeat (string_length(conta_senha)) nova_senha_visual += "*";
            draw_set_color(nova_cor_texto);
            draw_text_transformed(496, 436, nova_senha_visual, 0.86, 0.86, 0);
        }
        else {
            draw_set_color(nova_cor_placeholder);
            draw_text_transformed(496, 436, "Minimo de 6 caracteres", 0.76, 0.76, 0);
        }

        var nova_alpha_entrar = nova_ocupada ? 0.50 : (conta_mouse_sobre == 2 ? 1 : 0.88);
        var nova_alpha_criar = nova_ocupada ? 0.50 : (conta_mouse_sobre == 3 ? 1 : 0.88);
        var nova_alpha_convidado = conta_mouse_sobre == 4 ? 1 : 0.90;
        draw_sprite_part_ext(spr_ui_conta_sheet, 0, 812, 450, 358, 120, 410, 500, 0.54, 0.56, c_white, nova_alpha_entrar);
        draw_sprite_part_ext(spr_ui_conta_sheet, 0, 1180, 450, 338, 120, 680, 500, 0.58, 0.56, c_white, nova_alpha_criar);
        draw_sprite_part_ext(spr_ui_conta_sheet, 0, 808, 578, 700, 118, 455, 590, 0.53, 0.56, c_white, nova_alpha_convidado);
    }
    else {
        draw_sprite_ext(spr_ui_conta_conectada, 0, 314, 300, 0.30, 0.30, 0, c_white, 1);

        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(nova_cor_texto);
        draw_text_transformed(640, 476, global.soul_account_email, 0.86, 0.86, 0);

        var nova_alpha_sair = conta_mouse_sobre == 5 ? 1 : 0.88;
        var nova_alpha_voltar = conta_mouse_sobre == 4 ? 1 : 0.88;
        draw_sprite_ext(spr_ui_conta_sair, 0, 285, 500, 0.16, 0.16, 0, c_white, nova_alpha_sair);
        draw_sprite_ext(spr_ui_conta_voltar, 0, 670, 500, 0.16, 0.16, 0, c_white, nova_alpha_voltar);
    }

    var nova_mensagem = variable_global_exists("soul_account_message")
        ? global.soul_account_message
        : "Jogando como convidado";
    var nova_erro = variable_global_exists("soul_account_error")
        ? global.soul_account_error
        : "";

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_alpha(0.94);
    draw_set_color(string_length(nova_erro) > 0 ? nova_cor_erro : nova_cor_texto);
    draw_text_transformed(
        640,
        nova_conectada ? 692 : 690,
        string_length(nova_erro) > 0 ? nova_erro : nova_mensagem,
        0.78,
        0.78,
        0
    );

    if (!nova_conectada) {
        draw_set_alpha(nova_ocupada ? 0.45 : (conta_mouse_sobre == 6 ? 1 : 0.76));
        draw_set_color(nova_cor_texto);
        draw_text_transformed(640, 730, "Nao recebeu? Reenviar confirmacao", 0.72, 0.72, 0);
    }

    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(-1);
    exit;

    draw_set_font(fnt_dialogo);

    var conta_cor_papel = menu_alto_contraste ? c_white : make_color_rgb(255, 249, 239);
    var conta_cor_capa = make_color_rgb(220, 212, 244);
    var conta_cor_rosa = make_color_rgb(239, 205, 226);
    var conta_cor_menta = make_color_rgb(198, 237, 220);
    var conta_cor_azul = make_color_rgb(205, 228, 245);
    var conta_cor_borda = menu_alto_contraste
        ? make_color_rgb(48, 38, 86)
        : make_color_rgb(121, 111, 164);
    var conta_cor_texto = menu_alto_contraste
        ? make_color_rgb(20, 22, 34)
        : make_color_rgb(55, 63, 96);
    var conta_conectada_draw = variable_global_exists("soul_account_guest")
        && !global.soul_account_guest;
    var conta_ocupada_draw = variable_global_exists("soul_account_busy")
        && global.soul_account_busy;

    // Fundo e página central, mantendo a linguagem de álbum do restante do menu.
    draw_set_alpha(0.48);
    draw_set_color(make_color_rgb(35, 48, 72));
    draw_rectangle(0, 0, 1280, 811, false);
    draw_set_alpha(0.18);
    draw_set_color(make_color_rgb(30, 37, 61));
    draw_roundrect(257, 92, 1027, 718, false);
    draw_set_alpha(0.98);
    draw_set_color(conta_cor_capa);
    draw_roundrect(250, 84, 1020, 710, false);
    draw_set_alpha(1);
    draw_set_color(conta_cor_papel);
    draw_roundrect(270, 104, 1000, 690, false);
    draw_set_alpha(0.68);
    draw_set_color(conta_cor_borda);
    draw_roundrect(250, 84, 1020, 710, true);

    draw_set_alpha(0.90);
    draw_set_color(conta_cor_rosa);
    draw_roundrect(470, 112, 800, 174, false);
    draw_set_alpha(0.48);
    draw_set_color(conta_cor_borda);
    draw_roundrect(470, 112, 800, 174, true);

    draw_set_alpha(1);
    draw_set_color(conta_cor_texto);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(635, 143, "Conta e nuvem", 1.46, 1.46, 0);

    draw_set_alpha(0.75);
    draw_text_transformed(
        635,
        214,
        conta_conectada_draw
            ? "Seu progresso pode acompanhar voce em outros dispositivos."
            : "Entre apenas se quiser levar seu progresso para outro dispositivo.",
        0.82,
        0.82,
        0
    );

    if (!conta_conectada_draw) {
        var conta_campos_y = [292, 372];
        var conta_rotulos = ["E-mail", "Senha"];

        for (var conta_i = 0; conta_i < 2; conta_i++) {
            var conta_ativo_draw = conta_campo_ativo == conta_i;
            draw_set_halign(fa_left);
            draw_set_alpha(0.92);
            draw_set_color(conta_cor_texto);
            draw_text_transformed(382, conta_campos_y[conta_i] - 18, conta_rotulos[conta_i], 0.82, 0.82, 0);

            draw_set_alpha(0.98);
            draw_set_color(conta_cor_papel);
            draw_roundrect(370, conta_campos_y[conta_i], 910, conta_campos_y[conta_i] + 58, false);
            draw_set_alpha(conta_ativo_draw ? 0.95 : 0.42);
            draw_set_color(conta_ativo_draw ? conta_cor_menta : conta_cor_borda);
            draw_roundrect(370, conta_campos_y[conta_i], 910, conta_campos_y[conta_i] + 58, true);
        }

        var conta_senha_visual = "";
        repeat (string_length(conta_senha)) conta_senha_visual += "*";
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        draw_set_alpha(0.92);
        draw_set_color(conta_cor_texto);
        draw_text_transformed(392, 321, string_length(conta_email) > 0 ? conta_email : "voce@exemplo.com", 0.92, 0.92, 0);
        draw_text_transformed(392, 401, string_length(conta_senha_visual) > 0 ? conta_senha_visual : "Minimo de 6 caracteres", 0.92, 0.92, 0);

        var conta_botoes_x1 = [370, 660];
        var conta_botoes_x2 = [620, 910];
        var conta_botoes_txt = [conta_ocupada_draw ? "Conectando..." : "Entrar", "Criar conta"];
        for (var conta_b = 0; conta_b < 2; conta_b++) {
            var conta_hover_b = conta_mouse_sobre == conta_b + 2;
            draw_set_alpha(conta_ocupada_draw ? 0.44 : 0.96);
            draw_set_color(conta_hover_b ? conta_cor_menta : (conta_b == 0 ? conta_cor_azul : conta_cor_rosa));
            draw_roundrect(conta_botoes_x1[conta_b], 480, conta_botoes_x2[conta_b], 538, false);
            draw_set_alpha(conta_hover_b ? 0.95 : 0.52);
            draw_set_color(conta_cor_borda);
            draw_roundrect(conta_botoes_x1[conta_b], 480, conta_botoes_x2[conta_b], 538, true);
            draw_set_alpha(conta_ocupada_draw ? 0.50 : 1);
            draw_set_color(conta_cor_texto);
            draw_set_halign(fa_center);
            draw_text_transformed((conta_botoes_x1[conta_b] + conta_botoes_x2[conta_b]) / 2, 509, conta_botoes_txt[conta_b], 1.02, 1.02, 0);
        }
    }
    else {
        draw_set_alpha(0.82);
        draw_set_color(conta_cor_menta);
        draw_circle(635, 330, 70, false);
        draw_set_alpha(0.92);
        draw_set_color(conta_cor_borda);
        draw_circle(635, 330, 70, true);
        draw_set_alpha(1);
        draw_set_color(conta_cor_texto);
        draw_set_halign(fa_center);
        draw_text_transformed(635, 318, "Conta conectada", 1.18, 1.18, 0);
        draw_set_alpha(0.78);
        draw_text_transformed(635, 360, global.soul_account_email, 0.86, 0.86, 0);

        var conta_log_hover = conta_mouse_sobre == 5;
        var conta_back_hover = conta_mouse_sobre == 4;
        draw_set_alpha(0.96);
        draw_set_color(conta_log_hover ? conta_cor_rosa : conta_cor_papel);
        draw_roundrect(370, 480, 620, 538, false);
        draw_set_color(conta_back_hover ? conta_cor_menta : conta_cor_azul);
        draw_roundrect(660, 480, 910, 538, false);
        draw_set_alpha(0.58);
        draw_set_color(conta_cor_borda);
        draw_roundrect(370, 480, 620, 538, true);
        draw_roundrect(660, 480, 910, 538, true);
        draw_set_alpha(1);
        draw_set_color(conta_cor_texto);
        draw_text_transformed(495, 509, "Sair da conta", 1.00, 1.00, 0);
        draw_text_transformed(785, 509, "Voltar", 1.00, 1.00, 0);
    }

    var conta_mensagem = variable_global_exists("soul_account_message")
        ? global.soul_account_message
        : "Jogando como convidado";
    var conta_erro = variable_global_exists("soul_account_error")
        ? global.soul_account_error
        : "";
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_alpha(0.90);
    draw_set_color(string_length(conta_erro) > 0 ? make_color_rgb(164, 73, 92) : conta_cor_texto);
    draw_text_transformed(635, 574, string_length(conta_erro) > 0 ? conta_erro : conta_mensagem, 0.82, 0.82, 0);

    if (!conta_conectada_draw) {
        var conta_hover_reenviar = conta_mouse_sobre == 6;
        var conta_hover_voltar = conta_mouse_sobre == 4;
        draw_set_alpha(0.96);
        draw_set_color(conta_hover_reenviar ? conta_cor_menta : conta_cor_azul);
        draw_roundrect(350, 622, 620, 680, false);
        draw_set_color(conta_hover_voltar ? conta_cor_menta : conta_cor_papel);
        draw_roundrect(660, 622, 930, 680, false);
        draw_set_alpha((conta_hover_reenviar || conta_hover_voltar) ? 0.95 : 0.52);
        draw_set_color(conta_cor_borda);
        draw_roundrect(350, 622, 620, 680, true);
        draw_roundrect(660, 622, 930, 680, true);
        draw_set_alpha(1);
        draw_set_color(conta_cor_texto);
        draw_text_transformed(485, 651, "Reenviar confirmacao", 0.86, 0.86, 0);
        draw_text_transformed(795, 651, "Continuar como convidado", 0.86, 0.86, 0);
    }

    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(-1);
}

// ─────────────────────────────────────────────
// DESENHAR TELA DE CRÉDITOS
// ─────────────────────────────────────────────
if (mostrando_creditos) {
    // A arte enviada ja contem a composicao completa da tela. Desenha-la como
    // uma unica pagina preserva as proporcoes, a textura e a tipografia.
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_sprite_stretched(spr_ui_creditos, 0, 0, 0, 1280, 811);

    var cred_novo_mx = device_mouse_x_to_gui(0);
    var cred_novo_my = device_mouse_y_to_gui(0);
    if (point_in_rectangle(cred_novo_mx, cred_novo_my, 455, 620, 850, 705)) {
        draw_set_alpha(0.13);
        draw_set_color(make_color_rgb(239, 205, 226));
        draw_roundrect(455, 620, 850, 705, false);
        draw_set_alpha(1);
    }

    exit;

    draw_set_font(fnt_dialogo);

    var cred_cor_papel = menu_alto_contraste
        ? c_white
        : make_color_rgb(255, 249, 239);
    var cred_cor_capa = make_color_rgb(220, 212, 244);
    var cred_cor_rosa = make_color_rgb(239, 205, 226);
    var cred_cor_menta = make_color_rgb(198, 237, 220);
    var cred_cor_azul = make_color_rgb(205, 228, 245);
    var cred_cor_borda = menu_alto_contraste
        ? make_color_rgb(48, 38, 86)
        : make_color_rgb(121, 111, 164);
    var cred_cor_texto = menu_alto_contraste
        ? make_color_rgb(20, 22, 34)
        : make_color_rgb(55, 63, 96);
    var cred_cor_folha = make_color_rgb(79, 128, 112);

    // Fundo calmo para destacar a página de scrapbook.
    draw_set_alpha(0.44);
    draw_set_color(make_color_rgb(35, 48, 72));
    draw_rectangle(0, 0, 1280, 811, false);

    // Capa, sombra e folha principal.
    draw_set_alpha(0.18);
    draw_set_color(make_color_rgb(30, 37, 61));
    draw_roundrect(231, 104, 1051, 692, false);

    draw_set_alpha(0.98);
    draw_set_color(cred_cor_capa);
    draw_roundrect(222, 94, 1042, 682, false);

    draw_set_alpha(0.70);
    draw_set_color(cred_cor_borda);
    draw_roundrect(222, 94, 1042, 682, true);

    draw_set_alpha(1);
    draw_set_color(cred_cor_papel);
    draw_roundrect(239, 111, 1025, 665, false);

    draw_set_alpha(0.34);
    draw_set_color(cred_cor_borda);
    draw_roundrect(239, 111, 1025, 665, true);

    // Fita do título.
    draw_set_alpha(0.92);
    draw_set_color(cred_cor_rosa);
    draw_roundrect(510, 132, 754, 198, false);

    draw_set_alpha(0.42);
    draw_set_color(cred_cor_borda);
    draw_roundrect(510, 132, 754, 198, true);

    draw_set_alpha(1);
    draw_set_color(cred_cor_texto);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(632, 165, "Créditos", 1.70, 1.70, 0);

    // Cartão da criação.
    draw_set_alpha(0.18);
    draw_set_color(cred_cor_borda);
    draw_roundrect(281, 232, 614, 520, false);

    draw_set_alpha(0.96);
    draw_set_color(cred_cor_azul);
    draw_roundrect(275, 225, 608, 513, false);

    draw_set_alpha(0.36);
    draw_set_color(cred_cor_borda);
    draw_roundrect(275, 225, 608, 513, true);

    draw_set_alpha(0.88);
    draw_set_color(cred_cor_menta);
    draw_roundrect(358, 216, 526, 236, false);

    draw_set_alpha(1);
    draw_set_color(cred_cor_texto);
    draw_text_transformed(442, 275, "SOULSCAPES", 1.28, 1.28, 0);

    draw_set_alpha(0.70);
    draw_text_transformed(442, 328, "Desenvolvimento, arte e roteiro", 0.88, 0.88, 0);

    draw_set_alpha(1);
    draw_text_transformed(442, 374, "Alicia", 1.34, 1.34, 0);

    draw_set_alpha(0.72);
    draw_text_transformed(442, 443, "Projeto desenvolvido como\ntrabalho escolar.", 0.86, 0.86, 0);

    // Cartão dos agradecimentos.
    draw_set_alpha(0.18);
    draw_set_color(cred_cor_borda);
    draw_roundrect(657, 232, 990, 520, false);

    draw_set_alpha(0.97);
    draw_set_color(cred_cor_menta);
    draw_roundrect(651, 225, 984, 513, false);

    draw_set_alpha(0.36);
    draw_set_color(cred_cor_borda);
    draw_roundrect(651, 225, 984, 513, true);

    draw_set_alpha(0.88);
    draw_set_color(cred_cor_rosa);
    draw_roundrect(734, 216, 902, 236, false);

    draw_set_alpha(1);
    draw_set_color(cred_cor_texto);
    draw_text_transformed(818, 274, "Agradecimentos", 1.18, 1.18, 0);

    draw_set_alpha(0.74);
    draw_text_transformed(
        818,
        340,
        "Aos professores, orientadores\ne participantes da pesquisa.",
        0.84,
        0.84,
        0
    );

    // Bilhetinho especial para Mauricio B.
    draw_set_alpha(0.92);
    draw_set_color(cred_cor_papel);
    draw_roundrect(686, 397, 950, 481, false);

    draw_set_alpha(0.46);
    draw_set_color(cred_cor_borda);
    draw_roundrect(686, 397, 950, 481, true);

    draw_set_alpha(1);
    draw_set_color(cred_cor_texto);
    draw_text_transformed(
        818,
        439,
        "Agradecimento especial ao meu irmão,\nMauricio B.",
        0.82,
        0.82,
        0
    );

    // Folhinhas e confetes de scrapbook.
    desenhar_folha(267, 146, 210, 22, 12, cred_cor_folha, 0.80);
    desenhar_folha(283, 135, 315, 24, 13, cred_cor_folha, 0.88);
    desenhar_folha(1000, 620, 35, 24, 13, cred_cor_folha, 0.84);
    desenhar_folha(1011, 637, 220, 21, 11, cred_cor_folha, 0.76);

    draw_set_alpha(0.78 * menu_decoracao);
    draw_set_color(cred_cor_rosa);
    draw_circle(272, 622, 6, false);
    draw_set_color(cred_cor_azul);
    draw_circle(289, 633, 3, false);
    draw_set_color(cred_cor_menta);
    draw_circle(992, 142, 5, false);

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

    draw_set_alpha(0.18);
    draw_set_color(cred_cor_borda);
    draw_roundrect(voltar_x1 + 3, voltar_y1 + 4, voltar_x2 + 3, voltar_y2 + 4, false);

    draw_set_alpha(0.96);
    draw_set_color(mouse_sobre_voltar ? cred_cor_rosa : cred_cor_papel);
    draw_roundrect(voltar_x1, voltar_y1, voltar_x2, voltar_y2, false);

    draw_set_color(cred_cor_borda);
    draw_set_alpha(mouse_sobre_voltar ? 0.92 : 0.56);
    draw_roundrect(voltar_x1, voltar_y1, voltar_x2, voltar_y2, true);

    draw_set_alpha(1);
    draw_set_color(cred_cor_texto);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_text(
        640,
        (voltar_y1 + voltar_y2) / 2,
        "Back"
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
        720
    ];

    var barra_x1 = 650;
    var barra_x2 = 1060;

    // Paleta de álbum de memórias.
    var cor_overlay = make_color_rgb(42, 55, 84);
    var cor_painel = make_color_rgb(220, 212, 244);
    var cor_painel_interno = menu_alto_contraste
        ? c_white
        : make_color_rgb(255, 249, 239);
    var cor_papel_sombra = make_color_rgb(226, 211, 205);

    var cor_texto = menu_alto_contraste
        ? make_color_rgb(20, 22, 34)
        : make_color_rgb(57, 66, 107);
    var cor_texto_claro = make_color_rgb(91, 97, 137);

    var cor_borda = menu_alto_contraste
        ? make_color_rgb(48, 38, 86)
        : make_color_rgb(121, 111, 164);
    var cor_rosa = make_color_rgb(239, 205, 226);
    var cor_lilas = make_color_rgb(220, 212, 244);
    var cor_menta = make_color_rgb(198, 237, 220);
    var cor_azul = make_color_rgb(205, 228, 245);
    var cor_destaque = cor_rosa;
    var cor_slider = make_color_rgb(137, 187, 174);
    var cor_desativado = make_color_rgb(225, 219, 226);

    var cfg_cores_cartao = [
        cor_azul,
        cor_lilas,
        cor_menta,
        cor_rosa,
        cor_azul,
        cor_lilas,
        cor_menta
    ];

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

    // Capa do álbum.
    draw_set_alpha(0.98);
    draw_set_color(cor_painel);

    draw_roundrect(
        100,
        70,
        1170,
        750,
        false
    );

    // Página de papel creme.
    draw_set_alpha(1);
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

    // Fita pastel atrás do título.
    draw_set_alpha(0.88);
    draw_set_color(cor_rosa);
    draw_roundrect(485, 91, 785, 149, false);

    draw_set_alpha(0.40);
    draw_set_color(cor_borda);
    draw_roundrect(485, 91, 785, 149, true);

    // Título
    draw_set_alpha(1);
    draw_set_color(cor_texto);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_text_transformed(
        635,
        120,
        "Configurações",
        1.52,
        1.52,
        0
    );

    // Cada configuração fica em um cartão de papel pastel.
    for (var i = 0; i < 7; i++) {
        var cfg_selecionado = config_opcao_atual == i;

        draw_set_alpha(cfg_selecionado ? 0.18 : 0.08);
        draw_set_color(cor_papel_sombra);
        draw_roundrect(139, cfg_y[i] - 24, 1139, cfg_y[i] + 29, false);

        draw_set_alpha(cfg_selecionado ? 0.48 : 0.22);
        draw_set_color(cfg_cores_cartao[i]);
        draw_roundrect(135, cfg_y[i] - 27, 1135, cfg_y[i] + 27, false);

        draw_set_alpha(cfg_selecionado ? 0.70 : 0.24);
        draw_set_color(cor_borda);
        draw_roundrect(135, cfg_y[i] - 27, 1135, cfg_y[i] + 27, true);

        // Pequena fita prendendo cada cartão à página.
        draw_set_alpha(cfg_selecionado ? 0.76 : 0.38);
        draw_set_color(i mod 2 == 0 ? cor_rosa : cor_menta);
        draw_roundrect(151, cfg_y[i] - 31, 193, cfg_y[i] - 21, false);
    }

    // Ramos completos nos cantos, com caule e folhas separadas.
    desenhar_raminho_ajustes(132, 132, false, 0.84 * menu_decoracao);
    desenhar_raminho_ajustes(1128, 704, true, 0.82 * menu_decoracao);

    draw_set_alpha(0.78 * menu_decoracao);
    draw_set_color(cor_rosa);
    draw_circle(1119, 112, 5, false);
    draw_set_color(cor_menta);
    draw_circle(1135, 123, 3, false);

    // Textos das opções
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_set_color(cor_texto);
    draw_set_alpha(0.95);

    draw_text_transformed(165, cfg_y[0], "Music volume", 1.12, 1.12, 0);
    draw_text_transformed(165, cfg_y[1], "Sound volume", 1.12, 1.12, 0);
    draw_text_transformed(165, cfg_y[2], "Low-stimulation mode", 1.12, 1.12, 0);
    draw_text_transformed(165, cfg_y[3], "Reduce motion", 1.12, 1.12, 0);
    draw_text_transformed(165, cfg_y[4], "Text speed", 1.12, 1.12, 0);
    draw_text_transformed(165, cfg_y[5], "Text size", 1.12, 1.12, 0);
    draw_text_transformed(165, cfg_y[6], "Contrast", 1.12, 1.12, 0);


    // ─────────────────────────────────────────
    // SLIDERS
    // ─────────────────────────────────────────

    // Música
    draw_set_alpha(0.64);
    draw_set_color(cor_papel_sombra);

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

    draw_set_color(cor_painel_interno);
    draw_circle(musica_x, cfg_y[0], 7, false);
    draw_set_color(cor_rosa);
    draw_circle(musica_x, cfg_y[0], 3, false);

    draw_set_color(cor_borda);
    draw_circle(
        musica_x,
        cfg_y[0],
        12,
        true
    );

    // Sons
    draw_set_alpha(0.64);
    draw_set_color(cor_papel_sombra);

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

    draw_set_color(cor_painel_interno);
    draw_circle(sons_x, cfg_y[1], 7, false);
    draw_set_color(cor_azul);
    draw_circle(sons_x, cfg_y[1], 3, false);

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
        ? cor_menta
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

    draw_set_color(config_baixo_estimulo ? cor_slider : cor_rosa);
    draw_circle(estimulo_x, cfg_y[2], 4, false);

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
        ? cor_menta
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

    draw_set_color(config_reduzir_animacoes ? cor_slider : cor_rosa);
    draw_circle(animacao_x, cfg_y[3], 4, false);

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
        "Slow",
        "Normal",
        "Fast"
    ];

    var textos_tamanho = [
        "Small",
        "Normal",
        "Large"
    ];

    var textos_contraste = [
        "Normal",
        "High"
    ];

    draw_set_alpha(1);
    draw_set_color(cor_texto);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    // Etiquetas de papel para as opções com setas.
    for (var cfg_valor_i = 4; cfg_valor_i <= 6; cfg_valor_i++) {
        draw_set_alpha(0.82);
        draw_set_color(cor_painel_interno);
        draw_roundrect(744, cfg_y[cfg_valor_i] - 20, 966, cfg_y[cfg_valor_i] + 20, false);

        draw_set_alpha(0.36);
        draw_set_color(cor_borda);
        draw_roundrect(744, cfg_y[cfg_valor_i] - 20, 966, cfg_y[cfg_valor_i] + 20, true);

        draw_set_alpha(0.70);
        draw_set_color(cfg_cores_cartao[cfg_valor_i]);
        draw_circle(700, cfg_y[cfg_valor_i], 18, false);
        draw_circle(1010, cfg_y[cfg_valor_i], 18, false);
    }

    draw_set_alpha(1);
    draw_set_color(cor_texto);

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

    draw_set_alpha(0.18);
    draw_set_color(cor_papel_sombra);
    draw_roundrect(voltar_x1 + 3, voltar_y1 + 4, voltar_x2 + 3, voltar_y2 + 4, false);

    draw_set_alpha(0.96);
    draw_set_color(sobre_voltar ? cor_destaque : cor_painel_interno);
    draw_roundrect(voltar_x1, voltar_y1, voltar_x2, voltar_y2, false);

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
        "Back",
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

// A arte foi composta para paisagem. Em celulares ainda não rotacionados,
// manter a leitura íntegra em vez de esmagar os botões do menu.
if (
    variable_global_exists("mobile_mode")
    && global.mobile_mode
    && (
        (variable_global_exists("mobile_browser") && global.mobile_browser)
            ? browser_width < browser_height
            : display_get_width() < display_get_height()
    )
) {
    var rotacao_gui_w = display_get_gui_width();
    var rotacao_gui_h = display_get_gui_height();

    draw_set_alpha(0.95);
    draw_set_color(make_color_rgb(30, 42, 67));
    draw_rectangle(0, 0, rotacao_gui_w, rotacao_gui_h, false);

    draw_set_alpha(1);
    draw_set_font(fnt_dialogo);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(250, 246, 239));
    draw_text_transformed(
        rotacao_gui_w * 0.5,
        rotacao_gui_h * 0.45,
        "Gire o celular para jogar",
        1.35,
        1.35,
        0
    );
    draw_set_color(make_color_rgb(194, 222, 215));
    draw_text(
        rotacao_gui_w * 0.5,
        rotacao_gui_h * 0.54,
        "Soulscapes foi criado para a tela horizontal."
    );

    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(-1);
}
