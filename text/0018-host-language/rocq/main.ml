let () =
  let t = Modes.Lam (Modes.lin, Modes.Tunit, Modes.Var Modes.O) in
  print_endline (match Modes.infer [] Modes.Runtime t with Some _ -> "accepted" | None -> "rejected");
  let e = Modes.Lam (Modes.ghost, Modes.Tunit, t) in
  print_endline (match Modes.erase [] e with Some (Modes.Ulam (Modes.Uvar Modes.O)) -> "erased to the identity" | _ -> "unexpected")
