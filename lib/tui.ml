open Minttea
open Yt

type screen = 
  | MainMenu
  | ConnectYouTube
  | RevokeYouTube

type model = {
  choices: string list;
  cursor: int;
  current_screen: screen;
}

let initial_model = 
  {
    cursor = 0;
    choices = [
      "Connect to YouTube";
      "Revoke YouTube Connection";
    ];
    current_screen = MainMenu;
  }

let init _model = Command.Noop

let update event model =
  match model.current_screen, event with
  | MainMenu, Event.KeyDown (Key "q" | Escape) -> (model, Command.Quit)
  | _, Event.KeyDown (Key "q" | Escape) -> 
      ({ model with current_screen = MainMenu }, Command.Noop)
  | MainMenu, Event.KeyDown (Up | Key "k") ->
      let cursor =
        if model.cursor = 0 then List.length model.choices - 1
        else model.cursor - 1
      in
      ({ model with cursor }, Command.Noop)
  | MainMenu, Event.KeyDown (Down | Key "j") ->
      let cursor =
        if model.cursor = List.length model.choices - 1 then 0
        else model.cursor + 1
      in
      ({ model with cursor }, Command.Noop)
  | MainMenu, Event.KeyDown (Enter | Space) ->
      let new_screen = 
        match List.nth model.choices model.cursor with
        | "Connect to YouTube" -> ConnectYouTube
        | "Revoke YouTube Connection" -> RevokeYouTube
        | _ -> MainMenu
      in
      ({ model with current_screen = new_screen }, Command.Noop)
  | _, _ -> (model, Command.Noop)

let view model =
  match model.current_screen with
  | MainMenu ->
      let options =
        model.choices
        |> List.mapi (fun idx name ->
               let cursor = if model.cursor = idx then ">" else " " in
               Format.sprintf "%s %s" cursor name)
        |> String.concat "\n"
      in
      Format.sprintf
        {|
YouTube Connection Options:

%s

Press Enter to select, q to quit.

      |} options

  | ConnectYouTube ->
     Printf.sprintf {|
Connecting to YouTube...

1. Open your web browser.
2. Go to the authorization URL: %s
3. Grant permissions to the app.

Press q to return to the main menu.
      |} @@ generateYtAuthUrl ()

  | RevokeYouTube ->
      {|
Revoking YouTube Connection...

1. Confirming your request.
2. Removing stored credentials.
3. Notifying YouTube about the revocation.

Press q to return to the main menu.
      |}

let app = app ~init ~update ~view ()
