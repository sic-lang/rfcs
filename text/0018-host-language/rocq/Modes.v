(* Prototype: the modes of sic-lang/rfcs#16 on a minimal calculus.
  A checker counting usages, an erasure to untyped terms, and the theorem that
  well-typed programs erase without erased variables left at run time. *)

From Stdlib Require Import List Bool.
Import ListNotations.

Inductive rel := erased | runtime.
Inductive use := linear | unrestricted.
Record mode := { mrel : rel; muse : use }.
Inductive ty := tunit | tarr (m : mode) (a b : ty).

(* Terms with de Bruijn indices; applications carry the mode of their argument. *)
Inductive term :=
  | var (n : nat)
  | lam (m : mode) (a : ty) (t : term)
  | app (m : mode) (t u : term)
  | unit.

Inductive count := zero | one | many.

Definition rel_eqb a b := match a, b with erased, erased | runtime, runtime => true | _, _ => false end.
Definition use_eqb a b := match a, b with linear, linear | unrestricted, unrestricted => true | _, _ => false end.
Definition count_eqb a b := match a, b with zero, zero | one, one | many, many => true | _, _ => false end.
Definition mode_eqb m n := rel_eqb (mrel m) (mrel n) && use_eqb (muse m) (muse n).
Fixpoint ty_eqb a b :=
  match a, b with
  | tunit, tunit => true
  | tarr m a1 b1, tarr n a2 b2 => mode_eqb m n && ty_eqb a1 a2 && ty_eqb b1 b2
  | _, _ => false
  end.

Definition cadd c d := match c, d with zero, x => x | x, zero => x | _, _ => many end.
Definition cscale u c := match u, c with linear, x => x | unrestricted, zero => zero | unrestricted, _ => many end.

Fixpoint set_nth (l : list count) n v :=
  match l, n with
  | [], _ => []
  | _ :: l', 0 => v :: l'
  | x :: l', S n' => x :: set_nth l' n' v
  end.

Fixpoint zip_add (u v : list count) :=
  match u, v with
  | c :: u', d :: v' => cadd c d :: zip_add u' v'
  | _, _ => []
  end.

Definition ctx := list (mode * ty).

(* Infers the type of a term in position p, with the usage of each variable.
  An occurrence counts for the usage of a variable when its relevance is the
  position's: types may mention run-time variables freely, as in QTT, but
  erased linear permissions are tracked. *)
Fixpoint infer (G : ctx) (p : rel) (t : term) : option (ty * list count) :=
  match t with
  | var n =>
    match nth_error G n with
    | None => None
    | Some (m, a) =>
      match mrel m, p with
      | erased, runtime => None
      | r, _ =>
        let z := repeat zero (length G) in
        Some (a, if rel_eqb r p then set_nth z n one else z)
      end
    end
  | unit => Some (tunit, repeat zero (length G))
  | lam m a t =>
    match infer ((m, a) :: G) p t with
    | Some (b, c :: u') =>
      if use_eqb (muse m) linear && negb (rel_eqb p erased && rel_eqb (mrel m) runtime)
        && negb (count_eqb c one)
      then None else Some (tarr m a b, u')
    | _ => None
    end
  | app m t s =>
    match infer G p t with
    | Some (tarr m' a b, u) =>
      if mode_eqb m' m then
        match infer G (match mrel m with erased => erased | runtime => p end) s with
        | Some (a', v) => if ty_eqb a' a then Some (b, zip_add u (map (cscale (muse m)) v)) else None
        | None => None
        end
      else None
    | _ => None
    end
  end.

Inductive uterm := uvar (n : nat) | ulam (t : uterm) | uapp (t u : uterm) | uunit.

(* The index of variable n once the erased variables of rho are removed. *)
Fixpoint runtime_index (rho : list rel) (n : nat) : option nat :=
  match rho, n with
  | [], _ => None
  | runtime :: _, 0 => Some 0
  | erased :: _, 0 => None
  | r :: rho', S n' =>
    option_map (fun k => match r with runtime => S k | erased => k end) (runtime_index rho' n')
  end.

Fixpoint erase (rho : list rel) (t : term) : option uterm :=
  match t with
  | var n => option_map uvar (runtime_index rho n)
  | unit => Some uunit
  | lam m _ t =>
    match mrel m with
    | runtime => option_map ulam (erase (runtime :: rho) t)
    | erased => erase (erased :: rho) t
    end
  | app m t u =>
    match mrel m with
    | runtime =>
      match erase rho t, erase rho u with
      | Some a, Some b => Some (uapp a b)
      | _, _ => None
      end
    | erased => erase rho t
    end
  end.

Definition is_some {A} (o : option A) := match o with Some _ => true | None => false end.

Lemma runtime_index_some : forall rho n,
  nth_error rho n = Some runtime -> is_some (runtime_index rho n) = true.
Proof.
  induction rho as [|r rho IH]; destruct n; simpl; intros H; try discriminate.
  - destruct r; [discriminate | reflexivity].
  - specialize (IH n H). destruct (runtime_index rho n); [destruct r; reflexivity | discriminate].
Qed.

Theorem erase_some : forall t G a u,
  infer G runtime t = Some (a, u) -> is_some (erase (map (fun e => mrel (fst e)) G) t) = true.
Proof.
  induction t as [n | m ty t IH | m t1 IH1 t2 IH2 |]; intros G a0 u0 H; simpl in *.
  - destruct (nth_error G n) as [[m a]|] eqn:E; [|discriminate].
    destruct (mrel m) eqn:R; [discriminate|].
    pose proof (runtime_index_some (map (fun e => mrel (fst e)) G) n) as L.
    rewrite nth_error_map, E in L. simpl in L. rewrite R in L. specialize (L eq_refl).
    destruct (runtime_index _ n); [reflexivity | discriminate].
  - destruct (infer ((m, ty) :: G) runtime t) as [[b [|c u']]|] eqn:E; try discriminate.
    specialize (IH _ _ _ E). simpl in IH.
    destruct (mrel m); [assumption|].
    destruct (erase _ t); [reflexivity | discriminate].
  - destruct (infer G runtime t1) as [[[|m' a b] u]|] eqn:E1; try discriminate.
    specialize (IH1 _ _ _ E1).
    destruct (mode_eqb m' m); [|discriminate].
    destruct (mrel m) eqn:R; [assumption|].
    destruct (infer G runtime t2) as [[a' v]|] eqn:E2; [|discriminate].
    specialize (IH2 _ _ _ E2).
    destruct (erase _ t1), (erase _ t2); simpl in *; congruence.
  - reflexivity.
Qed.

(* Examples, evaluated in the kernel. *)

Definition lin := {| mrel := runtime; muse := linear |}.
Definition ghost := {| mrel := erased; muse := linear |}.
Definition unr := {| mrel := runtime; muse := unrestricted |}.

(* The linear identity is accepted. *)
Compute is_some (infer [] runtime (lam lin tunit (var 0))).
(* Duplicating a linear argument is rejected. *)
Compute is_some (infer [] runtime (lam lin tunit (app unr (lam unr tunit (var 0)) (var 0)))).
(* Dropping an erased linear permission is rejected. *)
Compute is_some (infer [] runtime (lam ghost tunit unit)).
(* A function consuming an erased permission erases to the identity on its run-time argument. *)
Compute erase [] (lam ghost tunit (lam lin tunit (var 0))).

From Stdlib Require Extraction ExtrOcamlBasic.
Extraction Language OCaml.
Extraction "modes.ml" infer erase lin ghost.
