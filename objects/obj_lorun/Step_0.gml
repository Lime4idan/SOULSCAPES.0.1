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
            "Você acordou...",
            "Eu estava começando a achar que não abriria os olhos.",
            "Consegue ficar de pé?"
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
        dialogo.texto = "O que devo perguntar?";

        dialogo.iniciar_escolha(
            [
                "Quem é você?",
                "Onde estamos?",
                "O que aconteceu comigo?"
            ],
            [
                [
                    {
                        nome: "???",
                        texto: "Quem é você?"
                    },
                    {
                        nome: "Lorun",
                        texto: "Meu nome é Lorun. Eu vivo nesta floresta."
                    }
                ],

                [
                    {
                        nome: "???",
                        texto: "Onde estamos?"
                    },
                    {
                        nome: "Lorun",
                        texto: "Nas ruínas de Velmora. A floresta cresceu sobre o que restou."
                    }
                ],

                [
                    {
                        nome: "???",
                        texto: "O que aconteceu comigo?"
                    },
                    {
                        nome: "Lorun",
                        texto: "Eu ainda não sei. Encontrei você desacordado perto das ruínas."
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
                texto: "Espere... onde você encontrou isso?"
            },
            {
                nome: "???",
                texto: "Estava mais adiante, perto da água."
            },
            {
                nome: "Lorun",
                texto: "É um fragmento de vitral antigo."
            },
            {
                nome: "Lorun",
                texto: "Existe uma passagem adiante que reage à luz dele."
            },
            {
                nome: "Lorun",
                texto: "Leve-o até lá. Talvez ele mostre o caminho."
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