// ─────────────────────────────────────────────
//  CONFIGURAÇÕES DA CÂMERA
// ─────────────────────────────────────────────

// Cada room possui sua própria instância de câmera.
// Evita carregar a câmera da room anterior e criar uma duplicata.
persistent = false;

// Garante que o Viewport 0 realmente seja desenhado.
// Apenas "Enable Viewports" não torna o viewport visível.
view_enabled = true;
view_visible[0] = true;

// Todas as rooms usam a mesma resolução de jogo.
// Evita esticar a imagem ao entrar em rooms configuradas como 1366x768.
view_wport[0] = 1280;
view_hport[0] = 811;

var _room_cam = view_get_camera(0);
if (_room_cam != -1) {
    camera_set_view_size(_room_cam, 1280, 811);
}

// Margens (distância do jogador até a borda da tela)
margin_left   = 600;    // margem esquerda (pixels)
margin_right  = 600;    // margem direita
margin_top    = 0;      // margem superior (não usado porque Y é fixo)
margin_bottom = 0;      // margem inferior

// Suavização (0 = sem movimento, 1 = instantâneo)
smooth_factor = 0.1;    // valor entre 0 e 1 – quanto maior, mais rápido

// Posição alvo da câmera (usada para o lerp)
target_x = x;           // começa na posição atual da câmera
target_y = y;

// Referência ao jogador
follow_object = obj_Kiran;   // ou instance_find(obj_Kiran, 0)
