perto_jogador = false;

if (!global.inimigos_derrotados[inimigo_indice] && instance_exists(obj_Kiran)) {
    var jogador_inimigo = instance_nearest(x, y, obj_Kiran);
    perto_jogador = point_distance(x, y, jogador_inimigo.x, jogador_inimigo.y)
        <= distancia_interacao;
}

var inimigo_pausado =
    (variable_global_exists("jogo_pausado") && global.jogo_pausado)
    || (variable_global_exists("dialogue_open") && global.dialogue_open);

if (!inimigo_pausado && !global.config_reduzir_animacoes) {
    tempo_visual += 0.055;
}

if (
    perto_jogador
    && !inimigo_pausado
    && current_time >= global.interacao_bloqueada_ate
    && (
        keyboard_check_pressed(ord("E"))
        || (variable_global_exists("mobile_interact_pressed") && global.mobile_interact_pressed)
    )
) {
    var controlador_duelo = instance_find(obj_pause, 0);

    if (instance_exists(controlador_duelo)) {
        global.interacao_bloqueada_ate = current_time + 120;
        controlador_duelo.iniciar_confronto_instancia(id);
    }
}
