dist_interacao = 90;
pode_interagir = false;

sala_destino = Room4;

// A trava global sobrevive à troca de room e impede que o mesmo toque mobile
// acione também a folha da sala de destino.
if (!variable_global_exists("transicao_room_bloqueada_ate")) {
    global.transicao_room_bloqueada_ate = 0;
}

if (!variable_global_exists("mobile_transition_wait_release")) {
    global.mobile_transition_wait_release = false;
}
