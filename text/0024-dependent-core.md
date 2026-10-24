# RFC 0024: Dependent Core

- Pull request: [sic-lang/rfcs#24](https://github.com/sic-lang/rfcs/pull/24)

## Summary

This RFC defines the dependent core of Sic: dependent functions, a predicative hierarchy of universes with prenex universe polymorphism, a sort of strict propositions, and records whose fields carry grades.
Its rules extend [graded modal dependent type theory](https://arxiv.org/abs/2010.13163) with the grades of the [modes](https://github.com/sic-lang/rfcs/pull/16).
It is the first of the RFCs of the core calculus; equality, inductive and coinductive types, and totality are left to the next ones.

## Motivation

The first of the [layers](https://github.com/sic-lang/rfcs/pull/13) requires types that depend on values, so that a program and its proofs are written in the same language.
The [modes](https://github.com/sic-lang/rfcs/pull/16) decide how the core counts the uses of each variable, and leave the rest of the core to later RFCs.
This RFC gives the typing rules of the constructs on which every later RFC of the core builds.

## Proposal

### Notation

The rules of this RFC are those of [graded modal dependent type theory](https://arxiv.org/abs/2010.13163) (GrTT, Moon, Eades and Orchard, ESOP 2021), extended by the later sections, but they lay out the grades differently: each grade is written before the declaration it describes, instead of before the whole context.
This section introduces the conventions of all the rules; the symbols of a single construct are introduced with it.

#### Letters

Each letter keeps one kind and one rank, so that the rank of an object (scalar, vector or matrix) is read from its letter, as the type of an object tells its rank in Lean:

| Letters | Denote |
| --- | --- |
| $`x, y`$ | Variables |
| $`t, a`$ | Terms, $`a`$ being a term substituted for a variable |
| $`A, B`$ | Types |
| $`\Gamma`$ | Contexts, sequences of declarations $`x : A`$ |
| $`p, q`$ | Usages, the two counts that make up a [grade](#grades) |
| $`r, s`$ | Grades, elements of the semiring of the [grades](#grades) |
| $`g, g'`$ | Vectors of grades, one grade per variable of the context |
| $`G`$ | Matrix of the grades with which the types of the context use the variables before them |

A subscript numbers objects of the same kind that come from different premises, as $`g_1`$ and $`g_2`$; it never selects a component.
Components are selected by application, as in Lean: $`G\ i`$ is the row of $`G`$ for the type of the $`i`$-th variable, and $`G\ i\ j`$, defined for $`j < i`$, is the grade with which this type uses the $`j`$-th variable.
A prime only marks a usage in the type of the judgment, as $`g'`$: a second grade of the same kind is written $`r_2`$, not $`r'`$.

The operations on grades are those of GrTT:

```math
r + s \qquad r \cdot s \qquad g_1 + g_2 \qquad s * g
```

The first two are the addition and the multiplication of the semiring, the third adds two vectors component by component, and the last multiplies each component of a vector by a grade.
A literal vector is written in parentheses, as in GrTT, since a digit alone cannot tell a grade from a vector of one component:

```math
(1, 0) \qquad (1) \qquad ()
```

Only $`0`$ is written without parentheses: it is the zero grade or the zero vector, according to its place.

#### Grades Before What They Describe

A judgment carries three grades for its context, written in brackets before it in the order of GrTT:

```math
[G \mid g \mid g']\ \Gamma \vdash t : A
```

From left to right, they say how the types of the context use the variables before them, how the term uses each variable, and how its type does.
The matrix has a row for each variable of the context, and each vector a grade for each variable.
Brackets keep the three grades apart from a literal vector, written in parentheses.

When a declaration extends a context, its slice of these three grades is written in brackets before the declaration:

```math
[G \mid g_1 \mid g']\ \Gamma,\ [g_2 \mid r \mid 0]\ x : A \vdash t : B
```

The slice gives, in the same order, the row of the matrix for the type of the new variable, the usage of the variable in the term and its usage in the type of the term; extending the context extends each of the three grades of the context by its component of the slice.
The example of GrTT, the body of a function that takes a type and two arguments of that type and returns the first, reads:

```math
[() \mid 0 \mid 1]\ a : U,\ [(1) \mid 1 \mid 0]\ x : a,\ [(1, 0) \mid 0 \mid 0]\ y : a \vdash x : a
```

The type is used once by the type of each argument and once by the type of the result, the first argument once by the term, and the second argument nowhere.

A binder carries two grades, written in brackets before its declaration and separated by a comma, as the pair of grades of GrTT:

```math
([s, r]\ x : A) \to B
```

A function of this type uses its argument with the first grade in its body and with the second in its result type.
The comma distinguishes the annotation of a binder from the slice of a declaration in a context, written with bars.

#### Correspondence With GrTT

| GrTT | This RFC |
| --- | --- |
| $`(\Delta \mid \sigma_s \mid \sigma_r) \odot \Gamma \vdash t : A`$ | $`[G \mid g \mid g']\ \Gamma \vdash t : A`$ |
| $`\Delta`$, $`\Delta[i]`$ | $`G`$, $`G\ i`$ |
| $`\sigma_s`$, $`\sigma_r`$ | $`g`$, $`g'`$ |
| $`\sigma_1`$, $`\sigma_2`$ | $`g_1`$, $`g_2`$ |
| $`(x :_{(s, r)} A) \to B`$ | $`([s, r]\ x : A) \to B`$ |

### Grades

A grade counts the uses of a variable along the two axes of the [modes](https://github.com/sic-lang/rfcs/pull/16): its uses at run time, and all its uses, erased or not.
Each count is a usage of the linear structure of [Abel, Danielsson and Eriksson](https://arxiv.org/abs/2603.29716), a semiring on $`0`$, $`1`$ and $`\omega`$, where $`\omega`$ stands for any number of uses:

```math
1 + 1 = \omega \qquad p + \omega = \omega \qquad \omega \cdot \omega = \omega
```

with $`0`$ and $`1`$ the units of addition and multiplication.

A grade is a pair of usages $`\langle p, q \rangle`$, written in angle brackets since parentheses write literal vectors.
Its first usage counts the uses at run time and its second all the uses, so that the first never counts more uses than the second; six grades satisfy this condition:

```math
\langle 0, 0 \rangle \qquad \langle 0, 1 \rangle \qquad \langle 0, \omega \rangle \qquad \langle 1, 1 \rangle \qquad \langle 1, \omega \rangle \qquad \langle \omega, \omega \rangle
```

Addition and multiplication act on each usage, and the six grades are closed under them.
The zero grade is $`\langle 0, 0 \rangle`$, written $`0`$, and the unit grade is $`\langle 1, 1 \rangle`$, written $`1`$: a variable alone uses itself once at run time and once in all.

Each grade is one of the six modes, whose usages `none`, `linear` and `unrestricted` are $`0`$, $`1`$ and $`\omega`$:

| Mode | Grade |
| --- | --- |
| `none / none` | $`\langle 0, 0 \rangle`$ |
| `none / linear` | $`\langle 0, 1 \rangle`$ |
| `none / unrestricted` | $`\langle 0, \omega \rangle`$ |
| `linear / linear` | $`\langle 1, 1 \rangle`$ |
| `linear / unrestricted` | $`\langle 1, \omega \rangle`$ |
| `unrestricted / unrestricted` | $`\langle \omega, \omega \rangle`$ |

For instance, passing a permission of mode `none / linear` to a parameter of the same mode uses it with the grade $`\langle 0, 1 \rangle \cdot 1 = \langle 0, 1 \rangle`$: once, and never at run time.

The usages are ordered by $`\omega \le 0`$ and $`\omega \le 1`$, where $`p \le q`$ means that a variable of usage $`p`$ may be used where the usage $`q`$ is expected, and the grades are ordered on each usage.
A variable of usage $`\omega`$ may thus be used any number of times, none included, while a variable of usage $`1`$ is used exactly once and one of usage $`0`$ never: $`0`$ and $`1`$ are not comparable, so the core has no affine grade.
GrTT compares grades by equality only and leaves their order to future work; the order follows Abel, Danielsson and Eriksson, who check grades by a relation separate from typing.

The grades satisfy the conditions that GrTT calls quantitative, those that [Atkey](https://doi.org/10.1145/3209108.3209189) requires of quantitative type theory: $`0 \ne 1`$, a sum is $`0`$ only if both terms are, and a product is $`0`$ only if one of its factors is.
The first two hold on each usage; for the third, a factor whose second usage is $`0`$ counts no use at all, so it is the grade $`0`$.
The zero divisor $`\langle 1, 0 \rangle`$ of the product of semirings, which the modes point out, is not a grade.

### Judgments and Contexts

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

- The grades are not laid out as in GrTT: a reader of GrTT has to translate the rules.

## Rationale and Alternatives

To be written.

## Prior Art

To be written.

## Unresolved Questions

- Does the order of the grades keep the metatheory of GrTT, whose typing judgment carries the grades, while Abel, Danielsson and Eriksson formalize it with grades checked by a separate relation?
- Is a term whose grade has no use at run time, $`\langle 0, 1 \rangle`$ or $`\langle 0, \omega \rangle`$, erased safely?
  Abel, Danielsson and Eriksson prove it for the zero grade only; the projection of a grade on its first usage preserves the operations and the order, and would carry their result to every grade without use at run time if typing is preserved along it.
