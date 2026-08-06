// Confirmar que a variável existe
if (variable_instance_exists(id, "musica_jogo_id")) {
    if (
        musica_jogo_id != noone
        && audio_is_playing(musica_jogo_id)
    ) {
        audio_stop_sound(musica_jogo_id);
    }
}