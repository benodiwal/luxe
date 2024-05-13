open Luxe.Start

type command = 
  | Help of string
  | Version
  | Start

let parseArgs () =
  match Array.length Sys.argv with
  | 1 -> Help "No arguments provided !!"
  | 2 -> (
    match Sys.argv.(1) with
    | "help" | "-h" | "--help" -> Help "Help"
    | "version" -> Version
    | "start" -> Start
    | _ -> Help "Command not found !!"
  )
  | _ -> Help "Invalid number of arguments !!"

(* Version *)
let printVersion () = print_endline "0.0.1"

(* Help *)
let printHelpMsg () =
  print_endline {|
  Usage:
  luxe <command>
  
  Commands:
  help         Display this help message
  version      Display version information
  start        Start luxe (termial client) and log in to your YouTube account

  Options:
  -h, --help   Alternate command to display help message
  |}

let printMsg str = print_endline str

let help msg =
  printMsg msg;
  printHelpMsg ()

let action command =
  match command with
  | Help s -> help s
  | Version -> printVersion ()
  | Start -> Start.start ()

let () =
   parseArgs () |> action
