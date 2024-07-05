let parseEnv key =
  Dotenv.export () |> ignore;
  Sys.getenv_opt key

let readEnv key =
  match parseEnv key with
  | Some value -> value
  | None ->
    print_endline ("environment variable " ^ key ^ " not found");
    exit 1
