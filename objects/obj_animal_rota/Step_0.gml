if (
    (variable_global_exists("jogo_pausado") && global.jogo_pausado)
    || (variable_global_exists("dialogue_open") && global.dialogue_open)
) {
    exit;
}

if (animal_pausa > 0) {
    animal_pausa--;
}
else {
    x += animal_direcao * velocidade_da_rota;

    var animal_metade_rota = largura_da_rota * 0.5;
    if (x >= animal_origem_x + animal_metade_rota) {
        x = animal_origem_x + animal_metade_rota;
        animal_direcao = -1;
        animal_pausa = irandom_range(18, 46);
    }
    else if (x <= animal_origem_x - animal_metade_rota) {
        x = animal_origem_x - animal_metade_rota;
        animal_direcao = 1;
        animal_pausa = irandom_range(18, 46);
    }
}

if (!variable_global_exists("config_reduzir_animacoes") || !global.config_reduzir_animacoes) {
    animal_tempo += 0.09;
}
