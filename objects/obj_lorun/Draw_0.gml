draw_self();

var pode_mostrar_interacao =
    etapa_conversa == 0
    || (etapa_conversa == 3 && global.tem_fragmento);

if (
    pode_interagir
    && pode_mostrar_interacao
    && !global.dialogue_open
    && !conversa_finalizada
) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);

    draw_text(x, y - 90, "E - Interagir");

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}