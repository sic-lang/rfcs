# RFC 0018: Host Language

- Pull request: [sic-lang/rfcs#18](https://github.com/sic-lang/rfcs/pull/18)

## Summary

This RFC chooses [Lean 4](https://lean-lang.org/) as the language of both the mechanized metatheory of the type system and the stage 0 compiler of Sic, so that the compiler can be proved correct against the metatheory in the same language.

## Motivation

The [layers](https://github.com/sic-lang/rfcs/pull/13) rest on soundness, which a type system on paper cannot guarantee: soundness must be proved, and the compiler must implement the type system that was proved.
Before Sic can compile itself, a stage 0 compiler written in another language is needed.
If that language is also a proof assistant, the metatheory is the specification of the compiler, and the compiler is a refinement of it, in the sense of the [refinement model](https://github.com/sic-lang/rfcs/pull/15).

## Proposal

The mechanized metatheory and the stage 0 compiler are written in Lean 4, at the version pinned by the flake of the `sic` repository.
The metatheory and every stage of the compiler, from stage 0 in Lean to the stages written in Sic, live in that repository, so that they change together.

- The metatheory formalizes the type system, as the RFCs of the core define it, and proves its properties: type safety, termination of type checking, consistency.
- The stage 0 compiler implements the type system; its type checker and its erasure of the erased grades of [RFC 16](https://github.com/sic-lang/rfcs/pull/16) are proved correct against the metatheory.

Everything is proved, in this order:

1. The type system is defined by the RFCs of this repository.
2. The metatheory formalizes it and proves its properties, before any compiler exists.
3. The stage 0 compiler is written, then proved correct against the metatheory.

Sic is not meant to be usable soon: a type system proved sound is worth more than a compiler that works early on.

### Prototype

The same prototype, kept in [`0018-host-language/`](0018-host-language/), was written in Lean 4.29.1 and [Rocq](https://rocq-prover.org/) 9.1.1, both from nixpkgs `nixos-26.05`: the grades of RFC 16, then called modes, on a minimal calculus, a type checker counting usages, an erasure to untyped terms, and the theorem that well-typed programs erase without erased variables left at run time.

| | Lean 4 | Rocq |
| --- | --- | --- |
| Size (lines, of which proofs) | 162 (58) | 172 (32) |
| Programming | `do` notation, derived equality and printing | Equality functions written by hand, explicit matches |
| Proofs | Short with automation (`simp_all`), but one goal needed manual help | Longer tactics, more predictable |
| Native executable | `lake build` to C, 1.3 s, 2.7 MB | Extraction to OCaml, then `ocamlopt`, 0.5 MB |
| Trusted path to run | Lean compiler and a C compiler | Extraction, its mapping to native OCaml types (`ExtrOcamlBasic`), and the OCaml compiler |
| Nix friction | `lean4` needs a C compiler in the environment | The standard library is a separate package, whose path `nix shell` does not set |

## Drawbacks

- [Iris](https://iris-project.org/), the separation logic in which [RustBelt](https://plv.mpi-sws.org/rustbelt/popl18/) proves Rust's ownership sound, is mature in Rocq, but its [Lean port](https://arxiv.org/abs/2609.24252) picked up only in 2026 and is still partial; the semantics of linear grades and permissions may need it.
- Lean changes often, with breaking changes between versions; pinning the version in the flake contains this, but updates cost work.
- Proof automation makes proofs short but brittle: a change in the definitions or in Lean can break `simp` calls far from it.

## Rationale and Alternatives

- **Rocq**: [MetaCoq](https://hal.archives-ouvertes.fr/hal-02380196) is the most complete precedent, with a type checker and an erasure proved correct for the kernel of Coq, and Iris is mature; but Rocq programs run only through extraction, which adds a trusted step and makes the stage 0 compiler less pleasant to write and to run often.
- **[Agda](https://agda.readthedocs.io/en/stable/)**: well suited to metatheory, but weak for writing and running a compiler.
- **[Idris 2](https://www.idris-lang.org/)**: good for programming, but without a tradition of mechanized metatheory.
- **A programming language without proofs** (OCaml, Haskell, Rust): the compiler could only be tested against the metatheory, never proved.
- **Two languages**, one for the metatheory and one for the compiler: the gap between what is proved and what runs is the one the layers reject.

## Prior Art

- [Lean 4](https://github.com/leanprover/lean4) is itself written in Lean and compiles to C.
- [Lean4Lean](https://arxiv.org/abs/2403.14064) (Carneiro, TYPES 2025): a type checker for Lean written in Lean, which checks all of Mathlib, formalizes Lean's type theory, proves partial correctness of the checker, and found a soundness bug in Lean.
- MetaCoq (["Coq Coq Correct!"](https://hal.archives-ouvertes.fr/hal-02380196), Sozeau et al., POPL 2020, and its [journal version](https://doi.org/10.1145/3706056)): a type checker and an erasure for the kernel of Coq, proved correct in Coq, moving from a trusted code base to a trusted theory base.
- [Iris in Lean](https://arxiv.org/abs/2609.24252): the port of Iris to Lean 4.
- [CakeML](https://cakeml.org/): a compiler verified in HOL4 and bootstrapped inside the logic.

## Unresolved Questions

None.
