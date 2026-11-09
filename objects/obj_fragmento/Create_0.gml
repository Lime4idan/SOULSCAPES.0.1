distancia_interacao = 120;
pode_interagir = false;

if (!variable_global_exists("tem_fragmento")) {
    global.tem_fragmento = false;
}

if (!variable_global_exists("tem_espada_fragmento")) {
    // Compatibilidade com partidas iniciadas antes da arma existir.
    global.tem_espada_fragmento = global.tem_fragmento;
}

// O item já coletado permanece no inventário e não reaparece ao voltar à room.
if (global.tem_fragmento) {
    instance_destroy();
}
