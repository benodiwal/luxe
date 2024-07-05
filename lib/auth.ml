open Env
open Server
open Cohttp
open Cohttp_lwt_unix
open Lwt

let control = { continue_running = true; capture_code = None }

let generateAuthUrl () =
  let client_id = readEnv "CLIENT_ID" in
  let redirect_uri = readEnv "REDIRECT_URI" in
  let scope = readEnv "SCOPE" in
  let response_type = readEnv "RESPONSE_TYPE" in
  let authorization_url = readEnv "AUTHORIZATION_URL" in
  let auth_url = Printf.sprintf "%s?client_id=%s&redirect_uri=%s&scope=%s&response_type=%s" authorization_url client_id redirect_uri scope response_type in
  auth_url

let exchange_code_for_tokens code =
  let uri = Uri.of_string (readEnv "AUTHORIZATION_URL") in
  let body = Uri.encoded_of_query [
    ("code", [code]);
    ("client_id", [readEnv "CLIENT_ID"]);
    ("client_secret", [readEnv "CLIENT_SECRET"]);
    ("redirect_uri", [readEnv "REDIRECT_URI"]);
    ("grant_type", ["authorization_code"]);
  ] in
  let default_headers = Header.init () in
  let headers = Header.add default_headers "Content-Type" "application/x-www-form-urlencoded" in
  Client.post ~headers ~body:(`String body) uri
  >>= fun (resp, body) ->
    body |> Cohttp_lwt.Body.to_string >|= fun body ->
      match resp |> Response.status |> Code.code_of_status with
      | 200 -> `Success body
      | _ -> `Error body

let save_tokens encrypted_data =
  Lwt_io.with_file ~mode:Lwt_io.Output "tokens.dat" (fun f -> 
    Lwt_io.write f encrypted_data
)

let encrypt_data data =
  let key = readEnv "key" in
  String.mapi (fun i c -> char_of_int ((int_of_char c) lxor (int_of_char key.[i mod (String.length key)]))) data

let store_tokens tokens =
  let encrypt_tokens = encrypt_data tokens in
  save_tokens encrypt_tokens

let initiate_oauth_flow () =
  let port = int_of_string (readEnv "PORT") in
  let server = create_server port control in
  let server_thread = Lwt.async (fun () -> server) in
  let auth_url = generateAuthUrl () in
  print_endline auth_url;
  print_endline "\nAuthorizing ...\n";
  while control.continue_running do
    Lwt_unix.sleep 1.0 |> Lwt_main.run
  done;
  server_thread

let handle_oauth_flow () =
  match control.capture_code with
  | Some code ->
    Printf.printf "Captured Code: %s\n" code;
    exchange_code_for_tokens code >>= fun result ->
      (match result with
      | `Success tokens -> store_tokens tokens >>= fun () -> Lwt.return (Printf.printf "Tokens stored successfully.\n")
      | `Error error -> Lwt.return (Printf.printf "Failed to exchange code: %s\n" error))
  | None ->
    Lwt.return (Printf.printf "No code was captured\n")
  
let start () =
   let _server_thread = initiate_oauth_flow () in
   let handle_result =
    handle_oauth_flow () >>= fun () ->
      Lwt.return_unit
    in
    let forever, _ = Lwt.wait () in
    Lwt_main.run handle_result;
    Lwt_main.run forever
