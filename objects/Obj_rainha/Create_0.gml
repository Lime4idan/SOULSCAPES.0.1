// A Room6 foi montada à mão com a Rainha, Kiran e as colisões. Estes
// controladores completam a sala mesmo quando ela é executada diretamente.
if (!instance_exists(obj_camera)) {
    instance_create_depth(0, 0, -10000, obj_camera);
}

if (!instance_exists(obj_dialogo)) {
    instance_create_depth(0, 0, -10001, obj_dialogo);
}

if (!instance_exists(obj_pause)) {
    instance_create_depth(0, 0, -10002, obj_pause);
}

if (!instance_exists(obj_moldura_jogo)) {
    instance_create_depth(0, 0, -10003, obj_moldura_jogo);
}

if (!instance_exists(obj_musica_jogo)) {
    instance_create_depth(0, 0, -10004, obj_musica_jogo);
}

if (!variable_global_exists("interacao_bloqueada_ate")) {
    global.interacao_bloqueada_ate = 0;
}

if (!variable_global_exists("encontro_rainha_iniciado")) {
    global.encontro_rainha_iniciado = false;
}

if (!variable_global_exists("capitulo_concluido")) {
    global.capitulo_concluido = false;
}

// Entrar novamente na sala sempre deve começar no estado explorável. Uma
// tentativa anterior podia deixar esta flag global ligada e fazer a Rainha
// ignorar tanto o aviso quanto a tecla E.
if (!global.capitulo_concluido) {
    global.encontro_rainha_iniciado = false;
    global.dialogue_open = false;
    global.jogo_pausado = false;
}

pode_interagir = false;
// A origem da arte fica no centro da personagem alta; um alcance pequeno por
// distância entre origens obrigava Kiran a atravessar visualmente o vestido.
distancia_interacao = 340;
image_speed = 0;
