display_set_gui_size(1280, 811);

// Controlador persistente de save local + Supabase.
if (!instance_exists(obj_save_cloud)) {
    instance_create_depth(0, 0, -20000, obj_save_cloud);
}

// O mesmo projeto continua funcionando no desktop. No Android/iOS os toques
// passam a controlar a interface e o jogo sem exigir um perfil separado.
if (!variable_global_exists("mobile_mode")) {
    var menu_info_sistema = os_get_info();
    var menu_mobile_navegador = ds_map_exists(menu_info_sistema, "mobile")
        && menu_info_sistema[? "mobile"] >= 0.5;
    ds_map_destroy(menu_info_sistema);

    global.mobile_browser = menu_mobile_navegador;
    global.mobile_mode =
        os_type == os_android
        || os_type == os_ios
        || menu_mobile_navegador;
}

if (!variable_global_exists("mobile_fullscreen_solicitado")) {
    global.mobile_fullscreen_solicitado = false;
}

// ─────────────────────────────────────────────
// POSIÇÃO GERAL DO MENU
// ─────────────────────────────────────────────
menu_centro_x = 665;

botao_w = 290;
botao_h = 58;

botao_y = [
    321, // Novo Jogo
    383, // Continuar
    445, // Conta
    507, // Configurações
    569  // Créditos
];

botao_texto = [
    "Novo Jogo",
    "Continuar",
    "Conta",
    "Configurações",
    "Créditos"
];

// Continuar e habilitado assim que um save local ou da nuvem for encontrado.
botao_ativo = [
    true,
    variable_global_exists("soul_save_exists") && global.soul_save_exists,
    true,
    true,
    true
];

// ─────────────────────────────────────────────
// CONTROLE DO MENU
// ─────────────────────────────────────────────
opcao_atual = 0;
mouse_sobre = -1;

hover_anim = [0, 0, 0, 0, 0];
click_anim = [0, 0, 0, 0, 0];

tempo_menu = 0;

// Telas internas
mostrando_configuracoes = false;
mostrando_creditos = false;
mostrando_conta = false;

conta_campo_ativo = -1;
conta_email = "";
conta_senha = "";
conta_mouse_sobre = -1;
conta_mostrar_senha = false;


// ─────────────────────────────────────────────
// CONFIGURAÇÕES
// ─────────────────────────────────────────────

// Carregar apenas uma vez por execução. O arquivo INI mantém as preferências
// quando o jogo é fechado e aberto novamente.
if (!variable_global_exists("configuracoes_carregadas")) {
    ini_open("soulscapes_config.ini");

    global.config_volume_musica = clamp(
        ini_read_real("audio", "musica", 0.80),
        0,
        1
    );

    global.config_volume_sons = clamp(
        ini_read_real("audio", "sons", 0.70),
        0,
        1
    );

    global.config_baixo_estimulo =
        ini_read_real("acessibilidade", "baixo_estimulo", 0) >= 0.5;

    global.config_reduzir_animacoes =
        ini_read_real("acessibilidade", "reduzir_animacoes", 0) >= 0.5;

    global.config_velocidade_texto = clamp(
        round(ini_read_real("texto", "velocidade", 1)),
        0,
        2
    );

    global.config_tamanho_texto = clamp(
        round(ini_read_real("texto", "tamanho", 1)),
        0,
        2
    );

    global.config_contraste = clamp(
        round(ini_read_real("acessibilidade", "contraste", 0)),
        0,
        1
    );

    ini_close();
    global.configuracoes_carregadas = true;
}

// Função única usada tanto pelo menu quanto pela pausa.
global.salvar_configuracoes = function() {
    ini_open("soulscapes_config.ini");
    ini_write_real("audio", "musica", global.config_volume_musica);
    ini_write_real("audio", "sons", global.config_volume_sons);
    ini_write_real("acessibilidade", "baixo_estimulo", global.config_baixo_estimulo);
    ini_write_real("acessibilidade", "reduzir_animacoes", global.config_reduzir_animacoes);
    ini_write_real("acessibilidade", "contraste", global.config_contraste);
    ini_write_real("texto", "velocidade", global.config_velocidade_texto);
    ini_write_real("texto", "tamanho", global.config_tamanho_texto);
    ini_close();
};

// Um pequeno som de interface é criado em memória. Assim, o controle de
// volume dos sons já tem um efeito real mesmo antes de outros SFX existirem.
if (!variable_global_exists("som_ui_criado")) {
    var som_taxa = 22050;
    var som_amostras = round(som_taxa * 0.16);

    global.som_ui_buffer = buffer_create(
        som_amostras * 2,
        buffer_fixed,
        1
    );

    buffer_seek(global.som_ui_buffer, buffer_seek_start, 0);

    for (var som_i = 0; som_i < som_amostras; som_i++) {
        var som_t = som_i / som_taxa;
        var som_envelope = power(1 - som_i / som_amostras, 2);
        var som_onda =
            sin(2 * pi * 660 * som_t)
            + sin(2 * pi * 990 * som_t) * 0.34;

        buffer_write(
            global.som_ui_buffer,
            buffer_s16,
            round(som_onda * som_envelope * 4200)
        );
    }

    global.som_ui_asset = audio_create_buffer_sound(
        global.som_ui_buffer,
        buffer_s16,
        som_taxa,
        0,
        som_amostras * 2,
        audio_mono
    );

    global.som_ui_criado = true;
}

global.tocar_som_ui = function(_tom) {
    if (
        variable_global_exists("som_ui_asset")
        && global.config_volume_sons > 0
    ) {
        var som_canal = audio_play_sound(global.som_ui_asset, 100, false);
        audio_sound_gain(som_canal, global.config_volume_sons * 0.34, 0);
        audio_sound_pitch(som_canal, _tom);
    }
};

// O menu usa uma cópia local para desenhar e editar, sincronizada no Step.
config_volume_musica = global.config_volume_musica;
config_volume_sons = global.config_volume_sons;

config_arrastando = -1;

config_baixo_estimulo = global.config_baixo_estimulo;
config_reduzir_animacoes = global.config_reduzir_animacoes;

// 0 = Lenta | 1 = Normal | 2 = Rápida
config_velocidade_texto = global.config_velocidade_texto;

// 0 = Pequeno | 1 = Normal | 2 = Grande
config_tamanho_texto = global.config_tamanho_texto;

// 0 = Normal | 1 = Alto
config_contraste = global.config_contraste;

// Valores anteriores para salvar somente depois de uma alteração real.
config_anterior_musica = config_volume_musica;
config_anterior_sons = config_volume_sons;
config_anterior_baixo = config_baixo_estimulo;
config_anterior_animacoes = config_reduzir_animacoes;
config_anterior_velocidade = config_velocidade_texto;
config_anterior_tamanho = config_tamanho_texto;
config_anterior_contraste = config_contraste;
config_salvar_atraso = 0;

// Linha atualmente selecionada
config_opcao_atual = 0;

// Detectar os controles com o mouse
config_mouse_sobre = -1;


// ─────────────────────────────────────────────
// MÚSICA DO MENU
// ─────────────────────────────────────────────
musica_menu_id = audio_play_sound(
    snd_musica_menu,
    0,
    true
);

audio_sound_gain(
    musica_menu_id,
    config_volume_musica,
    0
);


// ─────────────────────────────────────────────
// DESENHAR UMA FOLHA
// ─────────────────────────────────────────────
desenhar_folha = function(
    _cx,
    _cy,
    _angulo,
    _comprimento,
    _largura,
    _cor,
    _alpha
) {
    var dx = dcos(_angulo);
    var dy = dsin(_angulo);

    var nx = -dy;
    var ny = dx;

    var metade_comp = _comprimento / 2;
    var metade_larg = _largura / 2;

    var ponta_x = _cx + dx * metade_comp;
    var ponta_y = _cy + dy * metade_comp;

    var base_x = _cx - dx * metade_comp;
    var base_y = _cy - dy * metade_comp;

    var lado1_x = _cx + nx * metade_larg;
    var lado1_y = _cy + ny * metade_larg;

    var lado2_x = _cx - nx * metade_larg;
    var lado2_y = _cy - ny * metade_larg;

    draw_set_alpha(_alpha);
    draw_set_color(_cor);

    draw_triangle(
        ponta_x,
        ponta_y,
        lado1_x,
        lado1_y,
        base_x,
        base_y,
        false
    );

    draw_triangle(
        ponta_x,
        ponta_y,
        lado2_x,
        lado2_y,
        base_x,
        base_y,
        false
    );

    // Nervura da folha
    draw_set_alpha(_alpha * 0.65);

    draw_line_width(
        base_x,
        base_y,
        ponta_x,
        ponta_y,
        1
    );
};

// Ramo maior e legivel para os cantos da tela de Ajustes. Ele evita a
// sobreposicao de pequenos icones que, em resolucoes altas, virava uma mancha.
desenhar_raminho_ajustes = function(_x, _y, _espelho, _alpha) {
    var _lado = _espelho ? -1 : 1;
    var _verde_escuro = make_color_rgb(66, 112, 96);
    var _verde_claro = make_color_rgb(116, 168, 139);

    draw_set_alpha(_alpha * 0.88);
    draw_set_color(_verde_escuro);
    draw_line_width(_x, _y, _x + 38 * _lado, _y - 26, 2);
    draw_line_width(_x + 16 * _lado, _y - 11, _x + 12 * _lado, _y - 26, 1);
    draw_line_width(_x + 28 * _lado, _y - 19, _x + 35 * _lado, _y - 34, 1);

    desenhar_folha(_x + 8 * _lado, _y - 7, _espelho ? 205 : 335, 24, 13, _verde_escuro, _alpha);
    desenhar_folha(_x + 14 * _lado, _y - 21, _espelho ? 330 : 210, 26, 14, _verde_claro, _alpha * 0.94);
    desenhar_folha(_x + 28 * _lado, _y - 18, _espelho ? 205 : 335, 25, 13, _verde_escuro, _alpha * 0.96);
    desenhar_folha(_x + 37 * _lado, _y - 32, _espelho ? 330 : 210, 22, 12, _verde_claro, _alpha * 0.90);
};


// ─────────────────────────────────────────────
// AÇÃO DOS BOTÕES
// ─────────────────────────────────────────────
executar_opcao = function(_opcao) {
    switch (_opcao) {

        // NOVO JOGO
        case 0:
            global.dialogue_open = false;
            global.tem_fragmento = false;
            global.tem_espada_fragmento = false;
            global.vida_kiran_max = 100;
            global.vida_kiran = 100;
            global.guardas_recusados = [0, 0, 0, 0];
            global.fragmento_reconhecido = false;
            global.lorun_apresentada = false;
            global.inventario_itens = [];
            global.inventario_armas = [];
            global.inventario_roupas = [];
            global.inventario_colecionaveis = [];
            global.inventario_missoes = [];
            global.inimigos_derrotados = [false, false, false, false];
            global.itens_curativos_coletados = [];
            global.comandante_partiu = false;
            global.comandante_conhecida = false;
            global.encontro_rainha_iniciado = false;
            global.capitulo_concluido = false;
            global.pontos_florakii = 0;
            global.pontos_dahlia = 0;
            global.pontos_neutro = 0;
            global.escolhas_rota_usadas = [];
            global.rotas_identidade_carregadas = true;
            ini_open("soulscapes_rotas.ini");
            ini_section_delete("rotas");
            ini_section_delete("escolhas");
            ini_write_real("rotas", "florakii", 0);
            ini_write_real("rotas", "dahlia", 0);
            ini_write_real("rotas", "neutro", 0);
            ini_close();

            if (variable_global_exists("soul_prepare_new_game")) {
                global.soul_prepare_new_game();
            }

            // Parar a música do menu
            if (audio_is_playing(musica_menu_id)) {
                audio_stop_sound(musica_menu_id);
            }

            room_goto(Room1);
        break;


        // CONTINUAR
        case 1:
            if (
                variable_global_exists("soul_continue_game")
                && global.soul_continue_game()
                && audio_is_playing(musica_menu_id)
            ) {
                audio_stop_sound(musica_menu_id);
            }
        break;


        // CONTA
        case 2:
            mostrando_conta = true;
            mostrando_configuracoes = false;
            mostrando_creditos = false;
            conta_campo_ativo = -1;
            keyboard_string = "";
        break;

        // CONFIGURAÇÕES
        case 3:
            mostrando_configuracoes = true;
            mostrando_creditos = false;
            mostrando_conta = false;
        break;


        // CRÉDITOS
        case 4:
            mostrando_creditos = true;
            mostrando_configuracoes = false;
            mostrando_conta = false;
        break;
    }
};
