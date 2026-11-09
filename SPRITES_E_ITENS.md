# Guia rápido de arte e itens

O projeto continua funcional sem arte final. Quando os sprites abaixo forem
importados com estes nomes, o jogo passa a usá-los automaticamente.

## Vida de Kiran

- `spr_vida_cheia`
- `spr_vida_parcial`
- `spr_vida_vazia`
- `spr_vida_brilho`

O HUD reserva cinco folhas, cada uma representando 20 pontos de vida. Se esses
assets não existirem, folhas de vitral facetadas são desenhadas por código.

## Inimigos

O sprite anexado já está preparado como `spr_florakii_inimigo` e é usado pela
Lumi no mapa, na conversa e na batalha. Para trocar a arte depois, basta
substituir a imagem desse sprite no GameMaker mantendo o mesmo nome.

Os guardas continuam com encaixes separados para mapa, batalha e retrato.

Para cada guarda (`mira`, `nilo`, `orion`):

- `spr_<nome>_mapa`: corpo usado durante a exploração;
- `spr_<nome>_batalha`: corpo inteiro usado no duelo;
- `spr_<nome>_retrato`: retrato usado antes do confronto.
- `spr_<nome>_ataque`: animação mostrada durante o golpe.

Para Kiran, use `spr_kiran_batalha` e `spr_kiran_ataque`. Se o sprite de
ataque ainda não existir, o jogo mantém automaticamente o sprite normal.

Escalas e deslocamentos ficam em `objects/obj_pause/Create_0.gml`, nos arrays
`escalas_mapa_inimigos`, `escalas_batalha_inimigos`,
`offsets_batalha_inimigos_x` e `offsets_batalha_inimigos_y`.

### Trocar sprites sem editar código

Os encontros colocados nas rooms usam `obj_inimigo_mapa`. No Room Editor:

1. Abra a camada **Inimigos** e selecione a instância desejada. Você pode
   arrastá-la livremente para mudar o ponto do encontro.
2. No painel **Variables**, altere `sprite_mapa_personalizado`.
3. Escolha também `sprite_retrato_personalizado` e
   `sprite_batalha_personalizado`.
4. Em `sprite_ataque_personalizado`, escolha a animação do golpe.
5. Ajuste as escalas e os offsets se a arte não ficar centralizada.

Se você só tiver uma imagem, escolha apenas `sprite_mapa_personalizado`: ela
também será usada provisoriamente como retrato e sprite de batalha. Outra opção
é atribuir o sprite normal da própria instância; o desenho do mapa reconhece
esse campo automaticamente.

Após alterações externas feitas pelo Codex, feche e abra novamente o projeto
no GameMaker (ou escolha **Reload from disk** quando ele avisar). Caso contrário,
o editor pode continuar mostrando a versão antiga das variáveis.

`inimigo_indice` escolhe os dados do personagem: `0` Mira, `1` Nilo,
`2` Lumi e `3` Orion. Mover a instância na room também muda o ponto do
encontro, sem precisar alterar coordenadas no código.

## Estátuas

Cada `obj_fragmento_vitral` continua na room depois da coleta. Selecione a
instância e configure no painel **Variables**:

```gml
estatua_sprite_com_fragmento = spr_minha_estatua_cheia;
estatua_sprite_sem_fragmento = spr_minha_estatua_vazia;
estatua_escala_sprite = 1;
```

`indice_fragmento` escolhe o caco guardado (`0` a `3`). Você também pode
arrastar cada estátua para a posição desejada pelo Room Editor.

## Itens curativos

- `spr_item_orvalho_lunar`
- `spr_item_fruto_rosado`
- `spr_item_seiva_estelar`

Cada instância de `obj_item_cura` pode ser colocada manualmente em qualquer
room. No Creation Code, use `tipo_item = 0`, `1` ou `2`. Também é possível
sobrescrever nome, descrição, cura, raridade, sprite, escala, deslocamento,
quantidade, texto de interação e se a coleta é única.

```gml
tipo_item = 1;
id_coleta = "identificador_unico";
quantidade_item = 1;
coleta_unica = true;
sprite_personalizado = spr_meu_item;
escala_sprite = 1;
offset_sprite_x = 0;
offset_sprite_y = 0;
```

O `id_coleta` deve ser diferente em cada instância de coleta única. Os itens
entram na aba **Itens**, empilham pelo ID do tipo e podem ser usados no
inventário ou durante a batalha.

## Animal de ambientação

O `obj_animal_rota` já está colocado em Room1 com um desenho provisório. Para
trocar por sua arte, selecione a instância e escolha `sprite_animal`. Os campos
`largura_da_rota`, `velocidade_da_rota` e `escala_animal` controlam seu passeio
de ida e volta sem precisar editar código.
