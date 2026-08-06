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
    draw_set_alpha(0.88);

    draw_set_color(
        make_color_rgb(229, 231, 241)
    );

    draw_roundrect(
        490,
        705,
        790,
        757,
        false
    );


    draw_set_alpha(0.60);

    draw_set_color(
        make_color_rgb(91, 105, 137)
    );

    draw_roundrect(
        490,
        705,
        790,
        757,
        true
    );


    draw_set_alpha(1);

    draw_set_color(
        make_color_rgb(55, 65, 95)
    );

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_text(
        640,
        731,
        "E  Coletar fragmento"
    );
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
        "Fragmento encontrado  "
        + string(total_coletado)
        + " / 4"
    );
}


// Restaurar
draw_set_alpha(1);
draw_set_color(c_white);

draw_set_halign(fa_left);
draw_set_valign(fa_top);