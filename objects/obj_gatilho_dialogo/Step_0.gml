if (!ativado && !global.dialogue_open) {
    var jogador = instance_nearest(x, y, obj_Kiran);

    if (instance_exists(jogador)) {
        var distancia = point_distance(x, y, jogador.x, jogador.y);

        if (distancia <= distancia_ativacao) {
            ativado = true;

            with (obj_dialogo) {
                iniciar_dialogo(other.falas);
            }
        }
    }
}