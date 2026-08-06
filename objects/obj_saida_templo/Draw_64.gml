if (!pode_sair) {
    exit;
}

var pausa_aberta =
    variable_global_exists("jogo_pausado")
    && global.jogo_pausado;

var dialogo_aberto =
    variable_global_exists("dialogue_open")
    && global.dialogue_open;

if (pausa_aberta || dialogo_aberto) {
    exit;
}


draw_set_font(fnt_dialogo);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);


// Fundo
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


// Borda
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


// Texto
draw_set_alpha(1);
draw_set_color(
    make_color_rgb(55, 65, 95)
);

draw_text(
    640,
    731,
    "E  Sair do templo"
);


// Restaurar
draw_set_alpha(1);
draw_set_color(c_white);

draw_set_halign(fa_left);
draw_set_valign(fa_top);