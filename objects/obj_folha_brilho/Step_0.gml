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
            current_time >= global.transicao_room_bloqueada_ate
            && (
                keyboard_check_pressed(ord("E"))
                || (variable_global_exists("mobile_interact_pressed") && global.mobile_interact_pressed)
            )
        ) {
            // Consome a interação e deixa uma pequena janela de segurança para
            // a nova room. No desktop o E continua respondendo imediatamente.
            global.transicao_room_bloqueada_ate = current_time + 450;
            global.mobile_transition_wait_release = true;

            if (variable_global_exists("mobile_interact_pressed")) {
                global.mobile_interact_pressed = false;
            }

            // Também funciona ao voltar para a Room1 persistente, onde o
            // Create de Kiran não roda novamente.
            with (obj_Kiran) {
                mobile_interact_buffer = 0;
                mobile_room_touch_lock = true;
            }

            room_goto(sala_destino);
        }
    }
}
