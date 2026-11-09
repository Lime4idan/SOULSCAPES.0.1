// ─────────────────────────────────────────────────────────────────────────────
// CONTROLES MOBILE — desenhados na GUI para permanecerem fixos na tela.
// Durante diálogos, puzzles, batalhas e menus eles recuam e a própria interface
// passa a receber o toque diretamente.
// ─────────────────────────────────────────────────────────────────────────────
if (!variable_global_exists("mobile_mode") || !global.mobile_mode) exit;

// A moldura é desenhada depois de Kiran. Quando ela existe, também assume o
// HUD mobile para que nenhum botão fique escondido atrás dos ornamentos.
// O desenho antigo abaixo permanece apenas como fallback em salas sem moldura.
if (instance_exists(obj_moldura_jogo)) exit;

var mobile_gui_w = display_get_gui_width();
var mobile_gui_h = display_get_gui_height();

// Em retrato, não comprimir o jogo: pedir a rotação de forma clara.
var mobile_em_retrato = global.mobile_browser
    ? browser_width < browser_height
    : display_get_width() < display_get_height();

if (mobile_em_retrato) {
    draw_set_alpha(0.94);
    draw_set_color(make_color_rgb(30, 42, 67));
    draw_rectangle(0, 0, mobile_gui_w, mobile_gui_h, false);

    draw_set_alpha(1);
    draw_set_font(fnt_dialogo);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(250, 246, 239));
    draw_text_transformed(
        mobile_gui_w * 0.5,
        mobile_gui_h * 0.45,
        "Gire o celular para jogar",
        1.35,
        1.35,
        0
    );
    draw_set_color(make_color_rgb(194, 222, 215));
    draw_text(
        mobile_gui_w * 0.5,
        mobile_gui_h * 0.54,
        "Soulscapes foi criado para a tela horizontal."
    );

    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(-1);
    exit;
}

var mobile_ocultar =
    (variable_global_exists("jogo_pausado") && global.jogo_pausado)
    || (variable_global_exists("dialogue_open") && global.dialogue_open);

if (mobile_ocultar) exit;

var mobile_left_cx = mobile_gui_w * 0.095;
var mobile_right_cx = mobile_gui_w * 0.205;
var mobile_move_cy = mobile_gui_h - 116;
var mobile_jump_cx = mobile_gui_w - 104;
var mobile_action_cx = mobile_gui_w - 244;
var mobile_action_cy = mobile_gui_h - 116;
var mobile_pause_cx = mobile_gui_w - 54;
var mobile_pause_cy = 54;

var mobile_cor_fundo = make_color_rgb(244, 239, 250);
var mobile_cor_borda = make_color_rgb(119, 113, 173);
var mobile_cor_texto = make_color_rgb(55, 61, 96);
var mobile_cor_menta = make_color_rgb(194, 231, 218);
var mobile_cor_rosa = make_color_rgb(238, 199, 222);
var mobile_alpha = 0.72;

draw_set_font(fnt_dialogo);

var desenhar_botao_mobile = function(
    _cx,
    _cy,
    _raio,
    _pressionado,
    _cor,
    _texto,
    _alpha_normal,
    _cor_borda,
    _cor_texto
) {
    var _deslocamento = _pressionado ? 3 : 0;

    draw_set_alpha(0.14);
    draw_set_color(make_color_rgb(35, 39, 64));
    draw_circle(_cx + 3, _cy + 6, _raio, false);

    draw_set_alpha(_pressionado ? 0.92 : _alpha_normal);
    draw_set_color(_cor);
    draw_circle(_cx, _cy + _deslocamento, _raio, false);

    draw_set_alpha(_pressionado ? 1 : 0.78);
    draw_set_color(_cor_borda);
    draw_circle(_cx, _cy + _deslocamento, _raio, true);

    draw_set_alpha(1);
    draw_set_color(_cor_texto);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(_cx, _cy + _deslocamento, _texto);
};

// Direções grandes, separadas o bastante para não confundir os dedos.
desenhar_botao_mobile(
    mobile_left_cx,
    mobile_move_cy,
    58,
    global.mobile_left,
    mobile_cor_fundo,
    "<",
    mobile_alpha,
    mobile_cor_borda,
    mobile_cor_texto
);
desenhar_botao_mobile(
    mobile_right_cx,
    mobile_move_cy,
    58,
    global.mobile_right,
    mobile_cor_fundo,
    ">",
    mobile_alpha,
    mobile_cor_borda,
    mobile_cor_texto
);

// Ação e pulo usam cores diferentes para serem reconhecidos sem leitura.
desenhar_botao_mobile(
    mobile_action_cx,
    mobile_action_cy,
    57,
    false,
    mobile_cor_menta,
    "AÇÃO",
    mobile_alpha,
    mobile_cor_borda,
    mobile_cor_texto
);
desenhar_botao_mobile(
    mobile_jump_cx,
    mobile_action_cy,
    66,
    global.mobile_jump,
    mobile_cor_rosa,
    "PULAR",
    mobile_alpha,
    mobile_cor_borda,
    mobile_cor_texto
);

// Menu compacto no canto superior, longe das ações principais.
draw_set_alpha(0.15);
draw_set_color(make_color_rgb(35, 39, 64));
draw_circle(mobile_pause_cx + 2, mobile_pause_cy + 4, 34, false);
draw_set_alpha(0.76);
draw_set_color(mobile_cor_fundo);
draw_circle(mobile_pause_cx, mobile_pause_cy, 34, false);
draw_set_alpha(0.85);
draw_set_color(mobile_cor_borda);
draw_circle(mobile_pause_cx, mobile_pause_cy, 34, true);

draw_set_alpha(1);
draw_set_color(mobile_cor_texto);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(mobile_pause_cx, mobile_pause_cy - 8, "—");
draw_text(mobile_pause_cx, mobile_pause_cy, "—");
draw_text(mobile_pause_cx, mobile_pause_cy + 8, "—");

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
