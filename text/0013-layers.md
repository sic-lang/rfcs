# RFC 0013: Layers

- Pull request: [sic-lang/rfcs#13](https://github.com/sic-lang/rfcs/pull/13)

## Summary

This RFC states the three layers on which the type system of Sic is built: dependent types, linear types and refinement.
It decides what the type system must achieve, not how: each mechanism is the subject of a later RFC.

## Motivation

Sic aims to find bugs at compile time, in the use cases it targets: critical systems, low-level and systems programming, and distributed systems.
This RFC defines what the type system must guarantee to reach that aim, as three layers, each built on the previous one:

1. Dependent types are the base: types specify what is expected of the system, and the implementation is proved to meet its specification in the same language.
2. Linear types enrich the base, so that types also govern the resources and the concurrency, local or distributed, that the system uses.
3. Refinement makes the enriched base usable in practice, by letting types refine and decompose the system.

No existing language combines the three layers, but each of them exists separately: [Idris 2](https://arxiv.org/abs/2104.00480) combines dependent and linear types, [ATS](https://www.cs.bu.edu/~hwxi/atslangweb/) adds low-level programming to restricted dependent types and linear types, and [F\*](https://fstar-lang.org/) extracts verified low-level code to C through [Low\*](https://fstarlang.github.io/lowstar/html/); none of them offers refinement with decomposition.
Sic aims to combine these pieces, not to restate an existing language with a new syntax.

## Proposal

Sic rests on three layers and on soundness: a program the compiler accepts has the properties its types state.
No design choice may compromise them, since that would defeat the purpose of the language.

### Dependent Types

Programs and proofs are written in the same language: types can depend on values, and propositions are types whose values are their proofs (the Curry-Howard correspondence).
Properties of a program are stated and proved next to its code, and checked by the compiler.

### Linear Types

The type system tracks how many times a value is used, so that resources (memory, file handles, devices, locks) are used exactly as their protocol requires: never leaked, never used after being released.
Linearity should also describe communication protocols, so that concurrent and distributed programs are checked against them.

The linear logic of Sic is intuitionistic for now, like [quantitative type theory](https://doi.org/10.1145/3209108.3209189) and the session types of [Caires and Pfenning](https://doi.org/10.1007/978-3-642-15375-4_16).
Its connectives and units are then available as follows:

| | Multiplicative | Additive |
| --- | --- | --- |
| Conjunction | ⊗, pairs whose components have grades | &, through an [extension of quantitative type theory](https://ksvi.mff.cuni.cz/~sefl/papers/pairs_in_qtt.pdf) (Šefl and Svoboda) |
| Its unit | 1, the unit type | ⊤, through the same extension, though it can absorb any resource, against "never leaked" |
| Disjunction | ⅋, only encoded, through the negation `A ⊸ ⊥` | ⊕, sum types |
| Its unit | ⊥, the answer type of that negation | 0, the empty type |

Linear implication ⊸ is a function whose argument is linear, and the exponential ! is unrestricted usage; its dual ? is, like ⅋, only encoded.
In an intuitionistic logic, the negation `A ⊸ ⊥` is not involutive, so the encoded ⅋, ⊥ and ? are translations of their classical counterparts, not the connectives themselves.
Protocols do not suffer from it: the duality between the two ends of a channel is a function on descriptions of protocols, which is involutive on them.
A classical linear core, as in the calculus CP of [Wadler](https://doi.org/10.1145/2364527.2364568), would give all of them exactly, but is not considered for now.

### Refinement

Specifications at every level of the architecture (system, subsystem, software, module, function) are written in the language and checked by the compiler.
They form levels of detail: the first level views the whole system with little detail, and each next level views smaller, partly independent parts of the system in more detail.
Two adjacent levels are related in either direction:

- going down, refining a component adds detail without changing its boundary, and decomposing it splits it into subcomponents whose specifications together imply its own;
- going up, abstracting a component hides the details that the rest of the system does not need, and composing components gives the specification of their whole.

Each relation between two levels has local proof obligations, proved once where they arise, whether the levels were written top-down or bottom-up.
The correctness of the whole system follows from the chain of levels, without ever stating a global invariant.
The compiler checks both that each specification is consistent (it can be satisfied) and that each level refines the one above.

## Drawbacks

Combining dependent types, linear types and refinement in one language is ambitious: some of their interactions, such as refining linear components, are still research topics.
Committing to these layers early may rule out designs that would turn out simpler.

## Rationale and Alternatives

- Using several languages, such as a specification language next to an implementation language, leaves a gap between what is proved and what runs, and the levels of a specification drift apart in documents that nothing checks.
- Stating the layers as needs rather than mechanisms keeps the later RFCs free to choose the best mechanism for each.

## Prior Art

- [Agda](https://agda.readthedocs.io/en/stable/), [Idris](https://www.idris-lang.org/), [Lean](https://lean-lang.org/): dependent types; [Idris 2](https://arxiv.org/abs/2104.00480) combines them with linearity through [quantitative type theory](https://doi.org/10.1145/3209108.3209189), whose erased quantity makes proofs cost nothing at run time.
- [ATS](https://www.cs.bu.edu/~hwxi/atslangweb/), [Rust](https://www.rust-lang.org/), [Austral](https://austral-lang.org/): linear or affine types for safe resource management in systems programming.
- Session types, with the correspondence between linear logic and session types ([Caires and Pfenning, 2010](https://doi.org/10.1007/978-3-642-15375-4_16); [Wadler, 2012](https://doi.org/10.1145/2364527.2364568)): linearity for communication protocols.
- [B](https://doi.org/10.1017/CBO9780511624162) and [Event-B](https://wiki.event-b.org/): stepwise refinement of abstract machines with gluing invariants, and [decomposition of Event-B models](https://wiki.event-b.org/index.php/D23_Decomposition).
- Contract-based design ([Contracts for System Design](https://nowpublishers.com/article/Details/EDA-053), assume/guarantee contracts): decomposition of system specifications into component specifications, where refinement is a preorder.
- [Behavioral subtyping](https://doi.org/10.1145/197320.197383) (Liskov and Wing, 1994): refinement as subtyping.
- [F\*](https://fstar-lang.org/), [Liquid Haskell](https://ucsd-progsys.github.io/liquidhaskell/): refinement types, where a type is restricted by a predicate.

## Unresolved Questions

- Do linear types reach concurrent and distributed programs, or only local resources?
- Does the type system need ⅋, ⊥ and ? beyond protocols, which only a classical linear core would give exactly?
- How is ⊤ restricted, so that it cannot absorb a linear resource?
- Can classical reasoning be confined where it does not compute, since classical logic with dependent types [degenerates](https://doi.org/10.1007/11417170_16) unless restricted, as in [dLPAω](https://arxiv.org/abs/1805.09542)?
  It could be confined to a layer of processes, with ⅋, ⊥, ? and an exact duality, while types depend only on the intuitionistic functional core; to the erased grades, as Lean admits the [excluded middle](https://leanprover-community.github.io/mathlib4_docs/Init/Classical.html) for propositions, whose proofs are erased; or even to the grade `none / linear` only.
- Is refinement a form of subtyping, a simulation between components, or both?
- Which "… Types" name fits the refinement layer, given that refinement types already denote types restricted by a predicate?
- Where are types inferred, given that inference is undecidable with dependent types, and that Agda, Idris and Lean infer them locally from written signatures?
- Evaluation during type checking needs the functions used in types and proofs to terminate, but executable code such as the loop of a server must not: how are total and partial code separated?
- What does the type system offer for security, a subject too important to ignore? Linear types give memory safety, but security may also need information flow control, where secret data cannot influence public outputs (graded types can grade data by security levels, as [Granule](https://arxiv.org/abs/2309.04324) does to enforce non-interference), capabilities, and secret independence against timing side channels, which [HACL\*](https://github.com/hacl-star/hacl-star) proves for its cryptographic code.
- What does the type system offer for dependability, a subject as important as security? Proofs may replace part of the testing that safety standards require, as the formal methods supplement DO-333 of DO-178C allows in avionics ([NASA case studies](https://ntrs.nasa.gov/citations/20140004055)), and the levels of detail may match the levels of requirements that these standards trace; dependability may also need fault tolerance, such as [crash-stop failures](https://arxiv.org/abs/2207.02015), and bounds on time and resources, such as [time credits](https://www.doi.org/10.1007/S10817-017-9431-7).
- Which language hosts the mechanized metatheory of the type system, and can the same language implement the stage 0 compiler, proved against that metatheory?
