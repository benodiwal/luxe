open Env

let generateAuthUrl () =
  let client_id = readEnv "CLIENT_ID" in
  let redirect_uri = readEnv "REDIRECT_URI" in
  let scope = readEnv "SCOPE" in
  let response_type = readEnv "RESPONSE_TYPE" in
  let authorization_url = "https://accounts.google.com/o/oauth2/auth" in
  let auth_url = Printf.sprintf "%s?client_id=%s&redirect_uri=%s&scope=%s&response_type=%s" authorization_url client_id redirect_uri scope response_type in
  auth_url

let port = 3000

let initiate_oauth_flow () =
  let server_thread = Lwt.async (fun () -> Server.local_server port) in
  let auth_url = generateAuthUrl () in
  print_endline auth_url;
  server_thread

let start () =
  let _server_thread = initiate_oauth_flow () in
  let forever, _ = Lwt.wait() in
  Lwt_main.run forever
