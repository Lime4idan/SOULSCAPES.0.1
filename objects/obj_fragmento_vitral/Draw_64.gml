if (false) {
draw_set_font(fnt_dialogo);


// ═════════════════════════════════════════════
// CONTAR FRAGMENTOS COLETADOS
// ═════════════════════════════════════════════
var total_coletado = 0;

for (
    var i = 0;
    i < array_length(global.fragmentos_vitral);
    i++
) {
    if (global.fragmentos_vitral[i]) {
        total_coletado++;
    }
}


// ═════════════════════════════════════════════
// AVISO DE INTERAÇÃO
// ═════════════════════════════════════════════
if (
    perto_do_fragmento
    && !coletando
    && !global.jogo_pausado
    && !global.dialogue_open
) {
    var aviso_cx = display_get_gui_width() / 2;
    var aviso_cy = display_get_gui_height() - 120;
    var aviso_w = 350;
    var aviso_h = 58;
    var aviso_x1 = aviso_cx - aviso_w / 2;
    var aviso_y1 = aviso_cy - aviso_h / 2;
    var aviso_x2 = aviso_cx + aviso_w / 2;
    var aviso_y2 = aviso_cy + aviso_h / 2;

    draw_set_alpha(0.18);
    draw_set_color(make_color_rgb(73, 70, 110));
    draw_roundrect(aviso_x1 + 3, aviso_y1 + 4, aviso_x2 + 3, aviso_y2 + 4, false);

    draw_set_alpha(0.94);
    draw_set_color(make_color_rgb(249, 244, 251));
    draw_roundrect(aviso_x1, aviso_y1, aviso_x2, aviso_y2, false);

    draw_set_alpha(0.76);
    draw_set_color(make_color_rgb(139, 122, 185));
    draw_roundrect(aviso_x1, aviso_y1, aviso_x2, aviso_y2, true);

    draw_set_alpha(0.96);
    draw_set_color(make_color_rgb(222, 211, 244));
    draw_roundrect(
        aviso_x1 + 12,
        aviso_y1 + 10,
        aviso_x1 + 56,
        aviso_y2 - 10,
        false
    );

    draw_set_alpha(0.86);
    draw_set_color(make_color_rgb(121, 105, 171));
    draw_roundrect(
        aviso_x1 + 12,
        aviso_y1 + 10,
        aviso_x1 + 56,
        aviso_y2 - 10,
        true
    );

    draw_set_alpha(1);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(76, 69, 119));
    draw_text(aviso_x1 + 34, aviso_cy, (variable_global_exists("mobile_mode") && global.mobile_mode) ? "!" : "E");

    draw_set_color(make_color_rgb(64, 67, 101));
    draw_text(
        (aviso_x1 + 60 + aviso_x2) / 2,
        aviso_cy,
        "Coletar fragmento"
    );

    draw_set_alpha(0.78);
    draw_set_color(make_color_rgb(238, 196, 222));
    draw_circle(aviso_x2 - 14, aviso_y1 + 12, 4, false);
    draw_set_color(make_color_rgb(191, 235, 220));
    draw_circle(aviso_x2 - 9, aviso_y1 + 22, 2, false);
}


// ═════════════════════════════════════════════
// MENSAGEM APÓS COLETAR
// ═════════════════════════════════════════════
if (coletando) {
    var alpha_aviso =
        clamp(tempo_coleta / 20, 0, 1);

    draw_set_alpha(alpha_aviso * 0.90);

    draw_set_color(
        make_color_rgb(229, 231, 241)
    );

    draw_roundrect(
        470,
        90,
        810,
        150,
        false
    );


    draw_set_alpha(alpha_aviso * 0.58);

    draw_set_color(
        make_color_rgb(91, 105, 137)
    );

    draw_roundrect(
        470,
        90,
        810,
        150,
        true
    );


    draw_set_alpha(alpha_aviso);

    draw_set_color(
        make_color_rgb(55, 65, 95)
    );

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_text(
        640,
        120,
        "Fragment found  "
        + string(total_coletado)
        + " / 4"
    );
}


// Restaurar
draw_set_alpha(1);
draw_set_color(c_white);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
}

draw_set_font(fnt_dialogo);

var estg_total = 0;
for (var estg_i = 0; estg_i < array_length(global.fragmentos_vitral); estg_i++) {
    if (global.fragmentos_vitral[estg_i]) {
        estg_total++;
    }
}

if (
    perto_do_fragmento
    && !coletando
    && !global.jogo_pausado
    && !global.dialogue_open
) {
    var estg_cx = display_get_gui_width() / 2;
    var estg_cy = display_get_gui_height() - 120;
    var estg_w = tem_oferenda ? 620 : 440;
    var estg_x1 = estg_cx - estg_w / 2;
    var estg_y1 = estg_cy - 35;
    var estg_x2 = estg_cx + estg_w / 2;
    var estg_y2 = estg_cy + 35;

    draw_set_alpha(0.18);
    draw_set_color(make_color_rgb(73, 70, 110));
    draw_roundrect(estg_x1 + 3, estg_y1 + 4, estg_x2 + 3, estg_y2 + 4, false);
    draw_set_alpha(0.99);
    draw_set_color(make_color_rgb(255, 249, 239));
    draw_roundrect(estg_x1, estg_y1, estg_x2, estg_y2, false);
    draw_set_alpha(0.90);
    draw_set_color(make_color_rgb(139, 122, 185));
    draw_roundrect(estg_x1, estg_y1, estg_x2, estg_y2, true);

    draw_set_alpha(0.96);
    draw_set_color(make_color_rgb(222, 211, 244));
    draw_roundrect(estg_x1 + 12, estg_y1 + 10, estg_x1 + 62, estg_y2 - 10, false);
    draw_set_alpha(0.86);
    draw_set_color(make_color_rgb(121, 105, 171));
    draw_roundrect(estg_x1 + 12, estg_y1 + 10, estg_x1 + 62, estg_y2 - 10, true);

    draw_set_alpha(1);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(76, 69, 119));
    draw_text_transformed(estg_x1 + 37, estg_cy, (variable_global_exists("mobile_mode") && global.mobile_mode) ? "!" : "E", 1.08, 1.08, 0);
    draw_set_color(make_color_rgb(57, 66, 107));
    var estg_texto_acao = "Examinar estátua";
    if (fragmento_liberado) {
        estg_texto_acao = "Observar estátua";
    }
    else if (tem_oferenda) {
        estg_texto_acao = "Oferecer " + global.oferendas_estatuas[indice_fragmento];
    }
    draw_text_transformed((estg_x1 + 68 + estg_x2) / 2, estg_cy,
        estg_texto_acao,
        0.88, 0.88, 0);
}

if (tempo_mensagem_estatua > 0) {
    var estg_msg_alpha = clamp(tempo_mensagem_estatua / 20, 0, 1);
    draw_set_alpha(estg_msg_alpha * 0.99);
    draw_set_color(make_color_rgb(255, 249, 239));
    draw_roundrect(230, 127, 1050, 243, false);
    draw_set_alpha(estg_msg_alpha * 0.86);
    draw_set_color(make_color_rgb(121, 111, 164));
    draw_roundrect(230, 127, 1050, 243, true);
    draw_set_alpha(estg_msg_alpha * 0.92);
    draw_set_color(make_color_rgb(220, 212, 244));
    draw_roundrect(490, 115, 790, 152, false);
    draw_set_alpha(estg_msg_alpha);
    draw_set_color(make_color_rgb(57, 66, 107));
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(640, 134, "ESTÁTUA DO VITRAL", 0.64, 0.64, 0);
    draw_text_ext_transformed(640, 173, mensagem_estatua, 30, 740, 0.84, 0.84, 0);
}

if (coletando) {
    var estg_coleta_alpha = clamp(tempo_coleta / 20, 0, 1);
    draw_set_alpha(estg_coleta_alpha * 0.92);
    draw_set_color(make_color_rgb(249, 244, 251));
    draw_roundrect(470, 164, 810, 222, false);
    draw_set_alpha(estg_coleta_alpha * 0.62);
    draw_set_color(make_color_rgb(121, 111, 164));
    draw_roundrect(470, 164, 810, 222, true);
    draw_set_alpha(estg_coleta_alpha);
    draw_set_color(make_color_rgb(57, 66, 107));
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(640, 193, "Fragmento libertado  " + string(estg_total) + " / 4");
}

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
