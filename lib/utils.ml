open Env
open Lwt
open Yojson.Basic.Util

let generateUrl scope redirect_uri =
  let client_id = readEnv "CLIENT_ID" in
  let redirect_uri = redirect_uri in
  let scope = scope in
  let state = "random" in
  let response_type = readEnv "RESPONSE_TYPE" in
  let authorization_url = readEnv "AUTHORIZATION_URL" in
  let access_type = readEnv "ACCESS_TYPE" in
  let auth_url = Printf.sprintf "%s?client_id=%s&redirect_uri=%s&scope=%s&state=%s&response_type=%s&access_type=%s"
  authorization_url client_id redirect_uri scope state response_type access_type in
  auth_url

let get_home_dir () =
  try Sys.getenv "HOME"
  with Not_found ->
    Sys.getenv "USERPROFILE"

let read_json_file path =
  Lwt_io.with_file ~mode:Input path (fun channel ->
    Lwt_io.read channel >>= fun content ->
    let json = Yojson.Basic.from_string content in
    let name = json |> member "name" |> to_string_option in
    Lwt.return name
  )
