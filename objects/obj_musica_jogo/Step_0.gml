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
    musica_jogo_asset = -1;

    exit;
}


// ═════════════════════════════════════════════
// DENTRO DO JOGO
// ═════════════════════════════════════════════

// A sala da Rainha reutiliza o tema do menu. O mesmo controlador persistente
// troca a faixa na transição, evitando duas músicas tocando ao mesmo tempo.
var musica_desejada = room == Room6
    ? snd_musica_menu
    : snd_musica_jogo;

if (
    musica_jogo_id != noone
    && audio_is_playing(musica_jogo_id)
    && musica_jogo_asset != musica_desejada
) {
    audio_stop_sound(musica_jogo_id);
    musica_jogo_id = noone;
}

// Voltar a tocar ao iniciar, retornar ao jogo ou trocar de ambiente.
if (
    musica_jogo_id == noone
    || !audio_is_playing(musica_jogo_id)
) {
    musica_jogo_asset = musica_desejada;
    musica_jogo_id = audio_play_sound(
        musica_jogo_asset,
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
