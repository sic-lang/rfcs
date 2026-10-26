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
| $`x, y, z`$ | Variables |
| $`f`$ | Fields of [records](#records) |
| $`t, u, a`$ | Terms, $`u`$ being a term compared to $`t`$ and $`a`$ a term substituted for a variable |
| $`A, B, C`$ | Types |
| $`R`$ | The type of a record in the rules of the [records](#records) |
| $`\diamond`$ | The connective of a [record](#records), $`\otimes`$ or $`\&`$ |
| $`\kappa`$ | Sorts, the universes $`U_l`$ and the universes of [strict propositions](#strict-propositions) $`\Omega_l`$ |
| $`\Gamma, \Theta`$ | Contexts, sequences of declarations $`x : A`$, $`\Theta`$ being the fields of a [record](#records) bound as variables by a match |
| $`p, q, r`$ | Grades, elements of the semiring of the [grades](#grades) |
| $`\gamma, \delta`$ | Vectors of grades, one grade per variable of the context |
| $`m`$ | Modes, in which a term is checked for its uses |

A subscript numbers objects of the same kind that come from different premises or different parts of a context, as $`\gamma_1`$ and $`\gamma_2`$, or $`\Gamma_1`$ and $`\Gamma_2`$: an object alone of its kind has none, and several are all numbered; a subscript never selects a component.

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
| `lam p t` | $`\lambda_{p}\, (x : A).\, t`$, which also carries the type of its argument |
| `t ∘⟨ p ⟩ u` | $`t \circ_{p} u`$ |
| `Σʷ p , q ▷ A ▹ B`, `Σˢ p , q ▷ A ▹ B` | $`\Sigma^{\text{⊗}}_{U_l}\{x :^{q}_{p} A,\ y :^{\mathbb{0}}_{\mathbb{1}} B\}`$, $`\Sigma^{\text{\&}}_{U_l}\{x :^{q}_{p} A,\ y :^{\mathbb{0}}_{\mathbb{1}} B\}`$ |
| `prodʷ p t u`, `prodˢ p t u` | $`R\{t,\ u\}`$, where $`R`$ is the record type of the pair |
| `prodrec r p q C t u` | $`\mathsf{match}_r\ t\ \mathsf{as}\ z\ \mathsf{return}\ C\ \mathsf{with}\ R\{x,\ y\} \Rightarrow u`$ |
| `fst p t`, `snd p t` | $`\pi_{R, 1}\ t`$, $`\pi_{R, 2}\ t`$ |
| `Unitʷ`, `Unitˢ` | $`\Sigma^{\text{⊗}}_{U_l}\{\}`$, $`\Sigma^{\text{\&}}_{U_l}\{\}`$ |
| `starʷ`, `starˢ` | $`R\{\}`$, where $`R`$ is the record type of the unit |
| `Uⱼ`, `U-cong` | $`(U)`$, $`(U_\equiv)`$ |
| `univ` | $`(U_{\mathsf{type}})`$, $`(U_{\mathsf{type}\equiv})`$ |
| `γ ▸[ m ] t` | $`\gamma \mathrel{▶_m} t`$ |
| `m ᵐ· p` | $`m \odot p`$ |
| `𝟘ᵐ`, `𝟙ᵐ` | $`\mathbb{0}\mathbb{0}^{\mathsf{m}}`$, $`\mathbb{1}\mathbb{1}^{\mathsf{m}}`$, with the [mode](#modes) $`\mathbb{0}\mathbb{1}^{\mathsf{m}}`$ between them |

A pair of ADE corresponds to a record whose level $`l`$ is the larger level of $`A`$ and $`B`$, where the pair lives; a record may also live higher.
The records are typed as the strong pairs and the strong unit of ADE, whatever their connective, and used as their weak pairs and weak unit when they are multiplicative, as their strong pairs and strong unit when they are additive.

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

The core has the four judgments of Martin-Löf type theory, as [Nordström, Petersson and Smith](https://intuitionistic.wordpress.com/wp-content/uploads/2010/07/nordstrom-et-al-type-theory.pdf) present them, with a judgment for contexts and a judgment for usage:

```math
\vdash \Gamma \qquad \Gamma \vdash A \qquad \Gamma \vdash A \equiv B \qquad \Gamma \vdash t : A \qquad \Gamma \vdash t \equiv u : A \qquad \gamma \mathrel{▶_m} t
```

| Judgment | Meaning |
| --- | --- |
| $`\vdash \Gamma`$ | $`\Gamma`$ is a well-formed context |
| $`\Gamma \vdash A`$ | $`A`$ is a type in the context $`\Gamma`$ |
| $`\Gamma \vdash A \equiv B`$ | $`A`$ and $`B`$ are equal types |
| $`\Gamma \vdash t : A`$ | $`t`$ is a term of type $`A`$ |
| $`\Gamma \vdash t \equiv u : A`$ | $`t`$ and $`u`$ are equal terms of type $`A`$ |
| $`\gamma \mathrel{▶_m} t`$ | Checked in the [mode](#modes) $`m`$, $`t`$ uses each variable of its context as the grade that $`\gamma`$ gives it allows |

As Nordström, Petersson and Smith explain them, a type is known by its terms and by the equality of its terms, which is an equivalence relation, and two types are equal when they have the same terms and the same equal terms; the formalization has to check the rules of this RFC against this meaning, which its logical relation states.
The judgment for contexts makes explicit the condition that Nordström, Petersson and Smith put on the context of a judgment: each declared type is a type in the context of the declarations before it.

Typing and the equalities are those of Martin-Löf type theory: they carry no grade.
Usage is defined on the term alone, whose binders carry their grades, and its vector has a grade for each variable of the context of the term.
A program is a term that is both well typed and well used: typing tells what it computes, and usage how it uses its resources.
The rules of usage are named after the rules of typing, with the subscript $`\mathsf{m}`$.

Equality is written $`\equiv`$, so that $`=`$ remains free in terms for the equality type of a later RFC; in the conditions of the rules, $`=`$ is an equality of the metalanguage, which for levels is the one the [levels](#levels) define, not the equality of their syntax.

#### Contexts

A context is either empty, written $`\varepsilon`$, or a context extended by a declaration whose type is a type in it:

```math
\frac{}{\vdash \varepsilon}\;(\mathsf{ctx}_\varepsilon)
\qquad
\frac{\Gamma \vdash A \quad x \notin \Gamma}{\vdash \Gamma,\ x : A}\;(\mathsf{ctx}_{,})
```

The variable $`x`$ is fresh, absent from $`\Gamma`$, so that a name designates one declaration; ADE, whose variables are de Bruijn indices, needs no such condition.

#### Variables

A variable has the type of its declaration, and, checked in the mode $`m`$, uses itself with the grade $`\ulcorner m \urcorner`$ of the [mode](#modes) and nothing else:

```math
\frac{\vdash \Gamma_1,\ x : A,\ \Gamma_2}{\Gamma_1,\ x : A,\ \Gamma_2 \vdash x : A}\;(\mathsf{var})
\qquad
\frac{}{(\mathbb{0}^{\mathsf{c}}, x \mathrel{≔} \ulcorner m \urcorner) \mathrel{▶_m} x}\;(\mathsf{var}_{\mathsf{m}})
```

#### Equality

The equality of types and the equality of terms are equivalence relations, reflexive, symmetric and transitive:

```math
\frac{\Gamma \vdash A}{\Gamma \vdash A \equiv A}\;(\mathsf{refl}_{\mathsf{type}})
\qquad
\frac{\Gamma \vdash A \equiv B}{\Gamma \vdash B \equiv A}\;(\mathsf{sym}_{\mathsf{type}})
\qquad
\frac{\Gamma \vdash A_1 \equiv A_2 \quad \Gamma \vdash A_2 \equiv A_3}{\Gamma \vdash A_1 \equiv A_3}\;(\mathsf{trans}_{\mathsf{type}})
```

```math
\frac{\Gamma \vdash t : A}{\Gamma \vdash t \equiv t : A}\;(\mathsf{refl})
\qquad
\frac{\Gamma \vdash t \equiv u : A}{\Gamma \vdash u \equiv t : A}\;(\mathsf{sym})
\qquad
\frac{\Gamma \vdash t_1 \equiv t_2 : A \quad \Gamma \vdash t_2 \equiv t_3 : A}{\Gamma \vdash t_1 \equiv t_3 : A}\;(\mathsf{trans})
```

Each construct adds its own rules of congruence and computation, and two types are also equal when they are equal terms of a [universe](#universes) or of a universe of [strict propositions](#strict-propositions).

#### Type Conversion

Conversion gives a term any type equal to its own, and an equality of two terms as well, which the other rules do not derive, since a rule of computation gives its equality at one type only:

```math
\frac{\Gamma \vdash t : A \quad \Gamma \vdash A \equiv B}{\Gamma \vdash t : B}\;(\mathsf{conv})
\qquad
\frac{\Gamma \vdash t \equiv u : A \quad \Gamma \vdash A \equiv B}{\Gamma \vdash t \equiv u : B}\;(\mathsf{conv}_\equiv)
```

The core has no cumulativity, so conversion checks an equality of types, not a subtyping.

#### Usage

A term may be given grades lower than its uses, in the order of the [grades](#grades) taken on each component, written $`\le^{\mathsf{c}}`$:

```math
\frac{\gamma \mathrel{▶_m} t \quad \delta \le^{\mathsf{c}} \gamma}{\delta \mathrel{▶_m} t}\;(\mathsf{sub})
```

This rule lets an unrestricted variable be used once or not at all, and a variable of grade $`\langle \omega, 1 \rangle`$ be used once, at run time or not.

#### Admissible Properties

The following properties are not rules: they follow from the rules, and the formalization has to prove them.

- Context conversion: a judgment still holds when the type of a declaration of its context is replaced by an equal type.
- Level instantiation: a judgment still holds when its level variables are replaced by levels, so that a definition checked once with its level variables is used at any levels, as the [universes](#universes) require.
- Presuppositions: every judgment implies that its context is well formed, a typing $`\Gamma \vdash t : A`$ implies $`\Gamma \vdash A`$, and an equality implies that both its sides are types, or terms of its type.
- Subject reduction: a term keeps its types when it reduces, as the [conversion](#conversion) reduces terms.
- Substitution: a judgment still holds when terms of the types of its variables are substituted for them, and equal terms substituted give equal results; a usage still holds with the usages of the substituted terms, each scaled by the grade of its variable, added together.
- Types in sorts: every type is a term of a [sort](#letters), since the rules that make the terms of a sort types are the only rules that conclude $`\Gamma \vdash A`$.
- Usage preservation: a term keeps its usages when it reduces by a $`\beta`$ rule, though not conversely, since a reduction may drop an argument with its uses; the reduction of a neutral match keeps them only when the record is not used at all, as the [unresolved questions](#unresolved-questions) say.
- Weakening: a judgment still holds in a well-formed context that extends its own.

### Universes

A universe is a type whose elements are types.
A universe that contains itself makes the theory inconsistent ([Girard's paradox](https://doi.org/10.1007/BFb0014058)), so the universes form a predicative hierarchy, as in Agda and in the formalization of ADE:

```math
U_0 : U_1 : U_2 : \cdots
```

#### Levels

A level $`l`$ is $`0`$, a successor $`l + 1`$, the larger $`l_1 \sqcup l_2`$ of two levels, or a level variable.
Since a definition is checked once with its level variables and then used at any levels, two levels are equal when they are equal whatever levels their variables take: for level variables $`l_1`$ and $`l_2`$, $`l_1 \sqcup l_1`$ equals $`l_1`$, but $`l_1 \sqcup l_2`$ does not equal $`l_1`$, since they agree only when $`l_2`$ is at most $`l_1`$.
This equality is decidable, since it is a formula of [Presburger arithmetic](https://en.wikipedia.org/wiki/Presburger_arithmetic).
Levels are not terms: they appear only as the subscripts of universes, and use no variable of the context, unlike the levels of the formalization of ADE, which are terms of a type of levels since [Danielsson, Favier and Kubánek](https://doi.org/10.1145/3776645).

#### Formation

A universe is a type in the universe just above it, in any well-formed context, and uses no variable:

```math
\frac{\vdash \Gamma}{\Gamma \vdash U_l : U_{l + 1}}\;(U)
\qquad
\frac{\vdash \Gamma \quad l_1 = l_2}{\Gamma \vdash U_{l_1} \equiv U_{l_2} : U_{l_1 + 1}}\;(U_\equiv)
\qquad
\frac{}{\mathbb{0}^{\mathsf{c}} \mathrel{▶_m} U_l}\;(U_{\mathsf{m}})
```

The hierarchy is not cumulative: a type of $`U_l`$ is not a type of $`U_{l + 1}`$, as in Agda and Lean, and unlike Rocq.
The type of a function lives in the larger universe of its domain and codomain, as the [functions](#functions) define.

#### Elements as Types

A term of a universe is a type, and two equal terms of a universe are equal types, as the rule `univ` of the [formalization of ADE](https://github.com/graded-type-theory/graded-type-theory/blob/master/Definition/Typed.agda), which does not write the decoding $`\mathsf{El}`$ of Nordström, Petersson and Smith either:

```math
\frac{\Gamma \vdash A : U_l}{\Gamma \vdash A}\;(U_{\mathsf{type}})
\qquad
\frac{\Gamma \vdash A \equiv B : U_l}{\Gamma \vdash A \equiv B}\;(U_{\mathsf{type}\equiv})
```

#### Universe Polymorphism

Universe polymorphism is prenex, as in [Lean](https://lean-lang.org/doc/reference/latest/The-Type-System/Universes/): level variables are parameters of a top-level definition only, instantiated with levels at each use, and the definition is checked once, with its level variables.
Within the rules, a level variable is a constant; no type quantifies over levels, so no universe beyond the hierarchy is needed, unlike the $`\mathsf{Set}\omega`$ of [Agda](https://agda.readthedocs.io/en/latest/language/universe-levels.html).

### Strict Propositions

A proposition is a type whose proofs carry no information but their existence.

#### Formation

The propositions live in universes of their own, written $`\Omega_l`$ as the propositions of categorical semantics, which form a second predicative hierarchy, strict as the `Prop` of [Agda](https://agda.readthedocs.io/en/latest/language/prop.html), from [Gilbert, Cockx, Sozeau and Tabareau](https://doi.org/10.1145/3290316):

```math
\frac{\vdash \Gamma}{\Gamma \vdash \Omega_l : U_{l + 1}}\;(\Omega)
\qquad
\frac{\vdash \Gamma \quad l_1 = l_2}{\Gamma \vdash \Omega_{l_1} \equiv \Omega_{l_2} : U_{l_1 + 1}}\;(\Omega_\equiv)
\qquad
\frac{}{\mathbb{0}^{\mathsf{c}} \mathrel{▶_m} \Omega_l}\;(\Omega_{\mathsf{m}})
```

The `Prop` of Lean and the `SProp` of Rocq are impredicative instead: a proposition that quantifies over all propositions is itself one of them; together with proof irrelevance and the elimination of subsingletons, this makes the conversion of Lean undecidable ([Carneiro](https://github.com/digama0/lean-type-theory)).

#### Elements as Types

A sort is a universe $`U_l`$ or a universe of propositions $`\Omega_l`$; a proposition is a type, as a term of a universe is, and two equal propositions are equal types:

```math
\frac{\Gamma \vdash A : \Omega_l}{\Gamma \vdash A}\;(\Omega_{\mathsf{type}})
\qquad
\frac{\Gamma \vdash A \equiv B : \Omega_l}{\Gamma \vdash A \equiv B}\;(\Omega_{\mathsf{type}\equiv})
```

#### Proof Irrelevance

Proof irrelevance is definitional: two proofs of the same proposition are equal.

```math
\frac{\Gamma \vdash t : A \quad \Gamma \vdash u : A \quad \Gamma \vdash A : \Omega_l}{\Gamma \vdash t \equiv u : A}\;(\mathsf{irr})
```

Since equality carries no grade, two proofs are equal even when they use their hypotheses differently; the usage of each is checked on its own.

A proof cannot be analyzed to build data, since irrelevance would identify the data built from two proofs; this restriction of elimination concerns the inductive types of a later RFC, as in Agda, and not the [records](#records) of propositions, whose single construction leaves nothing to analyze.

#### Erased Proofs

A proof exists only in erased positions: every binder whose type is a proposition has a [grade](#grades) without use at run time, so that a proof is checked in the [mode](#modes) $`\mathbb{0}\mathbb{0}^{\mathsf{m}}`$ or $`\mathbb{0}\mathbb{1}^{\mathsf{m}}`$, which the rules of the [functions](#functions) and the [records](#records) check.
The erasure of proofs is then the erasure of the grades without use at run time, with no mechanism of its own.

### Functions

The rules of the functions are those of ADE, with sorts in place of its universes.

#### Formation

The type of a function binds its argument with two grades: $`p`$ for its uses in the body of the function, and $`q`$ for its uses in the type $`B`$ of the result.
It lives in a sort of the kind of $`B`$, at the larger level of its domain and its codomain, so that a function into a proposition is a proposition; when the domain is a proposition, the argument is a proof, whose grade has no use at run time, as the [strict propositions](#strict-propositions) require:

```math
\frac{\begin{gathered}{}\Gamma \vdash A : \kappa_1 \quad \Gamma,\ x : A \vdash B : \kappa_2 \quad \kappa_1 \in \{U_{l_1}, \Omega_{l_1}\} \quad \kappa_2 \in \{U_{l_2}, \Omega_{l_2}\} \\ \llcorner p \lrcorner \ne \mathbb{1}\mathbb{1}^{\mathsf{m}} \text{ if } \kappa_1 = \Omega_{l_1} \quad \kappa = U_{l_1 \sqcup l_2} \text{ if } \kappa_2 = U_{l_2} \quad \kappa = \Omega_{l_1 \sqcup l_2} \text{ if } \kappa_2 = \Omega_{l_2}\end{gathered}}{\Gamma \vdash \Pi^{q}_{p}\, (x : A).\, B : \kappa}\;(\Pi)
```

The type of a function uses the variables of its domain as many times as the argument is used, and the domain is checked in the mode of this grade; its codomain uses the argument with the grade $`q`$:

```math
\frac{\gamma \mathrel{▶_{m \odot p}} A \quad \delta \bullet \ulcorner m \urcorner \cdot q \mathrel{▶_m} B}{p \cdot^{\mathsf{c}} \gamma +^{\mathsf{c}} \delta \mathrel{▶_m} \Pi^{q}_{p}\, (x : A).\, B}\;(\Pi_{\mathsf{m}})
```

#### Construction

A function is introduced by abstraction, which carries the type of its argument, so that the type of every term is determined by the term; its body uses its argument with the grade $`p`$ of its type, and the type of the argument, as every type a term carries, uses no variable:

```math
\frac{\Gamma \vdash \Pi^{q}_{p}\, (x : A).\, B \quad \Gamma,\ x : A \vdash t : B}{\Gamma \vdash \lambda_{p}\, (x : A).\, t : \Pi^{q}_{p}\, (x : A).\, B}\;(\lambda)
\qquad
\frac{\gamma \bullet \ulcorner m \urcorner \cdot p \mathrel{▶_m} t}{\gamma \mathrel{▶_m} \lambda_{p}\, (x : A).\, t}\;(\lambda_{\mathsf{m}})
```

#### Application

A function is eliminated by application, which uses the argument as many times as the function does, checking it in the mode of this grade:

```math
\frac{\Gamma \vdash t : \Pi^{q}_{p}\, (x : A).\, B \quad \Gamma \vdash a : A}{\Gamma \vdash t \circ_{p} a : B[a/x]}\;(\circ)
\qquad
\frac{\gamma \mathrel{▶_m} t \quad \delta \mathrel{▶_{m \odot p}} a}{\gamma +^{\mathsf{c}} p \cdot^{\mathsf{c}} \delta \mathrel{▶_m} t \circ_{p} a}\;(\circ_{\mathsf{m}})
```

The substitution $`B[a/x]`$ replaces the free occurrences of $`x`$ in $`B`$ by $`a`$, renaming the bound variables of $`B`$ that $`a`$ would capture.
An argument that is a proof is thus checked in a mode without use at run time, $`\mathbb{0}\mathbb{0}^{\mathsf{m}}`$ or $`\mathbb{0}\mathbb{1}^{\mathsf{m}}`$.

Applying an abstraction computes by substitution, and a function is equal to the abstraction of its application:

```math
\frac{\Gamma \vdash \Pi^{q}_{p}\, (x : A).\, B \quad \Gamma,\ x : A \vdash t : B \quad \Gamma \vdash a : A}{\Gamma \vdash (\lambda_{p}\, (x : A).\, t) \circ_{p} a \equiv t[a/x] : B[a/x]}\;(\beta)
\qquad
\frac{\Gamma \vdash t : \Pi^{q}_{p}\, (x : A).\, B \quad x \notin \Gamma}{\Gamma \vdash t \equiv \lambda_{p}\, (x : A).\, t \circ_{p} x : \Pi^{q}_{p}\, (x : A).\, B}\;(\eta)
```

Equality is also a congruence for the type of functions, abstraction and application, with the premises of their rules.

#### Examples

For instance, the constant function uses its first argument once in its body and its second never, and its type mentions neither:

```math
\lambda_{\mathbb{1}}\, (x : A).\, \lambda_{\mathbb{0}}\, (y : B).\, x : \Pi^{\mathbb{0}}_{\mathbb{1}}\, (x : A).\, \Pi^{\mathbb{0}}_{\mathbb{0}}\, (y : B).\, A
```

Polymorphism over types needs no rule of its own: the identity takes its type as an argument, which its body never uses and its type uses twice, for the argument and for the result, that is $`\mathbb{1} + \mathbb{1} = \langle \omega, \omega \rangle`$:

```math
\lambda_{\mathbb{0}}\, (A : U_l).\, \lambda_{\mathbb{1}}\, (x : A).\, x : \Pi^{\langle \omega, \omega \rangle}_{\mathbb{0}}\, (A : U_l).\, \Pi^{\mathbb{0}}_{\mathbb{1}}\, (x : A).\, A
```

Its type argument thus has the grade `none / none`: it does not exist at run time.

### Records

A record groups fields, whose types may depend on the fields before them, as the declarations of a context do.
This order makes the fields positional: a field is known by its position, and its name only binds it in the types of the fields after it, so that two records that differ only by the names of their fields are equal, up to the renaming of bound variables.
Records are anonymous and compared by their structure, as the [tuples of Rust](https://doc.rust-lang.org/reference/types/tuple.html); a type distinct from every other type with the same fields, as a [struct of Rust](https://doc.rust-lang.org/reference/types/struct.html), comes from a declaration, which this RFC does not define, and the language may name its fields and reorder them, each name being translated to a position.
Each field carries two grades, as the argument of a [function](#functions) does: $`p`$ counts how many times one use of the record gives access to the field, as the grade of the first component of the pairs of ADE, so that the grade of a field used through a variable is the grade of the variable times the grade of the field; $`q`$ counts how many times the types of the fields after it use the field.

#### Formation

A field $`f`$ of type $`A`$ is declared with its grades on its colon, $`f :^{q}_{p} A`$, placed as on the type of functions.
The last field has both grades too, so that all the fields have the same form; since no field comes after it, its grade $`q`$ only has to allow no use, as the grade $`q`$ of a function whose codomain does not use its argument.
A record is multiplicative or additive, after the connectives $`\otimes`$ and $`\&`$ of linear logic that it generalizes, and its type carries this connective $`\diamond`$ and the sort $`\kappa`$ in which it lives:

```math
\Sigma^{\diamond}_\kappa\{f_1 :^{q_1}_{p_1} A_1,\ \dots,\ f_n :^{q_n}_{p_n} A_n\}
\qquad
\diamond \in \{\text{⊗}, \text{\&}\}
```

The user of a multiplicative record gets all its fields at once, and the user of an additive record one field of its choice.
The connective changes only the usage of the terms of a record, never their typing: both kinds of records have the same rules of typing and equality, and differ by the usage of their terms only.
Two record types that differ only by their connective are still different types, as two types that differ only by a grade: an additive record taken for a multiplicative one would give all its fields, while its uses provide for one only.
The empty records are, at any level $`l`$, the unit types $`\Sigma^{\text{⊗}}_{U_l}\{\}`$ and $`\Sigma^{\text{\&}}_{U_l}\{\}`$, the $`1`$ and $`\top`$ of linear logic, and the true propositions $`\Sigma^{\text{⊗}}_{\Omega_l}\{\}`$ and $`\Sigma^{\text{\&}}_{\Omega_l}\{\}`$, the units $`I`$ and $`\top`$ of the [logic of bunched implications](https://doi.org/10.2307/421090) of O'Hearn and Pym.
The additive ones can be built from any resources, as the construction of the [records](#records) shows; a proof is checked in an erased mode, so that $`\Sigma^{\text{\&}}_{\Omega_l}\{\}`$ absorbs only erased resources, such as a permission of grade $`\langle 0, 1 \rangle`$.

A record of two fields whose second has the grades $`\mathbb{1}`$ and $`\mathbb{0}`$ is a pair of ADE, and a record of more fields is a sequence of nested pairs, in which the grade $`q_i`$ counts the uses of $`f_i`$ in the types of all the fields after it.

Each field type is checked in the context $`\Gamma_i`$, which extends $`\Gamma`$ by the fields before $`f_i`$:

```math
\Gamma_i \;=\; \Gamma,\ f_1 : A_1,\ \dots,\ f_{i - 1} : A_{i - 1}
```

The sort of a record is chosen by whoever writes it, and the rule only checks it, as [Agda](https://agda.readthedocs.io/en/latest/language/prop.html) and [Lean](https://lean-lang.org/doc/reference/latest/The-Type-System/Inductive-Types/#structures) check the sort declared for a record.
A record in a universe of propositions $`\Omega_l`$ has only propositions as fields, which gives the conjunction of propositions, since irrelevance would otherwise equate records that hold different data; a record in a universe $`U_l`$ may have fields of any sort, even propositions only, and is then an ordinary type, whose elements are all equal by the $`\eta`$ rule of the [projections](#projections) without being irrelevant.
The level $`l`$ of the record bounds the levels of its fields, where $`l_1 \le l_2`$ when $`l_1 \sqcup l_2 = l_2`$, which is decidable as their equality: a record may thus live in a universe above its fields, which lifts a type to a higher universe without cumulativity, as the [`ULift` of Lean](https://lean-lang.org/doc/reference/latest/The-Type-System/Universes/#--tech-term-universe-lifting) does.
A field that is a proof has a grade without use at run time, as the [strict propositions](#strict-propositions) require:

```math
\frac{\begin{gathered}{}\vdash \Gamma \text{ if } n = 0 \quad \kappa \in \{U_l, \Omega_l\} \\ \Gamma_i \vdash A_i : \kappa_i \quad \kappa_i \in \{U_{l_i}, \Omega_{l_i}\} \quad l_i \le l \quad \kappa_i = \Omega_{l_i} \text{ if } \kappa = \Omega_l \quad f_i \notin \Gamma_i \quad \llcorner p_i \lrcorner \ne \mathbb{1}\mathbb{1}^{\mathsf{m}} \text{ if } \kappa_i = \Omega_{l_i} \quad \text{for each } i\end{gathered}}{\Gamma \vdash \Sigma^{\diamond}_\kappa\{f_1 :^{q_1}_{p_1} A_1,\ \dots,\ f_n :^{q_n}_{p_n} A_n\} : \kappa}\;(\Sigma\{\})
```

The premise $`\vdash \Gamma`$ keeps the context well formed when there is no field; otherwise, the typing of the first field type implies it, since every typing judgment implies that its context is well formed, as the [admissible properties](#admissible-properties) state.

The type of a record uses the variables of each field type as many times as the field is used, checked in the mode of its grade, as the domain of a function; the grade $`q_i`$ of each field $`f_i`$ allows its uses in the types of the fields after it, added up, in the order of the [grades](#grades), as (sub) does for a term:

```math
\frac{\gamma_i \mathrel{▶_{m \odot p_i}} A_i \quad \text{for each } i \quad \delta \bullet \ulcorner m \urcorner \cdot q_1 \bullet \dots \bullet \ulcorner m \urcorner \cdot q_n \le^{\mathsf{c}} p_1 \cdot^{\mathsf{c}} \gamma_1 +^{\mathsf{c}} \dots +^{\mathsf{c}} p_n \cdot^{\mathsf{c}} \gamma_n}{\delta \mathrel{▶_m} \Sigma^{\diamond}_\kappa\{f_1 :^{q_1}_{p_1} A_1,\ \dots,\ f_n :^{q_n}_{p_n} A_n\}}\;(\Sigma\{\}_{\mathsf{m}})
```

The vector $`\gamma_i`$, which has a grade for each variable of $`\Gamma_i`$, is extended by $`\mathbb{0}`$ for the fields from $`f_i`$ on, and a sum of no vector is $`\mathbb{0}^{\mathsf{c}}`$.
For two fields, this is the rule of ADE for the type of its pairs: the type of the second field uses the first with the grade $`\ulcorner m \urcorner \cdot q_1`$, as the codomain of a function uses its argument.
The last field, which no type uses, has a grade $`q_n`$ such that $`\ulcorner m \urcorner \cdot q_n \le \mathbb{0}`$.
The sort $`\kappa`$ uses no variable, as a universe.

For instance, a type packed with one of its elements never exists at run time, and the type of the element uses it once:

```math
\Sigma^{\text{⊗}}_{U_1}\{f_1 :^{\mathbb{1}}_{\mathbb{0}} U_0,\ f_2 :^{\mathbb{0}}_{\mathbb{1}} f_1\} : U_1
```

Its first field thus has the grade `none / none`, and the record lives in $`U_1`$, the lowest universe that bounds its two field types.

#### Construction

The records are typed as the strong pairs of ADE, which they write $`\Sigma_{\&}`$ after the additive conjunction of linear logic, generalized from two fields to any number; the multiplicative records are used as their weak pairs, written $`\Sigma_{\otimes}`$, and the additive records as their strong pairs.
In the rules below, $`R`$ stands for the record type $`\Sigma^{\diamond}_{\kappa}\{f_1 :^{q_1}_{p_1} A_1,\ \dots,\ f_n :^{q_n}_{p_n} A_n\}`$.

A record is built from a term for each field, whose type takes the terms of the fields before it.
The term carries its type $`R`$, as the type carries its sort, and the usage reads the connective and the grades of the fields in $`R`$, so that they are written once, in the type, as a constructor of a [structure of Lean](https://lean-lang.org/doc/reference/latest/The-Type-System/Inductive-Types/#structures) carries the parameters of its type:

```math
\frac{\Gamma \vdash R \quad \Gamma \vdash t_i : A_i[t_1/f_1, \dots, t_{i - 1}/f_{i - 1}] \quad \text{for each } i}{\Gamma \vdash R\{t_1,\ \dots,\ t_n\} : R}\;(\Sigma\{\}_{\mathsf{i}})
```

A multiplicative record uses the variables of each term as many times as the grade of its field, checking the term in the mode of this grade, and its type $`R`$ uses none, as the type of a pair in ADE:

```math
\frac{\diamond = \text{⊗} \quad \gamma_i \mathrel{▶_{m \odot p_i}} t_i \quad \text{for each } i}{p_1 \cdot^{\mathsf{c}} \gamma_1 +^{\mathsf{c}} \dots +^{\mathsf{c}} p_n \cdot^{\mathsf{c}} \gamma_n \mathrel{▶_m} R\{t_1,\ \dots,\ t_n\}}\;(\Sigma\{\}^{\text{⊗}}_{\mathsf{i}\mathsf{m}})
```

Since the user of an additive record gets one field only, the record needs the resources of each field, but not of all of them together: its uses are bounded by the uses of each field, counted with the grade of its field:

```math
\frac{\diamond = \text{\&} \quad \gamma_i \mathrel{▶_{m \odot p_i}} t_i \quad \delta \le^{\mathsf{c}} p_i \cdot^{\mathsf{c}} \gamma_i \quad \text{for each } i \quad \delta \le^{\mathsf{c}} \ulcorner m \urcorner \cdot^{\mathsf{c}} \delta}{\delta \mathrel{▶_m} R\{t_1,\ \dots,\ t_n\}}\;(\Sigma\{\}^{\text{\&}}_{\mathsf{i}\mathsf{m}})
```

For a record with fields, the greatest such vector is the meet $`p_1 \cdot^{\mathsf{c}} \gamma_1 \wedge^{\mathsf{c}} \dots \wedge^{\mathsf{c}} p_n \cdot^{\mathsf{c}} \gamma_n`$, which is at most each of its operands, so a variable used once by every field is used once by the record, which may then give any one of them.
For the record without fields, the bounds are vacuous, and the empty additive record may use any resources, which it never gives back, as the $`\top`$ of linear logic: ADE give the same choice to their strong unit, as the option `Starˢ-sink` of their formalization.
The last premise keeps the erased uses of a term checked in an erased mode erased, as ADE multiply the uses of their strong unit by $`\ulcorner m \urcorner`$; it only restricts the record without fields.

#### Matching

A record is matched by a body $`u`$ that receives all its fields at once as variables, which form the context $`\Theta`$, and the type $`C`$ of the result may depend on the record, bound to $`z`$:

```math
\Theta \;=\; x_1 : A_1,\ x_2 : A_2[x_1/f_1],\ \dots,\ x_n : A_n[x_1/f_1, \dots, x_{n - 1}/f_{n - 1}]
```

The match carries $`R`$ and $`C`$, as the matches of ADE carry their type of result, so that its type is determined by the term:

```math
\frac{\Gamma,\ z : R \vdash C \quad \Gamma \vdash t : R \quad \Gamma,\ \Theta \vdash u : C[R\{x_1,\ \dots,\ x_n\}/z]}{\Gamma \vdash \mathsf{match}_r\ t\ \mathsf{as}\ z\ \mathsf{return}\ C\ \mathsf{with}\ R\{x_1,\ \dots,\ x_n\} \Rightarrow u : C[t/z]}\;(\mathsf{match})
```

A record of propositions is a proof, and is matched for any result: its fields are proofs, which the body uses only in erased positions, and by the $`\eta`$ rule of the [projections](#projections), the match of a proof equals its body with the projections of the proof substituted, so that the matches of two proofs of the same proposition are equal.

On the seven grades, the grades $`p`$ that allow discarding, $`p \le \mathbb{0}`$, are exactly those that allow duplicating, $`p \le p + p`$: $`\mathbb{0}`$, $`\langle 0, \omega \rangle`$ and $`\langle \omega, \omega \rangle`$.
A multiplicative record provides all its fields, so that taking fewer than all of them discards the others, as a [projection](#projections) does; an additive record provides one field, so that taking more than one duplicates the resources they share, as a match does.
In the mode $`m`$, the field $`f_i`$ is discarded or duplicated freely when $`\ulcorner m \urcorner \cdot p_i \le \mathbb{0}`$, which always holds in the mode $`\mathbb{0}\mathbb{0}^{\mathsf{m}}`$, and in the mode $`\mathbb{0}\mathbb{1}^{\mathsf{m}}`$ fails only for the grades whose total multiplicity is $`1`$.

The record is used $`r`$ times, and the type $`C`$ is checked in the mode $`\mathbb{0}\mathbb{0}^{\mathsf{m}}`$, as in ADE, so that it uses no variable.
The body of the match of a multiplicative record uses each variable $`x_i`$ with the grade of its field times $`r`$:

```math
\frac{\begin{gathered}{}\diamond = \text{⊗} \quad \gamma \mathrel{▶_{m \odot r}} t \quad \delta \bullet \ulcorner m \urcorner \cdot r \cdot p_1 \bullet \dots \bullet \ulcorner m \urcorner \cdot r \cdot p_n \mathrel{▶_m} u \quad \mathbb{0}^{\mathsf{c}} \mathrel{▶_{\mathbb{0}\mathbb{0}^{\mathsf{m}}}} C \\ \llcorner r \lrcorner = \mathbb{1}\mathbb{1}^{\mathsf{m}} \text{ if } m = \mathbb{1}\mathbb{1}^{\mathsf{m}}\end{gathered}}{r \cdot^{\mathsf{c}} \gamma +^{\mathsf{c}} \delta \mathrel{▶_m} \mathsf{match}_r\ t\ \mathsf{as}\ z\ \mathsf{return}\ C\ \mathsf{with}\ R\{x_1,\ \dots,\ x_n\} \Rightarrow u}\;(\mathsf{match}^{\text{⊗}}_{\mathsf{m}})
```

The body of the match of an additive record uses one field $`f_i`$ of its choice, and the other fields only when they are discarded or duplicated freely; it uses the others with $`\mathbb{0}`$, that is, in erased positions only:

```math
\frac{\begin{gathered}{}\diamond = \text{\&} \quad \gamma \mathrel{▶_{m \odot r}} t \quad \delta \bullet g_1 \bullet \dots \bullet g_n \mathrel{▶_m} u \quad \mathbb{0}^{\mathsf{c}} \mathrel{▶_{\mathbb{0}\mathbb{0}^{\mathsf{m}}}} C \quad \llcorner r \lrcorner = \mathbb{1}\mathbb{1}^{\mathsf{m}} \text{ if } m = \mathbb{1}\mathbb{1}^{\mathsf{m}} \\ g_j = \ulcorner m \urcorner \cdot r \cdot p_j \text{ if } j = i \text{ or } \ulcorner m \urcorner \cdot p_j \le \mathbb{0} \quad g_j = \mathbb{0} \text{ otherwise} \quad \text{for each } j\end{gathered}}{r \cdot^{\mathsf{c}} \gamma +^{\mathsf{c}} \delta \mathrel{▶_m} \mathsf{match}_r\ t\ \mathsf{as}\ z\ \mathsf{return}\ C\ \mathsf{with}\ R\{x_1,\ \dots,\ x_n\} \Rightarrow u}\;(\mathsf{match}^{\text{\&}}_{\mathsf{m}})
```

The condition on $`r`$ forbids, in a term that runs, the match of a record that does not exist at run time: the body would run while the record is erased.
ADE call this an erased match: they prove the soundness of erasure with it for closed programs only, and without it also for programs that run under consistent hypotheses, which this RFC follows for now; a record without use at run time can still be matched inside an erased term, and the case left out is an [unresolved question](#unresolved-questions).
A field that is a proof stays erased, since the grade $`r \cdot p_i`$ of its variable has no use at run time when $`p_i`$ has none.
ADE also give the type of the result a grade $`q`$ for its uses of $`z`$, which counts nothing when the type is checked in $`\mathbb{0}\mathbb{0}^{\mathsf{m}}`$, whose grade is $`\mathbb{0}`$, so the match has none.

Matching a record that has just been built substitutes its terms for the variables:

```math
\frac{\Gamma,\ z : R \vdash C \quad \Gamma \vdash t_i : A_i[t_1/f_1, \dots, t_{i - 1}/f_{i - 1}] \quad \text{for each } i \quad \Gamma,\ \Theta \vdash u : C[R\{x_1,\ \dots,\ x_n\}/z]}{\Gamma \vdash \mathsf{match}_r\ R\{t_1,\ \dots,\ t_n\}\ \mathsf{as}\ z\ \mathsf{return}\ C\ \mathsf{with}\ R\{x_1,\ \dots,\ x_n\} \Rightarrow u \equiv u[t_1/x_1, \dots, t_n/x_n] : C[R\{t_1,\ \dots,\ t_n\}/z]}\;(\mathsf{match}_\beta)
```

Equality is also a congruence for the record types, their terms and their match, with the premises of their rules, so that a record whose type is written differently but equal is matched as well.

#### Projections

A record is also used by projecting one of its fields, whose type takes the projections of the fields before it, as the strong pairs of ADE are; the projection carries the type $`R`$, in which the usage reads the connective and the grades:

```math
\frac{\Gamma \vdash t : R \quad 1 \le i \le n}{\Gamma \vdash \pi_{R, i}\ t : A_i[\pi_{R, 1}\ t/f_1, \dots, \pi_{R, i - 1}\ t/f_{i - 1}]}\;(\pi)
```

A projection uses the record once, and gets the field once; this is allowed only when the grade of the field allows one use in the mode of the projection.
It also drops the other fields, which an additive record allows, since its user takes one field, and a multiplicative record allows only when they are discarded freely:

```math
\frac{\gamma \mathrel{▶_m} t \quad \ulcorner m \urcorner \cdot p_i \le \ulcorner m \urcorner \quad \ulcorner m \urcorner \cdot p_j \le \mathbb{0} \text{ for each } j \ne i \text{ if } \diamond = \text{⊗}}{\gamma \mathrel{▶_m} \pi_{R, i}\ t}\;(\pi_{\mathsf{m}})
```

A field without use at run time, such as a proof, is thus projected only in an erased term: in the mode $`\mathbb{1}\mathbb{1}^{\mathsf{m}}`$, the condition is $`p_i \le \mathbb{1}`$, which fails when the run-time multiplicity of $`p_i`$ is $`0`$, since $`0`$ and $`1`$ are not comparable.
In the mode $`\mathbb{0}\mathbb{1}^{\mathsf{m}}`$, a field of grade $`\langle 0, 1 \rangle`$ or $`\langle 0, \omega \rangle`$ is projected, so that a specification reads the erased fields of a record.
In the mode $`\mathbb{0}\mathbb{0}^{\mathsf{m}}`$, every field of every record is projected, so that a type reads any field of a multiplicative record.

Projecting a record that has just been built gives the term of its field, and two records are equal when all their projections are, which gives the $`\eta`$ rule:

```math
\frac{\Gamma \vdash R \quad \Gamma \vdash t_j : A_j[t_1/f_1, \dots, t_{j - 1}/f_{j - 1}] \quad \text{for each } j \quad 1 \le i \le n}{\Gamma \vdash \pi_{R, i}\ R\{t_1,\ \dots,\ t_n\} \equiv t_i : A_i[t_1/f_1, \dots, t_{i - 1}/f_{i - 1}]}\;(\pi_\beta)
```

```math
\frac{\Gamma \vdash t : R \quad \Gamma \vdash u : R \quad \Gamma \vdash \pi_{R, i}\ t \equiv \pi_{R, i}\ u : A_i[\pi_{R, 1}\ t/f_1, \dots, \pi_{R, i - 1}\ t/f_{i - 1}] \quad \text{for each } i}{\Gamma \vdash t \equiv u : R}\;(\Sigma\{\}_\eta)
```

With $`(\pi_\beta)`$, it makes every record equal to the record of its projections, $`t \equiv R\{\pi_{R, 1}\ t,\ \dots,\ \pi_{R, n}\ t\}`$, and with $`(\mathsf{match}_\beta)`$ and congruence, every match equal to its body with the projections substituted:

```math
\mathsf{match}_r\ t\ \mathsf{as}\ z\ \mathsf{return}\ C\ \mathsf{with}\ R\{x_1,\ \dots,\ x_n\} \Rightarrow u \;\equiv\; u[\pi_{R, 1}\ t/x_1, \dots, \pi_{R, n}\ t/x_n]
```

Since equality carries no grade, the two sides may use their variables differently; the usage of each is checked on its own.
In particular, the right side uses $`t`$ once for each field, so that a match is not replaced by its projections in a program; the [conversion](#conversion) only uses this equality to compare terms.
For the same reason, a term equal to another by $`\eta`$ is not always as well used: a multiplicative record keeps its usage when it is rebuilt by a match, and an additive record when it is rebuilt from its projections.
Equality is also a congruence for the projections, with the premises of their rule.

For instance, a choice between two functions applied to the same linear resource $`x`$ uses it once, since its user applies only one of them:

```math
R\{y \circ_{\mathbb{1}} x,\ z \circ_{\mathbb{1}} x\} \qquad R = \Sigma^{\text{\&}}_{U_0}\{f_1 :^{\mathbb{0}}_{\mathbb{1}} B,\ f_2 :^{\mathbb{0}}_{\mathbb{1}} C\}
```

Each field uses $`x`$ with the grade $`\mathbb{1}`$, and the record with $`\mathbb{1} \wedge \mathbb{1} = \mathbb{1}`$; a multiplicative record would use it with $`\mathbb{1} + \mathbb{1} = \langle \omega, \omega \rangle`$.

### Conversion

The rule $`(\mathsf{conv})`$ compares types with the [equality of types](#equality), which the constructs of this RFC define together, through the equalities of their terms in a sort:

| Equality | Constructs |
| --- | --- |
| Computation, $`\beta`$ | Application of an abstraction, projection and match of a record |
| Extensionality, $`\eta`$ | Functions and records |
| Irrelevance | Two proofs of the same proposition, $`(\mathsf{irr})`$ |
| Levels | Universes whose levels are equal in Presburger arithmetic, $`(U_\equiv)`$ and $`(\Omega_\equiv)`$ |
| Congruence | Every construct, with the premises of its rules |

Grades and the connectives of records are part of terms and types, but no rule equates two different grades or connectives: two types that differ only by a grade, as $`\Pi^{\mathbb{0}}_{\mathbb{1}}\, (x : A).\, B`$ and $`\Pi^{\mathbb{0}}_{\langle \omega, \omega \rangle}\, (x : A).\, B`$, are different types, as in ADE.
Since typing carries no grade otherwise, the modes and the seven grades play no part in equality: what ADE prove about typing holds whatever their modality.

Checking a type needs a decision procedure for equality.
The one of this RFC is the algorithm of [Abel, Öhman and Vezzosi](https://doi.org/10.1145/3158111), whose formalization ADE extend: both terms are reduced to their weak head normal forms, whose heads are compared, and terms are compared by their type, through $`\eta`$, at the types of functions and of records.
A match whose record is neutral reduces to its body with the projections of the record substituted, which the [projections](#projections) show equal, so that no match is neutral: as [Agda](https://agda.readthedocs.io/en/latest/language/runtime-irrelevance.html) puts it, a match on a record type with $`\eta`$-equality is not really a match.
A type that is a proposition is checked first, and two of its terms are then equal without being compared, which keeps irrelevance decidable, as [Gilbert, Cockx, Sozeau and Tabareau](https://doi.org/10.1145/3290316) show; two levels are compared by deciding their formula of Presburger arithmetic.

ADE prove normalization and the decidability of equality for functions, both kinds of pairs and both kinds of units, with the $`\eta`$ rules of functions, strong pairs and the strong unit, which are those of all the records here, and [Pujet and Tabareau](https://doi.org/10.1145/3498693) prove normalization, with the same framework, for a theory with a universe of strict propositions.
No proof yet covers their combination, the records of any number of fields, the reduction of the neutral matches, and the level variables; the formalization of this RFC has to provide it.

### Erasure

Erasure compiles a program to an untyped target language, removing every part that has no use at run time.
It is the extraction of ADE, written $`t^\bullet`$ as in their paper, extended to the constructs of this RFC.
A program is a closed term that is well typed and well used in the mode of run time:

```math
\varepsilon \vdash t : A \qquad \mathbb{0}^{\mathsf{c}} \mathrel{▶_{\mathbb{1}\mathbb{1}^{\mathsf{m}}}} t
```

Only the run-time multiplicity of a grade matters: a grade $`p`$ is erased when $`\llcorner p \lrcorner \ne \mathbb{1}\mathbb{1}^{\mathsf{m}}`$, that is, when its run-time multiplicity is $`0`$, whatever its total multiplicity.
The target language has variables, abstractions $`\lambda x.\, v`$, applications $`v\ w`$, tuples $`\{v_1, \dots, v_k\}`$ with their projections $`v.k`$ and the binding of their components $`\mathsf{let}\ \{x_1, \dots, x_k\} = v\ \mathsf{in}\ w`$, and a value $`\text{↯}`$ that stands for what was erased.
The extraction follows the strict target of ADE, evaluated by value:

| Term | Extraction |
| --- | --- |
| $`U_l`$, $`\Omega_l`$, $`\Pi^{q}_{p}\, (x : A).\, B`$, $`\Sigma^{\diamond}_\kappa\{\dots\}`$ | $`\text{↯}`$ |
| $`x`$ | $`x`$ |
| $`\lambda_{p}\, (x : A).\, t`$ | $`\lambda x.\, t^\bullet`$ |
| $`t \circ_{p} a`$ | $`t^\bullet\ a^\bullet`$, or $`t^\bullet\ \text{↯}`$ if $`p`$ is erased: only the argument is erased, and the function still runs |
| $`R\{t_1,\ \dots,\ t_n\}`$, multiplicative | $`\{t_{i_1}^\bullet, \dots, t_{i_k}^\bullet\}`$ |
| $`\mathsf{match}_r\ t\ \mathsf{as}\ z\ \mathsf{return}\ C\ \mathsf{with}\ R\{x_1,\ \dots,\ x_n\} \Rightarrow u`$, multiplicative | $`\mathsf{let}\ \{x_{i_1}, \dots, x_{i_k}\} = t^\bullet\ \mathsf{in}\ u^\bullet[\text{↯}/x_j]`$ for the erased fields $`f_j`$ |
| $`\pi_{R, i}\ t`$, multiplicative | $`t^\bullet.j`$, where $`i = i_j`$ |
| $`R\{t_1,\ \dots,\ t_n\}`$, additive | $`\{\lambda y.\, t_{i_1}^\bullet, \dots, \lambda y.\, t_{i_k}^\bullet\}`$, with $`y`$ fresh |
| $`\mathsf{match}_r\ t\ \mathsf{as}\ z\ \mathsf{return}\ C\ \mathsf{with}\ R\{x_1,\ \dots,\ x_n\} \Rightarrow u`$, additive | $`\mathsf{let}\ \{y_1, \dots, y_k\} = t^\bullet\ \mathsf{in}\ u^\bullet[y_1\ \text{↯}/x_{i_1}, \dots, y_k\ \text{↯}/x_{i_k}, \text{↯}/x_j]`$ for the erased fields $`f_j`$, with $`y_1, \dots, y_k`$ fresh |
| $`\pi_{R, i}\ t`$, additive | $`t^\bullet.j\ \text{↯}`$, where $`i = i_j`$ |

In this table, $`i_1 < \dots < i_k`$ are the positions of the fields of $`R`$ whose grade is not erased, so that the fields that do not exist at run time take no room in a record.
For instance, if the three fields of $`R`$ have the grades $`\mathbb{1}`$, $`\langle 0, \omega \rangle`$ and $`\mathbb{1}`$, the fields kept at run time are at the positions $`i_1 = 1`$ and $`i_2 = 3`$, and $`\pi_{R, 3}\ t`$ becomes $`t^\bullet.2\ \text{↯}`$: the second component of the tuple, a delayed field, applied to $`\text{↯}`$ to compute it.
A term that is checked in an erased mode is never extracted: the argument of an erased application, a proof, an erased field, and the type of the result of a match disappear, and the rules forbid the match, in a term that runs, of a record without use at run time.
An erased argument still leaves its abstraction, which receives $`\text{↯}`$, as in the strict target of ADE; removing it from the calling convention is an optimization of the compiler.

The fields of an additive record are delayed, unlike the strong pairs of ADE, which their strict target computes at once: since the user of the record takes one field, computing all of them would run the uses of each field, such as two functions that both consume the same linear resource.
A projection then computes the field it takes, and only this one.
A match of an additive record computes a field at each use of its variable, as a projection would.

The soundness of erasure states that a program and its extraction compute the same value; ADE prove it for the natural numbers, and the values that a program may observe come with the inductive types of a later RFC.
Their proof covers neither the mode $`\mathbb{0}\mathbb{1}^{\mathsf{m}}`$ nor the delayed fields of the additive records, both of which are [unresolved questions](#unresolved-questions), and the evaluation order of Sic, which a later RFC fixes, may choose their non-strict target instead.

### Examples

To be written.

## Drawbacks

To be written.

## Rationale and Alternatives

- Typing and equality carry no grade, as in ADE, instead of carrying them in the typing judgment as [graded modal dependent type theory](https://arxiv.org/abs/2010.13163) (GrTT, Moon, Eades and Orchard) does.
  GrTT checks every subterm as if it ran, even in an erased position: a specification cannot return an erased field, and a field that does not exist at run time has no projection.
  The usage judgment of ADE, indexed by a mode, checks an erased subterm in a mode of its own, and its metatheory is formalized.
  Equality then compares values, not uses, which removes no guarantee: it only compares types, and the usage of every term is checked.
- The judgments are the four of Martin-Löf type theory, as in ADE and in [Abel, Öhman and Vezzosi](https://doi.org/10.1145/3158111), rather than those of a [pure type system](https://en.wikipedia.org/wiki/Pure_type_system), where a type is a term of a sort and two types are equal as terms of a sort only.
  Two equalities of types in different sorts would then compose only if the two sorts were shown equal, which needs the uniqueness of the type of a term, and thus the injectivity of the type of functions for equality: this injectivity follows from the normalization that the formalization has to prove, which itself needs a transitive equality of types.
  The formalization has to show, from normalization, that two equal types are also equal terms of a sort, so that the equality of types adds no equality to those of the sorts.
  The equality of types has its own rules of reflexivity and symmetry, which follow from the other rules, so that the equalities of types and of terms have the same rules, as in the presentation of Nordström, Petersson and Smith.
  A type is still always a term of a sort, unlike in ADE, whose type of levels may lie in no universe, so that the rules that need the level of a type check its sort, and the others check that it is a type.
- Every term determines its type: an abstraction carries the type of its argument, unlike the abstractions of ADE, and the terms of the later constructs carry the types they need.
  The type of a term is then computed from the term alone, without the bidirectional checking that ADE need for their abstractions; the terms of the core are checked, not written by hand, and the language infers what they carry.
- The [records](#records) are positional, and a type with named fields comes from a declaration that makes it distinct from every other type, so that two types with the same fields are never confused, since nothing says that their fields mean the same.
  Records compared by the names of their fields, in the written order or in a canonical one, would make two unrelated types with the same names interchangeable, and would need the names of fields to be told apart from the variables they bind.
- [Records](#records) have any number of fields, while functions have one argument, since a function of several arguments is a function that returns a function, without loss: each argument keeps its grades, and $`\eta`$ makes every other way of writing it equal.
  Records nested two fields at a time would lose the grade of the last field, which the weak pairs of ADE fix to $`\mathbb{1}`$, would need a unit for the innermost one, and would make $`\Sigma^{\text{⊗}}\{A, \Sigma^{\text{⊗}}\{B, C\}\}`$ and $`\Sigma^{\text{⊗}}\{\Sigma^{\text{⊗}}\{A, B\}, C\}`$ two different types, only isomorphic.
  The arguments of a constructor, which should form a record, and the fields of a declared type have any number of fields anyway.
  The metatheory of ADE about pairs is then redone by induction on the fields.
- A [record](#records) has a single construction, so that its projections and its match define each other through $`\eta`$: the multiplicative and additive records share the typing of the strong pairs of ADE, and their connective acts on usage only, where taking fewer fields than a multiplicative record provides needs discarding, and taking more than the one field an additive record provides needs duplicating.
  Keeping the multiplicative records without $`\eta`$, as the weak pairs of ADE, would leave a record unequal to the record rebuilt from its fields, and a record of propositions matched only for a proposition.
  The $`\eta`$ rule of a type defined by its pattern matching, $`C[t] \equiv \mathsf{match}\ t\ \mathsf{with}\ R\{x_1, \dots, x_n\} \Rightarrow C[R\{x_1, \dots, x_n\}]`$, has no known decision procedure with dependent types, and is delicate to decide even without them, as [Scherer](https://doi.org/10.1145/3009837.3009901) shows for sums.
  An $`\eta`$ rule for the records whose fields are all discarded freely, and for them only, would make equality depend on grades.
  The inductive types of a later RFC have several constructions, and keep pattern matching as their elimination.
- Each field carries one grade $`q`$ for its uses in the types of all the fields after it, as the nested pairs of ADE, rather than one grade for each later field, as the rows of grades of GrTT.
  The usage of a record type adds these uses anyway, so finer rows would only add grades to write and to check.
  Without the grade $`q`$, the uses of a field in the types after it would not be counted at all, and a field of grade `none / linear` could not appear in them.
- The sort of a [record](#records) is written in its type and checked, rather than computed from its fields, which would make every record of propositions a proposition and leave no empty record for the true proposition.
  Writing it gives both the unit type and the true proposition as empty records, lets a record of proofs be an ordinary type, and lifts a type to a higher universe; a distinct construct for the records of propositions would instead double the records and their rules.
  The type of a [function](#functions) keeps a computed sort, since computing it loses nothing: two functions into a proposition are equal by irrelevance and $`\eta`$, so placing one in a universe $`U_l`$ would give it no identity of its own.
  A function type is lifted to a higher universe as any type, by a record of one field, so that records remain the only mechanism of lifting.
- The record types are written $`\Sigma^{\diamond}_\kappa`$, after the dependent sum of Martin-Löf type theory, which linearity splits by the connective $`\diamond`$, as ADE write their pairs $`\Sigma_{\otimes}`$ and $`\Sigma_{\&}`$, and the record terms $`R\{t_1,\ \dots,\ t_n\}`$, as the [struct expressions of Rust](https://doc.rust-lang.org/reference/expressions/struct-expr.html), since $`R`$ already carries the connective and the grades.
  The connective is a superscript, so that the sort keeps its place as a subscript, and the types of both kinds of records have one form, as they have one typing.
- The empty additive record absorbs any resources, as the $`\top`$ of linear logic, since the uses of an additive record are bounded by the uses of each of its fields, which no field bounds when there is none.
  Its uses cannot be the meet of the uses of no field, a greatest multiplicity $`\varnothing`$ that allows no number of uses, since no multiplicity can be added above $`0`$, $`1`$ and $`\omega`$: the distributivity $`(0 \wedge 1) \cdot \varnothing = 0 \cdot \varnothing \wedge 1 \cdot \varnothing`$ gives $`\omega \cdot \varnothing = 0`$, hence $`\varnothing + \varnothing = 0`$ since $`\omega = 1 + 1`$, and $`\varnothing = 0`$ by the monotonicity of the addition.
  Restricting it to no resources would make it a second unit type, and forbidding it would make the additive records the only ones that need a field; it is also the dual of the empty type, as the negation of linear logic exchanges them, which protocols with a dual need.

## Prior Art

To be written.

## Unresolved Questions

Four choices of this RFC are provisional, each tied to a question below:

- The empty additive record absorbs any resources, until the conjecture that a program shows in its type the resources it abandons is settled.
- A term that runs does not match a [record](#matching) without use at run time, until erased matches are studied.
- The fields of an additive record are delayed at run time by the [erasure](#erasure), until the soundness of this choice is proved.
- The [erasure](#erasure) targets evaluation by value, until the evaluation order of Sic is fixed.

- Which word names the strict propositions in the language, given that `Prop` is impredicative in Lean and Rocq?
- Does definitional proof irrelevance keep the metatheory of a graded type theory?
  Abel, Danielsson and Eriksson note that their framework cannot model it.
- Which RFC defines the top-level definitions, whose level variables the [universes](#universes) assume?
- Should the usage rule of the type of functions be written with a bound, as the usage rules of the types and of the additive terms of the [records](#records), so that the rules of usage share one style?
  It keeps the exact form of ADE for now, and this point is to be analyzed again.
- Which mechanism declares the types with named fields, distinct from every other type, and how does it relate to the inductive types, of which the [structures of Lean](https://lean-lang.org/doc/reference/latest/The-Type-System/Inductive-Types/#structures) are the case with a single constructor?
  The arguments of each constructor should form a [record](#records), so that a record is never defined in two ways.
- Can a term that runs match a record without use at run time, which ADE call an erased match?
  Erasing it seems sound, since the body uses the fields only in erased positions: [ADE](https://arxiv.org/abs/2603.29716) prove the soundness of erasure with it for closed programs, but their proof fails for a program that runs under hypotheses, in a context that is not empty, for which they only conjecture it; allowing it later would only accept more programs.
  This case is left out for now and must be studied later: the restriction could be lifted for closed programs, which the proof of ADE already covers, the open points being the programs that run under hypotheses and the mode $`\mathbb{0}\mathbb{1}^{\mathsf{m}}`$.
  With the $`\eta`$ rule of the records, a match whose record is neutral reduces to its projections, which removes the [counterexample of ADE](https://github.com/graded-type-theory/graded-type-theory/blob/master/Graded/Erasure/LogicalRelation/Fundamental/Counterexample.agda) for the programs that run under hypotheses, an erased match blocked on a variable while its extraction computes; this reduction preserves the usage when the record is not used at all, $`r = \mathbb{0}`$, but not for the other erased grades, of the mode $`\mathbb{0}\mathbb{1}^{\mathsf{m}}`$.
- Does a program show in its type the resources it abandons in the empty additive record?
  An empty additive record that absorbed a linear resource has no elimination, and using it with a grade that discards it multiplies the grade of the resource, which then loses its single use: the conjecture is that a closed program whose type, normalized, contains no empty additive record abandons no resource, as the subformula property of linear logic implies without dependent types.
  If it fails, the additive records need at least one field, and the empty one becomes a second unit type or disappears.
- Which evaluation order does Sic follow: by value, as the strict target of ADE that the [erasure](#erasure) of this RFC uses, or by name, as their non-strict target, for which they also prove the soundness of erasure?
- Does erasure stay sound when the fields of the additive records are delayed, which the strict target of ADE does not do for its strong pairs?
- Is a term checked in the mode $`\mathbb{0}\mathbb{1}^{\mathsf{m}}`$ erased safely?
  ADE prove the soundness of erasure for their two modes only; the projection of a grade on its run-time multiplicity preserves the operations and the order, and could carry their result to the three modes.
