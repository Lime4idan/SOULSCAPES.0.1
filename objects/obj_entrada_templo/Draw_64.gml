if (!pode_interagir) {
    exit;
}


// Esconder durante pausa
if (
    variable_global_exists("jogo_pausado")
    && global.jogo_pausado
) {
    exit;
}


// Esconder durante diálogo
if (
    variable_global_exists("dialogue_open")
    && global.dialogue_open
) {
    exit;
}


var entrada_liberada =
    variable_global_exists("fragmento_reconhecido")
    && global.fragmento_reconhecido;


var texto_interacao;

if (entrada_liberada) {
    texto_interacao = "E  Entrar no templo";
}
else {
    texto_interacao = "E  Examinar entrada";
}


var centro_x = 640;
var centro_y = 735;

var largura = 290;
var altura = 52;


// Fundo
draw_set_alpha(0.88);
draw_set_color(
    make_color_rgb(229, 231, 241)
);

draw_roundrect(
    centro_x - largura / 2,
    centro_y - altura / 2,
    centro_x + largura / 2,
    centro_y + altura / 2,
    false
);


// Borda
draw_set_alpha(0.62);
draw_set_color(
    make_color_rgb(91, 105, 137)
);

draw_roundrect(
    centro_x - largura / 2,
    centro_y - altura / 2,
    centro_x + largura / 2,
    centro_y + altura / 2,
    true
);


// Texto
draw_set_alpha(1);
draw_set_color(
    make_color_rgb(55, 65, 95)
);

draw_set_font(fnt_dialogo);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_text(
    centro_x,
    centro_y,
    texto_interacao
);


// Restaurar
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);