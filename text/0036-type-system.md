# RFC 0036: Type System

Pull request: [sic-lang/rfcs#36](https://github.com/sic-lang/rfcs/pull/36)

## Summary

This RFC states the type system of Sic as a whole: what it is made of, why each piece is there, what was set aside and why, and what the whole can and cannot do.
It gives no definition, rule or property itself: the system is defined in the annexes, the files of the directory that bears the name of this file, each on one subject and each built on the ones before it.

## Motivation

The type system of Sic combines dependent types with grades, which count uses.
Its pieces are tightly bound: the declared types need an equality to state their indices and their extensionality, and the equality is defined on the declared types, so that the system cannot be split into documents that each stand alone without one of them depending on a later one.
This RFC therefore states the system in one place, and keeps apart the two things a reader looks for: the main document says what the system is made of and why, for a reader who decides or reviews the design, and the annexes say exactly what it is, for a reader who checks or implements it.

## Proposal

The type system is presented in the annexes, in the order in which they build on each other.
This document lists the pieces of the system and the reasons for each of them, and refers to the annex that defines it.

### Grades

The type system counts uses, a use being an access to a value through a variable, along the two axes of the [grades](https://github.com/sic-lang/rfcs/pull/16) of Sic: the uses at run time, and all the uses, erased or not.
A [multiplicity](0036-type-system/03-multiplicities.md) counts the uses on one axis, as the multiplicities $`0`$, $`1`$ and $`\omega`$ of [Idris 2](https://arxiv.org/abs/2104.00480) and of [Linear Haskell](https://ghc.gitlab.haskell.org/ghc/doc/users_guide/exts/linear_types.html) do, and a [grade](0036-type-system/04-grades.md) is a pair of multiplicities, one per axis.
The multiplicities and the grades each form a [modality](0036-type-system/02-modalities.md) of the graded type theory of [Abel, Danielsson and Eriksson](https://doi.org/10.1145/3607862), whose rules only know a modality by its laws, so that the rules of the type system follow theirs.
Their meaning is an abstract interpretation of the numbers of uses: each grade stands for the numbers of uses it allows, and its operations and its order are derived from those of the numbers rather than chosen.

The usage and the ownership of a term are checked in one of three [modes](0036-type-system/05-modes.md): no use, all the uses but none at run time, and all the uses.
The theory of Abel, Danielsson and Eriksson has only the first and the last; the mode in between is added so that an erased term, such as a proof, still counts all its uses, and cannot drop or duplicate a permission that may be used once.

### Levels and Sorts

The types live in [sorts](0036-type-system/07-sorts.md), the universes $`U_l`$, whose elements are types, and the universes of propositions $`\Omega_l`$, whose elements are propositions, both indexed by a [level](0036-type-system/06-levels.md).
A level is built from $`0`$, the successor, the larger of two levels and level variables, which stand for any natural numbers, so that an entry of the signature is checked once with its level variables and used at any levels, as in [Lean](https://lean-lang.org/doc/reference/latest/The-Type-System/Universes/).
Two levels are equal or ordered when their values are, whatever numbers their variables take: the values are the meaning of the levels, and the equality and the order are exact for it by construction.

The quality of a sort, $`U`$ or $`\Omega`$, may be a sort variable, as the sort qualities of [Rocq](https://rocq-prover.org/doc/master/refman/addendum/universe-polymorphism.html), so that one entry of the signature serves for the types and for the propositions.
A sort bounds another when its level is above and it holds propositions only if the other does, and the join of two qualities gives the least sort that bounds two sorts at the same level.

### Syntax and Substitution

The [syntax](0036-type-system/08-syntax.md) has few terms: variables applied to arguments, sorts, instances of the constants of the signature, defined or declared, instances of the declared types, and the constructors and the recursors of the data types, so that every type other than a sort comes from a type declaration, and its terms from the constructors and the recursor of its block.
A parameter of a type declaration may be a second-order variable, which stands for a term under the variables of a telescope, as the type of the result of a function depends on its argument.
The [substitution](0036-type-system/09-substitution.md) of the first order gives terms to the variables, and the substitution of the second order gives abstractions to the variables, as the arguments of an instance do to its parameters.

### Judgments, Usage and Ownership

The [typing](0036-type-system/13-typing.md) has the judgments of Martin-Löf type theory, a type, two equal types, a term of a type and two equal terms, in a signature and a context, and carries no grade; the [usage](0036-type-system/11-usage.md) is a judgment of its own, which checks in a mode how a term uses each variable of its scope, as a [vector of grades](0036-type-system/10-grade-vectors.md) allows, as in the theory of Abel, Danielsson and Eriksson.
The [ownership](0036-type-system/12-ownership.md) is a third judgment, which checks in a mode the ownership of the value of a term: a grade that counts the uses of this value during a whole run, through all the variables that lead to it.
Where the usage of a variable comes from the term that uses it, its ownership comes from the argument that its binder receives: each entry of a telescope requires an ownership of its argument, and a second-order variable states the ownership of its result from those of its arguments, as the meet of a constant and of factors, each scaling the ownership of one argument, so that a result may be a fresh value, an alias of an argument, or either.

A program is a term well typed, well used and well owned.
Its typing tells what it computes.
Its usage tells how it uses its resources, so that it states which resources it consumes, which proofs and specifications it erases, and which permissions it passes on exactly once.
Its ownership tells how its values are shared, so that it states which values no other variable reaches.
The three judgments are independent conditions, none derived from another, as three terms show, each passing two of them and failing the [third](0036-type-system/13-typing.md#properties); the ownership only reads the grades of the telescopes, which give the mode in which each argument is checked, as for the usage.

The signature lists the constant definitions, the constant declarations and the type declarations, in order, each checked against the entries before it, once with its level variables and for each instance of its sort and grade variables.
A constant has a mode, which says where it may be used: a constant of the mode $`{11}^{\mathsf{m}}`$ is a program, used anywhere, one of the mode $`{01}^{\mathsf{m}}`$ a proof or a ghost term, used in proofs and specifications, and one of the mode $`{00}^{\mathsf{m}}`$ a specification, used in specifications only.
A constant also has the ownership of its value, in every mode.
A constant definition is transparent: it unfolds to its body, whose ownership is checked against the one of the definition.
A constant declaration has no body, and covers three needs, told apart by the sort of its type and its mode: an axiom, a proposition assumed true, of the mode $`{01}^{\mathsf{m}}`$; a ghost constant, a value or a type that the specifications and the proofs use, of the mode $`{00}^{\mathsf{m}}`$ or $`{01}^{\mathsf{m}}`$; and a foreign constant, a type, a value or a function that the running program gets from outside, of the mode $`{11}^{\mathsf{m}}`$.
Its ownership is trusted, as its type is, so that a foreign constant states whether its value may be shared.

The universes of propositions $`\Omega_l`$ hold strict propositions: two proofs of a proposition are equal, and an entry of a telescope whose type is a proposition has a grade without use at run time, so that the proofs are erased.

### Reduction and Erasure

The [reduction](0036-type-system/14-reduction.md) is the computation of the type theory: one step of weak head reduction, untyped and defined on the terms of every scope, which unfolds a constant definition to its body at its instance and applies the computations that the kinds of type declarations give to their terms.
A closed term computes to a head normal form and stops there, without reducing its parts: the computation is lazy, as the meaning explanations of Martin-Löf type theory that [Nordström, Petersson and Smith](https://intuitionistic.wordpress.com/wp-content/uploads/2010/07/nordstrom-et-al-type-theory.pdf) present, and tells what a term is, not how a program runs, whose evaluation order the RFC of the calling convention fixes.

The [erasure](0036-type-system/15-erasure.md) compiles a term to an untyped target language, and replaces with a value $`\text{↯}`$ the parts whose grade is in a set of grades.
The set of the grades that a mode does not count gives, for the mode of run time, the program that runs, without its proofs and its specifications, as the extraction of Abel, Danielsson and Eriksson, and, for the mode of the proofs, the program that the proofs see, with its ghost code.
A variable whose grade is in the set is absent from the erasure of a term whose usage is checked in a mode that counts no use of the set, so that the usage states what the erasure removes; the erasure follows the grades alone, and depends on no evaluation order.
A constant keeps the grades of its instance, and the target language has one copy of it for each instance of its grades, so that no grade remains at run time.

### Meaning

The [meaning](0036-type-system/16-meaning.md) of the judgments follows the meaning explanations of Martin-Löf type theory: a closed judgment is true when its terms compute as it says, a judgment in a context when it is true under every pair of equal closed substitutions of the context, and a judgment with level variables when it is true at every value of its level variables.
Every judgment of the typing has a meaning, with the same objects, from the signatures to the arguments of an instance, and the meaning ignores the grades, the modes and the ownerships, as the typing does.
A closed canonical type is known by the equality of its canonical terms, which the sorts give: a universe $`U_n`$ relates types, each with the equality of its terms, and a universe of propositions $`\Omega_n`$ relates propositions, each with its truth, the closed terms of a true proposition being all equal proofs of it.
A constant declaration has no body to compute: the meaning takes an interpretation, which gives each constant declaration a term, and computes in the signature where the declarations become definitions with these terms.
The typing is sound: under an interpretation that gives each constant declaration a term of its type, every judgment that the rules derive is true, so that the axioms and the foreign constants of a program are the hypotheses of its guarantees.

What the usage and the ownership of a term guarantee of its erasure when it runs, and the soundness of the erasure, are not stated yet: every closed term of the core computes to a sort, whose erasure is $`\text{↯}`$, so that they need the terms that the kinds of type declarations bring, and the evaluation order that the RFC of the calling convention fixes.

### Annexes

Each annex states one subject, with its definitions, its meaning and its properties, and only them; it names the annexes it builds on, and an annex never builds on a later one.
Its file name starts with a number on two digits, which gives the order of the annexes.
The examples are in the directory `99-examples` of the annexes, one file per example, named after the number of the annex it illustrates: they are derived from the system, and are not part of it.

- [Notation](0036-type-system/01-notation.md): the letters that name each kind of object, and the conventions shared by all the rules and formulas of the annexes.
- [Modalities](0036-type-system/02-modalities.md): the laws that the multiplicities and the grades share, the order by the meet, and the properties that follow from them.
- [Multiplicities](0036-type-system/03-multiplicities.md): the numbers of uses $`0`$, $`1`$ and $`\omega`$, their operations, their order and their meaning.
- [Grades](0036-type-system/04-grades.md): the pairs of multiplicities that count the uses at run time and in total, their meaning, their properties and their projection on the run-time multiplicity.
- [Modes](0036-type-system/05-modes.md): the three settings in which the usage of a term is checked, and their structure on the grades.
- [Levels](0036-type-system/06-levels.md): the indices of the sorts, their values, their equality, their order and their properties.
- [Sorts](0036-type-system/07-sorts.md): the universes of types and of propositions, their qualities, the join of the qualities and the relation by which a sort bounds another.
- [Syntax](0036-type-system/08-syntax.md): the terms, among them the constructors and the recursors of the data types, their arguments, the motives and the branches of the recursors, the telescopes, the contexts and the signatures, with the variables they bind.
- [Substitution](0036-type-system/09-substitution.md): the substitutions of the first and of the second order, the closed substitutions, the instantiation of the level variables and their properties.
- [Grade vectors](0036-type-system/10-grade-vectors.md): the grades of the variables of a scope, their operations, their order and their properties.
- [Usage](0036-type-system/11-usage.md): the judgment that checks, in a mode, how a term uses the variables of its scope.
- [Ownership](0036-type-system/12-ownership.md): the judgment that checks, in a mode, the ownership of the value of a term.
- [Typing](0036-type-system/13-typing.md): the judgments of the signatures, of the contexts, of the types, of the terms and of their arguments, their rules and their properties.
- [Reduction](0036-type-system/14-reduction.md): the weak head reduction, its head normal forms, the computation of the closed terms and their determinism.
- [Erasure](0036-type-system/15-erasure.md): the translation to an untyped target language that replaces with a value the parts of a term whose grade is in a set, the sets of grades that the modes do not count, and the absence of the erased variables.
- [Meaning](0036-type-system/16-meaning.md): the meaning of the judgments of the typing, the interpretation of the constant declarations, the equality of the canonical terms of the sorts, the exactness of the meaning for the proofs, and the soundness of the typing under an interpretation of the constant declarations.

## Drawbacks

The type system has these drawbacks:

- One RFC for the whole type system is a large document to review, even with the definitions in the annexes; its parts are accepted together, since none of them stands alone.
- Seven grades, among which a programmer chooses on every binder, are many: the surface language has to infer most of them, which no RFC designs yet.
- The ownership adds a requirement to every entry of a telescope and an ownership to every second-order variable and constant, which the surface language has to infer as well.
- Without cumulativity, a program polymorphic in its universes writes its levels and their joins, as in Agda and in Lean.
- Without impredicative propositions, the encodings that quantify a proposition over all propositions, which Lean and Rocq accept, are not available.
- The constant definitions are transparent: a library cannot hide the body of a definition from the equality, until the modules of a later RFC give a way to hide it.
- A constant whose body checks a position with a grade variable is compiled once for each instance of its grades that a program uses, which enlarges the program, as the monomorphization of Rust does.
- The soundness holds under an interpretation of the constant declarations: a signature whose axioms contradict each other has none, so that its programs get no guarantee, and the type system does not check that the axioms of a program have an interpretation.
- The meaning of the grades counts the uses that a term makes, not those that a program makes when it runs, which depend on the evaluation order; the run-time multiplicities $`1`$ and $`\omega`$ wait for the RFC of the calling convention to mean a number of uses.

## Rationale and Alternatives

This section gives the principles of the design, then the choices that settle each part of the system, in the order of the proposal, and why the system is one RFC.

### Principles

The design of the type system follows a few principles, which explain most of its choices:

- Soundness first: a program the compiler accepts has the properties its types state, as [RFC 13](https://github.com/sic-lang/rfcs/pull/13) requires, and no other benefit justifies weakening it.
- No two mechanisms for the same thing: a need that an existing piece already meets gets no second piece, so that every piece has one role and the system stays small.
- Few pieces, but powerful ones: a piece is chosen general enough to cover several needs, as a codata type whose destructors take arguments gives both the functions and the additive conjunction $`\&`$ of linear logic.
- Embrace duality where it exists: when a construct has a dual, both are given together and named after each other, as the data types and the codata types.
- No speculative mechanism: a piece enters the system for a use that exists, not for one that might come.
- Conscious exclusions: what the system leaves out is stated with what is lost, what remains, and whether it can be added later.

### Choices on the Grades

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

### Choices on the Levels and Sorts

The levels and the sorts are settled by the following choices:

- The levels are not terms: they appear only as the indices of the sorts, and their equality is defined by their values rather than by rules of equality, unlike the formalization of Abel, Danielsson and Eriksson, whose levels are terms of a type of levels since [Danielsson, Favier and Kubánek](https://doi.org/10.1145/3776645); no term computes a level, so that no rule is needed to compare two of them, and their equality is decidable.
- The sort of a type declaration may be the join of two qualities, as its level may be the join of two levels, so that a pair holds two fields of independent sorts; the sort constraints of the [bounded sort polymorphism](https://doi.org/10.1145/3776732) of Rocq would be one mechanism more, for this need only.
- Conscious exclusion of the quantification over levels: no type quantifies over levels, so that no universe is needed beyond the two hierarchies, as the $`\mathsf{Set}\omega`$ of [Agda](https://agda.readthedocs.io/en/latest/language/universe-levels.html) is; the level variables give the polymorphism that programs need, and a quantification could be added later with a universe above the hierarchies.

### Choices on the Syntax and Substitution

The syntax and the substitution are settled by the following choices:

- The variables are named, as in the paper of Abel, Danielsson and Eriksson, rather than numbered by the de Bruijn indices of its formalization: an index is a way to represent the bound variables, which the system does not need to fix.
- The sort and grade variables of an entry are not part of the terms: an entry stands for its instances, as a rule for the instances of its fraction, so that no judgment meets a grade variable, whose order with the other grades would be unknown; the level variables are part of the terms, since an entry is checked once with them and used at any levels.
- The parameters that depend on variables are second-order variables, as the contextual types of Nanevski, Pfenning and Pientka, rather than parameters of a type of functions: the type of functions is itself declared, and its type declaration cannot take a function as a parameter.
- The substitutions of the first and of the second order are defined apart, as in the theory of Nanevski, Pfenning and Pientka: the second one substitutes the arguments of an application in the abstraction it gives, which is not a part of the term it substitutes, and the first one does it.

### Choices on the Judgments, Usage and Ownership

The judgments, the usage and the ownership are settled by the following choices:

- Typing and equality carry no grade, as in the theory of Abel, Danielsson and Eriksson, rather than carrying them in the typing judgment, as the [graded modal dependent type theory](https://arxiv.org/abs/2010.13163) of Moon, Eades and Orchard does: the latter checks every subterm as if it ran, even in an erased position, so that a specification cannot return an erased field; a usage indexed by a mode checks an erased subterm in a mode of its own, and the equality compares values, not uses, which removes no guarantee, since the usage of every term is checked.
- The judgments are the four of Martin-Löf type theory, as in the theory of Abel, Danielsson and Eriksson and in [Abel, Öhman and Vezzosi](https://doi.org/10.1145/3158111), rather than those of a [pure type system](https://en.wikipedia.org/wiki/Pure_type_system), in which a type is a term of a sort and two types are equal only as terms of a sort, so that two equalities of types in different sorts compose only once the two sorts are shown equal; a type is still a term of a sort, as the only rules that conclude that a term is a type say.
- The signature is explicit in every judgment, as the global environment of [Rocq](https://rocq-prover.org/doc/master/refman/language/cic.html), rather than ambient: a rule says which entries it reads.
- A constant definition is an entry of the signature with a mode, rather than a binding in a term or a text to inline: it is checked once, with its sort, level and grade variables, and used in the modes it allows, as the modes of [Verus](https://doi.org/10.1145/3586037) separate the specifications, the proofs and the code that runs; inlining would check each use again, and lose the polymorphism of its variables.
- The constant definitions are transparent: an opaque definition would hide a body from the equality, which the strict propositions already do for the proofs, and which the modules of a later RFC may do for the other terms.
- One entry, the constant declaration, covers the axioms, the ghost constants and the foreign constants, told apart by their sort and their mode, rather than three entries, or primitive types with rules of their own, as the [primitive integers and arrays](https://rocq-prover.org/doc/master/refman/language/core/primitive.html) of Rocq: a foreign type is a constant whose representation the implementation chooses.
  A constant uses no variable, so that a foreign function that creates a resource to be used once, such as a handle, must consume a resource to do so, a capability that the program holds with a linear grade, as the world token of [Idris 2](https://arxiv.org/abs/2104.00480) threads its effects.
- The propositions are strict, as the `Prop` of [Agda](https://agda.readthedocs.io/en/latest/language/prop.html), from [Gilbert, Cockx, Sozeau and Tabareau](https://doi.org/10.1145/3290316): a proof carries no information but its existence, so that two proofs of a proposition are equal by definition, and a proof is never needed at run time.
- The ownership is a judgment of its own, rather than an attribute of the types, as the unique types of [Marshall, Vollmer and Orchard](https://doi.org/10.1007/978-3-030-99336-8_13) and the uniqueness mode of [Lorenzen, White, Dolan, Eisenberg and Lindley](https://doi.org/10.1145/3674642): the typing and the equality carry no grade, as for the usage, and the ownership counts with the grades of the usage, so that it adds no structure on the grades.
- The ownership counts the uses of a value during a whole run, rather than its past uses only, as uniqueness does, or its future uses only, as linearity does, which Marshall, Vollmer and Orchard tell apart: one grade states both, and the judgment follows no order of the uses.
  A program passes a value from one use to the next, as a read that returns the value it reads, so that the order of the uses is that of the data, and the ownership depends on no order of evaluation, which the RFC of the calling convention fixes; a value used before a use that requires it alone, without being passed from one to the other, is rejected, although the earlier use is over.
- The ownership of the variables is the same in every premise of a rule, as the context of the typing, rather than computed by each premise and added, as the vector of the usage: the ownership of a variable comes from the argument that its binder receives, while its usage comes from the term that uses it.
- Each entry of a telescope has a requirement of its own, rather than the telescope one relation on the ownerships of all its arguments, so that each argument is checked alone, as the usage checks it with the grade of its entry.
- The ownership of the result of a second-order variable is a meet of an optional constant and of optional factors, rather than one grade or one argument whose ownership it takes: a result may be an alias of an argument in one branch and a fresh value in another, and the coefficient of a factor scales the ownership of the argument, as for an alias that a proof also mentions.
- The ownership of a constant declaration is trusted, as its type is, rather than left out: a foreign constant has no body to check, and its ownership says whether its value may be shared, which no other piece states.
- Conscious exclusions, each with what is lost, what remains, and whether it can be added later:
  - Impredicative propositions: a proposition cannot quantify over all propositions; the levels give the quantifications over the propositions of a lower level, which cover the usual encodings, and the sort variables give one entry for the types and the propositions.
    With definitional proof irrelevance, impredicativity makes the equality of types undecidable, as [Abel and Coquand](https://doi.org/10.23638/LMCS-16(2:14)2020) show, so it is excluded rather than deferred.
  - Cumulativity: a type of $`U_l`$ is not a type of $`U_{l + 1}`$; it is deferred, since adding it later only accepts more programs, at the cost of a subtyping in place of the equality of types.
  - Fractions of ownership: several uses of a value at once followed by a use that requires it alone, which the [fractional uniqueness](https://doi.org/10.1145/3649848) of Marshall and Orchard accepts, are rejected, since the sum $`1 + 1 = \omega`$ of the multiplicities cannot be undone; the sequential case passes the value from one use to the next, and fractions could be added later, at the cost of a larger modality.

### Choices on the Reduction and Erasure

The reduction and the erasure are settled by the following choices:

- The reduction is weak head, rather than to full normal forms: the meaning of a closed term and the comparison of two terms need only their heads, as in the decision procedure for the equality of [Abel, Öhman and Vezzosi](https://doi.org/10.1145/3158111), which the formalization of Abel, Danielsson and Eriksson extends; it is untyped, so that a step needs no typing, and that a step keeps the type of a term is a property of the reduction, not a condition of its steps.
- The reduction is the computation of the type theory, not the evaluation of a program: the computation is deterministic, and the guarantees of the system hold whatever the order in which a program runs.
  The costs, the order of the foreign effects and the evaluation of the parts of a term that are taken one at a time belong to the RFC of the calling convention, whose direction is the call-by-push-value of [Levy](https://doi.org/10.1007/978-94-007-0954-6), by polarity, as [Downen, Sullivan, Ariola and Peyton Jones](https://doi.org/10.1007/978-3-030-17184-1_5) evaluate data by value and codata on observation; that RFC has to check again, on the machine it chooses, the resource correctness of the usage of recursion, which [Eriksson, Abel and Danielsson](https://doi.org/10.1145/3828677) prove for a call-by-name machine.
- One erasure, parametrized by the set of grades it erases, rather than an erasure for the run time and another for the proofs, each with clauses of its own: each kind of type declaration gives the clauses of its terms once, and the erasure of each mode is an instance.
- The erasures by two sets are compared by an order on the target language, in which a term is less defined than another when it has $`\text{↯}`$ in place of some of its parts, rather than by erasing an erased term again, which would need grades in the target language.
- A constant keeps the grades of its instance, rather than having one copy that receives its erased parts at run time: the parts of its body that the erasure removes depend on these grades, so that each instance has a program of its own, with nothing left of the grades.

### Choices on the Meaning

The meaning is settled by the following choices:

- The meaning is given by the computation of the terms, as in the meaning explanations of Martin-Löf type theory, rather than by a model in another theory, such as sets: a judgment says what its terms compute by the reduction of the typing, so that what it guarantees is about the terms of Sic themselves.
- The constant declarations are interpreted, rather than given a meaning of their own: an axiom or a foreign constant has no body to compute, and the soundness holds under every interpretation that gives each of them a term of its type, so that a program depends on its declarations as on hypotheses.
- Every judgment of the typing has a meaning, the telescopes in a sort and the arguments of an instance included, rather than the closed equality alone, so that the soundness is stated for each judgment that the rules derive, and the application of a second-order variable has the meaning of its arguments.
- The terms of a proposition need not compute: the equality of a proposition relates the terms themselves, all when it is true and none when it is false, so that a proof, which the erasure removes, is never computed, and the meaning is exact for the rule of the irrelevance of the proofs.
- What the usage and the ownership guarantee at run time, and the soundness of the erasure, wait for the kinds of type declarations, rather than being stated in the core: every closed term of the core computes to a sort, whose erasure is $`\text{↯}`$, so that these statements would hold of no program that runs.

### One RFC

The type system was first split into four RFCs, the grades, the core, the data and codata types, and the observational equality, linked by a contract that each kind of type declaration fulfills.
The split did not hold: the data and codata types kept deferring to the equality what they needed, the indexed families, the extensionality of the recursive types, and the liftings through some nested types, while the equality is defined on the data and codata types.
One RFC with short annexes keeps the definitions readable, one subject at a time, without a cycle between documents.

## Prior Art

The type system builds on the following work:

- The abstract interpretation of [Cousot and Cousot](https://doi.org/10.1145/512950.512973) and its [best abstractions](https://doi.org/10.1145/567752.567778) give the meaning of the multiplicities and of the grades.
- Grades on binders come from [McBride](https://doi.org/10.1007/978-3-319-30936-1_12) and the quantitative type theory of [Atkey](https://doi.org/10.1145/3209108.3209189), which [Idris 2](https://arxiv.org/abs/2104.00480) implements with the multiplicities $`0`$, $`1`$ and $`\omega`$, and threads its effects through a linear world token, and [Linear Haskell](https://ghc.gitlab.haskell.org/ghc/doc/users_guide/exts/linear_types.html) with $`1`$ and $`\omega`$.
- The graded dependent type theory of [Abel, Danielsson and Eriksson](https://doi.org/10.1145/3607862), extended in their [journal version](https://arxiv.org/abs/2603.29716) and [formalized in Agda](https://github.com/graded-type-theory/graded-type-theory), on which the rules of the type system are built: it parametrizes its rules by a modality and a mode structure, which the grades and the modes instantiate, and [Eriksson, Abel and Danielsson](https://doi.org/10.1145/3828677) add the well-behaved greatest lower bounds that the usage of recursion needs.
- The [graded modal dependent type theory](https://arxiv.org/abs/2010.13163) of Moon, Eades and Orchard carries grades in typing, and [Granule](https://doi.org/10.1145/3341714) is a language built on graded modal types, whose semirings include exact counts.
- The levels follow those of [Lean](https://lean-lang.org/doc/reference/latest/The-Type-System/Universes/), built from zero, the successor, the maximum and prenex variables, and the sort variables the [sort polymorphism of Rocq](https://rocq-prover.org/doc/master/refman/addendum/universe-polymorphism.html), whose theory [Bounded Sort Polymorphism with Elimination Constraints](https://doi.org/10.1145/3776732) gives.
- The second-order variables follow the contextual types of [Nanevski, Pfenning and Pientka](https://doi.org/10.1145/1352582.1352591), whose metavariables stand for terms under the variables of a context, and whose substitution of the metavariables is defined apart from that of the variables.
- The judgments are those of Martin-Löf type theory, and their meaning follows its meaning explanations, in which a judgment is true when its terms compute as it says, as [Nordström, Petersson and Smith](https://intuitionistic.wordpress.com/wp-content/uploads/2010/07/nordstrom-et-al-type-theory.pdf) present them, and the signature follows the global environment of [Rocq](https://rocq-prover.org/doc/master/refman/language/cic.html), an ordered list of declarations, definitions and assumptions.
- The uniqueness types of [Clean](https://doi.org/10.1017/S0960129500070109), from Barendsen and Smetsers, guarantee that a value has no other reference, so that it can be updated in place; [Marshall, Vollmer and Orchard](https://doi.org/10.1007/978-3-030-99336-8_13) relate uniqueness, a guarantee on the past uses, to linearity, a restriction of the future ones, [Marshall and Orchard](https://doi.org/10.1145/3649848) add fractions to share a unique value for a while, and [Lorenzen, White, Dolan, Eisenberg and Lindley](https://doi.org/10.1145/3674642) give OCaml a uniqueness mode on its types; all of them check uniqueness in the typing, where Sic checks the ownership by a judgment of its own, after the usage of Abel, Danielsson and Eriksson, which they check apart from the typing, and with the grades of the usage.
- The strict propositions follow the `Prop` of [Agda](https://agda.readthedocs.io/en/latest/language/prop.html) and the `SProp` of Rocq, both from [Gilbert, Cockx, Sozeau and Tabareau](https://doi.org/10.1145/3290316).
- The weak head reduction follows the decision procedure for the equality of [Abel, Öhman and Vezzosi](https://doi.org/10.1145/3158111), and the erasure the extraction of Abel, Danielsson and Eriksson, which it extends with a set of erased grades; the order between erasures follows the approximants of the Böhm trees of [Kerinec, Manzonetto and Pagani](https://doi.org/10.23638/LMCS-16(3:6)2020), below which the undefined value lies.
- [Verus](https://doi.org/10.1145/3586037) separates the code that runs from the specifications and proofs by [modes of variables](https://verus-lang.github.io/verus/guide/reference-var-modes.html), as the modes of the constants of Sic, and tracks ghost resources linearly, which the grades `none / linear` and `linear / unrestricted` express in Sic.

## Unresolved Questions

These questions remain open:

- The annexes are written as the system is settled, subject by subject, so that the list above grows with them.
- What do the run-time multiplicities $`1`$ and $`\omega`$ mean for a program that runs?
  The meaning of the grades counts the uses that a term makes, and the uses made when it runs depend on the evaluation order, which the RFC of the calling convention fixes.
- What do the usage and the ownership of a term guarantee of its erasure when it runs, and is the erasure sound for the meaning?
  Every closed term of the core computes to a sort, whose erasure is $`\text{↯}`$: the statements need the terms that the kinds of type declarations bring, and the evaluation order that the RFC of the calling convention fixes.
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
