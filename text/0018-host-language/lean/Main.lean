import Modes

def main : IO Unit := do
  IO.println (repr (infer [] .runtime (.lam lin .unit (.var 0))))
  IO.println (repr (erase [] (.lam ghost .unit (.lam lin .unit (.var 0)))))
