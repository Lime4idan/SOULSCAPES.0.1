// ═════════════════════════════════════════════
// CONFIGURAÇÃO DA SAÍDA
// ═════════════════════════════════════════════
distancia_interacao = 105;
pode_sair = false;

if (!variable_global_exists("voltando_do_templo")) {
    global.voltando_do_templo = false;
}

if (!variable_global_exists("transicao_room_bloqueada_ate")) {
    global.transicao_room_bloqueada_ate = 0;
}

if (!variable_global_exists("mobile_transition_wait_release")) {
    global.mobile_transition_wait_release = false;
}
