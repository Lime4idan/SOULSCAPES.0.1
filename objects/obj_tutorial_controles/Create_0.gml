display_set_gui_size(1280, 811);

// Visibilidade
alpha_controles = 1;

// O painel só começa a desaparecer
// depois que o jogador usar algum controle
controle_usado = false;
tempo_apos_controle = 0;


// ─────────────────────────────────────────────
// DESENHAR UMA TECLA
// ─────────────────────────────────────────────
desenhar_tecla = function(
    _x,
    _y,
    _texto,
    _largura
) {
    var altura = 30;

    var cor_fundo = make_color_rgb(229, 229, 242);
    var cor_borda = make_color_rgb(103, 108, 161);
    var cor_texto = make_color_rgb(57, 65, 103);

    // Sombra
    draw_set_alpha(0.12 * alpha_controles);
    draw_set_color(cor_borda);

    draw_roundrect(
        _x + 2,
        _y + 3,
        _x + _largura + 2,
        _y + altura + 3,
        false
    );

    // Fundo
    draw_set_alpha(0.92 * alpha_controles);
    draw_set_color(cor_fundo);

    draw_roundrect(
        _x,
        _y,
        _x + _largura,
        _y + altura,
        false
    );

    // Borda
    draw_set_alpha(0.75 * alpha_controles);
    draw_set_color(cor_borda);

    draw_roundrect(
        _x,
        _y,
        _x + _largura,
        _y + altura,
        true
    );

    // Texto
    draw_set_alpha(alpha_controles);
    draw_set_color(cor_texto);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_text(
        _x + _largura / 2,
        _y + altura / 2,
        _texto
    );
};