// A instância e a máscara continuam em escala 1. Na sala ampla da Rainha,
// apenas o desenho fica menor; assim a proporção visual melhora sem trazer de
// volta o bloqueio de movimento causado pela máscara redimensionada.
var escala_visual = room == Room6 ? 0.72 : 1;
if (sprite_index == spr_kiran_run) escala_visual *= 1.045;

if (abs(escala_visual - 1) > 0.001) {
    var base_abaixo_origem = sprite_get_height(sprite_index)
        - sprite_get_yoffset(sprite_index);
    var ajuste_base = base_abaixo_origem * (escala_visual - 1);

    draw_sprite_ext(
        sprite_index,
        image_index,
        x,
        y - ajuste_base,
        facing * escala_visual,
        escala_visual,
        image_angle,
        image_blend,
        image_alpha
    );
}
else {
    draw_self();
}
