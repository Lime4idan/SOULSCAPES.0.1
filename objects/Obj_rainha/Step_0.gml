pode_interagir = false;

if (global.capitulo_concluido || global.encontro_rainha_iniciado) {
    exit;
}

if (instance_exists(obj_Kiran)) {
    var jogador = instance_nearest(x, y, obj_Kiran);
    pode_interagir = point_distance(x, y, jogador.x, jogador.y)
        <= distancia_interacao;
}

if (
    !pode_interagir
    || global.jogo_pausado
    || global.dialogue_open
    || current_time < global.interacao_bloqueada_ate
    || !(
        keyboard_check_pressed(ord("E"))
        || (variable_global_exists("mobile_interact_pressed") && global.mobile_interact_pressed)
    )
) {
    exit;
}

var controlador = instance_find(obj_pause, 0);

if (
    instance_exists(controlador)
    && variable_instance_exists(controlador, "iniciar_encontro_roteiro")
) {
    global.encontro_rainha_iniciado = true;
    global.interacao_bloqueada_ate = current_time + 180;
    controlador.iniciar_encontro_roteiro(7);
}
