open Env
open Lwt
open Yojson.Basic.Util

let generateAuthUrl () =
  let client_id = readEnv "CLIENT_ID" in
  let redirect_uri = readEnv "REDIRECT_URI" in
  let scope = "profile%20email%20openid" in
  let state = "randomstuff" in
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

let log_name name =
  Lwt_io.printlf "Hi! %s" name

let rec check_file_continuously path interval file_found =
  Lwt_unix.file_exists path >>= fun exists ->
  if exists then
    read_json_file path >>= function
    | Some name -> 
        log_name name >>= fun () ->
        file_found := true;
        Lwt.return_unit
    | None -> 
        Lwt_io.printl "Name not found in the file." >>= fun () ->
        Lwt_unix.sleep interval >>= fun () ->
        check_file_continuously path interval file_found
  else
    Lwt_unix.sleep interval >>= fun () ->
    check_file_continuously path interval file_found

let initiate_oauth_flow () =
  Display.render_content_for_auth ();
  let auth_url = generateAuthUrl () in
  Lwt_io.printl auth_url >>= fun () -> 
  Lwt_io.printl "\nAuthorizing ...\n"

let start () =
  let home_dir = get_home_dir () in
  let file_path = Filename.concat home_dir ".luxe.config" in
  let file_found = ref false in
  
  Lwt_main.run (
    Lwt_unix.file_exists file_path >>= fun exists ->
    if exists then
      read_json_file file_path >>= function
      | Some name -> log_name name
      | None -> Lwt_io.printl "Name not found in the file."
    else
      let background_check = check_file_continuously file_path 1.0 file_found in
      let auth_flow = initiate_oauth_flow () in
      
      Lwt.join [
        auth_flow;
        (background_check >>= fun () -> Lwt.return_unit)
      ] >>= fun () ->
      
      let rec wait_for_file () =
        if !file_found then
          Lwt.return_unit
        else
          Lwt_unix.sleep 1.0 >>= wait_for_file
      in
      
      wait_for_file ()
  )
