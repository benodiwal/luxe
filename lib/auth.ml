open Env

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

let initiate_oauth_flow () =
  let auth_url = generateAuthUrl () in
  print_endline auth_url;
  print_endline "\nAuthorizing ...\n"
  
let start () = initiate_oauth_flow ()
