// ─────────────────────────────────────────────
//  LÓGICA DA CÂMERA COM MARGEM (DEADZONE)
// ─────────────────────────────────────────────

var _cam = view_camera[0];                 // câmera ativa
var _vw  = camera_get_view_width(_cam);    // 1280
var _vh  = camera_get_view_height(_cam);   // 811
var _player = follow_object;

// Se não houver jogador, sai
if (!instance_exists(_player)) exit;

// ─── LÓGICA HORIZONTAL (X) ───

// Se o jogador encostou na margem DIREITA
if (_player.x > x + _vw - margin_right) {
    target_x = _player.x - _vw + margin_right;
}
// Se o jogador encostou na margem ESQUERDA
if (_player.x < x + margin_left) {
    target_x = _player.x - margin_left;
}

// Trava a câmera dentro dos limites da sala (evita buracos pretos)
// A sala tem 1938 de largura, então a câmera pode ir de 0 até (1938 - 1280) = 658
target_x = clamp(target_x, 0, room_width - _vw);

// Aplica a suavização (lerp)
x = lerp(x, target_x, smooth_factor);

// ─── EIXO Y (fixo – a sala tem a mesma altura da view) ───
y = 0;   // se a sala for maior verticalmente, use (room_height - _vh) / 2

// ─── APLICA A POSIÇÃO NA CÂMERA ───
camera_set_view_pos(_cam, x, y);