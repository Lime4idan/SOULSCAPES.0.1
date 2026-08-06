distancia_interacao = 160;
pode_interagir = false;
conversa_finalizada = false;
etapa_conversa = 0;
fragmento_reconhecido = false;
if (!variable_global_exists("tem_fragmento")) {
    global.tem_fragmento = false;
}

if (!variable_global_exists("fragmento_reconhecido")) {
    global.fragmento_reconhecido = false;
}