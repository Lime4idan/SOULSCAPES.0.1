// ─────────────────────────────────────────────
//  LÓGICA DA CÂMERA COM MARGEM (DEADZONE)
// ─────────────────────────────────────────────

// Se a room não tiver um viewport ativo, não tente acessar uma câmera inválida.
if (!view_enabled || !view_visible[0]) exit;

var _cam = view_get_camera(0);             // câmera ativa
if (_cam == -1) exit;                      // nenhuma câmera atribuída

var _vw  = camera_get_view_width(_cam);    // 1280
var _vh  = camera_get_view_height(_cam);   // 811
var _player = instance_find(follow_object, 0);

// Corrige imediatamente uma posição inicial fora da room.
// Sem isso, o lerp mostrava a área vazia enquanto a câmera voltava lentamente.
var _max_x = max(0, room_width - _vw);
x = clamp(x, 0, _max_x);
target_x = clamp(target_x, 0, _max_x);

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
// Calcula o limite usando o tamanho atual da room e da view.
target_x = clamp(target_x, 0, _max_x);

// Aplica a suavização (lerp)
x = lerp(x, target_x, smooth_factor);

// ─── EIXO Y (fixo – a sala tem a mesma altura da view) ───
y = 0;   // se a sala for maior verticalmente, use (room_height - _vh) / 2

// ─── APLICA A POSIÇÃO NA CÂMERA ───
camera_set_view_pos(_cam, x, y);
