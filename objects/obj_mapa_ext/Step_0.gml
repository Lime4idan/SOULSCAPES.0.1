pode_interagir = false;

if (instance_exists(obj_Kiran)) {

    var distancia = point_distance(
        x,
        y,
        obj_Kiran.x,
        obj_Kiran.y
    );

    if (distancia <= dist_interacao) {

        pode_interagir = true;

        if (
            keyboard_check_pressed(ord("E"))
            || (variable_global_exists("mobile_interact_pressed") && global.mobile_interact_pressed)
        ) {
            room_goto(sala_destino);
        }
    }
}
