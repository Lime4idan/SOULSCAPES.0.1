distancia_interacao = 100;
pode_interagir = false;
entrando_templo = false;

if (!variable_global_exists("transicao_room_bloqueada_ate")) {
    global.transicao_room_bloqueada_ate = 0;
}

if (!variable_global_exists("mobile_transition_wait_release")) {
    global.mobile_transition_wait_release = false;
}
