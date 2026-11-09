// ─────────────────────────────────────────────
//  obj_kiran  |  CREATE EVENT
// ─────────────────────────────────────────────

// Horizontal movement

hsp          = 0;
vsp          = 0;
move_accel   = 0.5;
move_fric    = 0.9;
move_spd_max = 2.5;      // walking max speed
run_spd_max  = 7;     // running max speed (Shift held)
run_accel    = 0.8;    // accelerates faster when running

// Vertical
grav       = 0.25;
jump_force = -5;

// Ground detection
on_ground        = false;
ground_tolerance = 2;

// A Room6 foi montada visualmente no editor com uma escala reduzida. Como a
// escala da instância também reduz a máscara de colisão, normalize Kiran já no
// Create (antes do primeiro Step) e coloque seus pés sobre a trilha da sala.
// A movimentação da Room6 usa um piso virtual no Step e não depende dos blocos
// de colisão que podem ser redimensionados novamente no Room Editor.
if (room == Room6) {
    image_xscale = image_xscale < 0 ? -1 : 1;
    image_yscale = 1;
    x = clamp(x, 180, 1260);
    y = 470;
}

// Facing direction (1 = right, -1 = left). Respeita a orientação definida
// na room antes de normalizar a escala da instância.
facing = image_xscale < 0 ? -1 : 1;

// Input flags
key_left  = 0;
key_right = 0;
key_jump  = 0;
key_run   = 0;

// ─────────────────────────────────────────────────────────────────────────────
// CONTROLES MOBILE
// A mesma lógica de movimento continua sendo usada no computador. No Android
// e iOS, os botões desenhados no Draw GUI alimentam estas entradas globais.
// F10 alterna a interface durante testes no desktop, sem afetar o jogador.
// ─────────────────────────────────────────────────────────────────────────────
if (!variable_global_exists("mobile_mode")) {
    var kiran_info_sistema = os_get_info();
    var kiran_mobile_navegador = ds_map_exists(kiran_info_sistema, "mobile")
        && kiran_info_sistema[? "mobile"] >= 0.5;
    ds_map_destroy(kiran_info_sistema);

    global.mobile_browser = kiran_mobile_navegador;
    global.mobile_mode =
        os_type == os_android
        || os_type == os_ios
        || kiran_mobile_navegador;
}

if (!variable_global_exists("mobile_browser")) {
    global.mobile_browser = false;
}

if (!variable_global_exists("mobile_fullscreen_solicitado")) {
    global.mobile_fullscreen_solicitado = false;
}

global.mobile_left = false;
global.mobile_right = false;
global.mobile_run = false;
global.mobile_jump = false;
global.mobile_jump_pressed = false;
global.mobile_interact_pressed = false;
global.mobile_pause_pressed = false;
global.mobile_inventory_pressed = false;
global.mobile_settings_pressed = false;

mobile_left_hold = 0;
mobile_right_hold = 0;
mobile_interact_buffer = 0;
mobile_pause_buffer = 0;
mobile_inventory_buffer = 0;
mobile_settings_buffer = 0;
mobile_debug_latch = false;

// Ao trocar de room no celular, o dedo que acionou a saída pode continuar
// pressionado durante a criação da sala seguinte. Guardamos esse estado para
// que o novo Kiran espere o toque ser solto antes de aceitar outra interação.
if (!variable_global_exists("mobile_transition_wait_release")) {
    global.mobile_transition_wait_release = false;
}

// Esta trava precisa ser global porque a Room1 e suas instâncias são
// persistentes. Ao voltar para ela, o Create de Kiran não executa novamente.
mobile_room_touch_lock = global.mobile_transition_wait_release;
if (global.mobile_mode) {
    for (var mobile_create_touch = 0; mobile_create_touch < 5; mobile_create_touch++) {
        if (device_mouse_check_button(mobile_create_touch, mb_left)) {
            mobile_room_touch_lock = true;
            global.mobile_transition_wait_release = true;
            break;
        }
    }
}

// Jump buffer (coyote time)
jump_buffer = 0;

// Jump cooldown + release flag
jump_cooldown     = 0;
jump_cooldown_max = 12;
jump_key_released = true;

// Sprite flicker fix
prev_sprite = -1;

// Todas as animações usam a mesma máscara. Origens diferentes entre os
// sprites não podem mais empurrar Kiran para dentro de paredes.
mask_index = spr_kiran_idle;

// Última posição livre, usada somente como rede de segurança.
posicao_segura_x = x;
posicao_segura_y = y;

// Fragile platform hook
current_spd_max = move_spd_max;

// Dialogue guard
if (!variable_global_exists("dialogue_open")) {
    global.dialogue_open = false;
}

view_object[0] = noone;   // desativa o follow padrão

// Obj_rainha foi criado pelo editor sem eventos registrados. Inicializar a
// Room6 a partir do Create já existente de Kiran garante câmera, diálogo, HUD
// e música mesmo que o GameMaker volte a salvar o arquivo .yy da Rainha.
if (room == Room6) {
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

    global.dialogue_open = false;
    global.jogo_pausado = false;
    global.encontro_rainha_iniciado = false;
    global.capitulo_concluido = false;
    global.interacao_bloqueada_ate = 0;
}


// ─────────────────────────────────────────────────────────────────────────────
// EFEITOS SONOROS DE GAMEPLAY
// Criados uma única vez em memória, com timbres diferentes para cada ação.
// Assim funcionam em todas as rooms e obedecem ao volume de Sons do menu.
// ─────────────────────────────────────────────────────────────────────────────
if (!variable_global_exists("config_volume_sons")) {
    global.config_volume_sons = 0.70;
}

if (!variable_global_exists("sfx_gameplay_criado")) {
    global.sfx_gameplay_buffers = [];

    var criar_sfx = function(_duracao, _freq_inicio, _freq_fim, _tipo) {
        var _taxa = 22050;
        var _amostras = max(1, round(_taxa * _duracao));
        var _buffer = buffer_create(_amostras * 2, buffer_fixed, 1);
        buffer_seek(_buffer, buffer_seek_start, 0);

        for (var _i = 0; _i < _amostras; _i++) {
            var _t = _i / _taxa;
            var _p = _i / _amostras;
            var _freq_delta = _freq_fim - _freq_inicio;
            var _fase = 2 * pi * (
                _freq_inicio * _t
                + _freq_delta * _t * _t / (2 * _duracao)
            );
            // Média de três amostras reduz o chiado digital áspero do gerador
            // anterior. O pequeno ataque também elimina estalos no início.
            var _ruido_a = frac(sin((_i + 1) * 12.9898) * 43758.5453);
            var _ruido_b = frac(sin((_i + 7) * 37.719) * 14375.147);
            var _ruido_c = frac(sin((_i + 19) * 5.3983) * 29381.731);
            var _ruido = ((_ruido_a + _ruido_b + _ruido_c) / 3) * 2 - 1;
            var _ataque = clamp(_p / 0.07, 0, 1);
            var _envolvente = _ataque * power(max(0, 1 - _p), 1.7);
            var _onda = 0;

            switch (_tipo) {
                case 0: // passo macio, sem o chiado metálico anterior
                    _envolvente = _ataque * power(max(0, 1 - _p), 4.6);
                    _onda = sin(_fase) * 0.34 + _ruido * 0.10;
                break;

                case 1: // salto: sopro curto e suave que sobe
                    _envolvente = power(sin(pi * clamp(_p, 0, 1)), 0.82);
                    _onda = sin(_fase) * 0.48 + sin(_fase * 0.5) * 0.10;
                break;

                case 2: // aterrissagem/dano: impacto abafado
                    _envolvente = _ataque * power(max(0, 1 - _p), 4.8);
                    _onda = sin(_fase) * 0.46 + _ruido * 0.16;
                break;

                case 3: // ataque: corte de ar, menos estridente
                    _envolvente = _ataque * power(max(0, 1 - _p), 2.4);
                    _onda = sin(_fase) * 0.28 + _ruido * (0.28 * (1 - _p));
                break;

                case 4: // defesa: cristal curto e arredondado
                    _envolvente = _ataque * power(max(0, 1 - _p), 2.0);
                    _onda = sin(_fase) * 0.48 + sin(_fase * 1.5) * 0.14;
                break;

                case 5: // cura: acorde leve, com entrada e saída suaves
                    _envolvente = power(sin(pi * clamp(_p, 0, 1)), 0.90);
                    _onda = sin(_fase) * 0.40
                        + sin(_fase * 1.25) * 0.16
                        + sin(_fase * 2) * 0.07;
                break;
            }

            buffer_write(
                _buffer,
                buffer_s16,
                clamp(round(_onda * _envolvente * 5200), -32768, 32767)
            );
        }

        var _asset = audio_create_buffer_sound(
            _buffer,
            buffer_s16,
            _taxa,
            0,
            _amostras * 2,
            audio_mono
        );
        array_push(global.sfx_gameplay_buffers, _buffer);
        return _asset;
    };

    global.sfx_passo = criar_sfx(0.060, 108, 72, 0);
    global.sfx_pulo = criar_sfx(0.19, 190, 430, 1);
    global.sfx_aterrissar = criar_sfx(0.10, 96, 48, 2);
    global.sfx_ataque_kiran = criar_sfx(0.15, 540, 155, 3);
    global.sfx_ataque_inimigo = criar_sfx(0.19, 245, 70, 3);
    global.sfx_dano = criar_sfx(0.12, 125, 44, 2);
    global.sfx_defesa = criar_sfx(0.18, 430, 720, 4);
    global.sfx_cura = criar_sfx(0.34, 330, 610, 5);
    global.sfx_gameplay_criado = true;
}

global.tocar_sfx = function(_asset, _volume, _pitch) {
    if (_asset != -1 && global.config_volume_sons > 0) {
        var _canal = audio_play_sound(_asset, 110, false);
        audio_sound_gain(
            _canal,
            clamp(global.config_volume_sons * _volume, 0, 1),
            0
        );
        audio_sound_pitch(_canal, _pitch);
    }
};

sfx_passo_timer = 0;
sfx_passo_alternar = false;
sfx_no_chao_anterior = false;
