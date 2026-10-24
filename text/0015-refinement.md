# RFC 0015: Refinement Model

- Pull request: [sic-lang/rfcs#15](https://github.com/sic-lang/rfcs/pull/15)

## Summary

This RFC defines the model behind the refinement layer of the [layers RFC](https://github.com/sic-lang/rfcs/pull/13): what a component and its specification are, what refining and composing them mean, and which local proof obligations relate two levels of detail, whether they are written top-down or bottom-up.
It fixes the semantics, not the syntax nor the encoding in the core language, which later RFCs decide.
It adds no feature to the type system by itself: interfaces, implementations and their proofs are meant to be encoded with the dependent types and the modes of the first two layers, though the encoding may still need features of its own.

## Motivation

The layers require levels of detail related by local steps, without a global invariant, but do not say what a step is.
Without a precise model, each later RFC (the core language, modules, concurrency) would invent its own notion of refinement, and the steps of one could not be combined with the steps of another.
The model must also answer the question left open by the layers: whether refinement is subtyping, simulation, or both.

## Proposal

### Components and Interfaces

A component offers an interface and may use other interfaces.
An interface describes the operations a component offers, the state they act on, and their specification: an invariant on the state, and for each operation the condition under which it may be called and the effect it guarantees.
The state of an interface may be ghost: it exists only for the specification and is erased at run time.

An implementation of an interface `L2` over an interface `L1` is a program `M` that offers `L2` by calling `L1`, written `L1 ⊢ M : L2`, after the certified abstraction layers of [CertiKOS](https://flint.cs.yale.edu/certikos/publications/dscal.html).
A system is a tree of such judgments, whose leaves are interfaces provided by the hardware, the operating system or other trusted components.

### Refinement

An interface `L'` refines an interface `L`, written `L' ⊑ L`, when every implementation of `L'` can be used wherever an implementation of `L` is expected.
Refinement is a preorder: it is reflexive and transitive, so chains of refinement steps compose.

Refinement covers two cases:

- **Same state** (behavioral subtyping): `L'` keeps the state of `L`, accepts at least the same calls and guarantees at least the same effects.
  Refinement is then a subtyping relation.
- **Different state** (data refinement): `L'` represents the state of `L` differently, and a gluing invariant relates the concrete state to the abstract one.
  Refinement is then a simulation: every step of `L'` matches a step of `L`, or no step at all for the internal steps that `L'` adds.

Subtyping is the case of a simulation whose gluing invariant is the identity, so a single notion covers both: this answers the question left open by the layers.

### Composition

Components compose along two axes:

- **Vertically**, an implementation uses the interfaces below it: from `L1 ⊢ M : L2` and `L2 ⊢ N : L3`, the composition gives `L1 ⊢ N ∘ M : L3`.
- **Horizontally**, components run side by side and interact: `L1 ∥ L2` is the interface of their parallel composition, described by a protocol (see [Linear Types](https://github.com/sic-lang/rfcs/pull/13)).

Vertical composition is well-founded: an implementation only uses interfaces below it, so implementations never depend on each other in a cycle.
Components that need each other either form a single component, or interact horizontally, through their interfaces and a protocol.

Composition is monotone with respect to refinement on both axes: replacing a component by one that refines it refines the whole.
This theorem (independent refinement, in contract theory) is what makes every proof obligation local: once the relation between two levels is proved, no change elsewhere invalidates it.

### Levels of Detail

The levels of detail of the layers RFC are interfaces related by refinement and composition.
The relation between two adjacent levels is the same, whichever level is written first:

- going down, a level is refined or decomposed: the more detailed interfaces are written, then proved to refine the more abstract one;
- going up, components are abstracted or composed: the more abstract interface is written, hiding the details that the rest of the system does not need, then the existing components are proved to refine it.

Both directions produce the same proof obligations, and a system may mix them, for instance to reuse an existing component under a new, more abstract interface.
Going up also integrates an existing library, even a foreign one: a more abstract interface hides it, so that the rest of the system depends only on that interface.
Its abstract state, its gluing invariant and the proofs are erased ([RFC 16](https://github.com/sic-lang/rfcs/pull/16)), so the abstraction costs nothing at run time when its operations are those of the library.

### Proof Obligations

Each interface, and each relation between two levels, produces only the following obligations, about itself:

1. **Consistency**: the interface has an implementation, so its specification does not contradict itself; going up, the existing implementation proves it.
2. **Initialization**: the initial state satisfies the invariant.
3. **Preservation**: every operation preserves the invariant.
4. **Simulation**: in a data refinement, every concrete step preserves the gluing invariant and matches an abstract step or none.
5. **Decomposition**: the composition of the interfaces of the subcomponents refines the interface of the parent.

Obligations 1 to 3 concern one interface, obligations 4 and 5 the relation between two levels.
In the [key-value store vision](https://github.com/sic-lang/rfcs/pull/14), level 2 is a horizontal decomposition (obligation 5), levels 3a and 4 vertical data refinements (obligation 4).

### Required Extensions

This model is a base, too limited on its own: Sic needs all the following extensions, whose design is left to later RFCs.

- **Fine-grained concurrency**: components whose operations interleave with other threads, as the concurrent abstraction layers of [CCAL](https://flint.cs.yale.edu/flint/publications/ccal.html) handle with strategies and linking theorems across threads and cores.
- **Conditional refinement**: refinements that hold only under conditions on the caller, such as holding a permission, while staying transitive, as in [conditional contextual refinement](https://doi.org/10.1145/3571232).
- **Choices that depend on the future**: refinements that forward simulation cannot prove, through backward simulation or prophecy variables.
- **Liveness**: proofs that components that run forever keep answering, under explicit fairness assumptions, as [IronFleet](https://www.microsoft.com/en-us/research/publication/ironfleet-proving-practical-distributed-systems-correct/) proves for distributed systems.
- **Components that never terminate**: a coinductive representation of interacting programs, such as [interaction trees](https://arxiv.org/abs/1906.00046), executable and usable in a metatheory where every function terminates.
- **Several viewpoints and missing components**: the conjunction of contracts, to combine viewpoints such as function and timing on one component, and their quotient, which computes the specification of the component missing from a decomposition ([Contracts for System Design](https://nowpublishers.com/article/Details/EDA-053)).

## Drawbacks

- Simulation in one direction (forward simulation, as in B) is simple but incomplete: some correct refinements of nondeterministic specifications need backward simulation.
  For instance, the concurrent queue of [Herlihy and Wing](https://doi.org/10.1145/78969.78972) is linearizable, but the point where an operation takes effect depends on what other threads do later, which a forward simulation cannot choose in advance.
- The model only covers safety, or partial correctness: a component that never answers, because it loops or blocks, refines any interface.
  Termination, and liveness for components that run forever such as servers, are not covered.

## Rationale and Alternatives

- **Refinement as subtyping only**, as in behavioral subtyping or refinement types: it cannot change the representation of the state, which most useful refinements do (a map becoming a hash table, a reliable channel becoming a lossy one).
- **State machines only**, as in B and Event-B: the model above keeps their proof obligations, but makes vertical composition part of refinement itself, where B handles it with dedicated clauses (`IMPORTS`) and Event-B, without implementations, lacks it.
- **Contracts only**, as in contract-based design: their meta-theory gives the algebra of composition and refinement, but no notion of implementation as a program; the judgment `L1 ⊢ M : L2` provides it.

## Prior Art

- [B](https://doi.org/10.1017/CBO9780511624162) and [Event-B](https://wiki.event-b.org/): refinement of abstract machines by gluing invariants, the proof obligations above, and the [decomposition of Event-B models](https://wiki.event-b.org/index.php/D23_Decomposition) into sub-models refined separately.
- [Contracts for System Design](https://nowpublishers.com/article/Details/EDA-053) (Benveniste et al., 2018): the meta-theory of refinement, conjunction and composition of contracts, and independent refinement.
- [CertiKOS](https://flint.cs.yale.edu/certikos/publications/dscal.html) (Gu et al., POPL 2015) and its concurrent extension [CCAL](https://flint.cs.yale.edu/flint/publications/ccal.html) (PLDI 2018): certified abstraction layers `L1 ⊢R M : L2` in Coq, composed into operating system kernels.
- [Interaction structures](https://arxiv.org/abs/0905.4063) (Hancock and Hyvernat, 2006): interfaces in type theory, whose morphisms are simulations, and where the proof of a simulation is a program.
- [Interaction trees](https://arxiv.org/abs/1906.00046) (Xia et al., POPL 2020): programs as trees of events, compared up to weak bisimulation, used by DeepSpec.
- Refinement calculus ([Back and von Wright](https://doi.org/10.1007/978-1-4612-1674-2); [Morgan](https://www.cs.ox.ac.uk/publications/books/PfS/)), and its [predicate transformer semantics in Agda](https://webspace.science.uu.nl/~swier004/publications/2019-icfp-anne.pdf) (Swierstra and Baanen, ICFP 2019).
- [Behavioral subtyping](https://doi.org/10.1145/197320.197383) (Liskov and Wing, 1994).
- [Practical Foundations for Programming Languages](https://www.cs.cmu.edu/~rwh/pfpl/) (Harper, second edition, 2016): subtyping as a preorder, type refinements ordered by entailment, and representation independence, where an implementation of an abstract type is proved correct by a bisimulation with a reference implementation that clients cannot tell apart.
- [SPARK](https://learn.adacore.com/courses/intro-to-spark/chapters/04_State_Abstraction.html): abstract state of a package specification, refined in its body.
- [Dafny](https://dafny.org/latest/DafnyRef/DafnyRef): module refinement, where a module makes the entities of an abstract module more concrete, such as the definition of a type declared without one, without proving their properties again, but without gluing invariants.
- [Conditional contextual refinement](https://doi.org/10.1145/3571232) (Song et al., POPL 2023): refinements that are both conditional, with separation logic preconditions and postconditions, and transitively composable.

### Current State of the Design

As a theory of refinement, the model of this RFC is a synthesis of established work, and is behind the state of the art on fine-grained concurrency, conditional refinement, choices that depend on the future and liveness, hence the required extensions.
As a feature of a programming language, it has no equivalent among the work cited above:

| | Changes of representation | Several levels | In the programming language |
| --- | --- | --- | --- |
| B and Event-B | Yes | Yes | No: specification languages |
| SPARK | Yes | No: specification and body only | Yes |
| Dafny | No gluing invariant | Yes | Yes |
| CertiKOS, CCAL, IronFleet | Yes | Yes | No: methods in a proof assistant or a verifier |
| This RFC | Yes | Yes | Yes, with linear and erased modes |

Its risk lies in that combination, where interactions such as gluing invariants over linear resources have not been studied.

## Unresolved Questions

- Refinements that forward simulation cannot prove must be handled: through backward simulation, which together with forward simulation is complete ([Lynch and Vaandrager](https://doi.org/10.1006/inco.1995.1134)), or prophecy variables, ghost state that predicts the future ([Abadi and Lamport](https://doi.org/10.1016/0304-3975(91)90224-P); in separation logic, [Jung et al.](https://doi.org/10.1145/3371113)), which would fit the erased mode, or both?
- How are foreign interfaces, provided by the hardware or by code in other languages, specified, and how far are they trusted?
- The language should eventually prove termination, for components that must finish, and liveness, for components that run forever such as servers: how are both specified, and how do new internal steps prove that they terminate (variants, as in Event-B)?
- How does horizontal composition handle atomicity, when one abstract step becomes several concrete steps interleaved with other components?
- How does a gluing invariant relate states that hold linear resources?
- Which components may use which interfaces (who imports whom), and how are interfaces and their implementations reused across systems and levels?
- Which encoding in the core language: interfaces as indexed types, as records of operations, or as modules?
