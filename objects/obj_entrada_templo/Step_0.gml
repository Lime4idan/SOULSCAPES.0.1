// ═════════════════════════════════════════════
// LIMPAR ESTADO ANTIGO DA SALA PERSISTENTE
// ═════════════════════════════════════════════
// Room1 continua existindo enquanto o templo está aberto. Ao retornar,
// "entrando_templo" ainda pode estar verdadeiro e "pode_interagir" pode
// conter o valor do último frame. Zerar os dois garante que o aviso só seja
// reativado pela distância atual calculada mais abaixo.
entrando_templo = false;
pode_interagir = false;


// ═════════════════════════════════════════════
// PAUSA
// ═════════════════════════════════════════════
if (
    variable_global_exists("jogo_pausado")
    && global.jogo_pausado
) {
    pode_interagir = false;
    exit;
}


// ═════════════════════════════════════════════
// VERIFICAR SE KIRAN EXISTE
// ═════════════════════════════════════════════
if (!instance_exists(obj_Kiran)) {
    pode_interagir = false;
    exit;
}


// Encontrar o Kiran
var jogador = instance_nearest(
    x,
    y,
    obj_Kiran
);


// Verificar distância
pode_interagir =
    point_distance(
        x,
        y,
        jogador.x,
        jogador.y
    )
    <= distancia_interacao;


// ═════════════════════════════════════════════
// NÃO INTERAGIR DURANTE DIÁLOGOS
// ═════════════════════════════════════════════
if (
    variable_global_exists("dialogue_open")
    && global.dialogue_open
) {
    exit;
}


// ═════════════════════════════════════════════
// APERTAR E NA ENTRADA
// ═════════════════════════════════════════════
if (
    pode_interagir
    && current_time >= global.transicao_room_bloqueada_ate
    && (
        keyboard_check_pressed(ord("E"))
        || (variable_global_exists("mobile_interact_pressed") && global.mobile_interact_pressed)
    )
) {
    entrando_templo = true;

    // Consome o toque que iniciou a troca. Como Room1 e Kiran são
    // persistentes, sem este bloqueio o mesmo toque pode disparar a saída
    // da próxima sala e devolver o jogador imediatamente.
    global.transicao_room_bloqueada_ate = current_time + 450;
    global.mobile_transition_wait_release = true;

    if (variable_global_exists("mobile_interact_pressed")) {
        global.mobile_interact_pressed = false;
    }

    with (obj_Kiran) {
        mobile_interact_buffer = 0;
        mobile_room_touch_lock = true;
    }

    if (variable_global_exists("dialogue_open")) {
        global.dialogue_open = false;
    }

    if (variable_global_exists("jogo_pausado")) {
        global.jogo_pausado = false;
    }

    room_goto(rm_templo);
}
