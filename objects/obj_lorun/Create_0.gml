distancia_interacao = 160;
pode_interagir = false;
conversa_finalizada = false;
etapa_conversa = 0;
fragmento_reconhecido = false;
opcao_fragmento_indice = -1;

// Flutuação apenas visual: a posição real continua fixa para não alterar
// a distância de interação nem qualquer futura colisão.
lorun_aura_tempo = random(1000);
lorun_flutuar_y = 0;
lorun_flutuar_altura = 7;
lorun_flutuar_velocidade = 0.045;

if (!variable_global_exists("tem_fragmento")) {
    global.tem_fragmento = false;
}

if (!variable_global_exists("fragmento_reconhecido")) {
    global.fragmento_reconhecido = false;
}

if (!variable_global_exists("lorun_apresentada")) {
    global.lorun_apresentada = false;
}

etapa_conversa = global.lorun_apresentada ? 10 : 0;

fala_lorun = function(_nome, _texto) {
    return { nome: _nome, texto: _texto };
};

opcao_rota_lorun = function(_id, _texto, _rota) {
    return { id: _id, texto: _texto, rota: _rota, pontos: 1 };
};

lorun_intro = [
    fala_lorun("Narração", "Kiran entra no templo. O lugar está silencioso. Há pedaços de vitral espalhados pelo chão."),
    fala_lorun("Lorun", "Ei."),
    fala_lorun("Kiran", "...!"),
    fala_lorun("Lorun", "Calma. Eu não vou atacar você."),
    fala_lorun("Kiran", "Quem é você?"),
    fala_lorun("Lorun", "Lorun."),
    fala_lorun("Kiran", "Você mora aqui?"),
    fala_lorun("Lorun", "Não exatamente. Mas venho aqui quando preciso de silêncio."),
    fala_lorun("Kiran", "Então eu interrompi?"),
    fala_lorun("Lorun", "Um pouco. Mas acho que você precisava mais dele do que eu."),
    fala_lorun("Kiran", "..."),
    fala_lorun("Lorun", "Você parece perdido."),
    fala_lorun("Kiran", "Eu estou."),
    fala_lorun("Lorun", "Imaginei.")
];

lorun_opcoes1 = [
    opcao_rota_lorun("lorun_contato_florakii", "Você é Florakii?", "florakii"),
    opcao_rota_lorun("lorun_contato_neutro", "Onde eu estou?", "neutro"),
    opcao_rota_lorun("lorun_contato_dahlia", "Este templo pertence à Rainha?", "dahlia")
];

lorun_rotas1 = [
    [
        fala_lorun("Kiran", "Você é Florakii?"),
        fala_lorun("Lorun", "Sou."),
        fala_lorun("Kiran", "Uma pessoa lá fora achou que eu também era. Por causa do meu tamanho... e deste broto."),
        fala_lorun("Lorun", "Seu broto não decide sua espécie. Mas é um broto bonito."),
        fala_lorun("Kiran", "Obrigado... eu acho.")
    ],
    [
        fala_lorun("Kiran", "Onde eu estou?"),
        fala_lorun("Lorun", "Num templo antigo de Velmora."),
        fala_lorun("Kiran", "Velmora?"),
        fala_lorun("Lorun", "A floresta lá fora."),
        fala_lorun("Kiran", "Nunca ouvi esse nome."),
        fala_lorun("Lorun", "Então você está ainda mais perdido do que pensei."),
        fala_lorun("Kiran", "Ótimo."),
        fala_lorun("Lorun", "Podia ser pior."),
        fala_lorun("Kiran", "Como?"),
        fala_lorun("Lorun", "Você podia estar perdido sozinho.")
    ],
    [
        fala_lorun("Kiran", "Este templo pertence à Rainha?"),
        fala_lorun("Lorun", "Pertence a Velmora. A Rainha apenas ordenou que ele fosse vigiado."),
        fala_lorun("Kiran", "Então os guardas cumprem uma ordem."),
        fala_lorun("Lorun", "Alguns cumprem por dever. Outros, por medo do que pode despertar aqui.")
    ]
];

lorun_continuacao = [
    fala_lorun("Narração", "Lorun observa Kiran por alguns instantes."),
    fala_lorun("Lorun", "Posso perguntar uma coisa?"),
    fala_lorun("Kiran", "Depende."),
    fala_lorun("Lorun", "Justo. Você sabe de onde veio?"),
    fala_lorun("Kiran", "Não."),
    fala_lorun("Lorun", "Sua espécie?"),
    fala_lorun("Kiran", "Também não."),
    fala_lorun("Lorun", "Família?"),
    fala_lorun("Kiran", "... Não lembro."),
    fala_lorun("Lorun", "Entendi."),
    fala_lorun("Kiran", "Não, não entendeu. Todo mundo olha para mim e parece decidir alguma coisa. Florakii. Dahlia. Invasor. Estranho. E eu nem sei o que sou."),
    fala_lorun("Narração", "Lorun fica em silêncio por um momento."),
    fala_lorun("Lorun", "Então não decide ainda."),
    fala_lorun("Kiran", "O quê?"),
    fala_lorun("Lorun", "O que você é."),
    fala_lorun("Kiran", "Mas eu preciso saber."),
    fala_lorun("Lorun", "Talvez um dia. Mas não precisa descobrir tudo hoje."),
    fala_lorun("Kiran", "É fácil falar."),
    fala_lorun("Lorun", "É. Por isso não estou dizendo que é fácil fazer.")
];

lorun_opcoes2 = [
    opcao_rota_lorun("lorun_identidade_dahlia", "Minhas roupas são Dahlia. Isso significa alguma coisa?", "dahlia"),
    opcao_rota_lorun("lorun_identidade_neutro", "Não quero que nenhum dos dois decida por mim.", "neutro"),
    opcao_rota_lorun("lorun_identidade_florakii", "Talvez eu seja Florakii.", "florakii")
];

lorun_rotas2 = [
    [
        fala_lorun("Kiran", "Minhas roupas são Dahlia. Isso significa alguma coisa?"),
        fala_lorun("Lorun", "Significa que você está usando roupas Dahlia."),
        fala_lorun("Kiran", "Só isso?"),
        fala_lorun("Lorun", "Por enquanto.")
    ],
    [
        fala_lorun("Kiran", "Não quero que nenhum dos dois decida por mim."),
        fala_lorun("Lorun", "Então não deixe."),
        fala_lorun("Kiran", "É mais fácil falar."),
        fala_lorun("Lorun", "Eu sei.")
    ],
    [
        fala_lorun("Kiran", "Talvez eu seja Florakii."),
        fala_lorun("Lorun", "Talvez."),
        fala_lorun("Kiran", "Você não saberia reconhecer?"),
        fala_lorun("Lorun", "Reconhecer alguém não é a mesma coisa que decidir quem essa pessoa é.")
    ]
];

lorun_vitral_intro = [
    fala_lorun("Narração", "Uma luz fraca atravessa o vitral quebrado e responde à presença de Kiran."),
    fala_lorun("Kiran", "Ele fez isso antes."),
    fala_lorun("Lorun", "Então talvez esteja tentando lembrar de você.")
];

lorun_opcoes3 = [
    opcao_rota_lorun("lorun_vitral_neutro", "Quero descobrir sozinho por que ele reage a mim.", "neutro"),
    opcao_rota_lorun("lorun_vitral_florakii", "A floresta está tentando falar comigo?", "florakii"),
    opcao_rota_lorun("lorun_vitral_dahlia", "A Rainha sabe que o vitral faz isso?", "dahlia")
];

lorun_rotas3 = [
    [
        fala_lorun("Kiran", "Quero descobrir sozinho por que ele reage a mim."),
        fala_lorun("Lorun", "Tudo bem. Só não confunda descobrir sozinho com precisar enfrentar tudo sozinho.")
    ],
    [
        fala_lorun("Kiran", "A floresta está tentando falar comigo?"),
        fala_lorun("Lorun", "Talvez."),
        fala_lorun("Kiran", "Ela fala?"),
        fala_lorun("Lorun", "Nem sempre com palavras.")
    ],
    [
        fala_lorun("Kiran", "A Rainha sabe que o vitral faz isso?"),
        fala_lorun("Lorun", "Provavelmente sabe mais sobre ele do que eu."),
        fala_lorun("Kiran", "Então preciso encontrá-la.")
    ]
];

lorun_oferendas_intro = [
    fala_lorun("Lorun", "Há partes deste templo que não respondem apenas ao vitral."),
    fala_lorun("Lorun", "Existem quatro oferendas antigas espalhadas por Velmora. Os guardas e o bosque não vão entregá-las sem questionar suas intenções.")
];

lorun_opcoes4 = [
    opcao_rota_lorun("lorun_oferendas_dahlia", "Os guardas receberam ordens para protegê-las?", "dahlia"),
    opcao_rota_lorun("lorun_oferendas_florakii", "Se pertencem à floresta, por que alguém está guardando elas?", "florakii"),
    opcao_rota_lorun("lorun_oferendas_neutro", "Só preciso delas para descobrir o que está acontecendo comigo.", "neutro")
];

lorun_rotas4 = [
    [
        fala_lorun("Kiran", "Os guardas receberam ordens para protegê-las?"),
        fala_lorun("Lorun", "Sim. Alguns acreditam na ordem. Outros temem o que acontece se deixarem de obedecer.")
    ],
    [
        fala_lorun("Kiran", "Se pertencem à floresta, por que alguém está guardando elas?"),
        fala_lorun("Lorun", "Porque proteger e possuir parecem a mesma coisa para quem nunca perguntou à floresta.")
    ],
    [
        fala_lorun("Kiran", "Só preciso delas para descobrir o que está acontecendo comigo."),
        fala_lorun("Lorun", "Então procure respostas. Mas lembre que nem todo mundo no seu caminho precisa virar inimigo.")
    ]
];

lorun_final = [
    fala_lorun("Lorun", "Kiran."),
    fala_lorun("Kiran", "Hm?"),
    fala_lorun("Lorun", "Se alguém disser que sabe exatamente o que você é... não precisa acreditar só porque essa pessoa parece ter certeza."),
    fala_lorun("Kiran", "Nem em você?"),
    fala_lorun("Lorun", "Principalmente em mim."),
    fala_lorun("Kiran", "..."),
    fala_lorun("Lorun", "Vai no seu tempo. Eu continuo aqui quando voltar.")
];


// Abre os assuntos repetíveis da Lorun.
// A opção da lâmina só aparece depois que o fragmento foi encontrado.
abrir_assuntos_lorun = function(_dialogo) {
    var _opcoes = [
        "Conversar um pouco",
        "Perguntar sobre a floresta",
        "Perguntar sobre as ruínas",
        "Perguntar sobre os perigos"
    ];

    var _respostas = [
        [
            {
                nome: "Kiran",
                texto: "Podemos conversar um pouco?"
            },
            {
                nome: "Lorun",
                texto: "Claro. A floresta fica menos silenciosa quando você está por perto."
            }
        ],
        [
            {
                nome: "Kiran",
                texto: "O que você sabe sobre esta floresta?"
            },
            {
                nome: "Lorun",
                texto: "Ela guarda memórias antigas. Algumas flores até brilham quando se lembram de alguém."
            }
        ],
        [
            {
                nome: "Kiran",
                texto: "E aquelas ruínas?"
            },
            {
                nome: "Lorun",
                texto: "São o que restou de Velmora. A floresta cresceu ao redor delas para protegê-las."
            }
        ],
        [
            {
                nome: "Kiran",
                texto: "Tem mais alguém nesta floresta?"
            },
            {
                nome: "Lorun",
                texto: "Tem. Os guardas da Rainha vigiam caminhos e oferendas por toda parte. Eles desconfiam de qualquer desconhecido."
            },
            {
                nome: "Lorun",
                texto: "Você também pode encontrar Florakii protegendo memórias do bosque. Nem todos querem machucar você, então converse antes de erguer a lâmina."
            },
            {
                nome: "Lorun",
                texto: "Se alguém bloquear seu caminho, escute primeiro. Você sempre pode recuar e voltar quando estiver preparado."
            }
        ]
    ];

    opcao_fragmento_indice = -1;

    if (global.tem_fragmento) {
        opcao_fragmento_indice = array_length(_opcoes);

        if (!global.fragmento_reconhecido) {
            _opcoes[opcao_fragmento_indice] = "Mostrar a nova espada";
            _respostas[opcao_fragmento_indice] = [
                {
                    nome: "Kiran",
                    texto: "Encontrei um fragmento perto da água. Ele se transformou nesta espada."
                },
                {
                    nome: "Lorun",
                    texto: "Esta lâmina nasceu de um vitral antigo. A luz dentro dela ainda está viva."
                },
                {
                    nome: "Lorun",
                    texto: "Talvez ele reaja a alguma coisa dentro do templo."
                }
            ];
        }
        else {
            _opcoes[opcao_fragmento_indice] = "Perguntar sobre a lâmina";
            _respostas[opcao_fragmento_indice] = [
                {
                    nome: "Kiran",
                    texto: "Você descobriu mais alguma coisa sobre esta lâmina?"
                },
                {
                    nome: "Lorun",
                    texto: "Ela parece responder às memórias guardadas nas ruínas. Talvez revele novas formas com o tempo."
                }
            ];
        }
    }

    _dialogo.nome_falante = "Kiran";
    _dialogo.texto = "Sobre o que quero conversar?";
    _dialogo.iniciar_escolha(
        _opcoes,
        _respostas,
        "lorun_assuntos"
    );
};
