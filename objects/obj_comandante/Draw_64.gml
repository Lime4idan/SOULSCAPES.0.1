if (
    !pode_interagir
    || estado_comandante != 0
    || global.dialogue_open
    || (variable_global_exists("jogo_pausado") && global.jogo_pausado)
) {
    exit;
}

var camera = view_get_camera(0);
var gui_x = camera == -1
    ? x
    : (x - camera_get_view_x(camera))
        * display_get_gui_width() / camera_get_view_width(camera);
var comandante_topo_mundo = bbox_top;
var gui_y = camera == -1
    ? comandante_topo_mundo
    : (comandante_topo_mundo - camera_get_view_y(camera))
        * display_get_gui_height() / camera_get_view_height(camera);

gui_x = clamp(gui_x, 116, display_get_gui_width() - 116);
gui_y = clamp(gui_y - 34, 72, display_get_gui_height() - 72);

var x1 = gui_x - 106;
var y1 = gui_y - 23;
var x2 = gui_x + 106;
var y2 = gui_y + 23;
var alto_contraste = variable_global_exists("config_contraste")
    && global.config_contraste >= 1;

draw_set_alpha(0.20);
draw_set_color(make_color_rgb(35, 34, 65));
draw_roundrect(x1 + 3, y1 + 4, x2 + 3, y2 + 4, false);
draw_set_alpha(0.96);
draw_set_color(alto_contraste ? c_white : make_color_rgb(249, 244, 251));
draw_roundrect(x1, y1, x2, y2, false);
draw_set_alpha(0.80);
draw_set_color(alto_contraste
    ? make_color_rgb(43, 34, 79)
    : make_color_rgb(139, 122, 185));
draw_roundrect(x1, y1, x2, y2, true);

draw_set_alpha(0.98);
draw_set_color(make_color_rgb(225, 216, 245));
draw_roundrect(x1 + 9, y1 + 7, x1 + 49, y2 - 7, false);
draw_set_color(make_color_rgb(121, 105, 171));
draw_roundrect(x1 + 9, y1 + 7, x1 + 49, y2 - 7, true);

draw_set_alpha(1);
draw_set_font(fnt_dialogo);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(alto_contraste
    ? make_color_rgb(20, 20, 32)
    : make_color_rgb(76, 69, 119));
draw_text(x1 + 29, gui_y, (variable_global_exists("mobile_mode") && global.mobile_mode) ? "!" : "E");
draw_set_color(alto_contraste
    ? make_color_rgb(20, 20, 32)
    : make_color_rgb(64, 67, 101));
draw_text((x1 + 54 + x2) * 0.5, gui_y, "Interagir");

draw_set_alpha(0.78);
draw_set_color(make_color_rgb(238, 196, 222));
draw_circle(x2 - 12, y1 + 10, 3, false);
draw_set_color(make_color_rgb(191, 235, 220));
draw_circle(x2 - 8, y1 + 18, 2, false);

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
