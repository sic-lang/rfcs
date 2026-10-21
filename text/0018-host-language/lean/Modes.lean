/-! Prototype: the modes of sic-lang/rfcs#16 on a minimal calculus.
A checker counting usages, an erasure to untyped terms, and the theorem that
well-typed programs erase without erased variables left at run time. -/

inductive Rel | erased | runtime
  deriving DecidableEq, Repr

inductive Use | linear | unrestricted
  deriving DecidableEq, Repr

structure Mode where
  rel : Rel
  use : Use
  deriving DecidableEq, Repr

inductive Ty | unit | arr (m : Mode) (a b : Ty)
  deriving DecidableEq, Repr

/-- Terms with de Bruijn indices; applications carry the mode of their argument. -/
inductive Term
  | var (n : Nat)
  | lam (m : Mode) (a : Ty) (t : Term)
  | app (m : Mode) (t u : Term)
  | unit
  deriving Repr

inductive Count | zero | one | many
  deriving DecidableEq, Repr

def Count.add : Count → Count → Count
  | .zero, c => c
  | c, .zero => c
  | _, _ => .many

def Count.scale : Use → Count → Count
  | .linear, c => c
  | .unrestricted, .zero => .zero
  | .unrestricted, _ => .many

abbrev Ctx := List (Mode × Ty)

/-- Infers the type of a term in position `p`, with the usage of each variable.
An occurrence counts for the usage of a variable when its relevance is the
position's: types may mention run-time variables freely, as in QTT, but erased
linear permissions are tracked. -/
def infer (Γ : Ctx) (p : Rel) : Term → Option (Ty × List Count)
  | .var n => do
    let (m, a) ← Γ[n]?
    if m.rel = .erased ∧ p = .runtime then none
    else
      let z := List.replicate Γ.length Count.zero
      some (a, if m.rel = p then z.set n .one else z)
  | .unit => some (.unit, List.replicate Γ.length .zero)
  | .lam m a t => do
    let (b, u) ← infer ((m, a) :: Γ) p t
    match u with
    | [] => none
    | c :: u' =>
      if m.use = .linear ∧ ¬(p = .erased ∧ m.rel = .runtime) ∧ c ≠ .one then none
      else some (.arr m a b, u')
  | .app m t s => do
    let (ft, u) ← infer Γ p t
    match ft with
    | .arr m' a b =>
      if m' ≠ m then none
      else
        let (a', v) ← infer Γ (if m.rel = .erased then .erased else p) s
        if a' ≠ a then none
        else some (b, List.zipWith Count.add u (v.map (Count.scale m.use)))
    | .unit => none

inductive UTerm | var (n : Nat) | lam (t : UTerm) | app (t u : UTerm) | unit
  deriving Repr

/-- The index of variable `n` once the erased variables of `ρ` are removed. -/
def runtimeIndex : List Rel → Nat → Option Nat
  | [], _ => none
  | .runtime :: _, 0 => some 0
  | .erased :: _, 0 => none
  | r :: ρ, n + 1 => (runtimeIndex ρ n).map fun k => if r = .runtime then k + 1 else k

def erase (ρ : List Rel) : Term → Option UTerm
  | .var n => UTerm.var <$> runtimeIndex ρ n
  | .unit => some .unit
  | .lam m _ t =>
    if m.rel = .runtime then UTerm.lam <$> erase (.runtime :: ρ) t
    else erase (.erased :: ρ) t
  | .app m t u =>
    if m.rel = .runtime then UTerm.app <$> erase ρ t <*> erase ρ u
    else erase ρ t

theorem runtimeIndex_isSome (ρ : List Rel) (n : Nat) (h : ρ[n]? = some .runtime) :
    (runtimeIndex ρ n).isSome := by
  induction ρ generalizing n with
  | nil => simp at h
  | cons r ρ ih =>
    cases n with
    | zero => cases r <;> simp_all [runtimeIndex]
    | succ n => cases r <;> simp_all [runtimeIndex]

theorem erase_isSome (t : Term) :
    ∀ (Γ : Ctx) (a : Ty) (u : List Count), infer Γ .runtime t = some (a, u) →
      (erase (Γ.map (·.1.rel)) t).isSome := by
  induction t with
  | var n =>
    intro Γ a u h
    simp only [infer] at h
    cases hn : Γ[n]? with
    | none => simp [hn] at h
    | some e =>
      obtain ⟨⟨r, us⟩, ty⟩ := e
      cases r with
      | erased => simp [hn] at h
      | runtime =>
        simp only [erase]
        have := runtimeIndex_isSome (Γ.map (·.1.rel)) n (by simp [hn])
        simpa using this
  | unit => intro _ _ _ _; simp [erase]
  | lam m ty t ih =>
    intro Γ a u h
    simp only [infer] at h
    cases hb : infer ((m, ty) :: Γ) .runtime t with
    | none => simp [hb] at h
    | some r =>
      have := ih ((m, ty) :: Γ) r.1 r.2 hb
      cases hm : m.rel <;> simp_all [erase]
  | app m t s ihf iha =>
    intro Γ a u h
    simp only [infer] at h
    cases ht : infer Γ .runtime t with
    | none => simp [ht] at h
    | some r =>
      obtain ⟨ft, ut⟩ := r
      have et := ihf Γ ft ut ht
      cases ft with
      | unit => simp [ht] at h
      | arr m' a' b =>
        cases hm : m.rel with
        | erased => simp [erase, hm, et]
        | runtime =>
          cases hs : infer Γ .runtime s with
          | none => simp_all
          | some r' =>
            have es := iha Γ r'.1 r'.2 hs
            simp only [erase, hm, if_true]
            revert et es
            cases erase (Γ.map (·.1.rel)) t <;> cases erase (Γ.map (·.1.rel)) s <;> simp <;> rfl

/-! Examples, evaluated by the compiled checker. -/

def lin : Mode := ⟨.runtime, .linear⟩
def ghost : Mode := ⟨.erased, .linear⟩
def unr : Mode := ⟨.runtime, .unrestricted⟩

-- The linear identity is accepted.
#eval (infer [] .runtime (.lam lin .unit (.var 0))).isSome
-- Duplicating a linear argument is rejected.
#eval (infer [] .runtime (.lam lin .unit (.app unr (.lam unr .unit (.var 0)) (.var 0)))).isSome
-- Dropping an erased linear permission is rejected.
#eval (infer [] .runtime (.lam ghost .unit .unit)).isSome
-- A function consuming an erased permission erases to the identity on its run-time argument.
#eval erase [] (.lam ghost .unit (.lam lin .unit (.var 0)))
