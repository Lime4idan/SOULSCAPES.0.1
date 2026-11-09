if (global.comandante_partiu) {
    instance_destroy();
    exit;
}

var comandante_pausada =
    variable_global_exists("jogo_pausado")
    && global.jogo_pausado;

if (!comandante_pausada && !global.config_reduzir_animacoes) {
    tempo_visual += 0.045;
}

// Espera a última fala terminar antes de começar a subir a escada.
if (estado_comandante == 1) {
    pode_interagir = false;

    if (!global.dialogue_open) {
        estado_comandante = 2;
    }

    exit;
}

// A escada sobe para a direita no cenário. A comandante acompanha essa
// diagonal e desaparece aos poucos antes de sair do enquadramento.
if (estado_comandante == 2) {
    pode_interagir = false;

    if (!comandante_pausada) {
        var velocidade_saida = global.config_reduzir_animacoes ? 2.35 : 1.35;
        x += velocidade_saida * 0.52;
        y -= velocidade_saida;

        if (y < 445) {
            image_alpha = max(0, image_alpha - 0.018);
        }

        if (y <= 375 || image_alpha <= 0) {
            global.comandante_partiu = true;
            instance_destroy();
        }
    }

    exit;
}

pode_interagir = false;

if (instance_exists(obj_Kiran)) {
    var jogador = instance_nearest(x, y, obj_Kiran);
    pode_interagir = point_distance(x, y, jogador.x, jogador.y)
        <= distancia_interacao;
}

if (
    comandante_pausada
    || global.dialogue_open
    || !pode_interagir
    || current_time < global.interacao_bloqueada_ate
    || !(
        keyboard_check_pressed(ord("E"))
        || (variable_global_exists("mobile_interact_pressed") && global.mobile_interact_pressed)
    )
) {
    exit;
}

var dialogo = instance_find(obj_dialogo, 0);
if (!instance_exists(dialogo)) exit;

global.interacao_bloqueada_ate = current_time + 140;
var restantes = oferendas_restantes();

if (restantes <= 0) {
    estado_comandante = 1;
    dialogo.iniciar_dialogo([
        {
            nome: "Comandante da Rainha",
            texto: "As quatro oferendas foram devolvidas... e todos os fragmentos despertaram. Então os rumores sobre a luz que você carrega eram verdadeiros."
        },
        {
            nome: "Kiran",
            texto: "Vai continuar bloqueando meu caminho?"
        },
        {
            nome: "Comandante da Rainha",
            texto: "Não. Há algo em você que estes vitrais não deveriam reconhecer — algo que a própria floresta tentou esquecer."
        },
        {
            nome: "Comandante da Rainha",
            texto: "Suba, se tiver coragem. Eu retornarei à Rainha e direi a ela que Kiran voltou."
        }
    ]);
}
else if (!global.comandante_conhecida) {
    global.comandante_conhecida = true;
    var controlador_encontro = instance_find(obj_pause, 0);

    if (
        instance_exists(controlador_encontro)
        && variable_instance_exists(controlador_encontro, "iniciar_encontro_roteiro")
    ) {
        controlador_encontro.iniciar_encontro_roteiro(1);
    }
    else {
        dialogo.iniciar_dialogo([
            {
                nome: "Comandante da Rainha",
                texto: "Você aí. Pare. Por ordem da Rainha, ninguém sobe esta escadaria."
            }
        ]);
    }
}
else {
    var lembrete = restantes == 1
        ? "Uma oferenda ainda não retornou ao seu relicário. Esta escadaria permanece fechada."
        : string(restantes) + " oferendas ainda não retornaram aos relicários. Esta escadaria permanece fechada.";

    dialogo.iniciar_dialogo([
        {
            nome: "Comandante da Rainha",
            texto: lembrete
        },
        {
            nome: "Comandante da Rainha",
            texto: "Vencer meus oficiais não é suficiente. Devolva cada oferenda e deixe os quatro fragmentos responderem à sua luz."
        }
    ]);
}
