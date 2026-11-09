if (
    !perto_jogador
    || global.inimigos_derrotados[inimigo_indice]
    || (variable_global_exists("jogo_pausado") && global.jogo_pausado)
    || (variable_global_exists("dialogue_open") && global.dialogue_open)
) {
    exit;
}

var inimigo_camera = view_get_camera(0);
var inimigo_gui_x = inimigo_camera == -1
    ? x
    : (x - camera_get_view_x(inimigo_camera))
        * display_get_gui_width() / camera_get_view_width(inimigo_camera);
var inimigo_topo_mundo = bbox_top;
var inimigo_gui_y = inimigo_camera == -1
    ? inimigo_topo_mundo
    : (inimigo_topo_mundo - camera_get_view_y(inimigo_camera))
        * display_get_gui_height() / camera_get_view_height(inimigo_camera);

// Mesmo cartão, tamanho e afastamento usados por todos os personagens faláveis.
inimigo_gui_x = clamp(inimigo_gui_x, 116, display_get_gui_width() - 116);
inimigo_gui_y = clamp(inimigo_gui_y - 34, 72, display_get_gui_height() - 72);

var inimigo_aviso_cy = inimigo_gui_y;
var inimigo_aviso_x1 = inimigo_gui_x - 106;
var inimigo_aviso_y1 = inimigo_aviso_cy - 23;
var inimigo_aviso_x2 = inimigo_gui_x + 106;
var inimigo_aviso_y2 = inimigo_aviso_cy + 23;
var inimigo_alto_contraste = variable_global_exists("config_contraste")
    && global.config_contraste >= 1;

draw_set_alpha(0.18);
draw_set_color(make_color_rgb(73, 70, 110));
draw_roundrect(inimigo_aviso_x1 + 3, inimigo_aviso_y1 + 4,
    inimigo_aviso_x2 + 3, inimigo_aviso_y2 + 4, false);
draw_set_alpha(0.94);
draw_set_color(inimigo_alto_contraste ? c_white : make_color_rgb(249, 244, 251));
draw_roundrect(inimigo_aviso_x1, inimigo_aviso_y1,
    inimigo_aviso_x2, inimigo_aviso_y2, false);
draw_set_alpha(0.76);
draw_set_color(inimigo_alto_contraste ? make_color_rgb(43, 34, 79) : make_color_rgb(139, 122, 185));
draw_roundrect(inimigo_aviso_x1, inimigo_aviso_y1,
    inimigo_aviso_x2, inimigo_aviso_y2, true);

draw_set_alpha(0.96);
draw_set_color(make_color_rgb(222, 211, 244));
draw_roundrect(inimigo_aviso_x1 + 9, inimigo_aviso_y1 + 7,
    inimigo_aviso_x1 + 49, inimigo_aviso_y2 - 7, false);
draw_set_alpha(0.86);
draw_set_color(make_color_rgb(121, 105, 171));
draw_roundrect(inimigo_aviso_x1 + 9, inimigo_aviso_y1 + 7,
    inimigo_aviso_x1 + 49, inimigo_aviso_y2 - 7, true);

draw_set_alpha(1);
draw_set_font(fnt_dialogo);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(inimigo_alto_contraste ? make_color_rgb(20, 20, 32) : make_color_rgb(76, 69, 119));
draw_text(inimigo_aviso_x1 + 29, inimigo_aviso_cy, (variable_global_exists("mobile_mode") && global.mobile_mode) ? "!" : "E");
draw_set_color(inimigo_alto_contraste ? make_color_rgb(20, 20, 32) : make_color_rgb(64, 67, 101));
draw_text((inimigo_aviso_x1 + 54 + inimigo_aviso_x2) * 0.5,
    inimigo_aviso_cy, "Interagir");

draw_set_alpha(0.78);
draw_set_color(make_color_rgb(238, 196, 222));
draw_circle(inimigo_aviso_x2 - 12, inimigo_aviso_y1 + 10, 3, false);
draw_set_color(make_color_rgb(191, 235, 220));
draw_circle(inimigo_aviso_x2 - 8, inimigo_aviso_y1 + 18, 2, false);

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
