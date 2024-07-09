(* open Minttea *)
(* open Tui *)

module Start = struct
  let start () =
    Auth.start ();
    (* start app ~initial_model *)
end
