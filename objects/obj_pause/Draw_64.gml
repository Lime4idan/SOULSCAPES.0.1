// Inimigos provisórios desenhados na GUI a partir da posição do mundo.
// Assim a mecânica já fica visível sem depender de um sprite definitivo.
if (
    !global.jogo_pausado
    && array_length(inimigos_sala_indices) > 0
    && (
        !object_exists(obj_inimigo_mapa)
        || instance_number(obj_inimigo_mapa) <= 0
    )
) {
    var mapa_camera = view_get_camera(0);
    var mapa_camera_x = mapa_camera == -1 ? 0 : camera_get_view_x(mapa_camera);
    var mapa_camera_y = mapa_camera == -1 ? 0 : camera_get_view_y(mapa_camera);
    var mapa_escala_x = mapa_camera == -1
        ? 1
        : display_get_gui_width() / camera_get_view_width(mapa_camera);
    var mapa_escala_y = mapa_camera == -1
        ? 1
        : display_get_gui_height() / camera_get_view_height(mapa_camera);

    for (var mapa_inimigo_i = 0; mapa_inimigo_i < array_length(inimigos_sala_indices); mapa_inimigo_i++) {
        var mapa_inimigo_indice = inimigos_sala_indices[mapa_inimigo_i];

        if (!global.inimigos_derrotados[mapa_inimigo_indice]) {
            var mapa_inimigo_x = (inimigos_sala_x[mapa_inimigo_i] - mapa_camera_x) * mapa_escala_x;
            var mapa_inimigo_y = (inimigos_sala_y[mapa_inimigo_i] - mapa_camera_y) * mapa_escala_y;
            var mapa_cor = cores_inimigos[mapa_inimigo_indice];
            var mapa_sprite = sprites_mapa_inimigos[mapa_inimigo_indice];

            if (mapa_sprite != -1 && sprite_exists(mapa_sprite)) {
                var mapa_sprite_w = max(1, sprite_get_width(mapa_sprite));
                var mapa_sprite_h = max(1, sprite_get_height(mapa_sprite));
                var mapa_sprite_escala = min(120 / mapa_sprite_w, 145 / mapa_sprite_h)
                    * escalas_mapa_inimigos[mapa_inimigo_indice];
                var mapa_sprite_x = mapa_inimigo_x
                    + (sprite_get_xoffset(mapa_sprite) - mapa_sprite_w * 0.5)
                    * mapa_sprite_escala;
                var mapa_sprite_y = mapa_inimigo_y + 65
                    + (sprite_get_yoffset(mapa_sprite) - mapa_sprite_h)
                    * mapa_sprite_escala;

                draw_set_alpha(0.16);
                draw_set_color(make_color_rgb(38, 45, 70));
                draw_ellipse(mapa_inimigo_x - 48, mapa_inimigo_y + 53,
                    mapa_inimigo_x + 48, mapa_inimigo_y + 70, false);
                draw_set_alpha(1);
                draw_sprite_ext(
                    mapa_sprite,
                    floor(tempo_inimigos) mod max(1, sprite_get_number(mapa_sprite)),
                    mapa_sprite_x,
                    mapa_sprite_y,
                    mapa_sprite_escala,
                    mapa_sprite_escala,
                    0,
                    c_white,
                    1
                );
            }
            else {

            // Silhueta chibi de NPC, pronta para ser trocada por um sprite.
            draw_set_alpha(0.16);
            draw_set_color(mapa_cor);
            draw_ellipse(mapa_inimigo_x - 45, mapa_inimigo_y + 55,
                mapa_inimigo_x + 45, mapa_inimigo_y + 70, false);

            draw_set_alpha(0.96);
            draw_set_color(make_color_rgb(247, 239, 244));
            draw_circle(mapa_inimigo_x, mapa_inimigo_y - 37, 24, false);
            draw_set_color(mapa_cor);
            draw_roundrect(mapa_inimigo_x - 25, mapa_inimigo_y - 10,
                mapa_inimigo_x + 25, mapa_inimigo_y + 45, false);
            draw_line_width(mapa_inimigo_x - 14, mapa_inimigo_y + 42,
                mapa_inimigo_x - 17, mapa_inimigo_y + 64, 8);
            draw_line_width(mapa_inimigo_x + 14, mapa_inimigo_y + 42,
                mapa_inimigo_x + 17, mapa_inimigo_y + 64, 8);

            draw_set_alpha(0.82);
            draw_set_color(make_color_rgb(72, 73, 111));
            draw_circle(mapa_inimigo_x, mapa_inimigo_y - 37, 24, true);
            draw_roundrect(mapa_inimigo_x - 25, mapa_inimigo_y - 10,
                mapa_inimigo_x + 25, mapa_inimigo_y + 45, true);
            draw_set_alpha(0.76);
            draw_set_color(mapa_cor);
            draw_circle(mapa_inimigo_x - 14, mapa_inimigo_y - 53, 13, false);
            draw_circle(mapa_inimigo_x + 3, mapa_inimigo_y - 59, 15, false);
            draw_circle(mapa_inimigo_x + 17, mapa_inimigo_y - 50, 11, false);

            draw_set_alpha(0.88);
            draw_set_color(make_color_rgb(72, 73, 111));
            draw_circle(mapa_inimigo_x - 8, mapa_inimigo_y - 37, 2, false);
            draw_circle(mapa_inimigo_x + 8, mapa_inimigo_y - 37, 2, false);

            draw_set_alpha(0.52);
            draw_set_color(make_color_rgb(126, 102, 157));
            draw_circle(mapa_inimigo_x - 37, mapa_inimigo_y - 2, 5, false);
            draw_circle(mapa_inimigo_x + 40, mapa_inimigo_y - 17, 4, false);
            draw_circle(mapa_inimigo_x + 32, mapa_inimigo_y + 28, 3, false);
            }

            if (inimigo_proximo == mapa_inimigo_indice) {
                draw_set_alpha(0.18);
                draw_set_color(make_color_rgb(53, 56, 87));
                draw_roundrect(mapa_inimigo_x - 85, mapa_inimigo_y - 143,
                    mapa_inimigo_x + 82, mapa_inimigo_y - 99, false);
                draw_set_alpha(0.95);
                draw_set_color(make_color_rgb(252, 249, 255));
                draw_roundrect(mapa_inimigo_x - 88, mapa_inimigo_y - 147,
                    mapa_inimigo_x + 79, mapa_inimigo_y - 103, false);
                draw_set_alpha(0.72);
                draw_set_color(make_color_rgb(121, 111, 164));
                draw_roundrect(mapa_inimigo_x - 88, mapa_inimigo_y - 147,
                    mapa_inimigo_x + 79, mapa_inimigo_y - 103, true);

                draw_set_alpha(1);
                draw_set_font(fnt_dialogo);
                draw_set_halign(fa_center);
                draw_set_valign(fa_middle);
                draw_set_color(make_color_rgb(57, 66, 107));
                draw_text_transformed(mapa_inimigo_x - 64, mapa_inimigo_y - 125, (variable_global_exists("mobile_mode") && global.mobile_mode) ? "!" : "E", 0.72, 0.72, 0);
                draw_text_transformed(mapa_inimigo_x + 2, mapa_inimigo_y - 125, "Conversar", 0.66, 0.66, 0);
            }
        }
    }

    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(-1);
}

// HUD ilustrado escolhido para Kiran. A arte permanece intacta e o valor
// numérico é redesenhado por cima para continuar refletindo a vida real.
if (!global.jogo_pausado && sprite_exists(spr_hud_vida)) {
    // Versão compacta dentro da área segura: não disputa espaço nem fica
    // escondida pelos ornamentos da moldura fixa.
    var hud_arte_escala = 0.185;
    var hud_arte_x = 64;
    var hud_arte_y = 68;
    draw_set_alpha(0.98);
    draw_sprite_ext(spr_hud_vida, 0, hud_arte_x, hud_arte_y,
        hud_arte_escala, hud_arte_escala, 0, c_white, 1);

    // Faz as cinco folhas refletirem o HP, inclusive durante a animação de
    // dano/cura. Antes somente o número mudava porque as folhas eram fixas.
    desenhar_estado_hud_ilustrado(
        hud_arte_x,
        hud_arte_y,
        hud_arte_escala,
        hud_vida_exibida,
        global.vida_kiran_max
    );

    // Cobre somente o número impresso na referência e mostra o HP atual.
    // As coordenadas são relativas à arte, então tamanho e posição podem ser
    // ajustados sem desalinhar o valor dinâmico.
    var hud_numero_cx = hud_arte_x + 1713 * hud_arte_escala;
    var hud_numero_cy = hud_arte_y + 313 * hud_arte_escala;
    var hud_numero_meia_largura = 230 * hud_arte_escala;
    var hud_numero_meia_altura = 82 * hud_arte_escala;
    draw_set_alpha(0.99);
    draw_set_color(make_color_rgb(247, 242, 233));
    draw_roundrect(
        hud_numero_cx - hud_numero_meia_largura,
        hud_numero_cy - hud_numero_meia_altura,
        hud_numero_cx + hud_numero_meia_largura,
        hud_numero_cy + hud_numero_meia_altura,
        false
    );
    draw_set_alpha(0.72);
    draw_set_color(make_color_rgb(104, 96, 133));
    draw_roundrect(
        hud_numero_cx - hud_numero_meia_largura,
        hud_numero_cy - hud_numero_meia_altura,
        hud_numero_cx + hud_numero_meia_largura,
        hud_numero_cy + hud_numero_meia_altura,
        true
    );
    draw_set_alpha(1);
    draw_set_font(fnt_dialogo);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    var hud_numero_cor = global.vida_kiran <= global.vida_kiran_max * 0.30
        ? make_color_rgb(219, 118, 164)
        : make_color_rgb(52, 65, 96);
    desenhar_texto_grosso(hud_numero_cx, hud_numero_cy,
        string(ceil(global.vida_kiran)) + " / " + string(global.vida_kiran_max),
        0.56, 0.56, hud_numero_cor);
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(-1);
}

// Confirmação curta no mapa após guardar a oferenda. Fica no canto oposto ao
// HUD de vida para não cobrir Kiran nem os avisos de interação.
if (
    !global.jogo_pausado
    && recompensa_toast_timer > 0
    && recompensa_sprite != -1
    && sprite_exists(recompensa_sprite)
) {
    var rec_toast_entrada = clamp(
        (recompensa_toast_total - recompensa_toast_timer) / 14,
        0,
        1
    );
    var rec_toast_saida = clamp(recompensa_toast_timer / 24, 0, 1);
    var rec_toast_alpha = min(rec_toast_entrada, rec_toast_saida);
    var rec_toast_x1 = 884;
    var rec_toast_y1 = 78;
    var rec_toast_x2 = 1226;
    var rec_toast_y2 = 170;

    draw_set_alpha(0.18 * rec_toast_alpha);
    draw_set_color(make_color_rgb(43, 51, 79));
    draw_roundrect(rec_toast_x1 + 5, rec_toast_y1 + 7,
        rec_toast_x2 + 5, rec_toast_y2 + 7, false);
    draw_set_alpha(0.97 * rec_toast_alpha);
    draw_set_color(make_color_rgb(251, 247, 240));
    draw_roundrect(rec_toast_x1, rec_toast_y1,
        rec_toast_x2, rec_toast_y2, false);
    draw_set_alpha(0.76 * rec_toast_alpha);
    draw_set_color(make_color_rgb(137, 120, 177));
    draw_roundrect(rec_toast_x1, rec_toast_y1,
        rec_toast_x2, rec_toast_y2, true);

    draw_set_alpha(0.22 * rec_toast_alpha);
    draw_set_color(make_color_rgb(197, 238, 220));
    draw_circle(931, 124, 35, false);

    var rec_toast_bbox_l = sprite_get_bbox_left(recompensa_sprite);
    var rec_toast_bbox_r = sprite_get_bbox_right(recompensa_sprite);
    var rec_toast_bbox_t = sprite_get_bbox_top(recompensa_sprite);
    var rec_toast_bbox_b = sprite_get_bbox_bottom(recompensa_sprite);
    var rec_toast_bbox_w = max(1, rec_toast_bbox_r - rec_toast_bbox_l + 1);
    var rec_toast_bbox_h = max(1, rec_toast_bbox_b - rec_toast_bbox_t + 1);
    var rec_toast_escala = min(58 / rec_toast_bbox_w, 58 / rec_toast_bbox_h);
    var rec_toast_sprite_x = 931
        + (sprite_get_xoffset(recompensa_sprite)
            - (rec_toast_bbox_l + rec_toast_bbox_r) * 0.5)
        * rec_toast_escala;
    var rec_toast_sprite_y = 124
        + (sprite_get_yoffset(recompensa_sprite)
            - (rec_toast_bbox_t + rec_toast_bbox_b) * 0.5)
        * rec_toast_escala;
    draw_set_alpha(rec_toast_alpha);
    draw_sprite_ext(recompensa_sprite, 0,
        rec_toast_sprite_x, rec_toast_sprite_y,
        rec_toast_escala, rec_toast_escala, 0, c_white, 1);

    draw_set_font(fnt_dialogo);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    desenhar_texto_grosso(978, 105, "Oferenda recebida!",
        0.64, 0.64, make_color_rgb(52, 65, 96));
    draw_set_alpha(0.80 * rec_toast_alpha);
    draw_set_color(make_color_rgb(84, 85, 120));
    draw_text_ext_transformed(978, 129, recompensa_nome,
        18, 222, 0.52, 0.52, 0);

    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(-1);
}

// Versão anterior mantida desligada para facilitar ajustes futuros.
if (!global.jogo_pausado && false) {
    // Área segura da moldura: afasta o HUD do ornamento superior direito.
    var hudv_matrix_anterior = matrix_get(matrix_world);
    matrix_set(
        matrix_world,
        matrix_build(-58, 100, 0, 0, 0, 0, 1, 1, 1)
    );

    var hudv_max = max(1, global.vida_kiran_max);
    var hudv_vida = clamp(hud_vida_exibida, 0, hudv_max);
    var hudv_baixa = global.vida_kiran <= hudv_max * 0.30;
    var hudv_texto = global.config_contraste >= 1
        ? make_color_rgb(20, 22, 34)
        : make_color_rgb(52, 59, 94);
    var hudv_borda = global.config_contraste >= 1
        ? make_color_rgb(42, 35, 78)
        : make_color_rgb(92, 94, 139);
    var hudv_papel = global.config_contraste >= 1
        ? c_white
        : make_color_rgb(255, 250, 241);
    var hudv_rosa = make_color_rgb(224, 137, 174);
    var hudv_menta = make_color_rgb(151, 214, 181);
    var hudv_pulso = hud_vida_feedback_timer > 0
        ? hud_vida_feedback_timer / hud_vida_feedback_total
        : 0;
    var hudv_indice_afetado = hud_vida_feedback < 0
        ? clamp(floor(global.vida_kiran / 20), 0, 4)
        : clamp(ceil(global.vida_kiran / 20) - 1, 0, 4);

    draw_set_font(fnt_dialogo);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);

    // Sombra curta e duas camadas de papel/vitral mantêm legibilidade sem peso.
    draw_set_alpha(0.16);
    draw_set_color(make_color_rgb(25, 32, 55));
    draw_roundrect(929, 24, 1261, 126, false);
    draw_set_alpha(0.97);
    draw_set_color(hudv_papel);
    draw_roundrect(924, 19, 1256, 121, false);
    draw_set_alpha(hudv_baixa ? 0.56 : 0.34);
    draw_set_color(hudv_baixa ? hudv_rosa : hudv_borda);
    draw_roundrect(924, 19, 1256, 121, true);

    draw_set_alpha(0.92);
    draw_set_color(hudv_baixa ? hudv_rosa : hudv_menta);
    draw_roundrect(944, 31, 1033, 55, false);
    draw_set_alpha(1);
    draw_set_color(hudv_texto);
    draw_set_halign(fa_center);
    draw_text_transformed(988, 43, "KIRAN", 0.54, 0.54, 0);

    draw_set_halign(fa_right);
    draw_text_transformed(
        1238,
        43,
        string(ceil(global.vida_kiran)) + " / " + string(hudv_max),
        0.64,
        0.64,
        0
    );

    // Galho contínuo: as folhas parecem parte de um único artefato do HUD.
    draw_set_alpha(0.62);
    draw_set_color(hudv_borda);
    draw_line_width(956, 86, 1229, 86, 2);
    draw_line_width(956, 86, 946, 77, 2);

    for (var hudv_i = 0; hudv_i < 5; hudv_i++) {
        var hudv_nivel = clamp((hudv_vida - hudv_i * 20) / 20, 0, 1);
        var hudv_x = 978 + hudv_i * 56;
        var hudv_y = 86 + (hudv_i mod 2) * 3;
        var hudv_feedback_folha = hudv_i == hudv_indice_afetado
            ? hud_vida_feedback * hudv_pulso
            : 0;

        draw_line_width(hudv_x - 18, 86, hudv_x - 7, hudv_y + 7, 1);
        desenhar_folha_vitral(
            hudv_x,
            hudv_y,
            hudv_nivel,
            0.82,
            hudv_feedback_folha
        );
    }

    if (hudv_baixa) {
        draw_set_alpha(global.config_baixo_estimulo ? 0.55 : 0.76);
        draw_set_color(hudv_rosa);
        draw_set_halign(fa_right);
        draw_text_transformed(1238, 108, "vida baixa", 0.48, 0.48, 0);
    }

    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(-1);
    matrix_set(matrix_world, hudv_matrix_anterior);
}

// Versão geométrica anterior preservada apenas como referência visual.
if (!global.jogo_pausado && false) {
    var hud_vida_max = max(1, global.vida_kiran_max);
    var hud_vida = clamp(global.vida_kiran, 0, hud_vida_max);
    var hud_cor_texto = global.config_contraste >= 1
        ? make_color_rgb(20, 22, 34)
        : make_color_rgb(57, 66, 107);

    draw_set_font(fnt_dialogo);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);

    draw_set_alpha(0.16);
    draw_set_color(make_color_rgb(32, 41, 68));
    draw_roundrect(953, 27, 1263, 99, false);
    draw_set_alpha(0.94);
    draw_set_color(global.config_contraste >= 1
        ? c_white
        : make_color_rgb(255, 249, 239));
    draw_roundrect(948, 22, 1258, 94, false);
    draw_set_alpha(0.76);
    draw_set_color(make_color_rgb(121, 111, 164));
    draw_roundrect(948, 22, 1258, 94, true);

    draw_set_alpha(1);
    draw_set_color(hud_cor_texto);
    draw_set_halign(fa_center);
    draw_text_transformed(1103, 38, "Vida de Kiran  •  cada folha vale 20", 0.54, 0.54, 0);

    // Cinco folhas grandes. A folha atual murcha aos poucos; as vazias ficam pálidas.
    for (var hud_folha_i = 0; hud_folha_i < 5; hud_folha_i++) {
        var hud_folha_nivel = clamp((hud_vida - hud_folha_i * 20) / 20, 0, 1);
        var hud_folha_x = 1009 + hud_folha_i * 48;
        var hud_folha_y = 67 + (1 - hud_folha_nivel) * 4;
        var hud_folha_largura = 13 * (0.72 + hud_folha_nivel * 0.28);
        var hud_folha_altura = 9 * (0.72 + hud_folha_nivel * 0.28);

        draw_set_alpha(0.62);
        draw_set_color(make_color_rgb(226, 221, 232));
        draw_ellipse(hud_folha_x - 14, hud_folha_y - 10,
            hud_folha_x + 14, hud_folha_y + 10, false);
        draw_set_alpha(0.80);
        draw_set_color(make_color_rgb(121, 111, 164));
        draw_ellipse(hud_folha_x - 14, hud_folha_y - 10,
            hud_folha_x + 14, hud_folha_y + 10, true);

        if (hud_folha_nivel > 0) {
            draw_set_alpha(0.96);
            draw_set_color(merge_color(
                make_color_rgb(239, 205, 226),
                make_color_rgb(153, 211, 178),
                hud_folha_nivel
            ));
            draw_ellipse(hud_folha_x - hud_folha_largura,
                hud_folha_y - hud_folha_altura,
                hud_folha_x + hud_folha_largura,
                hud_folha_y + hud_folha_altura,
                false);
        }

        draw_set_alpha(0.72);
        draw_set_color(make_color_rgb(78, 105, 125));
        draw_line(hud_folha_x - 10, hud_folha_y + 6,
            hud_folha_x + 11, hud_folha_y - 6);
        draw_line(hud_folha_x + 11, hud_folha_y - 6,
            hud_folha_x + 16, hud_folha_y - 10 + (1 - hud_folha_nivel) * 5);
    }

    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(-1);
}

if (!global.jogo_pausado) {
    // Convite da Rainha. Desenhado pelo obj_pause porque o arquivo do objeto
    // da Rainha foi salvo pelo editor sem Draw GUI registrado.
    if (
        room == Room6
        && !global.dialogue_open
        && !global.encontro_rainha_iniciado
        && !global.capitulo_concluido
        && instance_exists(obj_Kiran)
        && instance_exists(Obj_rainha)
    ) {
        var rainha_prompt = instance_find(Obj_rainha, 0);
        var kiran_prompt = instance_nearest(rainha_prompt.x, rainha_prompt.y, obj_Kiran);

        if (point_distance(rainha_prompt.x, rainha_prompt.y, kiran_prompt.x, kiran_prompt.y) <= 400) {
            var prompt_camera = view_get_camera(0);
            var prompt_gui_x = prompt_camera == -1
                ? rainha_prompt.x
                : (rainha_prompt.x - camera_get_view_x(prompt_camera))
                    * display_get_gui_width() / camera_get_view_width(prompt_camera);
            var prompt_gui_y = prompt_camera == -1
                ? rainha_prompt.bbox_top
                : (rainha_prompt.bbox_top - camera_get_view_y(prompt_camera))
                    * display_get_gui_height() / camera_get_view_height(prompt_camera);

            prompt_gui_x = clamp(prompt_gui_x, 116, display_get_gui_width() - 116);
            prompt_gui_y = clamp(prompt_gui_y - 34, 72, display_get_gui_height() - 72);

            var prompt_x1 = prompt_gui_x - 106;
            var prompt_y1 = prompt_gui_y - 23;
            var prompt_x2 = prompt_gui_x + 106;
            var prompt_y2 = prompt_gui_y + 23;

            draw_set_alpha(0.20);
            draw_set_color(make_color_rgb(35, 34, 65));
            draw_roundrect(prompt_x1 + 3, prompt_y1 + 4, prompt_x2 + 3, prompt_y2 + 4, false);
            draw_set_alpha(0.96);
            draw_set_color(make_color_rgb(249, 244, 251));
            draw_roundrect(prompt_x1, prompt_y1, prompt_x2, prompt_y2, false);
            draw_set_alpha(0.80);
            draw_set_color(make_color_rgb(139, 122, 185));
            draw_roundrect(prompt_x1, prompt_y1, prompt_x2, prompt_y2, true);

            draw_set_alpha(0.98);
            draw_set_color(make_color_rgb(225, 216, 245));
            draw_roundrect(prompt_x1 + 9, prompt_y1 + 7, prompt_x1 + 49, prompt_y2 - 7, false);
            draw_set_color(make_color_rgb(121, 105, 171));
            draw_roundrect(prompt_x1 + 9, prompt_y1 + 7, prompt_x1 + 49, prompt_y2 - 7, true);

            draw_set_alpha(1);
            draw_set_font(fnt_dialogo);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_color(make_color_rgb(76, 69, 119));
            draw_text(prompt_x1 + 29, prompt_gui_y, (variable_global_exists("mobile_mode") && global.mobile_mode) ? "!" : "E");
            draw_set_color(make_color_rgb(64, 67, 101));
            draw_text((prompt_x1 + 54 + prompt_x2) * 0.5, prompt_gui_y, "Interagir");
            draw_set_alpha(1);
            draw_set_color(c_white);
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
            draw_set_font(-1);
        }
    }

    // Convite da escadaria final, no mesmo estilo dos demais "E · Interagir".
    if (
        room == Room1
        && global.comandante_partiu
        && !global.encontro_rainha_iniciado
        && instance_exists(obj_Kiran)
    ) {
        var escada_gui_pronta = true;
        for (var escada_gui_i = 0; escada_gui_i < 4; escada_gui_i++) {
            if (!global.fragmentos_vitral[escada_gui_i]) escada_gui_pronta = false;
        }

        var escada_gui_kiran = instance_nearest(5850, 485, obj_Kiran);
        if (escada_gui_pronta && point_distance(escada_gui_kiran.x, escada_gui_kiran.y, 5850, 485) <= 145) {
            draw_set_font(fnt_dialogo);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_alpha(0.22);
            draw_set_color(make_color_rgb(29, 35, 64));
            draw_roundrect(497, 689, 787, 749, false);
            draw_set_alpha(0.97);
            draw_set_color(make_color_rgb(249, 245, 237));
            draw_roundrect(491, 683, 781, 743, false);
            draw_set_alpha(0.82);
            draw_set_color(make_color_rgb(135, 119, 181));
            draw_roundrect(491, 683, 781, 743, true);
            draw_set_alpha(1);
            draw_set_color(make_color_rgb(221, 211, 244));
            draw_roundrect(503, 695, 547, 731, false);
            draw_set_color(make_color_rgb(69, 66, 108));
            draw_text(525, 713, (variable_global_exists("mobile_mode") && global.mobile_mode) ? "!" : "E");
            draw_text(662, 713, "Subir a escada");
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
            draw_set_font(-1);
            draw_set_alpha(1);
            draw_set_color(c_white);
        }
    }

    exit;
}

draw_set_font(fnt_dialogo);

var mouse_gui_x = device_mouse_x_to_gui(0);
var mouse_gui_y = device_mouse_y_to_gui(0);

var alto_contraste = global.config_contraste >= 1;


// ═════════════════════════════════════════════
// PALETA
// ═════════════════════════════════════════════
var cor_overlay =
    make_color_rgb(35, 49, 72);

var cor_painel =
    alto_contraste
    ? c_white
    : make_color_rgb(229, 231, 242);

var cor_interno =
    alto_contraste
    ? make_color_rgb(250, 250, 252)
    : make_color_rgb(241, 241, 247);

var cor_borda =
    alto_contraste
    ? make_color_rgb(42, 35, 78)
    : make_color_rgb(102, 108, 158);

var cor_texto =
    alto_contraste
    ? make_color_rgb(18, 20, 31)
    : make_color_rgb(55, 63, 96);

var cor_normal =
    make_color_rgb(234, 235, 244);

var cor_hover =
    make_color_rgb(211, 214, 235);

var cor_sensorial =
    make_color_rgb(215, 217, 239);

var cor_sensorial_hover =
    make_color_rgb(188, 194, 227);

var cor_slider =
    make_color_rgb(145, 153, 207);

var cor_desativado =
    make_color_rgb(204, 207, 225);


// ═════════════════════════════════════════════
// FUNDO ESCURECIDO
// ═════════════════════════════════════════════
draw_set_alpha(
    tela_pause == 2
    ? 0.48
    : (global.config_baixo_estimulo ? 0.66 : 0.50)
);

draw_set_color(cor_overlay);

draw_rectangle(
    0,
    0,
    1280,
    811,
    false
);


// ═════════════════════════════════════════════
// PAINEL
// ═════════════════════════════════════════════
if (tela_pause == 4) {

    // Mesma capa de álbum refinada usada nas configurações.
    draw_set_alpha(0.14);
    draw_set_color(make_color_rgb(32, 41, 68));
    draw_roundrect(107, 78, 1177, 758, false);

    draw_set_alpha(0.98);
    draw_set_color(make_color_rgb(220, 212, 244));
    draw_roundrect(100, 70, 1170, 750, false);

    draw_set_alpha(1);
    draw_set_color(alto_contraste ? c_white : make_color_rgb(255, 249, 239));
    draw_roundrect(118, 88, 1152, 732, false);

    draw_set_alpha(0.70);
    draw_set_color(alto_contraste ? make_color_rgb(48, 38, 86) : make_color_rgb(121, 111, 164));
    draw_roundrect(100, 70, 1170, 750, true);
}
else if (tela_pause == 5) {
    // O combate usa uma composição própria de tela inteira logo abaixo.
    draw_set_alpha(0.10);
    draw_set_color(make_color_rgb(15, 25, 44));
    draw_rectangle(0, 0, 1280, 811, false);
}
else if (tela_pause == 6) {
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(16, 25, 45));
    draw_rectangle(0, 0, 1280, 811, false);
}
else {

    // Sombra
    draw_set_alpha(0.11);
    draw_set_color(cor_overlay);

    draw_roundrect(
        357,
        78,
        929,
        729,
        false
    );

    // Painel
    draw_set_alpha(0.86);
    draw_set_color(cor_painel);

    draw_roundrect(
        350,
        70,
        922,
        720,
        false
    );

    // Mancha interna
    draw_set_alpha(0.28);
    draw_set_color(cor_interno);

    draw_roundrect(
        365,
        85,
        907,
        705,
        false
    );

    // Borda
    draw_set_alpha(0.40);
    draw_set_color(cor_borda);

    draw_roundrect(
        350,
        70,
        922,
        720,
        true
    );
}

if (tela_pause == 6) {
    var fim_aparecer = clamp(fim_capitulo_timer / 50, 0, 1);
    var fim_papel = make_color_rgb(247, 242, 232);
    var fim_azul = make_color_rgb(176, 204, 218);
    var fim_lilas = make_color_rgb(201, 190, 228);

    draw_set_alpha(fim_aparecer);
    draw_set_color(make_color_rgb(9, 17, 34));
    draw_rectangle(0, 0, 1280, 811, false);
    draw_set_alpha(fim_aparecer * 0.18);
    draw_set_color(fim_azul);
    draw_circle(640, 382, 250, false);
    draw_set_alpha(fim_aparecer * 0.72);
    draw_set_color(fim_papel);
    draw_line(354, 330, 548, 330);
    draw_line(732, 330, 926, 330);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_font(fnt_dialogo);
    draw_text_transformed(640, 330, "FIM DO CAPÍTULO", 1.82, 1.82, 0);
    draw_set_alpha(fim_aparecer * 0.90);
    draw_set_color(fim_lilas);
    draw_text_transformed(640, 391, "O QUINTO FRAGMENTO", 0.88, 0.88, 0);
    draw_set_alpha(fim_aparecer * 0.82);
    draw_set_color(fim_papel);
    draw_text_transformed(640, 465,
        "As quatro oferendas retornaram. A porta da memória foi aberta.",
        0.76, 0.76, 0);

    // A arte final criada para o capítulo ocupa a tela inteira. O desenho
    // anterior permanece como fallback caso o sprite ainda esteja ausente.
    if (sprite_exists(spr_fim)) {
        draw_set_alpha(fim_aparecer);
        draw_set_color(c_white);
        var fim_sprite_w = max(1, sprite_get_width(spr_fim));
        var fim_sprite_h = max(1, sprite_get_height(spr_fim));
        var fim_sprite_escala = max(1280 / fim_sprite_w, 811 / fim_sprite_h);
        draw_sprite_ext(
            spr_fim,
            0,
            (1280 - fim_sprite_w * fim_sprite_escala) * 0.5,
            (811 - fim_sprite_h * fim_sprite_escala) * 0.5,
            fim_sprite_escala,
            fim_sprite_escala,
            0,
            c_white,
            1
        );
    }

    if (fim_capitulo_timer >= 45) {
        draw_set_alpha(0.48 + sin(fim_capitulo_timer * 0.08) * 0.16);
        draw_text_transformed(640, 674, "Espaço · voltar ao menu", 0.64, 0.64, 0);
    }

    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(-1);
}


// ═════════════════════════════════════════════
// MENU PRINCIPAL
// ═════════════════════════════════════════════
if (tela_pause == 0) {
    draw_set_alpha(1);
    draw_set_color(cor_texto);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    // Título
    draw_text_transformed(
        636,
        125,
        "Paused",
        1.52,
        1.52,
        0
    );

    // Linha decorativa
    draw_set_alpha(0.20);
    draw_set_color(cor_borda);

    draw_line(
        490,
        165,
        782,
        165
    );

    desenhar_folha_pause(
        474,
        165,
        0.36
    );

    desenhar_folha_pause(
        798,
        165,
        0.36
    );


    // Botões
    for (
        var menu_i = 0;
        menu_i < array_length(opcoes_pause);
        menu_i++
    ) {
        var menu_hover =
            hover_pause[menu_i];

        var menu_x1 =
            botao_pause_x1[menu_i];

        var menu_x2 =
            botao_pause_x2[menu_i];

        var menu_y1 =
            botao_pause_y[menu_i];

        var menu_y2 =
            menu_y1
            + botao_pause_h[menu_i];

        var menu_centro_x =
            (menu_x1 + menu_x2) / 2;

        var menu_centro_y =
            (menu_y1 + menu_y2) / 2;

        var menu_sensorial =
            menu_i == 0;

        var menu_expansao =
            menu_hover * 3;

        menu_x1 -= menu_expansao;
        menu_x2 += menu_expansao;

        menu_y1 -= menu_expansao * 0.35;
        menu_y2 += menu_expansao * 0.35;


        // Sombra
        draw_set_alpha(
            menu_sensorial
            ? 0.075
            : 0.045
        );

        draw_set_color(cor_overlay);

        draw_roundrect(
            menu_x1 + 2,
            menu_y1 + 3,
            menu_x2 + 2,
            menu_y2 + 3,
            false
        );


        // Fundo
        draw_set_alpha(
            menu_sensorial
            ? 0.82
            : 0.58
        );

        if (menu_sensorial) {
            draw_set_color(
                merge_color(
                    cor_sensorial,
                    cor_sensorial_hover,
                    menu_hover
                )
            );
        }
        else {
            draw_set_color(
                merge_color(
                    cor_normal,
                    cor_hover,
                    menu_hover
                )
            );
        }

        draw_roundrect(
            menu_x1,
            menu_y1,
            menu_x2,
            menu_y2,
            false
        );


        // Mancha interna sensorial
        if (menu_sensorial) {
            draw_set_alpha(
                0.035
                + menu_hover * 0.055
            );

            draw_set_color(cor_slider);

            draw_roundrect(
                menu_x1 + 7,
                menu_y1 + 6,
                menu_x2 - 7,
                menu_y2 - 7,
                false
            );
        }


        // Borda
        draw_set_alpha(
            menu_sensorial
            ? 0.55 + menu_hover * 0.30
            : 0.27 + menu_hover * 0.43
        );

        draw_set_color(cor_borda);

        draw_roundrect(
            menu_x1,
            menu_y1,
            menu_x2,
            menu_y2,
            true
        );


        // Texto
        draw_set_alpha(0.94);
        draw_set_color(cor_texto);

        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);

        draw_text_transformed(
            menu_centro_x,
            menu_centro_y,
            opcoes_pause[menu_i],
            menu_sensorial ? 1.15 : 1.02,
            menu_sensorial ? 1.15 : 1.02,
            0
        );


        // Folhinha selecionadora
        if (menu_i == opcao_pause) {
            var menu_movimento = 0;

            if (
                !global
                .config_reduzir_animacoes
            ) {
                menu_movimento =
                    sin(tempo_pause) * 2;
            }

            desenhar_folha_pause(
                menu_x1 - 25
                + menu_movimento,
                menu_centro_y,
                0.90
            );
        }
    }


    // Instrução inferior
    draw_set_alpha(0.45);
    draw_set_color(cor_texto);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_text(
        636,
        650,
        "Esc  return to game"
    );
}


// ═════════════════════════════════════════════
// CONTROLES
// ═════════════════════════════════════════════
if (tela_pause == 1) {
    draw_set_alpha(1);
    draw_set_color(cor_texto);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_text_transformed(
        636,
        130,
        "Controls",
        1.52,
        1.52,
        0
    );

    draw_set_alpha(0.20);
    draw_set_color(cor_borda);

    draw_line(
        490,
        170,
        782,
        170
    );


    // Teclas
    desenhar_tecla_pause(
        415,
        200,
        "A",
        38
    );

    desenhar_tecla_pause(
        463,
        200,
        "D",
        38
    );

    desenhar_tecla_pause(
        415,
        252,
        "Shift",
        86
    );

    desenhar_tecla_pause(
        415,
        304,
        "Espaço",
        104
    );

    desenhar_tecla_pause(
        415,
        356,
        "E",
        38
    );

    desenhar_tecla_pause(
        415,
        408,
        "Tab",
        68
    );

    desenhar_tecla_pause(
        415,
        460,
        "Space",
        104
    );

    desenhar_tecla_pause(
        415,
        512,
        "Esc",
        68
    );


    // Ações
    draw_set_alpha(0.92);
    draw_set_color(cor_texto);

    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);

    draw_text(570, 217, "Mover");
    draw_text(570, 269, "Correr");
    draw_text(570, 313, "Pular");
    draw_text(570, 373, "Interagir");
    draw_text(570, 425, "Abrir / fechar inventário");
    draw_text(570, 469, "Avançar / confirmar");
    draw_text(570, 529, "Pausar ou voltar");

    // Alternativas continuam disponíveis, mas sem competir com a tecla principal.
    draw_set_alpha(0.58);
    draw_set_color(cor_borda);
    draw_text_transformed(570, 337, "Z / X também", 0.70, 0.70, 0);
    draw_text_transformed(570, 491, "Return também", 0.70, 0.70, 0);

    draw_set_alpha(0.68);
    draw_set_color(cor_borda);
    draw_set_halign(fa_center);
    draw_text_transformed(
        636,
        568,
        "No menu de pausa: escolha Pausa sensorial",
        0.76,
        0.76,
        0
    );


    // Botão voltar
    var controles_draw_x1 = 515;
    var controles_draw_y1 = 590;
    var controles_draw_x2 = 765;
    var controles_draw_y2 = 646;

    var controles_draw_mouse =
        point_in_rectangle(
            mouse_gui_x,
            mouse_gui_y,
            controles_draw_x1,
            controles_draw_y1,
            controles_draw_x2,
            controles_draw_y2
        );

    draw_set_alpha(0.74);

    draw_set_color(
        controles_draw_mouse
        ? cor_hover
        : cor_normal
    );

    draw_roundrect(
        controles_draw_x1,
        controles_draw_y1,
        controles_draw_x2,
        controles_draw_y2,
        false
    );

    draw_set_alpha(
        controles_draw_mouse
        ? 0.82
        : 0.38
    );

    draw_set_color(cor_borda);

    draw_roundrect(
        controles_draw_x1,
        controles_draw_y1,
        controles_draw_x2,
        controles_draw_y2,
        true
    );

    draw_set_alpha(1);
    draw_set_color(cor_texto);

    draw_set_halign(fa_center);

    draw_text(
        640,
        (
            controles_draw_y1
            + controles_draw_y2
        ) / 2,
        "Back"
    );
}


// ═════════════════════════════════════════════
// INVENTÁRIO
// ═════════════════════════════════════════════
// Layout antigo preservado temporariamente apenas como referência visual.
/*
if (tela_pause == 4 && false) {
    var inv_cor_rosa = make_color_rgb(239, 205, 226);
    var inv_cor_lilas = make_color_rgb(220, 212, 244);
    var inv_cor_menta = make_color_rgb(198, 237, 220);
    var inv_cor_azul = make_color_rgb(205, 228, 245);
    var inv_cor_vazio = make_color_rgb(220, 222, 233);
    var inv_cor_texto_suave = make_color_rgb(111, 112, 143);
    var inv_cor_papel = make_color_rgb(255, 249, 239);
    var inv_cor_papel_sombra = make_color_rgb(238, 222, 211);
    var inv_cor_tinta = make_color_rgb(83, 73, 101);

    draw_set_alpha(1);
    draw_set_color(cor_texto);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_text_transformed(
        636,
        105,
        "Caderno de memórias",
        1.50,
        1.50,
        0
    );

    draw_set_alpha(0.18);
    draw_set_color(cor_borda);
    draw_line(470, 145, 802, 145);
    desenhar_folha_pause(454, 145, 0.32);
    desenhar_folha_pause(818, 145, 0.32);


    // ─────────────────────────────────────────
    // CADERNO ABERTO
    // ─────────────────────────────────────────
    draw_set_alpha(0.17);
    draw_set_color(cor_overlay);
    draw_roundrect(105, 174, 1175, 578, false);

    // Capa aparecendo por trás das páginas.
    draw_set_alpha(0.94);
    draw_set_color(inv_cor_lilas);
    draw_roundrect(98, 164, 1170, 570, false);

    draw_set_alpha(0.72);
    draw_set_color(cor_borda);
    draw_roundrect(98, 164, 1170, 570, true);

    // Duas páginas creme, unidas pela lombada.
    draw_set_alpha(1);
    draw_set_color(inv_cor_papel);
    draw_roundrect(112, 176, 636, 556, false);
    draw_roundrect(634, 176, 1156, 556, false);

    draw_set_alpha(0.32);
    draw_set_color(inv_cor_papel_sombra);
    draw_roundrect(620, 178, 650, 554, false);

    draw_set_alpha(0.36);
    draw_set_color(cor_borda);
    draw_line_width(635, 184, 635, 548, 2);

    // Linhas leves de papel e pequenos adesivos florais.
    draw_set_alpha(0.16);
    draw_set_color(inv_cor_rosa);
    draw_line(150, 470, 590, 470);
    draw_line(680, 470, 1115, 470);
    draw_set_alpha(0.72);
    draw_set_color(inv_cor_rosa);
    draw_circle(137, 201, 7, false);
    draw_set_color(inv_cor_menta);
    draw_circle(149, 195, 5, false);
    draw_set_color(inv_cor_azul);
    draw_circle(1128, 202, 6, false);
    draw_set_color(inv_cor_lilas);
    draw_circle(1140, 194, 4, false);


    // ─────────────────────────────────────────
    // PÁGINA DO FRAGMENTO PRINCIPAL
    // ─────────────────────────────────────────

    draw_set_alpha(1);
    draw_set_color(inv_cor_tinta);
    draw_text_transformed(
        360,
        215,
        global.tem_fragmento
        ? "Fragmento luminoso"
        : "Espaço vazio",
        1.10,
        1.10,
        0
    );

    // Aura do espaço de item.
    draw_set_alpha(global.tem_fragmento ? 0.13 : 0.07);
    draw_set_color(global.tem_fragmento ? inv_cor_menta : inv_cor_vazio);
    draw_circle(360, 328, 70, false);

    draw_set_alpha(global.tem_fragmento ? 0.22 : 0.12);
    draw_circle(360, 328, 50, false);

    if (global.tem_fragmento) {
        draw_set_alpha(0.96);
        draw_set_color(inv_cor_azul);
        draw_triangle(360, 276, 318, 328, 360, 382, false);
        draw_set_color(inv_cor_lilas);
        draw_triangle(360, 276, 402, 328, 360, 382, false);

        draw_set_alpha(0.82);
        draw_set_color(cor_borda);
        draw_line_width(360, 276, 318, 328, 2);
        draw_line_width(318, 328, 360, 382, 2);
        draw_line_width(360, 382, 402, 328, 2);
        draw_line_width(402, 328, 360, 276, 2);

        draw_set_alpha(0.58);
        draw_set_color(c_white);
        draw_line_width(351, 294, 334, 326, 3);

        draw_set_alpha(0.88);
        draw_set_color(inv_cor_menta);
        draw_roundrect(257, 403, 463, 441, false);

        draw_set_alpha(1);
        draw_set_color(cor_texto);
        draw_text(360, 422, "guardado com carinho");

        draw_set_alpha(0.68);
        draw_set_color(cor_texto);
        draw_text_transformed(
            360,
            503,
            global.fragmento_reconhecido
            ? "Lorun reconheceu a luz deste fragmento."
            : "Um vidro antigo que emite uma luz suave.",
            0.82,
            0.82,
            0
        );
    }
    else {
        draw_set_alpha(0.48);
        draw_set_color(cor_borda);
        draw_text_transformed(360, 328, "?", 2.0, 2.0, 0);

        draw_set_alpha(0.60);
        draw_set_color(cor_texto);
        draw_text_transformed(
            360,
            485,
            "Itens importantes aparecerão aqui.",
            0.82,
            0.82,
            0
        );
    }


    // ─────────────────────────────────────────
    // PÁGINA DOS CACOS DO VITRAL
    // ─────────────────────────────────────────
    var inv_total_cacos = 0;

    for (
        var inv_contar = 0;
        inv_contar < array_length(global.fragmentos_vitral);
        inv_contar++
    ) {
        if (global.fragmentos_vitral[inv_contar]) {
            inv_total_cacos++;
        }
    }

    draw_set_alpha(1);
    draw_set_color(inv_cor_tinta);
    draw_text_transformed(910, 215, "Cacos do Vitral", 1.10, 1.10, 0);

    draw_set_alpha(0.68);
    draw_set_color(cor_texto);
    draw_text(
        910,
        252,
        string(inv_total_cacos) + " / 4 encontrados"
    );

    var inv_cores_cacos = [
        make_color_rgb(139, 181, 194),
        make_color_rgb(163, 174, 207),
        make_color_rgb(174, 194, 163),
        make_color_rgb(194, 166, 193)
    ];

    for (var inv_i = 0; inv_i < 4; inv_i++) {
        var inv_slot_x = 692 + inv_i * 108;
        var inv_encontrado = global.fragmentos_vitral[inv_i];

        draw_set_alpha(inv_encontrado ? 0.92 : 0.48);
        draw_set_color(inv_encontrado ? inv_cores_cacos[inv_i] : inv_cor_vazio);
        draw_roundrect(
            inv_slot_x,
            292,
            inv_slot_x + 82,
            398,
            false
        );

        draw_set_alpha(inv_encontrado ? 0.76 : 0.30);
        draw_set_color(cor_borda);
        draw_roundrect(
            inv_slot_x,
            292,
            inv_slot_x + 82,
            398,
            true
        );

        draw_set_alpha(inv_encontrado ? 0.94 : 0.40);
        draw_set_color(inv_encontrado ? c_white : inv_cor_texto_suave);
        draw_triangle(
            inv_slot_x + 41,
            311,
            inv_slot_x + 22,
            350,
            inv_slot_x + 47,
            379,
            false
        );
        draw_triangle(
            inv_slot_x + 41,
            311,
            inv_slot_x + 64,
            347,
            inv_slot_x + 47,
            379,
            false
        );

        // Fita adesiva pastel no topo de cada lembrança.
        draw_set_alpha(inv_encontrado ? 0.78 : 0.34);
        draw_set_color(inv_i mod 2 == 0 ? inv_cor_rosa : inv_cor_menta);
        draw_roundrect(
            inv_slot_x + 20,
            285,
            inv_slot_x + 62,
            301,
            false
        );

        if (!inv_encontrado) {
            draw_set_alpha(0.52);
            draw_set_color(cor_texto);
            draw_text(inv_slot_x + 41, 347, "?");
        }
    }

    draw_set_alpha(0.78);
    draw_set_color(global.vitral_resolvido ? inv_cor_menta : inv_cor_rosa);
    draw_roundrect(770, 414, 1050, 454, false);

    draw_set_alpha(1);
    draw_set_color(cor_texto);
    draw_text(
        910,
        434,
        global.vitral_resolvido
        ? "Vitral restaurado"
        : "Cacos ainda espalhados"
    );

    draw_set_alpha(0.62);
    draw_text_transformed(
        910,
        503,
        "Os cacos encontrados ficam guardados automaticamente.",
        0.78,
        0.78,
        0
    );


    // ─────────────────────────────────────────
    // BOTÃO VOLTAR
    // ─────────────────────────────────────────
    var inv_voltar_x1 = 515;
    var inv_voltar_y1 = 645;
    var inv_voltar_x2 = 765;
    var inv_voltar_y2 = 705;

    var inv_mouse_voltar = point_in_rectangle(
        mouse_gui_x,
        mouse_gui_y,
        inv_voltar_x1,
        inv_voltar_y1,
        inv_voltar_x2,
        inv_voltar_y2
    );

    draw_set_alpha(0.74);
    draw_set_color(inv_mouse_voltar ? cor_hover : cor_normal);
    draw_roundrect(
        inv_voltar_x1,
        inv_voltar_y1,
        inv_voltar_x2,
        inv_voltar_y2,
        false
    );

    draw_set_alpha(inv_mouse_voltar ? 0.82 : 0.38);
    draw_set_color(cor_borda);
    draw_roundrect(
        inv_voltar_x1,
        inv_voltar_y1,
        inv_voltar_x2,
        inv_voltar_y2,
        true
    );

    draw_set_alpha(1);
    draw_set_color(cor_texto);
    draw_text(640, (inv_voltar_y1 + inv_voltar_y2) / 2, "Voltar à pausa");

    draw_set_alpha(0.58);
    draw_set_color(cor_texto);
    draw_text_transformed(
        640,
        610,
        "Tab fecha o caderno e volta ao jogo",
        0.78,
        0.78,
        0
    );
}
*/


// ═════════════════════════════════════════════
// NOVO INVENTÁRIO EM PERGAMINHO
// ═════════════════════════════════════════════
if (tela_pause == 4) {
    var inv_cor_rosa = make_color_rgb(239, 205, 226);
    var inv_cor_lilas = make_color_rgb(220, 212, 244);
    var inv_cor_menta = make_color_rgb(198, 237, 220);
    var inv_cor_azul = make_color_rgb(205, 228, 245);
    var inv_cor_orquidea = make_color_rgb(230, 218, 245);
    var inv_cor_vazio = make_color_rgb(235, 233, 241);
    var inv_cor_papel = alto_contraste
        ? c_white
        : make_color_rgb(255, 249, 239);
    var inv_cor_papel_claro = alto_contraste
        ? c_white
        : make_color_rgb(252, 251, 255);
    var inv_cor_tinta = alto_contraste
        ? make_color_rgb(20, 22, 34)
        : make_color_rgb(57, 66, 107);
    var inv_cor_tinta_suave = alto_contraste
        ? make_color_rgb(48, 38, 86)
        : make_color_rgb(91, 97, 137);
    var inv_cores_abas = [
        inv_cor_menta,
        inv_cor_lilas,
        inv_cor_rosa,
        inv_cor_orquidea
    ];
    var inv_cores_cacos = [
        make_color_rgb(139, 194, 198),
        make_color_rgb(160, 168, 211),
        make_color_rgb(164, 198, 158),
        make_color_rgb(205, 158, 193)
    ];

    // A categoria é montada com o progresso atual e com as listas globais
    // que receberão os conteúdos novos adicionados futuramente.
    var inv_conteudo = [];
    var inv_total_cacos = 0;

    for (var inv_contar_novo = 0; inv_contar_novo < 4; inv_contar_novo++) {
        if (global.fragmentos_vitral[inv_contar_novo]) {
            inv_total_cacos++;
        }
    }

    switch (inventario_aba) {
        case 0:
            for (var inv_item_novo = 0; inv_item_novo < array_length(global.inventario_itens); inv_item_novo++) {
                array_push(inv_conteudo, global.inventario_itens[inv_item_novo]);
            }
        break;

        case 1:
            for (var inv_arma_nova = 0; inv_arma_nova < array_length(global.inventario_armas); inv_arma_nova++) {
                array_push(inv_conteudo, global.inventario_armas[inv_arma_nova]);
            }

            var inv_caco_nomes = [
                "Caco do Orvalho",
                "Caco da Semente",
                "Caco Lunar",
                "Caco Sereno"
            ];
            var inv_caco_historias = [
                "Uma lembrança fria como a madrugada. Ao tocá-la, Kiran ouve água correndo entre raízes antigas.",
                "O vidro conserva o calor de uma semente que esperou muitos anos pela estação certa.",
                "Sob a luz, uma voz Florakii canta sobre proteger memórias sem aprisioná-las.",
                "O último reflexo mostra um juramento diante da Rainha e uma porta que ainda permanece fechada."
            ];

            for (var inv_caco_arma = 0; inv_caco_arma < 4; inv_caco_arma++) {
                if (global.fragmentos_vitral[inv_caco_arma]) {
                    var inv_caco_arma_item = global.inventario_criar_item(
                        inv_caco_nomes[inv_caco_arma],
                        inv_caco_historias[inv_caco_arma],
                        "Fragmento do Vitral " + string(inv_caco_arma + 1) + " de 4",
                        1,
                        inv_cores_cacos[inv_caco_arma],
                        "caco"
                    );
                    inv_caco_arma_item.sprite_item = spr_fragmento;
                    array_push(inv_conteudo, inv_caco_arma_item);
                }
            }
        break;

        case 2:
            for (var inv_roupa_nova = 0; inv_roupa_nova < array_length(global.inventario_roupas); inv_roupa_nova++) {
                array_push(inv_conteudo, global.inventario_roupas[inv_roupa_nova]);
            }
        break;

        case 3:
            var inv_estado_luz = global.fragmento_reconhecido
                ? "Concluída"
                : "Em andamento";
            var inv_texto_luz = global.fragmento_reconhecido
                ? "Lorun reconheceu a luz que você encontrou na floresta."
                : (global.tem_fragmento
                    ? "Mostre a Lâmina do Fragmento a Lorun."
                    : "Procure pelo fragmento luminoso escondido entre as folhas.");

            array_push(
                inv_conteudo,
                global.inventario_criar_item(
                    "Luz entre as folhas",
                    inv_texto_luz,
                    inv_estado_luz,
                    1,
                    inv_cor_menta,
                    "missao"
                )
            );

            array_push(
                inv_conteudo,
                global.inventario_criar_item(
                    "Vitral da Memória",
                    global.vitral_resolvido
                        ? "O vitral foi restaurado e suas lembranças voltaram a brilhar."
                        : "Encontre os quatro cacos espalhados e restaure o vitral no templo.",
                    global.vitral_resolvido
                        ? "Concluída"
                        : string(inv_total_cacos) + " / 4 cacos",
                    1,
                    inv_cor_lilas,
                    "missao"
                )
            );

            for (var inv_missao_nova = 0; inv_missao_nova < array_length(global.inventario_missoes); inv_missao_nova++) {
                array_push(inv_conteudo, global.inventario_missoes[inv_missao_nova]);
            }
        break;
    }

    var inv_total_novo = min(
        array_length(inv_conteudo),
        inventario_aba == 3 ? 4 : 8
    );
    var inv_tem_selecao = inv_total_novo > 0;

    if (inv_tem_selecao) {
        inventario_slot = clamp(inventario_slot, 0, inv_total_novo - 1);
    }

    // Nova base ilustrada da bolsa, importada da arte final. O conteúdo
    // dinâmico continua sendo desenhado por cima para preservar itens,
    // missões, seleção e uso de consumíveis.
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_sprite_part_ext(
        Sprite16,
        0,
        0,
        210,
        1000,
        630,
        100,
        28,
        1.08,
        650 / 630,
        c_white,
        1
    );

    var desenhar_recorte_inventario = function(
        _sx,
        _sy,
        _sw,
        _sh,
        _x,
        _y,
        _w,
        _h,
        _alpha
    ) {
        draw_set_alpha(_alpha);
        draw_set_color(c_white);
        draw_sprite_part_ext(
            Sprite16,
            0,
            _sx,
            _sy,
            _sw,
            _sh,
            _x,
            _y,
            _w / _sw,
            _h / _sh,
            c_white,
            _alpha
        );
    };

    // Título e abas saem diretamente da folha ilustrada do inventário.
    // O cabeçalho ganha uma faixa própria. Ele não encosta mais nas abas,
    // então a leitura fica: título -> categorias -> conteúdo.
    // O título conduz a leitura da página e mantém a proporção original.
    desenhar_recorte_inventario(1160, 0, 370, 88, 480, 24, 320, 76, 1);

    var inv_abas_src_x = [1000, 1261, 1000, 1261];
    var inv_abas_src_y = [210, 210, 302, 302];

    for (var inv_aba_arte = 0; inv_aba_arte < 4; inv_aba_arte++) {
        var inv_aba_arte_ativa = inv_aba_arte == inventario_aba;
        var inv_aba_arte_hover = inv_aba_arte == inventario_mouse_aba;
        var inv_aba_arte_x = 252 + inv_aba_arte * 201;
        var inv_aba_arte_y = inv_aba_arte_ativa ? 90 : 96;
        var inv_aba_arte_h = inv_aba_arte_ativa ? 67 : 61;

        desenhar_recorte_inventario(
            inv_abas_src_x[inv_aba_arte],
            inv_abas_src_y[inv_aba_arte],
            261,
            92,
            inv_aba_arte_x,
            inv_aba_arte_y,
            190,
            inv_aba_arte_h,
            inv_aba_arte_ativa ? 1 : (inv_aba_arte_hover ? 0.90 : 0.66)
        );
    }

    // A arte-base ja traz a moldura vazia de "Detalhes". Desenhar outro
    // recorte por cima criava uma capsula dentro da outra; aqui entra apenas
    // o texto, centralizado na placa que ja pertence ao painel.
    draw_set_alpha(0.90);
    draw_set_color(inv_cor_tinta);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(888, 195, "Detalhes", 0.68, 0.68, 0);
    draw_set_valign(fa_top);

    // O nome da categoria ja aparece na aba ativa. Repeti-lo acima do divisor
    // criava um texto solto entre a navegacao e o conteudo; o divisor ilustrado
    // agora volta a respirar sozinho.

    // A construção antiga fica desativada; foi mantida no arquivo apenas
    // como referência de geometria para o conteúdo interativo.
    if (false) {
    // Título preso à página por uma fita pastel, como nas configurações.
    draw_set_alpha(0.16);
    draw_set_color(make_color_rgb(226, 211, 205));
    draw_roundrect(458, 70, 822, 118, false);

    draw_set_alpha(0.88);
    draw_set_color(inv_cor_rosa);
    draw_roundrect(455, 66, 825, 114, false);
    draw_set_alpha(0.40);
    draw_set_color(inv_cor_tinta_suave);
    draw_roundrect(455, 66, 825, 114, true);

    desenhar_folha_pause(476, 90, global.config_baixo_estimulo ? 0.20 : 0.44);
    desenhar_folha_pause(804, 90, global.config_baixo_estimulo ? 0.20 : 0.44);

    draw_set_alpha(1);
    draw_set_color(inv_cor_tinta);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(640, 90, "Bolsa de aventuras", 1.34, 1.34, 0);

    // Corpo principal com sombra discreta e contorno limpo.
    draw_set_alpha(0.14);
    draw_set_color(make_color_rgb(32, 41, 68));
    draw_roundrect(105, 171, 1175, 659, false);

    draw_set_alpha(1);
    draw_set_color(inv_cor_papel);
    draw_roundrect(99, 165, 1169, 653, false);
    draw_set_alpha(0.46);
    draw_set_color(inv_cor_tinta_suave);
    draw_roundrect(99, 165, 1169, 653, true);

    // Abas coloridas. A selecionada sobe como uma etiqueta de caderno.
    for (var inv_aba_nova = 0; inv_aba_nova < 4; inv_aba_nova++) {
        var inv_aba_x1_nova = 104 + inv_aba_nova * 267;
        var inv_aba_x2_nova = inv_aba_x1_nova + 261;
        var inv_aba_ativa = inv_aba_nova == inventario_aba;
        var inv_aba_mouse = inv_aba_nova == inventario_mouse_aba;
        var inv_aba_y1_nova = inv_aba_ativa ? 112 : 121;

        // Uma sombra curtinha faz a aba parecer parte do caderno.
        draw_set_alpha(inv_aba_ativa ? 0.18 : 0.09);
        draw_set_color(inv_cor_tinta);
        draw_roundrect(inv_aba_x1_nova + 3, inv_aba_y1_nova + 4, inv_aba_x2_nova + 3, 184, false);

        draw_set_alpha(inv_aba_ativa ? 0.94 : (inv_aba_mouse ? 0.82 : 0.58));
        draw_set_color(inv_cores_abas[inv_aba_nova]);
        draw_roundrect(inv_aba_x1_nova, inv_aba_y1_nova, inv_aba_x2_nova, 181, false);
        draw_set_alpha(inv_aba_ativa ? 0.78 : 0.30);
        draw_set_color(inv_cor_tinta);
        draw_roundrect(inv_aba_x1_nova, inv_aba_y1_nova, inv_aba_x2_nova, 181, true);

        // Pequena fita alternada dá unidade com os cartões das configurações.
        draw_set_alpha(inv_aba_ativa ? 0.78 : 0.30);
        draw_set_color(inv_aba_nova mod 2 == 0 ? inv_cor_rosa : inv_cor_menta);
        draw_roundrect(inv_aba_x1_nova + 18, inv_aba_y1_nova - 4,
            inv_aba_x1_nova + 58, inv_aba_y1_nova + 6, false);

        // Cada aba tem uma silhueta própria para ser reconhecida sem depender
        // somente do texto ou da cor.
        var inv_icone_x = inv_aba_x1_nova + 63;
        var inv_icone_y = inv_aba_y1_nova + 31;
        draw_set_alpha(inv_aba_ativa ? 0.92 : 0.58);
        draw_set_color(inv_cor_tinta_suave);

        if (inv_aba_nova == 0) {
            draw_line_width(inv_icone_x - 10, inv_icone_y + 9,
                inv_icone_x + 10, inv_icone_y - 10, 3);
            draw_ellipse(inv_icone_x - 11, inv_icone_y - 10,
                inv_icone_x + 3, inv_icone_y + 5, false);
            draw_ellipse(inv_icone_x - 1, inv_icone_y - 2,
                inv_icone_x + 13, inv_icone_y + 11, false);
        }
        else if (inv_aba_nova == 1) {
            draw_line_width(inv_icone_x - 11, inv_icone_y + 11,
                inv_icone_x + 10, inv_icone_y - 10, 4);
            draw_line_width(inv_icone_x - 9, inv_icone_y - 9,
                inv_icone_x + 11, inv_icone_y + 11, 3);
            draw_line_width(inv_icone_x - 13, inv_icone_y + 6,
                inv_icone_x - 5, inv_icone_y + 14, 3);
        }
        else if (inv_aba_nova == 2) {
            draw_rectangle(inv_icone_x - 8, inv_icone_y - 10,
                inv_icone_x + 8, inv_icone_y + 12, false);
            draw_triangle(inv_icone_x - 8, inv_icone_y - 9,
                inv_icone_x - 17, inv_icone_y - 1,
                inv_icone_x - 8, inv_icone_y + 5, false);
            draw_triangle(inv_icone_x + 8, inv_icone_y - 9,
                inv_icone_x + 17, inv_icone_y - 1,
                inv_icone_x + 8, inv_icone_y + 5, false);
        }
        else {
            draw_circle(inv_icone_x, inv_icone_y - 8, 7, false);
            draw_circle(inv_icone_x, inv_icone_y + 8, 7, false);
            draw_circle(inv_icone_x - 8, inv_icone_y, 7, false);
            draw_circle(inv_icone_x + 8, inv_icone_y, 7, false);
            draw_set_color(inv_cor_papel_claro);
            draw_circle(inv_icone_x, inv_icone_y, 4, false);
        }

        draw_set_alpha(1);
        draw_set_color(inv_cor_tinta);
        draw_text_transformed(
            (inv_aba_x1_nova + inv_aba_x2_nova) / 2 + 23,
            inv_aba_y1_nova + 25,
            inventario_abas[inv_aba_nova],
            0.86,
            0.86,
            0
        );

        if (inv_aba_ativa) {
            draw_set_alpha(0.82);
            draw_set_color(inv_cor_tinta_suave);
            draw_roundrect(inv_aba_x1_nova + 34, 174,
                inv_aba_x2_nova - 34, 178, false);
        }
    }

    // Folhas nos cantos dão acabamento sem cobrir o conteúdo.
    desenhar_folha_pause(118, 190, global.config_baixo_estimulo ? 0.24 : 0.56);
    desenhar_folha_pause(1150, 190, global.config_baixo_estimulo ? 0.24 : 0.56);
    desenhar_folha_pause(118, 632, global.config_baixo_estimulo ? 0.20 : 0.46);
    desenhar_folha_pause(1150, 632, global.config_baixo_estimulo ? 0.20 : 0.46);

    // Dois painéis internos dão hierarquia à grade e à ficha do item.
    draw_set_alpha(0.13);
    draw_set_color(inv_cor_lilas);
    draw_roundrect(122, 195, 558, 628, false);
    draw_set_alpha(0.18);
    draw_set_color(inv_cor_azul);
    draw_roundrect(597, 195, 1144, 628, false);

    draw_set_alpha(0.28);
    draw_set_color(inv_cor_tinta_suave);
    draw_roundrect(122, 195, 558, 628, true);
    draw_roundrect(597, 195, 1144, 628, true);

    draw_set_alpha(0.26);
    draw_set_color(inv_cor_tinta_suave);
    draw_line_width(577, 211, 577, 620, 2);

    draw_set_alpha(1);
    draw_set_color(inv_cor_tinta);
    draw_text_transformed(338, 208, inventario_abas[inventario_aba], 1.0, 1.0, 0);
    draw_set_alpha(0.30);
    draw_line(188, 229, 488, 229);
    desenhar_folha_pause(174, 229, 0.34);
    desenhar_folha_pause(502, 229, 0.34);

    // Etiqueta discreta da ficha, equilibrando o título da categoria.
    draw_set_alpha(0.78);
    draw_set_color(inv_cor_rosa);
    draw_roundrect(790, 204, 950, 235, false);
    draw_set_alpha(0.34);
    draw_set_color(inv_cor_tinta_suave);
    draw_roundrect(790, 204, 950, 235, true);
    draw_set_alpha(0.88);
    draw_set_color(inv_cor_tinta);
    draw_set_halign(fa_center);
    draw_text_transformed(870, 220, "Detalhes", 0.68, 0.68, 0);
    }

    if (inventario_aba == 3) {
        // Os oito slots pertencem à arte-base. Na aba de missões cobrimos só
        // essa área com um recorte do próprio papel aquarelado; assim não ficam
        // "fantasmas" da grade nem aparece um bloco branco artificial.
        desenhar_recorte_inventario(
            420, 235, 420, 100,
            132, 236, 442, 232,
            1
        );

        draw_set_alpha(0.14);
        draw_set_color(inv_cor_tinta_suave);
        draw_roundrect(138, 242, 568, 462, true);

        draw_set_halign(fa_center);
        draw_set_alpha(0.90);
        draw_set_color(inv_cor_tinta);
        draw_text_transformed(353, 252, "Jornada", 0.70, 0.70, 0);

        // Missões aparecem em cartões largos, como páginas marcadas.
        for (var inv_missao_draw = 0; inv_missao_draw < inv_total_novo; inv_missao_draw++) {
            var inv_missao_atual = inv_conteudo[inv_missao_draw];
            var inv_missao_y_nova = 274 + inv_missao_draw * 88;
            var inv_missao_sel = inv_missao_draw == inventario_slot;

            draw_set_alpha(inv_missao_sel ? 0.84 : 0.72);
            draw_set_color(inv_missao_sel ? inv_missao_atual.cor : inv_cor_papel_claro);
            draw_roundrect(160, inv_missao_y_nova, 546, inv_missao_y_nova + 66, false);
            draw_set_alpha(inv_missao_sel ? 0.56 : 0.22);
            draw_set_color(inv_cor_tinta_suave);
            draw_roundrect(160, inv_missao_y_nova, 546, inv_missao_y_nova + 66, true);

            draw_set_alpha(0.90);
            draw_set_color(inv_missao_atual.cor);
            draw_circle(190, inv_missao_y_nova + 33, 10, false);
            draw_circle(190, inv_missao_y_nova + 20, 6, false);
            draw_circle(190, inv_missao_y_nova + 46, 6, false);
            draw_circle(177, inv_missao_y_nova + 33, 6, false);
            draw_circle(203, inv_missao_y_nova + 33, 6, false);
            draw_set_color(inv_cor_orquidea);
            draw_circle(190, inv_missao_y_nova + 33, 4, false);

            draw_set_halign(fa_left);
            draw_set_alpha(1);
            draw_set_color(inv_cor_tinta);
            draw_text_transformed(222, inv_missao_y_nova + 21, inv_missao_atual.nome, 0.68, 0.68, 0);
            draw_set_alpha(0.72);
            draw_set_color(inv_cor_tinta_suave);
            draw_text_transformed(222, inv_missao_y_nova + 47, inv_missao_atual.detalhe, 0.52, 0.52, 0);
        }
    }
    else {
        // Grade com oito espaços, já pronta para os itens futuros.
        for (var inv_slot_novo = 0; inv_slot_novo < 8; inv_slot_novo++) {
            var inv_slot_col_nova = inv_slot_novo mod 4;
            var inv_slot_lin_nova = floor(inv_slot_novo / 4);
            var inv_slot_x_novo = 146 + inv_slot_col_nova * 111;
            var inv_slot_y_novo = 242 + inv_slot_lin_nova * 116;
            var inv_slot_ocupado = inv_slot_novo < inv_total_novo;
            var inv_slot_sel = inv_slot_ocupado && inv_slot_novo == inventario_slot;
            var inv_slot_cor_nova = inv_slot_ocupado
                ? inv_conteudo[inv_slot_novo].cor
                : inv_cor_vazio;

            // A moldura e o fundo dos oito espaços já fazem parte da arte.
            // Aqui entram apenas o brilho da seleção e o conteúdo vivo.
            if (inv_slot_sel) {
                draw_set_alpha(0.17);
                draw_set_color(inv_slot_cor_nova);
                draw_roundrect(
                    inv_slot_x_novo + 4,
                    inv_slot_y_novo + 4,
                    inv_slot_x_novo + 92,
                    inv_slot_y_novo + 95,
                    false
                );
            }

            if (inv_slot_ocupado) {
                draw_set_alpha(inv_slot_sel ? 0.30 : 0.16);
                draw_set_color(inv_slot_cor_nova);
                draw_circle(inv_slot_x_novo + 44, inv_slot_y_novo + 40, 31, false);
            }

            draw_set_alpha(inv_slot_sel ? 0.96 : 0.22);
            draw_set_color(inv_slot_sel ? inv_slot_cor_nova : inv_cor_tinta_suave);
            if (inv_slot_sel || inv_slot_ocupado) {
                draw_roundrect(inv_slot_x_novo, inv_slot_y_novo, inv_slot_x_novo + 88, inv_slot_y_novo + 92, true);
            }

            if (inv_slot_sel) {
                draw_set_alpha(0.34);
                draw_set_color(c_white);
                draw_roundrect(inv_slot_x_novo + 5, inv_slot_y_novo + 5,
                    inv_slot_x_novo + 83, inv_slot_y_novo + 87, true);
            }

            if (inv_slot_ocupado) {
                var inv_item_slot_novo = inv_conteudo[inv_slot_novo];
                var inv_icone_x_novo = inv_slot_x_novo + 44;
                var inv_icone_y_novo = inv_slot_y_novo + 38;

                draw_set_alpha(inv_item_slot_novo.bloqueado ? 0.42 : 0.96);
                draw_set_color(inv_item_slot_novo.bloqueado ? inv_cor_tinta_suave : inv_item_slot_novo.cor);

            var inv_slot_tem_sprite = variable_struct_exists(inv_item_slot_novo, "sprite_item")
                    && inv_item_slot_novo.sprite_item != -1
                    && sprite_exists(inv_item_slot_novo.sprite_item);

                if (inv_slot_tem_sprite) {
                    var inv_slot_sprite_w = max(1, sprite_get_width(inv_item_slot_novo.sprite_item));
                    var inv_slot_sprite_h = max(1, sprite_get_height(inv_item_slot_novo.sprite_item));
                    var inv_slot_sprite_scale = min(54 / inv_slot_sprite_w, 54 / inv_slot_sprite_h);
                    var inv_slot_sprite_x = inv_icone_x_novo
                        + (sprite_get_xoffset(inv_item_slot_novo.sprite_item) - inv_slot_sprite_w * 0.5)
                        * inv_slot_sprite_scale;
                    var inv_slot_sprite_y = inv_icone_y_novo
                        + (sprite_get_yoffset(inv_item_slot_novo.sprite_item) - inv_slot_sprite_h * 0.5)
                        * inv_slot_sprite_scale;
                    draw_sprite_ext(inv_item_slot_novo.sprite_item, 0,
                        inv_slot_sprite_x, inv_slot_sprite_y,
                        inv_slot_sprite_scale, inv_slot_sprite_scale,
                        0, c_white, inv_item_slot_novo.bloqueado ? 0.38 : 1);
                }
                else switch (inv_item_slot_novo.icone) {
                    case "fragmento":
                    case "caco":
                        draw_triangle(inv_icone_x_novo, inv_icone_y_novo - 25, inv_icone_x_novo - 21, inv_icone_y_novo, inv_icone_x_novo, inv_icone_y_novo + 25, false);
                        draw_triangle(inv_icone_x_novo, inv_icone_y_novo - 25, inv_icone_x_novo + 21, inv_icone_y_novo, inv_icone_x_novo, inv_icone_y_novo + 25, false);
                        draw_set_alpha(inv_item_slot_novo.bloqueado ? 0.34 : 0.72);
                        draw_set_color(c_white);
                        draw_line_width(inv_icone_x_novo - 5, inv_icone_y_novo - 15, inv_icone_x_novo - 12, inv_icone_y_novo - 1, 2);
                    break;

                    case "espada":
                        draw_line_width(inv_icone_x_novo - 15, inv_icone_y_novo + 18, inv_icone_x_novo + 15, inv_icone_y_novo - 18, 6);
                        draw_line_width(inv_icone_x_novo - 17, inv_icone_y_novo + 4, inv_icone_x_novo - 2, inv_icone_y_novo + 19, 4);
                    break;

                    case "roupa":
                        draw_rectangle(inv_icone_x_novo - 15, inv_icone_y_novo - 17, inv_icone_x_novo + 15, inv_icone_y_novo + 22, false);
                        draw_triangle(inv_icone_x_novo - 15, inv_icone_y_novo - 17, inv_icone_x_novo - 31, inv_icone_y_novo - 2, inv_icone_x_novo - 15, inv_icone_y_novo + 7, false);
                        draw_triangle(inv_icone_x_novo + 15, inv_icone_y_novo - 17, inv_icone_x_novo + 31, inv_icone_y_novo - 2, inv_icone_x_novo + 15, inv_icone_y_novo + 7, false);
                    break;

                    default:
                        draw_circle(inv_icone_x_novo, inv_icone_y_novo, 11, false);
                        draw_circle(inv_icone_x_novo, inv_icone_y_novo - 17, 8, false);
                        draw_circle(inv_icone_x_novo, inv_icone_y_novo + 17, 8, false);
                        draw_circle(inv_icone_x_novo - 17, inv_icone_y_novo, 8, false);
                        draw_circle(inv_icone_x_novo + 17, inv_icone_y_novo, 8, false);
                    break;
                }

                if (inv_item_slot_novo.bloqueado) {
                    draw_set_alpha(0.86);
                    draw_set_color(inv_cor_tinta);
                    draw_set_halign(fa_center);
                    draw_text(inv_icone_x_novo, inv_icone_y_novo, "?");
                }

                if (inv_item_slot_novo.quantidade > 1) {
                    draw_set_alpha(0.94);
                    draw_set_color(inv_cor_rosa);
                    draw_circle(inv_slot_x_novo + 76, inv_slot_y_novo + 15, 12, false);
                    draw_set_alpha(1);
                    draw_set_color(inv_cor_tinta);
                    draw_text_transformed(inv_slot_x_novo + 76, inv_slot_y_novo + 15, string(inv_item_slot_novo.quantidade), 0.55, 0.55, 0);
                }

                draw_set_alpha(0.84);
                draw_set_color(inv_cor_tinta);
                draw_set_halign(fa_center);
                draw_text_transformed(
                    inv_slot_x_novo + 44,
                    inv_slot_y_novo + 77,
                    inv_item_slot_novo.bloqueado ? "???" : inv_item_slot_novo.nome,
                    0.48,
                    0.48,
                    0
                );
            }
            // Os pontos dos espaços vazios já estão pintados no painel-base.
        }
    }

    // Ficha à direita: ilustração, nome, descrição e estado.
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    if (inv_tem_selecao) {
        var inv_item_detalhe = inv_conteudo[inventario_slot];
        var inv_detalhe_cor = inv_item_detalhe.bloqueado
            ? inv_cor_vazio
            : inv_item_detalhe.cor;

        draw_set_alpha(0.16);
        draw_set_color(inv_detalhe_cor);
        draw_circle(862, 315, 82, false);
        draw_set_alpha(0.24);
        draw_circle(862, 315, 61, false);
        draw_set_alpha(inv_item_detalhe.bloqueado ? 0.40 : 0.96);
        draw_set_color(inv_item_detalhe.bloqueado ? inv_cor_tinta_suave : inv_detalhe_cor);

        var inv_tem_sprite_item = variable_struct_exists(inv_item_detalhe, "sprite_item")
            && inv_item_detalhe.sprite_item != -1
            && sprite_exists(inv_item_detalhe.sprite_item);

        if (inv_tem_sprite_item) {
            var inv_sprite_item_w = max(1, sprite_get_width(inv_item_detalhe.sprite_item));
            var inv_sprite_item_h = max(1, sprite_get_height(inv_item_detalhe.sprite_item));
            var inv_sprite_item_escala = min(118 / inv_sprite_item_w, 118 / inv_sprite_item_h);
            var inv_sprite_item_x = 862
                + (sprite_get_xoffset(inv_item_detalhe.sprite_item) - inv_sprite_item_w * 0.5)
                * inv_sprite_item_escala;
            var inv_sprite_item_y = 315
                + (sprite_get_yoffset(inv_item_detalhe.sprite_item) - inv_sprite_item_h * 0.5)
                * inv_sprite_item_escala;
            draw_set_alpha(inv_item_detalhe.bloqueado ? 0.38 : 1);
            draw_sprite_ext(
                inv_item_detalhe.sprite_item,
                0,
                inv_sprite_item_x,
                inv_sprite_item_y,
                inv_sprite_item_escala,
                inv_sprite_item_escala,
                0,
                c_white,
                inv_item_detalhe.bloqueado ? 0.38 : 1
            );
        }
        else if (inv_item_detalhe.icone == "missao") {
            draw_circle(862, 315, 25, false);
            draw_circle(862, 280, 16, false);
            draw_circle(862, 350, 16, false);
            draw_circle(827, 315, 16, false);
            draw_circle(897, 315, 16, false);
            draw_set_color(inv_cor_orquidea);
            draw_circle(862, 315, 10, false);
        }
        else if (inv_item_detalhe.icone == "espada") {
            draw_line_width(825, 352, 899, 278, 13);
            draw_line_width(822, 319, 858, 355, 8);
        }
        else if (inv_item_detalhe.icone == "roupa") {
            draw_rectangle(832, 280, 892, 356, false);
            draw_triangle(832, 280, 803, 310, 832, 327, false);
            draw_triangle(892, 280, 921, 310, 892, 327, false);
        }
        else if (inv_item_detalhe.icone == "fragmento" || inv_item_detalhe.icone == "caco") {
            draw_triangle(862, 260, 815, 315, 862, 371, false);
            draw_triangle(862, 260, 909, 315, 862, 371, false);
            draw_set_alpha(inv_item_detalhe.bloqueado ? 0.34 : 0.70);
            draw_set_color(c_white);
            draw_line_width(849, 282, 832, 312, 4);
        }
        else if (inv_item_detalhe.icone == "orvalho") {
            draw_triangle(862, 272, 830, 330, 862, 357, false);
            draw_triangle(862, 272, 894, 330, 862, 357, false);
            draw_set_alpha(0.52);
            draw_set_color(c_white);
            draw_triangle(859, 284, 840, 326, 860, 316, false);
        }
        else if (inv_item_detalhe.icone == "fruto") {
            draw_circle(844, 324, 29, false);
            draw_circle(878, 324, 29, false);
            draw_set_color(inv_cor_menta);
            draw_triangle(859, 294, 866, 265, 900, 279, false);
        }
        else if (inv_item_detalhe.icone == "seiva") {
            draw_triangle(862, 264, 829, 325, 862, 369, false);
            draw_triangle(862, 264, 895, 325, 862, 369, false);
            draw_triangle(813, 310, 911, 310, 862, 344, false);
        }
        else {
            draw_circle(862, 315, 22, false);
            draw_circle(862, 279, 17, false);
            draw_circle(862, 351, 17, false);
            draw_circle(826, 315, 17, false);
            draw_circle(898, 315, 17, false);
        }

        if (inv_item_detalhe.bloqueado) {
            draw_set_alpha(0.92);
            draw_set_color(inv_cor_tinta);
            draw_text_transformed(862, 315, "?", 1.8, 1.8, 0);
        }

        draw_set_alpha(1);
        draw_set_color(inv_cor_tinta);
        draw_text_transformed(
            862,
            416,
            inv_item_detalhe.bloqueado ? "Ainda é um mistério" : inv_item_detalhe.nome,
            1.02,
            1.02,
            0
        );

        draw_set_alpha(0.86);
        draw_set_color(inv_detalhe_cor);
        draw_roundrect(746, 447, 978, 481, false);
        draw_set_alpha(1);
        draw_set_color(inv_cor_tinta);
        draw_text_transformed(862, 464, inv_item_detalhe.detalhe, 0.66, 0.66, 0);

        // A descrição fica em uma ficha própria, em vez de flutuar na página.
        // Missões usam uma ficha curta para permanecer dentro do painel.
        var inv_desc_x1 = inventario_aba == 3 ? 680 : 650;
        var inv_desc_x2 = inventario_aba == 3 ? 1044 : 1090;
        var inv_desc_y2 = inventario_aba == 3 ? 546 : 580;
        draw_set_alpha(0.72);
        draw_set_color(inv_cor_papel_claro);
        draw_roundrect(inv_desc_x1, 496, inv_desc_x2, inv_desc_y2, false);
        draw_set_alpha(0.26);
        draw_set_color(inv_cor_tinta_suave);
        draw_roundrect(inv_desc_x1, 496, inv_desc_x2, inv_desc_y2, true);

        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_alpha(0.78);
        draw_set_color(inv_cor_tinta_suave);
        draw_text_ext_transformed(
            inventario_aba == 3 ? 700 : 673,
            inventario_aba == 3 ? 504 : 508,
            inv_item_detalhe.descricao,
            inventario_aba == 3 ? 22 : 28,
            inventario_aba == 3 ? 324 : 380,
            inventario_aba == 3 ? 0.68 : 0.76,
            inventario_aba == 3 ? 0.68 : 0.76,
            0
        );

        if (inventario_aba == 3 && inventario_slot == 1 && !global.vitral_resolvido) {
            draw_set_alpha(0.24);
            draw_set_color(inv_cor_vazio);
            draw_roundrect(700, 552, 1024, 562, false);
            draw_set_alpha(0.92);
            draw_set_color(inv_cor_lilas);
            draw_roundrect(700, 552, 700 + 324 * (inv_total_cacos / 4), 562, false);
        }

        var inv_item_consumivel = inventario_aba == 0
            && variable_struct_exists(inv_item_detalhe, "consumivel")
            && inv_item_detalhe.consumivel
            && variable_struct_exists(inv_item_detalhe, "cura")
            && inv_item_detalhe.cura > 0;

        if (inv_item_consumivel) {
            var inv_vida_cheia = global.vida_kiran >= global.vida_kiran_max;
            var inv_usar_hover = point_in_rectangle(
                mouse_gui_x,
                mouse_gui_y,
                756,
                596,
                968,
                642
            );
            draw_set_alpha(inv_vida_cheia ? 0.38 : (inv_usar_hover ? 1 : 0.82));
            draw_set_color(inv_vida_cheia ? inv_cor_vazio : inv_cor_menta);
            draw_roundrect(756, 596, 968, 642, false);
            draw_set_alpha(inv_usar_hover ? 0.92 : 0.50);
            draw_set_color(inv_cor_tinta_suave);
            draw_roundrect(756, 596, 968, 642, true);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_alpha(inv_vida_cheia ? 0.46 : 1);
            draw_set_color(inv_cor_tinta);
            draw_text_transformed(862, 619,
                inv_vida_cheia ? "Vida completa" : "Espaço  •  Usar",
                0.65, 0.65, 0);
            draw_set_alpha(0.72);
            draw_text_transformed(862, 657,
                inv_item_detalhe.raridade + "  •  Cura " + string(inv_item_detalhe.cura),
                0.49, 0.49, 0);
        }
    }
    else {
        var inv_texto_vazio = "Novos tesouros aparecerão aqui.";

        if (inventario_aba == 1) {
            inv_texto_vazio = "As armas encontradas durante a jornada ficarão guardadas aqui.";
        }
        else if (inventario_aba == 2) {
            inv_texto_vazio = "Roupas e acessórios especiais aparecerão aqui.";
        }
        else if (inventario_aba == 0) {
            inv_texto_vazio = "Sua bolsa ainda está esperando a primeira descoberta.";
        }

        draw_set_alpha(0.16);
        draw_set_color(inv_cores_abas[inventario_aba]);
        draw_circle(870, 315, 78, false);
        draw_set_alpha(0.50);
        draw_set_color(inv_cor_tinta_suave);
        draw_line_width(850, 332, 890, 285, 4);
        desenhar_folha_pause(857, 317, 0.44);
        desenhar_folha_pause(882, 298, 0.44);

        draw_set_alpha(1);
        draw_set_color(inv_cor_tinta);
        draw_text_transformed(870, 420, "Um cantinho à espera", 1.0, 1.0, 0);
        draw_set_halign(fa_center);
        draw_set_valign(fa_top);
        draw_set_alpha(0.70);
        draw_set_color(inv_cor_tinta_suave);
        draw_text_ext_transformed(870, 462, inv_texto_vazio, 28, 360, 0.76, 0.76, 0);
    }

    if (inventario_mensagem_timer > 0) {
        draw_set_alpha(0.94);
        draw_set_color(inv_cor_menta);
        draw_roundrect(382, 610, 898, 640, false);
        draw_set_alpha(0.48);
        draw_set_color(inv_cor_tinta_suave);
        draw_roundrect(382, 610, 898, 640, true);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_alpha(1);
        draw_set_color(inv_cor_tinta);
        draw_text_transformed(640, 625, inventario_mensagem, 0.53, 0.53, 0);
    }

    // Rodapé final da nova folha. O botão central mantém a mesma área clicável
    // usada no Step, agora com a arte “Voltar ao jogo”.
    var inv_botao_voltar_x1 = 527;
    // O rodapé fica numa faixa própria abaixo da moldura principal.
    // Isso evita que as etiquetas pareçam coladas no painel de conteúdo.
    var inv_botao_voltar_y1 = 680;
    var inv_botao_voltar_x2 = 753;
    var inv_botao_voltar_y2 = 720;
    var inv_botao_voltar_hover = point_in_rectangle(
        mouse_gui_x,
        mouse_gui_y,
        inv_botao_voltar_x1,
        inv_botao_voltar_y1,
        inv_botao_voltar_x2,
        inv_botao_voltar_y2
    );

    // Mantém o mesmo eixo vertical, mas respeita a razão de aspecto de cada
    // etiqueta para que nenhuma delas pareça horizontalmente esticada.
    desenhar_recorte_inventario(1000, 394, 360, 58, 157, 680, 248, 40, 0.90);
    desenhar_recorte_inventario(
        1360, 394, 310, 55,
        inv_botao_voltar_x1,
        inv_botao_voltar_y1,
        inv_botao_voltar_x2 - inv_botao_voltar_x1,
        inv_botao_voltar_y2 - inv_botao_voltar_y1,
        inv_botao_voltar_hover ? 1 : 0.88
    );
    desenhar_recorte_inventario(1000, 452, 350, 58, 878, 680, 242, 40, 0.90);

    if (false) {
    // Rodapé em etiquetas de papel, seguindo o acabamento das configurações.
    draw_set_alpha(0.58);
    draw_set_color(inv_cor_azul);
    draw_roundrect(122, 675, 445, 719, false);
    draw_set_color(inv_cor_lilas);
    draw_roundrect(835, 675, 1158, 719, false);
    draw_set_alpha(0.28);
    draw_set_color(inv_cor_tinta_suave);
    draw_roundrect(122, 675, 445, 719, true);
    draw_roundrect(835, 675, 1158, 719, true);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_alpha(0.78);
    draw_set_color(inv_cor_tinta);
    var inv_rodape_esquerda = variable_global_exists("mobile_mode") && global.mobile_mode
        ? "Toque nas abas  |  Toque para selecionar"
        : "Q / E trocar aba  |  Setas selecionar";
    var inv_rodape_direita = variable_global_exists("mobile_mode") && global.mobile_mode
        ? "Toque no botão central para fechar"
        : "Espaço usar item  |  Tab fechar";
    draw_text_transformed(282, 697, inv_rodape_esquerda, 0.62, 0.62, 0);
    draw_text_transformed(1000, 697, inv_rodape_direita, 0.62, 0.62, 0);

    var inv_voltar_x1_novo = 485;
    var inv_voltar_y1_novo = 675;
    var inv_voltar_x2_novo = 795;
    var inv_voltar_y2_novo = 719;
    var inv_mouse_voltar_novo = point_in_rectangle(
        mouse_gui_x,
        mouse_gui_y,
        inv_voltar_x1_novo,
        inv_voltar_y1_novo,
        inv_voltar_x2_novo,
        inv_voltar_y2_novo
    );

    draw_set_alpha(0.88);
    draw_set_color(inv_mouse_voltar_novo ? inv_cor_menta : inv_cor_papel_claro);
    draw_roundrect(inv_voltar_x1_novo, inv_voltar_y1_novo, inv_voltar_x2_novo, inv_voltar_y2_novo, false);
    draw_set_alpha(inv_mouse_voltar_novo ? 0.90 : 0.44);
    draw_set_color(inv_cor_tinta_suave);
    draw_roundrect(inv_voltar_x1_novo, inv_voltar_y1_novo, inv_voltar_x2_novo, inv_voltar_y2_novo, true);
    draw_set_alpha(1);
    draw_set_color(inv_cor_tinta);
    draw_text_transformed(640, 697, "Voltar ao jogo", 0.82, 0.82, 0);
    }
}


// ═════════════════════════════════════════════
// AMEAÇA ANTES DO DUELO
// ═════════════════════════════════════════════
if (
    tela_pause == 5
    && (
        batalha_fase == -4
        || batalha_fase == -3
        || batalha_fase == -1
        || batalha_fase == -5
        || batalha_fase == -2
    )
) {
    var cena_tinta = alto_contraste
        ? make_color_rgb(10, 14, 27)
        : make_color_rgb(30, 42, 73);
    var cena_tinta_suave = alto_contraste
        ? make_color_rgb(31, 38, 57)
        : make_color_rgb(78, 88, 119);
    var cena_borda = alto_contraste
        ? make_color_rgb(32, 38, 62)
        : make_color_rgb(107, 116, 151);
    var cena_papel = alto_contraste
        ? c_white
        : make_color_rgb(250, 247, 237);
    var cena_papel_frio = alto_contraste
        ? make_color_rgb(248, 249, 252)
        : make_color_rgb(234, 237, 246);
    var cena_rosa = make_color_rgb(241, 194, 218);
    var cena_menta = make_color_rgb(183, 228, 211);
    var cena_lilas = make_color_rgb(202, 196, 231);
    var cena_noite = make_color_rgb(27, 39, 64);
    var cena_roteiro = batalha_fase == -4;
    var cena_indice_inimigo = clamp(batalha_inimigo, 0, 3);
    var cena_nome_npc = cena_roteiro
        ? encontro_roteiro_nome
        : nomes_inimigos[cena_indice_inimigo];
    var cena_titulo_npc = cena_roteiro
        ? encontro_roteiro_titulo
        : titulos_inimigos[cena_indice_inimigo];
    var cena_rotulo_npc = cena_roteiro
        ? encontro_roteiro_rotulo
        : rotulos_faccoes_inimigos[cena_indice_inimigo];
    var cena_contexto_npc = cena_roteiro
        ? encontro_roteiro_contexto
        : (faccoes_inimigos[cena_indice_inimigo] == "florakii"
            ? "Uma guardiã do bosque. Sua lealdade é à memória viva da floresta, não à Rainha."
            : "Um agente da Coroa. Suas ordens são impedir que desconhecidos levem as oferendas.");
    var cena_cor_npc = cena_roteiro
        ? encontro_roteiro_cor
        : cores_inimigos[cena_indice_inimigo];
    var cena_florakii = cena_roteiro
        ? encontro_roteiro_tipo == 2
        : faccoes_inimigos[cena_indice_inimigo] == "florakii";
    var cena_tem_arma = global.tem_espada_fragmento;

    draw_set_font(fnt_dialogo);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    // Cenário exclusivo do encontro, com o mesmo enquadramento em todas as rooms.
    draw_set_alpha(1);
    draw_set_color(c_white);
    if (
        cena_roteiro
        && encontro_roteiro_tipo == 7
        && sprite_exists(spr_background_rainha)
    ) {
        draw_sprite_stretched(spr_background_rainha, 0, 0, 0, 1280, 811);
    }
    else if (sprite_exists(spr_fundo_encontro)) {
        draw_sprite_stretched(spr_fundo_encontro, 0, 0, 0, 1280, 811);
    }
    else {
        draw_set_color(cena_noite);
        draw_rectangle(0, 0, 1280, 811, false);
    }
    draw_set_alpha(alto_contraste ? 0.32 : 0.18);
    draw_set_color(make_color_rgb(10, 17, 34));
    draw_rectangle(0, 0, 1280, 811, false);

    // Título cerimonial: discreto, mas claramente separado da conversa.
    draw_set_alpha(0.30);
    draw_set_color(make_color_rgb(8, 14, 29));
    draw_roundrect(377, 46, 903, 113, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
    // A largura da fonte varia com a configuração de texto. O vão das linhas
    // acompanha o título para nunca atravessar as letras.
    var cena_titulo = cena_roteiro && encontro_roteiro_tipo == 7
        ? "AUDIÊNCIA DA RAINHA"
        : "ENCONTRO NA FLORESTA";
    var cena_titulo_escala = 1.18;
    var cena_titulo_metade = string_width(cena_titulo)
        * cena_titulo_escala * 0.5;
    draw_line(402, 76, 640 - cena_titulo_metade - 24, 76);
    draw_line(640 + cena_titulo_metade + 24, 76, 878, 76);
    draw_text_transformed(
        640,
        76,
        cena_titulo,
        cena_titulo_escala,
        cena_titulo_escala,
        0
    );
    // Losango desenhado, sem depender de um glifo ausente na fonte.
    draw_set_alpha(0.92);
    draw_line(640, 92, 647, 100);
    draw_line(647, 100, 640, 108);
    draw_line(640, 108, 633, 100);
    draw_line(633, 100, 640, 92);

    // Retrato grande; o cálculo aceita qualquer sprite novo sem ficar minúsculo.
    var cena_npc_x = 855;
    var cena_npc_y = 316;
    var cena_retrato = cena_roteiro
        ? encontro_roteiro_retrato
        : sprites_retrato_inimigos[cena_indice_inimigo];

    // A Rainha alterna a expressão sem alterar o roteiro. Nas falas mais
    // acolhedoras ela sorri; no restante da audiência mantém o retrato neutro.
    if (cena_roteiro && encontro_roteiro_tipo == 7) {
        cena_retrato = spr_perfil_rainha_neutro;

        if (
            encontro_roteiro_bloco != 1
            && encontro_roteiro_bloco != 4
            && encontro_roteiro_indice >= 0
            && encontro_roteiro_indice < array_length(encontro_roteiro_linhas)
        ) {
            var cena_fala_rainha = encontro_roteiro_linhas[encontro_roteiro_indice];

            if (is_struct(cena_fala_rainha) && cena_fala_rainha.nome == "Rainha Dahlýria") {
                var cena_texto_rainha = string_lower(cena_fala_rainha.texto);
                var cena_rainha_alegre =
                    string_pos("você a salvou", cena_texto_rainha) > 0
                    || string_pos("principalmente por isso", cena_texto_rainha) > 0
                    || string_pos("não precisa fazer isso sozinho", cena_texto_rainha) > 0
                    || string_pos("essa confiança", cena_texto_rainha) > 0
                    || string_pos("mudou mais", cena_texto_rainha) > 0;

                if (cena_rainha_alegre) cena_retrato = spr_perfil_rainha_alegre;
            }
        }
    }

    draw_set_alpha(0.17);
    draw_set_color(cena_cor_npc);
    draw_circle(cena_npc_x, cena_npc_y, 190, false);
    draw_set_alpha(0.12);
    draw_set_color(c_white);
    draw_circle(cena_npc_x, cena_npc_y, 152, false);
    draw_set_alpha(0.42);
    draw_set_color(cena_menta);
    draw_circle(cena_npc_x, cena_npc_y, 188, true);

    if (cena_retrato != -1 && sprite_exists(cena_retrato)) {
        var cena_sprite_w = max(1, sprite_get_width(cena_retrato));
        var cena_sprite_h = max(1, sprite_get_height(cena_retrato));
        var cena_ajuste_personagem = cena_roteiro
            ? 1
            : clamp(escalas_batalha_inimigos[cena_indice_inimigo], 0.90, 1.25);
        var cena_sprite_escala = min(310 / cena_sprite_w, 345 / cena_sprite_h)
            * cena_ajuste_personagem;
        var cena_sprite_x = cena_npc_x
            + (sprite_get_xoffset(cena_retrato) - cena_sprite_w * 0.5)
            * cena_sprite_escala;
        var cena_sprite_y = cena_npc_y
            + (sprite_get_yoffset(cena_retrato) - cena_sprite_h * 0.5)
            * cena_sprite_escala;

        draw_set_alpha(1);
        draw_sprite_ext(
            cena_retrato,
            floor(tempo_inimigos) mod max(1, sprite_get_number(cena_retrato)),
            cena_sprite_x,
            cena_sprite_y,
            cena_sprite_escala,
            cena_sprite_escala,
            0,
            c_white,
            1
        );
    }
    else if (cena_roteiro && encontro_roteiro_tipo == 7) {
        // Silhueta provisória da Rainha até spr_perfil_rainha existir.
        draw_set_alpha(0.98);
        draw_set_color(cena_papel);
        draw_circle(cena_npc_x, cena_npc_y - 72, 39, false);
        draw_set_color(cena_cor_npc);
        draw_triangle(cena_npc_x - 24, cena_npc_y - 104,
            cena_npc_x, cena_npc_y - 146,
            cena_npc_x + 24, cena_npc_y - 104, false);
        draw_triangle(cena_npc_x - 68, cena_npc_y + 116,
            cena_npc_x, cena_npc_y - 27,
            cena_npc_x + 68, cena_npc_y + 116, false);
        draw_set_color(cena_borda);
        draw_circle(cena_npc_x, cena_npc_y - 72, 39, true);
        draw_line(cena_npc_x - 68, cena_npc_y + 116,
            cena_npc_x, cena_npc_y - 27);
        draw_line(cena_npc_x, cena_npc_y - 27,
            cena_npc_x + 68, cena_npc_y + 116);
    }
    else {
        draw_set_alpha(0.98);
        draw_set_color(cena_papel);
        draw_circle(cena_npc_x, cena_npc_y - 58, 44, false);
        draw_set_color(cena_cor_npc);
        draw_roundrect(cena_npc_x - 48, cena_npc_y - 10,
            cena_npc_x + 48, cena_npc_y + 118, false);
        draw_set_color(cena_borda);
        draw_circle(cena_npc_x, cena_npc_y - 58, 44, true);
        draw_roundrect(cena_npc_x - 48, cena_npc_y - 10,
            cena_npc_x + 48, cena_npc_y + 118, true);
    }

    // Ficha de contexto à esquerda, inspirada em papel artesanal.
    draw_set_alpha(0.22);
    draw_set_color(make_color_rgb(7, 13, 27));
    draw_roundrect(72, 163, 486, 370, false);
    draw_set_alpha(0.96);
    draw_set_color(cena_papel);
    draw_roundrect(65, 156, 479, 363, false);
    draw_set_alpha(0.64);
    draw_set_color(cena_borda);
    draw_roundrect(65, 156, 479, 363, true);
    draw_line(104, 207, 440, 207);
    draw_set_halign(fa_left);
    draw_set_alpha(1);
    draw_set_color(cena_tinta);
    draw_text_transformed(100, 183, "Encontro na floresta", 1.12, 1.12, 0);
    draw_set_color(cena_tinta);
    draw_set_valign(fa_top);
    draw_text_ext_transformed(
        100,
        225,
        cena_contexto_npc,
        34,
        320,
        1.06,
        1.06,
        0
    );
    draw_set_valign(fa_middle);

    // Faixa do equipamento, destacada da ficha e fácil de identificar.
    draw_set_alpha(0.20);
    draw_set_color(make_color_rgb(7, 13, 27));
    draw_roundrect(94, 391, 458, 447, false);
    draw_set_alpha(0.96);
    draw_set_color(cena_tem_arma ? make_color_rgb(219, 234, 218) : cena_lilas);
    draw_roundrect(88, 385, 452, 441, false);
    draw_set_alpha(0.76);
    draw_set_color(cena_borda);
    draw_roundrect(88, 385, 452, 441, true);
    draw_set_alpha(0.20);
    draw_set_color(cena_cor_npc);
    draw_circle(122, 413, 20, false);
    draw_set_alpha(1);
    draw_set_color(cena_tinta);
    if (cena_tem_arma) {
        draw_line_width(114, 422, 130, 404, 3);
        draw_line_width(113, 405, 129, 421, 2);
    }
    else {
        draw_text_transformed(122, 413, "?", 1.10, 1.10, 0);
    }
    draw_set_halign(fa_center);
    draw_text_transformed(
        288,
        413,
        cena_tem_arma
            ? "Lâmina do Fragmento equipada"
            : "Você ainda não encontrou uma arma",
        0.82,
        0.82,
        0
    );

    // Identidade do oponente, separada do retrato como na referência.
    draw_set_halign(fa_center);
    draw_set_alpha(0.46);
    draw_set_color(make_color_rgb(7, 12, 26));
    draw_text_transformed(1094, 251, cena_nome_npc, 1.90, 1.90, 0);
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_text_transformed(1091, 248, cena_nome_npc, 1.90, 1.90, 0);
    draw_set_alpha(0.98);
    draw_text_transformed(1091, 292, cena_titulo_npc, 0.88, 0.88, 0);
    draw_set_alpha(0.72);
    draw_line(996, 316, 1186, 316);
    draw_set_alpha(0.96);
    draw_set_color(cena_florakii ? cena_menta : cena_lilas);
    draw_roundrect(982, 331, 1200, 371, false);
    draw_set_alpha(0.72);
    draw_set_color(cena_borda);
    draw_roundrect(982, 331, 1200, 371, true);
    draw_set_alpha(1);
    draw_set_color(cena_tinta);
    draw_text_transformed(1091, 351,
        cena_rotulo_npc, 0.78, 0.78, 0);

    // Painel de diálogo largo com sombra e margem generosa.
    draw_set_alpha(0.28);
    draw_set_color(make_color_rgb(6, 12, 26));
    draw_roundrect(68, 519, 1218, 785, false);
    draw_set_alpha(0.98);
    draw_set_color(cena_papel);
    draw_roundrect(60, 511, 1210, 777, false);
    draw_set_alpha(0.68);
    draw_set_color(cena_borda);
    draw_roundrect(60, 511, 1210, 777, true);

    var cena_nome_falante = cena_nome_npc;

    if (
        cena_roteiro
        && encontro_roteiro_bloco != 1
        && encontro_roteiro_bloco != 4
        && array_length(encontro_roteiro_linhas) > 0
    ) {
        cena_nome_falante = encontro_roteiro_linhas[encontro_roteiro_indice].nome;
    }

    if (cena_roteiro && (encontro_roteiro_bloco == 1 || encontro_roteiro_bloco == 4)) {
        cena_nome_falante = "Kiran";
    }

    if (batalha_fase == -3 && batalha_conversa_etapa == 1) {
        cena_nome_falante = "Kiran";
    }

    if (batalha_fase == -5) {
        cena_nome_falante = "Kiran";
    }

    draw_set_alpha(1);
    draw_set_color(cena_nome_falante == "Kiran" ? cena_lilas : (cena_florakii ? cena_menta : cena_rosa));
    draw_roundrect(86, 492, 324, 546, false);
    draw_set_color(cena_borda);
    draw_roundrect(86, 492, 324, 546, true);
    draw_set_color(cena_tinta);
    draw_text_transformed(205, 519, cena_nome_falante, 1.06, 1.06, 0);

    draw_set_valign(fa_top);

    if (batalha_fase == -4) {
        var cena_roteiro_escolha = encontro_roteiro_bloco == 1
            || encontro_roteiro_bloco == 4;

        if (cena_roteiro_escolha) {
            var cena_roteiro_opcoes = encontro_roteiro_bloco == 1
                ? encontro_roteiro_opcoes1
                : encontro_roteiro_opcoes2;

            var cena_roteiro_mobile = variable_global_exists("mobile_mode")
                && global.mobile_mode;

            if (!cena_roteiro_mobile) {
                draw_set_halign(fa_left);
                draw_set_valign(fa_top);
                draw_set_color(cena_tinta);
                draw_text_transformed(88, 520, "Como Kiran responde?", 1.04, 1.04, 0);
            }

            for (var cena_roteiro_i = 0;
                cena_roteiro_i < array_length(cena_roteiro_opcoes);
                cena_roteiro_i++
            ) {
                var cena_roteiro_x1 = 88;
                var cena_roteiro_y1 = cena_roteiro_mobile
                    ? 520 + cena_roteiro_i * 58
                    : 558 + cena_roteiro_i * 51;
                var cena_roteiro_x2 = 1192;
                var cena_roteiro_y2 = cena_roteiro_y1
                    + (cena_roteiro_mobile ? 54 : 46);
                var cena_roteiro_sel = encontro_roteiro_opcao == cena_roteiro_i;

                draw_set_alpha(cena_roteiro_sel ? 0.19 : 0.10);
                draw_set_color(make_color_rgb(66, 61, 96));
                draw_roundrect(cena_roteiro_x1 + 2, cena_roteiro_y1 + 3,
                    cena_roteiro_x2 + 2, cena_roteiro_y2 + 3, false);

                draw_set_alpha(cena_roteiro_sel ? 0.98 : 0.84);
                draw_set_color(cena_roteiro_sel
                    ? cena_menta
                    : (cena_roteiro_i mod 2 == 0
                        ? cena_lilas
                        : make_color_rgb(216, 232, 248)));
                draw_roundrect(
                    cena_roteiro_x1,
                    cena_roteiro_y1,
                    cena_roteiro_x2,
                    cena_roteiro_y2,
                    false
                );
                draw_set_alpha(cena_roteiro_sel ? 0.92 : 0.48);
                draw_set_color(cena_borda);
                draw_roundrect(
                    cena_roteiro_x1,
                    cena_roteiro_y1,
                    cena_roteiro_x2,
                    cena_roteiro_y2,
                    true
                );

                if (cena_roteiro_sel) {
                    draw_set_alpha(0.82);
                    draw_set_color(cena_rosa);
                    draw_roundrect(cena_roteiro_x1 + 8, cena_roteiro_y1 + 7,
                        cena_roteiro_x1 + 15, cena_roteiro_y2 - 7, false);
                }

                draw_set_alpha(0.94);
                draw_set_color(cena_roteiro_sel ? cena_rosa : c_white);
                draw_circle(cena_roteiro_x1 + 36,
                    (cena_roteiro_y1 + cena_roteiro_y2) * 0.5, 13, false);
                draw_set_alpha(0.72);
                draw_set_color(cena_borda);
                draw_circle(cena_roteiro_x1 + 36,
                    (cena_roteiro_y1 + cena_roteiro_y2) * 0.5, 13, true);

                draw_set_alpha(1);
                draw_set_color(cena_tinta);
                draw_set_halign(fa_center);
                draw_set_valign(fa_middle);
                draw_text_transformed(cena_roteiro_x1 + 36,
                    (cena_roteiro_y1 + cena_roteiro_y2) * 0.5,
                    string(cena_roteiro_i + 1), 0.72, 0.72, 0);

                draw_set_halign(fa_left);
                draw_text_transformed(cena_roteiro_x1 + 64,
                    (cena_roteiro_y1 + cena_roteiro_y2) * 0.5,
                    cena_roteiro_opcoes[cena_roteiro_i],
                    cena_roteiro_mobile ? 0.94 : 0.82,
                    cena_roteiro_mobile ? 0.94 : 0.82,
                    0);
            }

            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_alpha(0.76);
            draw_set_color(cena_tinta_suave);
            var cena_instrucao_roteiro = variable_global_exists("mobile_mode")
                && global.mobile_mode
                    ? "Toque na resposta desejada"
                    : "Setas / WASD escolher   ·   Espaço confirmar";
            draw_text_transformed(640, 766, cena_instrucao_roteiro, 0.62, 0.62, 0);
        }
        else {
            var cena_fala_atual = encontro_roteiro_linhas[encontro_roteiro_indice];
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
            draw_set_color(cena_fala_atual.nome == "Narração"
                ? cena_tinta_suave
                : cena_tinta);
            draw_text_ext_transformed(
                104,
                579,
                cena_fala_atual.texto,
                39,
                1000,
                1.16,
                1.16,
                0
            );
            draw_set_halign(fa_right);
            draw_set_valign(fa_middle);
            draw_set_color(cena_tinta_suave);
            draw_text_transformed(1164, 746, "ESPAÇO   -   continuar", 0.72, 0.72, 0);
        }
    }
    else if (batalha_fase == -3) {
        if (batalha_conversa_etapa == 1) {
            draw_set_halign(fa_left);
            draw_set_color(cena_tinta);
            var cena_conversa_mobile = variable_global_exists("mobile_mode")
                && global.mobile_mode;
            draw_text_transformed(
                cena_conversa_mobile ? 88 : 100,
                cena_conversa_mobile ? 476 : 572,
                batalha_conversa_visitou_pergunta
                    ? "O que Kiran responde agora?"
                    : "Como Kiran responde?",
                1.08,
                1.08,
                0
            );

            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);

            for (var cena_op_i = 0; cena_op_i < 3; cena_op_i++) {
                var cena_op_x1 = cena_conversa_mobile
                    ? 88
                    : 82 + cena_op_i * 376;
                var cena_op_x2 = cena_conversa_mobile
                    ? 1192
                    : cena_op_x1 + 350;
                var cena_op_y1 = cena_conversa_mobile
                    ? 510 + cena_op_i * 78
                    : 650;
                var cena_op_y2 = cena_conversa_mobile
                    ? cena_op_y1 + 72
                    : 718;
                var cena_op_sel = batalha_conversa_opcao == cena_op_i;

                if (cena_op_sel) {
                    draw_set_alpha(global.config_baixo_estimulo ? 0.16 : 0.27);
                    draw_set_color(cena_rosa);
                    draw_roundrect(cena_op_x1 - 7, cena_op_y1 - 7,
                        cena_op_x2 + 7, cena_op_y2 + 7, false);
                }

                draw_set_alpha(1);
                draw_set_color(cena_op_sel ? cena_noite : cena_papel_frio);
                draw_roundrect(cena_op_x1, cena_op_y1, cena_op_x2, cena_op_y2, false);
                draw_set_alpha(cena_op_sel ? 1 : 0.72);
                draw_set_color(cena_op_sel ? make_color_rgb(246, 165, 207) : cena_borda);
                draw_roundrect(cena_op_x1, cena_op_y1, cena_op_x2, cena_op_y2, true);
                draw_set_alpha(1);
                draw_set_color(cena_op_sel ? c_white : cena_tinta);
                // As três respostas são curtas. Desenhar uma linha no centro
                // evita o deslocamento vertical de draw_text_ext.
                var cena_op_texto = opcoes_conversa_inimigos[
                    batalha_inimigo
                ][cena_op_i];
                var cena_op_escala = clamp(
                    (cena_conversa_mobile ? 980 : 296)
                        / max(1, string_width(cena_op_texto)),
                    cena_conversa_mobile ? 0.94 : 0.64,
                    cena_conversa_mobile ? 1.08 : 0.88
                );
                draw_text_transformed(
                    (cena_op_x1 + cena_op_x2) * 0.5,
                    (cena_op_y1 + cena_op_y2) * 0.5,
                    cena_op_texto,
                    cena_op_escala,
                    cena_op_escala,
                    0
                );

                if (cena_op_sel) {
                    draw_set_halign(fa_left);
                    draw_text_transformed(
                        cena_op_x1 + 18,
                        (cena_op_y1 + cena_op_y2) * 0.5,
                        ">",
                        0.88,
                        0.88,
                        0
                    );
                    draw_set_halign(fa_center);
                }
            }

            draw_set_alpha(0.76);
            draw_set_color(cena_tinta_suave);
            draw_text_transformed(
                640,
                751,
                cena_conversa_mobile
                    ? "Toque na resposta desejada"
                    : "A / D escolher   -   Espaco confirmar   -   Esc sair",
                0.66,
                0.66,
                0
            );
        }
        else {
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
            draw_set_color(cena_tinta);
            draw_text_ext_transformed(104, 579, batalha_mensagem, 42, 1000, 1.28, 1.28, 0);
            draw_set_halign(fa_right);
            draw_set_valign(fa_middle);
            draw_set_color(cena_tinta_suave);
            draw_text_transformed(1164, 746, "ESPACO   -   continuar", 0.72, 0.72, 0);
        }
    }
    else if (batalha_fase == -5) {
        var cena_troca_curativos = global.inventario_itens_curativos(false);
        var cena_troca_total = array_length(cena_troca_curativos);

        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(cena_tinta);
        draw_text_ext_transformed(
            104,
            574,
            "Escolha uma cura para oferecer. O item será entregue, mas ninguém precisará lutar.",
            34,
            480,
            0.88,
            0.88,
            0
        );

        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        for (var cena_troca_i = 0; cena_troca_i < cena_troca_total; cena_troca_i++) {
            var cena_troca_item = cena_troca_curativos[cena_troca_i];
            var cena_troca_y1 = 558 + cena_troca_i * 58;
            var cena_troca_y2 = cena_troca_y1 + 48;
            var cena_troca_sel = batalha_troca_item_opcao == cena_troca_i;

            draw_set_alpha(cena_troca_sel ? 0.98 : 0.82);
            draw_set_color(cena_troca_sel ? cena_menta : cena_papel_frio);
            draw_roundrect(650, cena_troca_y1, 1168, cena_troca_y2, false);
            draw_set_alpha(cena_troca_sel ? 0.94 : 0.54);
            draw_set_color(cena_borda);
            draw_roundrect(650, cena_troca_y1, 1168, cena_troca_y2, true);

            var cena_troca_sprite = variable_struct_exists(cena_troca_item, "sprite_item")
                ? cena_troca_item.sprite_item
                : -1;
            if (cena_troca_sprite != -1 && sprite_exists(cena_troca_sprite)) {
                var troca_bbox_l = sprite_get_bbox_left(cena_troca_sprite);
                var troca_bbox_r = sprite_get_bbox_right(cena_troca_sprite);
                var troca_bbox_t = sprite_get_bbox_top(cena_troca_sprite);
                var troca_bbox_b = sprite_get_bbox_bottom(cena_troca_sprite);
                var troca_bbox_w = max(1, troca_bbox_r - troca_bbox_l + 1);
                var troca_bbox_h = max(1, troca_bbox_b - troca_bbox_t + 1);
                var troca_sprite_escala = min(34 / troca_bbox_w, 34 / troca_bbox_h);
                var troca_sprite_x = 680
                    + (sprite_get_xoffset(cena_troca_sprite)
                        - (troca_bbox_l + troca_bbox_r) * 0.5)
                    * troca_sprite_escala;
                var troca_sprite_y = (cena_troca_y1 + cena_troca_y2) * 0.5
                    + (sprite_get_yoffset(cena_troca_sprite)
                        - (troca_bbox_t + troca_bbox_b) * 0.5)
                    * troca_sprite_escala;
                draw_set_alpha(1);
                draw_sprite_ext(
                    cena_troca_sprite,
                    0,
                    troca_sprite_x,
                    troca_sprite_y,
                    troca_sprite_escala,
                    troca_sprite_escala,
                    0,
                    c_white,
                    1
                );
            }

            draw_set_alpha(1);
            draw_set_color(cena_tinta);
            draw_text_transformed(
                712,
                (cena_troca_y1 + cena_troca_y2) * 0.5,
                (cena_troca_sel ? ">  " : "") + cena_troca_item.nome,
                0.76,
                0.76,
                0
            );
            draw_set_halign(fa_right);
            draw_text_transformed(
                1142,
                (cena_troca_y1 + cena_troca_y2) * 0.5,
                "x" + string(cena_troca_item.quantidade)
                    + "   Cura " + string(cena_troca_item.cura),
                0.62,
                0.62,
                0
            );
            draw_set_halign(fa_left);
        }

        draw_set_halign(fa_center);
        draw_set_alpha(0.72);
        draw_set_color(cena_tinta_suave);
        draw_text_transformed(
            909,
            748,
            "Setas escolher  ·  Espaço oferecer  ·  Esc voltar",
            0.56,
            0.56,
            0
        );
    }
    else if (batalha_fase == -1) {
        var cena_neutro_puro = global.rota_neutra_pura();
        var cena_curativos_total = array_length(
            global.inventario_itens_curativos(false)
        );
        var cena_duelo_total = cena_neutro_puro ? 3 : 2;
        var cena_duelo_inicio_y = cena_duelo_total == 3 ? 548 : 590;

        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(cena_tinta);
        draw_text_ext_transformed(104, 576, batalha_mensagem, 39, 540, 1.05, 1.05, 0);
        draw_set_color(cena_tinta_suave);
        draw_text_transformed(
            104,
            704,
            cena_neutro_puro ? "Como resolver este encontro?" : "Aceitar este duelo?",
            0.88,
            0.88,
            0
        );

        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        for (var cena_duelo_i = 0; cena_duelo_i < cena_duelo_total; cena_duelo_i++) {
            var cena_duelo_y1 = cena_duelo_inicio_y + cena_duelo_i * 62;
            var cena_duelo_y2 = cena_duelo_y1 + 50;
            var cena_duelo_sel = batalha_opcao_confronto == cena_duelo_i;
            var cena_duelo_bloqueado = cena_duelo_i == 0 && !cena_tem_arma;
            if (cena_neutro_puro && cena_duelo_i == 1 && cena_curativos_total <= 0) {
                cena_duelo_bloqueado = true;
            }

            var cena_duelo_texto = "Lutar";
            if (cena_neutro_puro && cena_duelo_i == 1) {
                cena_duelo_texto = cena_curativos_total > 0
                    ? "Oferecer item de cura"
                    : "Sem item de cura";
            }
            else if (
                (!cena_neutro_puro && cena_duelo_i == 1)
                || (cena_neutro_puro && cena_duelo_i == 2)
            ) {
                cena_duelo_texto = "Ir embora";
            }

            if (cena_duelo_sel) {
                draw_set_alpha(global.config_baixo_estimulo ? 0.16 : 0.27);
                draw_set_color(cena_rosa);
                draw_roundrect(727, cena_duelo_y1 - 7, 1173, cena_duelo_y2 + 7, false);
            }

            draw_set_alpha(1);
            draw_set_color(cena_duelo_sel ? cena_noite : cena_papel_frio);
            draw_roundrect(734, cena_duelo_y1, 1166, cena_duelo_y2, false);
            draw_set_alpha(cena_duelo_sel ? 1 : 0.72);
            draw_set_color(cena_duelo_sel ? make_color_rgb(246, 165, 207) : cena_borda);
            draw_roundrect(734, cena_duelo_y1, 1166, cena_duelo_y2, true);
            draw_set_alpha(cena_duelo_bloqueado ? 0.42 : 1);
            draw_set_color(cena_duelo_sel ? c_white : cena_tinta);
            draw_text_transformed(
                950,
                (cena_duelo_y1 + cena_duelo_y2) * 0.5,
                (cena_duelo_sel ? ">  " : "")
                    + cena_duelo_texto,
                0.90,
                0.90,
                0
            );
        }
    }
    else {
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(cena_tinta);
        draw_text_ext_transformed(104, 579, batalha_mensagem, 42, 1000, 1.28, 1.28, 0);
        draw_set_halign(fa_right);
        draw_set_valign(fa_middle);
        draw_set_color(cena_tinta_suave);
        draw_text_transformed(1164, 746, "ESPACO   -   voltar ao jogo", 0.72, 0.72, 0);
    }

    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(-1);
}


// Versão antiga mantida apenas como referência durante a transição.
if (tela_pause == 5 && (batalha_fase == -1 || batalha_fase == -2) && false) {
    var con_texto = alto_contraste
        ? make_color_rgb(20, 22, 34)
        : make_color_rgb(57, 66, 107);
    var con_borda = alto_contraste
        ? make_color_rgb(48, 38, 86)
        : make_color_rgb(121, 111, 164);
    var con_papel = alto_contraste ? c_white : make_color_rgb(255, 249, 239);
    var con_rosa = make_color_rgb(239, 205, 226);
    var con_lilas = make_color_rgb(220, 212, 244);
    var con_menta = make_color_rgb(198, 237, 220);
    var con_cor_npc = cores_inimigos[batalha_inimigo];
    var con_tem_arma = global.tem_espada_fragmento;

    draw_set_font(fnt_dialogo);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    // Página interna, usando a mesma construção visual do inventário.
    draw_set_alpha(0.14);
    draw_set_color(make_color_rgb(32, 41, 68));
    draw_roundrect(109, 169, 1175, 735, false);
    draw_set_alpha(1);
    draw_set_color(con_papel);
    draw_roundrect(103, 163, 1169, 729, false);
    draw_set_alpha(0.42);
    draw_set_color(con_borda);
    draw_roundrect(103, 163, 1169, 729, true);

    draw_set_alpha(0.18);
    draw_set_color(con_lilas);
    draw_roundrect(132, 188, 506, 588, false);
    draw_set_color(make_color_rgb(205, 228, 245));
    draw_roundrect(530, 188, 1140, 588, false);
    draw_set_alpha(0.30);
    draw_set_color(con_borda);
    draw_roundrect(132, 188, 506, 588, true);
    draw_roundrect(530, 188, 1140, 588, true);

    desenhar_folha_pause(121, 183, global.config_baixo_estimulo ? 0.20 : 0.48);
    desenhar_folha_pause(1151, 183, global.config_baixo_estimulo ? 0.20 : 0.48);

    draw_set_alpha(0.90);
    draw_set_color(con_rosa);
    draw_roundrect(430, 95, 850, 151, false);
    draw_set_alpha(0.48);
    draw_set_color(con_borda);
    draw_roundrect(430, 95, 850, 151, true);
    draw_set_alpha(1);
    draw_set_color(con_texto);
    draw_text_transformed(640, 123, "Confronto", 1.40, 1.40, 0);

    // Retrato provisório do adversário na página esquerda.
    var con_npc_x = 319;
    var con_npc_y = 350;
    var con_retrato = sprites_retrato_inimigos[batalha_inimigo];

    if (con_retrato != -1 && sprite_exists(con_retrato)) {
        var con_retrato_w = max(1, sprite_get_width(con_retrato));
        var con_retrato_h = max(1, sprite_get_height(con_retrato));
        var con_retrato_escala = min(245 / con_retrato_w, 245 / con_retrato_h);
        var con_retrato_x = con_npc_x
            + (sprite_get_xoffset(con_retrato) - con_retrato_w * 0.5)
            * con_retrato_escala;
        var con_retrato_y = con_npc_y
            + (sprite_get_yoffset(con_retrato) - con_retrato_h * 0.5)
            * con_retrato_escala;
        draw_set_alpha(0.14);
        draw_set_color(con_cor_npc);
        draw_circle(con_npc_x, con_npc_y, 111, false);
        draw_set_alpha(1);
        draw_sprite_ext(
            con_retrato,
            0,
            con_retrato_x,
            con_retrato_y,
            con_retrato_escala,
            con_retrato_escala,
            0,
            c_white,
            1
        );
    }
    else {
    draw_set_alpha(0.12);
    draw_set_color(con_cor_npc);
    draw_circle(con_npc_x, con_npc_y, 98, false);
    draw_set_alpha(0.98);
    draw_set_color(make_color_rgb(246, 239, 244));
    draw_circle(con_npc_x, con_npc_y - 41, 31, false);
    draw_set_color(con_cor_npc);
    draw_roundrect(con_npc_x - 33, con_npc_y - 8, con_npc_x + 33, con_npc_y + 77, false);
    draw_set_alpha(0.84);
    draw_set_color(con_borda);
    draw_circle(con_npc_x, con_npc_y - 41, 31, true);
    draw_roundrect(con_npc_x - 33, con_npc_y - 8, con_npc_x + 33, con_npc_y + 77, true);
    draw_line_width(con_npc_x - 32, con_npc_y + 8, con_npc_x - 61, con_npc_y + 52, 8);
    draw_line_width(con_npc_x + 32, con_npc_y + 8, con_npc_x + 61, con_npc_y + 52, 8);
    draw_set_alpha(0.82);
    draw_set_color(con_cor_npc);
    draw_circle(con_npc_x - 19, con_npc_y - 62, 18, false);
    draw_circle(con_npc_x + 6, con_npc_y - 69, 20, false);
    draw_circle(con_npc_x + 27, con_npc_y - 57, 15, false);
    }

    // Pequeno brasão da Guarda Real.
    draw_set_alpha(0.94);
    draw_set_color(con_rosa);
    draw_circle(con_npc_x, con_npc_y + 23, 13, false);
    draw_set_color(con_borda);
    draw_triangle(con_npc_x, con_npc_y + 12, con_npc_x - 9, con_npc_y + 29,
        con_npc_x + 9, con_npc_y + 29, true);

    draw_set_alpha(1);
    draw_set_color(con_texto);
    draw_text_transformed(319, 222, nomes_inimigos[batalha_inimigo], 1.08, 1.08, 0);
    draw_set_alpha(0.66);
    draw_text_ext_transformed(319, 492,
        titulos_inimigos[batalha_inimigo], 22, 320, 0.64, 0.64, 0);
    draw_set_alpha(0.88);
    draw_set_color(con_cor_npc);
    draw_roundrect(232, 535, 406, 568, false);
    draw_set_alpha(0.82);
    draw_set_color(con_texto);
    draw_text_transformed(319, 552, dificuldades_inimigos[batalha_inimigo], 0.58, 0.58, 0);

    // Página direita: ordem real e fala de ameaça.
    draw_set_alpha(0.76);
    draw_set_color(con_rosa);
    draw_roundrect(680, 211, 990, 249, false);
    draw_set_alpha(0.90);
    draw_set_color(con_texto);
    draw_text_transformed(835, 230, "GUARDA DA RAINHA", 0.64, 0.64, 0);

    draw_set_alpha(0.92);
    draw_set_color(con_papel);
    draw_roundrect(566, 268, 1104, 449, false);
    draw_set_alpha(0.42);
    draw_set_color(con_borda);
    draw_roundrect(566, 268, 1104, 449, true);
    draw_set_alpha(1);
    draw_set_color(con_texto);
    draw_text_ext_transformed(835, 302, "“" + batalha_mensagem + "”", 33, 470, 0.82, 0.82, 0);

    if (batalha_fase == -1) {
        draw_set_alpha(0.90);
        draw_set_color(con_tem_arma ? con_menta : con_lilas);
        draw_roundrect(600, 475, 1070, 529, false);
        draw_set_alpha(0.82);
        draw_set_color(con_texto);
        draw_text_transformed(835, 502,
            con_tem_arma
                ? "Lâmina do Fragmento equipada"
                : "Encontre uma arma antes de aceitar o duelo",
            0.65, 0.65, 0);

        for (var con_i = 0; con_i < 2; con_i++) {
            var con_x1 = 350 + con_i * 310;
            var con_x2 = con_x1 + 270;
            var con_sel = batalha_opcao_confronto == con_i;
            var con_lutar_bloqueado = con_i == 0 && !con_tem_arma;

            draw_set_alpha(con_sel ? 0.98 : 0.66);
            draw_set_color(con_i == 0 ? con_rosa : con_menta);
            draw_roundrect(con_x1, 620, con_x2, 682, false);
            draw_set_alpha(con_sel ? 0.96 : 0.50);
            draw_set_color(con_borda);
            draw_roundrect(con_x1, 620, con_x2, 682, true);
            draw_set_alpha(con_lutar_bloqueado ? 0.42 : 1);
            draw_set_color(con_texto);
            draw_text_transformed((con_x1 + con_x2) / 2, 651,
                con_i == 0 ? "Lutar" : "Ir embora", 0.86, 0.86, 0);
        }

        draw_set_alpha(0.62);
        draw_set_color(con_texto);
        draw_text_transformed(640, 716, "Setas escolher  •  Espaço confirmar  •  Esc recuar", 0.58, 0.58, 0);
    }
    else {
        draw_set_alpha(0.94);
        draw_set_color(con_menta);
        draw_roundrect(500, 620, 780, 682, false);
        draw_set_alpha(0.88);
        draw_set_color(con_borda);
        draw_roundrect(500, 620, 780, 682, true);
        draw_set_alpha(1);
        draw_set_color(con_texto);
        draw_text_transformed(640, 651, "Continuar", 0.86, 0.86, 0);
        draw_set_alpha(0.62);
        draw_text_transformed(640, 716, "Espaço confirmar", 0.58, 0.58, 0);
    }
}


// ═════════════════════════════════════════════
// DUELO EM TURNOS CONTRA NPC
// ═════════════════════════════════════════════
if (tela_pause == 5 && batalha_fase >= 0) {
    draw_set_font(fnt_dialogo);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    var pro_tinta = alto_contraste
        ? make_color_rgb(18, 20, 31)
        : make_color_rgb(48, 55, 88);
    var pro_tinta_suave = alto_contraste
        ? make_color_rgb(45, 39, 76)
        : make_color_rgb(82, 88, 124);
    var pro_borda = alto_contraste
        ? make_color_rgb(44, 36, 78)
        : make_color_rgb(86, 89, 132);
    var pro_papel = alto_contraste
        ? c_white
        : make_color_rgb(255, 250, 241);
    var pro_papel_frio = alto_contraste
        ? make_color_rgb(250, 250, 252)
        : make_color_rgb(244, 247, 249);
    var pro_rosa = make_color_rgb(224, 137, 174);
    var pro_rosa_claro = make_color_rgb(246, 210, 226);
    var pro_lilas = make_color_rgb(194, 181, 229);
    var pro_menta = make_color_rgb(145, 211, 178);
    var pro_menta_clara = make_color_rgb(202, 239, 220);
    var pro_azul = make_color_rgb(174, 211, 229);
    var pro_noite = make_color_rgb(28, 39, 65);
    var pro_inimigo = cores_inimigos[batalha_inimigo];
    var pro_feedback_razao = batalha_feedback_timer > 0
        ? batalha_feedback_timer / batalha_feedback_total
        : 0;
    var pro_entrada = batalha_entrada_total > 0
        ? clamp(batalha_entrada_timer / batalha_entrada_total, 0, 1)
        : 0;

    // Cenário noturno exclusivo da batalha.
    draw_set_alpha(1);
    draw_set_color(c_white);
    if (sprite_exists(spr_fundo_batalha)) {
        draw_sprite_stretched(spr_fundo_batalha, 0, 0, 0, 1280, 811);
    }
    else {
        draw_set_color(pro_noite);
        draw_rectangle(0, 0, 1280, 811, false);
    }
    draw_set_alpha(alto_contraste ? 0.20 : 0.07);
    draw_set_color(make_color_rgb(11, 20, 39));
    draw_rectangle(0, 0, 1280, 811, false);

    // Pulso de impacto sem vermelho e sem clarões agressivos.
    if (batalha_feedback_timer > 0 && (batalha_feedback_tipo == -1 || batalha_feedback_tipo == 3)) {
        draw_set_alpha(global.config_baixo_estimulo
            ? 0.025
            : 0.035 + pro_feedback_razao * 0.045);
        draw_set_color(batalha_feedback_tipo == 3 ? pro_menta : pro_rosa);
        draw_rectangle(0, 0, 1280, 811, false);
    }

    // Sombras no chão integram os personagens à ilustração sem esconder o fundo.
    draw_set_alpha(0.22);
    draw_set_color(make_color_rgb(16, 27, 45));
    draw_ellipse(788, 475, 1165, 526, false);
    draw_ellipse(116, 508, 482, 553, false);

    // HUD ilustrado do adversário, com nome e HP personalizados em runtime.
    var pro_hud_inimigo_escala = 0.22;
    var pro_hud_inimigo_x = 770;
    var pro_hud_inimigo_y = 34;
    draw_set_alpha(0.99);
    draw_sprite_ext(
        spr_hud_vida_inimigo,
        0,
        pro_hud_inimigo_x,
        pro_hud_inimigo_y,
        pro_hud_inimigo_escala,
        pro_hud_inimigo_escala,
        0,
        c_white,
        1
    );

    // A folha atingida recebe um pulso rosa-claro antes da camada de perda.
    if (
        batalha_feedback_timer > 0
        && batalha_feedback_alvo == 1
        && (batalha_feedback_tipo == 1 || batalha_feedback_tipo == 2)
    ) {
        var pro_folhas_inimigo_x = [707, 906, 1106, 1303, 1502];
        var pro_folha_inimigo_i = clamp(
            floor(batalha_corrupcao / max(1, batalha_hp_max_inimigo / 5)),
            0,
            4
        );
        var pro_folha_inimigo_x = pro_hud_inimigo_x
            + pro_folhas_inimigo_x[pro_folha_inimigo_i] * pro_hud_inimigo_escala;
        var pro_folha_inimigo_y = pro_hud_inimigo_y
            + 392 * pro_hud_inimigo_escala;
        var pro_pulso_folha = sin((1 - pro_feedback_razao) * pi);
        draw_set_alpha(0.13 + pro_pulso_folha * 0.20);
        draw_set_color(pro_rosa_claro);
        draw_circle(pro_folha_inimigo_x, pro_folha_inimigo_y,
            24 + pro_pulso_folha * 5, false);
        draw_set_alpha(0.72);
        draw_set_color(c_white);
        draw_circle(pro_folha_inimigo_x, pro_folha_inimigo_y,
            20 + pro_pulso_folha * 4, true);
    }

    desenhar_estado_hud_inimigo(
        pro_hud_inimigo_x,
        pro_hud_inimigo_y,
        pro_hud_inimigo_escala,
        batalha_corrupcao,
        batalha_hp_max_inimigo
    );

    var pro_nome_inimigo_x = pro_hud_inimigo_x + 382 * pro_hud_inimigo_escala;
    var pro_nome_inimigo_y = pro_hud_inimigo_y + 267 * pro_hud_inimigo_escala;
    draw_set_halign(fa_center);
    draw_set_alpha(1);
    draw_set_color(pro_tinta);
    desenhar_texto_grosso(
        pro_nome_inimigo_x,
        pro_nome_inimigo_y - 5,
        nomes_inimigos[batalha_inimigo],
        0.78,
        0.78,
        pro_tinta
    );
    draw_set_alpha(0.72);
    draw_set_color(pro_tinta_suave);
    desenhar_texto_grosso(
        pro_nome_inimigo_x,
        pro_nome_inimigo_y + 15,
        tipos_inimigos[batalha_inimigo]
            + "  •  " + dificuldades_inimigos[batalha_inimigo],
        0.43,
        0.43,
        pro_tinta_suave
    );

    var pro_numero_inimigo_x = pro_hud_inimigo_x + 1748 * pro_hud_inimigo_escala;
    var pro_numero_inimigo_y = pro_hud_inimigo_y + 364 * pro_hud_inimigo_escala;
    draw_set_alpha(0.99);
    draw_set_color(make_color_rgb(247, 242, 233));
    draw_roundrect(
        pro_numero_inimigo_x - 76,
        pro_numero_inimigo_y - 18,
        pro_numero_inimigo_x + 76,
        pro_numero_inimigo_y + 18,
        false
    );
    draw_set_alpha(0.72);
    draw_set_color(pro_borda);
    draw_roundrect(
        pro_numero_inimigo_x - 76,
        pro_numero_inimigo_y - 18,
        pro_numero_inimigo_x + 76,
        pro_numero_inimigo_y + 18,
        true
    );
    draw_set_alpha(1);
    var pro_numero_inimigo_cor = batalha_corrupcao <= batalha_hp_max_inimigo * 0.28
        ? pro_rosa
        : pro_tinta;
    desenhar_texto_grosso(
        pro_numero_inimigo_x,
        pro_numero_inimigo_y,
        string(ceil(batalha_corrupcao))
            + " / " + string(batalha_hp_max_inimigo),
        0.64,
        0.64,
        pro_numero_inimigo_cor
    );

    draw_set_halign(fa_left);
    draw_set_alpha(0.68);
    draw_set_color(pro_tinta_suave);
    draw_text_transformed(
        800,
        204,
        "Fraco a " + fraquezas_inimigos[batalha_inimigo]
            + (batalha_elite_desperto ? "  •  Fase 2" : ""),
        0.44,
        0.44,
        0
    );

    if (batalha_status_inimigo != "") {
        draw_set_halign(fa_center);
        draw_set_alpha(0.90);
        draw_set_color(pro_menta_clara);
        draw_roundrect(800, 220, 1082, 250, false);
        draw_set_alpha(0.52);
        draw_set_color(pro_borda);
        draw_roundrect(800, 220, 1082, 250, true);
        draw_set_alpha(0.84);
        draw_set_color(pro_tinta);
        draw_text_transformed(941, 235, batalha_status_inimigo, 0.46, 0.46, 0);
    }

    // Adversário: sprite futuro ou silhueta provisória com encaixe automático.
    var pro_enemy_sprite = sprites_batalha_inimigos[batalha_inimigo];
    if (
        batalha_animacao_ataque_inimigo > 0
        && sprites_ataque_inimigos[batalha_inimigo] != -1
        && sprite_exists(sprites_ataque_inimigos[batalha_inimigo])
    ) {
        pro_enemy_sprite = sprites_ataque_inimigos[batalha_inimigo];
    }
    var pro_enemy_x = 963 + offsets_batalha_inimigos_x[batalha_inimigo]
        + pro_entrada * 110;
    var pro_enemy_y = 525 + offsets_batalha_inimigos_y[batalha_inimigo];
    var pro_enemy_shake = global.config_reduzir_animacoes
        ? 0
        : sin(batalha_feedback_timer * 1.7) * 10 * batalha_impacto_inimigo;
    pro_enemy_x += pro_enemy_shake;

    if (pro_enemy_sprite != -1 && sprite_exists(pro_enemy_sprite)) {
        var pro_enemy_w = max(1, sprite_get_width(pro_enemy_sprite));
        var pro_enemy_h = max(1, sprite_get_height(pro_enemy_sprite));
        var pro_enemy_scale = min(215 / pro_enemy_w, 200 / pro_enemy_h)
            * escalas_batalha_inimigos[batalha_inimigo];
        var pro_enemy_draw_x = pro_enemy_x
            + (sprite_get_xoffset(pro_enemy_sprite) - pro_enemy_w * 0.5)
            * pro_enemy_scale;
        var pro_enemy_draw_y = pro_enemy_y
            + (sprite_get_yoffset(pro_enemy_sprite) - pro_enemy_h)
            * pro_enemy_scale;
        var pro_enemy_frames = max(1, sprite_get_number(pro_enemy_sprite));
        var pro_enemy_frame = floor(tempo_pause * 8) mod pro_enemy_frames;
        if (
            batalha_animacao_ataque_inimigo > 0
            && pro_enemy_sprite == sprites_ataque_inimigos[batalha_inimigo]
        ) {
            var pro_enemy_ataque_total = global.config_reduzir_animacoes ? 10 : 28;
            var pro_enemy_ataque_progresso = clamp(
                1 - batalha_animacao_ataque_inimigo / pro_enemy_ataque_total,
                0,
                1
            );
            pro_enemy_frame = clamp(
                floor(pro_enemy_ataque_progresso * pro_enemy_frames),
                0,
                pro_enemy_frames - 1
            );
        }
        draw_set_alpha(1);
        draw_sprite_ext(
            pro_enemy_sprite,
            pro_enemy_frame,
            pro_enemy_draw_x,
            pro_enemy_draw_y,
            pro_enemy_scale,
            pro_enemy_scale,
            0,
            c_white,
            1
        );
    }
    else {
        // Placeholder de corpo inteiro: capa, armadura e brasão da Rainha.
        draw_set_alpha(0.15);
        draw_set_color(pro_inimigo);
        draw_circle(pro_enemy_x, pro_enemy_y - 119, 72, false);
        draw_set_alpha(0.98);
        draw_set_color(make_color_rgb(248, 240, 244));
        draw_circle(pro_enemy_x, pro_enemy_y - 159, 34, false);
        draw_set_color(pro_inimigo);
        draw_triangle(pro_enemy_x - 48, pro_enemy_y - 116,
            pro_enemy_x + 48, pro_enemy_y - 116,
            pro_enemy_x, pro_enemy_y - 6, false);
        draw_roundrect(pro_enemy_x - 38, pro_enemy_y - 132,
            pro_enemy_x + 38, pro_enemy_y - 54, false);
        draw_set_alpha(0.84);
        draw_set_color(pro_borda);
        draw_circle(pro_enemy_x, pro_enemy_y - 159, 34, true);
        draw_roundrect(pro_enemy_x - 38, pro_enemy_y - 132,
            pro_enemy_x + 38, pro_enemy_y - 54, true);
        draw_line_width(pro_enemy_x - 34, pro_enemy_y - 105,
            pro_enemy_x - 66, pro_enemy_y - 61, 8);
        draw_line_width(pro_enemy_x + 34, pro_enemy_y - 105,
            pro_enemy_x + 66, pro_enemy_y - 61, 8);
        draw_set_alpha(0.92);
        draw_set_color(pro_rosa);
        draw_circle(pro_enemy_x, pro_enemy_y - 93, 14, false);
        draw_set_color(pro_borda);
        draw_triangle(pro_enemy_x, pro_enemy_y - 106,
            pro_enemy_x - 10, pro_enemy_y - 84,
            pro_enemy_x + 10, pro_enemy_y - 84, true);
        draw_set_alpha(0.68);
        draw_set_color(pro_tinta_suave);
        draw_text_transformed(pro_enemy_x, pro_enemy_y + 18,
            "SPRITE DO GUARDA", 0.48, 0.48, 0);
    }

    // Kiran no primeiro plano à esquerda.
    var pro_kiran_sprite = sprite_batalha_kiran;
    var pro_kiran_usando_ataque =
        batalha_animacao_ataque_kiran > 0
        && sprite_ataque_kiran != -1
        && sprite_exists(sprite_ataque_kiran);
    if (pro_kiran_usando_ataque) {
        pro_kiran_sprite = sprite_ataque_kiran;
    }
    if (pro_kiran_sprite == -1 || !sprite_exists(pro_kiran_sprite)) {
        pro_kiran_sprite = spr_kiran_idle;
    }
    var pro_kiran_x = 294 - pro_entrada * 90;
    var pro_kiran_y = 548;
    var pro_kiran_shake = global.config_reduzir_animacoes
        ? 0
        : sin(batalha_feedback_timer * 1.8) * 9 * batalha_impacto_kiran;
    pro_kiran_x += pro_kiran_shake;

    if (pro_kiran_sprite != -1 && sprite_exists(pro_kiran_sprite)) {
        var pro_kiran_w = max(1, sprite_get_width(pro_kiran_sprite));
        var pro_kiran_h = max(1, sprite_get_height(pro_kiran_sprite));
        var pro_kiran_scale = min(250 / pro_kiran_w, 210 / pro_kiran_h);
        var pro_kiran_draw_x = pro_kiran_x
            + (sprite_get_xoffset(pro_kiran_sprite) - pro_kiran_w * 0.5)
            * pro_kiran_scale;
        var pro_kiran_draw_y = pro_kiran_y
            + (sprite_get_yoffset(pro_kiran_sprite) - pro_kiran_h)
            * pro_kiran_scale;
        var pro_kiran_frames = max(1, sprite_get_number(pro_kiran_sprite));
        var pro_kiran_frame = 0;
        if (pro_kiran_usando_ataque) {
            var pro_kiran_ataque_total = global.config_reduzir_animacoes ? 10 : 28;
            var pro_kiran_ataque_progresso = clamp(
                1 - batalha_animacao_ataque_kiran / pro_kiran_ataque_total,
                0,
                1
            );
            pro_kiran_frame = clamp(
                floor(pro_kiran_ataque_progresso * pro_kiran_frames),
                0,
                pro_kiran_frames - 1
            );
        }
        draw_set_alpha(1);
        draw_sprite_ext(
            pro_kiran_sprite,
            pro_kiran_frame,
            pro_kiran_draw_x,
            pro_kiran_draw_y,
            pro_kiran_scale,
            pro_kiran_scale,
            0,
            c_white,
            1
        );
    }

    // A lâmina provisória só é necessária se nenhuma das artes com espada
    // estiver ativa. spr_kiran_sword e spr_ataque_kiran já incluem a arma.
    var pro_kiran_sprite_tem_espada = pro_kiran_sprite == spr_kiran_sword
        || pro_kiran_usando_ataque;
    if (!pro_kiran_sprite_tem_espada) {
        draw_set_alpha(0.92);
        draw_set_color(pro_borda);
        draw_line_width(pro_kiran_x + 64, pro_kiran_y - 23,
            pro_kiran_x + 105, pro_kiran_y - 116, 8);
        draw_set_color(pro_azul);
        draw_triangle(pro_kiran_x + 105, pro_kiran_y - 116,
            pro_kiran_x + 91, pro_kiran_y - 76,
            pro_kiran_x + 117, pro_kiran_y - 70, false);
        draw_set_color(pro_borda);
        draw_line_width(pro_kiran_x + 52, pro_kiran_y - 45,
            pro_kiran_x + 84, pro_kiran_y - 31, 5);
    }

    // Ficha geométrica antiga de Kiran (substituída pela arte final abaixo).
    if (false) {
    draw_set_alpha(0.18);
    draw_set_color(pro_noite);
    draw_roundrect(728, 373, 1195, 521, false);
    draw_set_alpha(0.97);
    draw_set_color(pro_papel);
    draw_roundrect(722, 367, 1189, 515, false);
    draw_set_alpha(0.64);
    draw_set_color(pro_borda);
    draw_roundrect(722, 367, 1189, 515, true);
    draw_set_halign(fa_left);
    draw_set_alpha(1);
    draw_set_color(pro_tinta);
    draw_text_transformed(746, 392, "Kiran", 0.88, 0.88, 0);
    draw_set_alpha(0.72);
    draw_set_color(pro_tinta_suave);
    draw_text_transformed(746, 420, "Lâmina do Fragmento", 0.53, 0.53, 0);

    draw_set_halign(fa_right);
    draw_set_alpha(0.76);
    draw_text_transformed(1165, 397,
        "HP " + string(ceil(batalha_serenidade)) + " / " + string(global.vida_kiran_max),
        0.58, 0.58, 0);
    draw_text_transformed(1165, 421,
        "Energia " + string(batalha_energia) + " / " + string(batalha_energia_max),
        0.52, 0.52, 0);

    // As mesmas cinco folhas de vitral aparecem dentro do combate.
    for (var pro_folha_i = 0; pro_folha_i < 5; pro_folha_i++) {
        var pro_folha_nivel = clamp((batalha_serenidade - pro_folha_i * 20) / 20, 0, 1);
        var pro_folha_alvo = batalha_feedback_tipo == -1
            ? clamp(floor(batalha_serenidade / 20), 0, 4)
            : clamp(ceil(batalha_serenidade / 20) - 1, 0, 4);
        var pro_folha_pulso = pro_folha_i == pro_folha_alvo
            && batalha_feedback_alvo == 0
            ? (batalha_feedback_tipo == -1 ? -pro_feedback_razao : pro_feedback_razao)
            : 0;
        desenhar_folha_vitral(
            775 + pro_folha_i * 64,
            468,
            pro_folha_nivel,
            0.72,
            pro_folha_pulso
        );
    }

    // Pontos de energia como pequenas gemas, legíveis sem texto adicional.
    for (var pro_energia_i = 0; pro_energia_i < batalha_energia_max; pro_energia_i++) {
        draw_set_alpha(pro_energia_i < batalha_energia ? 0.92 : 0.24);
        draw_set_color(pro_energia_i < batalha_energia ? pro_azul : pro_tinta_suave);
        draw_circle(1035 + pro_energia_i * 17, 468, 5, false);
    }
    }

    // Vida de Kiran no alto à esquerda; o adversário ocupa o lado oposto.
    var pro_hud_escala = 0.20;
    var pro_hud_x = 30;
    var pro_hud_y = 34;
    draw_set_alpha(0.99);
    draw_sprite_ext(spr_hud_vida, 0, pro_hud_x, pro_hud_y,
        pro_hud_escala, pro_hud_escala, 0, c_white, 1);

    if (
        batalha_feedback_timer > 0
        && batalha_feedback_alvo == 0
        && (batalha_feedback_tipo == -1 || batalha_feedback_tipo == 3)
    ) {
        var pro_folhas_kiran_x = [643, 859, 1076, 1286, 1492];
        var pro_folha_kiran_i = clamp(
            floor(batalha_serenidade / max(1, global.vida_kiran_max / 5)),
            0,
            4
        );
        var pro_folha_kiran_x = pro_hud_x
            + pro_folhas_kiran_x[pro_folha_kiran_i] * pro_hud_escala;
        var pro_folha_kiran_y = pro_hud_y + 469 * pro_hud_escala;
        var pro_folha_kiran_cor = batalha_feedback_tipo == 3
            ? pro_menta_clara
            : pro_rosa_claro;
        var pro_pulso_kiran = sin((1 - pro_feedback_razao) * pi);
        draw_set_alpha(0.13 + pro_pulso_kiran * 0.20);
        draw_set_color(pro_folha_kiran_cor);
        draw_circle(pro_folha_kiran_x, pro_folha_kiran_y,
            24 + pro_pulso_kiran * 5, false);
        draw_set_alpha(0.72);
        draw_set_color(c_white);
        draw_circle(pro_folha_kiran_x, pro_folha_kiran_y,
            20 + pro_pulso_kiran * 4, true);
    }

    desenhar_estado_hud_ilustrado(
        pro_hud_x,
        pro_hud_y,
        pro_hud_escala,
        batalha_serenidade,
        global.vida_kiran_max
    );
    draw_set_alpha(0.99);
    draw_set_color(make_color_rgb(247, 242, 233));
    var pro_hud_numero_x = pro_hud_x + 1713 * pro_hud_escala;
    var pro_hud_numero_y = pro_hud_y + 313 * pro_hud_escala;
    draw_roundrect(
        pro_hud_numero_x - 76,
        pro_hud_numero_y - 18,
        pro_hud_numero_x + 76,
        pro_hud_numero_y + 18,
        false
    );
    draw_set_alpha(0.72);
    draw_set_color(pro_borda);
    draw_roundrect(
        pro_hud_numero_x - 76,
        pro_hud_numero_y - 18,
        pro_hud_numero_x + 76,
        pro_hud_numero_y + 18,
        true
    );
    draw_set_alpha(1);
    draw_set_halign(fa_center);
    desenhar_texto_grosso(pro_hud_numero_x, pro_hud_numero_y,
        string(ceil(batalha_serenidade)) + " / " + string(global.vida_kiran_max),
        0.64, 0.64, pro_tinta);
    // Medidor ilustrado de energia. Centralizamos pela área realmente visível
    // porque os arquivos possuem margens transparentes e origens diferentes.
    var pro_energia_valor = clamp(floor(batalha_energia), 0, 8);

    // Resolver pelo nome impede que uma alteração na ordem/ID dos assets feita
    // pelo editor associe, por exemplo, energia 6 ao desenho de outro valor.
    var pro_energia_nome = "spr_energia_"
        + string(pro_energia_valor)
        + "_8";
    var pro_energia_sprite = asset_get_index(pro_energia_nome);

    // Compatibilidade com projetos antigos enquanto os nove sprites existem.
    if (!sprite_exists(pro_energia_sprite)) {
        pro_energia_sprite = sprites_energia[pro_energia_valor];
    }

    if (sprite_exists(pro_energia_sprite)) {
        var pro_energia_bbox_l = sprite_get_bbox_left(pro_energia_sprite);
        var pro_energia_bbox_r = sprite_get_bbox_right(pro_energia_sprite);
        var pro_energia_bbox_t = sprite_get_bbox_top(pro_energia_sprite);
        var pro_energia_bbox_b = sprite_get_bbox_bottom(pro_energia_sprite);
        var pro_energia_bbox_w = max(1, pro_energia_bbox_r - pro_energia_bbox_l + 1);
        var pro_energia_escala = 190 / pro_energia_bbox_w;
        var pro_energia_centro_x = pro_hud_x + 304;
        var pro_energia_centro_y = pro_hud_y + 137;
        var pro_energia_desenho_x = pro_energia_centro_x
            + (sprite_get_xoffset(pro_energia_sprite)
                - (pro_energia_bbox_l + pro_energia_bbox_r) * 0.5)
            * pro_energia_escala;
        var pro_energia_desenho_y = pro_energia_centro_y
            + (sprite_get_yoffset(pro_energia_sprite)
                - (pro_energia_bbox_t + pro_energia_bbox_b) * 0.5)
            * pro_energia_escala;

        draw_set_alpha(0.98);
        draw_sprite_ext(
            pro_energia_sprite,
            0,
            pro_energia_desenho_x,
            pro_energia_desenho_y,
            pro_energia_escala,
            pro_energia_escala,
            0,
            c_white,
            1
        );
    }

    // Dano/cura em uma plaquinha sólida junto do HUD afetado. Assim o valor
    // não se perde sobre o cenário nem cobre o personagem.
    if (batalha_feedback_timer > 0 && batalha_feedback_valor > 0) {
        var pro_numero_cor = batalha_feedback_tipo == -1
            ? pro_rosa
            : (batalha_feedback_tipo == 3 ? pro_menta : pro_lilas);
        var pro_numero_x = batalha_feedback_alvo == 1
            ? pro_numero_inimigo_x
            : pro_hud_numero_x;
        var pro_numero_y = batalha_feedback_alvo == 1
            ? pro_numero_inimigo_y + 42
            : pro_hud_numero_y + 42;
        var pro_numero_alpha = clamp(pro_feedback_razao * 2.2, 0, 1);

        draw_set_alpha(0.96 * pro_numero_alpha);
        draw_set_color(batalha_feedback_tipo == 3
            ? pro_menta_clara
            : pro_rosa_claro);
        draw_roundrect(pro_numero_x - 43, pro_numero_y - 15,
            pro_numero_x + 43, pro_numero_y + 15, false);
        draw_set_alpha(0.82 * pro_numero_alpha);
        draw_set_color(pro_borda);
        draw_roundrect(pro_numero_x - 43, pro_numero_y - 15,
            pro_numero_x + 43, pro_numero_y + 15, true);
        draw_set_alpha(pro_numero_alpha);
        draw_set_halign(fa_center);
        desenhar_texto_grosso(
            pro_numero_x,
            pro_numero_y,
            (batalha_feedback_tipo == 3 ? "+" : "−")
                + string(batalha_feedback_valor),
            0.72,
            0.72,
            pro_numero_cor
        );
    }

    // Caixa inferior: narrativa à esquerda, comandos à direita.
    draw_set_alpha(0.22);
    draw_set_color(pro_noite);
    draw_roundrect(45, 574, 1247, 790, false);
    draw_set_alpha(0.98);
    draw_set_color(pro_papel);
    draw_roundrect(38, 567, 1240, 783, false);
    draw_set_alpha(0.70);
    draw_set_color(pro_borda);
    draw_roundrect(38, 567, 1240, 783, true);
    draw_line(704, 581, 704, 769);

    draw_set_alpha(0.92);
    draw_set_color(pro_rosa_claro);
    draw_roundrect(72, 585, 202, 615, false);
    draw_set_color(pro_tinta);
    draw_set_halign(fa_center);
    draw_text_transformed(137, 600, "TURNO " + string(batalha_rodada), 0.52, 0.52, 0);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
    draw_set_color(pro_tinta);
    draw_text_ext_transformed(76, 626, batalha_mensagem, 31, 592, 1.03, 1.03, 0);
    draw_set_valign(fa_middle);

    if (batalha_fase == 0 && batalha_menu == 0) {
        var pro_tem_item = array_length(global.inventario_itens_curativos(true)) > 0;
        var pro_acoes_sprites = [
            spr_opcao_atacar,
            spr_opcao_tecnicas,
            pro_tem_item ? spr_opcao_itens : spr_opcao_naotemitens,
            spr_opcao_defender
        ];

        for (var pro_acao_i = 0; pro_acao_i < 4; pro_acao_i++) {
            var pro_acao_col = pro_acao_i mod 2;
            var pro_acao_lin = floor(pro_acao_i / 2);
            var pro_acao_x1 = 728 + pro_acao_col * 246;
            var pro_acao_y1 = 592 + pro_acao_lin * 72;
            var pro_acao_x2 = pro_acao_x1 + 232;
            var pro_acao_y2 = pro_acao_y1 + 60;
            var pro_acao_sel = batalha_acao_opcao == pro_acao_i;
            var pro_acao_disponivel = pro_acao_i != 2 || pro_tem_item;
            var pro_acao_sprite = pro_acoes_sprites[pro_acao_i];
            var pro_acao_cx = (pro_acao_x1 + pro_acao_x2) * 0.5;
            var pro_acao_cy = (pro_acao_y1 + pro_acao_y2) * 0.5;

            if (pro_acao_sel) {
                var pro_acao_brilho = global.config_baixo_estimulo
                    ? 0.18
                    : 0.22 + sin(tempo_pause * 2.2) * 0.04;
                draw_set_alpha(pro_acao_brilho);
                draw_set_color(c_white);
                draw_roundrect(pro_acao_x1 - 7, pro_acao_y1 - 6,
                    pro_acao_x2 + 7, pro_acao_y2 + 6, false);
                draw_set_alpha(0.82);
                draw_set_color(pro_rosa);
                draw_roundrect(pro_acao_x1 - 5, pro_acao_y1 - 4,
                    pro_acao_x2 + 5, pro_acao_y2 + 4, true);

                // Losango lateral: indicação inequívoca sem cobrir a arte.
                var pro_acao_losango_x = pro_acao_x1 - 12;
                draw_set_alpha(1);
                draw_set_color(c_white);
                draw_triangle(pro_acao_losango_x, pro_acao_cy - 8,
                    pro_acao_losango_x + 8, pro_acao_cy,
                    pro_acao_losango_x, pro_acao_cy + 8, false);
                draw_triangle(pro_acao_losango_x, pro_acao_cy - 8,
                    pro_acao_losango_x - 8, pro_acao_cy,
                    pro_acao_losango_x, pro_acao_cy + 8, false);
                draw_set_color(pro_rosa);
                draw_circle(pro_acao_losango_x, pro_acao_cy, 3, false);
            }

            var pro_acao_bbox_l = sprite_get_bbox_left(pro_acao_sprite);
            var pro_acao_bbox_r = sprite_get_bbox_right(pro_acao_sprite);
            var pro_acao_bbox_t = sprite_get_bbox_top(pro_acao_sprite);
            var pro_acao_bbox_b = sprite_get_bbox_bottom(pro_acao_sprite);
            var pro_acao_bbox_w = max(1, pro_acao_bbox_r - pro_acao_bbox_l + 1);
            var pro_acao_escala = 232 / pro_acao_bbox_w
                * (pro_acao_sel ? 1.04 : 1);
            var pro_acao_draw_x = pro_acao_cx
                + (sprite_get_xoffset(pro_acao_sprite)
                    - (pro_acao_bbox_l + pro_acao_bbox_r) * 0.5)
                * pro_acao_escala;
            var pro_acao_draw_y = pro_acao_cy
                + (sprite_get_yoffset(pro_acao_sprite)
                    - (pro_acao_bbox_t + pro_acao_bbox_b) * 0.5)
                * pro_acao_escala;

            draw_set_alpha(pro_acao_sel ? 1 : (pro_acao_disponivel ? 0.90 : 0.72));
            draw_sprite_ext(
                pro_acao_sprite,
                0,
                pro_acao_draw_x,
                pro_acao_draw_y,
                pro_acao_escala,
                pro_acao_escala,
                0,
                c_white,
                1
            );
        }

        draw_set_alpha(0.60);
        draw_set_color(pro_tinta_suave);
        draw_text_transformed(967, 760, "Setas escolher  •  Espaço confirmar  •  Esc fugir", 0.48, 0.48, 0);
    }
    else if (batalha_fase == 0 && batalha_menu == 1) {
        var pro_tecnica_sprites = [
            spr_laminaverdejante,
            spr_arcolunar,
            spr_estocadacometa
        ];
        draw_set_halign(fa_center);

        for (var pro_tec_i = 0; pro_tec_i < 3; pro_tec_i++) {
            var pro_golpe_i = pro_tec_i + 1;
            var pro_tec_y1 = 578 + pro_tec_i * 62;
            var pro_tec_y2 = pro_tec_y1 + 60;
            var pro_tec_cx = 967;
            var pro_tec_cy = (pro_tec_y1 + pro_tec_y2) * 0.5;
            var pro_tec_sel = batalha_tecnica_opcao == pro_tec_i;
            var pro_tec_ok = batalha_energia >= batalha_custos_golpes[pro_golpe_i];
            var pro_tec_sprite = pro_tecnica_sprites[pro_tec_i];

            if (pro_tec_sel) {
                var pro_tec_brilho = global.config_baixo_estimulo
                    ? 0.18
                    : 0.22 + sin(tempo_pause * 2.2) * 0.04;
                draw_set_alpha(pro_tec_brilho);
                draw_set_color(c_white);
                draw_roundrect(741, pro_tec_y1 - 3, 1193, pro_tec_y2 + 3, false);
                draw_set_alpha(0.84);
                draw_set_color(pro_rosa);
                draw_roundrect(743, pro_tec_y1 - 1, 1191, pro_tec_y2 + 1, true);

                var pro_tec_losango_x = 729;
                draw_set_alpha(1);
                draw_set_color(c_white);
                draw_triangle(pro_tec_losango_x, pro_tec_cy - 8,
                    pro_tec_losango_x + 8, pro_tec_cy,
                    pro_tec_losango_x, pro_tec_cy + 8, false);
                draw_triangle(pro_tec_losango_x, pro_tec_cy - 8,
                    pro_tec_losango_x - 8, pro_tec_cy,
                    pro_tec_losango_x, pro_tec_cy + 8, false);
                draw_set_color(pro_rosa);
                draw_circle(pro_tec_losango_x, pro_tec_cy, 3, false);
            }

            var pro_tec_bbox_l = sprite_get_bbox_left(pro_tec_sprite);
            var pro_tec_bbox_r = sprite_get_bbox_right(pro_tec_sprite);
            var pro_tec_bbox_t = sprite_get_bbox_top(pro_tec_sprite);
            var pro_tec_bbox_b = sprite_get_bbox_bottom(pro_tec_sprite);
            var pro_tec_bbox_w = max(1, pro_tec_bbox_r - pro_tec_bbox_l + 1);
            var pro_tec_escala = 440 / pro_tec_bbox_w
                * (pro_tec_sel ? 1.035 : 1);
            var pro_tec_draw_x = pro_tec_cx
                + (sprite_get_xoffset(pro_tec_sprite)
                    - (pro_tec_bbox_l + pro_tec_bbox_r) * 0.5)
                * pro_tec_escala;
            var pro_tec_draw_y = pro_tec_cy
                + (sprite_get_yoffset(pro_tec_sprite)
                    - (pro_tec_bbox_t + pro_tec_bbox_b) * 0.5)
                * pro_tec_escala;

            draw_set_alpha(pro_tec_sel ? 1 : (pro_tec_ok ? 0.90 : 0.46));
            draw_sprite_ext(
                pro_tec_sprite,
                0,
                pro_tec_draw_x,
                pro_tec_draw_y,
                pro_tec_escala,
                pro_tec_escala,
                0,
                c_white,
                1
            );
        }

        draw_set_halign(fa_center);
        draw_set_alpha(0.52);
        draw_set_color(pro_tinta_suave);
        draw_text_transformed(967, 775, "Espaço usar  •  Esc voltar", 0.39, 0.39, 0);
    }
    else if (batalha_fase == 0 && batalha_menu == 2) {
        var pro_curativos = global.inventario_itens_curativos(true);
        var pro_curativos_total = min(array_length(pro_curativos), 3);
        var pro_curativos_inicio = clamp(
            batalha_item_opcao - 2,
            0,
            max(0, array_length(pro_curativos) - pro_curativos_total)
        );
        draw_set_halign(fa_left);

        for (var pro_item_i = 0; pro_item_i < pro_curativos_total; pro_item_i++) {
            var pro_item_indice = pro_curativos_inicio + pro_item_i;
            var pro_item = pro_curativos[pro_item_indice];
            var pro_item_y1 = 582 + pro_item_i * 58;
            var pro_item_sel = batalha_item_opcao == pro_item_indice;
            draw_set_alpha(1);
            draw_set_color(pro_item_sel ? pro_noite : pro_item.cor);
            draw_roundrect(728, pro_item_y1, 1206, pro_item_y1 + 50, false);
            draw_set_alpha(pro_item_sel ? 1 : 0.48);
            draw_set_color(pro_item_sel ? pro_rosa : pro_borda);
            draw_roundrect(728, pro_item_y1, 1206, pro_item_y1 + 50, true);
            draw_set_alpha(1);
            draw_set_color(pro_item_sel ? c_white : pro_tinta);
            var pro_item_tem_sprite = variable_struct_exists(pro_item, "sprite_item")
                && pro_item.sprite_item != -1
                && sprite_exists(pro_item.sprite_item);
            if (pro_item_tem_sprite) {
                var pro_item_sprite_w = max(1, sprite_get_width(pro_item.sprite_item));
                var pro_item_sprite_h = max(1, sprite_get_height(pro_item.sprite_item));
                var pro_item_sprite_escala = min(38 / pro_item_sprite_w, 38 / pro_item_sprite_h);
                var pro_item_sprite_x = 758
                    + (sprite_get_xoffset(pro_item.sprite_item) - pro_item_sprite_w * 0.5)
                    * pro_item_sprite_escala;
                var pro_item_sprite_y = pro_item_y1 + 25
                    + (sprite_get_yoffset(pro_item.sprite_item) - pro_item_sprite_h * 0.5)
                    * pro_item_sprite_escala;
                draw_sprite_ext(
                    pro_item.sprite_item,
                    0,
                    pro_item_sprite_x,
                    pro_item_sprite_y,
                    pro_item_sprite_escala,
                    pro_item_sprite_escala,
                    0,
                    c_white,
                    1
                );
            }

            draw_text_transformed(790, pro_item_y1 + 17,
                (pro_item_sel ? ">  " : "") + pro_item.nome, 0.68, 0.68, 0);
            draw_set_alpha(0.66);
            draw_set_color(pro_item_sel ? c_white : pro_tinta);
            draw_text_transformed(790, pro_item_y1 + 36,
                pro_item.raridade + "  •  Cura " + string(pro_item.cura), 0.43, 0.43, 0);
            draw_set_halign(fa_right);
            draw_text_transformed(1182, pro_item_y1 + 25,
                "×" + string(pro_item.quantidade), 0.58, 0.58, 0);
            draw_set_halign(fa_left);
        }

        draw_set_halign(fa_center);
        draw_set_alpha(0.60);
        draw_set_color(pro_tinta_suave);
        draw_text_transformed(967, 760, "Usar consome o turno  •  Esc voltar", 0.49, 0.49, 0);
    }
    else if (batalha_fase == 6) {
        draw_set_alpha(0.96);
        draw_set_color(pro_rosa_claro);
        draw_roundrect(744, 598, 1190, 690, false);
        draw_set_alpha(0.70);
        draw_set_color(pro_borda);
        draw_roundrect(744, 598, 1190, 690, true);
        draw_set_alpha(1);
        draw_set_color(pro_tinta);
        draw_set_halign(fa_center);
        draw_text_transformed(967, 624,
            nomes_inimigos[batalha_inimigo] + " prepara", 0.58, 0.58, 0);
        draw_text_transformed(967, 657,
            batalha_golpe_pendente, 0.80, 0.80, 0);
        draw_set_alpha(0.58);
        draw_set_color(pro_tinta_suave);
        draw_text_transformed(967, 742,
            batalha_defesa_preparada
                ? "Sua guarda está fortalecida"
                : "Prepare-se para defender",
            0.49, 0.49, 0);
    }
    else if (batalha_fase == 4 || batalha_fase == 5) {
        var pro_def_feedback = batalha_fase == 5;
        var pro_def_progresso = clamp(
            pro_def_feedback
                ? batalha_defesa_posicao
                : 1 - batalha_defesa_timer / batalha_defesa_total,
            0,
            1
        );
        var pro_def_x1 = 758;
        var pro_def_x2 = 1176;
        var pro_def_marcador = lerp(pro_def_x1, pro_def_x2, pro_def_progresso);
        var pro_def_alvo_x = lerp(pro_def_x1, pro_def_x2, batalha_defesa_alvo);
        var pro_def_cor = pro_def_feedback
            ? (batalha_defesa_feedback > 0 ? pro_menta : pro_rosa)
            : pro_lilas;

        // Arte composta: banner e base da barra em um único sprite.
        var pro_def_base_sprite = apr_defenda_mais_barra;
        var pro_def_base_bbox_l = sprite_get_bbox_left(pro_def_base_sprite);
        var pro_def_base_bbox_r = sprite_get_bbox_right(pro_def_base_sprite);
        var pro_def_base_bbox_t = sprite_get_bbox_top(pro_def_base_sprite);
        var pro_def_base_bbox_b = sprite_get_bbox_bottom(pro_def_base_sprite);
        var pro_def_base_bbox_w = max(1,
            pro_def_base_bbox_r - pro_def_base_bbox_l + 1);
        var pro_def_base_escala = 446 / pro_def_base_bbox_w;
        var pro_def_base_cx = 967;
        var pro_def_base_cy = 633;
        var pro_def_base_draw_x = pro_def_base_cx
            + (sprite_get_xoffset(pro_def_base_sprite)
                - (pro_def_base_bbox_l + pro_def_base_bbox_r) * 0.5)
            * pro_def_base_escala;
        var pro_def_base_draw_y = pro_def_base_cy
            + (sprite_get_yoffset(pro_def_base_sprite)
                - (pro_def_base_bbox_t + pro_def_base_bbox_b) * 0.5)
            * pro_def_base_escala;

        draw_set_alpha(1);
        draw_sprite_ext(
            pro_def_base_sprite,
            0,
            pro_def_base_draw_x,
            pro_def_base_draw_y,
            pro_def_base_escala,
            pro_def_base_escala,
            0,
            c_white,
            1
        );

        // O tamanho das zonas corresponde exatamente às janelas usadas no
        // cálculo. Preparar a guarda deixa ambas maiores também visualmente.
        var pro_def_barra_y = 661;
        var pro_def_barra_w = pro_def_x2 - pro_def_x1;
        var pro_def_wide_w = max(34,
            pro_def_barra_w * 2 * batalha_defesa_janela_boa
                / batalha_defesa_total);
        var pro_def_narrow_w = max(20,
            pro_def_barra_w * 2 * batalha_defesa_janela_perfeita
                / batalha_defesa_total);

        var pro_def_wide_bbox_l = sprite_get_bbox_left(spr_hitzone_wide);
        var pro_def_wide_bbox_r = sprite_get_bbox_right(spr_hitzone_wide);
        var pro_def_wide_bbox_t = sprite_get_bbox_top(spr_hitzone_wide);
        var pro_def_wide_bbox_b = sprite_get_bbox_bottom(spr_hitzone_wide);
        var pro_def_wide_sx = pro_def_wide_w
            / max(1, pro_def_wide_bbox_r - pro_def_wide_bbox_l + 1);
        var pro_def_wide_sy = 31
            / max(1, pro_def_wide_bbox_b - pro_def_wide_bbox_t + 1);
        var pro_def_wide_draw_x = pro_def_alvo_x
            + (sprite_get_xoffset(spr_hitzone_wide)
                - (pro_def_wide_bbox_l + pro_def_wide_bbox_r) * 0.5)
            * pro_def_wide_sx;
        var pro_def_wide_draw_y = pro_def_barra_y
            + (sprite_get_yoffset(spr_hitzone_wide)
                - (pro_def_wide_bbox_t + pro_def_wide_bbox_b) * 0.5)
            * pro_def_wide_sy;

        var pro_def_narrow_bbox_l = sprite_get_bbox_left(spr_hitzone_narrow);
        var pro_def_narrow_bbox_r = sprite_get_bbox_right(spr_hitzone_narrow);
        var pro_def_narrow_bbox_t = sprite_get_bbox_top(spr_hitzone_narrow);
        var pro_def_narrow_bbox_b = sprite_get_bbox_bottom(spr_hitzone_narrow);
        var pro_def_narrow_sx = pro_def_narrow_w
            / max(1, pro_def_narrow_bbox_r - pro_def_narrow_bbox_l + 1);
        var pro_def_narrow_sy = 33
            / max(1, pro_def_narrow_bbox_b - pro_def_narrow_bbox_t + 1);
        var pro_def_narrow_draw_x = pro_def_alvo_x
            + (sprite_get_xoffset(spr_hitzone_narrow)
                - (pro_def_narrow_bbox_l + pro_def_narrow_bbox_r) * 0.5)
            * pro_def_narrow_sx;
        var pro_def_narrow_draw_y = pro_def_barra_y
            + (sprite_get_yoffset(spr_hitzone_narrow)
                - (pro_def_narrow_bbox_t + pro_def_narrow_bbox_b) * 0.5)
            * pro_def_narrow_sy;

        if (pro_def_feedback && batalha_defesa_feedback > 0) {
            var pro_def_pulso = global.config_baixo_estimulo
                ? 0.18
                : 0.18 + sin(tempo_pause * 3.2) * 0.06;
            draw_set_alpha(pro_def_pulso);
            draw_set_color(pro_menta_clara);
            draw_roundrect(
                pro_def_alvo_x - pro_def_wide_w * 0.5 - 7,
                pro_def_barra_y - 21,
                pro_def_alvo_x + pro_def_wide_w * 0.5 + 7,
                pro_def_barra_y + 21,
                false
            );
        }

        draw_set_alpha(pro_def_feedback && batalha_defesa_feedback < 0 ? 0.62 : 0.94);
        draw_sprite_ext(spr_hitzone_wide, 0,
            pro_def_wide_draw_x, pro_def_wide_draw_y,
            pro_def_wide_sx, pro_def_wide_sy, 0, c_white, 1);
        draw_set_alpha(pro_def_feedback && batalha_defesa_feedback < 0 ? 0.66 : 1);
        draw_sprite_ext(spr_hitzone_narrow, 0,
            pro_def_narrow_draw_x, pro_def_narrow_draw_y,
            pro_def_narrow_sx, pro_def_narrow_sy, 0, c_white, 1);

        // Cursor rosa acompanha a posição real e congela no ponto escolhido.
        var pro_def_cursor_bbox_l = sprite_get_bbox_left(spr_cursor);
        var pro_def_cursor_bbox_r = sprite_get_bbox_right(spr_cursor);
        var pro_def_cursor_bbox_t = sprite_get_bbox_top(spr_cursor);
        var pro_def_cursor_bbox_b = sprite_get_bbox_bottom(spr_cursor);
        var pro_def_cursor_escala = 50
            / max(1, pro_def_cursor_bbox_b - pro_def_cursor_bbox_t + 1);
        var pro_def_cursor_draw_x = pro_def_marcador
            + (sprite_get_xoffset(spr_cursor)
                - (pro_def_cursor_bbox_l + pro_def_cursor_bbox_r) * 0.5)
            * pro_def_cursor_escala;
        var pro_def_cursor_draw_y = pro_def_barra_y
            + (sprite_get_yoffset(spr_cursor)
                - (pro_def_cursor_bbox_t + pro_def_cursor_bbox_b) * 0.5)
            * pro_def_cursor_escala;
        draw_set_alpha(1);
        draw_sprite_ext(spr_cursor, 0,
            pro_def_cursor_draw_x, pro_def_cursor_draw_y,
            pro_def_cursor_escala, pro_def_cursor_escala,
            0, c_white, 1);

        // Em uma defesa perdida, a arte rosa substitui somente o banner.
        if (pro_def_feedback && batalha_defesa_feedback < 0) {
            var pro_def_rompida_bbox_l = sprite_get_bbox_left(spr_guardarompida_somente);
            var pro_def_rompida_bbox_r = sprite_get_bbox_right(spr_guardarompida_somente);
            var pro_def_rompida_bbox_t = sprite_get_bbox_top(spr_guardarompida_somente);
            var pro_def_rompida_bbox_b = sprite_get_bbox_bottom(spr_guardarompida_somente);
            var pro_def_rompida_escala = 446
                / max(1, pro_def_rompida_bbox_r - pro_def_rompida_bbox_l + 1);
            var pro_def_rompida_cy = 613;
            var pro_def_rompida_draw_x = 967
                + (sprite_get_xoffset(spr_guardarompida_somente)
                    - (pro_def_rompida_bbox_l + pro_def_rompida_bbox_r) * 0.5)
                * pro_def_rompida_escala;
            var pro_def_rompida_draw_y = pro_def_rompida_cy
                + (sprite_get_yoffset(spr_guardarompida_somente)
                    - (pro_def_rompida_bbox_t + pro_def_rompida_bbox_b) * 0.5)
                * pro_def_rompida_escala;
            draw_set_alpha(1);
            draw_sprite_ext(spr_guardarompida_somente, 0,
                pro_def_rompida_draw_x, pro_def_rompida_draw_y,
                pro_def_rompida_escala, pro_def_rompida_escala,
                0, c_white, 1);
        }

        draw_set_alpha(0.66);
        draw_set_color(pro_tinta_suave);
        draw_text_transformed(967, 739,
            pro_def_feedback
                ? (batalha_defesa_feedback > 0
                    ? "Defesa precisa — golpe bloqueado"
                    : "A guarda foi rompida — impacto aumentado")
                : "Espaço quando o cursor alcançar a faixa menta",
            0.60, 0.60, 0);
    }
    else {
        var pro_vitoria = batalha_fase == 2;
        draw_set_alpha(0.96);
        draw_set_color(pro_vitoria ? pro_menta_clara : pro_rosa_claro);
        draw_roundrect(744, 598, 1190, 700, false);
        draw_set_alpha(0.74);
        draw_set_color(pro_borda);
        draw_roundrect(744, 598, 1190, 700, true);
        draw_set_alpha(1);
        draw_set_color(pro_tinta);
        draw_text_transformed(967, 628,
            pro_vitoria ? "VITÓRIA" : "KIRAN RECUOU", 0.90, 0.90, 0);
        draw_set_alpha(0.72);
        draw_text_ext_transformed(967, 662,
            pro_vitoria
                ? "Oferenda recebida: " + global.oferendas_estatuas[batalha_inimigo]
                : "A vida será restaurada parcialmente ao sair do duelo.",
            22, 400, 0.54, 0.54, 0);
        draw_set_alpha(0.60);
        draw_text_transformed(967, 746, "Espaço para continuar", 0.48, 0.48, 0);
    }

    // Cartão central de recompensa. Só aparece quando o item foi realmente
    // entregue, com a arte correspondente à oferenda daquele adversário.
    if (
        batalha_fase == 2
        && batalha_recompensa_recebida
        && recompensa_sprite != -1
        && sprite_exists(recompensa_sprite)
    ) {
        draw_set_alpha(0.40);
        draw_set_color(pro_noite);
        draw_rectangle(0, 0, 1280, 811, false);

        draw_set_alpha(0.22);
        draw_set_color(pro_noite);
        draw_roundrect(326, 222, 962, 604, false);
        draw_set_alpha(0.99);
        draw_set_color(pro_papel);
        draw_roundrect(318, 214, 954, 596, false);
        draw_set_alpha(0.82);
        draw_set_color(pro_borda);
        draw_roundrect(318, 214, 954, 596, true);

        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_alpha(1);
        desenhar_texto_grosso(636, 258, "OFERENDA RECEBIDA!",
            0.92, 0.92, pro_tinta);
        draw_set_alpha(0.56);
        draw_set_color(pro_borda);
        draw_line(426, 291, 846, 291);

        var rec_card_bbox_l = sprite_get_bbox_left(recompensa_sprite);
        var rec_card_bbox_r = sprite_get_bbox_right(recompensa_sprite);
        var rec_card_bbox_t = sprite_get_bbox_top(recompensa_sprite);
        var rec_card_bbox_b = sprite_get_bbox_bottom(recompensa_sprite);
        var rec_card_bbox_w = max(1, rec_card_bbox_r - rec_card_bbox_l + 1);
        var rec_card_bbox_h = max(1, rec_card_bbox_b - rec_card_bbox_t + 1);
        var rec_card_escala = min(118 / rec_card_bbox_w, 118 / rec_card_bbox_h);
        var rec_card_cx = 636;
        var rec_card_cy = 373;
        var rec_card_sprite_x = rec_card_cx
            + (sprite_get_xoffset(recompensa_sprite)
                - (rec_card_bbox_l + rec_card_bbox_r) * 0.5)
            * rec_card_escala;
        var rec_card_sprite_y = rec_card_cy
            + (sprite_get_yoffset(recompensa_sprite)
                - (rec_card_bbox_t + rec_card_bbox_b) * 0.5)
            * rec_card_escala;

        draw_set_alpha(0.16);
        draw_set_color(pro_menta_clara);
        draw_circle(rec_card_cx, rec_card_cy, 78, false);
        draw_set_alpha(0.10);
        draw_circle(rec_card_cx, rec_card_cy, 96, false);
        draw_set_alpha(1);
        draw_sprite_ext(recompensa_sprite, 0,
            rec_card_sprite_x, rec_card_sprite_y,
            rec_card_escala, rec_card_escala, 0, c_white, 1);

        // Pequenos brilhos acompanham o estilo pastel sem distrair.
        draw_set_color(pro_rosa);
        draw_set_alpha(global.config_baixo_estimulo ? 0.42 : 0.70);
        draw_circle(518, 335, 4, false);
        draw_circle(750, 407, 3, false);
        draw_set_color(pro_menta);
        draw_circle(742, 326, 5, false);
        draw_circle(526, 419, 3, false);

        draw_set_alpha(1);
        desenhar_texto_grosso(636, 475, recompensa_nome,
            0.82, 0.82, pro_tinta);
        draw_set_alpha(0.76);
        draw_set_color(pro_tinta_suave);
        draw_text_ext_transformed(636, 510, recompensa_descricao,
            24, 500, 0.56, 0.56, 0);
        draw_set_alpha(0.68);
        draw_text_transformed(636, 565,
            "Espaço  •  guardar e continuar", 0.49, 0.49, 0);
    }

    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(-1);
}

// Interface anterior mantida sem execução durante a transição visual.
if (tela_pause == 5 && batalha_fase >= 0 && false) {
    draw_set_font(fnt_dialogo);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    var batd_cor_texto = alto_contraste
        ? make_color_rgb(20, 22, 34)
        : make_color_rgb(57, 66, 107);
    var batd_cor_borda = alto_contraste
        ? make_color_rgb(48, 38, 86)
        : make_color_rgb(121, 111, 164);
    var batd_cor_papel = alto_contraste
        ? c_white
        : make_color_rgb(255, 249, 239);
    var batd_rosa = make_color_rgb(239, 205, 226);
    var batd_lilas = make_color_rgb(220, 212, 244);
    var batd_menta = make_color_rgb(198, 237, 220);
    var batd_azul = make_color_rgb(205, 228, 245);
    var batd_cor_inimigo = cores_inimigos[batalha_inimigo];
    var batd_cores_opcoes = [batd_azul, batd_menta, batd_lilas, batd_rosa];

    // Folha interna do mesmo caderno usado pelo inventário.
    draw_set_alpha(0.14);
    draw_set_color(make_color_rgb(32, 41, 68));
    draw_roundrect(126, 162, 1158, 737, false);
    draw_set_alpha(1);
    draw_set_color(batd_cor_papel);
    draw_roundrect(120, 156, 1152, 731, false);
    draw_set_alpha(0.42);
    draw_set_color(batd_cor_borda);
    draw_roundrect(120, 156, 1152, 731, true);

    desenhar_folha_pause(136, 175, global.config_baixo_estimulo ? 0.20 : 0.50);
    desenhar_folha_pause(1137, 175, global.config_baixo_estimulo ? 0.20 : 0.50);

    // Fita de título.
    draw_set_alpha(0.88);
    draw_set_color(batd_rosa);
    draw_roundrect(430, 91, 850, 149, false);
    draw_set_alpha(0.40);
    draw_set_color(batd_cor_borda);
    draw_roundrect(430, 91, 850, 149, true);
    draw_set_alpha(1);
    draw_set_color(batd_cor_texto);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(640, 120,
        "Guarda Real  •  " + dificuldades_inimigos[batalha_inimigo]
            + (batalha_elite_desperto ? "  •  Fase 2" : ""),
        1.04, 1.04, 0);

    // Cartões dos dois lados da batalha, como duas fichas do inventário.
    draw_set_alpha(0.30);
    draw_set_color(batd_lilas);
    draw_roundrect(135, 170, 610, 445, false);
    draw_set_color(batd_azul);
    draw_roundrect(670, 170, 1145, 445, false);
    draw_set_alpha(0.46);
    draw_set_color(batd_cor_borda);
    draw_roundrect(135, 170, 610, 445, true);
    draw_roundrect(670, 170, 1145, 445, true);

    // Etiquetas superiores e medalhão central.
    draw_set_alpha(0.82);
    draw_set_color(batd_rosa);
    draw_roundrect(245, 174, 485, 211, false);
    draw_set_color(batd_menta);
    draw_roundrect(790, 174, 1030, 211, false);
    draw_set_alpha(0.96);
    draw_set_color(batd_cor_papel);
    draw_circle(640, 303, 27, false);
    draw_set_alpha(0.72);
    draw_set_color(batd_cor_borda);
    draw_circle(640, 303, 27, true);
    draw_line_width(628, 315, 650, 291, 4);
    draw_line_width(630, 291, 652, 315, 4);

    // NPC provisório. O corpo simples será substituído pelo sprite final.
    var batd_bob = 0;
    var batd_ex = 365;
    var batd_ey = 290 + batd_bob;
    draw_set_alpha(0.12);
    draw_set_color(batd_cor_inimigo);
    draw_circle(batd_ex, batd_ey + 8, 84, false);
    draw_set_alpha(0.96);
    draw_set_color(make_color_rgb(246, 239, 244));
    draw_circle(batd_ex, batd_ey - 37, 29, false);
    draw_set_color(batd_cor_inimigo);
    draw_roundrect(batd_ex - 31, batd_ey - 7, batd_ex + 31, batd_ey + 66, false);
    draw_set_alpha(0.86);
    draw_set_color(batd_cor_borda);
    draw_circle(batd_ex, batd_ey - 37, 29, true);
    draw_roundrect(batd_ex - 31, batd_ey - 7, batd_ex + 31, batd_ey + 66, true);
    draw_line_width(batd_ex - 30, batd_ey + 8, batd_ex - 54, batd_ey + 42, 7);
    draw_line_width(batd_ex + 30, batd_ey + 8, batd_ex + 54, batd_ey + 42, 7);
    draw_set_alpha(0.74);
    draw_set_color(batd_cor_inimigo);
    draw_circle(batd_ex - 18, batd_ey - 57, 17, false);
    draw_circle(batd_ex + 5, batd_ey - 64, 19, false);
    draw_circle(batd_ex + 24, batd_ey - 53, 14, false);

    // Brasão pastel da Guarda da Rainha.
    draw_set_alpha(0.96);
    draw_set_color(batd_rosa);
    draw_circle(batd_ex, batd_ey + 22, 13, false);
    draw_set_color(batd_cor_borda);
    draw_triangle(batd_ex, batd_ey + 10, batd_ex - 9, batd_ey + 29,
        batd_ex + 9, batd_ey + 29, true);

    // Kiran usa o próprio sprite já existente.
    draw_set_alpha(0.13);
    draw_set_color(batd_menta);
    draw_circle(910, 292, 86, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_sprite_ext(spr_kiran_idle, 0, 910, 318, 1.10, 1.10, 0, c_white, 1);

    // Representação provisória da Lâmina do Fragmento.
    draw_set_alpha(0.92);
    draw_set_color(batd_cor_borda);
    draw_line_width(958, 350, 992, 277, 8);
    draw_set_color(batd_azul);
    draw_triangle(992, 277, 979, 315, 1005, 315, false);
    draw_set_alpha(0.82);
    draw_set_color(c_white);
    draw_line_width(988, 292, 985, 308, 2);
    draw_set_color(batd_cor_borda);
    draw_line_width(970, 327, 993, 337, 5);

    // Nomes e barras.
    draw_set_alpha(1);
    draw_set_color(batd_cor_texto);
    draw_text_transformed(365, 191, nomes_inimigos[batalha_inimigo], 0.90, 0.90, 0);
    draw_text_transformed(910, 191, "Kiran", 0.90, 0.90, 0);
    draw_set_alpha(0.62);
    draw_text_transformed(365, 221, titulos_inimigos[batalha_inimigo], 0.55, 0.55, 0);
    draw_text_transformed(910, 221, "Tipo Luz", 0.55, 0.55, 0);

    draw_set_alpha(0.46);
    draw_set_color(make_color_rgb(226, 221, 232));
    draw_roundrect(190, 402, 540, 418, false);
    draw_roundrect(735, 402, 1085, 418, false);
    draw_set_alpha(0.94);
    draw_set_color(batd_lilas);
    draw_roundrect(190, 402,
        190 + 350 * (batalha_corrupcao / batalha_hp_max_inimigo), 418, false);
    draw_set_color(batd_menta);
    draw_roundrect(735, 402,
        735 + 350 * (batalha_serenidade / global.vida_kiran_max), 418, false);
    draw_set_alpha(0.48);
    draw_set_color(batd_cor_borda);
    draw_roundrect(190, 402, 540, 418, true);
    draw_roundrect(735, 402, 1085, 418, true);
    draw_set_alpha(0.74);
    draw_set_color(batd_cor_texto);
    draw_text_transformed(365, 430,
        "HP  " + string(ceil(batalha_corrupcao)) + " / " + string(batalha_hp_max_inimigo),
        0.62, 0.62, 0);
    draw_text_transformed(910, 430,
        "HP  " + string(ceil(batalha_serenidade)) + " / " + string(global.vida_kiran_max),
        0.66, 0.66, 0);
    draw_set_alpha(0.70);
    draw_text_transformed(640, 451,
        "Tipo do oponente: " + tipos_inimigos[batalha_inimigo]
        + "   •   Fraqueza: " + fraquezas_inimigos[batalha_inimigo],
        0.60, 0.60, 0);

    // Mensagem da rodada.
    draw_set_alpha(0.96);
    draw_set_color(batd_cor_papel);
    draw_roundrect(166, 456, 1114, 545, false);
    draw_set_alpha(0.52);
    draw_set_color(batd_cor_borda);
    draw_roundrect(166, 456, 1114, 545, true);
    draw_set_alpha(1);
    draw_set_color(batd_cor_texto);
    draw_text_ext_transformed(640, 480, batalha_mensagem, 26, 860, 0.82, 0.82, 0);

    draw_set_alpha(0.90);
    draw_set_color(batd_rosa);
    draw_roundrect(198, 456, 304, 480, false);
    draw_set_alpha(0.74);
    draw_set_color(batd_cor_texto);
    draw_text_transformed(251, 468, "Turno " + string(batalha_rodada), 0.48, 0.48, 0);

    if (batalha_fase == 0 || batalha_fase == 1) {
        for (var batd_i = 0; batd_i < 4; batd_i++) {
            var batd_col = batd_i mod 2;
            var batd_lin = floor(batd_i / 2);
            var batd_x1 = 145 + batd_col * 505;
            var batd_y1 = 558 + batd_lin * 76;
            var batd_x2 = batd_x1 + 485;
            var batd_y2 = batd_y1 + 58;
            var batd_sel = batalha_fase == 0 && batd_i == batalha_opcao;
            var batd_disponivel = batalha_energia >= batalha_custos_golpes[batd_i];

            draw_set_alpha(batd_sel ? 0.20 : 0.09);
            draw_set_color(batd_cor_borda);
            draw_roundrect(batd_x1 + 3, batd_y1 + 4, batd_x2 + 3, batd_y2 + 4, false);
            draw_set_alpha(!batd_disponivel ? 0.22 : (batd_sel ? 0.90 : 0.48));
            draw_set_color(batd_cores_opcoes[batd_i]);
            draw_roundrect(batd_x1, batd_y1, batd_x2, batd_y2, false);
            draw_set_alpha(batd_sel ? 0.88 : 0.30);
            draw_set_color(batd_cor_borda);
            draw_roundrect(batd_x1, batd_y1, batd_x2, batd_y2, true);

            // Pequena joia de tipo, repetindo os ícones delicados do inventário.
            draw_set_alpha(!batd_disponivel ? 0.22 : (batd_sel ? 0.96 : 0.58));
            draw_set_color(batd_cores_opcoes[batd_i]);
            draw_circle(batd_x1 + 31, batd_y1 + 29, 17, false);
            draw_set_color(batd_cor_borda);
            draw_circle(batd_x1 + 31, batd_y1 + 29, 17, true);
            draw_line(batd_x1 + 24, batd_y1 + 29, batd_x1 + 38, batd_y1 + 29);
            draw_line(batd_x1 + 31, batd_y1 + 22, batd_x1 + 31, batd_y1 + 36);

            draw_set_alpha(!batd_disponivel ? 0.35 : (batalha_fase == 0 ? 1 : 0.45));
            draw_set_color(batd_cor_texto);
            draw_text_transformed((batd_x1 + batd_x2) / 2 + 16,
                batd_y1 + 19, batalha_opcoes[batd_i], 0.76, 0.76, 0);
            draw_set_alpha(!batd_disponivel ? 0.28 : (batalha_fase == 0 ? 0.68 : 0.34));
            draw_text_transformed((batd_x1 + batd_x2) / 2 + 16,
                batd_y1 + 43,
                batalha_tipos_golpes[batd_i]
                    + "  •  Energia " + string(batalha_custos_golpes[batd_i]),
                0.54, 0.54, 0);
        }

        draw_set_alpha(0.68);
        draw_set_color(batd_cor_texto);
        draw_text_transformed(640, 708,
            "Energia " + string(batalha_energia) + " / " + string(batalha_energia_max)
                + "   •   Poder " + string(batalha_poder_golpes[batalha_opcao]),
            0.62, 0.62, 0);
        draw_set_alpha(0.72);
        draw_text_transformed(640, 730, batalha_descricoes_golpes[batalha_opcao], 0.55, 0.55, 0);
        draw_set_alpha(0.54);
        draw_text_transformed(640, 752, "Setas escolher  •  Espaço confirmar  •  Esc fugir", 0.52, 0.52, 0);
    }
    else if (batalha_fase == 4 || batalha_fase == 5) {
        var batd_feedback_ativo = batalha_fase == 5;
        var batd_defesa_progresso = clamp(
            batd_feedback_ativo
                ? batalha_defesa_posicao
                : 1 - batalha_defesa_timer / batalha_defesa_total,
            0,
            1
        );
        var batd_defesa_x = 260 + 760 * batd_defesa_progresso;
        var batd_feedback_cor = batalha_defesa_feedback > 0
            ? batd_menta
            : batd_rosa;

        // Pulso suave ao redor de toda a tela.
        if (batd_feedback_ativo) {
            var batd_feedback_alpha = global.config_baixo_estimulo
                ? 0.035
                : (global.config_reduzir_animacoes
                    ? 0.075
                    : 0.075 + sin(batalha_timer * 0.22) * 0.025);
            draw_set_alpha(batd_feedback_alpha);
            draw_set_color(batd_feedback_cor);
            draw_rectangle(0, 0, 1280, 811, false);
        }

        draw_set_alpha(0.92);
        draw_set_color(batd_feedback_ativo ? batd_feedback_cor : batd_lilas);
        draw_roundrect(225, 566, 1055, 690, false);
        draw_set_alpha(0.52);
        draw_set_color(batd_cor_borda);
        draw_roundrect(225, 566, 1055, 690, true);

        draw_set_alpha(1);
        draw_set_color(batd_cor_texto);
        draw_text_transformed(640, 590,
            batd_feedback_ativo
                ? (batalha_defesa_feedback > 0 ? "ACERTOU!" : "ERROU!")
                : "DEFENDA!",
            0.90, 0.90, 0);

        if (batd_feedback_ativo) {
            draw_set_alpha(0.42);
            draw_set_color(batd_feedback_cor);
            draw_roundrect(260, 620, 1020, 651, false);
        }

        // Zona larga = boa defesa; centro claro = defesa perfeita.
        draw_set_alpha(0.46);
        draw_set_color(batd_azul);
        draw_roundrect(577, 620, 703, 651, false);
        draw_set_alpha(0.92);
        draw_set_color(batd_menta);
        draw_roundrect(615, 616, 665, 655, false);
        draw_set_alpha(0.46);
        draw_set_color(batd_cor_borda);
        draw_roundrect(260, 620, 1020, 651, true);

        draw_set_alpha(1);
        draw_set_color(batd_feedback_ativo ? batd_feedback_cor : batd_rosa);
        draw_line_width(batd_defesa_x, 609, batd_defesa_x, 662, 6);
        draw_set_color(batd_cor_borda);
        draw_line(batd_defesa_x, 609, batd_defesa_x, 662);

        draw_set_alpha(0.72);
        draw_set_color(batd_cor_texto);
        draw_text_transformed(640, 676,
            batd_feedback_ativo
                ? (batalha_defesa_feedback > 0
                    ? "A guarda bloqueou todo o impacto"
                    : "O golpe atravessou a guarda e causou dano aumentado")
                : "Aperte Espaço quando o marcador estiver no centro verde",
            0.58, 0.58, 0);
        draw_set_alpha(0.48);
        draw_text_transformed(640, 722,
            batd_feedback_ativo
                ? "O resultado fica destacado em verde ou rosa"
                : "Fora da área colorida, o golpe causa dano aumentado",
            0.58, 0.58, 0);
    }
    else {
        var batd_vitoria = batalha_fase == 2;
        draw_set_alpha(0.12);
        draw_set_color(batd_cor_borda);
        draw_roundrect(323, 570, 963, 698, false);
        draw_set_alpha(0.92);
        draw_set_color(batd_cor_papel);
        draw_roundrect(317, 564, 957, 692, false);
        draw_set_alpha(0.76);
        draw_set_color(batd_cor_borda);
        draw_roundrect(317, 564, 957, 692, true);
        draw_set_alpha(0.88);
        draw_set_color(batd_vitoria ? batd_menta : batd_lilas);
        draw_roundrect(452, 553, 822, 593, false);
        draw_set_alpha(1);
        draw_set_color(batd_cor_texto);
        draw_text_transformed(637, 573,
            batd_vitoria ? "Vitória" : "Duelo encerrado",
            0.84, 0.84, 0);
        draw_set_alpha(0.88);
        draw_text_transformed(637, 625,
            batd_vitoria
                ? "Recebido: " + global.oferendas_estatuas[batalha_inimigo]
                : "A floresta continua aberta para uma nova tentativa",
            0.68, 0.68, 0);
        draw_set_alpha(0.68);
        draw_text_transformed(637, 666, "Espaço para continuar", 0.54, 0.54, 0);
        desenhar_folha_pause(340, 672, global.config_baixo_estimulo ? 0.18 : 0.42);
        desenhar_folha_pause(934, 672, global.config_baixo_estimulo ? 0.18 : 0.42);
    }
}


// ═════════════════════════════════════════════
// Versão anterior do protótipo emocional, mantida sem execução.
// ═════════════════════════════════════════════
if (tela_pause == 5 && false) {
    var emo_texto = alto_contraste
        ? make_color_rgb(20, 22, 34)
        : make_color_rgb(57, 66, 107);
    var emo_borda = alto_contraste
        ? make_color_rgb(48, 38, 86)
        : make_color_rgb(121, 111, 164);
    var emo_papel = alto_contraste ? c_white : make_color_rgb(255, 249, 239);
    var emo_rosa = make_color_rgb(239, 205, 226);
    var emo_lilas = make_color_rgb(220, 212, 244);
    var emo_menta = make_color_rgb(198, 237, 220);
    var emo_azul = make_color_rgb(205, 228, 245);
    var emo_cor_espirito = cores_inimigos[batalha_inimigo];
    var emo_cores_botoes = [emo_menta, emo_azul, emo_lilas];
    var emo_cores_sentimentos = [emo_rosa, emo_azul, emo_lilas];

    // Título pequeno, deixando o espírito ser o foco da tela.
    draw_set_alpha(0.88);
    draw_set_color(emo_rosa);
    draw_roundrect(470, 88, 810, 142, false);
    draw_set_alpha(0.38);
    draw_set_color(emo_borda);
    draw_roundrect(470, 88, 810, 142, true);
    draw_set_alpha(1);
    draw_set_color(emo_texto);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(640, 115, "Encontro de purificação", 1.05, 1.05, 0);

    // Um único palco limpo evita a aparência de ficha técnica.
    draw_set_alpha(0.14);
    draw_set_color(make_color_rgb(32, 41, 68));
    draw_roundrect(169, 171, 1119, 478, false);
    draw_set_alpha(0.96);
    draw_set_color(emo_papel);
    draw_roundrect(163, 165, 1113, 472, false);
    draw_set_alpha(0.28);
    draw_set_color(emo_borda);
    draw_roundrect(163, 165, 1113, 472, true);

    draw_set_alpha(0.88);
    draw_set_color(emo_texto);
    draw_text_transformed(640, 190, nomes_inimigos[batalha_inimigo], 0.88, 0.88, 0);

    var emo_bob = global.config_reduzir_animacoes ? 0 : sin(tempo_inimigos) * 4;
    var emo_x = 640;
    var emo_y = 292 + emo_bob;

    // Silhueta provisória de um espírito alado.
    draw_set_alpha(global.config_baixo_estimulo ? 0.08 : 0.14);
    draw_set_color(emo_cor_espirito);
    draw_circle(emo_x, emo_y, 90, false);
    draw_set_alpha(0.18);
    draw_circle(emo_x, emo_y, 68, false);
    draw_set_alpha(0.54);
    draw_set_color(emo_azul);
    draw_ellipse(emo_x - 82, emo_y - 25, emo_x - 22, emo_y + 38, false);
    draw_set_color(emo_lilas);
    draw_ellipse(emo_x + 22, emo_y - 25, emo_x + 82, emo_y + 38, false);
    draw_set_alpha(0.96);
    draw_set_color(emo_cor_espirito);
    draw_circle(emo_x, emo_y - 8, 42, false);
    draw_triangle(emo_x - 29, emo_y + 18, emo_x + 29, emo_y + 18, emo_x, emo_y + 77, false);
    draw_set_alpha(0.76);
    draw_set_color(emo_borda);
    draw_circle(emo_x, emo_y - 8, 42, true);

    draw_set_alpha(1);
    draw_set_color(emo_texto);
    draw_text_transformed(emo_x, emo_y - 8,
        batalha_simbolos[batalha_emocao], 1.62, 1.62, 0);

    // A emoção aparece por texto e símbolo: não depende somente de cor.
    draw_set_alpha(0.90);
    draw_set_color(emo_cores_sentimentos[batalha_emocao]);
    draw_roundrect(470, 382, 810, 426, false);
    draw_set_alpha(0.44);
    draw_set_color(emo_borda);
    draw_roundrect(470, 382, 810, 426, true);
    draw_set_alpha(1);
    draw_set_color(emo_texto);
    draw_text_transformed(640, 404,
        "Sentimento: " + batalha_emocoes[batalha_emocao], 0.80, 0.80, 0);

    // Barra curta: dois acertos corretos bastam para concluir.
    draw_set_alpha(0.38);
    draw_set_color(make_color_rgb(229, 225, 235));
    draw_roundrect(420, 443, 860, 456, false);
    draw_set_alpha(0.94);
    draw_set_color(emo_menta);
    draw_roundrect(420, 443, 420 + 440 * ((100 - batalha_corrupcao) / 100), 456, false);

    draw_set_alpha(0.90);
    draw_set_color(emo_papel);
    draw_roundrect(205, 490, 1075, 552, false);
    draw_set_alpha(0.28);
    draw_set_color(emo_borda);
    draw_roundrect(205, 490, 1075, 552, true);
    draw_set_alpha(0.92);
    draw_set_color(emo_texto);
    draw_text_ext_transformed(640, 508, batalha_mensagem, 22, 800, 0.68, 0.68, 0);

    if (batalha_fase == 0 || batalha_fase == 1) {
        for (var emo_i = 0; emo_i < 3; emo_i++) {
            var emo_x1 = 145 + emo_i * 335;
            var emo_y1 = 596;
            var emo_x2 = emo_x1 + 320;
            var emo_y2 = 662;
            var emo_sel = batalha_fase == 0 && batalha_opcao == emo_i;

            draw_set_alpha(emo_sel ? 0.18 : 0.08);
            draw_set_color(emo_borda);
            draw_roundrect(emo_x1 + 3, emo_y1 + 4, emo_x2 + 3, emo_y2 + 4, false);
            draw_set_alpha(emo_sel ? 0.92 : 0.48);
            draw_set_color(emo_cores_botoes[emo_i]);
            draw_roundrect(emo_x1, emo_y1, emo_x2, emo_y2, false);
            draw_set_alpha(emo_sel ? 0.86 : 0.28);
            draw_set_color(emo_borda);
            draw_roundrect(emo_x1, emo_y1, emo_x2, emo_y2, true);
            draw_set_alpha(batalha_fase == 0 ? 1 : 0.44);
            draw_set_color(emo_texto);
            draw_text_transformed((emo_x1 + emo_x2) / 2, 629,
                batalha_opcoes[emo_i], 0.82, 0.82, 0);
        }

        draw_set_alpha(0.66);
        draw_set_color(emo_texto);
        draw_text_transformed(640, 695,
            "Tristeza → Acalmar    •    Medo → Proteger    •    Confusão → Compreender",
            0.60, 0.60, 0);
        draw_set_alpha(0.48);
        draw_text_transformed(640, 728,
            "Setas escolher  •  Espaço confirmar  •  Esc sair", 0.54, 0.54, 0);
    }
    else {
        var emo_venceu = batalha_fase == 2;
        draw_set_alpha(0.92);
        draw_set_color(emo_venceu ? emo_menta : emo_lilas);
        draw_roundrect(370, 590, 910, 670, false);
        draw_set_alpha(0.58);
        draw_set_color(emo_borda);
        draw_roundrect(370, 590, 910, 670, true);
        draw_set_alpha(1);
        draw_set_color(emo_texto);
        draw_text_transformed(640, 615,
            emo_venceu ? "Oferenda recebida" : "Kiran recuperará a calma",
            0.78, 0.78, 0);
        draw_text_transformed(640, 647,
            emo_venceu ? global.oferendas_estatuas[batalha_inimigo] : "Tente novamente quando quiser",
            0.68, 0.68, 0);
        draw_set_alpha(0.54);
        draw_text_transformed(640, 708, "Espaço para continuar", 0.56, 0.56, 0);
    }
}


// ═════════════════════════════════════════════
// PAUSA SENSORIAL
// ═════════════════════════════════════════════
if (tela_pause == 3) {
    draw_set_alpha(1);
    draw_set_color(cor_texto);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_text_transformed(
        636,
        130,
        "Sensory break",
        1.48,
        1.48,
        0
    );

    draw_set_alpha(0.20);
    draw_set_color(cor_borda);

    draw_line(
        470,
        170,
        802,
        170
    );


    // Ciclo de 12 segundos
    var ciclo_resp =
        resp_tempo mod 12;

    var texto_resp =
        "Breathe in slowly";

    var progresso_resp = 0;

    if (ciclo_resp < 4) {
        texto_resp =
            "Breathe in slowly";

        progresso_resp =
            ciclo_resp / 4;
    }
    else if (ciclo_resp < 6) {
        texto_resp =
            "Hold gently";

        progresso_resp = 1;
    }
    else {
        texto_resp =
            "Breathe out slowly";

        progresso_resp =
            1 - ((ciclo_resp - 6) / 6);
    }


    draw_set_alpha(0.88);
    draw_set_color(cor_texto);

    draw_text_transformed(
        636,
        225,
        texto_resp,
        1.12,
        1.12,
        0
    );


    // Círculos respiratórios
    var raio_resp =
        60
        + progresso_resp * 42;

    if (global.config_reduzir_animacoes) {
        raio_resp = 82;
    }

    draw_set_alpha(0.07);
    draw_set_color(cor_slider);

    draw_circle(
        636,
        390,
        raio_resp + 24,
        false
    );

    draw_set_alpha(0.13);

    draw_circle(
        636,
        390,
        raio_resp + 12,
        false
    );

    draw_set_alpha(0.19);

    draw_circle(
        636,
        390,
        raio_resp,
        false
    );

    draw_set_alpha(0.54);
    draw_set_color(cor_borda);

    draw_circle(
        636,
        390,
        raio_resp,
        true
    );


    draw_set_alpha(0.58);
    draw_set_color(cor_texto);

    draw_text(
        636,
        525,
        "Stay here for as long as you need."
    );


    // Botão voltar
    var sensorial_draw_x1 = 515;
    var sensorial_draw_y1 = 590;
    var sensorial_draw_x2 = 765;
    var sensorial_draw_y2 = 646;

    var sensorial_draw_mouse =
        point_in_rectangle(
            mouse_gui_x,
            mouse_gui_y,
            sensorial_draw_x1,
            sensorial_draw_y1,
            sensorial_draw_x2,
            sensorial_draw_y2
        );

    draw_set_alpha(0.74);

    draw_set_color(
        sensorial_draw_mouse
        ? cor_hover
        : cor_normal
    );

    draw_roundrect(
        sensorial_draw_x1,
        sensorial_draw_y1,
        sensorial_draw_x2,
        sensorial_draw_y2,
        false
    );

    draw_set_alpha(
        sensorial_draw_mouse
        ? 0.82
        : 0.38
    );

    draw_set_color(cor_borda);

    draw_roundrect(
        sensorial_draw_x1,
        sensorial_draw_y1,
        sensorial_draw_x2,
        sensorial_draw_y2,
        true
    );

    draw_set_alpha(1);
    draw_set_color(cor_texto);

    draw_text(
        640,
        (
            sensorial_draw_y1
            + sensorial_draw_y2
        ) / 2,
        "Back"
    );
}


// ═════════════════════════════════════════════
// CONFIGURAÇÕES
// ═════════════════════════════════════════════
if (tela_pause == 2 && false) {
    var cfg_draw_y = [
        195,
        260,
        325,
        390,
        455,
        520,
        585,
        675
    ];

    var cfg_draw_barra_x1 = 650;
    var cfg_draw_barra_x2 = 1060;


    // Título
    draw_set_alpha(1);
    draw_set_color(cor_texto);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_text_transformed(
        636,
        105,
        "Settings",
        1.50,
        1.50,
        0
    );

    draw_set_alpha(0.18);
    draw_set_color(cor_borda);

    draw_line(
        470,
        145,
        802,
        145
    );


    // Destaque da opção
    for (
        var cfg_draw_i = 0;
        cfg_draw_i < 7;
        cfg_draw_i++
    ) {
        if (
            config_opcao_atual
            == cfg_draw_i
        ) {
            draw_set_alpha(0.075);
            draw_set_color(cor_hover);

            draw_roundrect(
                130,
                cfg_draw_y[cfg_draw_i] - 25,
                1135,
                cfg_draw_y[cfg_draw_i] + 25,
                false
            );

            draw_set_alpha(0.14);
            draw_set_color(cor_borda);

            draw_roundrect(
                130,
                cfg_draw_y[cfg_draw_i] - 25,
                1135,
                cfg_draw_y[cfg_draw_i] + 25,
                true
            );
        }
    }


    // Textos
    draw_set_alpha(0.94);
    draw_set_color(cor_texto);

    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);

    draw_text_transformed(
        165,
        cfg_draw_y[0],
        "Music volume",
        1.08,
        1.08,
        0
    );

    draw_text_transformed(
        165,
        cfg_draw_y[1],
        "Sound volume",
        1.08,
        1.08,
        0
    );

    draw_text_transformed(
        165,
        cfg_draw_y[2],
        "Low-stimulation mode",
        1.08,
        1.08,
        0
    );

    draw_text_transformed(
        165,
        cfg_draw_y[3],
        "Reduce motion",
        1.08,
        1.08,
        0
    );

    draw_text_transformed(
        165,
        cfg_draw_y[4],
        "Text speed",
        1.08,
        1.08,
        0
    );

    draw_text_transformed(
        165,
        cfg_draw_y[5],
        "Text size",
        1.08,
        1.08,
        0
    );

    draw_text_transformed(
        165,
        cfg_draw_y[6],
        "Contrast",
        1.08,
        1.08,
        0
    );


    // Slider da música
    draw_set_alpha(0.58);
    draw_set_color(cor_desativado);

    draw_roundrect(
        cfg_draw_barra_x1,
        cfg_draw_y[0] - 4,
        cfg_draw_barra_x2,
        cfg_draw_y[0] + 4,
        false
    );

    var cfg_musica_x = lerp(
        cfg_draw_barra_x1,
        cfg_draw_barra_x2,
        global.config_volume_musica
    );

    draw_set_alpha(0.88);
    draw_set_color(cor_slider);

    draw_roundrect(
        cfg_draw_barra_x1,
        cfg_draw_y[0] - 4,
        cfg_musica_x,
        cfg_draw_y[0] + 4,
        false
    );

    draw_circle(
        cfg_musica_x,
        cfg_draw_y[0],
        12,
        false
    );

    draw_set_color(cor_borda);

    draw_circle(
        cfg_musica_x,
        cfg_draw_y[0],
        12,
        true
    );


    // Slider dos sons
    draw_set_alpha(0.58);
    draw_set_color(cor_desativado);

    draw_roundrect(
        cfg_draw_barra_x1,
        cfg_draw_y[1] - 4,
        cfg_draw_barra_x2,
        cfg_draw_y[1] + 4,
        false
    );

    var cfg_sons_x = lerp(
        cfg_draw_barra_x1,
        cfg_draw_barra_x2,
        global.config_volume_sons
    );

    draw_set_alpha(0.88);
    draw_set_color(cor_slider);

    draw_roundrect(
        cfg_draw_barra_x1,
        cfg_draw_y[1] - 4,
        cfg_sons_x,
        cfg_draw_y[1] + 4,
        false
    );

    draw_circle(
        cfg_sons_x,
        cfg_draw_y[1],
        12,
        false
    );

    draw_set_color(cor_borda);

    draw_circle(
        cfg_sons_x,
        cfg_draw_y[1],
        12,
        true
    );


    // Interruptores
    var cfg_switch_x1 = 955;
    var cfg_switch_x2 = 1050;
    var cfg_switch_h = 38;


    // Baixo estímulo
    draw_set_alpha(0.88);

    draw_set_color(
        global.config_baixo_estimulo
        ? cor_slider
        : cor_desativado
    );

    draw_roundrect(
        cfg_switch_x1,
        cfg_draw_y[2] - cfg_switch_h / 2,
        cfg_switch_x2,
        cfg_draw_y[2] + cfg_switch_h / 2,
        false
    );

    var cfg_estimulo_x =
        global.config_baixo_estimulo
        ? cfg_switch_x2 - 20
        : cfg_switch_x1 + 20;

    draw_set_color(cor_interno);

    draw_circle(
        cfg_estimulo_x,
        cfg_draw_y[2],
        15,
        false
    );

    draw_set_color(cor_borda);

    draw_circle(
        cfg_estimulo_x,
        cfg_draw_y[2],
        15,
        true
    );


    // Reduzir animações
    draw_set_color(
        global.config_reduzir_animacoes
        ? cor_slider
        : cor_desativado
    );

    draw_roundrect(
        cfg_switch_x1,
        cfg_draw_y[3] - cfg_switch_h / 2,
        cfg_switch_x2,
        cfg_draw_y[3] + cfg_switch_h / 2,
        false
    );

    var cfg_animacao_x =
        global.config_reduzir_animacoes
        ? cfg_switch_x2 - 20
        : cfg_switch_x1 + 20;

    draw_set_color(cor_interno);

    draw_circle(
        cfg_animacao_x,
        cfg_draw_y[3],
        15,
        false
    );

    draw_set_color(cor_borda);

    draw_circle(
        cfg_animacao_x,
        cfg_draw_y[3],
        15,
        true
    );


    // Textos das opções
    var cfg_textos_velocidade = [
        "Slow",
        "Normal",
        "Fast"
    ];

    var cfg_textos_tamanho = [
        "Small",
        "Normal",
        "Large"
    ];

    var cfg_textos_contraste = [
        "Normal",
        "High"
    ];

    draw_set_alpha(1);
    draw_set_color(cor_texto);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);


    // Velocidade
    draw_text_transformed(
        700,
        cfg_draw_y[4],
        "<",
        1.20,
        1.20,
        0
    );

    draw_text_transformed(
        855,
        cfg_draw_y[4],
        cfg_textos_velocidade[
            global.config_velocidade_texto
        ],
        1.06,
        1.06,
        0
    );

    draw_text_transformed(
        1010,
        cfg_draw_y[4],
        ">",
        1.20,
        1.20,
        0
    );


    // Tamanho
    draw_text_transformed(
        700,
        cfg_draw_y[5],
        "<",
        1.20,
        1.20,
        0
    );

    draw_text_transformed(
        855,
        cfg_draw_y[5],
        cfg_textos_tamanho[
            global.config_tamanho_texto
        ],
        1.06,
        1.06,
        0
    );

    draw_text_transformed(
        1010,
        cfg_draw_y[5],
        ">",
        1.20,
        1.20,
        0
    );


    // Contraste
    draw_text_transformed(
        700,
        cfg_draw_y[6],
        "<",
        1.20,
        1.20,
        0
    );

    draw_text_transformed(
        855,
        cfg_draw_y[6],
        cfg_textos_contraste[
            global.config_contraste
        ],
        1.06,
        1.06,
        0
    );

    draw_text_transformed(
        1010,
        cfg_draw_y[6],
        ">",
        1.20,
        1.20,
        0
    );


    // Botão voltar
    var cfg_draw_voltar_x1 = 515;
    var cfg_draw_voltar_y1 = 645;
    var cfg_draw_voltar_x2 = 765;
    var cfg_draw_voltar_y2 = 705;

    var cfg_draw_mouse_voltar =
        point_in_rectangle(
            mouse_gui_x,
            mouse_gui_y,
            cfg_draw_voltar_x1,
            cfg_draw_voltar_y1,
            cfg_draw_voltar_x2,
            cfg_draw_voltar_y2
        );

    draw_set_alpha(0.74);

    draw_set_color(
        cfg_draw_mouse_voltar
        ? cor_hover
        : cor_normal
    );

    draw_roundrect(
        cfg_draw_voltar_x1,
        cfg_draw_voltar_y1,
        cfg_draw_voltar_x2,
        cfg_draw_voltar_y2,
        false
    );

    draw_set_alpha(
        cfg_draw_mouse_voltar
        ? 0.82
        : 0.38
    );

    draw_set_color(cor_borda);

    draw_roundrect(
        cfg_draw_voltar_x1,
        cfg_draw_voltar_y1,
        cfg_draw_voltar_x2,
        cfg_draw_voltar_y2,
        true
    );

    draw_set_alpha(1);
    draw_set_color(cor_texto);

    draw_text(
        640,
        (
            cfg_draw_voltar_y1
            + cfg_draw_voltar_y2
        ) / 2,
        "Back"
    );
}


// ═════════════════════════════════════════════
// CONFIGURAÇÕES — MESMO ÁLBUM DO MENU INICIAL
// ═════════════════════════════════════════════
if (tela_pause == 2) {
    var pcfg_y = [205, 275, 345, 415, 485, 555, 625, 720];
    var pcfg_barra_x1 = 650;
    var pcfg_barra_x2 = 1060;

    var pcfg_painel = make_color_rgb(220, 212, 244);
    var pcfg_interno = alto_contraste
        ? c_white
        : make_color_rgb(255, 249, 239);
    var pcfg_sombra_papel = make_color_rgb(226, 211, 205);
    var pcfg_texto = alto_contraste
        ? make_color_rgb(20, 22, 34)
        : make_color_rgb(57, 66, 107);
    var pcfg_borda = alto_contraste
        ? make_color_rgb(48, 38, 86)
        : make_color_rgb(121, 111, 164);
    var pcfg_rosa = make_color_rgb(239, 205, 226);
    var pcfg_lilas = make_color_rgb(220, 212, 244);
    var pcfg_menta = make_color_rgb(198, 237, 220);
    var pcfg_azul = make_color_rgb(205, 228, 245);
    var pcfg_slider = make_color_rgb(137, 187, 174);
    var pcfg_desativado = make_color_rgb(225, 219, 226);
    var pcfg_decoracao = global.config_baixo_estimulo ? 0.45 : 1;
    var pcfg_cores_cartao = [
        pcfg_azul,
        pcfg_lilas,
        pcfg_menta,
        pcfg_rosa,
        pcfg_azul,
        pcfg_lilas,
        pcfg_menta
    ];

    // Sombra, capa lilás e página de papel creme.
    draw_set_alpha(0.14);
    draw_set_color(make_color_rgb(32, 41, 68));
    draw_roundrect(107, 78, 1177, 758, false);

    draw_set_alpha(0.98);
    draw_set_color(pcfg_painel);
    draw_roundrect(100, 70, 1170, 750, false);

    draw_set_alpha(1);
    draw_set_color(pcfg_interno);
    draw_roundrect(118, 88, 1152, 732, false);

    draw_set_alpha(0.70);
    draw_set_color(pcfg_borda);
    draw_roundrect(100, 70, 1170, 750, true);

    // Fita pastel do título.
    draw_set_alpha(0.88);
    draw_set_color(pcfg_rosa);
    draw_roundrect(485, 91, 785, 149, false);
    draw_set_alpha(0.40);
    draw_set_color(pcfg_borda);
    draw_roundrect(485, 91, 785, 149, true);

    draw_set_alpha(1);
    draw_set_color(pcfg_texto);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(635, 120, "Configurações", 1.52, 1.52, 0);

    // Cartões de papel pastel, na mesma ordem e posição do menu inicial.
    for (var pcfg_i = 0; pcfg_i < 7; pcfg_i++) {
        var pcfg_selecionado = config_opcao_atual == pcfg_i;

        draw_set_alpha(pcfg_selecionado ? 0.18 : 0.08);
        draw_set_color(pcfg_sombra_papel);
        draw_roundrect(139, pcfg_y[pcfg_i] - 24, 1139, pcfg_y[pcfg_i] + 29, false);

        draw_set_alpha(pcfg_selecionado ? 0.48 : 0.22);
        draw_set_color(pcfg_cores_cartao[pcfg_i]);
        draw_roundrect(135, pcfg_y[pcfg_i] - 27, 1135, pcfg_y[pcfg_i] + 27, false);

        draw_set_alpha(pcfg_selecionado ? 0.70 : 0.24);
        draw_set_color(pcfg_borda);
        draw_roundrect(135, pcfg_y[pcfg_i] - 27, 1135, pcfg_y[pcfg_i] + 27, true);

        draw_set_alpha(pcfg_selecionado ? 0.76 : 0.38);
        draw_set_color(pcfg_i mod 2 == 0 ? pcfg_rosa : pcfg_menta);
        draw_roundrect(151, pcfg_y[pcfg_i] - 31, 193, pcfg_y[pcfg_i] - 21, false);
    }

    // Ramos completos, sem sobrepor tres icones pequenos no mesmo canto.
    desenhar_raminho_ajustes_pause(132, 132, false, 0.84 * pcfg_decoracao);
    desenhar_raminho_ajustes_pause(1128, 704, true, 0.82 * pcfg_decoracao);

    draw_set_alpha(0.78 * pcfg_decoracao);
    draw_set_color(pcfg_rosa);
    draw_circle(1119, 112, 5, false);
    draw_set_color(pcfg_menta);
    draw_circle(1135, 123, 3, false);

    // Nomes das configurações.
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_set_color(pcfg_texto);
    draw_set_alpha(0.95);
    draw_text_transformed(165, pcfg_y[0], "Volume da música", 1.12, 1.12, 0);
    draw_text_transformed(165, pcfg_y[1], "Volume dos sons", 1.12, 1.12, 0);
    draw_text_transformed(165, pcfg_y[2], "Modo baixo estímulo", 1.12, 1.12, 0);
    draw_text_transformed(165, pcfg_y[3], "Reduzir animações", 1.12, 1.12, 0);
    draw_text_transformed(165, pcfg_y[4], "Velocidade do texto", 1.12, 1.12, 0);
    draw_text_transformed(165, pcfg_y[5], "Tamanho do texto", 1.12, 1.12, 0);
    draw_text_transformed(165, pcfg_y[6], "Contraste", 1.12, 1.12, 0);

    // Sliders de música e efeitos.
    draw_set_alpha(0.64);
    draw_set_color(pcfg_sombra_papel);
    draw_roundrect(pcfg_barra_x1, pcfg_y[0] - 4, pcfg_barra_x2, pcfg_y[0] + 4, false);
    var pcfg_musica_x = lerp(pcfg_barra_x1, pcfg_barra_x2, global.config_volume_musica);
    draw_set_alpha(0.95);
    draw_set_color(pcfg_slider);
    draw_roundrect(pcfg_barra_x1, pcfg_y[0] - 4, pcfg_musica_x, pcfg_y[0] + 4, false);
    draw_circle(pcfg_musica_x, pcfg_y[0], 12, false);
    draw_set_color(pcfg_interno);
    draw_circle(pcfg_musica_x, pcfg_y[0], 7, false);
    draw_set_color(pcfg_rosa);
    draw_circle(pcfg_musica_x, pcfg_y[0], 3, false);
    draw_set_color(pcfg_borda);
    draw_circle(pcfg_musica_x, pcfg_y[0], 12, true);

    draw_set_alpha(0.64);
    draw_set_color(pcfg_sombra_papel);
    draw_roundrect(pcfg_barra_x1, pcfg_y[1] - 4, pcfg_barra_x2, pcfg_y[1] + 4, false);
    var pcfg_sons_x = lerp(pcfg_barra_x1, pcfg_barra_x2, global.config_volume_sons);
    draw_set_alpha(0.95);
    draw_set_color(pcfg_slider);
    draw_roundrect(pcfg_barra_x1, pcfg_y[1] - 4, pcfg_sons_x, pcfg_y[1] + 4, false);
    draw_circle(pcfg_sons_x, pcfg_y[1], 12, false);
    draw_set_color(pcfg_interno);
    draw_circle(pcfg_sons_x, pcfg_y[1], 7, false);
    draw_set_color(pcfg_azul);
    draw_circle(pcfg_sons_x, pcfg_y[1], 3, false);
    draw_set_color(pcfg_borda);
    draw_circle(pcfg_sons_x, pcfg_y[1], 12, true);

    // Interruptores.
    var pcfg_switch_x1 = 958;
    var pcfg_switch_x2 = 1052;
    var pcfg_switch_h = 38;
    draw_set_alpha(0.95);
    draw_set_color(global.config_baixo_estimulo ? pcfg_menta : pcfg_desativado);
    draw_roundrect(pcfg_switch_x1, pcfg_y[2] - pcfg_switch_h / 2,
        pcfg_switch_x2, pcfg_y[2] + pcfg_switch_h / 2, false);
    var pcfg_estimulo_x = global.config_baixo_estimulo
        ? pcfg_switch_x2 - 20
        : pcfg_switch_x1 + 20;
    draw_set_color(pcfg_interno);
    draw_circle(pcfg_estimulo_x, pcfg_y[2], 15, false);
    draw_set_color(global.config_baixo_estimulo ? pcfg_slider : pcfg_rosa);
    draw_circle(pcfg_estimulo_x, pcfg_y[2], 4, false);
    draw_set_color(pcfg_borda);
    draw_circle(pcfg_estimulo_x, pcfg_y[2], 15, true);

    draw_set_color(global.config_reduzir_animacoes ? pcfg_menta : pcfg_desativado);
    draw_roundrect(pcfg_switch_x1, pcfg_y[3] - pcfg_switch_h / 2,
        pcfg_switch_x2, pcfg_y[3] + pcfg_switch_h / 2, false);
    var pcfg_animacao_x = global.config_reduzir_animacoes
        ? pcfg_switch_x2 - 20
        : pcfg_switch_x1 + 20;
    draw_set_color(pcfg_interno);
    draw_circle(pcfg_animacao_x, pcfg_y[3], 15, false);
    draw_set_color(global.config_reduzir_animacoes ? pcfg_slider : pcfg_rosa);
    draw_circle(pcfg_animacao_x, pcfg_y[3], 4, false);
    draw_set_color(pcfg_borda);
    draw_circle(pcfg_animacao_x, pcfg_y[3], 15, true);

    // Opções com setas e etiquetas de papel.
    var pcfg_velocidades = ["Lenta", "Normal", "Rápida"];
    var pcfg_tamanhos = ["Pequeno", "Normal", "Grande"];
    var pcfg_contrastes = ["Normal", "Alto"];

    for (var pcfg_valor_i = 4; pcfg_valor_i <= 6; pcfg_valor_i++) {
        draw_set_alpha(0.82);
        draw_set_color(pcfg_interno);
        draw_roundrect(744, pcfg_y[pcfg_valor_i] - 20, 966, pcfg_y[pcfg_valor_i] + 20, false);
        draw_set_alpha(0.36);
        draw_set_color(pcfg_borda);
        draw_roundrect(744, pcfg_y[pcfg_valor_i] - 20, 966, pcfg_y[pcfg_valor_i] + 20, true);
        draw_set_alpha(0.70);
        draw_set_color(pcfg_cores_cartao[pcfg_valor_i]);
        draw_circle(700, pcfg_y[pcfg_valor_i], 18, false);
        draw_circle(1010, pcfg_y[pcfg_valor_i], 18, false);
    }

    draw_set_alpha(1);
    draw_set_color(pcfg_texto);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(700, pcfg_y[4], "<", 1.25, 1.25, 0);
    draw_text_transformed(855, pcfg_y[4], pcfg_velocidades[global.config_velocidade_texto], 1.12, 1.12, 0);
    draw_text_transformed(1010, pcfg_y[4], ">", 1.25, 1.25, 0);
    draw_text_transformed(700, pcfg_y[5], "<", 1.25, 1.25, 0);
    draw_text_transformed(855, pcfg_y[5], pcfg_tamanhos[global.config_tamanho_texto], 1.12, 1.12, 0);
    draw_text_transformed(1010, pcfg_y[5], ">", 1.25, 1.25, 0);
    draw_text_transformed(700, pcfg_y[6], "<", 1.25, 1.25, 0);
    draw_text_transformed(855, pcfg_y[6], pcfg_contrastes[global.config_contraste], 1.12, 1.12, 0);
    draw_text_transformed(1010, pcfg_y[6], ">", 1.25, 1.25, 0);

    // Botão Voltar igual ao do menu inicial.
    var pcfg_voltar_x1 = 520;
    var pcfg_voltar_y1 = pcfg_y[7] - 27;
    var pcfg_voltar_x2 = 750;
    var pcfg_voltar_y2 = pcfg_y[7] + 27;
    var pcfg_sobre_voltar = point_in_rectangle(
        mouse_gui_x, mouse_gui_y,
        pcfg_voltar_x1, pcfg_voltar_y1,
        pcfg_voltar_x2, pcfg_voltar_y2
    );
    draw_set_alpha(0.18);
    draw_set_color(pcfg_sombra_papel);
    draw_roundrect(pcfg_voltar_x1 + 3, pcfg_voltar_y1 + 4,
        pcfg_voltar_x2 + 3, pcfg_voltar_y2 + 4, false);
    draw_set_alpha(0.96);
    draw_set_color(pcfg_sobre_voltar ? pcfg_rosa : pcfg_interno);
    draw_roundrect(pcfg_voltar_x1, pcfg_voltar_y1,
        pcfg_voltar_x2, pcfg_voltar_y2, false);
    draw_set_alpha(pcfg_sobre_voltar ? 0.95 : 0.60);
    draw_set_color(pcfg_borda);
    draw_roundrect(pcfg_voltar_x1, pcfg_voltar_y1,
        pcfg_voltar_x2, pcfg_voltar_y2, true);
    draw_set_alpha(1);
    draw_set_color(pcfg_texto);
    draw_text_transformed(635, pcfg_y[7], "Voltar", 1.15, 1.15, 0);
}


// ═════════════════════════════════════════════
// RESTAURAR
// ═════════════════════════════════════════════
draw_set_alpha(1);
draw_set_color(c_white);

draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_set_font(-1);
