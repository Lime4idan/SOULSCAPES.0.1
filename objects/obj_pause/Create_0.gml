display_set_gui_size(1280, 811);

// O jogo sempre começa despausado
global.jogo_pausado = false;


// ═════════════════════════════════════════════
// CONFIGURAÇÕES GLOBAIS
// ═════════════════════════════════════════════
// Também carregar aqui permite testar uma room diretamente pelo GameMaker,
// sem precisar passar pelo menu inicial.
if (!variable_global_exists("configuracoes_carregadas")) {
    ini_open("soulscapes_config.ini");
    global.config_volume_musica = clamp(ini_read_real("audio", "musica", 0.80), 0, 1);
    global.config_volume_sons = clamp(ini_read_real("audio", "sons", 0.70), 0, 1);
    global.config_baixo_estimulo = ini_read_real("acessibilidade", "baixo_estimulo", 0) >= 0.5;
    global.config_reduzir_animacoes = ini_read_real("acessibilidade", "reduzir_animacoes", 0) >= 0.5;
    global.config_velocidade_texto = clamp(round(ini_read_real("texto", "velocidade", 1)), 0, 2);
    global.config_tamanho_texto = clamp(round(ini_read_real("texto", "tamanho", 1)), 0, 2);
    global.config_contraste = clamp(round(ini_read_real("acessibilidade", "contraste", 0)), 0, 1);
    ini_close();
    global.configuracoes_carregadas = true;
}

if (!variable_global_exists("salvar_configuracoes")) {
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
}

if (!variable_global_exists("tocar_som_ui")) {
    global.tocar_som_ui = function(_tom) {
        // Em testes diretos de room, o som é criado ao retornar ao menu.
    };
}

if (!variable_global_exists("interacao_bloqueada_ate")) {
    global.interacao_bloqueada_ate = 0;
}

if (!variable_global_exists("config_volume_musica")) {
    global.config_volume_musica = 0.80;
}

if (!variable_global_exists("config_volume_sons")) {
    global.config_volume_sons = 0.70;
}

if (!variable_global_exists("config_baixo_estimulo")) {
    global.config_baixo_estimulo = false;
}

if (!variable_global_exists("config_reduzir_animacoes")) {
    global.config_reduzir_animacoes = false;
}

if (!variable_global_exists("config_velocidade_texto")) {
    global.config_velocidade_texto = 1;
}

if (!variable_global_exists("config_tamanho_texto")) {
    global.config_tamanho_texto = 1;
}

if (!variable_global_exists("config_contraste")) {
    global.config_contraste = 0;
}

config_anterior_musica = global.config_volume_musica;
config_anterior_sons = global.config_volume_sons;
config_anterior_baixo = global.config_baixo_estimulo;
config_anterior_animacoes = global.config_reduzir_animacoes;
config_anterior_velocidade = global.config_velocidade_texto;
config_anterior_tamanho = global.config_tamanho_texto;
config_anterior_contraste = global.config_contraste;
config_salvar_atraso = 0;


// ═════════════════════════════════════════════
// IDENTIDADE OCULTA DE KIRAN
// ═════════════════════════════════════════════
// A rota nunca é exibida ao jogador. O INI mantém os pontos e as escolhas
// únicas enquanto o save geral do projeto ainda não está disponível.
if (!variable_global_exists("rotas_identidade_carregadas")) {
    ini_open("soulscapes_rotas.ini");
    global.pontos_florakii = max(0, ini_read_real("rotas", "florakii", 0));
    global.pontos_dahlia = max(0, ini_read_real("rotas", "dahlia", 0));
    global.pontos_neutro = max(0, ini_read_real("rotas", "neutro", 0));
    ini_close();
    global.escolhas_rota_usadas = [];
    global.rotas_identidade_carregadas = true;
}

global.salvar_rotas_identidade = function() {
    ini_open("soulscapes_rotas.ini");
    ini_write_real("rotas", "florakii", global.pontos_florakii);
    ini_write_real("rotas", "dahlia", global.pontos_dahlia);
    ini_write_real("rotas", "neutro", global.pontos_neutro);
    ini_close();
};

global.escolha_rota_ja_pontuou = function(_id_escolha) {
    if (_id_escolha == "") return false;

    for (var rota_usada_i = 0;
        rota_usada_i < array_length(global.escolhas_rota_usadas);
        rota_usada_i++
    ) {
        if (global.escolhas_rota_usadas[rota_usada_i] == _id_escolha) {
            return true;
        }
    }

    ini_open("soulscapes_rotas.ini");
    var rota_ja_usada = ini_read_real("escolhas", _id_escolha, 0) >= 0.5;
    ini_close();

    if (rota_ja_usada) array_push(global.escolhas_rota_usadas, _id_escolha);
    return rota_ja_usada;
};

global.adicionar_ponto_rota = function(_rota, _valor, _id_escolha) {
    var rota_valor = is_undefined(_valor) ? 1 : max(0, _valor);
    var rota_id = is_undefined(_id_escolha) ? "" : _id_escolha;

    if (rota_id != "" && global.escolha_rota_ja_pontuou(rota_id)) {
        return false;
    }

    switch (string_lower(_rota)) {
        case "florakii": global.pontos_florakii += rota_valor; break;
        case "dahlia": global.pontos_dahlia += rota_valor; break;
        case "neutro": global.pontos_neutro += rota_valor; break;
        default: return false;
    }

    if (rota_id != "") {
        array_push(global.escolhas_rota_usadas, rota_id);
        ini_open("soulscapes_rotas.ini");
        ini_write_real("escolhas", rota_id, 1);
        ini_close();
    }

    global.salvar_rotas_identidade();
    return true;
};

global.obter_rota_atual = function() {
    var rota_f = global.pontos_florakii;
    var rota_d = global.pontos_dahlia;
    var rota_n = global.pontos_neutro;

    if (rota_f > rota_d && rota_f > rota_n) return "florakii";
    if (rota_d > rota_f && rota_d > rota_n) return "dahlia";
    if (rota_n > rota_f && rota_n > rota_d) return "neutro";
    return "neutro";
};

// Benefício secreto da rota pacifista: não basta Neutro estar na frente.
// Nenhuma escolha Florakii ou Dahlia pode ter sido registrada na partida.
global.rota_neutra_pura = function() {
    return global.pontos_neutro > 0
        && global.pontos_florakii <= 0
        && global.pontos_dahlia <= 0;
};


// ═════════════════════════════════════════════
// INVENTÁRIO EXPANSÍVEL
// ═════════════════════════════════════════════
// Cada conteúdo futuro pode ser adicionado com:
// array_push(global.inventario_armas, global.inventario_criar_item(...));
// Assim, novas armas, roupas e itens entram na mesma interface.
if (!variable_global_exists("inventario_criar_item")) {
    global.inventario_criar_item = function(
        _nome,
        _descricao,
        _detalhe,
        _quantidade,
        _cor,
        _icone
    ) {
        return {
            id: _nome,
            nome: _nome,
            descricao: _descricao,
            detalhe: _detalhe,
            quantidade: _quantidade,
            cor: _cor,
            icone: _icone,
            bloqueado: false,
            categoria: "geral",
            consumivel: false,
            cura: 0,
            usavel_mapa: false,
            usavel_batalha: false,
            raridade: "Comum",
            sprite_item: -1
        };
    };
}

if (!variable_global_exists("inventario_itens")) {
    global.inventario_itens = [];
}

if (!variable_global_exists("inventario_armas")) {
    global.inventario_armas = [];
}

if (!variable_global_exists("inventario_roupas")) {
    global.inventario_roupas = [];
}

if (!variable_global_exists("inventario_colecionaveis")) {
    global.inventario_colecionaveis = [];
}

if (!variable_global_exists("inventario_missoes")) {
    global.inventario_missoes = [];
}

// Utilitários compartilhados pelas batalhas, estátuas e inventário.
if (!variable_global_exists("inventario_quantidade_item")) {
    global.inventario_quantidade_item = function(_nome) {
        var quantidade_encontrada = 0;

        for (var item_i = 0; item_i < array_length(global.inventario_itens); item_i++) {
            if (global.inventario_itens[item_i].nome == _nome) {
                quantidade_encontrada += global.inventario_itens[item_i].quantidade;
            }
        }

        return quantidade_encontrada;
    };
}

if (!variable_global_exists("inventario_adicionar_item")) {
    global.inventario_adicionar_item = function(
        _nome,
        _descricao,
        _cor,
        _icone,
        _sprite_item
    ) {
        var sprite_item_adicionado = is_undefined(_sprite_item)
            ? -1
            : _sprite_item;

        for (var item_i = 0; item_i < array_length(global.inventario_itens); item_i++) {
            if (global.inventario_itens[item_i].nome == _nome) {
                global.inventario_itens[item_i].quantidade++;

                // Atualiza também itens obtidos antes de seus sprites existirem.
                if (sprite_item_adicionado != -1) {
                    global.inventario_itens[item_i].sprite_item = sprite_item_adicionado;
                }

                return;
            }
        }

        var item_adicionado = global.inventario_criar_item(
            _nome,
            _descricao,
            "Oferenda de uma estátua",
            1,
            _cor,
            _icone
        );
        item_adicionado.sprite_item = sprite_item_adicionado;
        array_push(global.inventario_itens, item_adicionado);
    };
}

if (!variable_global_exists("inventario_remover_item")) {
    global.inventario_remover_item = function(_nome) {
        var nova_bolsa = [];
        var removeu = false;

        for (var item_i = 0; item_i < array_length(global.inventario_itens); item_i++) {
            var item_atual = global.inventario_itens[item_i];

            if (!removeu && item_atual.nome == _nome) {
                removeu = true;

                if (item_atual.quantidade > 1) {
                    item_atual.quantidade--;
                    array_push(nova_bolsa, item_atual);
                }
            }
            else {
                array_push(nova_bolsa, item_atual);
            }
        }

        global.inventario_itens = nova_bolsa;
        return removeu;
    };
}

// Consumíveis usam um ID estável, separado do nome mostrado na interface.
// Os sprites são opcionais: quando existirem, basta informar o asset no objeto
// de coleta; os placeholders continuam funcionando enquanto a arte é produzida.
if (!variable_global_exists("inventario_criar_consumivel")) {
    global.inventario_criar_consumivel = function(
        _id,
        _nome,
        _descricao,
        _cura,
        _raridade,
        _cor,
        _icone,
        _sprite_item,
        _quantidade
    ) {
        var novo_item = global.inventario_criar_item(
            _nome,
            _descricao,
            "Recupera " + string(_cura) + " de vida",
            max(1, _quantidade),
            _cor,
            _icone
        );

        novo_item.id = _id;
        novo_item.categoria = "cura";
        novo_item.consumivel = true;
        novo_item.cura = max(1, _cura);
        novo_item.usavel_mapa = true;
        novo_item.usavel_batalha = true;
        novo_item.raridade = _raridade;
        novo_item.sprite_item = _sprite_item;
        return novo_item;
    };
}

if (!variable_global_exists("inventario_adicionar_consumivel")) {
    global.inventario_adicionar_consumivel = function(
        _id,
        _nome,
        _descricao,
        _cura,
        _raridade,
        _cor,
        _icone,
        _sprite_item,
        _quantidade
    ) {
        var quantidade_adicionar = max(1, _quantidade);

        for (var consumivel_i = 0; consumivel_i < array_length(global.inventario_itens); consumivel_i++) {
            var consumivel_atual = global.inventario_itens[consumivel_i];
            var consumivel_id = variable_struct_exists(consumivel_atual, "id")
                ? consumivel_atual.id
                : consumivel_atual.nome;

            if (consumivel_id == _id) {
                consumivel_atual.quantidade += quantidade_adicionar;
                // Atualiza partidas antigas, nas quais o item foi coletado
                // antes de sua ilustração ter sido vinculada ao inventário.
                consumivel_atual.sprite_item = _sprite_item;
                return true;
            }
        }

        array_push(
            global.inventario_itens,
            global.inventario_criar_consumivel(
                _id,
                _nome,
                _descricao,
                _cura,
                _raridade,
                _cor,
                _icone,
                _sprite_item,
                quantidade_adicionar
            )
        );
        return true;
    };
}

// Migração visual para curas que já estavam salvas no inventário.
for (var cura_migracao_i = 0;
    cura_migracao_i < array_length(global.inventario_itens);
    cura_migracao_i++
) {
    var cura_migracao = global.inventario_itens[cura_migracao_i];
    var cura_migracao_id = variable_struct_exists(cura_migracao, "id")
        ? cura_migracao.id
        : "";

    switch (cura_migracao_id) {
        case "orvalho_lunar":
            cura_migracao.sprite_item = spr_itemcura_esfera_de_agua;
        break;

        case "fruto_rosado":
            cura_migracao.sprite_item = spr_itemcura_fruta;
        break;

        case "seiva_estelar":
            cura_migracao.sprite_item = spr_itemcura_folha_com_gota;
        break;
    }
}

if (!variable_global_exists("inventario_remover_item_id")) {
    global.inventario_remover_item_id = function(_id) {
        var nova_bolsa_id = [];
        var removeu_id = false;

        for (var remover_i = 0; remover_i < array_length(global.inventario_itens); remover_i++) {
            var remover_item = global.inventario_itens[remover_i];
            var remover_id = variable_struct_exists(remover_item, "id")
                ? remover_item.id
                : remover_item.nome;

            if (!removeu_id && remover_id == _id) {
                removeu_id = true;

                if (remover_item.quantidade > 1) {
                    remover_item.quantidade--;
                    array_push(nova_bolsa_id, remover_item);
                }
            }
            else {
                array_push(nova_bolsa_id, remover_item);
            }
        }

        global.inventario_itens = nova_bolsa_id;
        return removeu_id;
    };
}

if (!variable_global_exists("inventario_itens_curativos")) {
    global.inventario_itens_curativos = function(_somente_batalha) {
        var curativos = [];

        for (var cura_i = 0; cura_i < array_length(global.inventario_itens); cura_i++) {
            var cura_item = global.inventario_itens[cura_i];
            var eh_consumivel = variable_struct_exists(cura_item, "consumivel")
                && cura_item.consumivel;
            var tem_cura = variable_struct_exists(cura_item, "cura")
                && cura_item.cura > 0;
            var pode_usar = !_somente_batalha
                || (
                    variable_struct_exists(cura_item, "usavel_batalha")
                    && cura_item.usavel_batalha
                );

            if (eh_consumivel && tem_cura && pode_usar && cura_item.quantidade > 0) {
                array_push(curativos, cura_item);
            }
        }

        return curativos;
    };
}

if (!variable_global_exists("itens_curativos_coletados")) {
    global.itens_curativos_coletados = [];
}


// ═════════════════════════════════════════════
// DUELOS EM TURNOS CONTRA NPCS
// ═════════════════════════════════════════════
if (!variable_global_exists("inimigos_derrotados")) {
    global.inimigos_derrotados = [false, false, false, false];
}

if (!variable_global_exists("tem_espada_fragmento")) {
    global.tem_espada_fragmento = variable_global_exists("tem_fragmento")
        && global.tem_fragmento;
}

// Compatibilidade com partidas antigas: a espada já coletada também recebe
// sua arte e os novos campos usados pelo inventário refinado.
var arma_fragmento_encontrada = false;
for (var arma_migracao_i = 0; arma_migracao_i < array_length(global.inventario_armas); arma_migracao_i++) {
    var arma_migracao = global.inventario_armas[arma_migracao_i];
    if (arma_migracao.nome == "Lâmina do Fragmento") {
        arma_fragmento_encontrada = true;
        arma_migracao.sprite_item = spr_espada;
        arma_migracao.icone = "espada";
        arma_migracao.categoria = "arma";
        arma_migracao.raridade = "Única";
    }
}

if (global.tem_espada_fragmento && !arma_fragmento_encontrada) {
    var arma_fragmento_migrada = global.inventario_criar_item(
        "Lâmina do Fragmento",
        "Um caco de vitral que respondeu à mão de Kiran e assumiu a forma de uma espada.",
        "Arma equipada",
        1,
        make_color_rgb(176, 211, 224),
        "espada"
    );
    arma_fragmento_migrada.sprite_item = spr_espada;
    arma_fragmento_migrada.categoria = "arma";
    arma_fragmento_migrada.raridade = "Única";
    array_push(global.inventario_armas, arma_fragmento_migrada);
}

if (!variable_global_exists("vida_kiran_max")) {
    global.vida_kiran_max = 100;
}

if (!variable_global_exists("vida_kiran")) {
    global.vida_kiran = global.vida_kiran_max;
}

// HUD de vida em vitral. Se estes quatro assets forem criados no futuro,
// serão usados automaticamente; até lá, o Draw GUI usa folhas facetadas.
hud_sprite_folha_cheia = asset_get_index("spr_vida_cheia");
hud_sprite_folha_parcial = asset_get_index("spr_vida_parcial");
hud_sprite_folha_vazia = asset_get_index("spr_vida_vazia");
hud_sprite_folha_brilho = asset_get_index("spr_vida_brilho");
hud_vida_exibida = global.vida_kiran;
hud_vida_anterior = global.vida_kiran;
hud_vida_feedback = 0;
hud_vida_feedback_timer = 0;
hud_vida_feedback_total = 42;

if (!variable_global_exists("guardas_recusados")) {
    global.guardas_recusados = [0, 0, 0, 0];
}

if (!variable_global_exists("oferendas_estatuas")) {
    global.oferendas_estatuas = [
        "Essência de Orvalho",
        "Semente Estelar",
        "Pétala Lunar",
        "Cristal Sereno"
    ];
}

nomes_inimigos = [
    "Mira",
    "Nilo",
    "Lumi",
    "Orion"
];

titulos_inimigos = [
    "Guarda Real das Fontes",
    "Guarda Real dos Jardins",
    "Florakii do Bosque Nebuloso",
    "Capitão da Guarda Real"
];

faccoes_inimigos = ["guarda", "guarda", "florakii", "guarda"];
rotulos_faccoes_inimigos = [
    "GUARDA DA RAINHA",
    "GUARDA DA RAINHA",
    "FLORAKII",
    "GUARDA DA RAINHA"
];

tipos_inimigos = ["Água", "Natureza", "Esporos", "Cristal"];
fraquezas_inimigos = ["Natureza", "Lua", "Luz", "Impacto"];
golpes_inimigos = ["Maré Rápida", "Raiz Espiral", "Pólen Cortante", "Estilhaço Azul"];
golpes_inimigos_fortes = ["Dilúvio Frio", "Prisão de Raízes", "Nuvem de Esporos", "Ruptura Prismática"];

ameacas_inimigos = [
    "Alto, forasteiro. Por ordem da Rainha, ninguém se aproxima desta oferenda sem provar suas intenções.",
    "Você não pertence a estes jardins. Afaste-se agora, antes que as raízes decidam por você.",
    "Pare! A luz que você carrega está ferindo o bosque. Diga quem é antes de chegar mais perto.",
    "Sua jornada termina aqui, forasteiro. Nenhuma lâmina é erguida contra a Coroa sem enfrentar seu capitão."
];

ameacas_retorno = [
    "Você voltou, forasteiro. Desta vez vai explicar suas intenções ou pretende recuar novamente?",
    "Reconheço esses passos. O jardim também se lembra de quem foge de um desafio.",
    "Você voltou... O bosque ainda se lembra do brilho da sua lâmina. Veio conversar ou ferir outra vez?",
    "Outra vez diante de mim? Escolha com cuidado. Minha paciência não é infinita."
];

// Cada encontro começa como conversa. O jogador pode acalmar a situação,
// pedir contexto ou assumir que deseja atravessar pela força.
opcoes_conversa_inimigos = [
    [
        "Cumpra seu dever. Eu vou cumprir o meu.",
        "Não quero machucar você.",
        "Eu só preciso passar."
    ],
    [
        "Só não me impeça de seguir.",
        "Vou tentar não atingir as flores.",
        "Proteja seu posto."
    ],
    [
        "Então tente me impedir.",
        "Ainda podemos resolver isso sem nos machucar.",
        "Eu não vou desistir da oferenda."
    ],
    [
        "Eu não vou voltar agora.",
        "Não quero ferir mais ninguém.",
        "Você é o capitão. Faça seu dever."
    ]
];

metadados_conversa_inimigos = [
    [
        { id: "mira_antes_dahlia", rota: "dahlia", pontos: 1 },
        { id: "mira_antes_florakii", rota: "florakii", pontos: 1 },
        { id: "mira_antes_neutro", rota: "neutro", pontos: 1 }
    ],
    [
        { id: "nilo_antes_neutro", rota: "neutro", pontos: 1 },
        { id: "nilo_antes_florakii", rota: "florakii", pontos: 1 },
        { id: "nilo_antes_dahlia", rota: "dahlia", pontos: 1 }
    ],
    [
        { id: "lumi_antes_dahlia", rota: "dahlia", pontos: 1 },
        { id: "lumi_antes_florakii", rota: "florakii", pontos: 1 },
        { id: "lumi_antes_neutro", rota: "neutro", pontos: 1 }
    ],
    [
        { id: "orion_antes_neutro", rota: "neutro", pontos: 1 },
        { id: "orion_antes_florakii", rota: "florakii", pontos: 1 },
        { id: "orion_antes_dahlia", rota: "dahlia", pontos: 1 }
    ]
];

falas_escolha_conversa_inimigos = [
    [
        "Mira: “É exatamente o que farei.”",
        "Mira: “Então mantenha a lâmina baixa enquanto puder.”",
        "Mira: “E eu preciso impedir que passe.”"
    ],
    [
        "Nilo: “Então temos um problema.”",
        "Nilo: “As raízes ouviram. Vamos descobrir se acreditam.”",
        "Nilo: “Até o fim.”"
    ],
    [
        "Lumi: “Você fala exatamente como eles.”",
        "Lumi: “Ainda podemos. Afaste-se da oferenda.”",
        "Lumi: “Então o bosque ouvirá nossas intenções.”"
    ],
    [
        "Orion: “Então não haverá outro aviso.”",
        "Orion: “Suas intenções não apagam o caminho que abriu até aqui.”",
        "Orion: “Como capitão, eu não poderia responder de outra forma.”"
    ]
];

falas_pacificas_inimigos = [
    "Então mantenha sua lâmina baixa e siga outro caminho. Não haverá combate enquanto respeitar esta ordem.",
    "Se veio em paz, deixe as raízes quietas e retorne pelo caminho de onde veio.",
    "Eu também não quero ferir você. Afaste a luz da oferenda e o bosque deixará seus passos seguirem.",
    "Paz exige distância, forasteiro. Recolha a arma e abandone este posto."
];

falas_contexto_inimigos = [
    "A Rainha ordenou que estas oferendas não deixassem a floresta. Minha função é obedecer até que ela diga o contrário.",
    "Este jardim alimenta caminhos que você ainda não compreende. A Coroa não permite que estranhos levem suas sementes.",
    "Não protejo uma ordem da sua rainha. Esta pétala guarda uma memória do bosque, e os Florakii não entregam memórias a quem chega armado.",
    "Porque ela abre um caminho até a Rainha. E nenhum desconhecido chega até esse caminho sem passar por mim."
];

falas_desafio_inimigos = [
    "Então terá de provar que sua necessidade vale mais que a ordem que recebi.",
    "Desejar não basta. Se avançar, as raízes e eu responderemos juntos.",
    "Se realmente precisa dela, mostre que consegue lutar sem deixar a crueldade comandar sua mão.",
    "Finalmente uma intenção clara. Erga sua lâmina e sustente as consequências."
];

falas_recuo = [
    "Uma escolha sensata. Mas não se aproxime da oferenda enquanto eu estiver de guarda.",
    "Vá. As raízes guardarão o som dos seus passos caso decida retornar.",
    "Vá em paz. Só não toque no que o bosque confiou a mim.",
    "Recuar não apaga sua presença daqui. Se voltar, estarei esperando."
];

falas_sem_arma = [
    "Desarmado? Encontre uma forma de se proteger e vá embora.",
    "Você veio desafiar a Guarda Real de mãos vazias? Isso não é coragem. É descuido.",
    "Sem uma arma, sua coragem só vai fazer você se machucar. Procure proteção antes de me desafiar.",
    "Sem arma, você não é um adversário. É apenas mais um intruso perdido."
];

falas_inicio_batalha = [
    "Parece que não.",
    "As flores não gostam de barulho.",
    "Então o bosque ouvirá nossas intenções. Mostre se essa luz sabe proteger, e não apenas cortar.",
    "Até agora não enfrentou o capitão."
];

falas_derrota_guardas = [
    "Sua força não nasceu da ambição... Leve a oferenda. Talvez a Rainha tenha motivos para observá-lo.",
    "Hmph. As raízes não o rejeitaram. Leve isto, mas não pense que passei a confiar em você.",
    "Eu senti sua hesitação a cada golpe... Você não veio destruir. Leve a pétala e cuide dela.",
    "Impossível... A lâmina reconheceu cada abertura. Leve a oferenda — nosso próximo encontro decidirá mais."
];

// Sequências completas exibidas depois da vitória. O cartão de recompensa
// continua aparecendo primeiro; ao voltar ao mapa, o diálogo conclui a cena.
falas_pos_vitoria_guardas = [
    [
        { nome: "Narração", texto: "Mira abaixa a lança." },
        { nome: "Mira", texto: "Chega." },
        { nome: "Kiran", texto: "Você vai me deixar passar?" },
        { nome: "Narração", texto: "Mira observa a água." },
        { nome: "Mira", texto: "A fonte não reagiu contra você." },
        { nome: "Kiran", texto: "Isso significa alguma coisa?" },
        { nome: "Mira", texto: "Significa que eu não tenho tanta certeza quanto tinha antes. Leve a oferenda." },
        { nome: "Kiran", texto: "Obrigado." },
        { nome: "Mira", texto: "Não faça eu me arrepender." }
    ],
    [
        { nome: "Narração", texto: "Nilo se ajoelha. As raízes se afastam lentamente do caminho." },
        { nome: "Kiran", texto: "Elas estão abrindo passagem." },
        { nome: "Nilo", texto: "Eu percebi." },
        { nome: "Kiran", texto: "Então posso pegar a oferenda?" },
        { nome: "Nilo", texto: "Parece que elas decidiram antes de mim." },
        { nome: "Kiran", texto: "Isso te incomoda?" },
        { nome: "Nilo", texto: "Muito. Vai logo antes que eu mude de ideia." }
    ],
    [],
    [
        { nome: "Narração", texto: "Orion apoia a espada no chão." },
        { nome: "Orion", texto: "Pare." },
        { nome: "Narração", texto: "Kiran não avança." },
        { nome: "Kiran", texto: "Terminou?" },
        { nome: "Orion", texto: "Por agora." },
        { nome: "Kiran", texto: "A oferenda." },
        { nome: "Orion", texto: "Leve." },
        { nome: "Kiran", texto: "Só isso?" },
        { nome: "Orion", texto: "Não confunda derrota com confiança." },
        { nome: "Kiran", texto: "Não confundo." },
        { nome: "Orion", texto: "Bom. Porque a Rainha vai querer conhecer você." },
        { nome: "Kiran", texto: "Isso soa como ameaça." },
        { nome: "Orion", texto: "Ainda estou decidindo." }
    ]
];

opcoes_pos_vitoria_guardas = [
    [
        { id: "mira_depois_florakii", texto: "Você está bem?", rota: "florakii", pontos: 1 },
        { id: "mira_depois_dahlia", texto: "Você lutou bem.", rota: "dahlia", pontos: 1 },
        { id: "mira_depois_neutro", texto: "Vou levar a Essência.", rota: "neutro", pontos: 1 }
    ],
    [
        { id: "nilo_depois_neutro", texto: "Então vou levar a Semente.", rota: "neutro", pontos: 1 },
        { id: "nilo_depois_florakii", texto: "As raízes me aceitaram?", rota: "florakii", pontos: 1 },
        { id: "nilo_depois_dahlia", texto: "Você protegeu seu posto até o fim.", rota: "dahlia", pontos: 1 }
    ],
    [
        { id: "lumi_depois_dahlia", texto: "Da próxima vez, não fique no meu caminho.", rota: "dahlia", pontos: 1 },
        { id: "lumi_depois_neutro", texto: "Agora acredita que eu não sou Dahlia?", rota: "neutro", pontos: 1 },
        { id: "lumi_depois_florakii", texto: "Você está bem?", rota: "florakii", pontos: 1 }
    ],
    [
        { id: "orion_depois_florakii", texto: "Mira e Nilo estão bem?", rota: "florakii", pontos: 1 },
        { id: "orion_depois_neutro", texto: "Agora me dê o Cristal.", rota: "neutro", pontos: 1 },
        { id: "orion_depois_dahlia", texto: "Você lutou como um capitão.", rota: "dahlia", pontos: 1 }
    ]
];

respostas_pos_vitoria_guardas = [
    [
        [
            { nome: "Kiran", texto: "Você está bem?" },
            { nome: "Mira", texto: "Estou. A fonte não reagiu contra você. Leve a Essência." }
        ],
        [
            { nome: "Kiran", texto: "Você lutou bem." },
            { nome: "Mira", texto: "E você cumpriu sua parte. Leve a Essência." }
        ],
        [
            { nome: "Kiran", texto: "Vou levar a Essência." },
            { nome: "Mira", texto: "Leve. Mas não me faça arrepender." }
        ]
    ],
    [
        [
            { nome: "Kiran", texto: "Então vou levar a Semente." },
            { nome: "Nilo", texto: "Vai logo, antes que eu mude de ideia." }
        ],
        [
            { nome: "Kiran", texto: "As raízes me aceitaram?" },
            { nome: "Nilo", texto: "Parece que elas decidiram antes de mim." }
        ],
        [
            { nome: "Kiran", texto: "Você protegeu seu posto até o fim." },
            { nome: "Nilo", texto: "Era meu dever. Agora leve a Semente." }
        ]
    ],
    [
        [
            { nome: "Kiran", texto: "Da próxima vez, não fique no meu caminho." },
            { nome: "Lumi", texto: "Talvez você não seja Dahlia. Mas aprendeu rápido a falar como um." }
        ],
        [
            { nome: "Kiran", texto: "Agora acredita que eu não sou Dahlia?" },
            { nome: "Lumi", texto: "Ainda não sei o que você é." },
            { nome: "Kiran", texto: "Somos dois." }
        ],
        [
            { nome: "Kiran", texto: "Você está bem?" },
            { nome: "Lumi", texto: "Por que está perguntando isso?" },
            { nome: "Kiran", texto: "Porque a luta acabou." }
        ]
    ],
    [
        [
            { nome: "Kiran", texto: "Mira e Nilo estão bem?" },
            { nome: "Orion", texto: "Estão. Ainda é isso que importa para você?" },
            { nome: "Kiran", texto: "A luta acabou. Então sim." }
        ],
        [
            { nome: "Kiran", texto: "Agora me dê o Cristal." },
            { nome: "Orion", texto: "Leve. A Rainha vai querer conhecer você." }
        ],
        [
            { nome: "Kiran", texto: "Você lutou como um capitão." },
            { nome: "Orion", texto: "E você sustentou as consequências. Leve o Cristal." }
        ]
    ]
];

falas_vitoria_guardas = [
    "Você ainda não está preparado. Recolha sua lâmina e abandone este lugar.",
    "O jardim já respondeu por mim. Volte quando souber ouvir antes de atacar.",
    "Sua lâmina ainda fala mais alto que seu coração. Volte quando souber escutar o bosque.",
    "Foi exatamente como avisei. A Guarda da Rainha não cede a qualquer forasteiro."
];

hp_max_inimigos = [110, 132, 142, 215];
dano_min_inimigos = [15, 18, 19, 27];
dano_max_inimigos = [21, 25, 28, 37];
dificuldades_inimigos = ["Aprendiz", "Experiente", "Experiente", "Elite"];

descricoes_oferendas = [
    "Uma gota luminosa oferecida por Mira após o duelo.",
    "Uma semente morna entregue por Nilo após o duelo.",
    "Uma pétala prateada confiada ao bosque pela Florakii Lumi.",
    "Um cristal límpido confiado por Orion após o duelo."
];

// O índice acompanha o adversário, não o número do asset. A primeira arte
// pertence à Florakii Lumi, como definido para a história:
// Mira -> 2, Nilo -> 3, Lumi -> 1 e Orion -> 4.
// spr_oferenda5 fica disponível para a próxima oferenda adicionada ao jogo.
sprites_oferendas = [
    spr_oferenda2,
    spr_oferenda3,
    spr_oferenda1,
    spr_oferenda4
];

// Migração visual para oferendas que já estavam no inventário antes de as
// artes serem criadas. Não altera quantidades nem o progresso do jogador.
for (var oferenda_item_i = 0;
    oferenda_item_i < array_length(global.inventario_itens);
    oferenda_item_i++
) {
    var oferenda_item_atual = global.inventario_itens[oferenda_item_i];

    for (var oferenda_indice = 0;
        oferenda_indice < array_length(global.oferendas_estatuas);
        oferenda_indice++
    ) {
        if (oferenda_item_atual.nome == global.oferendas_estatuas[oferenda_indice]) {
            oferenda_item_atual.sprite_item = sprites_oferendas[oferenda_indice];
            break;
        }
    }
}

cores_inimigos = [
    make_color_rgb(178, 222, 235),
    make_color_rgb(188, 226, 194),
    make_color_rgb(222, 202, 241),
    make_color_rgb(205, 215, 242)
];

// Mapeamento automático escolhido para os quatro inimigos.
// índice 0 usa spr_inimigo1, índice 1 usa spr_inimigo2 e assim por diante.
// Enquanto os perfis próprios não existem, a mesma arte também aparece como
// retrato e no combate. Os arrays continuam separados para a troca futura.
sprites_mapa_inimigos = [
    spr_inimigo1,
    spr_inimigo2,
    spr_florakii_inimigo,
    spr_inimigo4
];
sprites_batalha_inimigos = [
    spr_inimigo1,
    spr_inimigo2,
    spr_florakii_inimigo,
    spr_inimigo4
];
sprites_ataque_inimigos = [
    spr_inimigo1_ataque,
    spr_inimigo2_ataque,
    spr_florakii_inimigo_ataque,
    spr_inimigo4_ataque
];
sprites_retrato_inimigos = [
    spr_inimigo1,
    spr_inimigo2,
    spr_perfil_florakiiinimigo,
    spr_inimigo4
];
// As artes dos guardas ocupam aproximadamente metade do canvas 300x300;
// escala 2 compensa essa margem transparente. O Florakii mantém seu ajuste.
escalas_mapa_inimigos = [2, 2, 0.92, 2];
escalas_batalha_inimigos = [2, 2, 1.08, 2];
offsets_batalha_inimigos_x = [0, 0, 0, 0];
offsets_batalha_inimigos_y = [0, 0, 0, 0];
// Pose normal da batalha: Kiran já empunhando a espada.
sprite_batalha_kiran = spr_kiran_sword;
// Animação nova de Kiran atacando com a espada.
sprite_ataque_kiran = spr_kiran_sword_attack;
if (!sprite_exists(sprite_ataque_kiran)) {
    sprite_ataque_kiran = asset_get_index("spr_ataque_kiran");
}
if (!sprite_exists(sprite_ataque_kiran)) {
    sprite_ataque_kiran = asset_get_index("spr_kiran_ataque");
}

inimigos_sala_indices = [];
inimigos_sala_x = [];
inimigos_sala_y = [];

criar_cura_extra = function(_x, _y, _tipo, _id, _variante) {
    // Os fundos das salas usam profundidades negativas. Em 170, os itens eram
    // criados corretamente, mas ficavam escondidos atrás da arte do cenário.
    var cura_extra = instance_create_depth(_x, _y, -9650, obj_item_cura);
    cura_extra.tipo_item = _tipo;
    cura_extra.id_coleta = _id;
    cura_extra.variante_sprite = _variante;
    return cura_extra;
};

if (room == Room1) {
    // Estes dois NPCs carregam oferendas para as estátuas de Room4 e Room5.
    inimigos_sala_indices = [2, 3];
    inimigos_sala_x = [1850, 4250];
    inimigos_sala_y = [545, 530];
}
else if (room == Room4) {
    // A oferenda encontrada aqui pertence à primeira estátua de Room1.
    inimigos_sala_indices = [0];
    inimigos_sala_x = [690];
    inimigos_sala_y = [575];
}
else if (room == Room5) {
    // A oferenda encontrada aqui pertence à estátua distante de Room1.
    inimigos_sala_indices = [1];
    inimigos_sala_x = [1050];
    inimigos_sala_y = [500];
}

// Elementos de exploração garantidos em runtime. Eles continuam aparecendo
// mesmo que uma room antiga seja aberta antes de o Room Editor recarregar as
// novas instâncias.
if (room == Room1) {
    if (instance_number(obj_animal_rota) <= 0) {
        var animal_room1 = instance_create_depth(760, 516, 175, obj_animal_rota);
        animal_room1.sprite_animal = spr_animal;
        animal_room1.escala_animal = 0.58;
        animal_room1.largura_da_rota = 300;
    }

    // Um segundo animal maior percorre quase toda a clareira. O pequeno
    // continua existindo como detalhe próximo ao ponto em que foi colocado.
    if (instance_number(obj_animal_rota) < 2) {
        var animal_room1_maior = instance_create_depth(3100, 516, 174, obj_animal_rota);
        animal_room1_maior.sprite_animal = spr_animal;
        animal_room1_maior.escala_animal = 1.85;
        animal_room1_maior.largura_da_rota = 5400;
        animal_room1_maior.velocidade_da_rota = 1.35;
    }

    // Curas distribuídas ao longo dos seis trechos da floresta principal.
    criar_cura_extra(620, 552, 0, "cura_extra_room1_01", 0);
    criar_cura_extra(2050, 536, 1, "cura_extra_room1_02", 1);
    criar_cura_extra(2920, 548, 0, "cura_extra_room1_03", 4);
    criar_cura_extra(4200, 542, 1, "cura_extra_room1_04", 3);
    criar_cura_extra(5250, 548, 2, "cura_extra_room1_05", 2);
}
else if (room == Room4) {
    // Permanecem sobre as margens da trilha, fora do lago central.
    criar_cura_extra(280, 500, 0, "cura_extra_room4_01", 5);
    criar_cura_extra(730, 592, 1, "cura_extra_room4_02", 3);
}
else if (room == Room5) {
    // Seguem os mesmos pontos seguros usados pelo caminho recalibrado de Kiran.
    criar_cura_extra(250, 410, 0, "cura_extra_room5_01", 4);
    criar_cura_extra(620, 400, 1, "cura_extra_room5_02", 1);
    criar_cura_extra(1380, 462, 0, "cura_extra_room5_03", 0);
}
else if (room == rm_templo) {
    criar_cura_extra(470, 548, 0, "cura_extra_templo_01", 5);
    criar_cura_extra(1060, 548, 2, "cura_extra_templo_02", 2);
}

inimigo_proximo = -1;
tempo_inimigos = random(100);

batalha_inimigo = -1;
batalha_corrupcao = 100;
batalha_serenidade = 100;
batalha_opcao = 0;
batalha_mouse_opcao = -1;
batalha_fase = 0;
batalha_timer = 0;
batalha_bloqueio = 0;
batalha_mensagem = "";
batalha_recompensa_recebida = false;
batalha_rodada = 1;
batalha_energia = 6;
batalha_energia_max = 8;
sprites_energia = [
    spr_energia_0_8,
    spr_energia_1_8,
    spr_energia_2_8,
    spr_energia_3_8,
    spr_energia_4_8,
    spr_energia_5_8,
    spr_energia_6_8,
    spr_energia_7_8,
    spr_energia_8_8
];
batalha_npc_enfraquecido = false;
batalha_ultimo_foi_fraqueza = false;
batalha_hp_max_inimigo = 100;
batalha_opcao_confronto = 0;
batalha_troca_item_opcao = 0;
batalha_resolvida_troca = false;
batalha_conversa_etapa = 0;
batalha_conversa_opcao = 0;
batalha_conversa_mouse = -1;
batalha_conversa_visitou_pergunta = false;
batalha_defesa_timer = 0;
batalha_defesa_total = 120;
batalha_dano_pendente = 0;
batalha_golpe_pendente = "";
batalha_elite_desperto = false;
batalha_iniciada = false;
batalha_defesa_feedback = 0;
batalha_defesa_posicao = 0;
batalha_defesa_alvo = 0.5;
batalha_defesa_janela_perfeita = 4;
batalha_defesa_janela_boa = 10;
batalha_animacao_ataque_kiran = 0;
batalha_animacao_ataque_inimigo = 0;
batalha_derrota_pendente = false;
batalha_mensagem_derrota = "";
batalha_menu = 0;
batalha_acao_opcao = 0;
batalha_tecnica_opcao = 0;
batalha_item_opcao = 0;
batalha_defesa_preparada = false;
batalha_feedback_timer = 0;
batalha_feedback_total = 48;
batalha_feedback_valor = 0;
batalha_feedback_alvo = 0;
batalha_feedback_tipo = 0;
batalha_impacto_inimigo = 0;
batalha_impacto_kiran = 0;
batalha_status_inimigo = "";
batalha_entrada_timer = 0;
batalha_entrada_total = 34;

// Conversas cinematográficas de história. Elas usam a mesma tela de encontro
// dos duelos, mas mantêm o roteiro, o retrato e as escolhas separados do
// estado da batalha.
encontro_roteiro_tipo = 0; // 0 nenhum, 1 comandante, 2 Florakii
encontro_roteiro_bloco = 0;
encontro_roteiro_indice = 0;
encontro_roteiro_opcao = 0;
encontro_roteiro_mouse = -1;
encontro_roteiro_linhas = [];
encontro_roteiro_opcoes1 = [];
encontro_roteiro_opcoes2 = [];
encontro_roteiro_metadados1 = [];
encontro_roteiro_metadados2 = [];
encontro_roteiro_rotas1 = [];
encontro_roteiro_rotas2 = [];
encontro_roteiro_comum = [];
encontro_roteiro_final = [];
encontro_roteiro_finais_rainha = [];
encontro_roteiro_nome = "";
encontro_roteiro_titulo = "";
encontro_roteiro_rotulo = "";
encontro_roteiro_contexto = "";
encontro_roteiro_retrato = -1;
encontro_roteiro_cor = make_color_rgb(205, 215, 242);
encontro_roteiro_tem_segunda_escolha = true;

if (!variable_global_exists("encontro_rainha_iniciado")) {
    global.encontro_rainha_iniciado = false;
}

if (!variable_global_exists("capitulo_concluido")) {
    global.capitulo_concluido = false;
}

fim_capitulo_timer = 0;

if (!variable_global_exists("florakii_roteiro_visto")) {
    global.florakii_roteiro_visto = false;
}

if (!variable_global_exists("guardas_roteiro_visto")) {
    global.guardas_roteiro_visto = [false, false, false, false];
}

nova_fala_encontro = function(_nome, _texto) {
    return { nome: _nome, texto: _texto };
};

opcao_rota_encontro = function(_id, _rota) {
    return { id: _id, rota: _rota, pontos: 1 };
};

// Apresentação da recompensa: cartão dentro da batalha e confirmação curta
// ao retornar para a exploração.
recompensa_nome = "";
recompensa_descricao = "";
recompensa_sprite = -1;
recompensa_toast_pendente = false;
recompensa_toast_timer = 0;
recompensa_toast_total = 240;
dialogo_pos_vitoria_timer = 0;
dialogo_pos_vitoria_indice = -1;

batalha_opcoes = [
    "Corte Prismático",
    "Lâmina Verdejante",
    "Arco Lunar",
    "Estocada Cometa"
];

batalha_tipos_golpes = ["Luz", "Natureza", "Lua", "Impacto"];
batalha_custos_golpes = [0, 2, 3, 2];
batalha_poder_golpes = [20, 24, 27, 30];
batalha_descricoes_golpes = [
    "Golpe confiável da espada; recupera 1 de energia.",
    "A lâmina absorve vida e recupera um pouco do HP.",
    "Cria uma guarda que enfraquece o próximo ataque.",
    "Golpe arriscado com chance de dano crítico."
];

iniciar_encontro_roteiro = function(_tipo) {
    encontro_roteiro_tipo = _tipo;
    encontro_roteiro_bloco = 0;
    encontro_roteiro_indice = 0;
    encontro_roteiro_opcao = 0;
    encontro_roteiro_mouse = -1;
    encontro_roteiro_tem_segunda_escolha = true;
    encontro_roteiro_metadados1 = [];
    encontro_roteiro_metadados2 = [];
    encontro_roteiro_finais_rainha = [];

    if (_tipo == 1) {
        batalha_inimigo = -1;
        encontro_roteiro_nome = "Comandante";
        encontro_roteiro_titulo = "Comandante da Guarda Real";
        encontro_roteiro_rotulo = "COMANDANTE DA RAINHA";
        encontro_roteiro_contexto = "A comandante que bloqueia a escadaria. Sua autoridade vem diretamente da Rainha.";
        encontro_roteiro_retrato = spr_perfil_comandante;
        encontro_roteiro_cor = make_color_rgb(221, 194, 232);
        encontro_roteiro_linhas = [
            nova_fala_encontro("Comandante", "Você aí. Pare."),
            nova_fala_encontro("Kiran", "...Eu?"),
            nova_fala_encontro("Comandante", "Claro que você. Pequeno desse jeito... e com um broto saindo da cabeça. Florakii."),
            nova_fala_encontro("Kiran", "O quê?"),
            nova_fala_encontro("Comandante", "Não precisa fingir. Vocês são fáceis de reconhecer. Pequenos, ligados às plantas... sempre se metendo onde não foram chamados.")
        ];
        encontro_roteiro_opcoes1 = [
            "Eu não sou Florakii.",
            "O que meu tamanho tem a ver com isso?",
            "E se eu fosse?",
            "Ficar em silêncio."
        ];
        encontro_roteiro_rotas1 = [
            [
                nova_fala_encontro("Kiran", "Eu não sou Florakii."),
                nova_fala_encontro("Comandante", "... Não? Então o que é isso?"),
                nova_fala_encontro("Narração", "Ela aponta para o broto na cabeça de Kiran."),
                nova_fala_encontro("Kiran", "Eu não sei."),
                nova_fala_encontro("Comandante", "Conveniente. Um broto na cabeça, metade da minha altura e perdido no território deles. Perdoe-me se não estou convencida."),
                nova_fala_encontro("Kiran", "Você sempre decide o que alguém é só olhando?"),
                nova_fala_encontro("Comandante", "Quando é tão óbvio, sim.")
            ],
            [
                nova_fala_encontro("Kiran", "O que meu tamanho tem a ver com alguma coisa?"),
                nova_fala_encontro("Comandante", "Muito. Olhe para você. E depois olhe para mim."),
                nova_fala_encontro("Kiran", "Estou olhando."),
                nova_fala_encontro("Comandante", "Então deveria entender. Florakii são pequenos. Frágeis. Você também."),
                nova_fala_encontro("Kiran", "Ser maior não faz você superior."),
                nova_fala_encontro("Comandante", "Talvez não. Mas ajuda bastante quando alguém precisa decidir quem sai do caminho.")
            ],
            [
                nova_fala_encontro("Kiran", "E se eu fosse Florakii?"),
                nova_fala_encontro("Comandante", "Então você deveria saber melhor do que ninguém quando abaixar a cabeça."),
                nova_fala_encontro("Kiran", "Por quê?"),
                nova_fala_encontro("Comandante", "Porque essa espécie sobreviveu até agora aprendendo a se esconder. Nas folhas. Nas raízes. Atrás uns dos outros."),
                nova_fala_encontro("Kiran", "Talvez eles só estejam se escondendo de pessoas como você."),
                nova_fala_encontro("Comandante", "Cuidado. Você já é pequeno. Não faça questão de parecer ainda menor.")
            ],
            [
                nova_fala_encontro("Kiran", "..."),
                nova_fala_encontro("Comandante", "Nada a dizer? Hm. Pelo menos nisso você parece ter sido bem ensinado."),
                nova_fala_encontro("Kiran", "..."),
                nova_fala_encontro("Comandante", "Os Florakii ficam muito mais suportáveis quando não tentam discutir.")
            ]
        ];
        // Primeira escolha revisada: Neutro, Dahlia e Florakii aparecem em
        // posições diferentes das usadas nos demais encontros.
        encontro_roteiro_opcoes1 = [
            "Eu não sou Florakii.",
            "Então tente me tirar daqui.",
            "E se eu fosse Florakii?"
        ];
        encontro_roteiro_metadados1 = [
            opcao_rota_encontro("comandante_01_neutro", "neutro"),
            opcao_rota_encontro("comandante_01_dahlia", "dahlia"),
            opcao_rota_encontro("comandante_01_florakii", "florakii")
        ];
        encontro_roteiro_rotas1 = [
            encontro_roteiro_rotas1[0],
            [
                nova_fala_encontro("Kiran", "Então tente me tirar daqui."),
                nova_fala_encontro("Comandante", "Você está me desafiando?"),
                nova_fala_encontro("Kiran", "Você parece gostar de olhar para baixo. Quero ver se sabe fazer mais alguma coisa."),
                nova_fala_encontro("Comandante", "Coragem e imprudência costumam ter o mesmo tamanho vistas de longe.")
            ],
            encontro_roteiro_rotas1[2]
        ];
        encontro_roteiro_comum = [
            nova_fala_encontro("Narração", "A Comandante se aproxima e observa o broto na cabeça de Kiran."),
            nova_fala_encontro("Comandante", "Estranho."),
            nova_fala_encontro("Kiran", "O quê?"),
            nova_fala_encontro("Comandante", "Seu broto. Não se parece exatamente com os deles."),
            nova_fala_encontro("Kiran", "Porque eu não sou um deles."),
            nova_fala_encontro("Comandante", "Ou talvez seja só uma variação particularmente esquisita."),
            nova_fala_encontro("Kiran", "Você realmente não consegue admitir que está errada, consegue?"),
            nova_fala_encontro("Comandante", "Eu não preciso. Florakii ou não, continuo olhando para baixo para falar com você.")
        ];
        encontro_roteiro_opcoes2 = [
            "Você gosta muito de falar do meu tamanho.",
            "Você trata todos os Florakii assim?",
            "Eu não tenho medo de você.",
            "Só quero passar."
        ];
        encontro_roteiro_rotas2 = [
            [
                nova_fala_encontro("Kiran", "Você parece gostar muito de falar do meu tamanho."),
                nova_fala_encontro("Comandante", "É difícil não notar."),
                nova_fala_encontro("Kiran", "Está tentando me intimidar?"),
                nova_fala_encontro("Comandante", "Não. Se eu precisasse tentar, seria decepcionante."),
                nova_fala_encontro("Kiran", "Então por que continua?"),
                nova_fala_encontro("Comandante", "Porque gosto quando criaturas pequenas lembram o quanto são pequenas.")
            ],
            [
                nova_fala_encontro("Kiran", "Você trata todos os Florakii desse jeito?"),
                nova_fala_encontro("Comandante", "Eu trato cada criatura de acordo com aquilo que ela é."),
                nova_fala_encontro("Kiran", "E você acha que sabe o que eles são?"),
                nova_fala_encontro("Comandante", "Sei o suficiente."),
                nova_fala_encontro("Kiran", "Então não sabe muito."),
                nova_fala_encontro("Comandante", "... Você tem uma língua grande demais para alguém tão pequeno.")
            ],
            [
                nova_fala_encontro("Kiran", "Eu não tenho medo de você."),
                nova_fala_encontro("Comandante", "Não?"),
                nova_fala_encontro("Kiran", "Não."),
                nova_fala_encontro("Narração", "A Comandante se inclina um pouco, aproximando o rosto do dele."),
                nova_fala_encontro("Comandante", "Então talvez os Florakii tenham finalmente produzido um exemplar com coragem."),
                nova_fala_encontro("Kiran", "Eu já disse que não sou Florakii."),
                nova_fala_encontro("Comandante", "E eu já disse que isso ainda está em discussão.")
            ],
            [
                nova_fala_encontro("Kiran", "Eu só quero passar."),
                nova_fala_encontro("Comandante", "Claro. Pequenos sempre querem passar despercebidos."),
                nova_fala_encontro("Kiran", "Eu não disse despercebido. Disse passar."),
                nova_fala_encontro("Comandante", "... Você está começando a me irritar.")
            ]
        ];
        encontro_roteiro_opcoes2 = [
            "Cumpri as condições. Tenho as quatro oferendas.",
            "Ser maior não faz você superior a eles.",
            "Não importa de que lado você acha que eu sou."
        ];
        encontro_roteiro_metadados2 = [
            opcao_rota_encontro("comandante_02_dahlia", "dahlia"),
            opcao_rota_encontro("comandante_02_florakii", "florakii"),
            opcao_rota_encontro("comandante_02_neutro", "neutro")
        ];
        encontro_roteiro_rotas2 = [
            [
                nova_fala_encontro("Kiran", "Tenho as quatro oferendas. Cumpri as condições."),
                nova_fala_encontro("Comandante", "Ainda precisa devolvê-las às estátuas."),
                nova_fala_encontro("Kiran", "Então farei isso.")
            ],
            [
                nova_fala_encontro("Kiran", "Ser maior não faz você superior a eles."),
                nova_fala_encontro("Comandante", "Está defendendo Florakii?"),
                nova_fala_encontro("Kiran", "Estou dizendo que tamanho não decide valor.")
            ],
            [
                nova_fala_encontro("Kiran", "Não me importa se acha que sou Florakii ou Dahlia."),
                nova_fala_encontro("Comandante", "Deveria."),
                nova_fala_encontro("Kiran", "Por quê? Até agora ninguém acertou.")
            ]
        ];
        encontro_roteiro_final = [
            nova_fala_encontro("Comandante", "Seja lá o que você for... está carregando a aparência de um Florakii e caminhando pelo território deles. Para mim, isso basta."),
            nova_fala_encontro("Kiran", "Então talvez você devesse aprender a olhar melhor."),
            nova_fala_encontro("Comandante", "Talvez. Ou talvez você devesse aprender que, neste lugar, nem sempre importa o que você é. Importa o que aqueles acima de você decidem que você é.")
        ];
    }
    else if (_tipo == 2) {
        batalha_inimigo = 2;
        encontro_roteiro_nome = "Lumi";
        encontro_roteiro_titulo = "Florakii do Bosque Nebuloso";
        encontro_roteiro_rotulo = "FLORAKII";
        encontro_roteiro_contexto = "Uma guardiã cautelosa do bosque. As roupas de Kiran despertam nela uma antiga desconfiança.";
        encontro_roteiro_retrato = spr_perfil_florakiiinimigo;
        encontro_roteiro_cor = make_color_rgb(183, 228, 211);
        encontro_roteiro_linhas = [
            nova_fala_encontro("Narração", "Kiran se aproxima. O Florakii percebe sua presença e imediatamente recua."),
            nova_fala_encontro("Lumi", "Não chega mais perto!"),
            nova_fala_encontro("Kiran", "Espera, eu só..."),
            nova_fala_encontro("Lumi", "Eu disse para ficar aí!"),
            nova_fala_encontro("Narração", "Kiran para. O Florakii o observa de cima a baixo; seus olhos param nas roupas dele."),
            nova_fala_encontro("Lumi", "Essas roupas... Você é um Dahlia."),
            nova_fala_encontro("Kiran", "Um quê?"),
            nova_fala_encontro("Lumi", "Não tenta fingir que não sabe. Esse tecido claro, o corte, esses detalhes... Eu já vi Dahlias usando roupas assim."),
            nova_fala_encontro("Kiran", "Eu nem sei o que é um Dahlia."),
            nova_fala_encontro("Lumi", "Claro que não sabe. E eu sou uma pedra.")
        ];
        encontro_roteiro_opcoes1 = [
            "Eu não sou um Dahlia.",
            "Por que você está com tanto medo?",
            "Se eu fosse um Dahlia, o que faria?",
            "Eu realmente não lembro de nada."
        ];
        encontro_roteiro_rotas1 = [
            [
                nova_fala_encontro("Kiran", "Eu não sou um Dahlia."),
                nova_fala_encontro("Lumi", "Então explica isso."),
                nova_fala_encontro("Narração", "Ela aponta para as roupas de Kiran."),
                nova_fala_encontro("Kiran", "Eu acordei usando elas. É a única explicação que eu tenho."),
                nova_fala_encontro("Lumi", "Dahlias mentem melhor que isso."),
                nova_fala_encontro("Kiran", "Você está me chamando de mentiroso?"),
                nova_fala_encontro("Lumi", "Estou dizendo que não vou acreditar em alguém vestido como um deles só porque pediu."),
                nova_fala_encontro("Kiran", "Justo. Se eu estivesse no seu lugar, talvez também não acreditasse."),
                nova_fala_encontro("Lumi", "... Você concordou? Isso não prova nada.")
            ],
            [
                nova_fala_encontro("Kiran", "Por que você está com tanto medo de mim?"),
                nova_fala_encontro("Lumi", "Eu não estou com medo."),
                nova_fala_encontro("Kiran", "Você quase pulou para trás quando me viu. Parece medo."),
                nova_fala_encontro("Lumi", "E se for? Você acha que seria estranho?"),
                nova_fala_encontro("Kiran", "Eu nem fiz nada."),
                nova_fala_encontro("Lumi", "Ainda. É assim que começa. Primeiro aparece um Dahlia sozinho. Depois aparecem os outros. E, quando percebemos, alguém desapareceu."),
                nova_fala_encontro("Kiran", "Então é por isso."),
                nova_fala_encontro("Lumi", "É por isso.")
            ],
            [
                nova_fala_encontro("Kiran", "Se eu fosse um Dahlia... o que você faria?"),
                nova_fala_encontro("Narração", "O Florakii endurece a expressão."),
                nova_fala_encontro("Lumi", "Depende."),
                nova_fala_encontro("Kiran", "De quê?"),
                nova_fala_encontro("Lumi", "De quanto tempo eu teria antes de você chamar os outros."),
                nova_fala_encontro("Kiran", "Eu estou sozinho."),
                nova_fala_encontro("Lumi", "Isso é exatamente o que alguém tentando me prender diria."),
                nova_fala_encontro("Kiran", "Você desconfia de tudo?"),
                nova_fala_encontro("Lumi", "Eu continuo vivo, não continuo? Aqui, confiar na pessoa errada custa caro.")
            ],
            [
                nova_fala_encontro("Kiran", "Eu realmente não lembro. De nada. Eu acordei aqui. Não sei onde estou, de onde vim... nem por que estou vestido assim."),
                nova_fala_encontro("Lumi", "..."),
                nova_fala_encontro("Kiran", "Eu nem sei meu caminho de volta."),
                nova_fala_encontro("Lumi", "E espera que eu acredite nisso?"),
                nova_fala_encontro("Kiran", "Não. Mas é verdade."),
                nova_fala_encontro("Narração", "O Florakii fica alguns segundos em silêncio."),
                nova_fala_encontro("Lumi", "Você é estranho."),
                nova_fala_encontro("Kiran", "Já me disseram isso hoje.")
            ]
        ];
        encontro_roteiro_opcoes1 = [
            "Minhas roupas não dizem quem eu sou.",
            "Não vou atacar você.",
            "Se quer me impedir, vai ter que tentar."
        ];
        encontro_roteiro_metadados1 = [
            opcao_rota_encontro("lumi_01_neutro", "neutro"),
            opcao_rota_encontro("lumi_01_florakii", "florakii"),
            opcao_rota_encontro("lumi_01_dahlia", "dahlia")
        ];
        encontro_roteiro_rotas1 = [
            [
                nova_fala_encontro("Kiran", "Minhas roupas não dizem quem eu sou."),
                nova_fala_encontro("Lumi", "Então o que você é?"),
                nova_fala_encontro("Kiran", "Ainda estou tentando descobrir.")
            ],
            [
                nova_fala_encontro("Kiran", "Não vou atacar você."),
                nova_fala_encontro("Lumi", "Está vestido como um Dahlia."),
                nova_fala_encontro("Kiran", "Isso não significa que eu queira machucar você.")
            ],
            [
                nova_fala_encontro("Kiran", "Se quer me impedir, vai ter que tentar."),
                nova_fala_encontro("Lumi", "... Você fala exatamente como eles."),
                nova_fala_encontro("Kiran", "Talvez eu só esteja cansado de ser impedido.")
            ]
        ];
        encontro_roteiro_comum = [
            nova_fala_encontro("Narração", "A Florakii continua analisando Kiran. Então nota o pequeno broto em sua cabeça."),
            nova_fala_encontro("Lumi", "Espera."),
            nova_fala_encontro("Kiran", "O quê?"),
            nova_fala_encontro("Lumi", "Isso na sua cabeça."),
            nova_fala_encontro("Kiran", "Meu broto?"),
            nova_fala_encontro("Lumi", "Você chama de broto?"),
            nova_fala_encontro("Kiran", "Não sei. Parece um broto."),
            nova_fala_encontro("Narração", "Ela se aproxima um pouco, ainda cautelosa."),
            nova_fala_encontro("Lumi", "Dahlias não têm isso."),
            nova_fala_encontro("Kiran", "Então acredita em mim agora?"),
            nova_fala_encontro("Lumi", "Não se empolga. Só significa que você é um Dahlia muito estranho."),
            nova_fala_encontro("Kiran", "Eu não sou um Dahlia!"),
            nova_fala_encontro("Lumi", "Fala mais baixo!")
        ];
        encontro_roteiro_opcoes2 = [
            "O que faço para você acreditar?",
            "Você julga todos pelas roupas?",
            "Talvez esteja tão errada quanto eles.",
            "Esquece. Eu vou embora."
        ];
        encontro_roteiro_rotas2 = [
            [
                nova_fala_encontro("Kiran", "Então o que eu preciso fazer para você acreditar em mim?"),
                nova_fala_encontro("Lumi", "Nada. Confiança não funciona assim. Você não faz alguma coisa e recebe confiança como recompensa."),
                nova_fala_encontro("Kiran", "Então estamos presos nisso."),
                nova_fala_encontro("Lumi", "Por enquanto."),
                nova_fala_encontro("Kiran", "‘Por enquanto’ é melhor que ‘nunca’."),
                nova_fala_encontro("Lumi", "... Não força.")
            ],
            [
                nova_fala_encontro("Kiran", "Você sempre decide quem alguém é pelas roupas?"),
                nova_fala_encontro("Lumi", "Quando essas roupas pertencem às pessoas que nos perseguem? Sim."),
                nova_fala_encontro("Kiran", "Mas elas não dizem quem eu sou."),
                nova_fala_encontro("Lumi", "Para você, talvez não. Para mim, significam perigo. Eu não conheço você. Só conheço aquilo que essas roupas normalmente trazem com elas."),
                nova_fala_encontro("Kiran", "Então eu herdei uma péssima primeira impressão."),
                nova_fala_encontro("Lumi", "Péssima é pouco.")
            ],
            [
                nova_fala_encontro("Kiran", "Talvez você esteja tão errado sobre mim quanto eles estão sobre você."),
                nova_fala_encontro("Kiran", "Os Dahlias olham para vocês e decidem o que vocês são antes mesmo de ouvirem uma palavra. Você fez a mesma coisa comigo."),
                nova_fala_encontro("Lumi", "Não é a mesma coisa. Eles fazem isso porque acham que são superiores. Eu faço porque quero continuar viva."),
                nova_fala_encontro("Kiran", "Ainda assim, você decidiu quem eu era antes de eu abrir a boca."),
                nova_fala_encontro("Narração", "O Florakii desvia o olhar."),
                nova_fala_encontro("Lumi", "... Talvez."),
                nova_fala_encontro("Kiran", "Isso foi um ‘talvez eu esteja errado’?"),
                nova_fala_encontro("Lumi", "Não exagera.")
            ],
            [
                nova_fala_encontro("Kiran", "Esquece. Eu vou embora."),
                nova_fala_encontro("Narração", "Kiran começa a se virar."),
                nova_fala_encontro("Lumi", "Espera."),
                nova_fala_encontro("Kiran", "Hm?"),
                nova_fala_encontro("Lumi", "Se você realmente não sabe onde está... não segue por aquele caminho. Patrulha Dahlia."),
                nova_fala_encontro("Kiran", "Achei que você queria que eu fosse embora."),
                nova_fala_encontro("Lumi", "Quero. Só não quero que você leve uma patrulha até aqui quando te encontrarem."),
                nova_fala_encontro("Kiran", "Claro. Obrigado."),
                nova_fala_encontro("Lumi", "Eu não fiz isso por você.")
            ]
        ];
        encontro_roteiro_opcoes2 = [
            "Medo não dá direito de bloquear meu caminho.",
            "Você decidiu quem eu era antes de me conhecer.",
            "Entendo por que você desconfia."
        ];
        encontro_roteiro_metadados2 = [
            opcao_rota_encontro("lumi_02_dahlia", "dahlia"),
            opcao_rota_encontro("lumi_02_neutro", "neutro"),
            opcao_rota_encontro("lumi_02_florakii", "florakii")
        ];
        encontro_roteiro_rotas2 = [
            [
                nova_fala_encontro("Kiran", "Medo não dá direito de bloquear meu caminho."),
                nova_fala_encontro("Lumi", "E coragem não dá direito de ignorar o medo dos outros."),
                nova_fala_encontro("Kiran", "Então nenhum de nós pode decidir pelo outro.")
            ],
            [
                nova_fala_encontro("Kiran", "Você decidiu quem eu era antes de me conhecer."),
                nova_fala_encontro("Lumi", "Eu queria continuar viva."),
                nova_fala_encontro("Kiran", "Eu entendo. Ainda assim, você decidiu antes de eu abrir a boca."),
                nova_fala_encontro("Lumi", "... Talvez.")
            ],
            [
                nova_fala_encontro("Kiran", "Entendo por que você desconfia."),
                nova_fala_encontro("Lumi", "Entender não faz eu confiar em você."),
                nova_fala_encontro("Kiran", "Não. Mas talvez seja um começo.")
            ]
        ];
        encontro_roteiro_final = [
            nova_fala_encontro("Kiran", "Se minhas roupas são Dahlia... por que eu estou usando elas?"),
            nova_fala_encontro("Lumi", "Essa é uma ótima pergunta."),
            nova_fala_encontro("Kiran", "Você não sabe? Estou meio sem opções."),
            nova_fala_encontro("Lumi", "Você esperava que eu soubesse? Você definitivamente não parece um Dahlia por inteiro."),
            nova_fala_encontro("Kiran", "Finalmente."),
            nova_fala_encontro("Lumi", "Eu disse ‘por inteiro’. E também não parece Florakii."),
            nova_fala_encontro("Kiran", "Já confundiram comigo. Por causa disso."),
            nova_fala_encontro("Narração", "Kiran aponta para o broto."),
            nova_fala_encontro("Lumi", "Isso é ridículo. Um broto não transforma alguém em Florakii."),
            nova_fala_encontro("Kiran", "Você acabou de decidir que eu era Dahlia por causa da minha roupa."),
            nova_fala_encontro("Lumi", "... Não gostei de você."),
            nova_fala_encontro("Kiran", "Porque eu tenho razão?"),
            nova_fala_encontro("Lumi", "Principalmente por isso."),
            nova_fala_encontro("Lumi", "Escuta. Eu ainda não confio em você."),
            nova_fala_encontro("Kiran", "Já percebi."),
            nova_fala_encontro("Lumi", "Mas... se fosse mesmo um Dahlia, provavelmente já teria feito alguma coisa."),
            nova_fala_encontro("Kiran", "Essa é a coisa mais próxima de um pedido de desculpas que eu vou receber?"),
            nova_fala_encontro("Lumi", "É a coisa mais próxima de confiança que você vai receber."),
            nova_fala_encontro("Kiran", "Aceito."),
            nova_fala_encontro("Lumi", "Não deveria. Porque, se alguém perguntar... eu nunca falei com você."),
            nova_fala_encontro("Kiran", "Entendido."),
            nova_fala_encontro("Lumi", "E cobre essas roupas."),
            nova_fala_encontro("Kiran", "Elas são tão ruins assim?"),
            nova_fala_encontro("Lumi", "Aqui? Elas podem ser a diferença entre alguém perguntar seu nome... ou atacar antes de descobrir.")
        ];
    }
    else if (_tipo == 7) {
        batalha_inimigo = -1;
        encontro_roteiro_nome = "Rainha Dahlýria";
        encontro_roteiro_titulo = "Soberana de Velmora";
        encontro_roteiro_rotulo = "A COROA E A MEMÓRIA";
        encontro_roteiro_contexto = "As oferendas despertaram o salão antigo. A Rainha reconhece Kiran, mas teme aquilo que suas memórias podem abrir.";
        encontro_roteiro_retrato = spr_perfil_rainha_neutro;
        encontro_roteiro_cor = make_color_rgb(211, 196, 232);
        encontro_roteiro_tem_segunda_escolha = true;
        encontro_roteiro_linhas = [
            nova_fala_encontro("Narração", "Kiran entra no salão. As quatro oferendas orbitam sua luz e a floresta silencia atrás dele."),
            nova_fala_encontro("Rainha Dahlýria", "Então é verdade... Kiran voltou."),
            nova_fala_encontro("Kiran", "Você me conhece?"),
            nova_fala_encontro("Rainha Dahlýria", "Sei quem você foi. E sei que pediu para que ninguém decidisse por você quem deveria voltar a ser.")
        ];

        // A ordem mistura as três identidades. A interface nunca revela a
        // pontuação, apenas registra a intenção por trás da resposta.
        encontro_roteiro_opcoes1 = [
            "Qual era minha relação com você?",
            "Quem eu era?",
            "O que aconteceu com Velmora quando estive aqui?"
        ];
        encontro_roteiro_metadados1 = [
            opcao_rota_encontro("rainha_contato_dahlia", "dahlia"),
            opcao_rota_encontro("rainha_contato_neutro", "neutro"),
            opcao_rota_encontro("rainha_contato_florakii", "florakii")
        ];
        encontro_roteiro_rotas1 = [
            [
                nova_fala_encontro("Kiran", "Qual era minha relação com você?"),
                nova_fala_encontro("Rainha Dahlýria", "Complicada."),
                nova_fala_encontro("Kiran", "Isso não ajuda."),
                nova_fala_encontro("Rainha Dahlýria", "Você nunca foi meu subordinado. Mesmo quando eu desejava que fosse.")
            ],
            [
                nova_fala_encontro("Kiran", "Quem eu era?"),
                nova_fala_encontro("Rainha Dahlýria", "Sei quem você foi."),
                nova_fala_encontro("Kiran", "Então me diga."),
                nova_fala_encontro("Rainha Dahlýria", "Você pediu para que ninguém fizesse isso por você.")
            ],
            [
                nova_fala_encontro("Kiran", "O que aconteceu com Velmora quando eu estive aqui?"),
                nova_fala_encontro("Rainha Dahlýria", "Você a salvou."),
                nova_fala_encontro("Kiran", "De quê?"),
                nova_fala_encontro("Rainha Dahlýria", "É justamente isso que temo que descubra.")
            ]
        ];
        encontro_roteiro_comum = [
            nova_fala_encontro("Narração", "Os fragmentos deixam a bolsa de Kiran e formam um arco diante da porta coberta por raízes de cristal."),
            nova_fala_encontro("Rainha Dahlýria", "Você escolheu esquecer. Eu respeitei essa escolha, mesmo sem concordar."),
            nova_fala_encontro("Kiran", "Então eu tinha um motivo."),
            nova_fala_encontro("Rainha Dahlýria", "Tinha. Medo.")
        ];
        encontro_roteiro_opcoes2 = [
            "Se eu escolhi esquecer, devia ter um motivo.",
            "Você respeitou minha escolha de esquecer?",
            "Você deveria ter me impedido."
        ];
        encontro_roteiro_metadados2 = [
            opcao_rota_encontro("rainha_memoria_neutro", "neutro"),
            opcao_rota_encontro("rainha_memoria_florakii", "florakii"),
            opcao_rota_encontro("rainha_memoria_dahlia", "dahlia")
        ];
        encontro_roteiro_rotas2 = [
            [
                nova_fala_encontro("Kiran", "Se fui eu que escolhi esquecer, então devia ter um motivo."),
                nova_fala_encontro("Rainha Dahlýria", "Tinha."),
                nova_fala_encontro("Kiran", "Qual?"),
                nova_fala_encontro("Rainha Dahlýria", "Medo.")
            ],
            [
                nova_fala_encontro("Kiran", "Você respeitou minha escolha de esquecer?"),
                nova_fala_encontro("Rainha Dahlýria", "Sim."),
                nova_fala_encontro("Kiran", "Mesmo discordando?"),
                nova_fala_encontro("Rainha Dahlýria", "Principalmente por isso.")
            ],
            [
                nova_fala_encontro("Kiran", "Você deveria ter me impedido."),
                nova_fala_encontro("Rainha Dahlýria", "Era isso que queria?"),
                nova_fala_encontro("Kiran", "Talvez."),
                nova_fala_encontro("Rainha Dahlýria", "O Kiran que conheci teria odiado ouvir isso.")
            ]
        ];

        // O final é escolhido só depois das duas respostas da Rainha. Assim,
        // até a última decisão pode mudar a rota predominante.
        encontro_roteiro_finais_rainha = [
            [
                nova_fala_encontro("Narração", "A floresta responde aos fragmentos. Uma quinta luz desperta dentro do peito de Kiran."),
                nova_fala_encontro("Kiran", "Isso faz parte da floresta?"),
                nova_fala_encontro("Rainha Dahlýria", "Talvez tenha pertencido. Agora responde a você."),
                nova_fala_encontro("Kiran", "Se isso ameaça Velmora, eu não vou abrir."),
                nova_fala_encontro("Rainha Dahlýria", "Você disse algo parecido antes. Mas desta vez não precisa fazer isso sozinho."),
                nova_fala_encontro("Voz além da porta", "Portador do quinto fragmento... Abra a porta.")
            ],
            [
                nova_fala_encontro("Narração", "Os fragmentos despertam. Uma quinta luz, antiga e obediente, responde de dentro de Kiran."),
                nova_fala_encontro("Kiran", "Você sabia que eu carregava isso?"),
                nova_fala_encontro("Rainha Dahlýria", "Sim. Você me pediu para não dizer."),
                nova_fala_encontro("Kiran", "Se eu fechei essa porta uma vez, posso fazer de novo. O que estiver atrás dela terá de esperar."),
                nova_fala_encontro("Rainha Dahlýria", "Essa confiança também me parece familiar."),
                nova_fala_encontro("Voz além da porta", "Portador do quinto fragmento... Abra a porta.")
            ],
            [
                nova_fala_encontro("Narração", "Os quatro fragmentos se alinham. O quinto responde de dentro de Kiran, mas ele não se aproxima da porta."),
                nova_fala_encontro("Kiran", "Então isso faz parte de mim?"),
                nova_fala_encontro("Rainha Dahlýria", "Sim. Essa é uma das respostas que você apagou."),
                nova_fala_encontro("Kiran", "Não vou decidir até entender o que existe atrás dela. Ainda não."),
                nova_fala_encontro("Rainha Dahlýria", "Então mudou mais do que eu imaginava."),
                nova_fala_encontro("Voz além da porta", "Portador do quinto fragmento... Abra a porta.")
            ]
        ];
        encontro_roteiro_final = encontro_roteiro_finais_rainha[2];
    }
    else {
        batalha_inimigo = clamp(_tipo - 3, 0, 3);
        encontro_roteiro_nome = nomes_inimigos[batalha_inimigo];
        encontro_roteiro_titulo = titulos_inimigos[batalha_inimigo];
        encontro_roteiro_rotulo = rotulos_faccoes_inimigos[batalha_inimigo];
        encontro_roteiro_retrato = sprites_retrato_inimigos[batalha_inimigo];
        encontro_roteiro_cor = cores_inimigos[batalha_inimigo];
        encontro_roteiro_tem_segunda_escolha = false;
        encontro_roteiro_opcoes2 = [];
        encontro_roteiro_rotas2 = [];
        encontro_roteiro_final = [];

        if (batalha_inimigo == 0) {
            encontro_roteiro_contexto = "Guarda Real das Fontes. Mira protege uma oferenda antiga por ordem direta da Rainha.";
            encontro_roteiro_linhas = [
                nova_fala_encontro("Narração", "Kiran se aproxima da fonte. Mira bloqueia o caminho com a lança."),
                nova_fala_encontro("Mira", "Pare aí."),
                nova_fala_encontro("Kiran", "Eu só preciso chegar até a fonte."),
                nova_fala_encontro("Mira", "Eu sei."),
                nova_fala_encontro("Kiran", "Então isso facilita bastante."),
                nova_fala_encontro("Mira", "Não para você."),
                nova_fala_encontro("Kiran", "Imaginei."),
                nova_fala_encontro("Mira", "Há uma oferenda protegida aqui. Minha ordem é simples. Ninguém toca nela.")
            ];
            encontro_roteiro_opcoes1 = [
                "Eu preciso dela.",
                "Não quero lutar.",
                "Você nem sabe quem eu sou.",
                "A Rainha mandou proteger isso de quê?"
            ];
            encontro_roteiro_rotas1 = [
                [
                    nova_fala_encontro("Kiran", "Eu preciso da oferenda."),
                    nova_fala_encontro("Mira", "Todo mundo precisa de alguma coisa."),
                    nova_fala_encontro("Kiran", "Ela pode me ajudar a recuperar minhas memórias."),
                    nova_fala_encontro("Mira", "E isso deveria mudar minha ordem?"),
                    nova_fala_encontro("Kiran", "Para mim muda."),
                    nova_fala_encontro("Mira", "Esse é justamente o problema.")
                ],
                [
                    nova_fala_encontro("Kiran", "Eu não quero lutar com você."),
                    nova_fala_encontro("Mira", "Então não lute."),
                    nova_fala_encontro("Kiran", "E você me deixa passar?"),
                    nova_fala_encontro("Mira", "Não."),
                    nova_fala_encontro("Kiran", "Você percebe o problema, né?"),
                    nova_fala_encontro("Mira", "Percebo. Por isso ainda estamos conversando.")
                ],
                [
                    nova_fala_encontro("Kiran", "Você nem sabe quem eu sou."),
                    nova_fala_encontro("Mira", "Não preciso saber."),
                    nova_fala_encontro("Kiran", "Isso é um pouco preocupante."),
                    nova_fala_encontro("Mira", "Você quer algo que estou encarregada de proteger. Por enquanto, isso é suficiente.")
                ],
                [
                    nova_fala_encontro("Kiran", "A Rainha mandou proteger isso de quê?"),
                    nova_fala_encontro("Mira", "De pessoas que fariam exatamente o que você está tentando fazer."),
                    nova_fala_encontro("Kiran", "Tocar numa oferenda?"),
                    nova_fala_encontro("Mira", "Usar coisas antigas sem entender o que elas fazem."),
                    nova_fala_encontro("Kiran", "E ela entende?"),
                    nova_fala_encontro("Narração", "Mira hesita."),
                    nova_fala_encontro("Mira", "Minha ordem não exige essa resposta.")
                ]
            ];
            encontro_roteiro_opcoes1 = [
                "Você recebeu essa ordem diretamente da Rainha?",
                "Preciso da Essência para entender o vitral.",
                "Não quero tirar nada da floresta."
            ];
            encontro_roteiro_metadados1 = [
                opcao_rota_encontro("mira_contato_dahlia", "dahlia"),
                opcao_rota_encontro("mira_contato_neutro", "neutro"),
                opcao_rota_encontro("mira_contato_florakii", "florakii")
            ];
            encontro_roteiro_rotas1 = [
                [
                    nova_fala_encontro("Kiran", "Você recebeu essa ordem diretamente da Rainha?"),
                    nova_fala_encontro("Mira", "Recebi."),
                    nova_fala_encontro("Kiran", "Então está cumprindo seu dever."),
                    nova_fala_encontro("Mira", "Exatamente.")
                ],
                [
                    nova_fala_encontro("Kiran", "Preciso da Essência para entender o vitral."),
                    nova_fala_encontro("Mira", "Seu motivo não muda minha ordem."),
                    nova_fala_encontro("Kiran", "Nem sua ordem muda o que eu preciso descobrir.")
                ],
                [
                    nova_fala_encontro("Kiran", "Não quero tirar nada da floresta."),
                    nova_fala_encontro("Mira", "Mesmo assim veio buscar a Essência."),
                    nova_fala_encontro("Kiran", "Quero devolvê-la à estátua."),
                    nova_fala_encontro("Mira", "Então pelo menos sabe para que serve.")
                ]
            ];
            encontro_roteiro_comum = [
                nova_fala_encontro("Mira", "Ainda pode voltar."),
                nova_fala_encontro("Kiran", "E você?"),
                nova_fala_encontro("Mira", "Eu fico."),
                nova_fala_encontro("Kiran", "Então nenhum de nós vai sair do caminho."),
                nova_fala_encontro("Mira", "Parece que não.")
            ];
        }
        else if (batalha_inimigo == 1) {
            encontro_roteiro_contexto = "Guarda Real dos Jardins. Nilo escuta as raízes antes de confiar em qualquer visitante.";
            encontro_roteiro_linhas = [
                nova_fala_encontro("Narração", "Kiran entra no jardim."),
                nova_fala_encontro("Nilo", "Você está pisando nas raízes."),
                nova_fala_encontro("Narração", "Kiran olha para baixo e tira o pé rapidamente."),
                nova_fala_encontro("Kiran", "Desculpa."),
                nova_fala_encontro("Nilo", "Elas ouviram."),
                nova_fala_encontro("Kiran", "Elas... ouvem?"),
                nova_fala_encontro("Nilo", "Mais do que algumas pessoas."),
                nova_fala_encontro("Kiran", "Você está falando de mim?"),
                nova_fala_encontro("Nilo", "Ainda estou decidindo.")
            ];
            encontro_roteiro_opcoes1 = [
                "Só preciso da oferenda.",
                "Você fala com as plantas?",
                "Posso passar sem lutar?",
                "Você também trabalha para a Rainha?"
            ];
            encontro_roteiro_rotas1 = [
                [
                    nova_fala_encontro("Kiran", "Eu só preciso da oferenda."),
                    nova_fala_encontro("Nilo", "Não diga ‘só’."),
                    nova_fala_encontro("Kiran", "Por quê?"),
                    nova_fala_encontro("Nilo", "As coisas mais problemáticas costumam começar com alguém dizendo que ‘só precisa’ de alguma coisa."),
                    nova_fala_encontro("Kiran", "Tudo bem. Eu preciso muito da oferenda."),
                    nova_fala_encontro("Nilo", "Melhor."),
                    nova_fala_encontro("Kiran", "Vai me entregar?"),
                    nova_fala_encontro("Nilo", "Não.")
                ],
                [
                    nova_fala_encontro("Kiran", "Você realmente conversa com elas?"),
                    nova_fala_encontro("Nilo", "Às vezes."),
                    nova_fala_encontro("Kiran", "E elas respondem?"),
                    nova_fala_encontro("Nilo", "Às vezes."),
                    nova_fala_encontro("Kiran", "E o que estão dizendo sobre mim?"),
                    nova_fala_encontro("Narração", "Nilo olha para as raízes."),
                    nova_fala_encontro("Nilo", "Que você está nervoso."),
                    nova_fala_encontro("Kiran", "Eu poderia ter dito isso."),
                    nova_fala_encontro("Nilo", "Elas são menos barulhentas.")
                ],
                [
                    nova_fala_encontro("Kiran", "Posso passar sem lutar?"),
                    nova_fala_encontro("Nilo", "Pode."),
                    nova_fala_encontro("Kiran", "Sério?"),
                    nova_fala_encontro("Nilo", "Pode voltar por onde veio."),
                    nova_fala_encontro("Kiran", "Isso não conta."),
                    nova_fala_encontro("Nilo", "Para mim conta.")
                ],
                [
                    nova_fala_encontro("Kiran", "Você também serve à Rainha?"),
                    nova_fala_encontro("Nilo", "Sirvo ao jardim."),
                    nova_fala_encontro("Kiran", "Isso foi um não?"),
                    nova_fala_encontro("Nilo", "Foi um ‘é complicado’."),
                    nova_fala_encontro("Kiran", "Tenho ouvido muito isso ultimamente."),
                    nova_fala_encontro("Nilo", "Então talvez esteja começando a perceber como Velmora funciona.")
                ]
            ];
            encontro_roteiro_opcoes1 = [
                "Preciso da Semente Estelar.",
                "As plantas realmente falam com você?",
                "A Rainha mandou proteger a Semente?"
            ];
            encontro_roteiro_metadados1 = [
                opcao_rota_encontro("nilo_contato_neutro", "neutro"),
                opcao_rota_encontro("nilo_contato_florakii", "florakii"),
                opcao_rota_encontro("nilo_contato_dahlia", "dahlia")
            ];
            encontro_roteiro_rotas1 = [
                [
                    nova_fala_encontro("Kiran", "Preciso da Semente Estelar."),
                    nova_fala_encontro("Nilo", "Precisar não faz com que ela pertença a você."),
                    nova_fala_encontro("Kiran", "Mesmo assim, preciso continuar.")
                ],
                [
                    nova_fala_encontro("Kiran", "As plantas realmente falam com você?"),
                    nova_fala_encontro("Nilo", "Nem sempre com palavras."),
                    nova_fala_encontro("Kiran", "E o que dizem sobre mim?"),
                    nova_fala_encontro("Nilo", "Que ainda estão decidindo.")
                ],
                [
                    nova_fala_encontro("Kiran", "A Rainha mandou proteger a Semente?"),
                    nova_fala_encontro("Nilo", "Mandou."),
                    nova_fala_encontro("Kiran", "Então este é seu posto."),
                    nova_fala_encontro("Nilo", "E não vou abandoná-lo.")
                ]
            ];
            encontro_roteiro_comum = [
                nova_fala_encontro("Nilo", "Última chance."),
                nova_fala_encontro("Kiran", "Para mim ou para você?"),
                nova_fala_encontro("Nilo", "Para as flores."),
                nova_fala_encontro("Kiran", "..."),
                nova_fala_encontro("Nilo", "Elas não gostam de barulho.")
            ];
        }
        else {
            encontro_roteiro_contexto = "Capitão da Guarda Real. Orion conhece o nome de Kiran e protege a última oferenda da Coroa.";
            encontro_roteiro_linhas = [
                nova_fala_encontro("Orion", "Então você é Kiran."),
                nova_fala_encontro("Kiran", "Você sabe meu nome."),
                nova_fala_encontro("Orion", "Depois de Mira e Nilo? Sei mais do que gostaria."),
                nova_fala_encontro("Kiran", "Eles estão vivos."),
                nova_fala_encontro("Orion", "Eu sei."),
                nova_fala_encontro("Kiran", "Então não vim aqui matar ninguém."),
                nova_fala_encontro("Orion", "Isso não significa que você não seja perigoso.")
            ];
            encontro_roteiro_opcoes1 = [
                "Não quero ser seu inimigo.",
                "A Rainha sabe quem eu sou?",
                "Seus guardas me deram escolha.",
                "Só saia do caminho."
            ];
            encontro_roteiro_rotas1 = [
                [
                    nova_fala_encontro("Kiran", "Eu não quero ser seu inimigo."),
                    nova_fala_encontro("Orion", "Você carrega uma lâmina que não deveria ter despertado."),
                    nova_fala_encontro("Kiran", "Eu também gostaria de entender isso."),
                    nova_fala_encontro("Orion", "E mesmo assim continua usando."),
                    nova_fala_encontro("Kiran", "Porque ninguém mais está me dando respostas."),
                    nova_fala_encontro("Orion", "Respostas não tornam uma arma menos perigosa.")
                ],
                [
                    nova_fala_encontro("Kiran", "A Rainha sabe quem eu sou?"),
                    nova_fala_encontro("Orion", "Ela sabe que você existe."),
                    nova_fala_encontro("Kiran", "Não foi isso que eu perguntei."),
                    nova_fala_encontro("Orion", "Eu sei."),
                    nova_fala_encontro("Kiran", "Então?"),
                    nova_fala_encontro("Orion", "Não tenho permissão para dizer mais."),
                    nova_fala_encontro("Kiran", "Todo mundo aqui adora essa frase."),
                    nova_fala_encontro("Orion", "Ela mantém muita gente viva.")
                ],
                [
                    nova_fala_encontro("Kiran", "Mira e Nilo escolheram ficar no caminho."),
                    nova_fala_encontro("Orion", "Porque receberam ordens."),
                    nova_fala_encontro("Kiran", "Eles também escolheram como cumprir essas ordens."),
                    nova_fala_encontro("Orion", "..."),
                    nova_fala_encontro("Kiran", "Você sabe disso."),
                    nova_fala_encontro("Orion", "Sei. Mas também sei que você passou pelos dois.")
                ],
                [
                    nova_fala_encontro("Kiran", "Só saia do caminho."),
                    nova_fala_encontro("Orion", "Você ficou corajoso rápido."),
                    nova_fala_encontro("Kiran", "Estou cansado."),
                    nova_fala_encontro("Orion", "Isso costuma parecer coragem de longe."),
                    nova_fala_encontro("Kiran", "Quer descobrir de perto?"),
                    nova_fala_encontro("Orion", "Pretendo.")
                ]
            ];
            encontro_roteiro_opcoes1 = [
                "Entendo que você está cumprindo ordens.",
                "Só quero o Cristal e respostas.",
                "Seus guardas estavam tentando proteger Velmora."
            ];
            encontro_roteiro_metadados1 = [
                opcao_rota_encontro("orion_contato_dahlia", "dahlia"),
                opcao_rota_encontro("orion_contato_neutro", "neutro"),
                opcao_rota_encontro("orion_contato_florakii", "florakii")
            ];
            encontro_roteiro_rotas1 = [
                [
                    nova_fala_encontro("Kiran", "Entendo que você está cumprindo ordens."),
                    nova_fala_encontro("Orion", "Finalmente alguém entende."),
                    nova_fala_encontro("Kiran", "Entender não significa que vou obedecer.")
                ],
                [
                    nova_fala_encontro("Kiran", "Só quero o Cristal e respostas."),
                    nova_fala_encontro("Orion", "E se as respostas forem piores do que as perguntas?"),
                    nova_fala_encontro("Kiran", "Ainda serão minhas.")
                ],
                [
                    nova_fala_encontro("Kiran", "Seus guardas estavam tentando proteger Velmora."),
                    nova_fala_encontro("Orion", "E mesmo assim você passou por eles."),
                    nova_fala_encontro("Kiran", "Eu não precisava odiá-los para continuar.")
                ]
            ];
            encontro_roteiro_comum = [
                nova_fala_encontro("Orion", "Essa é sua última oportunidade de voltar."),
                nova_fala_encontro("Kiran", "Vocês realmente gostam de dizer isso."),
                nova_fala_encontro("Orion", "E você parece gostar de ignorar."),
                nova_fala_encontro("Kiran", "Até agora funcionou."),
                nova_fala_encontro("Orion", "Até agora não enfrentou o capitão.")
            ];
        }
    }

    batalha_fase = -4;
    batalha_iniciada = false;
    batalha_bloqueio = 8;
    global.jogo_pausado = true;
    global.dialogue_open = true;
    tela_pause = 5;
};

iniciar_confronto = function(_indice) {
    batalha_inimigo = clamp(_indice, 0, 3);
    batalha_opcao_confronto = 0;
    batalha_conversa_etapa = 0;
    batalha_conversa_opcao = 0;
    batalha_conversa_mouse = -1;
    batalha_conversa_visitou_pergunta = false;
    batalha_mouse_opcao = -1;
    batalha_troca_item_opcao = 0;
    batalha_resolvida_troca = false;
    batalha_fase = -3;
    batalha_iniciada = false;
    batalha_bloqueio = 8;
    batalha_mensagem = global.guardas_recusados[batalha_inimigo] > 0
        ? ameacas_retorno[batalha_inimigo]
        : ameacas_inimigos[batalha_inimigo];
    global.jogo_pausado = true;
    tela_pause = 5;
};

// Versão usada por obj_inimigo_mapa. Lê diretamente os campos escolhidos
// no painel de Variáveis da instância antes de abrir a conversa.
iniciar_confronto_instancia = function(_instancia_inimigo) {
    if (!instance_exists(_instancia_inimigo)) {
        exit;
    }

    var instancia_indice = clamp(round(_instancia_inimigo.inimigo_indice), 0, 3);
    var instancia_sprite_mapa = _instancia_inimigo.sprite_mapa_personalizado;
    var instancia_sprite_retrato = _instancia_inimigo.sprite_retrato_personalizado;
    var instancia_sprite_batalha = _instancia_inimigo.sprite_batalha_personalizado;
    var instancia_sprite_ataque = _instancia_inimigo.sprite_ataque_personalizado;

    // Também aceita o campo Sprite comum da instância, para que a troca possa
    // ser feita pelo fluxo mais simples do Room Editor.
    if (
        (instancia_sprite_mapa == -1 || !sprite_exists(instancia_sprite_mapa))
        && _instancia_inimigo.sprite_index != -1
        && sprite_exists(_instancia_inimigo.sprite_index)
    ) {
        instancia_sprite_mapa = _instancia_inimigo.sprite_index;
    }

    if (instancia_sprite_mapa != -1 && sprite_exists(instancia_sprite_mapa)) {
        sprites_mapa_inimigos[instancia_indice] = instancia_sprite_mapa;
    }

    if (instancia_sprite_retrato != -1 && sprite_exists(instancia_sprite_retrato)) {
        sprites_retrato_inimigos[instancia_indice] = instancia_sprite_retrato;
    }
    else if (
        (sprites_retrato_inimigos[instancia_indice] == -1
            || !sprite_exists(sprites_retrato_inimigos[instancia_indice]))
        && instancia_sprite_mapa != -1
        && sprite_exists(instancia_sprite_mapa)
    ) {
        sprites_retrato_inimigos[instancia_indice] = instancia_sprite_mapa;
    }

    if (instancia_sprite_batalha != -1 && sprite_exists(instancia_sprite_batalha)) {
        sprites_batalha_inimigos[instancia_indice] = instancia_sprite_batalha;
    }
    else if (instancia_sprite_mapa != -1 && sprite_exists(instancia_sprite_mapa)) {
        sprites_batalha_inimigos[instancia_indice] = instancia_sprite_mapa;
    }

    if (instancia_sprite_ataque != -1 && sprite_exists(instancia_sprite_ataque)) {
        sprites_ataque_inimigos[instancia_indice] = instancia_sprite_ataque;
    }

    // O valor 1 significa "usar o tamanho automático". Só uma escala
    // realmente personalizada substitui o ajuste definido no array acima.
    if (abs(_instancia_inimigo.escala_mapa_personalizada - 1) > 0.001) {
        escalas_mapa_inimigos[instancia_indice] =
            _instancia_inimigo.escala_mapa_personalizada;
    }
    if (abs(_instancia_inimigo.escala_batalha_personalizada - 1) > 0.001) {
        escalas_batalha_inimigos[instancia_indice] =
            _instancia_inimigo.escala_batalha_personalizada;
    }
    offsets_batalha_inimigos_x[instancia_indice] =
        _instancia_inimigo.offset_batalha_x;
    offsets_batalha_inimigos_y[instancia_indice] =
        _instancia_inimigo.offset_batalha_y;

    if (instancia_indice == 2 && !global.florakii_roteiro_visto) {
        iniciar_encontro_roteiro(2);
    }
    else if (
        instancia_indice != 2
        && !global.guardas_roteiro_visto[instancia_indice]
    ) {
        iniciar_encontro_roteiro(3 + instancia_indice);
    }
    else {
        iniciar_confronto(instancia_indice);
    }
};

iniciar_batalha = function(_indice) {
    batalha_inimigo = clamp(_indice, 0, 3);
    batalha_hp_max_inimigo = hp_max_inimigos[batalha_inimigo];
    batalha_corrupcao = batalha_hp_max_inimigo;
    batalha_serenidade = clamp(global.vida_kiran, 1, global.vida_kiran_max);
    batalha_opcao = 0;
    batalha_mouse_opcao = -1;
    batalha_fase = 0;
    batalha_timer = 0;
    batalha_bloqueio = 8;
    batalha_recompensa_recebida = false;
    batalha_rodada = 1;
    batalha_energia = 6;
    batalha_npc_enfraquecido = false;
    batalha_ultimo_foi_fraqueza = false;
    batalha_defesa_timer = 0;
    batalha_dano_pendente = 0;
    batalha_golpe_pendente = "";
    batalha_elite_desperto = false;
    batalha_iniciada = true;
    batalha_defesa_feedback = 0;
    batalha_defesa_posicao = 0;
    batalha_defesa_alvo = 0.5;
    batalha_animacao_ataque_kiran = 0;
    batalha_animacao_ataque_inimigo = 0;
    batalha_derrota_pendente = false;
    batalha_mensagem_derrota = "";
    batalha_menu = 0;
    batalha_acao_opcao = 0;
    batalha_tecnica_opcao = 0;
    batalha_item_opcao = 0;
    batalha_troca_item_opcao = 0;
    batalha_resolvida_troca = false;
    batalha_defesa_preparada = false;
    batalha_feedback_timer = 0;
    batalha_feedback_valor = 0;
    batalha_feedback_alvo = 0;
    batalha_feedback_tipo = 0;
    batalha_impacto_inimigo = 0;
    batalha_impacto_kiran = 0;
    batalha_status_inimigo = "";
    batalha_entrada_timer = global.config_reduzir_animacoes ? 0 : batalha_entrada_total;
    batalha_mensagem = nomes_inimigos[batalha_inimigo]
        + ": “" + falas_inicio_batalha[batalha_inimigo] + "”";

    global.jogo_pausado = true;
    tela_pause = 5;
};

batalha_finalizar_vitoria = function() {
    batalha_fase = 2;
    batalha_mensagem = nomes_inimigos[batalha_inimigo]
        + ": “" + falas_derrota_guardas[batalha_inimigo]
        + "”  Oferenda recebida: "
        + global.oferendas_estatuas[batalha_inimigo] + ".";

    if (!batalha_recompensa_recebida) {
        batalha_recompensa_recebida = true;
        global.inimigos_derrotados[batalha_inimigo] = true;
        recompensa_nome = global.oferendas_estatuas[batalha_inimigo];
        recompensa_descricao = descricoes_oferendas[batalha_inimigo];
        recompensa_sprite = sprites_oferendas[batalha_inimigo];
        recompensa_toast_pendente = true;
        global.inventario_adicionar_item(
            global.oferendas_estatuas[batalha_inimigo],
            descricoes_oferendas[batalha_inimigo],
            cores_inimigos[batalha_inimigo],
            "flor",
            sprites_oferendas[batalha_inimigo]
        );
    }
};

falas_troca_cura = [
    "Mira observa o presente em silêncio. “Você abriu mão de algo que poderia curá-lo. Leve a oferenda — considero nossa ordem cumprida.”",
    "Nilo segura o item com cuidado. “As raízes aceitaram seu gesto. A Semente pode seguir com você.”",
    "Lumi hesita antes de receber a cura. “Você confiou em mim quando não precisava. Pegue a oferenda... antes que eu mude de ideia.”",
    "Orion baixa a arma. “Uma troca, não uma vitória. Talvez seja a primeira decisão sensata desta patrulha. O Cristal é seu.”"
];

// Consome uma cura e conclui o encontro sem iniciar combate. Para o restante
// da progressão, o adversário fica resolvido como após uma vitória normal.
batalha_finalizar_troca = function(_item_cura) {
    if (!is_struct(_item_cura)) return false;

    var troca_item_id = variable_struct_exists(_item_cura, "id")
        ? _item_cura.id
        : _item_cura.nome;

    if (!global.inventario_remover_item_id(troca_item_id)) return false;

    if (variable_global_exists("adicionar_ponto_rota")) {
        global.adicionar_ponto_rota(
            "neutro",
            1,
            "troca_cura_" + string(batalha_inimigo)
        );
    }

    batalha_resolvida_troca = true;
    batalha_iniciada = false;
    batalha_fase = 2;
    batalha_bloqueio = 8;
    batalha_mensagem = falas_troca_cura[batalha_inimigo]
        + "  " + _item_cura.nome + " foi entregue. Oferenda recebida: "
        + global.oferendas_estatuas[batalha_inimigo] + ".";

    if (!batalha_recompensa_recebida) {
        batalha_recompensa_recebida = true;
        global.inimigos_derrotados[batalha_inimigo] = true;
        recompensa_nome = global.oferendas_estatuas[batalha_inimigo];
        recompensa_descricao = descricoes_oferendas[batalha_inimigo];
        recompensa_sprite = sprites_oferendas[batalha_inimigo];
        recompensa_toast_pendente = true;
        global.inventario_adicionar_item(
            recompensa_nome,
            recompensa_descricao,
            cores_inimigos[batalha_inimigo],
            "flor",
            recompensa_sprite
        );
    }

    return true;
};

batalha_preparar_contra_ataque = function(_mensagem_acao) {
    var golpe_forte = false;

    // Cada adversário possui um ritmo reconhecível. Orion acelera na segunda fase.
    switch (batalha_inimigo) {
        case 0:
            golpe_forte = batalha_rodada mod 3 == 0;
        break;

        case 1:
            golpe_forte = batalha_rodada mod 2 == 0;
        break;

        case 2:
            golpe_forte = batalha_energia <= 2 || batalha_rodada mod 3 == 0;
        break;

        case 3:
            golpe_forte = batalha_elite_desperto
                ? batalha_rodada mod 2 == 0
                : batalha_rodada mod 3 == 0;
        break;
    }

    var bonus_elite = 0;

    if (
        batalha_inimigo == 3
        && batalha_corrupcao <= batalha_hp_max_inimigo * 0.5
    ) {
        golpe_forte = true;
        bonus_elite = 4;

        if (!batalha_elite_desperto) {
            batalha_elite_desperto = true;
            _mensagem_acao += "  Orion: ‘Chega. Finalmente parei de pegar leve.’ "
                + "Kiran: ‘Vocês também gostam muito dessa frase.’ "
                + "Orion: ‘Continue falando. Talvez ajude quando ficar sem fôlego.’";
        }
    }

    batalha_golpe_pendente = golpe_forte
        ? golpes_inimigos_fortes[batalha_inimigo]
        : golpes_inimigos[batalha_inimigo];
    batalha_dano_pendente = irandom_range(
        dano_min_inimigos[batalha_inimigo],
        dano_max_inimigos[batalha_inimigo]
    ) + bonus_elite;

    if (batalha_npc_enfraquecido) {
        batalha_dano_pendente = max(1, batalha_dano_pendente - 6);
        batalha_npc_enfraquecido = false;
    }

    batalha_defesa_timer = batalha_defesa_total;
    batalha_defesa_janela_perfeita = batalha_defesa_preparada ? 8 : 4;
    batalha_defesa_janela_boa = batalha_defesa_preparada ? 18 : 10;

    // A zona muda de lugar em todos os ataques. Se o sorteio cair perto
    // demais da posição anterior, deslocamos para o outro lado da barra.
    var defesa_alvo_anterior = batalha_defesa_alvo;
    var defesa_alvo_novo = random_range(0.20, 0.80);

    if (abs(defesa_alvo_novo - defesa_alvo_anterior) < 0.14) {
        defesa_alvo_novo += defesa_alvo_novo < 0.5 ? 0.28 : -0.28;
    }

    batalha_defesa_alvo = clamp(defesa_alvo_novo, 0.20, 0.80);
    batalha_fase = 6;
    batalha_timer = global.config_reduzir_animacoes ? 16 : 34;
    batalha_menu = 0;
    batalha_mensagem = _mensagem_acao + "  "
        + nomes_inimigos[batalha_inimigo]
        + " prepara " + batalha_golpe_pendente + ".";
};

batalha_executar_golpe = function(_golpe_indice) {
    var golpe_indice = clamp(_golpe_indice, 0, 3);
    var golpe_custo = batalha_custos_golpes[golpe_indice];

    if (batalha_energia < golpe_custo) {
        batalha_mensagem = "Energia insuficiente para "
            + batalha_opcoes[golpe_indice] + ".";
        global.tocar_som_ui(0.90);
        return false;
    }

    batalha_energia -= golpe_custo;

    if (golpe_indice == 0) {
        batalha_energia = min(batalha_energia_max, batalha_energia + 1);
    }

    var golpe_tipo = batalha_tipos_golpes[golpe_indice];
    var golpe_multiplicador = 1;
    batalha_ultimo_foi_fraqueza =
        golpe_tipo == fraquezas_inimigos[batalha_inimigo];

    if (batalha_ultimo_foi_fraqueza) {
        golpe_multiplicador = 1.65;
    }
    else if (golpe_tipo == tipos_inimigos[batalha_inimigo]) {
        golpe_multiplicador = 0.72;
    }

    var golpe_critico = golpe_indice == 3 && irandom(3) == 0;
    if (golpe_critico) {
        golpe_multiplicador *= 1.45;
    }

    var golpe_dano = max(1, round(
        batalha_poder_golpes[golpe_indice]
        * golpe_multiplicador
        * random_range(0.92, 1.08)
    ));
    batalha_corrupcao = max(0, batalha_corrupcao - golpe_dano);
    batalha_feedback_timer = batalha_feedback_total;
    batalha_feedback_valor = golpe_dano;
    batalha_feedback_alvo = 1;
    batalha_feedback_tipo = batalha_ultimo_foi_fraqueza || golpe_critico ? 2 : 1;
    batalha_impacto_inimigo = global.config_reduzir_animacoes ? 0 : 1;
    batalha_animacao_ataque_kiran = global.config_reduzir_animacoes ? 10 : 28;

    if (variable_global_exists("tocar_sfx")) {
        var golpe_tons_sfx = [1.00, 1.12, 0.90, 1.20];
        global.tocar_sfx(
            global.sfx_ataque_kiran,
            0.56,
            golpe_tons_sfx[golpe_indice]
        );
    }

    var golpe_texto = "Kiran usou " + batalha_opcoes[golpe_indice]
        + " e causou " + string(golpe_dano) + " de dano.";

    if (golpe_indice == 1) {
        var golpe_vida_antes = batalha_serenidade;
        batalha_serenidade = min(global.vida_kiran_max, batalha_serenidade + 12);
        var golpe_cura = batalha_serenidade - golpe_vida_antes;
        global.vida_kiran = batalha_serenidade;

        if (golpe_cura > 0) {
            golpe_texto += " A lâmina devolveu " + string(golpe_cura) + " de vida.";
            if (variable_global_exists("tocar_sfx")) {
                global.tocar_sfx(global.sfx_cura, 0.42, 1.08);
            }
        }
    }

    if (golpe_indice == 2) {
        batalha_npc_enfraquecido = true;
        batalha_status_inimigo = "Próximo golpe enfraquecido";
        golpe_texto += " A força do próximo ataque inimigo diminuiu.";
    }
    else {
        batalha_status_inimigo = "";
    }

    if (batalha_ultimo_foi_fraqueza) {
        golpe_texto += " Super efetivo!";
    }
    else if (golpe_multiplicador < 1) {
        golpe_texto += " Pouco efetivo.";
    }

    if (golpe_critico) {
        golpe_texto += " Acerto crítico!";
    }

    if (batalha_corrupcao <= 0) {
        batalha_finalizar_vitoria();
    }
    else {
        batalha_preparar_contra_ataque(golpe_texto);
    }

    return true;
};

batalha_usar_consumivel = function(_item_indice) {
    var curativos = global.inventario_itens_curativos(true);

    if (array_length(curativos) <= 0) {
        batalha_mensagem = "A bolsa não possui nenhum item curativo.";
        global.tocar_som_ui(0.90);
        return false;
    }

    var item_indice = clamp(_item_indice, 0, array_length(curativos) - 1);
    var item_cura = curativos[item_indice];

    if (batalha_serenidade >= global.vida_kiran_max) {
        batalha_mensagem = "A vida de Kiran já está completa. O item foi preservado.";
        global.tocar_som_ui(0.92);
        return false;
    }

    var vida_antes_item = batalha_serenidade;
    batalha_serenidade = min(
        global.vida_kiran_max,
        batalha_serenidade + item_cura.cura
    );
    global.vida_kiran = batalha_serenidade;
    var cura_real_item = batalha_serenidade - vida_antes_item;
    var id_item_cura = variable_struct_exists(item_cura, "id")
        ? item_cura.id
        : item_cura.nome;

    global.inventario_remover_item_id(id_item_cura);
    batalha_feedback_timer = batalha_feedback_total;
    batalha_feedback_valor = cura_real_item;
    batalha_feedback_alvo = 0;
    batalha_feedback_tipo = 3;
    batalha_impacto_kiran = global.config_reduzir_animacoes ? 0 : 1;
    batalha_preparar_contra_ataque(
        "Kiran usou " + item_cura.nome + " e recuperou "
            + string(cura_real_item) + " de vida."
    );
    if (variable_global_exists("tocar_sfx")) {
        global.tocar_sfx(global.sfx_cura, 0.52, 1.00);
    }
    return true;
};

batalha_assumir_guarda = function() {
    batalha_defesa_preparada = true;
    batalha_energia = min(batalha_energia_max, batalha_energia + 2);
    batalha_preparar_contra_ataque(
        "Kiran firmou a Lâmina do Fragmento e recuperou 2 de energia."
    );
    if (variable_global_exists("tocar_sfx")) {
        global.tocar_sfx(global.sfx_defesa, 0.36, 0.92);
    }
};

encerrar_batalha = function() {
    var encerrando_com_vitoria = batalha_fase == 2;
    var indice_encerrado = batalha_inimigo;

    if (batalha_fase == 2 && recompensa_toast_pendente) {
        recompensa_toast_timer = recompensa_toast_total;
        recompensa_toast_pendente = false;
    }

    if (batalha_iniciada) {
        global.vida_kiran = batalha_fase == 3
            ? max(30, batalha_serenidade)
            : clamp(batalha_serenidade, 0, global.vida_kiran_max);
    }

    tela_pause = 0;
    global.jogo_pausado = false;
    batalha_inimigo = -1;
    inimigo_proximo = -1;
    batalha_iniciada = false;

    if (
        encerrando_com_vitoria
        && !batalha_resolvida_troca
        && indice_encerrado >= 0
        && array_length(opcoes_pos_vitoria_guardas[indice_encerrado]) > 0
    ) {
        dialogo_pos_vitoria_indice = indice_encerrado;
        dialogo_pos_vitoria_timer = 2;
    }
};

inventario_abas = [
    "Itens",
    "Armas",
    "Roupas",
    "Missões"
];

inventario_aba = 0;
inventario_slot = 0;
inventario_mouse_aba = -1;
inventario_mouse_slot = -1;
inventario_mensagem = "";
inventario_mensagem_timer = 0;

if (!variable_global_exists("tem_fragmento")) {
    global.tem_fragmento = false;
}

if (!variable_global_exists("fragmentos_vitral")) {
    global.fragmentos_vitral = [false, false, false, false];
}

if (!variable_global_exists("fragmento_reconhecido")) {
    global.fragmento_reconhecido = false;
}

if (!variable_global_exists("vitral_resolvido")) {
    global.vitral_resolvido = false;
}

// ═════════════════════════════════════════════
// TELAS
// ═════════════════════════════════════════════
tela_pause = 0;

// 0 = menu principal
// 1 = controles
// 2 = configurações
// 3 = pausa sensorial
// 4 = inventário

opcao_pause = 0;
mouse_pause = -1;

tempo_pause = 0;
resp_tempo = 0;


// ═════════════════════════════════════════════
// BOTÕES DO MENU PRINCIPAL
// ═════════════════════════════════════════════
opcoes_pause = [
    "Pausa sensorial",
    "Continuar",
    "Inventário",
    "Controles",
    "Configurações",
    "Voltar ao menu"
];

botao_pause_y = [
    185,
    275,
    333,
    391,
    449,
    507
];

botao_pause_x1 = [
    405,
    475,
    475,
    475,
    475,
    475
];

botao_pause_x2 = [
    875,
    805,
    805,
    805,
    805,
    805
];

botao_pause_h = [
    66,
    46,
    46,
    46,
    46,
    46
];

hover_pause = [
    0,
    0,
    0,
    0,
    0,
    0
];


// ═════════════════════════════════════════════
// CONFIGURAÇÕES
// ═════════════════════════════════════════════
config_opcao_atual = 0;
config_mouse_sobre = -1;
config_arrastando = -1;


// ═════════════════════════════════════════════
// DESENHAR FOLHINHA
// ═════════════════════════════════════════════
desenhar_folha_pause = function(
    _x,
    _y,
    _alpha
) {
    var cor_folha = make_color_rgb(78, 105, 125);
    var cor_nervura = make_color_rgb(58, 82, 105);

    // Caule
    draw_set_alpha(_alpha * 0.80);
    draw_set_color(cor_nervura);

    draw_line_width(
        _x,
        _y + 10,
        _x + 2,
        _y - 10,
        1
    );

    // Folha esquerda
    draw_set_alpha(_alpha);
    draw_set_color(cor_folha);

    draw_ellipse(
        _x - 10,
        _y - 7,
        _x + 1,
        _y + 3,
        false
    );

    // Folha direita
    draw_ellipse(
        _x,
        _y - 13,
        _x + 12,
        _y - 2,
        false
    );

    // Nervuras
    draw_set_alpha(_alpha * 0.48);
    draw_set_color(cor_nervura);

    draw_line(
        _x - 7,
        _y - 3,
        _x,
        _y
    );

    draw_line(
        _x + 2,
        _y - 7,
        _x + 9,
        _y - 10
    );
};

desenhar_folha_ajustes_pause = function(
    _cx, _cy, _angulo, _comprimento, _largura, _cor, _alpha
) {
    var _dx = dcos(_angulo);
    var _dy = dsin(_angulo);
    var _nx = -_dy;
    var _ny = _dx;
    var _meio_c = _comprimento * 0.5;
    var _meio_l = _largura * 0.5;
    var _ponta_x = _cx + _dx * _meio_c;
    var _ponta_y = _cy + _dy * _meio_c;
    var _base_x = _cx - _dx * _meio_c;
    var _base_y = _cy - _dy * _meio_c;

    draw_set_alpha(_alpha);
    draw_set_color(_cor);
    draw_triangle(
        _ponta_x, _ponta_y,
        _cx + _nx * _meio_l, _cy + _ny * _meio_l,
        _base_x, _base_y,
        false
    );
    draw_triangle(
        _ponta_x, _ponta_y,
        _cx - _nx * _meio_l, _cy - _ny * _meio_l,
        _base_x, _base_y,
        false
    );
    draw_set_alpha(_alpha * 0.62);
    draw_line_width(_base_x, _base_y, _ponta_x, _ponta_y, 1);
};

desenhar_raminho_ajustes_pause = function(_x, _y, _espelho, _alpha) {
    var _lado = _espelho ? -1 : 1;
    var _verde_escuro = make_color_rgb(66, 112, 96);
    var _verde_claro = make_color_rgb(116, 168, 139);

    draw_set_alpha(_alpha * 0.88);
    draw_set_color(_verde_escuro);
    draw_line_width(_x, _y, _x + 38 * _lado, _y - 26, 2);
    draw_line_width(_x + 16 * _lado, _y - 11, _x + 12 * _lado, _y - 26, 1);
    draw_line_width(_x + 28 * _lado, _y - 19, _x + 35 * _lado, _y - 34, 1);

    desenhar_folha_ajustes_pause(_x + 8 * _lado, _y - 7, _espelho ? 205 : 335, 24, 13, _verde_escuro, _alpha);
    desenhar_folha_ajustes_pause(_x + 14 * _lado, _y - 21, _espelho ? 330 : 210, 26, 14, _verde_claro, _alpha * 0.94);
    desenhar_folha_ajustes_pause(_x + 28 * _lado, _y - 18, _espelho ? 205 : 335, 25, 13, _verde_escuro, _alpha * 0.96);
    desenhar_folha_ajustes_pause(_x + 37 * _lado, _y - 32, _espelho ? 330 : 210, 22, 12, _verde_claro, _alpha * 0.90);
};


// ═════════════════════════════════════════════
// DESENHAR TECLA
// ═════════════════════════════════════════════
desenhar_tecla_pause = function(
    _x,
    _y,
    _texto,
    _largura
) {
    var altura = 34;

    var cor_fundo_tecla =
        make_color_rgb(228, 230, 242);

    var cor_borda_tecla =
        make_color_rgb(101, 107, 157);

    var cor_texto_tecla =
        make_color_rgb(55, 63, 96);

    // Sombra
    draw_set_alpha(0.08);
    draw_set_color(cor_borda_tecla);

    draw_roundrect(
        _x + 2,
        _y + 3,
        _x + _largura + 2,
        _y + altura + 3,
        false
    );

    // Fundo
    draw_set_alpha(0.82);
    draw_set_color(cor_fundo_tecla);

    draw_roundrect(
        _x,
        _y,
        _x + _largura,
        _y + altura,
        false
    );

    // Borda
    draw_set_alpha(0.56);
    draw_set_color(cor_borda_tecla);

    draw_roundrect(
        _x,
        _y,
        _x + _largura,
        _y + altura,
        true
    );

    // Texto
    draw_set_alpha(1);
    draw_set_color(cor_texto_tecla);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_text(
        _x + _largura / 2,
        _y + altura / 2,
        _texto
    );
};


// ═════════════════════════════════════════════
// FOLHA DE VIDA EM VITRAL
// ═════════════════════════════════════════════
desenhar_folha_vitral = function(
    _x,
    _y,
    _nivel,
    _escala,
    _pulso
) {
    var nivel = clamp(_nivel, 0, 1);
    var sprite_folha = nivel <= 0
        ? hud_sprite_folha_vazia
        : (nivel >= 0.999 ? hud_sprite_folha_cheia : hud_sprite_folha_parcial);

    if (sprite_folha != -1 && sprite_exists(sprite_folha)) {
        var sprite_largura = max(1, sprite_get_width(sprite_folha));
        var escala_asset = _escala * 42 / sprite_largura;
        var sprite_cor = _pulso < 0
            ? make_color_rgb(218, 111, 157)
            : c_white;
        draw_set_alpha(1);
        draw_sprite_ext(
            sprite_folha,
            0,
            _x,
            _y,
            escala_asset,
            escala_asset,
            0,
            sprite_cor,
            1
        );

        if (
            _pulso > 0
            && hud_sprite_folha_brilho != -1
            && sprite_exists(hud_sprite_folha_brilho)
        ) {
            draw_set_alpha(0.72);
            draw_sprite_ext(
                hud_sprite_folha_brilho,
                0,
                _x,
                _y,
                escala_asset,
                escala_asset,
                0,
                c_white,
                1
            );
        }

        return;
    }

    // Silhueta angular de oito pontos: evita a aparência de elipses provisórias.
    var pontos_x = [-19, -13, -3, 10, 21, 17, 7, -7];
    var pontos_y = [8, -7, -18, -14, -3, 11, 20, 18];
    var contorno = make_color_rgb(73, 79, 119);
    var vazio = make_color_rgb(222, 220, 231);
    var menta = make_color_rgb(130, 205, 171);
    var menta_clara = make_color_rgb(190, 239, 217);
    var rosa = make_color_rgb(222, 132, 172);
    var lilas = make_color_rgb(188, 176, 226);
    var cor_base = nivel <= 0
        ? vazio
        : merge_color(rosa, menta, nivel);
    var escala_pulso = _escala * (1 + abs(_pulso) * 0.07);

    // Sombra recortada.
    draw_set_alpha(0.16);
    draw_set_color(make_color_rgb(28, 35, 60));
    for (var sombra_i = 0; sombra_i < 8; sombra_i++) {
        var sombra_prox = (sombra_i + 1) mod 8;
        draw_triangle(
            _x + 2,
            _y + 4,
            _x + pontos_x[sombra_i] * escala_pulso + 2,
            _y + pontos_y[sombra_i] * escala_pulso + 4,
            _x + pontos_x[sombra_prox] * escala_pulso + 2,
            _y + pontos_y[sombra_prox] * escala_pulso + 4,
            false
        );
    }

    // Casco vazio do vitral.
    draw_set_alpha(nivel <= 0 ? 0.72 : 0.92);
    for (var face_i = 0; face_i < 8; face_i++) {
        var face_prox = (face_i + 1) mod 8;
        draw_set_color(face_i mod 2 == 0
            ? cor_base
            : merge_color(cor_base, lilas, nivel <= 0 ? 0.18 : 0.28));
        draw_triangle(
            _x,
            _y,
            _x + pontos_x[face_i] * escala_pulso,
            _y + pontos_y[face_i] * escala_pulso,
            _x + pontos_x[face_prox] * escala_pulso,
            _y + pontos_y[face_prox] * escala_pulso,
            false
        );
    }

    // A parte restante ocupa um miolo menor, tornando a vida parcial legível
    // mesmo sem depender da diferença entre verde e rosa.
    if (nivel > 0 && nivel < 0.999) {
        var escala_interna = escala_pulso * (0.42 + nivel * 0.43);
        draw_set_alpha(0.82);
        for (var miolo_i = 0; miolo_i < 8; miolo_i++) {
            var miolo_prox = (miolo_i + 1) mod 8;
            draw_set_color(miolo_i mod 2 == 0 ? menta : menta_clara);
            draw_triangle(
                _x,
                _y,
                _x + pontos_x[miolo_i] * escala_interna,
                _y + pontos_y[miolo_i] * escala_interna,
                _x + pontos_x[miolo_prox] * escala_interna,
                _y + pontos_y[miolo_prox] * escala_interna,
                false
            );
        }
    }

    // Chumbo, nervura e rachadura da folha parcial.
    draw_set_alpha(0.78);
    draw_set_color(contorno);
    for (var linha_i = 0; linha_i < 8; linha_i++) {
        var linha_prox = (linha_i + 1) mod 8;
        draw_line_width(
            _x + pontos_x[linha_i] * escala_pulso,
            _y + pontos_y[linha_i] * escala_pulso,
            _x + pontos_x[linha_prox] * escala_pulso,
            _y + pontos_y[linha_prox] * escala_pulso,
            2
        );
    }
    draw_line_width(
        _x - 15 * escala_pulso,
        _y + 13 * escala_pulso,
        _x + 17 * escala_pulso,
        _y - 7 * escala_pulso,
        1.5
    );
    draw_set_alpha(0.34);
    draw_set_color(c_white);
    draw_line_width(
        _x - 5 * escala_pulso,
        _y - 11 * escala_pulso,
        _x + 8 * escala_pulso,
        _y - 10 * escala_pulso,
        2
    );

    if (nivel > 0 && nivel < 0.999) {
        draw_set_alpha(0.72);
        draw_set_color(contorno);
        draw_line(_x + 2, _y - 2, _x - 5, _y + 6);
        draw_line(_x - 5, _y + 6, _x + 1, _y + 13);
    }
};

// A moldura ilustrada já contém cinco folhas verdes. Esta camada acompanha
// o HP real e "desbota" cada uma delas sem substituir a arte escolhida.
// Cada folha vale 20% da vida máxima; folhas parciais mudam gradualmente.
desenhar_estado_hud_ilustrado = function(
    _base_x,
    _base_y,
    _escala_arte,
    _vida,
    _vida_max
) {
    var vida_maxima = max(1, _vida_max);
    var vida_atual = clamp(_vida, 0, vida_maxima);
    var centros_x = [643, 859, 1076, 1286, 1492];
    var centro_y = 469;
    var pontos_x = [-58, -49, -20, 24, 56, 44, 5, -36];
    var pontos_y = [18, -34, -82, -59, -10, 34, 57, 45];
    var cor_vazia = make_color_rgb(231, 207, 220);
    var cor_parcial = make_color_rgb(225, 157, 191);
    var cor_contorno = make_color_rgb(104, 91, 133);

    for (var folha_i = 0; folha_i < 5; folha_i++) {
        var nivel = clamp(
            (vida_atual - folha_i * vida_maxima / 5)
                / (vida_maxima / 5),
            0,
            1
        );
        var perda = 1 - nivel;

        if (perda > 0.001) {
            var folha_x = _base_x + centros_x[folha_i] * _escala_arte;
            var folha_y = _base_y + centro_y * _escala_arte;
            var cor_perda = merge_color(cor_vazia, cor_parcial, perda < 0.999 ? 0.62 : 0.20);

            // A lavagem rosa acompanha exatamente a silhueta aproximada da
            // folha da ilustração, preservando o papel e o galho ao redor.
            draw_set_alpha(0.18 + perda * 0.70);
            draw_set_color(cor_perda);
            for (var folha_face = 0; folha_face < 8; folha_face++) {
                var folha_proxima = (folha_face + 1) mod 8;
                draw_triangle(
                    folha_x,
                    folha_y,
                    folha_x + pontos_x[folha_face] * _escala_arte,
                    folha_y + pontos_y[folha_face] * _escala_arte,
                    folha_x + pontos_x[folha_proxima] * _escala_arte,
                    folha_y + pontos_y[folha_proxima] * _escala_arte,
                    false
                );
            }

            draw_set_alpha(0.30 + perda * 0.48);
            draw_set_color(cor_contorno);
            draw_line_width(
                folha_x - 42 * _escala_arte,
                folha_y + 35 * _escala_arte,
                folha_x + 39 * _escala_arte,
                folha_y - 31 * _escala_arte,
                max(1, 5 * _escala_arte)
            );

            // Uma pequena rachadura torna a folha totalmente vazia legível
            // mesmo para quem não distingue bem verde e rosa.
            if (nivel <= 0.001) {
                draw_line_width(
                    folha_x + 2 * _escala_arte,
                    folha_y - 3 * _escala_arte,
                    folha_x - 18 * _escala_arte,
                    folha_y + 17 * _escala_arte,
                    max(1, 4 * _escala_arte)
                );
                draw_line_width(
                    folha_x - 18 * _escala_arte,
                    folha_y + 17 * _escala_arte,
                    folha_x - 4 * _escala_arte,
                    folha_y + 31 * _escala_arte,
                    max(1, 4 * _escala_arte)
                );
            }
        }
    }

    draw_set_alpha(1);
    draw_set_color(c_white);
};

// Estado das folhas da arte criada para os inimigos. Os centros são próprios
// desta moldura, que possui folhas maiores e na posição vertical.
desenhar_estado_hud_inimigo = function(
    _base_x,
    _base_y,
    _escala_arte,
    _vida,
    _vida_max
) {
    var vida_maxima = max(1, _vida_max);
    var vida_atual = clamp(_vida, 0, vida_maxima);
    var centros_x = [707, 906, 1106, 1303, 1502];
    var centro_y = 392;
    var pontos_x = [-55, -43, 0, 43, 55, 38, 0, -38];
    var pontos_y = [0, -54, -76, -54, 0, 54, 76, 54];
    var cor_vazia = make_color_rgb(230, 207, 224);
    var cor_parcial = make_color_rgb(216, 160, 199);
    var cor_contorno = make_color_rgb(90, 82, 126);

    for (var folha_i = 0; folha_i < 5; folha_i++) {
        var nivel = clamp(
            (vida_atual - folha_i * vida_maxima / 5)
                / (vida_maxima / 5),
            0,
            1
        );
        var perda = 1 - nivel;

        if (perda > 0.001) {
            var folha_x = _base_x + centros_x[folha_i] * _escala_arte;
            var folha_y = _base_y + centro_y * _escala_arte;
            draw_set_alpha(0.18 + perda * 0.70);
            draw_set_color(merge_color(cor_vazia, cor_parcial, perda < 0.999 ? 0.60 : 0.18));

            for (var face_i = 0; face_i < 8; face_i++) {
                var face_proxima = (face_i + 1) mod 8;
                draw_triangle(
                    folha_x,
                    folha_y,
                    folha_x + pontos_x[face_i] * _escala_arte,
                    folha_y + pontos_y[face_i] * _escala_arte,
                    folha_x + pontos_x[face_proxima] * _escala_arte,
                    folha_y + pontos_y[face_proxima] * _escala_arte,
                    false
                );
            }

            draw_set_alpha(0.32 + perda * 0.48);
            draw_set_color(cor_contorno);
            draw_line_width(
                folha_x,
                folha_y - 60 * _escala_arte,
                folha_x,
                folha_y + 59 * _escala_arte,
                max(1, 4 * _escala_arte)
            );

            if (nivel <= 0.001) {
                draw_line_width(
                    folha_x,
                    folha_y - 5 * _escala_arte,
                    folha_x - 18 * _escala_arte,
                    folha_y + 14 * _escala_arte,
                    max(1, 4 * _escala_arte)
                );
                draw_line_width(
                    folha_x - 18 * _escala_arte,
                    folha_y + 14 * _escala_arte,
                    folha_x - 5 * _escala_arte,
                    folha_y + 29 * _escala_arte,
                    max(1, 4 * _escala_arte)
                );
            }
        }
    }

    draw_set_alpha(1);
    draw_set_color(c_white);
};

// A fonte do projeto é delicada. Repetir o texto em deslocamentos mínimos
// cria um peso semelhante ao semibold sem trocar a tipografia do jogo.
desenhar_texto_grosso = function(_x, _y, _texto, _sx, _sy, _cor) {
    draw_set_color(_cor);
    draw_text_transformed(_x - 0.85, _y, _texto, _sx, _sy, 0);
    draw_text_transformed(_x + 0.85, _y, _texto, _sx, _sy, 0);
    draw_text_transformed(_x, _y - 0.65, _texto, _sx, _sy, 0);
    draw_text_transformed(_x, _y + 0.65, _texto, _sx, _sy, 0);
    draw_text_transformed(_x, _y, _texto, _sx, _sy, 0);
};
