// Só faz algo quando Kiran estiver voltando do templo
if (!global.voltando_do_templo) {
    exit;
}


// Espera o jogador existir na sala
if (!instance_exists(obj_Kiran)) {
    exit;
}

var jogador = instance_find(
    obj_Kiran,
    0
);


// Colocar Kiran diante da entrada
jogador.x = x;
jogador.y = y;

jogador.hsp = 0;
jogador.vsp = 0;


// Encerrar o retorno
global.voltando_do_templo = false;