// Moldura de tela: acompanha a GUI, não a câmera.
// Menus de tela cheia usam global.jogo_pausado e escondem a moldura.
if (
    variable_global_exists("jogo_pausado")
    && global.jogo_pausado
) {
    exit;
}

var moldura_gui_w = display_get_gui_width();
var moldura_gui_h = display_get_gui_height();

draw_set_alpha(0.85);
draw_set_color(c_white);
draw_sprite_stretched(
    spr_moldura_jogo,
    0,
    -18,
    -12,
    moldura_gui_w + 36,
    moldura_gui_h + 24
);

draw_set_alpha(1);
draw_set_color(c_white);

// ─────────────────────────────────────────────────────────────────────────────
// HUD MOBILE
// Fica neste Draw GUI para ser renderizado depois da própria moldura. Assim os
// controles permanecem acima dos ornamentos e dentro da área útil da cena.
// ─────────────────────────────────────────────────────────────────────────────
var moldura_mobile = variable_global_exists("mobile_mode") && global.mobile_mode;

if (variable_global_exists("dialogue_open") && global.dialogue_open) exit;

// Os três atalhos superiores usam as ilustrações em aquarela do próprio jogo.
// A geometria é compartilhada com o Step de obj_pause para que a arte e a área
// clicável permaneçam perfeitamente alinhadas no desktop e no mobile.
// Compactos para não competir com o HUD de vida nem cobrir a paisagem.
var atalhos_y1 = 82;
var atalhos_y2 = 148;
var atalhos_largura = 128;
var atalhos_gap = 6;
var atalhos_direita = moldura_gui_w - 60;
var menu_x2 = atalhos_direita;
var menu_x1 = menu_x2 - atalhos_largura;
var ajustes_x2 = menu_x1 - atalhos_gap;
var ajustes_x1 = ajustes_x2 - atalhos_largura;
var bolsa_x2 = ajustes_x1 - atalhos_gap;
var bolsa_x1 = bolsa_x2 - atalhos_largura;

var desenhar_atalho_arte = function(
    _sx,
    _sy,
    _sw,
    _sh,
    _x1,
    _y1,
    _x2,
    _y2,
    _realce,
    _pressionado
) {
    var _off_y = _pressionado ? 2 : 0;
    var _expande = _realce ? 2 : 0;

    draw_set_alpha(_realce ? 0.22 : 0.12);
    draw_set_color(make_color_rgb(41, 46, 73));
    draw_roundrect(
        _x1 + 3 - _expande,
        _y1 + 6 + _off_y - _expande,
        _x2 + 3 + _expande,
        _y2 + 6 + _off_y + _expande,
        false
    );

    draw_set_alpha(_pressionado ? 0.88 : 1);
    draw_set_color(c_white);
    draw_sprite_part_ext(
        Sprite16,
        0,
        _sx,
        _sy,
        _sw,
        _sh,
        _x1 - _expande,
        _y1 + _off_y - _expande,
        ((_x2 - _x1) + (_expande * 2)) / _sw,
        ((_y2 - _y1) + (_expande * 2)) / _sh,
        c_white,
        _pressionado ? 0.88 : 1
    );
};

if (!moldura_mobile) {
    var desktop_mouse_x = device_mouse_x_to_gui(0);
    var desktop_mouse_y = device_mouse_y_to_gui(0);

    desenhar_atalho_arte(
        0, 0, 384, 200,
        bolsa_x1, atalhos_y1, bolsa_x2, atalhos_y2,
        point_in_rectangle(desktop_mouse_x, desktop_mouse_y, bolsa_x1, atalhos_y1, bolsa_x2, atalhos_y2),
        false
    );
    desenhar_atalho_arte(
        384, 0, 384, 200,
        ajustes_x1, atalhos_y1, ajustes_x2, atalhos_y2,
        point_in_rectangle(desktop_mouse_x, desktop_mouse_y, ajustes_x1, atalhos_y1, ajustes_x2, atalhos_y2),
        false
    );



    desenhar_atalho_arte(
        768, 0, 384, 200,
        menu_x1, atalhos_y1, menu_x2, atalhos_y2,
        point_in_rectangle(desktop_mouse_x, desktop_mouse_y, menu_x1, atalhos_y1, menu_x2, atalhos_y2),
        false
    );

    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(-1);
    exit;
}

var mobile_em_retrato = variable_global_exists("mobile_browser")
    && global.mobile_browser
        ? browser_width < browser_height
        : display_get_width() < display_get_height();

if (mobile_em_retrato) {
    draw_set_alpha(0.95);
    draw_set_color(make_color_rgb(30, 42, 67));
    draw_rectangle(0, 0, moldura_gui_w, moldura_gui_h, false);

    draw_set_alpha(1);
    draw_set_font(fnt_dialogo);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(250, 246, 239));
    draw_text_transformed(
        moldura_gui_w * 0.5,
        moldura_gui_h * 0.45,
        "Gire o celular para jogar",
        1.35,
        1.35,
        0
    );
    draw_set_color(make_color_rgb(194, 222, 215));
    draw_text(
        moldura_gui_w * 0.5,
        moldura_gui_h * 0.54,
        "Soulscapes foi criado para a tela horizontal."
    );

    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(-1);
    exit;
}

var controls_y1 = moldura_gui_h - 242;
var controls_y2 = moldura_gui_h - 128;
var controls_mid_y = (controls_y1 + controls_y2) * 0.5;
var left_x1 = 54;
var left_x2 = 176;
var right_x1 = 176;
var right_x2 = 298;
var action_x1 = moldura_gui_w - 412;
var action_x2 = moldura_gui_w - 218;
var jump_x1 = moldura_gui_w - 204;
var jump_x2 = moldura_gui_w - 30;

var cor_tinta = make_color_rgb(51, 58, 91);
var cor_borda = make_color_rgb(116, 111, 171);
var cor_papel = make_color_rgb(246, 243, 248);
var cor_menta = make_color_rgb(190, 230, 215);
var cor_rosa = make_color_rgb(239, 202, 222);
var cor_sombra = make_color_rgb(31, 37, 60);

var desenhar_capsula_mobile = function(
    _x1,
    _y1,
    _x2,
    _y2,
    _pressionado,
    _cor_fundo,
    _cor_sombra,
    _cor_borda
) {
    var _off = _pressionado ? 3 : 0;

    draw_set_alpha(0.20);
    draw_set_color(_cor_sombra);
    draw_roundrect(_x1 + 3, _y1 + 7, _x2 + 3, _y2 + 7, false);

    draw_set_alpha(_pressionado ? 0.98 : 0.92);
    draw_set_color(_cor_fundo);
    draw_roundrect(_x1, _y1 + _off, _x2, _y2 + _off, false);

    draw_set_alpha(0.96);
    draw_set_color(_cor_borda);
    draw_roundrect(_x1, _y1 + _off, _x2, _y2 + _off, true);

    return _off;
};

// Movimento: uma única peça, dividida em duas áreas táteis bem grandes.
var move_off = desenhar_capsula_mobile(
    left_x1,
    controls_y1,
    right_x2,
    controls_y2,
    global.mobile_left || global.mobile_right,
    cor_papel,
    cor_sombra,
    cor_borda
);

draw_set_alpha(0.42);
draw_set_color(cor_borda);
draw_line(left_x2, controls_y1 + 14, left_x2, controls_y2 - 14);

draw_set_alpha(1);
draw_set_color(cor_tinta);
draw_line_width(left_x1 + 60, controls_mid_y + move_off, left_x1 + 43, controls_mid_y + move_off, 4);
draw_line_width(left_x1 + 43, controls_mid_y + move_off, left_x1 + 54, controls_mid_y - 11 + move_off, 4);
draw_line_width(left_x1 + 43, controls_mid_y + move_off, left_x1 + 54, controls_mid_y + 11 + move_off, 4);
draw_line_width(right_x1 + 38, controls_mid_y + move_off, right_x1 + 55, controls_mid_y + move_off, 4);
draw_line_width(right_x1 + 55, controls_mid_y + move_off, right_x1 + 44, controls_mid_y - 11 + move_off, 4);
draw_line_width(right_x1 + 55, controls_mid_y + move_off, right_x1 + 44, controls_mid_y + 11 + move_off, 4);

// Ações: cores e silhuetas distintas facilitam o reconhecimento periférico.
var action_off = desenhar_capsula_mobile(
    action_x1,
    controls_y1,
    action_x2,
    controls_y2,
    global.mobile_interact_pressed,
    cor_menta,
    cor_sombra,
    cor_borda
);
var jump_off = desenhar_capsula_mobile(
    jump_x1,
    controls_y1,
    jump_x2,
    controls_y2,
    global.mobile_jump,
    cor_rosa,
    cor_sombra,
    cor_borda
);

draw_set_font(fnt_dialogo);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_alpha(1);
draw_set_color(cor_tinta);
draw_text((action_x1 + action_x2) * 0.5, controls_mid_y - 7 + action_off, "INTERAGIR");
draw_set_alpha(0.72);
draw_text_transformed((action_x1 + action_x2) * 0.5, controls_mid_y + 18 + action_off, "AÇÃO", 0.72, 0.72, 0);
draw_set_alpha(1);
draw_text((jump_x1 + jump_x2) * 0.5, controls_mid_y - 7 + jump_off, "PULAR");
draw_set_alpha(0.72);
draw_text_transformed((jump_x1 + jump_x2) * 0.5, controls_mid_y + 18 + jump_off, "MOVIMENTO", 0.72, 0.72, 0);

// Atalhos táteis: a mesma arte e as mesmas áreas usadas no desktop.
desenhar_atalho_arte(
    0, 0, 384, 200,
    bolsa_x1, atalhos_y1, bolsa_x2, atalhos_y2,
    false,
    global.mobile_inventory_pressed
);
desenhar_atalho_arte(
    384, 0, 384, 200,
    ajustes_x1, atalhos_y1, ajustes_x2, atalhos_y2,
    false,
    global.mobile_settings_pressed
);
desenhar_atalho_arte(
    768, 0, 384, 200,
    menu_x1, atalhos_y1, menu_x2, atalhos_y2,
    false,
    global.mobile_pause_pressed
);

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
