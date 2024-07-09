open Lwt
open Tui
open Utils
open Env

let generateAuthUrl () = 
  let scope = "profile%20email%20openid" in
  let redirect_uri = readEnv "REDIRECT_URI" in
  generateUrl scope redirect_uri

let log_name name =
  print_endline ("Hi! " ^ name);
  Lwt.return_unit

let initaite_yt_flow () =
  Minttea.start app ~initial_model

let rec check_file_continuously path interval file_found =
  Lwt_unix.file_exists path >>= fun exists ->
  if exists then
    read_json_file path >>= function
    | Some name -> 
        log_name name >>= fun () ->
        file_found := true;
        initaite_yt_flow();
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
      | Some name ->
        log_name name >>= fun () ->
        initaite_yt_flow ();
        Lwt.return_unit
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
