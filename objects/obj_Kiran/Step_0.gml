
      // ─────────────────────────────────────────────────────────────────────────────
//  obj_kiran  |  STEP EVENT
// ─────────────────────────────────────────────────────────────────────────────

var sala_rainha = room == Room6;

// ── Entrada mobile compartilhada ──────────────────────────────────────────
// É calculada antes dos bloqueios de pausa/diálogo para que todos os outros
// objetos recebam os toques no mesmo frame. Até cinco dedos são aceitos.
if (keyboard_check_pressed(vk_f10)) {
    global.mobile_mode = !global.mobile_mode;
}

// Caso a partida seja iniciada fora do menu, o primeiro toque também pode
// solicitar a tela cheia no player do GX.games.
if (
    global.mobile_mode
    && global.mobile_browser
    && !global.mobile_fullscreen_solicitado
    && device_mouse_check_button_pressed(0, mb_left)
) {
    window_set_fullscreen(true);
    global.mobile_fullscreen_solicitado = true;
}

global.mobile_left = false;
global.mobile_right = false;
global.mobile_run = false;
global.mobile_jump = false;
global.mobile_jump_pressed = false;
mobile_interact_buffer = max(0, mobile_interact_buffer - 1);
mobile_pause_buffer = max(0, mobile_pause_buffer - 1);
mobile_inventory_buffer = max(0, mobile_inventory_buffer - 1);
mobile_settings_buffer = max(0, mobile_settings_buffer - 1);
global.mobile_interact_pressed = mobile_interact_buffer > 0;
global.mobile_pause_pressed = mobile_pause_buffer > 0;
global.mobile_inventory_pressed = mobile_inventory_buffer > 0;
global.mobile_settings_pressed = mobile_settings_buffer > 0;

// Não reaproveita na room nova o mesmo toque que abriu a transição anterior.
// O bloqueio termina assim que todos os dedos forem retirados da tela.
var mobile_room_touch_blocked = mobile_room_touch_lock
    || (
        variable_global_exists("mobile_transition_wait_release")
        && global.mobile_transition_wait_release
    );
if (mobile_room_touch_blocked) {
    var mobile_room_touch_active = false;

    for (var mobile_room_touch = 0; mobile_room_touch < 5; mobile_room_touch++) {
        if (device_mouse_check_button(mobile_room_touch, mb_left)) {
            mobile_room_touch_active = true;
            break;
        }
    }

    if (!mobile_room_touch_active) {
        mobile_room_touch_lock = false;
        global.mobile_transition_wait_release = false;

        // Descarta também o buffer antigo. Assim, depois de soltar o dedo,
        // somente um toque realmente novo pode acionar outra transição.
        mobile_interact_buffer = 0;
        global.mobile_interact_pressed = false;
    }
}

var mobile_interface_livre = global.mobile_mode
    && !mobile_room_touch_blocked
    && !(variable_global_exists("jogo_pausado") && global.jogo_pausado)
    && !(variable_global_exists("dialogue_open") && global.dialogue_open)
    && (
        global.mobile_browser
            ? browser_width >= browser_height
            : display_get_width() >= display_get_height()
    );

if (mobile_interface_livre) {
    var mobile_gui_w = display_get_gui_width();
    var mobile_gui_h = display_get_gui_height();

    // Faixa segura acima da moldura. O desenho e as áreas de toque usam
    // exatamente estes retângulos para não haver botão "fantasma".
    var mobile_controls_y1 = mobile_gui_h - 242;
    var mobile_controls_y2 = mobile_gui_h - 128;
    var mobile_left_x1 = 54;
    var mobile_left_x2 = 176;
    var mobile_right_x1 = 176;
    var mobile_right_x2 = 298;
    var mobile_action_x1 = mobile_gui_w - 412;
    var mobile_action_x2 = mobile_gui_w - 218;
    var mobile_jump_x1 = mobile_gui_w - 204;
    var mobile_jump_x2 = mobile_gui_w - 30;
    var mobile_pause_x1 = mobile_gui_w - 124;
    var mobile_pause_y1 = 60;
    var mobile_pause_x2 = mobile_gui_w - 56;
    var mobile_pause_y2 = 132;
    var mobile_settings_x1 = mobile_gui_w - 282;
    var mobile_settings_x2 = mobile_gui_w - 136;
    var mobile_inventory_x1 = mobile_gui_w - 418;
    var mobile_inventory_x2 = mobile_gui_w - 294;

    for (var mobile_touch = 0; mobile_touch < 5; mobile_touch++) {
        if (!device_mouse_check_button(mobile_touch, mb_left)) continue;

        var mobile_touch_x = device_mouse_x_to_gui(mobile_touch);
        var mobile_touch_y = device_mouse_y_to_gui(mobile_touch);
        var mobile_pressed = device_mouse_check_button_pressed(
            mobile_touch,
            mb_left
        );

        if (point_in_rectangle(
            mobile_touch_x,
            mobile_touch_y,
            mobile_left_x1,
            mobile_controls_y1,
            mobile_left_x2,
            mobile_controls_y2
        )) {
            global.mobile_left = true;
        }
        else if (point_in_rectangle(
            mobile_touch_x,
            mobile_touch_y,
            mobile_right_x1,
            mobile_controls_y1,
            mobile_right_x2,
            mobile_controls_y2
        )) {
            global.mobile_right = true;
        }
        else if (point_in_rectangle(
            mobile_touch_x,
            mobile_touch_y,
            mobile_jump_x1,
            mobile_controls_y1,
            mobile_jump_x2,
            mobile_controls_y2
        )) {
            global.mobile_jump = true;
            global.mobile_jump_pressed = global.mobile_jump_pressed
                || mobile_pressed;
        }
        else if (point_in_rectangle(
            mobile_touch_x,
            mobile_touch_y,
            mobile_action_x1,
            mobile_controls_y1,
            mobile_action_x2,
            mobile_controls_y2
        )) {
            if (mobile_pressed) mobile_interact_buffer = 2;
            global.mobile_interact_pressed = mobile_interact_buffer > 0;
        }
        else if (point_in_rectangle(
            mobile_touch_x,
            mobile_touch_y,
            mobile_inventory_x1,
            mobile_pause_y1,
            mobile_inventory_x2,
            mobile_pause_y2
        )) {
            if (mobile_pressed) mobile_inventory_buffer = 2;
            global.mobile_inventory_pressed = mobile_inventory_buffer > 0;
        }
        else if (point_in_rectangle(
            mobile_touch_x,
            mobile_touch_y,
            mobile_settings_x1,
            mobile_pause_y1,
            mobile_settings_x2,
            mobile_pause_y2
        )) {
            if (mobile_pressed) mobile_settings_buffer = 2;
            global.mobile_settings_pressed = mobile_settings_buffer > 0;
        }
        else if (point_in_rectangle(
            mobile_touch_x,
            mobile_touch_y,
            mobile_pause_x1,
            mobile_pause_y1,
            mobile_pause_x2,
            mobile_pause_y2
        )) {
            if (mobile_pressed) mobile_pause_buffer = 2;
            global.mobile_pause_pressed = mobile_pause_buffer > 0;
        }
    }

    mobile_left_hold = global.mobile_left ? mobile_left_hold + 1 : 0;
    mobile_right_hold = global.mobile_right ? mobile_right_hold + 1 : 0;
    global.mobile_run = mobile_left_hold >= 18 || mobile_right_hold >= 18;
}
else {
    mobile_left_hold = 0;
    mobile_right_hold = 0;
}

// ── 1. Pausa e posição segura ─────────────────────────────────────────────
if (
    variable_global_exists("jogo_pausado")
    && global.jogo_pausado
) {
    hsp = 0;
    exit;
}

// Se outro objeto ou uma troca de room colocar Kiran dentro de um sólido,
// voltar uma única vez à última posição válida em vez de empurrá-lo sem limite.
if (
    (!sala_rainha && place_meeting(x, y, obj_solid))
    || place_meeting(x, y, obj_comandante)
) {
    x = posicao_segura_x;
    y = posicao_segura_y;
    hsp = 0;
    vsp = 0;
}
else {
    posicao_segura_x = x;
    posicao_segura_y = y;
}

// ── 2. Block input during dialogue ──
if (global.dialogue_open) {
    hsp = 0;

    // Não deixa o Espaço usado no diálogo virar um pulo ao fechar a caixa.
    if (
        keyboard_check(vk_space)
        || keyboard_check(ord("Z"))
        || keyboard_check(ord("X"))
    ) {
        jump_key_released = false;
    }

    exit;
}

if (sfx_passo_timer > 0) {
    sfx_passo_timer--;
}
// ── 3. Decrement jump cooldown ─────────────────────────────────────────────
if (jump_cooldown > 0) jump_cooldown--;

// ── 4. Read input ──────────────────────────────────────────────────────────
key_left  = keyboard_check(vk_left)
    || keyboard_check(ord("A"))
    || global.mobile_left;
key_right = keyboard_check(vk_right)
    || keyboard_check(ord("D"))
    || global.mobile_right;
key_run   = keyboard_check(vk_shift) || global.mobile_run;

var jump_held =
    keyboard_check(vk_space)
    || keyboard_check(ord("Z"))
    || keyboard_check(ord("X"))
    || global.mobile_jump;

if (!jump_held) {
    jump_key_released = true;
}

key_jump = (
        jump_held
        && jump_key_released
        && jump_cooldown == 0
    )
    || (
        global.mobile_jump_pressed
        && jump_cooldown == 0
    );

// ── 5. Ground detection with coyote time ──────────────────────────────────
// Room4 possui um lago no centro. A linha abaixo acompanha a trilha pintada
// no cenário, fazendo Kiran contornar a água em vez de flutuar sobre ela.
var caminho_especial = room == Room4 || room == Room5 || sala_rainha;
var caminho_room4_y = y;

if (room == Room4) {
    if (x < 220) caminho_room4_y = lerp(470, 485, clamp(x / 220, 0, 1));
    else if (x < 430) caminho_room4_y = lerp(485, 590, (x - 220) / 210);
    else if (x < 640) caminho_room4_y = lerp(590, 632, (x - 430) / 210);
    else if (x < 850) caminho_room4_y = lerp(632, 590, (x - 640) / 210);
    else if (x < 1060) caminho_room4_y = lerp(590, 490, (x - 850) / 210);
    else caminho_room4_y = lerp(490, 470, clamp((x - 1060) / 220, 0, 1));

}
else if (room == Room5) {
    // Pontos recalibrados pelo centro visual da faixa de terra de Room5.
    // O traçado anterior subia demais entre x=280 e x=620 e deixava Kiran
    // caminhar sobre a vegetação acima da trilha.
    if (x < 280) caminho_room4_y = lerp(438, 420, clamp(x / 280, 0, 1));
    else if (x < 620) caminho_room4_y = lerp(420, 410, (x - 280) / 340);
    else if (x < 980) caminho_room4_y = lerp(410, 420, (x - 620) / 360);
    else if (x < 1320) caminho_room4_y = lerp(420, 470, (x - 980) / 340);
    else caminho_room4_y = lerp(470, 525, clamp((x - 1320) / 410, 0, 1));
}
else if (sala_rainha) {
    caminho_room4_y = 470;
}

// Cruzou a trilha durante uma queda: pousa exatamente sobre ela.
if (caminho_especial && vsp >= 0 && y >= caminho_room4_y) {
    y = caminho_room4_y;
    vsp = 0;
}

var on_ground_raw = (!sala_rainha && place_meeting(x, y + ground_tolerance, obj_solid))
    || place_meeting(x, y + ground_tolerance, obj_comandante)
    || (caminho_especial && abs(y - caminho_room4_y) <= ground_tolerance + 1 && vsp >= 0);

// O pouso toca somente quando Kiran realmente vinha caindo.
if (on_ground_raw && !sfx_no_chao_anterior && vsp > 1) {
    global.tocar_sfx(global.sfx_aterrissar, 0.24, random_range(0.97, 1.03));
}

if (on_ground_raw) {
    jump_buffer = 3;
    on_ground   = true;
} else {
    if (jump_buffer > 0) {
        jump_buffer--;
        on_ground = true;
    } else {
        on_ground = false;
    }
}

// ── 6. Choose speed cap and acceleration ──────────────────────────────────
var accel_to_use;
var spd_cap;

if (key_run) {
    accel_to_use = run_accel;
    spd_cap      = run_spd_max;
} else {
    accel_to_use = move_accel;
    spd_cap      = move_spd_max;
}

current_spd_max = spd_cap;

// ── 7. Horizontal acceleration / friction ─────────────────────────────────
if (key_right) hsp += accel_to_use;
if (key_left)  hsp -= accel_to_use;

if (!key_left && !key_right) {
    hsp *= move_fric;
    if (abs(hsp) < 0.1) hsp = 0;
}

hsp = clamp(hsp, -spd_cap, spd_cap);

// ── 8. Update facing ONLY while moving ────────────────────────────────────
if (hsp > 0.1)       facing =  1;
else if (hsp < -0.1) facing = -1;

// ── 9. Gravity and jump ────────────────────────────────────────────────────
if (!on_ground) {
    vsp += grav;
} else {
    if (vsp > 0) vsp = 0;
}

if (key_jump && on_ground) {
    vsp               = jump_force;
    on_ground         = false;
    jump_buffer       = 0;
    jump_cooldown     = jump_cooldown_max;
    jump_key_released = false;
    global.tocar_sfx(global.sfx_pulo, 0.25, random_range(0.99, 1.03));
}

vsp = min(vsp, 12);

// ── 10. Horizontal collision resolution ───────────────────────────────────
if (hsp != 0) {
    var hsp_sign  = sign(hsp);
    var hsp_steps = abs(round(hsp));
    repeat (hsp_steps) {
        if (
            (sala_rainha || !place_meeting(x + hsp_sign, y, obj_solid))
            && !place_meeting(x + hsp_sign, y, obj_comandante)
            && (!sala_rainha || (x + hsp_sign >= 180 && x + hsp_sign <= 1260))
        ) {
            x += hsp_sign;
        } else {
            hsp = 0;
            break;
        }
    }

    // Enquanto caminha, acompanha suavemente a curva do caminho de Room4.
    if (caminho_especial && on_ground) {
        if (room == Room4) {
            if (x < 220) caminho_room4_y = lerp(470, 485, clamp(x / 220, 0, 1));
            else if (x < 430) caminho_room4_y = lerp(485, 590, (x - 220) / 210);
            else if (x < 640) caminho_room4_y = lerp(590, 632, (x - 430) / 210);
            else if (x < 850) caminho_room4_y = lerp(632, 590, (x - 640) / 210);
            else if (x < 1060) caminho_room4_y = lerp(590, 490, (x - 850) / 210);
            else caminho_room4_y = lerp(490, 470, clamp((x - 1060) / 220, 0, 1));
        }
        else if (room == Room5) {
            if (x < 280) caminho_room4_y = lerp(438, 420, clamp(x / 280, 0, 1));
            else if (x < 620) caminho_room4_y = lerp(420, 410, (x - 280) / 340);
            else if (x < 980) caminho_room4_y = lerp(410, 420, (x - 620) / 360);
            else if (x < 1320) caminho_room4_y = lerp(420, 470, (x - 980) / 340);
            else caminho_room4_y = lerp(470, 525, clamp((x - 1320) / 410, 0, 1));
        }
        else {
            caminho_room4_y = 470;
            x = clamp(x, 180, 1260);
        }
        y = caminho_room4_y;
        vsp = 0;
    }
}

// ── 11. Vertical collision resolution ─────────────────────────────────────
if (vsp != 0) {
    var vsp_sign  = sign(vsp);
    var vsp_steps = abs(round(vsp));
    repeat (vsp_steps) {
        var caminho_room4_bloqueia_queda = caminho_especial
            && vsp_sign > 0
            && y + vsp_sign >= caminho_room4_y;

        if (
            !caminho_room4_bloqueia_queda
            && (sala_rainha || !place_meeting(x, y + vsp_sign, obj_solid))
            && !place_meeting(x, y + vsp_sign, obj_comandante)
        ) {
            y += vsp_sign;
        } else {
            if (caminho_room4_bloqueia_queda) y = caminho_room4_y;
            vsp = 0;
            break;
        }
    }
}

// Guardar a posição somente depois que os dois eixos estiverem livres.
if (
    (sala_rainha || !place_meeting(x, y, obj_solid))
    && !place_meeting(x, y, obj_comandante)
) {
    posicao_segura_x = x;
    posicao_segura_y = y;
}

// Um passo por passada, com alternância sutil de tom. Correr reduz o intervalo.
if (on_ground && abs(hsp) > 0.35 && sfx_passo_timer <= 0) {
    sfx_passo_alternar = !sfx_passo_alternar;
    var sfx_passo_tom = (sfx_passo_alternar ? 1.04 : 0.94)
        * random_range(0.98, 1.02);
    global.tocar_sfx(
        global.sfx_passo,
        key_run ? 0.16 : 0.13,
        sfx_passo_tom
    );
    sfx_passo_timer = key_run ? 11 : 19;
}

sfx_no_chao_anterior = on_ground;

// ── 12. Sprite animation ───────────────────────────────────────────────────
var target_sprite;

if (!on_ground) {
    target_sprite = (vsp < 0) ? spr_kiran_jump_rise : spr_kiran_jump_fall;
} else if (key_run && abs(hsp) > 0.5) {
    target_sprite = spr_kiran_run;
} else if (abs(hsp) > 0.2) {
    target_sprite = spr_kiran_walk;
} else {
    target_sprite = spr_kiran_idle;
}

if (sprite_index != target_sprite) {
    sprite_index = target_sprite;
    image_index  = 0;
    image_speed  = 1;
}

// ANDAR - aumentado
if (sprite_index == spr_kiran_walk) {
    image_speed = lerp(2.0, 2.0, abs(hsp) / move_spd_max);
}

// CORRER - aumentado
if (sprite_index == spr_kiran_run) {
    image_speed = lerp(0.6, 1.0, abs(hsp) / run_spd_max);
}

// PULO - mantém igual
if (sprite_index == spr_kiran_jump_rise || sprite_index == spr_kiran_jump_fall) {
    if (image_index >= sprite_get_number(sprite_index) - 1) {
        image_speed = 0;
        image_index = sprite_get_number(sprite_index) - 1;
    } else {
        image_speed = 1;
    }
}

// A escala da instância precisa permanecer em 1: no GameMaker ela também
// transforma a máscara de colisão. A pequena correção visual do sprite de
// corrida é aplicada somente no Draw Event.
// Na Room6 a própria escala da instância é usada porque o objeto não possui
// Draw Event registrado no arquivo que o editor continua sobrescrevendo.
// As colisões sólidas já são ignoradas nessa sala e o piso é virtual, então a
// escala menor não volta a travar a movimentação.
var escala_room6 = sala_rainha ? 0.72 : 1;
image_xscale = facing * escala_room6;
image_yscale = escala_room6;
