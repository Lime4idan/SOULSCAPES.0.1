// ═════════════════════════════════════════════
// NO MENU
// ═════════════════════════════════════════════
if (room == rm_menu) {
    if (
        musica_jogo_id != noone
        && audio_is_playing(musica_jogo_id)
    ) {
        audio_stop_sound(musica_jogo_id);
    }

    musica_jogo_id = noone;

    exit;
}


// ═════════════════════════════════════════════
// DENTRO DO JOGO
// ═════════════════════════════════════════════

// Voltar a tocar ao iniciar ou retornar ao jogo
if (
    musica_jogo_id == noone
    || !audio_is_playing(musica_jogo_id)
) {
    musica_jogo_id = audio_play_sound(
        snd_musica_jogo,
        0,
        true
    );
}


// Atualizar o volume
audio_sound_gain(
    musica_jogo_id,
    global.config_volume_musica,
    0
);