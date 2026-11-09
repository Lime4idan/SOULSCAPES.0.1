if (point_distance(x, y, obj_Kiran.x, obj_Kiran.y) < dist_interacao) {

    if (
        keyboard_check_pressed(ord("E"))
        || (variable_global_exists("mobile_interact_pressed") && global.mobile_interact_pressed)
    ) {
        room_goto(Room4);
    }
}
