// ═════════════════════════════════════════════
// GARANTIR INVENTÁRIO DOS CACOS
// ═════════════════════════════════════════════
if (!variable_global_exists("fragmentos_vitral")) {
    global.fragmentos_vitral = [
        false,
        false,
        false,
        false
    ];
}


// ═════════════════════════════════════════════
// PAUSA
// ═════════════════════════════════════════════
if (
    variable_global_exists("jogo_pausado")
    && global.jogo_pausado
) {
    exit;
}


// ═════════════════════════════════════════════
// VERIFICAR KIRAN
// ═════════════════════════════════════════════
if (!instance_exists(obj_Kiran)) {
    perto_do_vitral = false;
    exit;
}

var jogador = instance_nearest(
    x,
    y,
    obj_Kiran
);


// ═════════════════════════════════════════════
// PUZZLE FECHADO
// ═════════════════════════════════════════════
if (!puzzle_ativo) {
    perto_do_vitral =
        point_distance(
            x,
            y,
            jogador.x,
            jogador.y
        )
        <= distancia_interacao;


    var dialogo_aberto =
        variable_global_exists("dialogue_open")
        && global.dialogue_open;


    if (
        perto_do_vitral
        && !global.vitral_resolvido
        && !dialogo_aberto
        && keyboard_check_pressed(ord("E"))
    ) {
        puzzle_ativo = true;
        peca_arrastada = -1;

        global.dialogue_open = true;
    }

    exit;
}


// Enquanto estiver aberto, manter o personagem parado
global.dialogue_open = true;


// ═════════════════════════════════════════════
// ANIMAÇÃO
// ═════════════════════════════════════════════
if (!global.config_reduzir_animacoes) {
    tempo_puzzle += 0.06;
}


// ═════════════════════════════════════════════
// CONCLUSÃO DO PUZZLE
// ═════════════════════════════════════════════
if (concluindo_puzzle) {
    tempo_conclusao--;

    if (tempo_conclusao <= 0) {
        concluindo_puzzle = false;
        puzzle_ativo = false;

        global.dialogue_open = false;


        var controlador_dialogo =
            instance_find(
                obj_dialogo,
                0
            );

        if (controlador_dialogo != noone) {
            with (controlador_dialogo) {
                iniciar_dialogo([
                    {
                        nome: "Kiran",
                        texto: "Os fragmentos voltaram ao lugar..."
                    },
                    {
                        nome: "Kiran",
                        texto: "Há alguma coisa escondida nessa luz."
                    }
                ]);
            }
        }
    }

    exit;
}


// ═════════════════════════════════════════════
// MOUSE NA GUI
// ═════════════════════════════════════════════
var mouse_gui_x =
    device_mouse_x_to_gui(0);

var mouse_gui_y =
    device_mouse_y_to_gui(0);


// ═════════════════════════════════════════════
// SAIR DO PUZZLE
// ═════════════════════════════════════════════
if (
    keyboard_check_pressed(vk_escape)
    || keyboard_check_pressed(vk_backspace)
) {
    for (
        var sair_i = 0;
        sair_i < array_length(peca_colocada);
        sair_i++
    ) {
        if (
            global.fragmentos_vitral[sair_i]
            && !peca_colocada[sair_i]
        ) {
            peca_x[sair_i] =
                peca_inicio_x[sair_i];

            peca_y[sair_i] =
                peca_inicio_y[sair_i];
        }
    }

    peca_arrastada = -1;
    puzzle_ativo = false;

    global.dialogue_open = false;

    exit;
}


// ═════════════════════════════════════════════
// PEGAR UMA PEÇA
// ═════════════════════════════════════════════
if (mouse_check_button_pressed(mb_left)) {
    peca_arrastada = -1;

    for (
        var pegar_i =
            array_length(peca_colocada) - 1;

        pegar_i >= 0;

        pegar_i--
    ) {
        if (
            global.fragmentos_vitral[pegar_i]
            && !peca_colocada[pegar_i]
        ) {
            var distancia_mouse =
                point_distance(
                    mouse_gui_x,
                    mouse_gui_y,
                    peca_x[pegar_i],
                    peca_y[pegar_i]
                );

            if (distancia_mouse <= raio_clique) {
                peca_arrastada = pegar_i;

                offset_mouse_x =
                    peca_x[pegar_i]
                    - mouse_gui_x;

                offset_mouse_y =
                    peca_y[pegar_i]
                    - mouse_gui_y;

                break;
            }
        }
    }
}


// ═════════════════════════════════════════════
// ARRASTAR
// ═════════════════════════════════════════════
if (
    peca_arrastada != -1
    && mouse_check_button(mb_left)
) {
    peca_x[peca_arrastada] = clamp(
        mouse_gui_x + offset_mouse_x,
        180,
        1100
    );

    peca_y[peca_arrastada] = clamp(
        mouse_gui_y + offset_mouse_y,
        175,
        675
    );
}


// ═════════════════════════════════════════════
// SOLTAR
// ═════════════════════════════════════════════
if (
    peca_arrastada != -1
    && mouse_check_button_released(mb_left)
) {
    var solta_i = peca_arrastada;

    var distancia_do_alvo =
        point_distance(
            peca_x[solta_i],
            peca_y[solta_i],
            peca_alvo_x[solta_i],
            peca_alvo_y[solta_i]
        );


    // Encaixou
    if (distancia_do_alvo <= distancia_encaixe) {
        peca_x[solta_i] =
            peca_alvo_x[solta_i];

        peca_y[solta_i] =
            peca_alvo_y[solta_i];

        peca_colocada[solta_i] = true;
    }


    // Lugar errado
    else {
        peca_x[solta_i] =
            peca_inicio_x[solta_i];

        peca_y[solta_i] =
            peca_inicio_y[solta_i];
    }


    peca_arrastada = -1;


    // ═════════════════════════════════════════
    // VERIFICAR CONCLUSÃO
    // ═════════════════════════════════════════
    var terminou = true;

    for (
        var verificar_i = 0;
        verificar_i < array_length(peca_colocada);
        verificar_i++
    ) {
        if (
            !global.fragmentos_vitral[verificar_i]
            || !peca_colocada[verificar_i]
        ) {
            terminou = false;
            break;
        }
    }


    if (terminou) {
        global.vitral_resolvido = true;

        concluindo_puzzle = true;
        tempo_conclusao = 100;
    }
}