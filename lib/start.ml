let printAsciiArt () =
  print_endline {|
 _                
| |               
| |_   ___  _____ 
| | | | \ \/ / _ \
| | |_| |>  <  __/
|_|\__,_/_/\_\___|
                  
|}

let printWelcomeMessage () =
  
  print_endline {|
  Welcome to Luxe v0.0.1!

  Luxe is a command-line tool that allows you to interact with YouTube directly from your terminal.
  You can view live stream chats, upload videos, and more, all without leaving the comfort of your command line.
  
  To get started, log in with your Google account using OAuth:
  |}

module Start = struct
  let start () =
    printAsciiArt ();
    Auth.start ();
end
