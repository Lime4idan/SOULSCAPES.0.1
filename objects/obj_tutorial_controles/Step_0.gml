var apertou_controle =
    keyboard_check(ord("A"))
    || keyboard_check(ord("D"))
    || keyboard_check(vk_left)
    || keyboard_check(vk_right)
    || keyboard_check(vk_shift)
    || keyboard_check_pressed(ord("Z"))
    || keyboard_check_pressed(ord("X"))
    || keyboard_check_pressed(ord("E"))
    || keyboard_check_pressed(vk_space);

// Começar a contar depois que o jogador usar um controle
if (apertou_controle) {
    controle_usado = true;
}

// Esperar alguns segundos antes de desaparecer
if (controle_usado) {
    tempo_apos_controle++;

    if (tempo_apos_controle > room_speed * 4) {
        alpha_controles = lerp(
            alpha_controles,
            0,
            0.06
        );
    }
}

// Apagar o objeto quando ficar invisível
if (alpha_controles < 0.02) {
    instance_destroy();
}