var animal_bob = (
    variable_global_exists("config_reduzir_animacoes")
    && global.config_reduzir_animacoes
) ? 0 : abs(sin(animal_tempo)) * 2;
var animal_y = animal_origem_y - animal_bob;

draw_set_alpha(0.13);
draw_set_color(make_color_rgb(43, 53, 73));
draw_ellipse(x - 25, animal_y + 13, x + 25, animal_y + 21, false);

if (sprite_animal != -1 && sprite_exists(sprite_animal)) {
    var animal_w = max(1, sprite_get_width(sprite_animal));
    var animal_h = max(1, sprite_get_height(sprite_animal));
    var animal_escala_final = min(72 / animal_w, 54 / animal_h) * escala_animal;
    var animal_dx = x
        + (sprite_get_xoffset(sprite_animal) - animal_w * 0.5)
        * animal_escala_final * animal_direcao;
    var animal_dy = animal_y + 18 + (sprite_get_yoffset(sprite_animal) - animal_h) * animal_escala_final;
    draw_set_alpha(1);
    draw_sprite_ext(
        sprite_animal,
        floor(animal_tempo * 4) mod max(1, sprite_get_number(sprite_animal)),
        animal_dx,
        animal_dy,
        animal_escala_final * animal_direcao,
        animal_escala_final,
        0,
        c_white,
        1
    );
}
else {
    // Pequeno cervo-coelho provisório em tons de menta e lilás.
    draw_set_alpha(0.96);
    draw_set_color(make_color_rgb(213, 231, 220));
    draw_ellipse(x - 24, animal_y - 5, x + 18, animal_y + 18, false);
    draw_circle(x + 21 * animal_direcao, animal_y - 10, 13, false);
    draw_set_color(make_color_rgb(173, 160, 207));
    draw_triangle(
        x + 16 * animal_direcao, animal_y - 19,
        x + 12 * animal_direcao, animal_y - 39,
        x + 24 * animal_direcao, animal_y - 22,
        false
    );
    draw_triangle(
        x + 25 * animal_direcao, animal_y - 20,
        x + 31 * animal_direcao, animal_y - 37,
        x + 34 * animal_direcao, animal_y - 17,
        false
    );
    draw_set_color(make_color_rgb(62, 72, 99));
    draw_circle(x + 26 * animal_direcao, animal_y - 12, 2, false);
    draw_line_width(x - 13, animal_y + 13, x - 16, animal_y + 24, 3);
    draw_line_width(x + 7, animal_y + 13, x + 5, animal_y + 24, 3);
    draw_set_color(make_color_rgb(239, 205, 226));
    draw_circle(x - 25 * animal_direcao, animal_y - 2, 7, false);
}

draw_set_alpha(1);
draw_set_color(c_white);
