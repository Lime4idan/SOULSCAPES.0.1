// OBJETO-BASE DE CONSUMÍVEL CURATIVO
// Estas variáveis podem ser sobrescritas no Creation Code de cada instância.
// tipo_item: 0 Orvalho Lunar, 1 Fruto Rosado, 2 Seiva Estelar.
// Os seis sprites spr_itemcura_* permanecem disponíveis para novos consumíveis;
// cada item atual usa a ilustração que melhor comunica o que ele é.
if (!variable_instance_exists(id, "tipo_item")) tipo_item = 0;
id_coleta = "";
quantidade_item = 1;
coleta_unica = true;
nome_item = "";
descricao_item = "";
cura_item = -1;
raridade_item = "";
icone_item = "";
texto_interacao = "";
cor_tematica = -1;

// Arte futura: defina um sprite no próprio objeto ou sobrescreva esta variável.
if (!variable_instance_exists(id, "sprite_personalizado")) sprite_personalizado = -1;
// -1 distribui automaticamente as seis artes; instâncias criadas em runtime
// podem informar de 0 a 5 para controlar a variedade de cada sala.
if (!variable_instance_exists(id, "variante_sprite")) variante_sprite = -1;
if (!variable_instance_exists(id, "escala_sprite")) {
    escala_sprite = 1.25;
}
else if (escala_sprite == 1) {
    // O editor tende a restaurar o valor padrão para 1 ao salvar o objeto.
    escala_sprite = 1.25;
}
offset_sprite_x = 0;
offset_sprite_y = 0;

distancia_interacao = 82;
tempo_item = random(100);
perto_item = false;
coletado = false;
tempo_coleta = 0;
inicializado_item = false;
item_jogador = noone;

if (!variable_global_exists("dialogue_open")) {
    global.dialogue_open = false;
}

if (!variable_global_exists("jogo_pausado")) {
    global.jogo_pausado = false;
}

if (!variable_global_exists("interacao_bloqueada_ate")) {
    global.interacao_bloqueada_ate = 0;
}
