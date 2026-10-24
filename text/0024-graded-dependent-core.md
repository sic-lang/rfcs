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
| $`p, q, r`$ | Grades, elements of the semiring of the [grades](#grades) |
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
| `m ᵐ· p` | $`m \odot p`$ |
| `𝟘ᵐ`, `𝟙ᵐ` | $`\mathbb{0}\mathbb{0}^{\mathsf{m}}`$, $`\mathbb{1}\mathbb{1}^{\mathsf{m}}`$, with the [mode](#modes) $`\mathbb{0}\mathbb{1}^{\mathsf{m}}`$ between them |

### Grading

The grading of the core counts the uses of the variables, with which the [usage](#judgments) of a term is checked: a multiplicity counts uses, a grade pairs the multiplicity of the uses at run time with that of all the uses, and a mode is the setting of the check, which follows from the grades.

#### Multiplicities

A multiplicity counts the uses of a variable, as the multiplicities of [Idris 2](https://arxiv.org/abs/2104.00480) and of [Linear Haskell](https://ghc.gitlab.haskell.org/ghc/doc/users_guide/exts/linear_types.html) do: it is $`0`$, $`1`$ or $`\omega`$, where $`\omega`$ stands for any number of uses, none included, as in the linear modality of ADE.
The multiplicities are added, multiplied and met as follows:

| $`+`$ | $`0`$ | $`1`$ | $`\omega`$ |
| --- | --- | --- | --- |
| $`0`$ | $`0`$ | $`1`$ | $`\omega`$ |
| $`1`$ | $`1`$ | $`\omega`$ | $`\omega`$ |
| $`\omega`$ | $`\omega`$ | $`\omega`$ | $`\omega`$ |

| $`\cdot`$ | $`0`$ | $`1`$ | $`\omega`$ |
| --- | --- | --- | --- |
| $`0`$ | $`0`$ | $`0`$ | $`0`$ |
| $`1`$ | $`0`$ | $`1`$ | $`\omega`$ |
| $`\omega`$ | $`0`$ | $`\omega`$ | $`\omega`$ |

| $`\wedge`$ | $`0`$ | $`1`$ | $`\omega`$ |
| --- | --- | --- | --- |
| $`0`$ | $`0`$ | $`\omega`$ | $`\omega`$ |
| $`1`$ | $`\omega`$ | $`1`$ | $`\omega`$ |
| $`\omega`$ | $`\omega`$ | $`\omega`$ | $`\omega`$ |

The multiplicities are ordered by their meet, as in ADE: $`\omega`$ is below $`0`$ and below $`1`$, while $`0`$ and $`1`$ are not comparable, so that a variable of multiplicity $`\omega`$ may be used any number of times, none included, one of multiplicity $`1`$ exactly once and one of multiplicity $`0`$ never.

#### Grades

A grade counts the uses of a variable along the two axes of the [grades](https://github.com/sic-lang/rfcs/pull/16) of Sic: its uses at run time, and all its uses, erased or not.
It is a pair of [multiplicities](#multiplicities), written in angle brackets, whose first multiplicity counts the uses at run time and the second all the uses.
The run-time uses are among all the uses, so a pair whose second multiplicity is $`0`$ has $`0`$ as its first multiplicity too: of the nine pairs, the seven others are the grades.
The grade $`\langle 0, 0 \rangle`$ is written $`\mathbb{0}`$ and $`\langle 1, 1 \rangle`$ is written $`\mathbb{1}`$.

The operations act on each multiplicity, and the seven grades are closed under them.

The order of the grades is that of ADE: $`p \le q`$ when $`p = p \wedge q`$, which means that a variable of grade $`p`$ may be used where the grade $`q`$ is expected; it is the order of the multiplicities on each component.

The grade $`\langle \omega, 1 \rangle`$ is the meet of $`\langle 0, 1 \rangle`$ and $`\mathbb{1}`$: a variable used once in total, erased in one branch and at run time in another, is used once in total and at most once at run time.
Without it, this meet would be $`\langle \omega, \omega \rangle`$, and the multiplication would not distribute over the meet, as ADE requires of a modality: $`\langle 0, 1 \rangle \cdot (\langle 0, 1 \rangle \wedge \mathbb{1})`$ would be $`\langle 0, \omega \rangle`$, and $`\langle 0, 1 \rangle \cdot \langle 0, 1 \rangle \wedge \langle 0, 1 \rangle \cdot \mathbb{1}`$ would be $`\langle 0, 1 \rangle`$.

The seven grades form a modality of ADE whose zero is well behaved, as its modes require: $`\mathbb{0} \ne \mathbb{1}`$, a sum or a meet is $`\mathbb{0}`$ only if both operands are, and a product is $`\mathbb{0}`$ only if one of its factors is.
The two excluded pairs would break the last condition: $`\langle 1, 0 \rangle \cdot \langle 0, 1 \rangle`$ and $`\langle \omega, 0 \rangle \cdot \langle 0, 1 \rangle`$ are both $`\mathbb{0}`$.
These properties were checked in Agda by instantiating the modality structure of the formalization of ADE with the seven grades.

Each grade has a name in Sic, made of the names of its two multiplicities: `none`, `linear` and `unrestricted` for $`0`$, $`1`$ and $`\omega`$, except a run-time multiplicity $`\omega`$ under a total multiplicity $`1`$, named `affine` since it counts at most one use:

| Name | Grade |
| --- | --- |
| `none / none` | $`\mathbb{0}`$ |
| `none / linear` | $`\langle 0, 1 \rangle`$ |
| `none / unrestricted` | $`\langle 0, \omega \rangle`$ |
| `linear / linear` | $`\mathbb{1}`$ |
| `linear / unrestricted` | $`\langle 1, \omega \rangle`$ |
| `affine / linear` | $`\langle \omega, 1 \rangle`$ |
| `unrestricted / unrestricted` | $`\langle \omega, \omega \rangle`$ |

For instance, passing a permission of grade `none / linear` to a parameter of the same grade uses it with the grade $`\langle 0, 1 \rangle \cdot \mathbb{1} = \langle 0, 1 \rangle`$: once, and never at run time.

#### Modes

A mode is the setting in which the [usage](#judgments) of a term is checked.
The core has three modes, named after their grade $`\ulcorner m \urcorner`$, with which a variable checked in the mode $`m`$ uses itself:

| Mode | Grade | Counts |
| --- | --- | --- |
| $`\mathbb{0}\mathbb{0}^{\mathsf{m}}`$ | $`\mathbb{0}`$ | no use |
| $`\mathbb{0}\mathbb{1}^{\mathsf{m}}`$ | $`\langle 0, 1 \rangle`$ | all the uses, none at run time |
| $`\mathbb{1}\mathbb{1}^{\mathsf{m}}`$ | $`\mathbb{1}`$ | all the uses and the uses at run time |

A term used with the grade $`p`$ is checked in the mode $`\llcorner p \lrcorner`$ of this grade: $`\mathbb{0}\mathbb{0}^{\mathsf{m}}`$ for $`\mathbb{0}`$, $`\mathbb{0}\mathbb{1}^{\mathsf{m}}`$ for the other grades whose run-time multiplicity is $`0`$, those of proofs, specifications and permissions, and $`\mathbb{1}\mathbb{1}^{\mathsf{m}}`$ for the grades used at run time; the program itself is checked in $`\mathbb{1}\mathbb{1}^{\mathsf{m}}`$.
Modes are never written: they follow from the grades, and the two erased modes appear only inside the program, where a rule checks a subterm used with an erased grade, such as an erased argument, a proof, or the domain of the type of a function.
The product of two modes is the mode of the product of their grades, $`m_1 \cdot^{\mathsf{m}} m_2 = \llcorner \ulcorner m_1 \urcorner \cdot \ulcorner m_2 \urcorner \lrcorner`$, whose grade is the product $`\ulcorner m_1 \urcorner \cdot \ulcorner m_2 \urcorner`$ itself since the grades of the three modes are closed under multiplication; it is the more erased of the two modes.
Inside a term checked in the mode $`m`$, a subterm used with the grade $`p`$ is checked in the mode $`m \odot p = m \cdot^{\mathsf{m}} \llcorner p \lrcorner`$, written as in the paper of ADE, so that a subterm, once erased, stays erased.

ADE has the two modes $`\mathbb{0}^{\mathsf{m}}`$ and $`\mathbb{1}^{\mathsf{m}}`$ only, which are $`\mathbb{0}\mathbb{0}^{\mathsf{m}}`$ and $`\mathbb{1}\mathbb{1}^{\mathsf{m}}`$ here.
The mode $`\mathbb{0}\mathbb{1}^{\mathsf{m}}`$ is added so that an erased term still counts all its uses: in $`\mathbb{0}^{\mathsf{m}}`$, a proof could drop or duplicate a permission of grade `none / linear`.
The three modes form a mode structure of the formalization of ADE, which defines modes abstractly; this was checked in Agda with the seven grades.

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

- Is a term checked in the mode $`\mathbb{0}\mathbb{1}^{\mathsf{m}}`$ erased safely?
  ADE prove the soundness of erasure for their two modes only; the projection of a grade on its run-time multiplicity preserves the operations and the order, and could carry their result to the three modes.
