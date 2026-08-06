// ─────────────────────────────────────────────
//  obj_kiran  |  CREATE EVENT
// ─────────────────────────────────────────────

// Horizontal movement

hsp          = 0;
vsp          = 0;
move_accel   = 0.5;
move_fric    = 0.9;
move_spd_max = 2.5;      // walking max speed
run_spd_max  = 7;     // running max speed (Shift held)
run_accel    = 0.8;    // accelerates faster when running

// Vertical
grav       = 0.25;
jump_force = -5;

// Ground detection
on_ground        = false;
ground_tolerance = 2;

// Facing direction (1 = right, -1 = left)
facing = 1;

// Input flags
key_left  = 0;
key_right = 0;
key_jump  = 0;
key_run   = 0;

// Jump buffer (coyote time)
jump_buffer = 0;

// Jump cooldown + release flag
jump_cooldown     = 0;
jump_cooldown_max = 12;
jump_key_released = true;

// Sprite flicker fix
prev_sprite = -1;

// Fragile platform hook
current_spd_max = move_spd_max;

// Dialogue guard
if (!variable_global_exists("dialogue_open")) {
    global.dialogue_open = false;
}

view_object[0] = noone;   // desativa o follow padrão