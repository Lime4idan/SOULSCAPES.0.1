pode_interagir = false;

var jogador = instance_nearest(x, y, obj_Kiran);

if (instance_exists(jogador)) {
    var distancia = point_distance(x, y, jogador.x, jogador.y);

    if (distancia <= distancia_interacao) {
        pode_interagir = true;
    }
}

if (
    pode_interagir
    && keyboard_check_pressed(ord("E"))
    && !global.dialogue_open
) {
    global.tem_fragmento = true;

    with (obj_dialogo) {
        iniciar_dialogo([
            "Um fragmento de vidro...?",
            "Ele parece estar emitindo uma luz fraca."
        ]);
    }

    instance_destroy();
}