// ═════════════════════════════════════════════
// PAUSA
// ═════════════════════════════════════════════
if (
    variable_global_exists("jogo_pausado")
    && global.jogo_pausado
) {
    pode_sair = false;
    exit;
}


// ═════════════════════════════════════════════
// PROCURAR KIRAN
// ═════════════════════════════════════════════
if (!instance_exists(obj_Kiran)) {
    pode_sair = false;
    exit;
}

var jogador = instance_nearest(
    x,
    y,
    obj_Kiran
);


// ═════════════════════════════════════════════
// VERIFICAR DISTÂNCIA
// ═════════════════════════════════════════════
pode_sair =
    point_distance(
        x,
        y,
        jogador.x,
        jogador.y
    )
    <= distancia_interacao;


// ═════════════════════════════════════════════
// VERIFICAR DIÁLOGO
// ═════════════════════════════════════════════
var dialogo_aberto =
    variable_global_exists("dialogue_open")
    && global.dialogue_open;


// ═════════════════════════════════════════════
// SAIR DO TEMPLO
// ═════════════════════════════════════════════
if (
    pode_sair
    && !dialogo_aberto
    && keyboard_check_pressed(ord("E"))
) {
    global.voltando_do_templo = true;
    global.dialogue_open = false;

    room_goto(Room1);
}