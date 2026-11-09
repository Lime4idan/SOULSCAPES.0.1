// Soulscapes - save local com sincronizacao segura no Supabase.
// A chave abaixo e publica por projeto. A chave administrativa nunca fica no jogo.
supabase_url = "https://lskexxyrbhyfchxwvlcn.supabase.co";
supabase_key = "sb_publishable_a9cSyZssVy2jzIyK6legEg_nxu0_9_d";
auth_redirect_url = "https://gx.games/games/bdwxxw/soulscapes-demo-2026/";
auth_redirect_url_encoded = "https%3A%2F%2Fgx.games%2Fgames%2Fbdwxxw%2Fsoulscapes-demo-2026%2F";

save_file = "soulscapes_save.json";
session_file = "soulscapes_session.json";

access_token = "";
refresh_token = "";
user_id = "";
account_email = "";
account_guest = true;
upload_local_after_auth = false;

auth_request = -1;
auth_mode = "";
load_request = -1;
load_user_id = "";
save_request = -1;

last_room = room;
room_save_delay = -1;
last_save_ms = current_time;
autosave_interval_ms = 12000;

global.soul_save_system_ready = true;
global.soul_cloud_ready = false;
global.soul_cloud_online = false;
global.soul_save_exists = false;
global.soul_pending_save = 0;
global.soul_restore_pending = false;
global.soul_restore_room = -1;
global.soul_restore_data = 0;
global.soul_save_status = "Preparando save...";
global.soul_account_email = "";
global.soul_account_guest = true;
global.soul_account_busy = false;
global.soul_account_message = "Jogando como convidado";
global.soul_account_error = "";

read_text_file = function(_path) {
    if (!file_exists(_path)) return "";

    var _file = file_text_open_read(_path);
    var _text = "";

    while (!file_text_eof(_file)) {
        _text += file_text_read_string(_file);
        file_text_readln(_file);
    }

    file_text_close(_file);
    return _text;
};

write_text_file = function(_path, _text) {
    var _file = file_text_open_write(_path);
    file_text_write_string(_file, _text);
    file_text_close(_file);
};

parse_json_safe = function(_text) {
    if (string_length(_text) <= 0) return 0;

    try {
        return json_parse(_text);
    }
    catch (_erro) {
        return 0;
    }
};

build_save = function() {
    var _kiran = instance_find(obj_Kiran, 0);
    var _kx = _kiran != noone ? _kiran.x : 0;
    var _ky = _kiran != noone ? _kiran.y : 0;

    return {
        version: 3,
        room_name: room_get_name(room),
        kiran_x: _kx,
        kiran_y: _ky,
        vida_kiran: variable_global_exists("vida_kiran") ? global.vida_kiran : 100,
        vida_kiran_max: variable_global_exists("vida_kiran_max") ? global.vida_kiran_max : 100,
        tem_fragmento: variable_global_exists("tem_fragmento") ? global.tem_fragmento : false,
        tem_espada_fragmento: variable_global_exists("tem_espada_fragmento") ? global.tem_espada_fragmento : false,
        guardas_recusados: variable_global_exists("guardas_recusados") ? global.guardas_recusados : [0, 0, 0, 0],
        fragmento_reconhecido: variable_global_exists("fragmento_reconhecido") ? global.fragmento_reconhecido : false,
        lorun_apresentada: variable_global_exists("lorun_apresentada") ? global.lorun_apresentada : false,
        dialogo_inicial_mostrado: variable_global_exists("dialogo_inicial_mostrado") ? global.dialogo_inicial_mostrado : false,
        tutorial_controles_mostrado: variable_global_exists("tutorial_controles_mostrado") ? global.tutorial_controles_mostrado : false,
        tutorial_controles_pendente: variable_global_exists("tutorial_controles_pendente") ? global.tutorial_controles_pendente : false,
        florakii_roteiro_visto: variable_global_exists("florakii_roteiro_visto") ? global.florakii_roteiro_visto : false,
        guardas_roteiro_visto: variable_global_exists("guardas_roteiro_visto") ? global.guardas_roteiro_visto : [false, false, false, false],
        vitral_resolvido: variable_global_exists("vitral_resolvido") ? global.vitral_resolvido : false,
        fragmentos_vitral: variable_global_exists("fragmentos_vitral") ? global.fragmentos_vitral : [false, false, false, false],
        inventario_itens: variable_global_exists("inventario_itens") ? global.inventario_itens : [],
        inventario_armas: variable_global_exists("inventario_armas") ? global.inventario_armas : [],
        inventario_roupas: variable_global_exists("inventario_roupas") ? global.inventario_roupas : [],
        inventario_colecionaveis: variable_global_exists("inventario_colecionaveis") ? global.inventario_colecionaveis : [],
        inventario_missoes: variable_global_exists("inventario_missoes") ? global.inventario_missoes : [],
        inimigos_derrotados: variable_global_exists("inimigos_derrotados") ? global.inimigos_derrotados : [false, false, false, false],
        itens_curativos_coletados: variable_global_exists("itens_curativos_coletados") ? global.itens_curativos_coletados : [],
        comandante_partiu: variable_global_exists("comandante_partiu") ? global.comandante_partiu : false,
        comandante_conhecida: variable_global_exists("comandante_conhecida") ? global.comandante_conhecida : false,
        encontro_rainha_iniciado: variable_global_exists("encontro_rainha_iniciado") ? global.encontro_rainha_iniciado : false,
        capitulo_concluido: variable_global_exists("capitulo_concluido") ? global.capitulo_concluido : false,
        pontos_florakii: variable_global_exists("pontos_florakii") ? global.pontos_florakii : 0,
        pontos_dahlia: variable_global_exists("pontos_dahlia") ? global.pontos_dahlia : 0,
        pontos_neutro: variable_global_exists("pontos_neutro") ? global.pontos_neutro : 0,
        escolhas_rota_usadas: variable_global_exists("escolhas_rota_usadas") ? global.escolhas_rota_usadas : []
    };
};

apply_save_globals = function(_data) {
    if (!is_struct(_data)) return false;

    if (variable_struct_exists(_data, "vida_kiran")) global.vida_kiran = _data.vida_kiran;
    if (variable_struct_exists(_data, "vida_kiran_max")) global.vida_kiran_max = _data.vida_kiran_max;
    if (variable_struct_exists(_data, "tem_fragmento")) global.tem_fragmento = _data.tem_fragmento;
    if (variable_struct_exists(_data, "tem_espada_fragmento")) global.tem_espada_fragmento = _data.tem_espada_fragmento;
    if (variable_struct_exists(_data, "guardas_recusados")) global.guardas_recusados = _data.guardas_recusados;
    if (variable_struct_exists(_data, "fragmento_reconhecido")) global.fragmento_reconhecido = _data.fragmento_reconhecido;
    if (variable_struct_exists(_data, "lorun_apresentada")) global.lorun_apresentada = _data.lorun_apresentada;
    if (variable_struct_exists(_data, "dialogo_inicial_mostrado")) global.dialogo_inicial_mostrado = _data.dialogo_inicial_mostrado;
    if (variable_struct_exists(_data, "tutorial_controles_mostrado")) global.tutorial_controles_mostrado = _data.tutorial_controles_mostrado;
    if (variable_struct_exists(_data, "tutorial_controles_pendente")) global.tutorial_controles_pendente = _data.tutorial_controles_pendente;
    if (variable_struct_exists(_data, "florakii_roteiro_visto")) global.florakii_roteiro_visto = _data.florakii_roteiro_visto;
    if (variable_struct_exists(_data, "guardas_roteiro_visto")) global.guardas_roteiro_visto = _data.guardas_roteiro_visto;
    if (variable_struct_exists(_data, "vitral_resolvido")) global.vitral_resolvido = _data.vitral_resolvido;
    if (variable_struct_exists(_data, "fragmentos_vitral")) global.fragmentos_vitral = _data.fragmentos_vitral;
    if (variable_struct_exists(_data, "inventario_itens")) global.inventario_itens = _data.inventario_itens;
    if (variable_struct_exists(_data, "inventario_armas")) global.inventario_armas = _data.inventario_armas;
    if (variable_struct_exists(_data, "inventario_roupas")) global.inventario_roupas = _data.inventario_roupas;
    if (variable_struct_exists(_data, "inventario_colecionaveis")) global.inventario_colecionaveis = _data.inventario_colecionaveis;
    if (variable_struct_exists(_data, "inventario_missoes")) global.inventario_missoes = _data.inventario_missoes;
    if (variable_struct_exists(_data, "inimigos_derrotados")) global.inimigos_derrotados = _data.inimigos_derrotados;
    if (variable_struct_exists(_data, "itens_curativos_coletados")) global.itens_curativos_coletados = _data.itens_curativos_coletados;
    if (variable_struct_exists(_data, "comandante_partiu")) global.comandante_partiu = _data.comandante_partiu;
    if (variable_struct_exists(_data, "comandante_conhecida")) global.comandante_conhecida = _data.comandante_conhecida;
    if (variable_struct_exists(_data, "encontro_rainha_iniciado")) global.encontro_rainha_iniciado = _data.encontro_rainha_iniciado;
    if (variable_struct_exists(_data, "capitulo_concluido")) global.capitulo_concluido = _data.capitulo_concluido;
    if (variable_struct_exists(_data, "pontos_florakii")) global.pontos_florakii = _data.pontos_florakii;
    if (variable_struct_exists(_data, "pontos_dahlia")) global.pontos_dahlia = _data.pontos_dahlia;
    if (variable_struct_exists(_data, "pontos_neutro")) global.pontos_neutro = _data.pontos_neutro;
    if (variable_struct_exists(_data, "escolhas_rota_usadas")) global.escolhas_rota_usadas = _data.escolhas_rota_usadas;

    global.rotas_identidade_carregadas = true;
    return true;
};

save_session = function() {
    if (string_length(refresh_token) <= 0 || string_length(user_id) <= 0) return;

    write_text_file(session_file, json_stringify({
        access_token: access_token,
        refresh_token: refresh_token,
        user_id: user_id,
        email: account_email,
        guest: account_guest
    }));
};

auth_headers = function(_with_token) {
    var _headers = ds_map_create();
    _headers[? "apikey"] = supabase_key;
    _headers[? "Content-Type"] = "application/json";
    _headers[? "Accept"] = "application/json";
    _headers[? "Authorization"] = "Bearer " + (_with_token ? access_token : supabase_key);
    return _headers;
};

request_auth = function(_refresh) {
    if (auth_request != -1) return;

    var _headers = auth_headers(false);

    if (_refresh && string_length(refresh_token) > 0) {
        auth_mode = "refresh";
        auth_request = http_request(
            supabase_url + "/auth/v1/token?grant_type=refresh_token",
            "POST",
            _headers,
            json_stringify({refresh_token: refresh_token})
        );
    }
    else {
        auth_mode = "anonymous";
        auth_request = http_request(
            supabase_url + "/auth/v1/signup",
            "POST",
            _headers,
            "{}"
        );
    }

    ds_map_destroy(_headers);
};

request_email_auth = function(_email, _password, _create) {
    if (auth_request != -1) {
        global.soul_account_error = "Aguarde a conexao inicial terminar.";
        return false;
    }

    var _clean_email = string_lower(string_trim(_email));
    if (string_pos("@", _clean_email) <= 1) {
        global.soul_account_error = "Digite um e-mail valido.";
        return false;
    }
    if (string_length(_password) < 6) {
        global.soul_account_error = "Use uma senha com pelo menos 6 caracteres.";
        return false;
    }

    global.soul_account_busy = true;
    global.soul_account_error = "";
    global.soul_account_message = _create
        ? "Criando sua conta..."
        : "Entrando na sua conta...";
    auth_mode = _create ? "signup" : "signin";
    upload_local_after_auth = true;

    var _headers = auth_headers(false);
    var _endpoint = _create
        ? "/auth/v1/signup?redirect_to=" + auth_redirect_url_encoded
        : "/auth/v1/token?grant_type=password";

    auth_request = http_request(
        supabase_url + _endpoint,
        "POST",
        _headers,
        json_stringify({email: _clean_email, password: _password})
    );
    ds_map_destroy(_headers);
    return true;
};

request_confirmation_resend = function(_email) {
    if (auth_request != -1) {
        global.soul_account_error = "Aguarde a conexao atual terminar.";
        return false;
    }

    var _clean_email = string_lower(string_trim(_email));
    if (string_pos("@", _clean_email) <= 1) {
        global.soul_account_error = "Digite o e-mail usado no cadastro.";
        return false;
    }

    global.soul_account_busy = true;
    global.soul_account_error = "";
    global.soul_account_message = "Reenviando a confirmacao...";
    auth_mode = "resend";
    upload_local_after_auth = false;

    var _headers = auth_headers(false);
    auth_request = http_request(
        supabase_url + "/auth/v1/resend?redirect_to=" + auth_redirect_url_encoded,
        "POST",
        _headers,
        json_stringify({type: "signup", email: _clean_email})
    );
    ds_map_destroy(_headers);
    return true;
};

request_cloud_load = function() {
    if (load_request != -1 || string_length(access_token) <= 0 || string_length(user_id) <= 0) return;

    var _headers = auth_headers(true);
    load_user_id = user_id;
    load_request = http_request(
        supabase_url + "/rest/v1/player_saves?select=save_data,updated_at&user_id=eq." + user_id + "&limit=1",
        "GET",
        _headers,
        ""
    );
    ds_map_destroy(_headers);
};

upload_save_data = function(_save) {
    if (!is_struct(_save)) return false;
    if (save_request != -1 || string_length(access_token) <= 0 || string_length(user_id) <= 0) {
        return false;
    }

    var _headers = auth_headers(true);
    _headers[? "Prefer"] = "resolution=merge-duplicates,return=minimal";
    save_request = http_request(
        supabase_url + "/rest/v1/player_saves?on_conflict=user_id",
        "POST",
        _headers,
        json_stringify([{user_id: user_id, save_data: _save}])
    );
    ds_map_destroy(_headers);
    return true;
};

save_now = function() {
    if (room == rm_menu) return false;

    var _save = build_save();
    var _json = "";

    try {
        _json = json_stringify(_save);
    }
    catch (_erro) {
        global.soul_save_status = "Nao foi possivel montar o save";
        return false;
    }

    write_text_file(save_file, _json);
    global.soul_pending_save = _save;
    global.soul_save_exists = true;
    global.soul_save_status = "Progresso salvo";
    last_save_ms = current_time;

    upload_save_data(_save);

    return true;
};

continue_game = function() {
    if (!global.soul_save_exists || !is_struct(global.soul_pending_save)) return false;

    var _data = global.soul_pending_save;
    apply_save_globals(_data);

    var _target_room = Room1;
    if (variable_struct_exists(_data, "room_name")) {
        var _asset = asset_get_index(_data.room_name);
        if (_asset != -1) _target_room = _asset;
    }

    global.soul_restore_data = _data;
    global.soul_restore_room = _target_room;
    global.soul_restore_pending = true;
    room_goto(_target_room);
    return true;
};

prepare_new_game = function() {
    global.soul_restore_pending = false;
    global.soul_restore_data = 0;
    global.soul_pending_save = 0;
    global.soul_save_exists = false;
    room_save_delay = 45;
};

logout_account = function() {
    access_token = "";
    refresh_token = "";
    user_id = "";
    account_email = "";
    account_guest = true;
    upload_local_after_auth = false;

    if (file_exists(session_file)) file_delete(session_file);

    global.soul_cloud_online = false;
    global.soul_cloud_ready = false;
    global.soul_account_email = "";
    global.soul_account_guest = true;
    global.soul_account_busy = false;
    global.soul_account_error = "";
    global.soul_account_message = "Jogando como convidado";
    global.soul_save_status = global.soul_save_exists
        ? "Save local preservado"
        : "Criando sessao de convidado...";
    request_auth(false);
};

global.soul_save_now = function() {
    var _controller = instance_find(obj_save_cloud, 0);
    if (_controller == noone) return false;
    return _controller.save_now();
};

global.soul_continue_game = function() {
    var _controller = instance_find(obj_save_cloud, 0);
    if (_controller == noone) return false;
    return _controller.continue_game();
};

global.soul_prepare_new_game = function() {
    var _controller = instance_find(obj_save_cloud, 0);
    if (_controller != noone) _controller.prepare_new_game();
};

global.soul_account_sign_in = function(_email, _password) {
    var _controller = instance_find(obj_save_cloud, 0);
    if (_controller == noone) return false;
    return _controller.request_email_auth(_email, _password, false);
};

global.soul_account_sign_up = function(_email, _password) {
    var _controller = instance_find(obj_save_cloud, 0);
    if (_controller == noone) return false;
    return _controller.request_email_auth(_email, _password, true);
};

global.soul_account_resend = function(_email) {
    var _controller = instance_find(obj_save_cloud, 0);
    if (_controller == noone) return false;
    return _controller.request_confirmation_resend(_email);
};

global.soul_account_logout = function() {
    var _controller = instance_find(obj_save_cloud, 0);
    if (_controller != noone) _controller.logout_account();
};

// O save local habilita Continuar imediatamente, mesmo sem internet.
var _local_text = read_text_file(save_file);
var _local_save = parse_json_safe(_local_text);
if (is_struct(_local_save)) {
    global.soul_pending_save = _local_save;
    global.soul_save_exists = true;
    global.soul_save_status = "Save local encontrado";
}

var _session = parse_json_safe(read_text_file(session_file));
if (is_struct(_session)) {
    if (variable_struct_exists(_session, "access_token")) access_token = _session.access_token;
    if (variable_struct_exists(_session, "refresh_token")) refresh_token = _session.refresh_token;
    if (variable_struct_exists(_session, "user_id")) user_id = _session.user_id;
    if (variable_struct_exists(_session, "email")) account_email = _session.email;
    if (variable_struct_exists(_session, "guest")) account_guest = _session.guest;
}

global.soul_account_email = account_email;
global.soul_account_guest = account_guest;
global.soul_account_message = account_guest
    ? "Jogando como convidado"
    : "Conta conectada";

request_auth(string_length(refresh_token) > 0);
