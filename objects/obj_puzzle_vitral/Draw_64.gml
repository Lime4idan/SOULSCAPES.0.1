draw_set_font(fnt_dialogo);

// ═════════════════════════════════════════════
// GARANTIR INVENTÁRIO
// ═════════════════════════════════════════════
if (!variable_global_exists("fragmentos_vitral")) {
    global.fragmentos_vitral = [false, false, false, false];
}


// ═════════════════════════════════════════════
// AVISO PARA EXAMINAR
// ═════════════════════════════════════════════
if (perto_do_vitral && !puzzle_ativo && !global.vitral_resolvido) {
    var pausa_aberta =
        variable_global_exists("jogo_pausado")
        && global.jogo_pausado;

    var dialogo_aberto =
        variable_global_exists("dialogue_open")
        && global.dialogue_open;

    if (!pausa_aberta && !dialogo_aberto) {
        draw_set_alpha(0.88);
        draw_set_color(make_color_rgb(229, 231, 241));
        draw_roundrect(470, 705, 810, 757, false);

        draw_set_alpha(0.60);
        draw_set_color(make_color_rgb(91, 105, 137));
        draw_roundrect(470, 705, 810, 757, true);

        draw_set_alpha(1);
        draw_set_color(make_color_rgb(55, 65, 95));
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(640, 731, "E  Examinar vitral");
    }
}


// ═════════════════════════════════════════════
// SE O PUZZLE NÃO ESTÁ ABERTO, ENCERRA
// ═════════════════════════════════════════════
if (!puzzle_ativo) {
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    exit;
}


// ═════════════════════════════════════════════
// PALETA
// ═════════════════════════════════════════════
var cor_overlay      = make_color_rgb(28, 40, 60);
var cor_painel       = make_color_rgb(232, 235, 243);
var cor_painel2      = make_color_rgb(244, 246, 250);
var cor_borda        = make_color_rgb(102, 117, 152);
var cor_borda_clara  = make_color_rgb(180, 191, 218);
var cor_texto        = make_color_rgb(60, 70, 98);
var cor_texto_suave  = make_color_rgb(115, 126, 152);
var cor_luz          = make_color_rgb(197, 219, 231);
var cor_central      = make_color_rgb(141, 205, 204);


// ═════════════════════════════════════════════
// CONTAGEM
// ═════════════════════════════════════════════
var cacos_encontrados = 0;

for (var contar_i = 0; contar_i < array_length(global.fragmentos_vitral); contar_i++) {
    if (global.fragmentos_vitral[contar_i]) {
        cacos_encontrados++;
    }
}

var fragmentos_totais_restaurados = 1 + cacos_encontrados; // 1 central + 4 extras
var total_fragmentos = 5;


// ═════════════════════════════════════════════
// FUNDO ESCURO
// ═════════════════════════════════════════════
draw_set_alpha(0.76);
draw_set_color(cor_overlay);
draw_rectangle(0, 0, 1280, 811, false);


// ═════════════════════════════════════════════
// PAINEL PRINCIPAL
// ═════════════════════════════════════════════
draw_set_alpha(0.96);
draw_set_color(cor_painel);
draw_roundrect(120, 42, 1160, 769, false);

draw_set_alpha(0.38);
draw_set_color(cor_painel2);
draw_roundrect(136, 58, 1144, 753, false);

draw_set_alpha(0.58);
draw_set_color(cor_borda_clara);
draw_roundrect(136, 58, 1144, 753, true);

draw_set_alpha(0.30);
draw_set_color(cor_borda);
draw_roundrect(120, 42, 1160, 769, true);


// ═════════════════════════════════════════════
// TÍTULO
// ═════════════════════════════════════════════
draw_set_alpha(1);
draw_set_color(cor_texto);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_text_transformed(640, 95, "Vitral da Memória", 1.35, 1.35, 0);

draw_set_alpha(0.72);
draw_set_color(cor_texto_suave);
draw_text(640, 140, "Fragmento central restaurado");

draw_set_alpha(0.62);
draw_text(640, 176, "Cacos encontrados: " + string(cacos_encontrados) + " / 4");

draw_set_alpha(0.72);
draw_set_color(cor_borda_clara);
draw_line_width(390, 205, 890, 205, 1);


// ═════════════════════════════════════════════
// BRILHO ATRÁS DO VITRAL
// ═════════════════════════════════════════════
var pulso = sin(tempo_puzzle) * 4;

draw_set_alpha(0.08);
draw_set_color(cor_luz);
draw_circle(640, 410, 220 + pulso, false);

draw_set_alpha(0.05);
draw_circle(640, 410, 255 + pulso, false);


// ═════════════════════════════════════════════
// MOLDURA EXTERNA DO VITRAL (ARCO GÓTICO)
// ═════════════════════════════════════════════
draw_set_alpha(0.28);
draw_set_color(make_color_rgb(210, 220, 238));
draw_triangle(640, 118, 430, 255, 850, 255, false);
draw_rectangle(430, 255, 850, 585, false);

draw_set_alpha(0.82);
draw_set_color(cor_borda);
draw_line_width(430, 255, 640, 118, 5);
draw_line_width(850, 255, 640, 118, 5);
draw_line_width(430, 255, 430, 585, 5);
draw_line_width(850, 255, 850, 585, 5);
draw_line_width(430, 585, 850, 585, 5);


// ═════════════════════════════════════════════
// MOLDURA INTERNA
// ═════════════════════════════════════════════
draw_set_alpha(0.44);
draw_set_color(c_white);
draw_triangle(640, 152, 462, 268, 818, 268, false);
draw_rectangle(462, 268, 818, 555, false);

draw_set_alpha(0.70);
draw_set_color(cor_borda_clara);
draw_line_width(462, 268, 640, 152, 2);
draw_line_width(818, 268, 640, 152, 2);
draw_line_width(462, 268, 462, 555, 2);
draw_line_width(818, 268, 818, 555, 2);
draw_line_width(462, 555, 818, 555, 2);


// ═════════════════════════════════════════════
// TRAÇOS INTERNOS DO VITRAL
// ═════════════════════════════════════════════
draw_set_alpha(0.42);
draw_set_color(cor_borda_clara);

// linha vertical central
draw_line_width(640, 152, 640, 555, 2);

// cruz horizontal
draw_line_width(462, 410, 818, 410, 2);

// diagonais até as peças
draw_line_width(640, 410, peca_alvo_x[0], peca_alvo_y[0], 2);
draw_line_width(640, 410, peca_alvo_x[1], peca_alvo_y[1], 2);
draw_line_width(640, 410, peca_alvo_x[2], peca_alvo_y[2], 2);
draw_line_width(640, 410, peca_alvo_x[3], peca_alvo_y[3], 2);


// ═════════════════════════════════════════════
// ROSÁCEA / CENTRO
// ═════════════════════════════════════════════
draw_set_alpha(0.10);
draw_set_color(cor_central);
draw_circle(640, 410, 78 + pulso, false);

draw_set_alpha(0.18);
draw_circle(640, 410, 54, false);


// ═════════════════════════════════════════════
// SILHUETAS DOS ENCAIXES
// ═════════════════════════════════════════════
for (var slot_i = 0; slot_i < array_length(peca_colocada); slot_i++) {
    if (!peca_colocada[slot_i]) {
        desenhar_fragmento(
            slot_i,
            peca_alvo_x[slot_i],
            peca_alvo_y[slot_i],
            cor_borda_clara,
            0.10,
            cor_borda,
            0.28
        );
    }
}


// ═════════════════════════════════════════════
// FRAGMENTO CENTRAL FIXO
// ═════════════════════════════════════════════
draw_set_alpha(0.92);
draw_set_color(cor_central);

draw_triangle(640, 348, 692, 410, 640, 472, false);
draw_triangle(640, 348, 588, 410, 640, 472, false);

draw_set_alpha(0.74);
draw_set_color(cor_borda);
draw_line_width(640, 348, 692, 410, 2);
draw_line_width(692, 410, 640, 472, 2);
draw_line_width(640, 472, 588, 410, 2);
draw_line_width(588, 410, 640, 348, 2);

draw_set_alpha(0.30);
draw_set_color(c_white);
draw_line_width(620, 390, 650, 430, 2);


// ═════════════════════════════════════════════
// PEÇAS DISPONÍVEIS / NÃO ENCONTRADAS
// ═════════════════════════════════════════════
for (var peca_i = 0; peca_i < array_length(peca_colocada); peca_i++) {
    var encontrou = global.fragmentos_vitral[peca_i];

    // base suave atrás da peça
    draw_set_alpha(0.10);
    draw_set_color(cor_luz);
    draw_circle(peca_inicio_x[peca_i], peca_inicio_y[peca_i], 70, false);

    draw_set_alpha(0.36);
    draw_set_color(cor_borda_clara);
    draw_circle(peca_inicio_x[peca_i], peca_inicio_y[peca_i], 50, true);

    if (encontrou) {
        var sendo_arrastada = (peca_i == peca_arrastada);
        var encaixada = peca_colocada[peca_i];

        if (sendo_arrastada || encaixada) {
            draw_set_alpha(0.10);
            draw_set_color(cores_fragmentos[peca_i]);
            draw_circle(
                peca_x[peca_i],
                peca_y[peca_i],
                sendo_arrastada ? 76 : 66,
                false
            );
        }

        desenhar_fragmento(
            peca_i,
            peca_x[peca_i],
            peca_y[peca_i],
            cores_fragmentos[peca_i],
            sendo_arrastada ? 1 : 0.92,
            cor_borda,
            encaixada ? 0.88 : 0.68
        );

        draw_set_alpha(0.58);
        draw_set_color(cor_texto_suave);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(peca_inicio_x[peca_i], peca_inicio_y[peca_i] + 72, "Encontrado");
    }
    else {
        draw_set_alpha(0.30);
        draw_set_color(cor_texto_suave);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text_transformed(
            peca_inicio_x[peca_i],
            peca_inicio_y[peca_i] - 2,
            "?",
            1.35,
            1.35,
            0
        );

        draw_set_alpha(0.42);
        draw_text(peca_inicio_x[peca_i], peca_inicio_y[peca_i] + 72, "Não encontrado");
    }
}


// ═════════════════════════════════════════════
// STATUS INFERIOR
// ═════════════════════════════════════════════
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

if (concluindo_puzzle) {
    draw_set_alpha(1);
    draw_set_color(cor_texto);
    draw_text_transformed(640, 682, "A memória desperta...", 1.12, 1.12, 0);

    draw_set_alpha(0.75);
    draw_text(640, 720, "Vitral completo: 5 / 5");
}
else if (cacos_encontrados < 4) {
    draw_set_alpha(0.82);
    draw_set_color(cor_texto);
    draw_text(640, 676, "Ainda existem fragmentos espalhados pela floresta.");

    draw_set_alpha(0.62);
    draw_set_color(cor_texto_suave);
    draw_text(640, 712, "Vitral completo: " + string(fragmentos_totais_restaurados) + " / 5");

    draw_set_alpha(0.42);
    draw_text(640, 742, "Esc  sair");
}
else {
    draw_set_alpha(0.82);
    draw_set_color(cor_texto);
    draw_text(640, 676, "Arraste cada caco até sua silhueta no vitral.");

    draw_set_alpha(0.62);
    draw_set_color(cor_texto_suave);
    draw_text(640, 712, "Vitral completo: " + string(fragmentos_totais_restaurados) + " / 5");

    draw_set_alpha(0.42);
    draw_text(640, 742, "Esc  sair");
}


// ═════════════════════════════════════════════
// RESTAURAR ESTADO DE DESENHO
// ═════════════════════════════════════════════
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);