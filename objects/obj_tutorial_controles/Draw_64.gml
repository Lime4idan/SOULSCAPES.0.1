draw_set_font(fnt_dialogo);

var painel_x1 = 30;
var painel_y1 = 30;
var painel_x2 = 460;
var painel_y2 = 258;

var cor_painel = make_color_rgb(239, 238, 247);
var cor_borda = make_color_rgb(99, 105, 159);
var cor_texto = make_color_rgb(56, 64, 101);
var cor_titulo = make_color_rgb(75, 83, 136);


// ─────────────────────────────────────────────
// PAINEL
// ─────────────────────────────────────────────

// Sombra suave
draw_set_alpha(0.12 * alpha_controles);
draw_set_color(cor_borda);

draw_roundrect(
    painel_x1 + 5,
    painel_y1 + 6,
    painel_x2 + 5,
    painel_y2 + 6,
    false
);

// Fundo
draw_set_alpha(0.88 * alpha_controles);
draw_set_color(cor_painel);

draw_roundrect(
    painel_x1,
    painel_y1,
    painel_x2,
    painel_y2,
    false
);

// Borda
draw_set_alpha(0.65 * alpha_controles);
draw_set_color(cor_borda);

draw_roundrect(
    painel_x1,
    painel_y1,
    painel_x2,
    painel_y2,
    true
);


// ─────────────────────────────────────────────
// TÍTULO
// ─────────────────────────────────────────────
draw_set_alpha(alpha_controles);
draw_set_color(cor_titulo);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);

draw_text_transformed(
    55,
    58,
    "Controles",
    1.18,
    1.18,
    0
);


// ─────────────────────────────────────────────
// MOVER
// ─────────────────────────────────────────────
desenhar_tecla(55, 82, "A", 34);
desenhar_tecla(95, 82, "D", 34);

draw_set_alpha(alpha_controles);
draw_set_color(cor_texto);
draw_set_halign(fa_left);

draw_text(
    150,
    97,
    "Mover  (ou setas)"
);


// ─────────────────────────────────────────────
// CORRER
// ─────────────────────────────────────────────
desenhar_tecla(55, 118, "Shift", 74);

draw_set_alpha(alpha_controles);
draw_set_color(cor_texto);
draw_set_halign(fa_left);

draw_text(
    150,
    133,
    "Correr"
);


// ─────────────────────────────────────────────
// PULAR
// ─────────────────────────────────────────────
desenhar_tecla(55, 154, "Z", 34);
desenhar_tecla(95, 154, "X", 34);

draw_set_alpha(alpha_controles);
draw_set_color(cor_texto);
draw_set_halign(fa_left);

draw_text(
    150,
    169,
    "Pular"
);


// ─────────────────────────────────────────────
// INTERAGIR
// ─────────────────────────────────────────────
desenhar_tecla(55, 190, "E", 34);

draw_set_alpha(alpha_controles);
draw_set_color(cor_texto);
draw_set_halign(fa_left);

draw_text(
    150,
    205,
    "Interagir"
);


// ─────────────────────────────────────────────
// AVANÇAR DIÁLOGO
// ─────────────────────────────────────────────
desenhar_tecla(260, 190, "Espaço", 94);

draw_set_alpha(alpha_controles);
draw_set_color(cor_texto);
draw_set_halign(fa_left);

draw_text(
    365,
    205,
    "Avançar"
);


// Restaurar desenho
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);