// As definições abaixo aparecem no painel de Variáveis do objeto/instância.
// Elas são criadas pelo GameMaker antes deste evento.
if (!variable_instance_exists(id, "inimigo_indice")) inimigo_indice = 0;
if (!variable_instance_exists(id, "sprite_mapa_personalizado")) sprite_mapa_personalizado = -1;
if (!variable_instance_exists(id, "sprite_retrato_personalizado")) sprite_retrato_personalizado = -1;
if (!variable_instance_exists(id, "sprite_batalha_personalizado")) sprite_batalha_personalizado = -1;
if (!variable_instance_exists(id, "sprite_ataque_personalizado")) sprite_ataque_personalizado = -1;
if (!variable_instance_exists(id, "escala_mapa_personalizada")) escala_mapa_personalizada = 1;
if (!variable_instance_exists(id, "escala_batalha_personalizada")) escala_batalha_personalizada = 1;
if (!variable_instance_exists(id, "offset_batalha_x")) offset_batalha_x = 0;
if (!variable_instance_exists(id, "offset_batalha_y")) offset_batalha_y = 0;

inimigo_indice = clamp(round(inimigo_indice), 0, 3);
distancia_interacao = 100;
perto_jogador = false;
tempo_visual = random(100);
