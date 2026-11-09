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
    && current_time >= global.transicao_room_bloqueada_ate
    && (
        keyboard_check_pressed(ord("E"))
        || (variable_global_exists("mobile_interact_pressed") && global.mobile_interact_pressed)
    )
) {
    // Impede o toque usado para sair do templo de alcançar a entrada da
    // Room1 no frame seguinte. O spawn fica a apenas 96 px da entrada.
    global.transicao_room_bloqueada_ate = current_time + 450;
    global.mobile_transition_wait_release = true;

    if (variable_global_exists("mobile_interact_pressed")) {
        global.mobile_interact_pressed = false;
    }

    with (obj_Kiran) {
        mobile_interact_buffer = 0;
        mobile_room_touch_lock = true;
    }

    global.voltando_do_templo = true;
    global.dialogue_open = false;

    room_goto(Room1);
}
