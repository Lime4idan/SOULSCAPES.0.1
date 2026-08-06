// ─────────────────────────────────────────────────────────────────────────────
//  obj_kiran  |  STEP EVENT
// ─────────────────────────────────────────────────────────────────────────────

// ── 1. Block input during dialogue ──
if (global.dialogue_open) {
    hsp = 0;
    exit;
}
// ── 2. Decrement jump cooldown ─────────────────────────────────────────────
if (jump_cooldown > 0) jump_cooldown--;

// ── 3. Read input ──────────────────────────────────────────────────────────
key_left  = keyboard_check(vk_left)  || keyboard_check(ord("A"));
key_right = keyboard_check(vk_right) || keyboard_check(ord("D"));
key_run   = keyboard_check(vk_shift);

var jump_held = keyboard_check(ord("Z")) || keyboard_check(ord("X"));

if (!jump_held) {
    jump_key_released = true;
}

key_jump = jump_held && jump_key_released && (jump_cooldown == 0);

// ── 4. Ground detection with coyote time ──────────────────────────────────
var on_ground_raw = place_meeting(x, y + ground_tolerance, obj_solid);

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

// ── 5. Choose speed cap and acceleration ──────────────────────────────────
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

// ── 6. Horizontal acceleration / friction ─────────────────────────────────
if (key_right) hsp += accel_to_use;
if (key_left)  hsp -= accel_to_use;

if (!key_left && !key_right) {
    hsp *= move_fric;
    if (abs(hsp) < 0.1) hsp = 0;
}

hsp = clamp(hsp, -spd_cap, spd_cap);

// ── 7. Update facing ONLY while moving ────────────────────────────────────
if (hsp > 0.1)       facing =  1;
else if (hsp < -0.1) facing = -1;

// ── 8. Gravity and jump ────────────────────────────────────────────────────
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
}

vsp = min(vsp, 12);

// ── 9. Horizontal collision resolution ────────────────────────────────────
if (hsp != 0) {
    var hsp_sign  = sign(hsp);
    var hsp_steps = abs(round(hsp));
    repeat (hsp_steps) {
        if (!place_meeting(x + hsp_sign, y, obj_solid)) {
            x += hsp_sign;
        } else {
            hsp = 0;
            break;
        }
    }
}

// ── 10. Vertical collision resolution ─────────────────────────────────────
if (vsp != 0) {
    var vsp_sign  = sign(vsp);
    var vsp_steps = abs(round(vsp));
    repeat (vsp_steps) {
        if (!place_meeting(x, y + vsp_sign, obj_solid)) {
            y += vsp_sign;
        } else {
            vsp = 0;
            break;
        }
    }
}

// ── SEGURANÇA: Desprende do chão se entrar nele ──
while (place_meeting(x, y, obj_solid)) {
    y -= 1;
}

// ── 11. Sprite animation ───────────────────────────────────────────────────
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

image_xscale = facing;
if (
    variable_global_exists("jogo_pausado")
    && global.jogo_pausado
) {
    hsp = 0;
    exit;
}
