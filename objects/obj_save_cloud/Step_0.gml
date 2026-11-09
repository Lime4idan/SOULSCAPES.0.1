// Reaplica o estado depois que os Create Events da room terminarem.
if (global.soul_restore_pending && room == global.soul_restore_room) {
    var _kiran = instance_find(obj_Kiran, 0);

    if (_kiran != noone) {
        apply_save_globals(global.soul_restore_data);

        if (variable_struct_exists(global.soul_restore_data, "kiran_x")) {
            _kiran.x = global.soul_restore_data.kiran_x;
        }
        if (variable_struct_exists(global.soul_restore_data, "kiran_y")) {
            _kiran.y = global.soul_restore_data.kiran_y;
        }

        global.soul_restore_pending = false;
        global.soul_save_status = "Partida carregada";
        last_room = room;
        last_save_ms = current_time;
    }
}

// Salva alguns instantes depois de cada troca de room.
if (room != last_room) {
    last_room = room;
    room_save_delay = room == rm_menu ? -1 : 45;
}

if (room_save_delay >= 0) {
    room_save_delay--;
    if (room_save_delay <= 0) {
        room_save_delay = -1;
        save_now();
    }
}

// Autosave frequente. Evita perder batalhas, oferendas ou dialogos recentes.
if (
    room != rm_menu
    && !global.soul_restore_pending
    && current_time - last_save_ms >= autosave_interval_ms
) {
    save_now();
}
