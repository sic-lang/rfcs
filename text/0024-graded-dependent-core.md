# RFC 0024: Graded Dependent Core

- Pull request: [sic-lang/rfcs#24](https://github.com/sic-lang/rfcs/pull/24)

## Summary

This RFC defines the graded dependent core of Sic: dependent functions, a predicative hierarchy of universes with prenex universe polymorphism, a sort of strict propositions, and records whose fields carry grades.
Its rules extend the graded dependent type theory of [Abel, Danielsson and Eriksson](https://doi.org/10.1145/3607862), whose metatheory is [formalized in Agda](https://github.com/graded-type-theory/graded-type-theory), with the [grades](https://github.com/sic-lang/rfcs/pull/16) of Sic.
It is the first of the RFCs of the core calculus; equality, inductive and coinductive types, and totality are left to the next ones.

## Motivation

Sic writes a program and its proofs in the [same language](https://github.com/sic-lang/rfcs/pull/13), which requires types that depend on values.
The [grades](https://github.com/sic-lang/rfcs/pull/16) decide how the core counts the uses of each variable, and leave the rest of the core to later RFCs.
This RFC gives the typing rules of the constructs on which every later RFC of the core builds.

## Proposal

The proposal first fixes the notation, the grading, which counts the uses of the variables, and the judgments of the core.
It then defines the universes, the strict propositions, the functions and the records, each with its rules of typing and of usage, and ends with the conversion, the erasure and examples.

### Notation

The rules of this RFC are those of the graded dependent type theory of [Abel, Danielsson and Eriksson](https://doi.org/10.1145/3607862) (ADE), extended by the later sections, and they use the notation of its formalization, except where the [correspondence](#correspondence-with-ade) below says otherwise.
This section introduces the conventions of all the rules; the symbols of a single construct are introduced with it.

#### Letters

Each letter keeps one kind and one rank, so that the rank of an object (scalar or vector) is read from its letter, as the type of an object tells its rank in Lean:

| Letters | Denote |
| --- | --- |
| $`x, y`$ | Variables |
| $`t, a`$ | Terms, $`a`$ being a term substituted for a variable |
| $`A, B`$ | Types |
| $`\Gamma`$ | Contexts, sequences of declarations $`x : A`$ |
| $`p, q, r`$ | Grades, elements of the semiring of the [grades](#grading) |
| $`\gamma, \delta`$ | Vectors of grades, one grade per variable of the context |
| $`m`$ | Modes, in which a term is checked for its uses |

A subscript numbers objects of the same kind that come from different premises, as $`\gamma_1`$ and $`\gamma_2`$; it never selects a component.

The operations on grades are those of ADE:

```math
p + q \qquad p \cdot q \qquad p \wedge q \qquad \gamma +^{\mathsf{c}} \delta \qquad p \cdot^{\mathsf{c}} \gamma \qquad \gamma \wedge^{\mathsf{c}} \delta
```

The first three are the addition, the multiplication and the meet of the grades; the last three, marked with $`\mathsf{c}`$, act on each component of the vectors, the multiplication of a vector by a grade multiplying each of its components.
The zero vector, whose components are all the zero grade, has as many components as the context, whatever its length, and is written $`\mathbb{0}^{\mathsf{c}}`$.
A vector extended by a grade for a new variable is written $`\gamma \bullet p`$.
The vector $`\gamma`$ in which the grade of the variable $`x`$ is replaced by $`p`$ is written $`(\gamma, x \mathrel{≔} p)`$.

#### Binders

A binder carries two grades, written on the type of functions as in the paper of ADE, with a named variable and a dot before the type it binds in:

```math
\Pi^{q}_{p}\, (x : A).\, B
```

A function of this type uses its argument with the grade $`p`$ in its body, and its type uses the argument with the grade $`q`$ in $`B`$.

#### Correspondence With ADE

The rules use the notation of the formalization of ADE, which differs slightly from that of its paper, and depart from it only as follows:

| Formalization of ADE | This RFC |
| --- | --- |
| `var x0`, `var x1`, de Bruijn indices | $`x`$, $`y`$, named variables |
| `Γ ⊢ t ∷ A`, `Γ ⊢ t ≡ u ∷ A` | $`\Gamma \vdash t : A`$, $`\Gamma \vdash t \equiv u : A`$ |
| `Π p , q ▷ A ▹ B` | $`\Pi^{q}_{p}\, (x : A).\, B`$ |
| `γ ▸[ m ] t` | $`\gamma \mathrel{▶_m} t`$ |

### Grading

To be written.

### Judgments

To be written.

### Universes

To be written.

### Strict Propositions

To be written.

### Functions

To be written.

### Records

To be written.

### Conversion

To be written.

### Erasure

To be written.

### Examples

To be written.

## Drawbacks

To be written.

## Rationale and Alternatives

- Typing and equality carry no grade, as in ADE, instead of carrying them in the typing judgment as [graded modal dependent type theory](https://arxiv.org/abs/2010.13163) (GrTT, Moon, Eades and Orchard) does.
  GrTT checks every subterm as if it ran, even in an erased position: a specification cannot return an erased field, and a field that does not exist at run time has no projection.
  The usage judgment of ADE, indexed by a mode, checks an erased subterm in a mode of its own, and its metatheory is formalized.
  Equality then compares values, not uses, which removes no guarantee: it only compares types, and the usage of every term is checked.

## Prior Art

To be written.

## Unresolved Questions

To be written.
