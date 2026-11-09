var lorun_desenho_y = y + lorun_flutuar_y;

var lorun_reduzir_movimento =
    variable_global_exists("config_reduzir_animacoes")
    && global.config_reduzir_animacoes;

var lorun_baixo_estimulo =
    variable_global_exists("config_baixo_estimulo")
    && global.config_baixo_estimulo;

var lorun_alto_contraste =
    variable_global_exists("config_contraste")
    && global.config_contraste >= 1;

var lorun_pulso = lorun_reduzir_movimento
    ? 0
    : sin(lorun_aura_tempo * 0.72);

var lorun_intensidade = lorun_baixo_estimulo ? 0.58 : 1;
var lorun_aura_largura = 82 * abs(image_xscale);
var lorun_aura_altura = 105 * abs(image_yscale);


// ─────────────────────────────────────────────
// AURA DE FLORESTA ENCANTADA
// ─────────────────────────────────────────────
gpu_set_blendmode(bm_add);

// Camadas transparentes produzem um brilho macio atrás da Lorun.
draw_set_color(make_color_rgb(130, 244, 198));
draw_set_alpha((0.055 + lorun_pulso * 0.010) * lorun_intensidade);
draw_ellipse(
    x - lorun_aura_largura * 1.28,
    lorun_desenho_y - lorun_aura_altura * 1.18,
    x + lorun_aura_largura * 1.28,
    lorun_desenho_y + lorun_aura_altura * 1.18,
    false
);

draw_set_color(make_color_rgb(185, 255, 222));
draw_set_alpha((0.085 + lorun_pulso * 0.015) * lorun_intensidade);
draw_ellipse(
    x - lorun_aura_largura,
    lorun_desenho_y - lorun_aura_altura,
    x + lorun_aura_largura,
    lorun_desenho_y + lorun_aura_altura,
    false
);

// Pequenas luzes de fada orbitam sem alterar a posição da personagem.
var lorun_luzes = lorun_reduzir_movimento ? 3 : 5;

for (var lorun_i = 0; lorun_i < lorun_luzes; lorun_i++) {
    var lorun_angulo =
        lorun_aura_tempo * (0.55 + lorun_i * 0.035)
        + lorun_i * 1.2566;

    var lorun_luz_x =
        x
        + cos(lorun_angulo)
        * lorun_aura_largura
        * (0.72 + (lorun_i mod 2) * 0.18);

    var lorun_luz_y =
        lorun_desenho_y
        + sin(lorun_angulo)
        * lorun_aura_altura
        * 0.72;

    var lorun_luz_tamanho = 2.5 + (lorun_i mod 2);

    draw_set_color(
        (lorun_i mod 2) == 0
        ? make_color_rgb(184, 255, 211)
        : make_color_rgb(224, 255, 176)
    );

    draw_set_alpha(0.16 * lorun_intensidade);
    draw_circle(
        lorun_luz_x,
        lorun_luz_y,
        lorun_luz_tamanho * 2.6,
        false
    );

    draw_set_alpha(0.76 * lorun_intensidade);
    draw_circle(
        lorun_luz_x,
        lorun_luz_y,
        lorun_luz_tamanho,
        false
    );
}

gpu_set_blendmode(bm_normal);


// ─────────────────────────────────────────────
// LORUN FLUTUANDO
// ─────────────────────────────────────────────
draw_set_alpha(1);
draw_set_color(c_white);
draw_sprite_ext(
    sprite_index,
    image_index,
    x,
    lorun_desenho_y,
    image_xscale,
    image_yscale,
    image_angle,
    image_blend,
    image_alpha
);


// ─────────────────────────────────────────────
// BOTÃO FOFO DE INTERAÇÃO
// Mantido no Draw normal para não ficar escondido sob o HUD e a moldura.
// ─────────────────────────────────────────────
if (
    pode_interagir
    && (etapa_conversa == 0 || etapa_conversa == 6)
    && !global.dialogue_open
    && !(variable_global_exists("jogo_pausado") && global.jogo_pausado)
) {
    var aviso_cx = x;
    var aviso_cy = bbox_top + lorun_flutuar_y - 34;
    var aviso_x1 = aviso_cx - 106;
    var aviso_y1 = aviso_cy - 23;
    var aviso_x2 = aviso_cx + 106;
    var aviso_y2 = aviso_cy + 23;

    draw_set_alpha(0.20);
    draw_set_color(make_color_rgb(35, 34, 65));
    draw_roundrect(aviso_x1 + 3, aviso_y1 + 4, aviso_x2 + 3, aviso_y2 + 4, false);
    draw_set_alpha(0.96);
    draw_set_color(lorun_alto_contraste ? c_white : make_color_rgb(249, 244, 251));
    draw_roundrect(aviso_x1, aviso_y1, aviso_x2, aviso_y2, false);
    draw_set_alpha(0.80);
    draw_set_color(lorun_alto_contraste
        ? make_color_rgb(43, 34, 79)
        : make_color_rgb(139, 122, 185));
    draw_roundrect(aviso_x1, aviso_y1, aviso_x2, aviso_y2, true);

    draw_set_alpha(0.98);
    draw_set_color(make_color_rgb(225, 216, 245));
    draw_roundrect(aviso_x1 + 9, aviso_y1 + 7, aviso_x1 + 49, aviso_y2 - 7, false);
    draw_set_color(make_color_rgb(121, 105, 171));
    draw_roundrect(aviso_x1 + 9, aviso_y1 + 7, aviso_x1 + 49, aviso_y2 - 7, true);

    draw_set_alpha(1);
    draw_set_font(fnt_dialogo);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(lorun_alto_contraste
        ? make_color_rgb(20, 20, 32)
        : make_color_rgb(76, 69, 119));
    draw_text(aviso_x1 + 29, aviso_cy, (variable_global_exists("mobile_mode") && global.mobile_mode) ? "!" : "E");
    draw_set_color(lorun_alto_contraste
        ? make_color_rgb(20, 20, 32)
        : make_color_rgb(64, 67, 101));
    draw_text((aviso_x1 + 54 + aviso_x2) * 0.5, aviso_cy, "Interagir");

    draw_set_alpha(0.78);
    draw_set_color(make_color_rgb(238, 196, 222));
    draw_circle(aviso_x2 - 12, aviso_y1 + 10, 3, false);
    draw_set_color(make_color_rgb(191, 235, 220));
    draw_circle(aviso_x2 - 8, aviso_y1 + 18, 2, false);
}


// Restaurar o estado de desenho para os próximos objetos.
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
gpu_set_blendmode(bm_normal);
