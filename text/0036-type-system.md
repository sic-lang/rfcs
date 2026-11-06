# RFC 0036: Type System

- Pull request: [sic-lang/rfcs#36](https://github.com/sic-lang/rfcs/pull/36)

## Summary

This RFC states the type system of Sic as a whole: what it is made of, why each piece is there, what was set aside and why, and what the whole can and cannot do.
It gives no definition, rule or property itself: the system is defined in the annexes, the files of the directory that bears the name of this file, each on one subject and each built on the ones before it.

## Motivation

The type system of Sic combines dependent types with grades that count the uses of each variable.
Its pieces are tightly bound: the declared types need an equality to state their indices and their extensionality, and the equality is defined on the declared types, so that the system cannot be split into documents that each stand alone without one of them depending on a later one.
This RFC therefore states the system in one place, and keeps apart the two things a reader looks for: the main document says what the system is made of and why, for a reader who decides or reviews the design, and the annexes say exactly what it is, for a reader who checks or implements it.

## Proposal

The type system is presented in the annexes, in the order in which they build on each other.
This document lists the pieces of the system and the reasons for each of them, and refers to the annex that defines it.

### Grades

The type system counts the uses of each variable along the two axes of the [grades](https://github.com/sic-lang/rfcs/pull/16) of Sic: its uses at run time, and all its uses, erased or not, so that a program states which resources it consumes, which proofs and specifications it erases, and which permissions it passes on exactly once.
A [multiplicity](0036-type-system/02-multiplicities.md) counts the uses on one axis, as the multiplicities $`0`$, $`1`$ and $`\omega`$ of [Idris 2](https://arxiv.org/abs/2104.00480) and of [Linear Haskell](https://ghc.gitlab.haskell.org/ghc/doc/users_guide/exts/linear_types.html) do, and a [grade](0036-type-system/03-grades.md) is a pair of multiplicities, one per axis.
The grades form a modality of the graded type theory of [Abel, Danielsson and Eriksson](https://doi.org/10.1145/3607862), whose rules only know a modality by its laws, so that the rules of the type system follow theirs.
Their meaning is an abstract interpretation of the numbers of uses: each grade stands for the numbers of uses it allows, and its operations and its order are derived from those of the numbers rather than chosen.

The usage of a term is checked in one of three [modes](0036-type-system/04-modes.md): no use, all the uses but none at run time, and all the uses.
The theory of Abel, Danielsson and Eriksson has only the first and the last; the mode in between is added so that an erased term, such as a proof, still counts all its uses, and cannot drop or duplicate a permission that may be used once.

### Levels and Sorts

The types live in [sorts](0036-type-system/06-sorts.md), the universes $`U_l`$, whose elements are types, and the universes of propositions $`\Omega_l`$, whose elements are propositions, both indexed by a [level](0036-type-system/05-levels.md).
A level is built from $`0`$, the successor, the larger of two levels and level variables, which stand for any natural numbers, so that an entry of the signature is checked once with its level variables and used at any levels, as in [Lean](https://lean-lang.org/doc/reference/latest/The-Type-System/Universes/).
Two levels are equal or ordered when their values are, whatever numbers their variables take: the values are the meaning of the levels, and the equality and the order are exact for it by construction.

The quality of a sort, $`U`$ or $`\Omega`$, may be a sort variable, as the sort qualities of [Rocq](https://rocq-prover.org/doc/master/refman/addendum/universe-polymorphism.html), so that one entry of the signature serves for the types and for the propositions.
A sort bounds another when its level is above and it holds propositions only if the other does, and the join of two qualities gives the least sort that bounds two sorts at the same level.

### Syntax and Substitution

The [syntax](0036-type-system/07-syntax.md) has few terms: variables applied to arguments, sorts, instances of the constants of the signature, defined or declared, and instances of the declared types, so that every type other than a sort comes from a type declaration, whose kind adds the terms that build and use its types.
A parameter of a type declaration may be a second-order variable, which stands for a term under the variables of a telescope, as the type of the result of a function depends on its argument.
The [substitution](0036-type-system/08-substitution.md) of the first order gives terms to the variables, and the substitution of the second order gives abstractions to the variables, as the arguments of an instance do to its parameters.

### Annexes

Each annex states one subject, with its definitions, its meaning and its properties, and only them; it names the annexes it builds on, and an annex never builds on a later one.
Its file name starts with a number on two digits, which gives the order of the annexes.
The examples are in the directory `99-examples` of the annexes, one file per example, named after the number of the annex it illustrates: they are derived from the system, and are not part of it.

- [Notation](0036-type-system/01-notation.md): the letters that name each kind of object, and the conventions shared by all the rules and formulas of the annexes.
- [Multiplicities](0036-type-system/02-multiplicities.md): the numbers of uses $`0`$, $`1`$ and $`\omega`$, their operations, their order and their meaning.
- [Grades](0036-type-system/03-grades.md): the pairs of multiplicities that count the uses at run time and in total, their meaning, their properties and their projection on the run-time multiplicity.
- [Modes](0036-type-system/04-modes.md): the three settings in which the usage of a term is checked, and their structure on the grades.
- [Levels](0036-type-system/05-levels.md): the indices of the sorts, their values, their equality, their order and their properties.
- [Sorts](0036-type-system/06-sorts.md): the universes of types and of propositions, their qualities, the join of the qualities and the relation by which a sort bounds another.
- [Syntax](0036-type-system/07-syntax.md): the terms, their arguments, the telescopes, the contexts and the signatures, with the variables they bind.
- [Substitution](0036-type-system/08-substitution.md): the substitutions of the first and of the second order, the closed substitutions, the instantiation of the level variables and their properties.

## Drawbacks

- One RFC for the whole type system is a large document to review, even with the definitions in the annexes; its parts are accepted together, since none of them stands alone.
- Seven grades, among which a programmer chooses on every binder, are many: the surface language has to infer most of them, which no RFC designs yet.
- The meaning of the grades counts the uses that a term makes, not those that a program makes when it runs, which depend on the evaluation order; the run-time multiplicities $`1`$ and $`\omega`$ wait for the RFC of the calling convention to mean a number of uses.

## Rationale and Alternatives

The design of the type system follows a few principles, which explain most of its choices:

- Soundness first: a program the compiler accepts has the properties its types state, as [RFC 13](https://github.com/sic-lang/rfcs/pull/13) requires, and no other benefit justifies weakening it.
- No two mechanisms for the same thing: a need that an existing piece already meets gets no second piece, so that every piece has one role and the system stays small.
- Few pieces, but powerful ones: a piece is chosen general enough to cover several needs, as a codata type whose destructors take arguments gives both the functions and the additive conjunction $`\&`$ of linear logic.
- Embrace duality where it exists: when a construct has a dual, both are given together and named after each other, as the data types and the codata types.
- No speculative mechanism: a piece enters the system for a use that exists, not for one that might come.
- Conscious exclusions: what the system leaves out is stated with what is lost, what remains, and whether it can be added later.

The grades are settled by the following choices:

- The grades are pairs of multiplicities, one for each axis, rather than a flat set of named grades: the operations and the order act on each component, which gives their tables and their properties at once, and the names of the grades in Sic are read off the components.
- The order is the meet, as in the theory of Abel, Danielsson and Eriksson, rather than the reverse inclusion of the abstract interpretation turned into an order of its own: their rules use the meet as the order, so that the grades instantiate them as they are; the two orders coincide.
- The meet is the best abstraction of the union of the uses, so that a variable used differently by two branches gets the grade that allows both, rather than the join, which would allow fewer uses than either branch makes.
- The grade $`{\omega 1}^{\mathsf{p}}`$, `affine / linear`, counts exactly one use in total, made at run time or erased, as a permission that one branch passes on to the code and another to a proof; it is the meet of $`{01}^{\mathsf{p}}`$ and $`{11}^{\mathsf{p}}`$, and without it, this meet would be $`{\omega\omega}^{\mathsf{p}}`$, and the multiplication would not distribute over the meet, as a modality requires, since $`{01}^{\mathsf{p}} \cdot {\omega\omega}^{\mathsf{p}}`$ is $`{0\omega}^{\mathsf{p}}`$ while $`({01}^{\mathsf{p}} \cdot {01}^{\mathsf{p}}) \wedge ({01}^{\mathsf{p}} \cdot {11}^{\mathsf{p}})`$ is $`{01}^{\mathsf{p}}`$.
- The pairs $`\langle 1, 0 \rangle`$ and $`\langle \omega, 0 \rangle`$ are left out rather than identified with $`{00}^{\mathsf{p}}`$: they have no meaning of their own, and keeping them would break the well-behaved zero that the modes require, since $`\langle 1, 0 \rangle \cdot {01}^{\mathsf{p}}`$ and $`\langle \omega, 0 \rangle \cdot {01}^{\mathsf{p}}`$ are both $`{00}^{\mathsf{p}}`$.
- The properties of the greatest lower bounds hold for arbitrary families, since a family of grades takes at most seven values, rather than being assumed, as [Eriksson, Abel and Danielsson](https://doi.org/10.1145/3828677) assume them for a modality that may be infinite.
- Conscious exclusions, each with what is lost, what remains, and whether it can be added later:
  - Exact counts above one, such as a grade for exactly two uses: a resource used twice is unrestricted; the pairs of multiplicities would extend to pairs of larger modalities, as the [exact usage](https://doi.org/10.1145/3341714) of Granule, at the cost of larger tables and of the finiteness of the grades.
  - A greatest grade that allows no number of uses, the best abstraction of the empty set: no operation needs it, and no multiplicity can be added above $`0`$, $`1`$ and $`\omega`$ without breaking the distributivity, since $`(0 \wedge 1) \cdot \varnothing = (0 \cdot \varnothing) \wedge (1 \cdot \varnothing)`$ would give $`\omega \cdot \varnothing = 0`$, hence $`\varnothing + \varnothing = 0`$ since $`\omega = 1 + 1`$, and $`\varnothing = 0`$ by the monotonicity of the addition.

The levels and the sorts are settled by the following choices:

- The levels are not terms: they appear only as the indices of the sorts, and their equality is defined by their values rather than by rules of equality, unlike the formalization of Abel, Danielsson and Eriksson, whose levels are terms of a type of levels since [Danielsson, Favier and Kubánek](https://doi.org/10.1145/3776645); no term computes a level, so that no rule is needed to compare two of them, and their equality is decidable.
- The sort of a type declaration may be the join of two qualities, as its level may be the join of two levels, so that a pair holds two fields of independent sorts; the sort constraints of the [bounded sort polymorphism](https://doi.org/10.1145/3776732) of Rocq would be one mechanism more, for this need only.
- Conscious exclusion of the quantification over levels: no type quantifies over levels, so that no universe is needed beyond the two hierarchies, as the $`\mathsf{Set}\omega`$ of [Agda](https://agda.readthedocs.io/en/latest/language/universe-levels.html) is; the level variables give the polymorphism that programs need, and a quantification could be added later with a universe above the hierarchies.

The syntax and the substitution are settled by the following choices:

- The variables are named, as in the paper of Abel, Danielsson and Eriksson, rather than numbered by the de Bruijn indices of its formalization: an index is a way to represent the bound variables, which the system does not need to fix.
- The sort and grade variables of an entry are not part of the terms: an entry stands for its instances, as a rule for the instances of its fraction, so that no judgment meets a grade variable, whose order with the other grades would be unknown; the level variables are part of the terms, since an entry is checked once with them and used at any levels.
- The parameters that depend on variables are second-order variables, as the contextual types of Nanevski, Pfenning and Pientka, rather than parameters of a type of functions: the type of functions is itself declared, and its type declaration cannot take a function as a parameter.
- The substitutions of the first and of the second order are defined apart, as in the theory of Nanevski, Pfenning and Pientka: the second one substitutes the arguments of an application in the abstraction it gives, which is not a part of the term it substitutes, and the first one does it.

The type system was first split into four RFCs, the grades, the core, the data and codata types, and the observational equality, linked by a contract that each kind of type declaration fulfills.
The split did not hold: the data and codata types kept deferring to the equality what they needed, the indexed families, the extensionality of the recursive types, and the liftings through some nested types, while the equality is defined on the data and codata types.
One RFC with short annexes keeps the definitions readable, one subject at a time, without a cycle between documents.

## Prior Art

- The abstract interpretation of [Cousot and Cousot](https://doi.org/10.1145/512950.512973) and its [best abstractions](https://doi.org/10.1145/567752.567778) give the meaning of the multiplicities and of the grades.
- Grades on binders come from [McBride](https://doi.org/10.1007/978-3-319-30936-1_12) and the quantitative type theory of [Atkey](https://doi.org/10.1145/3209108.3209189), which [Idris 2](https://arxiv.org/abs/2104.00480) implements with the multiplicities $`0`$, $`1`$ and $`\omega`$, and [Linear Haskell](https://ghc.gitlab.haskell.org/ghc/doc/users_guide/exts/linear_types.html) with $`1`$ and $`\omega`$.
- The graded dependent type theory of [Abel, Danielsson and Eriksson](https://doi.org/10.1145/3607862), extended in their [journal version](https://arxiv.org/abs/2603.29716) and [formalized in Agda](https://github.com/graded-type-theory/graded-type-theory), on which the rules of the type system are built: it parametrizes its rules by a modality and a mode structure, which the grades and the modes instantiate, and [Eriksson, Abel and Danielsson](https://doi.org/10.1145/3828677) add the well-behaved greatest lower bounds that the usage of recursion needs.
- The [graded modal dependent type theory](https://arxiv.org/abs/2010.13163) of Moon, Eades and Orchard carries grades in typing, and [Granule](https://doi.org/10.1145/3341714) is a language built on graded modal types, whose semirings include exact counts.
- The levels follow those of [Lean](https://lean-lang.org/doc/reference/latest/The-Type-System/Universes/), built from zero, the successor, the maximum and prenex variables, and the sort variables the [sort polymorphism of Rocq](https://rocq-prover.org/doc/master/refman/addendum/universe-polymorphism.html), whose theory [Bounded Sort Polymorphism with Elimination Constraints](https://doi.org/10.1145/3776732) gives.
- The second-order variables follow the contextual types of [Nanevski, Pfenning and Pientka](https://doi.org/10.1145/1352582.1352591), whose metavariables stand for terms under the variables of a context, and whose substitution of the metavariables is defined apart from that of the variables.
- [Verus](https://doi.org/10.1145/3586037) separates the code that runs from the specifications and proofs by [modes of variables](https://verus-lang.github.io/verus/guide/reference-var-modes.html), and tracks ghost resources linearly, which the grades `none / linear` and `linear / unrestricted` express in Sic.

## Unresolved Questions

- The annexes are written as the system is settled, subject by subject, so that the list above grows with them.
- What do the run-time multiplicities $`1`$ and $`\omega`$ mean for a program that runs?
  The meaning of the grades counts the uses that a term makes, and the uses made when it runs depend on the evaluation order, which the RFC of the calling convention fixes.
- Does the type system embrace duality all the way, and which statements would show it?
  Three statements together would answer, once the annexes define the data and codata types:
  - The rules are closed under an involution that exchanges each construct with its dual, the data and the codata types, their introductions and their eliminations, the recursor and the corecursor: the dual of every rule is a rule of the system.
  - The transposition of a block of declared types in a program of the core, which turns data types into codata types by refunctionalization and back by defunctionalization, preserves the typing, the grades, the erasure and the reduction, and its two directions are mutual inverses, as [Binder, Jabs, Skupin and Ostermann](https://doi.org/10.1145/3371098) show for a language without dependent types, after [Rendel, Trieflinger and Ostermann](https://doi.org/10.1145/2784731.2784763), who proposed the two transformations as a test of the symmetry of data and codata.
  - The asymmetries that remain are listed, each justified by a limit of the logic rather than by a choice, since the full duality, as that of [Wadler](https://doi.org/10.1145/944705.944723) between call-by-value and call-by-name, needs a classical sequent calculus.

  Four obstacles to the transposition are already known:
  - Strict positivity: a recursion whose motive takes a term of the transposed type as an argument, as the addition of natural numbers, becomes a destructor that takes a term of its own type, which strict positivity forbids to keep the system consistent; [Binder, Skupin, Süberkrüb and Ostermann](https://doi.org/10.1145/3649846) avoid it by working in an inconsistent type theory, so that the transposition in Sic can only be partial, on a domain to characterize.
  - Dependent elimination: the motive of the recursor depends on the term it eliminates, while the result of a destructor depends on the earlier observations of the term only; the dual would be destructors whose results depend on the observed term, as the self parameters of [Binder, Skupin, Süberkrüb and Ostermann](https://doi.org/10.1145/3649846).
  - Anonymous eliminations: the recursor and the corecursor are terms without names, so that an exact round trip needs either labels on them that tell a local elimination from a global one, as the local and global names of [Binder, Jabs, Skupin and Ostermann](https://doi.org/10.1145/3371098), or a statement of the inverse up to the lifting of the eliminations into definitions.
  - The order of the signature: the transposed block lists every elimination of the original block in the program, whose motives may mention entries declared after the block, while an entry of a signature refers only to the entries before it.
