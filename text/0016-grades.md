# RFC 0016: Grades

- Pull request: [sic-lang/rfcs#16](https://github.com/sic-lang/rfcs/pull/16)

## Summary

This RFC decides where linearity lives in the core language: every binder carries a grade that counts the uses of its variable on at least two axes, at run time and in total, each `none`, `linear` or `unrestricted`, as the grades of a graded dependent type theory do.
Resources and protocols are used once at run time and freely in proofs, permissions to access memory once and only in erased positions, and specifications freely and only in erased positions.
It is the first RFC of the core language; the other features of the core (dependent types, inductive types, universes) are left to later RFCs.

## Motivation

Sic checks its [resources](https://github.com/sic-lang/rfcs/pull/13) with linear types, and the [goals beyond the type system](https://github.com/sic-lang/rfcs/pull/17) require erased proofs and specifications and safe low-level code.
Existing designs put linearity in one of two places:

- **In the types**, as in [Idris 2](https://arxiv.org/abs/2104.00480): each binder has a multiplicity 0, 1 or ω, from [quantitative type theory](https://doi.org/10.1145/3209108.3209189).
- **In ghost permissions**, as in [Verus](https://doi.org/10.1145/3586037) and [Pulse](https://fstar-lang.org/tutorial/book/pulse/pulse.html): pointers are ordinary values, and linear permissions, erased at run time, grant the right to use them; Verus checks them with modes, Pulse with a separation logic.

Every later RFC of the core depends on this choice, so it comes first.

## Proposal

The proposal defines the grades and why they count the uses on two axes, relates them to the grades of a graded type theory, and says who defines grades and how explicit they are.

### Grades

Every binder of the core language carries a grade, written in this RFC as a pair `runtime / total` of multiplicities:

| Axis | Values | Meaning |
| --- | --- | --- |
| Run time | `none`, `linear`, `unrestricted` | How many times the compiled program uses the value: never, exactly once, or any number of times |
| Total | `none`, `linear`, `unrestricted` | How many times the program uses the value in all, erased positions included |

A value never used in total is never used at run time, which leaves seven grades; the run-time multiplicity `unrestricted` under the total multiplicity `linear` counts at most one use, and is named `affine`:

| Grade | Used for | Example, from the [key-value store vision](https://github.com/sic-lang/rfcs/pull/14) when it has one |
| --- | --- | --- |
| `none / none` | Parameters that only types mention | The type of the elements of a generic container |
| `none / linear` | Permissions, ghost tokens | The permission to access a buffer through a raw pointer |
| `none / unrestricted` | Specifications, proofs | The abstract map `m` of level 1 |
| `linear / linear` | Resources that no proof mentions | A resource that a function only passes on |
| `linear / unrestricted` | Resources, session endpoints | `Conn`, the session endpoint of the client, which the proofs of its protocol mention |
| `affine / linear` | Values used once, at run time or in an erased position depending on the branch | |
| `unrestricted / unrestricted` | Ordinary data | Keys and values |

The grade `affine / linear` is that of a value that one branch uses once at run time and another once in an erased position: without it, the grades would not form a modality, as the [graded dependent core](https://github.com/sic-lang/rfcs/pull/24) shows.
The grades whose run-time multiplicity is `none` are the erased grades: their values do not exist in the compiled program.
Types are checked in an erased context, so a type may mention any variable, whatever its grade, as in quantitative type theory.

### Why Two Axes

Idris 2 uses quantitative type theory with the multiplicities 0, 1 and ω, on a single axis.
Its multiplicity 0 means erased and freely usable: it cannot express a value that is both erased and linear, which is exactly what a ghost permission is.
Verus expresses it with its [variable modes](https://verus-lang.github.io/verus/guide/reference-var-modes.html): `ghost` and `tracked` variables are erased, and only `tracked` ones are checked for linearity and borrowing, while run-time values are linear or not according to their type, as in Rust.
This RFC counts the uses at run time and in total in the grade, independent of the type, so that every combination is uniform:

- Resources and protocols are ordinary values, checked by the type system, as in Idris 2.
- Low-level code manipulates raw pointers, whose safety rests on erased linear permissions, as in Verus, at no run-time cost.
- Proofs mention resources freely without consuming them, as specifications in Verus mention run-time values.

### Grades of a Graded Type Theory

The two axes form a grade in the product of two semirings: one counts the uses of a variable at run time, the other all its uses, erased or not, and a type is checked with the zero grade, so that it may mention any variable.
Quantitative type theory, as Atkey defines it, requires its semiring to have no zero divisors, which a product of semirings has: `(1, 0) · (0, 1) = (0, 0)`.
Since every use counts in the second axis, no grade counts more uses at run time than in all, which excludes `(1, 0)` and `(ω, 0)`, and the [graded dependent core](https://github.com/sic-lang/rfcs/pull/24) shows that the remaining grades have no zero divisors.
The graded type theory of [Abel, Danielsson and Eriksson](https://doi.org/10.1145/3607862), whose metatheory holds for any modality, is the starting point of the [graded dependent core](https://github.com/sic-lang/rfcs/pull/24), and the seven grades form one of its modalities.

### Who Defines Grades

The set of grades is closed: only the language defines them, each axis through an RFC and a proof in the metatheory, because a grade changes how the compiler treats a value, as erasure does, and its correctness is a property of the compilation.
Users extend the type system through types instead, carried by the existing grades: a typestate, a capability or a time credit is an ordinary type in the grade `none / linear`, so new disciplines need no new grade.
Grades defined by users, which would only count or restrict uses without changing the compilation, remain possible later: since the metatheory of graded type theories holds for any structure of grades that satisfies their laws, such grades would come with proofs of these laws.

### Explicitness

The [design axes](https://github.com/sic-lang/rfcs/pull/17) lean to explicitness for what runs.

Grades are part of the type of every function, so a signature shows which arguments exist at run time and which must be used exactly once.

## Drawbacks

- The erased grades other than `none / none` are not zero, since their uses count in the second axis, while the known results on erasure erase the zero grade only: the erasure of these grades must be proved.
- The seven grades may not suffice: uniqueness and borrowing (see below) probably need further axes.

## Rationale and Alternatives

- **Quantitative type theory with 0, 1 and ω**, as in Idris 2: it cannot express erased linear permissions, so low-level code would need unsafe escapes for raw pointers.
- **Ghost permissions in a separation logic**, as in Pulse: run-time resources and session endpoints would be checked only through the logic.
- **Usage carried by types**, as in Verus and Rust: whether a value may be duplicated depends on its type, so the same type cannot be used linearly in one place and freely in another.
- **Exact usage counts**, with the semiring 0, 1, 2, …, ω or intervals of counts, as in [Granule](https://granule-project.github.io/): possible, and it would count resources precisely, such as a token used exactly twice, but it makes typing brittle (both branches of a conditional must use a variable the same number of times) and inference harder, for little gain in most programs; it is not a direction considered for now.
- **Independent axes** is also the approach of the [modes of OCaml](https://doi.org/10.1145/3674642) (affinity, uniqueness and locality), which found a single axis insufficient, but without an axis of erasure.

## Prior Art

- Quantitative type theory ([McBride, 2016](https://doi.org/10.1007/978-3-319-30936-1_12); [Atkey, LICS 2018](https://doi.org/10.1145/3209108.3209189)) and [Idris 2](https://arxiv.org/abs/2104.00480) (Brady, ECOOP 2021), which considers its quantity 1 experimental and lacks quantity polymorphism.
- Graded modal types: [Granule](https://granule-project.github.io/), [graded modal dependent type theory](https://arxiv.org/abs/2010.13163) (Moon, Eades and Orchard, ESOP 2021), which does not need its semiring to have no zero divisors, and [GraD](https://arxiv.org/abs/2011.04070) (Choudhury et al., POPL 2021), whose semantics proves a single pointer property for linear resources.
- [Verus](https://doi.org/10.1145/3586037) (Lattuada et al., OOPSLA 2023): linear ghost types for verified Rust, including pointers and concurrency, with the code modes `spec`, `proof` and `exec` and the variable modes `ghost`, `tracked` and `exec`, of which only `exec` exists at run time.
- [Pulse](https://fstar-lang.org/tutorial/book/pulse/pulse.html) and [Low\*](https://fstarlang.github.io/lowstar/html/) ([F\*](https://fstar-lang.org/)): ghost permissions as propositions of a concurrent separation logic, and extraction of verified code to C with proofs erased.
- [RustBelt](https://plv.mpi-sws.org/rustbelt/popl18/) (Jung et al., POPL 2018): semantic soundness of Rust's ownership and borrowing in the [Iris](https://iris-project.org/) separation logic.
- [Oxidizing OCaml with modal memory management](https://doi.org/10.1145/3674642) (Lorenzen et al., ICFP 2024): modes along affinity, uniqueness and locality, where locality is a simplification of Rust's lifetimes.
- [Linearity and uniqueness](https://doi.org/10.1007/978-3-030-99336-8_13) (Marshall, Vollmer and Orchard, ESOP 2022): linearity restricts the future of a value, uniqueness its past, and in-place update needs uniqueness.
- [Austral](https://austral-lang.org/): linear types for memory safety and capability-secure code.

## Unresolved Questions

- Are the values of the erased grades that are not zero erased safely? The [graded dependent core](https://github.com/sic-lang/rfcs/pull/24) states a way to prove it.
- Is uniqueness a third axis, needed for in-place updates such as the buffer of the vision?
- How are linear values borrowed without being consumed: lifetimes as in Rust, locality as in OCaml, or regions?
- How are grades polymorphic, so that one function serves values of several grades?
- Are affine values, used at most once in total, needed besides linear ones, for instance to drop a resource on an error path?
  The grade `affine / linear` does not give them, since it still counts exactly one use in total.
- Should users define their own grades, which do not change the compilation, and what would they cost in readability?
- Which grades are written in function bodies, and which are inferred there, given that implicitness must be justified (see the [design axes](https://github.com/sic-lang/rfcs/pull/17))?
