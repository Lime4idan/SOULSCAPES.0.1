// Animal provisório: arraste a instância para definir o centro da rota.
// Depois, escolha qualquer arte em sprite_animal no painel de Variáveis.
if (!variable_instance_exists(id, "sprite_animal")) sprite_animal = spr_animal;
if (!variable_instance_exists(id, "largura_da_rota")) largura_da_rota = 520;
if (!variable_instance_exists(id, "velocidade_da_rota")) velocidade_da_rota = 0.75;
if (!variable_instance_exists(id, "escala_animal")) escala_animal = 0.58;

if (sprite_animal == -1 && sprite_exists(spr_animal)) sprite_animal = spr_animal;

animal_origem_x = x;
animal_origem_y = y;
animal_direcao = choose(-1, 1);
animal_tempo = random(100);
animal_pausa = irandom_range(0, 24);
