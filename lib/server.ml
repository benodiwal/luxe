open Cohttp_lwt_unix

type server_control = {
  mutable continue_running: bool;
  mutable capture_code: string option;
}

let create_server port control =
  let callback _conn req _body =
    let uri = req |> Request.uri in
    let query_params = Uri.query uri in
    let code = match List.assoc_opt "code" query_params with
           | Some (codes) -> Some (List.hd codes)
           | None -> None
    in
    begin
      match code with
      | Some code ->
        control.capture_code <- Some code;
        control.continue_running <- false;  
      | None -> ()
    end;
    let html_body = Printf.sprintf "
    <html>
        <head><title>Authorization Success</title></head>
        <body>
          <h1>You are authorized</h1>
        </body>
      </html>
    " in
    Server.respond_string ~status:`OK ~body:html_body ()
  in
  Server.create ~mode:(`TCP (`Port port)) (Server.make ~callback ())
