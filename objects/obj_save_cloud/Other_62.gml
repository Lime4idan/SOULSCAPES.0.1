var _request_id = async_load[? "id"];

// O evento HTTP tambem e chamado enquanto a resposta ainda esta baixando.
// Nesse momento o status vale 1 e ainda nao existe uma resposta completa para
// interpretar. Esperar o callback final evita marcar requisicoes parciais como
// falha e impede que o id seja liberado antes da hora.
var _event_status = ds_map_exists(async_load, "status")
    ? async_load[? "status"]
    : 0;

if (_event_status == 1) exit;

var _http_status = ds_map_exists(async_load, "http_status")
    ? async_load[? "http_status"]
    : 0;
var _result = ds_map_exists(async_load, "result")
    ? async_load[? "result"]
    : "";

if (_request_id == auth_request) {
    auth_request = -1;
    global.soul_account_busy = false;

    if (_http_status >= 200 && _http_status < 300) {
        var _auth = parse_json_safe(_result);

        if (auth_mode == "resend") {
            global.soul_account_message = "Novo e-mail enviado. Use apenas o link mais recente.";
            global.soul_account_error = "";
            upload_local_after_auth = false;
        }
        else if (is_struct(_auth) && variable_struct_exists(_auth, "access_token")) {
            access_token = _auth.access_token;
            refresh_token = _auth.refresh_token;
            user_id = _auth.user.id;

            var _email_recebido = "";
            if (
                variable_struct_exists(_auth, "user")
                && is_struct(_auth.user)
                && variable_struct_exists(_auth.user, "email")
            ) {
                _email_recebido = string(_auth.user.email);
            }

            account_email = auth_mode == "anonymous" ? "" : _email_recebido;
            account_guest = auth_mode == "anonymous" || string_length(account_email) <= 0;
            global.soul_account_email = account_email;
            global.soul_account_guest = account_guest;
            global.soul_account_error = "";
            global.soul_account_message = account_guest
                ? "Jogando como convidado"
                : (auth_mode == "signup" ? "Conta criada e conectada" : "Conta conectada");
            save_session();

            global.soul_cloud_online = true;
            global.soul_save_status = "Nuvem conectada";
            request_cloud_load();
        }
        else if (auth_mode == "signup" && is_struct(_auth)) {
            // Projetos que exigem confirmacao de e-mail criam o cadastro sem
            // entregar uma sessao. O convidado atual continua valido.
            global.soul_account_message = "Conta criada. Confira seu e-mail para confirmar.";
            global.soul_account_error = "";
            upload_local_after_auth = false;
        }
    }
    else if (auth_mode == "refresh") {
        // A sessao venceu ou foi revogada. Um novo jogador anonimo e criado.
        access_token = "";
        refresh_token = "";
        user_id = "";
        account_email = "";
        account_guest = true;
        global.soul_account_email = "";
        global.soul_account_guest = true;
        global.soul_account_message = "Sessao expirada. Jogando como convidado.";
        request_auth(false);
    }
    else {
        global.soul_cloud_online = false;
        global.soul_cloud_ready = true;
        global.soul_save_status = global.soul_save_exists
            ? "Usando save local"
            : "Nuvem indisponivel";

        var _erro_auth = parse_json_safe(_result);
        var _mensagem_auth = "";
        if (is_struct(_erro_auth)) {
            if (variable_struct_exists(_erro_auth, "message")) {
                _mensagem_auth = string(_erro_auth.message);
            }
            else if (variable_struct_exists(_erro_auth, "msg")) {
                _mensagem_auth = string(_erro_auth.msg);
            }
            else if (variable_struct_exists(_erro_auth, "error_description")) {
                _mensagem_auth = string(_erro_auth.error_description);
            }
        }

        var _mensagem_minuscula = string_lower(_mensagem_auth);
        if (string_pos("invalid login", _mensagem_minuscula) > 0) {
            global.soul_account_error = "E-mail ou senha incorretos.";
        }
        else if (string_pos("already registered", _mensagem_minuscula) > 0) {
            global.soul_account_error = "Este e-mail ja tem uma conta.";
        }
        else if (string_pos("email not confirmed", _mensagem_minuscula) > 0) {
            global.soul_account_error = "Confirme seu e-mail antes de entrar.";
        }
        else if (string_pos("rate limit", _mensagem_minuscula) > 0) {
            global.soul_account_error = "Muitos e-mails enviados. Aguarde alguns minutos.";
        }
        else if (
            string_pos("password", _mensagem_minuscula) > 0
            && string_pos("6", _mensagem_minuscula) > 0
        ) {
            global.soul_account_error = "Use uma senha com pelo menos 6 caracteres.";
        }
        else {
            global.soul_account_error = "Nao foi possivel conectar. Tente novamente.";
        }
        global.soul_account_message = account_guest
            ? "Seu progresso continua salvo neste dispositivo."
            : "A conta continua conectada neste dispositivo.";
        upload_local_after_auth = false;
    }
}

if (_request_id == load_request) {
    var _load_response_user = load_user_id;
    load_request = -1;
    load_user_id = "";

    // Se a conta mudou enquanto a resposta estava a caminho, descarte o
    // retorno antigo e busque novamente usando a sessao atual.
    if (_load_response_user != user_id) {
        request_cloud_load();
        exit;
    }

    if (_http_status >= 200 && _http_status < 300) {
        var _rows = parse_json_safe(_result);

        if (is_array(_rows) && array_length(_rows) > 0) {
            var _cloud_save = _rows[0].save_data;

            if (is_struct(_cloud_save)) {
                global.soul_pending_save = _cloud_save;
                global.soul_save_exists = true;
                write_text_file(save_file, json_stringify(_cloud_save));
                global.soul_save_status = "Save da nuvem encontrado";
            }
        }
        else if (global.soul_save_exists && is_struct(global.soul_pending_save)) {
            // Uma conta nova ainda nao tem save remoto. Envia a copia local
            // inclusive a partir do menu, sem exigir que o jogador entre numa room.
            upload_save_data(global.soul_pending_save);
        }

        upload_local_after_auth = false;

        global.soul_cloud_ready = true;
        global.soul_cloud_online = true;
    }
    else {
        global.soul_cloud_ready = true;
        global.soul_cloud_online = false;
        global.soul_save_status = global.soul_save_exists
            ? "Usando save local"
            : "Nao foi possivel carregar a nuvem";
    }
}

if (_request_id == save_request) {
    save_request = -1;

    if (_http_status >= 200 && _http_status < 300) {
        global.soul_cloud_online = true;
        global.soul_save_status = "Progresso salvo na nuvem";
    }
    else {
        global.soul_cloud_online = false;
        global.soul_save_status = "Progresso salvo neste dispositivo";
    }
}
