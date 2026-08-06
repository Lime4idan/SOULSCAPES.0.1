// ─────────────────────────────────────────────
//  CONFIGURAÇÕES DA CÂMERA
// ─────────────────────────────────────────────

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