pode_interagir = false;

var jogador = instance_nearest(x, y, obj_Kiran);

if (instance_exists(jogador)) {
    var distancia = point_distance(x, y, jogador.x, jogador.y);

    if (distancia <= distancia_interacao) {
        pode_interagir = true;
    }
}

// ─────────────────────────────────────────────
// ETAPA 0: PRIMEIRO ENCONTRO
// ─────────────────────────────────────────────
if (
    etapa_conversa == 0
    && pode_interagir
    && !global.dialogue_open
    && keyboard_check_pressed(ord("E"))
) {
    var dialogo = instance_find(obj_dialogo, 0);

    if (instance_exists(dialogo)) {
        etapa_conversa = 1;

        dialogo.iniciar_dialogo_com_nome("Lorun", [
            "You are awake...",
            "I was beginning to think you would never open your eyes.",
            "Can you stand?"
        ]);
    }
}

// ─────────────────────────────────────────────
// ETAPA 1: ABRE AS ESCOLHAS
// ─────────────────────────────────────────────
else if (
    etapa_conversa == 1
    && !global.dialogue_open
) {
    var dialogo = instance_find(obj_dialogo, 0);

    if (instance_exists(dialogo)) {
        etapa_conversa = 2;

        dialogo.nome_falante = "???";
        dialogo.texto = "What should I ask?";

        dialogo.iniciar_escolha(
            [
                "Who are you?",
                "Where are we?",
                "What happened to me?"
            ],
            [
                [
                    {
                        nome: "???",
                        texto: "Who are you?"
                    },
                    {
                        nome: "Lorun",
                        texto: "My name is Lorun. I live in this forest."
                    }
                ],

                [
                    {
                        nome: "???",
                        texto: "Where are we?"
                    },
                    {
                        nome: "Lorun",
                        texto: "In the ruins of Velmora. The forest grew over what remained."
                    }
                ],

                [
                    {
                        nome: "???",
                        texto: "What happened to me?"
                    },
                    {
                        nome: "Lorun",
                        texto: "I still do not know. I found you unconscious near the ruins."
                    }
                ]
            ]
        );
    }
}

// ─────────────────────────────────────────────
// ETAPA 2: ESPERA O JOGADOR PEGAR O FRAGMENTO
// ─────────────────────────────────────────────
else if (
    etapa_conversa == 2
    && !global.dialogue_open
) {
    etapa_conversa = 3;
}

// ─────────────────────────────────────────────
// ETAPA 3: JOGADOR VOLTA COM O FRAGMENTO
// ─────────────────────────────────────────────
else if (
    etapa_conversa == 3
    && global.tem_fragmento
    && pode_interagir
    && !global.dialogue_open
    && keyboard_check_pressed(ord("E"))
) {
    var dialogo = instance_find(obj_dialogo, 0);

    if (instance_exists(dialogo)) {
        etapa_conversa = 4;

        dialogo.iniciar_dialogo([
            {
                nome: "Lorun",
                texto: "Wait... where did you find that?"
            },
            {
                nome: "???",
                texto: "Farther ahead, near the water."
            },
            {
                nome: "Lorun",
                texto: "It is a fragment of an ancient stained-glass window."
            },
            {
                nome: "Lorun",
                texto: "There is a passage ahead that reacts to its light."
            },
            {
                nome: "Lorun",
                texto: "Take it there. Maybe it will reveal the way."
            }
        ]);
    }
}

// ─────────────────────────────────────────────
// ETAPA 4: ENCERRA A CONVERSA SOBRE O FRAGMENTO
// ─────────────────────────────────────────────
else if (
    etapa_conversa == 4
    && !global.dialogue_open
) {
    etapa_conversa = 5;
    conversa_finalizada = true;
    global.fragmento_reconhecido = true;
}
