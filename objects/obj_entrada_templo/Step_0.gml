// ═════════════════════════════════════════════
// IMPEDIR EXECUÇÃO DURANTE A TRANSIÇÃO
// ═════════════════════════════════════════════
if (entrando_templo) {
    exit;
}


// ═════════════════════════════════════════════
// PAUSA
// ═════════════════════════════════════════════
if (
    variable_global_exists("jogo_pausado")
    && global.jogo_pausado
) {
    pode_interagir = false;
    exit;
}


// ═════════════════════════════════════════════
// VERIFICAR SE KIRAN EXISTE
// ═════════════════════════════════════════════
if (!instance_exists(obj_Kiran)) {
    pode_interagir = false;
    exit;
}


// Encontrar o Kiran
var jogador = instance_nearest(
    x,
    y,
    obj_Kiran
);


// Verificar distância
pode_interagir =
    point_distance(
        x,
        y,
        jogador.x,
        jogador.y
    )
    <= distancia_interacao;


// ═════════════════════════════════════════════
// NÃO INTERAGIR DURANTE DIÁLOGOS
// ═════════════════════════════════════════════
if (
    variable_global_exists("dialogue_open")
    && global.dialogue_open
) {
    exit;
}


// ═════════════════════════════════════════════
// APERTAR E NA ENTRADA
// ═════════════════════════════════════════════
if (
    pode_interagir
    && keyboard_check_pressed(ord("E"))
) {
    var entrada_liberada =
        variable_global_exists("fragmento_reconhecido")
        && global.fragmento_reconhecido;


    // ─────────────────────────────────────────
    // ENTRADA LIBERADA
    // ─────────────────────────────────────────
    if (entrada_liberada) {
        entrando_templo = true;

        if (variable_global_exists("dialogue_open")) {
            global.dialogue_open = false;
        }

        if (variable_global_exists("jogo_pausado")) {
            global.jogo_pausado = false;
        }

        room_goto(rm_templo);
    }


    // ─────────────────────────────────────────
    // ENTRADA AINDA BLOQUEADA
    // ─────────────────────────────────────────
    else {
        var controlador_dialogo =
            instance_find(obj_dialogo, 0);

        if (controlador_dialogo != noone) {
            with (controlador_dialogo) {
                iniciar_dialogo([
                    {
                        nome: "Kiran",
                        texto: "A entrada parece estar selada..."
                    },
                    {
                        nome: "Kiran",
                        texto: "Talvez Lorun saiba o que fazer."
                    }
                ]);
            }
        }
        else {
            show_debug_message(
                "ERRO: não existe obj_dialogo na Room1."
            );
        }
    }
}