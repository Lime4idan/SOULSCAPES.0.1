// Não disputar espaço com o menu de pausa.
if (
    variable_global_exists("jogo_pausado")
    && global.jogo_pausado
) {
    exit;
}

// Mantém o tutorial dentro da abertura útil da moldura.
var tutorial_matrix_anterior = matrix_get(matrix_world);
matrix_set(
    matrix_world,
    matrix_build(42, 60, 0, 0, 0, 0, 1, 1, 1)
);

draw_set_font(fnt_dialogo);

var tutorial_alto_contraste =
    variable_global_exists("config_contraste")
    && global.config_contraste >= 1;

var tutorial_baixo_estimulo =
    variable_global_exists("config_baixo_estimulo")
    && global.config_baixo_estimulo;

var tutorial_decoracao = tutorial_baixo_estimulo ? 0.35 : 1;
var tutorial_mobile =
    variable_global_exists("mobile_mode")
    && global.mobile_mode;

var painel_x1 = 28;
var painel_y1 = 28;
var painel_x2 = 510;
var painel_y2 = 398;

var cor_painel = tutorial_alto_contraste ? c_white : make_color_rgb(246, 243, 250);
var cor_borda = tutorial_alto_contraste ? make_color_rgb(43, 34, 79) : make_color_rgb(119, 113, 173);
var cor_texto = tutorial_alto_contraste ? make_color_rgb(18, 20, 31) : make_color_rgb(61, 67, 104);
var cor_titulo = tutorial_alto_contraste ? make_color_rgb(38, 29, 73) : make_color_rgb(89, 82, 144);
var cor_menta = make_color_rgb(203, 239, 226);
var cor_rosa = make_color_rgb(239, 205, 226);
var cor_lilas = make_color_rgb(221, 213, 244);
var cor_azul = make_color_rgb(211, 230, 247);


// ─────────────────────────────────────────────
// PAINEL
// ─────────────────────────────────────────────
draw_set_alpha(0.14 * alpha_controles);
draw_set_color(cor_borda);
draw_roundrect(
    painel_x1 + 5,
    painel_y1 + 6,
    painel_x2 + 5,
    painel_y2 + 6,
    false
);

draw_set_alpha(0.94 * alpha_controles);
draw_set_color(cor_painel);
draw_roundrect(
    painel_x1,
    painel_y1,
    painel_x2,
    painel_y2,
    false
);

draw_set_alpha(0.68 * alpha_controles);
draw_set_color(cor_borda);
draw_roundrect(
    painel_x1,
    painel_y1,
    painel_x2,
    painel_y2,
    true
);

// Confetes pastel deixam o cartão delicado sem atrapalhar a leitura.
draw_set_alpha(0.72 * alpha_controles * tutorial_decoracao);
draw_set_color(cor_rosa);
draw_circle(469, 55, 6, false);
draw_circle(451, 46, 3, false);
draw_set_color(cor_menta);
draw_circle(484, 72, 4, false);
draw_set_color(cor_azul);
draw_circle(462, 78, 3, false);

// Dois brilhinhos simples, compatíveis com a fonte e com qualquer plataforma.
draw_set_color(cor_lilas);
draw_line(42, 48, 42, 64);
draw_line(34, 56, 50, 56);
draw_set_color(cor_rosa);
draw_line(39, 372, 39, 386);
draw_line(32, 379, 46, 379);


// ─────────────────────────────────────────────
// TÍTULO
// ─────────────────────────────────────────────
draw_set_alpha(alpha_controles);
draw_set_color(cor_titulo);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_text_transformed(
    62,
    57,
    "Primeiros passos",
    1.16,
    1.16,
    0
);


// ─────────────────────────────────────────────
// CONTROLES PRINCIPAIS
// ─────────────────────────────────────────────
// Faixas alternadas ajudam a separar cada ação visualmente.
draw_set_alpha(0.34 * alpha_controles);
draw_set_color(cor_azul);
draw_roundrect(46, 80, 492, 116, false);
draw_set_color(cor_lilas);
draw_roundrect(46, 118, 492, 154, false);
draw_set_color(cor_rosa);
draw_roundrect(46, 156, 492, 192, false);
draw_set_color(cor_menta);
draw_roundrect(46, 194, 492, 230, false);
draw_set_color(cor_azul);
draw_roundrect(46, 232, 492, 268, false);
draw_set_color(cor_lilas);
draw_roundrect(46, 270, 492, 306, false);

if (tutorial_mobile) {
    desenhar_tecla(54, 83, "<  >", 82);
    draw_set_alpha(alpha_controles);
    draw_set_color(cor_texto);
    draw_set_halign(fa_left);
    draw_text(166, 98, "Mover");

    desenhar_tecla(54, 121, "Segure", 82);
    draw_set_color(cor_texto);
    draw_text(166, 136, "Correr");

    desenhar_tecla(54, 159, "Pular", 82);
    draw_set_color(cor_texto);
    draw_text(166, 174, "Pular");

    desenhar_tecla(54, 197, "Ação", 82);
    draw_set_color(cor_texto);
    draw_text(166, 212, "Interagir");

    desenhar_tecla(54, 235, "Menu", 82);
    draw_set_color(cor_texto);
    draw_text(166, 250, "Inventário e pausa");

    desenhar_tecla(54, 273, "Toque", 82);
    draw_set_color(cor_texto);
    draw_text(166, 288, "Escolher / confirmar");
}
else {
    desenhar_tecla(54, 83, "A", 34);
    desenhar_tecla(94, 83, "D", 34);

    draw_set_alpha(alpha_controles);
    draw_set_color(cor_texto);
    draw_set_halign(fa_left);
    draw_text(166, 98, "Mover  (ou setas)");

    desenhar_tecla(54, 121, "Shift", 74);
    draw_set_color(cor_texto);
    draw_text(166, 136, "Correr");

    desenhar_tecla(54, 159, "Espaço", 94);
    draw_set_color(cor_texto);
    draw_text(166, 174, "Pular / avançar / confirmar");

    desenhar_tecla(54, 197, "E", 34);
    draw_set_color(cor_texto);
    draw_text(166, 212, "Interagir");

    desenhar_tecla(54, 235, "Tab", 58);
    draw_set_color(cor_texto);
    draw_text(166, 250, "Abrir inventário");

    desenhar_tecla(54, 273, "Esc", 58);
    draw_set_color(cor_texto);
    draw_text(166, 288, "Pausar / voltar");
}


// ─────────────────────────────────────────────
// PAUSA SENSORIAL
// ─────────────────────────────────────────────
draw_set_alpha(0.78 * alpha_controles);
draw_set_color(cor_menta);
draw_roundrect(46, 316, 492, 368, false);

draw_set_alpha(0.52 * alpha_controles);
draw_set_color(cor_borda);
draw_roundrect(46, 316, 492, 368, true);

draw_set_alpha(alpha_controles);
draw_set_color(cor_titulo);
draw_set_halign(fa_center);
draw_text(
    269,
    332,
    tutorial_mobile
        ? "Precisa respirar?  Menu  >  Pausa sensorial"
        : "Precisa respirar?  Esc  >  Pausa sensorial"
);

draw_set_alpha(0.72 * alpha_controles);
draw_set_color(cor_texto);
draw_text_transformed(
    269,
    353,
    "O jogo fica parado enquanto você acompanha a respiração.",
    0.78,
    0.78,
    0
);

draw_set_alpha(0.65 * alpha_controles);
draw_set_halign(fa_right);
draw_text_transformed(
    490,
    386,
    tutorial_mobile
        ? "Os controles aceitam vários dedos ao mesmo tempo."
        : "Alternativas: Z/X pulam  |  Return confirma",
    0.72,
    0.72,
    0
);


// Restaurar desenho
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
matrix_set(matrix_world, tutorial_matrix_anterior);
