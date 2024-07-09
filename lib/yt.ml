open Lwt
open Utils
open Env

let generateYtAuthUrl () =
  let scope = readEnv "SCOPE" in
  generateUrl scope

let rec check_file_continuously path interval file_found =
  Lwt_unix.file_exists path >>= fun exists ->
    if exists then
      read_json_file path >>= function
      | Some access_token ->
        print_endline access_token;
        Lwt.return_unit
      | None ->
        Lwt_io.printf "Access token not found in file." >>= fun () ->
          Lwt_unix.sleep interval >>= fun () ->
            check_file_continuously path interval file_found
    else
      Lwt_unix.sleep interval >>= fun () ->
        check_file_continuously path interval file_found
