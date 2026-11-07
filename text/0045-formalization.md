# RFC 0045: Formalization

Pull request: [sic-lang/rfcs#45](https://github.com/sic-lang/rfcs/pull/45)

## Summary

The type system of Sic is formalized in [Lean](https://lean-lang.org/), in the `theory/` directory of the [`sic`](https://github.com/sic-lang/sic) repository, so that the kernel of Lean checks every property that the RFCs claim.
A reader then only has to check that the definitions and the statements of the formalization say what the RFCs say, which the formalization makes easy: each definition and each named formula of the RFCs has a counterpart of the same structure, and the correspondence between them is extracted from both sides and published, with nothing kept by hand.

## Motivation

A type system is a set of definitions and of claims about them, such as the soundness of a meaning or the erasure of what is never used at run time.
Written on paper, a claim is only as reliable as its proof and its review: the proofs of a dependent type theory are long, made of many cases that differ by little, where a missing case or a wrong side condition goes unnoticed.
A proof assistant checks every case of every proof, but it moves the question elsewhere: whether the definitions and the statements that it checks are those of the RFCs.

This RFC records how the formalization answers both questions:

- What is formalized, in which language, and what the checks of the formalization trust.
- How a reader makes sure that the formalization says what the RFCs say, and that it says all of it.

## Proposal

The proposal states what the formalization holds, what its checks trust, and how it corresponds to the RFCs.

### What Is Formalized

The formalization holds everything that the RFCs state about the type system: its definitions, the meaning of its judgments, and its properties, with their proofs.
The RFCs state these without any proof and without mentioning the formalization, so that each RFC stands on its own; the formalization cites the RFCs, and never the reverse.

### What the Checks Trust

The kernel of Lean checks the proofs, and the checks of the pull requests of `sic` make sure that nothing escapes it:

- Every declaration is checked again by `leanchecker`, which replays the declarations in the kernel, so that none was added without being checked.
- No declaration depends on an axiom other than `propext` and `Quot.sound`: no `sorry`, no `native_decide`, which would trust the compiler, and no `Classical.choice`, so that the proofs stay constructive, as the metatheory of a type system whose proofs compute should be.
- The formalization depends on Lean alone, without [Mathlib](https://github.com/leanprover-community/mathlib4), whose versions follow those of Lean closely and whose general structures depend on `Classical.choice`.
- The version of Lean is the one of the nixpkgs commit that the flake of `sic` pins, as for every other tool of its checks.

### Correspondence With the RFCs

The definitions and the statements follow the RFCs so closely that a reader compares them side by side, and the correspondence between them is computed from both:

- Every definition of an RFC has a definition of the formalization with the same structure and the same cases, and every named formula or rule a theorem or a rule; the formalization only adds what its representation of the variables needs, such as de Bruijn indices, and says so in a comment.
- Every definition, formula and rule of an RFC has a name, written in the last column of its formula or after the fraction of its rule; a check of the RFCs makes sure that every name has this form, from which it is extracted, and that it designates nothing else.
- A declaration of the formalization gives, with an attribute, the names of the definitions, formulas and rules that it formalizes, written exactly as the RFC writes them; a formula that the representation of the variables makes needless, such as a condition that a name is fresh, is given to the declaration of this representation.
- A program of the formalization extracts the names of the RFCs, at a commit that the flake of `sic` pins, and those of the declarations, and fails when a declaration gives a name that no RFC has, so that renaming a formula of an RFC cannot leave the correspondence behind.
- The same program writes the pages of the correspondence, one per file of the RFCs, which give each name with its section and its formula or rule, as the RFC writes it, then the source of each declaration that formalizes it, as its file writes it, without the proof of a theorem, so that a reader compares them on one page; the site of `sic` publishes them with the documentation of the formalization.

A name that no declaration gives shows as not yet formalized, so that the pages show what is left, and what is formalized, without a list kept by hand.

## Drawbacks

The correspondence relates names, not meanings: it shows that a declaration claims to formalize a formula, while only a reader checks that it does.
The attribute of the correspondence is itself defined in Lean, in a library apart from the formalization, since the attributes of Lean depend on `Classical.choice`.
Without Mathlib, the formalization proves itself the general facts it needs, on lists, sets and orders, which Mathlib already has.
Lean changes between versions more than older proof assistants do, so that updating it may break proofs.

## Rationale and Alternatives

The choices of this RFC are weighed against the following alternatives.

### The Language

Lean is the language of the formalization since it is also a programming language, which writes the programs of the formalization, such as the one that extracts the correspondence, and since its proof irrelevance, definitional for the propositions, and its automation suit the proofs on derivations; its [reference](https://lean-lang.org/doc/reference/latest/) describes all three.
The alternatives were considered as follows:

- [Agda](https://wiki.portal.chalmers.se/agda/), in which the [formalization of Abel, Danielsson and Eriksson](https://github.com/graded-type-theory/graded-type-theory) of a graded type theory is written, has the induction-recursion that their logical relation uses, which Lean lacks; but the formalization of Sic follows [Pujet](https://github.com/loic-p/logrel-mltt/tree/ef332527cb2203216ffe9d59b82e98ff13b2db3d) in encoding the logical relation as a predicate indexed by its interpretation, which needs no induction-recursion.
- [Rocq](https://rocq-prover.org/), in which [Martin-Löf à la Coq](https://doi.org/10.1145/3636501.3636951) is written, is more stable and has cumulative universes, which ease a logical relation over a hierarchy of universes, but extracts its programs to another language to run them.
- [Isabelle](https://isabelle.in.tum.de/) proves in a classical higher-order logic without dependent types, in which the syntax and the derivations of a dependent type theory are less direct to define.

### Names Rather Than a Manual Correspondence

The correspondence could be a table kept by hand, as the README of `sic` once had, but such a table goes out of date as soon as a formula is renamed or a declaration added, which nothing detects.
Extracting the names from both sides removes this cause, at the cost of a convention on where the RFCs write their names and of an attribute on the declarations.

### The Exact Names

The attribute gives the name as the RFC writes it in LaTeX, rather than an identifier of its own: a name of the RFC needs no second spelling, which would have to be kept consistent with the first, at the cost of names less pleasant to read in the formalization.

## Prior Art

The formalization follows practices of the following projects:

- The [formalization of Abel, Danielsson and Eriksson](https://github.com/graded-type-theory/graded-type-theory), which proves the metatheory of a graded type theory, including the erasure, and which the metatheory of Sic follows for most of its proofs.
- [logrel-coq](https://github.com/CoqHott/logrel-coq) and [Pujet's logrel-mltt](https://github.com/loic-p/logrel-mltt/tree/ef332527cb2203216ffe9d59b82e98ff13b2db3d), which formalize logical relations without induction-recursion.
- [Cedar](https://doi.org/10.1145/3663529.3663854), whose [specification in Lean](https://github.com/cedar-policy/cedar-spec) separates the definitions, which a reader checks against the intent, from the theorems about them, whose proofs Lean checks.
- [Lean4Lean](https://github.com/digama0/lean4lean), which checks the declarations of Lean again with a kernel written in Lean, as `leanchecker` does with the kernel of Lean.

## Unresolved Questions

None.
