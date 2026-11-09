draw_set_font(fnt_dialogo);

var _baixo_estimulo =
    variable_global_exists("config_baixo_estimulo")
    && global.config_baixo_estimulo;

var _reduzir_animacoes =
    variable_global_exists("config_reduzir_animacoes")
    && global.config_reduzir_animacoes;

var _alto_contraste =
    variable_global_exists("config_contraste")
    && global.config_contraste >= 1;

var _intensidade_magia = _baixo_estimulo ? 0.38 : 1;

// Garante que o inventário exista mesmo em saves antigos.
if (!variable_global_exists("fragmentos_vitral")) {
    global.fragmentos_vitral = [false, false, false, false];
}

// Aviso exibido perto do vitral quando o puzzle está fechado.
if (perto_do_vitral && !puzzle_ativo && !global.vitral_resolvido) {
    var _pausa_aberta = variable_global_exists("jogo_pausado") && global.jogo_pausado;
    var _dialogo_aberto = variable_global_exists("dialogue_open") && global.dialogue_open;

    if (!_pausa_aberta && !_dialogo_aberto) {
        var _aviso_x1 = 465;
        var _aviso_y1 = 704;
        var _aviso_x2 = 815;
        var _aviso_y2 = 762;
        var _aviso_cy = 733;

        draw_set_alpha(0.18);
        draw_set_color(make_color_rgb(73, 70, 110));
        draw_roundrect(_aviso_x1 + 3, _aviso_y1 + 4, _aviso_x2 + 3, _aviso_y2 + 4, false);

        draw_set_alpha(0.94);
        draw_set_color(_alto_contraste ? c_white : make_color_rgb(249, 244, 251));
        draw_roundrect(_aviso_x1, _aviso_y1, _aviso_x2, _aviso_y2, false);

        draw_set_alpha(0.76);
        draw_set_color(_alto_contraste ? make_color_rgb(43, 34, 79) : make_color_rgb(139, 122, 185));
        draw_roundrect(_aviso_x1, _aviso_y1, _aviso_x2, _aviso_y2, true);

        draw_set_alpha(0.96);
        draw_set_color(make_color_rgb(222, 211, 244));
        draw_roundrect(
            _aviso_x1 + 12,
            _aviso_y1 + 10,
            _aviso_x1 + 56,
            _aviso_y2 - 10,
            false
        );

        draw_set_alpha(0.86);
        draw_set_color(make_color_rgb(121, 105, 171));
        draw_roundrect(
            _aviso_x1 + 12,
            _aviso_y1 + 10,
            _aviso_x1 + 56,
            _aviso_y2 - 10,
            true
        );

        draw_set_alpha(1);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(_alto_contraste ? make_color_rgb(20, 20, 32) : make_color_rgb(76, 69, 119));
        draw_text(_aviso_x1 + 34, _aviso_cy, (variable_global_exists("mobile_mode") && global.mobile_mode) ? "!" : "E");

        draw_set_color(_alto_contraste ? make_color_rgb(20, 20, 32) : make_color_rgb(64, 67, 101));
        draw_text(
            (_aviso_x1 + 60 + _aviso_x2) / 2,
            _aviso_cy,
            "Examinar vitral"
        );

        draw_set_alpha(0.78);
        draw_set_color(make_color_rgb(238, 196, 222));
        draw_circle(_aviso_x2 - 14, _aviso_y1 + 12, 4, false);
        draw_set_color(make_color_rgb(191, 235, 220));
        draw_circle(_aviso_x2 - 9, _aviso_y1 + 22, 2, false);
    }
}

if (!puzzle_ativo) {
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    exit;
}

// Paleta: magia pastel + floresta encantada.
var _cor_overlay       = make_color_rgb(28, 33, 60);
var _cor_painel        = _alto_contraste ? c_white : make_color_rgb(245, 239, 249);
var _cor_cartao        = _alto_contraste ? c_white : make_color_rgb(255, 250, 253);
var _cor_cartao_alt    = make_color_rgb(234, 242, 251);
var _cor_borda         = _alto_contraste ? make_color_rgb(45, 34, 80) : make_color_rgb(139, 124, 174);
var _cor_borda_clara   = make_color_rgb(210, 193, 228);
var _cor_texto         = _alto_contraste ? make_color_rgb(18, 18, 28) : make_color_rgb(70, 59, 99);
var _cor_texto_suave   = _alto_contraste ? make_color_rgb(55, 43, 76) : make_color_rgb(126, 109, 148);
var _cor_acento        = make_color_rgb(91, 185, 153);
var _cor_acento_clara  = make_color_rgb(199, 237, 220);
var _cor_central       = make_color_rgb(143, 202, 235);
var _cor_rosa          = make_color_rgb(240, 165, 201);
var _cor_lilas         = make_color_rgb(190, 169, 231);
var _cor_azul          = make_color_rgb(158, 207, 238);

var _cacos_encontrados = 0;
for (var _contar = 0; _contar < array_length(global.fragmentos_vitral); _contar++) {
    if (global.fragmentos_vitral[_contar]) _cacos_encontrados++;
}

var _restaurados = 1 + _cacos_encontrados;
var _pulso = _reduzir_animacoes ? 0 : sin(tempo_puzzle) * 3;

// Fundo e sombra do painel.
draw_set_alpha(0.84);
draw_set_color(_cor_overlay);
draw_rectangle(0, 0, 1280, 811, false);

draw_set_alpha(0.24);
draw_set_color(c_black);
draw_roundrect(88, 48, 1208, 783, false);

draw_set_alpha(0.985);
draw_set_color(_cor_painel);
draw_roundrect(80, 36, 1200, 775, false);

draw_set_alpha(0.70);
draw_set_color(_cor_borda_clara);
draw_roundrect(80, 36, 1200, 775, true);

// Cabeçalho.
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_set_alpha(1);
draw_set_color(_cor_texto);
draw_text_transformed(116, 78, "Vitral da Memória", 1.45, 1.45, 0);

draw_set_alpha(0.78);
draw_set_color(_cor_texto_suave);
draw_text(116, 111, "Reconstrua a lembrança reunindo os fragmentos perdidos.");

// Indicador de progresso isolado do restante da interface.
draw_set_alpha(0.85);
draw_set_color(_cor_cartao_alt);
draw_roundrect(942, 62, 1164, 116, false);

draw_set_alpha(0.85);
draw_set_color(_cor_borda_clara);
draw_roundrect(942, 62, 1164, 116, true);

draw_set_halign(fa_center);
draw_set_alpha(1);
draw_set_color(_cor_acento);
draw_text_transformed(985, 89, string(_restaurados) + " / 5", 1.12, 1.12, 0);

draw_set_halign(fa_left);
draw_set_color(_cor_texto_suave);
draw_set_alpha(0.9);
draw_text(1030, 89, "restaurado");

draw_set_alpha(0.55);
draw_set_color(_cor_borda_clara);
draw_line_width(108, 132, 1172, 132, 1);

// Cartões principais: vitral à esquerda, inventário à direita.
draw_set_alpha(0.93);
draw_set_color(_cor_cartao);
draw_roundrect(108, 150, 760, 680, false);
draw_roundrect(784, 150, 1172, 680, false);

draw_set_alpha(0.62);
draw_set_color(_cor_borda_clara);
draw_roundrect(108, 150, 760, 680, true);
draw_roundrect(784, 150, 1172, 680, true);

// Pequenos detalhes botânicos nos cantos dos cartões.
draw_set_alpha(0.32);
draw_set_color(_cor_acento);
draw_line_width(122, 660, 151, 631, 2);
draw_ellipse(116, 644, 139, 657, false);
draw_ellipse(133, 630, 149, 650, false);

draw_line_width(1132, 660, 1158, 633, 2);
draw_ellipse(1128, 641, 1150, 654, false);
draw_ellipse(1143, 629, 1160, 648, false);

// Florzinha pastel no topo do inventário.
draw_set_alpha(0.42);
draw_set_color(_cor_rosa);
draw_circle(1138, 174, 6, false);
draw_circle(1150, 174, 6, false);
draw_circle(1144, 168, 6, false);
draw_circle(1144, 180, 6, false);
draw_set_color(_cor_acento);
draw_circle(1144, 174, 4, false);

draw_set_halign(fa_left);
draw_set_alpha(1);
draw_set_color(_cor_texto);
draw_text_transformed(136, 177, "Restauração", 1.08, 1.08, 0);

draw_set_halign(fa_right);
draw_set_alpha(0.8);
draw_set_color(_cor_acento);
draw_text(730, 177, "Centro preservado");

draw_set_halign(fa_left);
draw_set_alpha(1);
draw_set_color(_cor_texto);
draw_text_transformed(812, 177, "Fragmentos", 1.08, 1.08, 0);

draw_set_alpha(0.72);
draw_set_color(_cor_texto_suave);
draw_text(812, 207, "Leve os cacos encontrados ao vitral.");

// Brilho contido dentro do cartão do vitral.
draw_set_alpha(0.09 * _intensidade_magia);
draw_set_color(_cor_acento_clara);
draw_circle(435, 410, 208 + _pulso, false);

draw_set_alpha(0.06 * _intensidade_magia);
draw_circle(435, 410, 235 + _pulso, false);

// Moldura gótica externa.
draw_set_alpha(0.30);
draw_set_color(_cor_cartao_alt);
draw_triangle(435, 202, 228, 280, 642, 280, false);
draw_rectangle(228, 280, 642, 610, false);

draw_set_alpha(0.92);
draw_set_color(_cor_borda);
draw_line_width(228, 280, 435, 202, 4);
draw_line_width(642, 280, 435, 202, 4);
draw_line_width(228, 280, 228, 610, 4);
draw_line_width(642, 280, 642, 610, 4);
draw_line_width(228, 610, 642, 610, 4);

// Luzes de fada acompanhando o arco do vitral.
var _luzes_x = [255, 300, 345, 390, 435, 480, 525, 570, 615];
var _luzes_y = [270, 253, 236, 219, 203, 219, 236, 253, 270];

for (var _luz = 0; _luz < array_length(_luzes_x); _luz++) {
    var _brilho_luz = _reduzir_animacoes
        ? 0.54
        : 0.54 + sin(tempo_puzzle + (_luz * 0.8)) * 0.18;
    var _cor_luz_fada = _cor_rosa;

    if ((_luz mod 3) == 1) _cor_luz_fada = _cor_acento;
    if ((_luz mod 3) == 2) _cor_luz_fada = _cor_lilas;

    draw_set_alpha(_brilho_luz * 0.24 * _intensidade_magia);
    draw_set_color(_cor_luz_fada);
    draw_circle(_luzes_x[_luz], _luzes_y[_luz], 9, false);

    draw_set_alpha(_brilho_luz * _intensidade_magia);
    draw_circle(_luzes_x[_luz], _luzes_y[_luz], 3, false);
}

// Moldura interna e divisões do vidro.
draw_set_alpha(0.42);
draw_set_color(c_white);
draw_triangle(435, 232, 256, 294, 614, 294, false);
draw_rectangle(256, 294, 614, 580, false);

draw_set_alpha(0.72);
draw_set_color(_cor_borda_clara);
draw_line_width(256, 294, 435, 232, 2);
draw_line_width(614, 294, 435, 232, 2);
draw_line_width(256, 294, 256, 580, 2);
draw_line_width(614, 294, 614, 580, 2);
draw_line_width(256, 580, 614, 580, 2);
draw_line_width(435, 232, 435, 580, 2);
draw_line_width(256, 405, 614, 405, 2);

draw_set_alpha(0.45);
draw_line_width(435, 405, peca_alvo_x[0], peca_alvo_y[0], 2);
draw_line_width(435, 405, peca_alvo_x[1], peca_alvo_y[1], 2);
draw_line_width(435, 405, peca_alvo_x[2], peca_alvo_y[2], 2);
draw_line_width(435, 405, peca_alvo_x[3], peca_alvo_y[3], 2);

// Silhuetas dos quatro encaixes.
for (var _slot = 0; _slot < array_length(peca_colocada); _slot++) {
    if (!peca_colocada[_slot]) {
        desenhar_fragmento(
            _slot,
            peca_alvo_x[_slot],
            peca_alvo_y[_slot],
            _cor_borda_clara,
            0.12,
            _cor_borda,
            0.32
        );
    }
}

// Rosácea e fragmento central fixo.
draw_set_alpha(0.12 * _intensidade_magia);
draw_set_color(_cor_central);
draw_circle(435, 405, 76 + _pulso, false);

draw_set_alpha(0.20 * _intensidade_magia);
draw_circle(435, 405, 55, false);

draw_set_alpha(0.96);
draw_set_color(_cor_central);
draw_triangle(435, 343, 487, 405, 435, 467, false);
draw_triangle(435, 343, 383, 405, 435, 467, false);

draw_set_alpha(0.82);
draw_set_color(_cor_borda);
draw_line_width(435, 343, 487, 405, 2);
draw_line_width(487, 405, 435, 467, 2);
draw_line_width(435, 467, 383, 405, 2);
draw_line_width(383, 405, 435, 343, 2);

draw_set_alpha(0.42);
draw_set_color(c_white);
draw_line_width(416, 383, 447, 425, 2);

// Brilhinhos ao redor do centro, discretos para não competir com as peças.
draw_set_alpha(
    (_reduzir_animacoes ? 0.48 : 0.48 + sin(tempo_puzzle) * 0.12)
    * _intensidade_magia
);
draw_set_color(_cor_rosa);
draw_line_width(348, 346, 348, 360, 2);
draw_line_width(341, 353, 355, 353, 2);

draw_set_color(_cor_lilas);
draw_line_width(525, 476, 525, 490, 2);
draw_line_width(518, 483, 532, 483, 2);

draw_set_color(_cor_azul);
draw_circle(565, 335, 3, false);
draw_circle(309, 486, 3, false);

// Bases do inventário e seus estados.
for (var _base = 0; _base < array_length(peca_colocada); _base++) {
    var _encontrou = global.fragmentos_vitral[_base];
    var _encaixada = peca_colocada[_base];
    var _bx = peca_inicio_x[_base];
    var _by = peca_inicio_y[_base];

    draw_set_alpha(_encontrou ? 0.22 : 0.10);
    draw_set_color(_encontrou ? _cor_acento_clara : _cor_cartao_alt);
    draw_circle(_bx, _by, 66, false);

    draw_set_alpha(_encontrou ? 0.72 : 0.36);
    draw_set_color(_encontrou ? _cor_acento : _cor_borda_clara);
    draw_circle(_bx, _by, 60, true);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    if (!_encontrou) {
        draw_set_alpha(0.42);
        draw_set_color(_cor_texto_suave);
        draw_text_transformed(_bx, _by - 2, "?", 1.35, 1.35, 0);

        draw_set_alpha(0.66);
        draw_text(_bx, _by + 78, "Não encontrado");
    }
    else if (_encaixada) {
        draw_set_alpha(0.92);
        draw_set_color(_cor_acento);
        draw_line_width(_bx - 16, _by, _bx - 4, _by + 13, 4);
        draw_line_width(_bx - 4, _by + 13, _bx + 20, _by - 16, 4);

        draw_set_alpha(0.82);
        draw_text(_bx, _by + 78, "Encaixado");
    }
    else {
        draw_set_alpha(0.82);
        draw_set_color(_cor_texto_suave);
        draw_text(_bx, _by + 78, "Encontrado");
    }
}

// Peças coletadas. A arrastada é desenhada por último.
for (var _peca = 0; _peca < array_length(peca_colocada); _peca++) {
    if (global.fragmentos_vitral[_peca] && _peca != peca_arrastada) {
        var _peca_encaixada = peca_colocada[_peca];

        if (_peca_encaixada) {
            draw_set_alpha(0.12);
            draw_set_color(cores_fragmentos[_peca]);
            draw_circle(peca_x[_peca], peca_y[_peca], 66, false);
        }

        desenhar_fragmento(
            _peca,
            peca_x[_peca],
            peca_y[_peca],
            cores_fragmentos[_peca],
            0.96,
            _cor_borda,
            _peca_encaixada ? 0.92 : 0.72
        );
    }
}

if (peca_arrastada != -1) {
    draw_set_alpha(0.18);
    draw_set_color(cores_fragmentos[peca_arrastada]);
    draw_circle(peca_x[peca_arrastada], peca_y[peca_arrastada], 76, false);

    desenhar_fragmento(
        peca_arrastada,
        peca_x[peca_arrastada],
        peca_y[peca_arrastada],
        cores_fragmentos[peca_arrastada],
        1,
        _cor_borda,
        1
    );
}

// Mensagem contextual no rodapé do inventário.
draw_set_alpha(0.76);
draw_set_color(_cor_cartao_alt);
draw_roundrect(812, 570, 1144, 644, false);

draw_set_alpha(0.55);
draw_set_color(_cor_borda_clara);
draw_roundrect(812, 570, 1144, 644, true);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

if (concluindo_puzzle) {
    draw_set_alpha(1);
    draw_set_color(_cor_acento);
    draw_text_transformed(978, 595, "A memória desperta...", 1.08, 1.08, 0);

    draw_set_alpha(0.78);
    draw_set_color(_cor_texto_suave);
    draw_text(978, 624, "Vitral restaurado por completo");
}
else if (_cacos_encontrados < 4) {
    draw_set_alpha(1);
    draw_set_color(_cor_texto);
    draw_text(978, 594, "A floresta guarda mais brilhos");

    draw_set_alpha(0.76);
    draw_set_color(_cor_texto_suave);
    draw_text(978, 622, string(_cacos_encontrados) + " de 4 cacos encontrados");
}
else {
    draw_set_alpha(1);
    draw_set_color(_cor_texto);
    draw_text(978, 594, "Todos os cacos encontrados");

    draw_set_alpha(0.76);
    draw_set_color(_cor_texto_suave);
    draw_text(978, 622, "Arraste cada peça até sua silhueta");
}

// Botão de saída grande e tocável, mantido acima da moldura no mobile.
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_alpha(0.16);
// Cor literal: evita que builds HTML5 antigos tentem ler uma variável local
// inexistente ao restaurar o puzzle a partir de um save anterior.
draw_set_color(make_color_rgb(37, 42, 66));
draw_roundrect(523, 658, 763, 722, false);

draw_set_alpha(0.96);
draw_set_color(_cor_cartao_alt);
draw_roundrect(520, 652, 760, 716, false);

draw_set_alpha(0.84);
draw_set_color(_cor_borda);
draw_roundrect(520, 652, 760, 716, true);

draw_set_alpha(1);
draw_set_color(_cor_texto);
draw_text(640, 684, "VOLTAR");

// Restaura o estado de desenho para os demais objetos.
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
