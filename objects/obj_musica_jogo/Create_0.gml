// Criar a variável ANTES de qualquer instance_destroy
musica_jogo_id = noone;

// O controlador continua entre as rooms
persistent = true;

// Impedir controladores duplicados
if (instance_number(obj_musica_jogo) > 1) {
    instance_destroy();
    exit;
}

// Volume padrão
if (!variable_global_exists("config_volume_musica")) {
    global.config_volume_musica = 0.80;
}

// Começar a música caso esteja dentro do jogo
if (room != rm_menu) {
    musica_jogo_id = audio_play_sound(
        snd_musica_jogo,
        0,
        true
    );

    audio_sound_gain(
        musica_jogo_id,
        global.config_volume_musica,
        0
    );
}