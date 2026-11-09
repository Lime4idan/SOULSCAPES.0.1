// Comandante da Rainha que guarda a escadaria depois do templo.
if (!variable_global_exists("comandante_partiu")) {
    global.comandante_partiu = false;
}

if (!variable_global_exists("comandante_conhecida")) {
    global.comandante_conhecida = false;
}

if (global.comandante_partiu) {
    instance_destroy();
    exit;
}

estado_comandante = 0; // 0: bloqueando, 1: diálogo, 2: subindo
pode_interagir = false;
distancia_interacao = 155;
tempo_visual = random(100);

// A comandante precisa dominar visualmente o bloqueio da escadaria. O aumento
// mantém a origem configurada no sprite e deixa sua silhueta maior que Kiran.
image_xscale = 1.25;
image_yscale = 1.25;
image_speed = 0;

oferendas_restantes = function() {
    var total = 0;

    // Cada fragmento só desperta quando sua oferenda é devolvida à estátua.
    // Assim, vencer os guardas sem concluir as entregas não libera a escada.
    if (!variable_global_exists("fragmentos_vitral")) {
        return 4;
    }

    for (var oferenda_i = 0; oferenda_i < 4; oferenda_i++) {
        if (!global.fragmentos_vitral[oferenda_i]) total++;
    }

    return total;
};
