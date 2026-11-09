if (!perto_item && !coletado) {
    exit;
}

var item_camera = view_get_camera(0);
var item_camera_x = item_camera == -1 ? 0 : camera_get_view_x(item_camera);
var item_camera_y = item_camera == -1 ? 0 : camera_get_view_y(item_camera);
var item_escala_gui_x = item_camera == -1
    ? 1
    : display_get_gui_width() / camera_get_view_width(item_camera);
var item_escala_gui_y = item_camera == -1
    ? 1
    : display_get_gui_height() / camera_get_view_height(item_camera);
var item_gui_x = (x - item_camera_x) * item_escala_gui_x;
var item_gui_y = (y - item_camera_y) * item_escala_gui_y;
var item_texto = global.config_contraste >= 1
    ? make_color_rgb(18, 20, 31)
    : make_color_rgb(52, 59, 94);
var item_borda = global.config_contraste >= 1
    ? make_color_rgb(44, 36, 78)
    : make_color_rgb(86, 89, 132);
var item_papel = global.config_contraste >= 1
    ? c_white
    : make_color_rgb(255, 250, 241);

draw_set_font(fnt_dialogo);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

if (coletado) {
    var toast_alpha = clamp(tempo_coleta / 16, 0, 1);
    draw_set_alpha(0.18 * toast_alpha);
    draw_set_color(make_color_rgb(24, 31, 54));
    draw_roundrect(405, 131, 875, 197, false);
    draw_set_alpha(0.97 * toast_alpha);
    draw_set_color(item_papel);
    draw_roundrect(399, 125, 869, 191, false);
    draw_set_alpha(0.68 * toast_alpha);
    draw_set_color(cor_tematica);
    draw_roundrect(399, 125, 869, 191, true);
    draw_set_alpha(toast_alpha);
    draw_set_color(item_texto);
    draw_text_transformed(634, 148, nome_item + " guardado na bolsa", 0.72, 0.72, 0);
    draw_set_alpha(0.68 * toast_alpha);
    draw_text_transformed(634, 173,
        "Consumível  •  recupera " + string(cura_item) + " de vida", 0.50, 0.50, 0);
}
else {
    var prompt_x = clamp(item_gui_x, 150, display_get_gui_width() - 150);
    var prompt_y = clamp(
        item_gui_y - 86,
        115,
        display_get_gui_height() - 105
    );
    draw_set_alpha(0.17);
    draw_set_color(make_color_rgb(24, 31, 54));
    draw_roundrect(prompt_x - 121, prompt_y - 23,
        prompt_x + 121, prompt_y + 23, false);
    draw_set_alpha(0.97);
    draw_set_color(item_papel);
    draw_roundrect(prompt_x - 125, prompt_y - 27,
        prompt_x + 117, prompt_y + 19, false);
    draw_set_alpha(0.74);
    draw_set_color(cor_tematica);
    draw_roundrect(prompt_x - 125, prompt_y - 27,
        prompt_x + 117, prompt_y + 19, true);

    draw_set_alpha(0.92);
    draw_set_color(cor_tematica);
    draw_roundrect(prompt_x - 113, prompt_y - 18,
        prompt_x - 77, prompt_y + 10, false);
    draw_set_alpha(1);
    draw_set_color(item_texto);
    draw_text_transformed(prompt_x - 95, prompt_y - 4, (variable_global_exists("mobile_mode") && global.mobile_mode) ? "!" : "E", 0.62, 0.62, 0);
    draw_set_halign(fa_left);
    draw_text_transformed(prompt_x - 65, prompt_y - 4,
        texto_interacao, 0.55, 0.55, 0);
}

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
