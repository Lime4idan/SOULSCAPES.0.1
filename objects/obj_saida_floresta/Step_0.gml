if (
    instance_exists(obj_Kiran)
    && point_distance(x, y, obj_Kiran.x, obj_Kiran.y) < dist_interacao
) {

    if (
        current_time >= global.transicao_room_bloqueada_ate
        && (
            keyboard_check_pressed(ord("E"))
            || (variable_global_exists("mobile_interact_pressed") && global.mobile_interact_pressed)
        )
    ) {
        global.transicao_room_bloqueada_ate = current_time + 450;
        global.mobile_transition_wait_release = true;
        global.mobile_interact_pressed = false;

        with (obj_Kiran) {
            mobile_interact_buffer = 0;
            mobile_room_touch_lock = true;
        }

        room_goto(Room1);
    }
}
