var flutuar = global.config_reduzir_animacoes
    ? 0
    : sin(tempo_visual) * 1.4;

draw_set_alpha(0.20 * image_alpha);
draw_set_color(make_color_rgb(25, 32, 54));
draw_ellipse(x - 58, y - 6, x + 58, y + 10, false);

draw_set_alpha(image_alpha);
draw_set_color(c_white);
draw_sprite_ext(
    spr_comandante,
    0,
    x,
    y + flutuar,
    image_xscale,
    image_yscale,
    0,
    c_white,
    image_alpha
);

draw_set_alpha(1);
draw_set_color(c_white);
