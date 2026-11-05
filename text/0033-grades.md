# RFC 0033: Grades

- Pull request: [sic-lang/rfcs#33](https://github.com/sic-lang/rfcs/pull/33)

## Summary

This RFC defines the grades with which the core of Sic counts the uses of its variables: the multiplicities, which count uses, the grades, which pair the uses at run time with all the uses, and the modes, in which a term is checked for its uses.
It gives their operations, their order, their meaning as an abstract interpretation of the numbers of uses, and the properties that the [graded dependent core](https://github.com/sic-lang/rfcs/pull/24) relies on, among which the laws that the usage of recursion needs and the projection of the grades on their run-time multiplicity.
The grades form a modality of the graded dependent type theory of [Abel, Danielsson and Eriksson](https://doi.org/10.1145/3607862) (ADE), whose rules the core follows.

## Motivation

The [grades](https://github.com/sic-lang/rfcs/pull/16) of Sic count the uses of a variable along two axes, at run time and in total, so that a program states which resources it consumes, which proofs and specifications it erases, and which permissions it passes on exactly once.
Every RFC of the core reads the grades: the [graded dependent core](https://github.com/sic-lang/rfcs/pull/24) checks the usage of every term with them, the [data and codata types](https://github.com/sic-lang/rfcs/pull/34) count the uses of recursion with their greatest lower bounds, and the [observational equality](https://github.com/sic-lang/rfcs/pull/35) compares the grades of two types.
This RFC defines them once, with their algebra, so that the other RFCs state their rules in terms of properties named here, as ADE parametrize their theory by a modality that their rules only know by its laws.

## Proposal

The proposal first fixes the notation, then defines the multiplicities, the grades and the modes, gives the meaning of the multiplicities and of the grades, and ends with the properties of the grades that the other RFCs use.

### Notation

Each letter keeps one kind, as in the other RFCs of the core:

| Letters | Denote |
| --- | --- |
| $`u, v, w`$ | Multiplicities |
| $`p, q, r`$ | Grades, $`r`$ being the grade of a term that an elimination consumes |
| $`m`$ | Modes |
| $`S`$ | A set of numbers of uses, of pairs of numbers of uses, or of grades |
| $`I`$ | A set of indices, which indexes a family of grades |
| $`a, b`$ | Natural numbers, the numbers of uses |

A subscript numbers objects of the same kind that come from different premises, as $`p_1`$ and $`p_2`$: an object alone of its kind has none, and several are all numbered.

The operations on multiplicities and on grades are written alike, the kind of their operands telling which is meant:

```math
p + q \qquad p \cdot q \qquad p \wedge q \qquad p \le q
```

They are the addition, the multiplication, the meet and the order; the meet of a non-empty set $`S`$ of grades is written $`\bigwedge S`$.
The formulas of the meaning and of the properties are named in their last column, as the rules of the other RFCs are named after their fraction; a formula about multiplicities is indexed by $`u`$ and a formula about grades by $`p`$, the letters of their metavariables.
A variable left free in a formula is universally quantified, over the kind that its letter names.

The rules of ADE know the grades only as a modality, whose notation this RFC keeps where it does not depart from it:

| Formalization of ADE | This RFC |
| --- | --- |
| `Modality`, with its `𝟘`, `𝟙`, `+`, `·`, `∧` | The seven grades, $`\mathbb{0}`$, $`\mathbb{1}`$, $`+`$, $`\cdot`$, $`\wedge`$ |
| `𝟘ᵐ`, `𝟙ᵐ` | $`\mathbb{0}\mathbb{0}^{\mathsf{m}}`$, $`\mathbb{1}\mathbb{1}^{\mathsf{m}}`$, with the [mode](#modes) $`\mathbb{0}\mathbb{1}^{\mathsf{m}}`$ between them |
| `⌜ m ⌝`, `⌞ p ⌟` | $`\ulcorner m \urcorner`$, $`\llcorner p \lrcorner`$ |
| `m ᵐ· p` | $`m \odot p`$ |

### Multiplicities

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

The multiplicities are ordered by their meet, $`u \le v`$ when $`u = u \wedge v`$, as in ADE: $`\omega`$ is below $`0`$ and below $`1`$, while $`0`$ and $`1`$ are not comparable, so that a variable of multiplicity $`\omega`$ may be used any number of times, none included, one of multiplicity $`1`$ exactly once and one of multiplicity $`0`$ never.

### Grades

A grade counts the uses of a variable along the two axes of the [grades](https://github.com/sic-lang/rfcs/pull/16) of Sic: its uses at run time, and all its uses, erased or not.
It is a pair of [multiplicities](#multiplicities), written in angle brackets, whose first multiplicity counts the uses at run time and the second all the uses.
The run-time uses are among all the uses, so a pair whose second multiplicity is $`0`$ has $`0`$ as its first multiplicity too: of the nine pairs, the seven others are the grades.
The grade $`\langle 0, 0 \rangle`$ is written $`\mathbb{0}`$ and $`\langle 1, 1 \rangle`$ is written $`\mathbb{1}`$.

The operations act on each multiplicity, and the seven grades are closed under them:

```math
\begin{aligned}
\langle u_1, v_1 \rangle + \langle u_2, v_2 \rangle &= \langle u_1 + u_2,\ v_1 + v_2 \rangle \\
\langle u_1, v_1 \rangle \cdot \langle u_2, v_2 \rangle &= \langle u_1 \cdot u_2,\ v_1 \cdot v_2 \rangle \\
\langle u_1, v_1 \rangle \wedge \langle u_2, v_2 \rangle &= \langle u_1 \wedge u_2,\ v_1 \wedge v_2 \rangle
\end{aligned}
```

The order of the grades is that of ADE: $`p \le q`$ when $`p = p \wedge q`$, which means that a variable of grade $`p`$ may be used where the grade $`q`$ is expected; it is the order of the multiplicities on each component.

The grade $`\langle \omega, 1 \rangle`$ is the meet of $`\langle 0, 1 \rangle`$ and $`\mathbb{1}`$: a variable used once in total, erased in one branch and at run time in another, is used once in total and at most once at run time.
Without it, this meet would be $`\langle \omega, \omega \rangle`$, and the multiplication would not distribute over the meet, as ADE require of a modality: $`\langle 0, 1 \rangle \cdot (\langle 0, 1 \rangle \wedge \mathbb{1})`$ would be $`\langle 0, \omega \rangle`$, and $`\langle 0, 1 \rangle \cdot \langle 0, 1 \rangle \wedge \langle 0, 1 \rangle \cdot \mathbb{1}`$ would be $`\langle 0, 1 \rangle`$.

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
On the seven grades, the grades that allow discarding, $`p \le \mathbb{0}`$, are exactly those that allow duplicating, $`p \le p + p`$: $`\mathbb{0}`$, $`\langle 0, \omega \rangle`$ and $`\langle \omega, \omega \rangle`$.

The run-time multiplicity of a grade is its projection, which the [erasure](https://github.com/sic-lang/rfcs/pull/24) of the core reads:

```math
\mathsf{run}(\langle u, v \rangle) = u \qquad (\mathsf{run}_p)
```

### Modes

A mode is the setting in which the usage of a term is checked.
The core has three modes, named after their grade $`\ulcorner m \urcorner`$, with which a variable checked in the mode $`m`$ uses itself:

| Mode | Grade | Counts |
| --- | --- | --- |
| $`\mathbb{0}\mathbb{0}^{\mathsf{m}}`$ | $`\mathbb{0}`$ | no use |
| $`\mathbb{0}\mathbb{1}^{\mathsf{m}}`$ | $`\langle 0, 1 \rangle`$ | all the uses, none at run time |
| $`\mathbb{1}\mathbb{1}^{\mathsf{m}}`$ | $`\mathbb{1}`$ | all the uses and the uses at run time |

A term used with the grade $`p`$ is checked in the mode $`\llcorner p \lrcorner`$ of this grade: $`\mathbb{0}\mathbb{0}^{\mathsf{m}}`$ for $`\mathbb{0}`$, $`\mathbb{0}\mathbb{1}^{\mathsf{m}}`$ for the other grades whose run-time multiplicity is $`0`$, those of proofs, specifications and permissions, and $`\mathbb{1}\mathbb{1}^{\mathsf{m}}`$ for the grades used at run time; the program itself is checked in $`\mathbb{1}\mathbb{1}^{\mathsf{m}}`$:

```math
\llcorner \mathbb{0} \lrcorner = \mathbb{0}\mathbb{0}^{\mathsf{m}} \qquad \llcorner \langle 0, v \rangle \lrcorner = \mathbb{0}\mathbb{1}^{\mathsf{m}} \text{ if } v \ne 0 \qquad \llcorner \langle u, v \rangle \lrcorner = \mathbb{1}\mathbb{1}^{\mathsf{m}} \text{ if } u \ne 0
```

Modes are never written: they follow from the grades, and the two erased modes appear only inside the program, where a rule checks a subterm used with an erased grade, such as an erased argument, a proof, or the type of a binder.
The product of two modes is the mode of the product of their grades, $`m_1 \cdot^{\mathsf{m}} m_2 = \llcorner \ulcorner m_1 \urcorner \cdot \ulcorner m_2 \urcorner \lrcorner`$, whose grade is the product $`\ulcorner m_1 \urcorner \cdot \ulcorner m_2 \urcorner`$ itself since the grades of the three modes are closed under multiplication; it is the more erased of the two modes.
Inside a term checked in the mode $`m`$, a subterm used with the grade $`p`$ is checked in the mode $`m \odot p = m \cdot^{\mathsf{m}} \llcorner p \lrcorner`$, written as in the paper of ADE, so that a subterm, once erased, stays erased.

ADE have the two modes $`\mathbb{0}^{\mathsf{m}}`$ and $`\mathbb{1}^{\mathsf{m}}`$ only, which are $`\mathbb{0}\mathbb{0}^{\mathsf{m}}`$ and $`\mathbb{1}\mathbb{1}^{\mathsf{m}}`$ here.
The mode $`\mathbb{0}\mathbb{1}^{\mathsf{m}}`$ is added so that an erased term still counts all its uses: in $`\mathbb{0}^{\mathsf{m}}`$, a proof could drop or duplicate a permission of grade `none / linear`.
The modes project on those of ADE as the grades project on their run-time multiplicity, which the [properties](#properties) state.

### Meaning

The multiplicities and the grades are an [abstract interpretation](https://doi.org/10.1145/512950.512973) of the numbers of uses, in the sense of Cousot and Cousot: each stands for the numbers of uses it allows, and its operations approximate those of the numbers, soundly and as precisely as the multiplicities and the grades can, from which their tables and their orders follow.
The modes have no meaning of their own: a mode is the grade $`\ulcorner m \urcorner`$ with which a variable uses itself, and means what this grade means.
The uses of a variable that a program makes when it runs depend on its evaluation order, which a later RFC fixes; this meaning counts the uses that a term makes, as its usage counts them, and the [erasure](https://github.com/sic-lang/rfcs/pull/24) of the core gives its meaning to a run-time multiplicity $`0`$: the term that has it is absent from the program that runs.

#### Meaning of the Multiplicities

A multiplicity stands for the numbers of uses it allows:

```math
\mathsf{uses}(0) = \{0\} \qquad \mathsf{uses}(1) = \{1\} \qquad \mathsf{uses}(\omega) = \mathbb{N} \qquad (\mathsf{uses}_u)
```

The best multiplicity for a non-empty set $`S`$ of numbers of uses is the one that allows all of them, and allows the fewest numbers among those that do; the empty set has none, since $`0`$ and $`1`$ both allow its elements, vacuously, and neither allows fewer numbers than the other, but no operation below needs it.
Each operation is the [best abstraction](https://doi.org/10.1145/567752.567778) of the same operation on numbers, and the order is the reverse inclusion, so that a lower multiplicity allows more numbers of uses, the reverse of the usual order of abstract interpretation:

```math
\mathsf{best}(S) = u \iff S \subseteq \mathsf{uses}(u) \text{ and } \forall w.\ S \subseteq \mathsf{uses}(w) \implies \mathsf{uses}(u) \subseteq \mathsf{uses}(w) \qquad (\mathsf{best}_u)
```

```math
\begin{aligned}
u + v &= \mathsf{best}(\{a + b \mid a \in \mathsf{uses}(u),\ b \in \mathsf{uses}(v)\}) &&(+_u) \\
u \cdot v &= \mathsf{best}(\{a \cdot b \mid a \in \mathsf{uses}(u),\ b \in \mathsf{uses}(v)\}) &&(\cdot_u) \\
u \wedge v &= \mathsf{best}(\mathsf{uses}(u) \cup \mathsf{uses}(v)) &&(\wedge_u) \\
u \le v &\iff \mathsf{uses}(v) \subseteq \mathsf{uses}(u) &&(\le_u)
\end{aligned}
```

For instance, $`1 + 1`$ allows $`2`$ uses, which only $`\omega`$ allows, and $`0 \wedge 1`$ allows $`0`$ and $`1`$ uses, which only $`\omega`$ allows too.

#### Meaning of the Grades

A grade stands for the pairs of numbers of uses it allows, at run time and in total, the uses at run time being among all the uses:

```math
\mathsf{uses}(\langle u, v \rangle) = \{(a, b) \mid a \in \mathsf{uses}(u),\ b \in \mathsf{uses}(v),\ a \le b\} \qquad (\mathsf{uses}_p)
```

Each operation gives the best grade for a non-empty set $`S`$ of pairs of numbers of uses, as for the multiplicities, and the order is again the reverse inclusion:

```math
\mathsf{best}(S) = p \iff S \subseteq \mathsf{uses}(p) \text{ and } \forall q.\ S \subseteq \mathsf{uses}(q) \implies \mathsf{uses}(p) \subseteq \mathsf{uses}(q) \qquad (\mathsf{best}_p)
```

```math
\begin{aligned}
p + q &= \mathsf{best}(\{(a_1 + a_2, b_1 + b_2) \mid (a_1, b_1) \in \mathsf{uses}(p),\ (a_2, b_2) \in \mathsf{uses}(q)\}) &&(+_p) \\
p \cdot q &= \mathsf{best}(\{(a_1 \cdot a_2, b_1 \cdot b_2) \mid (a_1, b_1) \in \mathsf{uses}(p),\ (a_2, b_2) \in \mathsf{uses}(q)\}) &&(\cdot_p) \\
p \wedge q &= \mathsf{best}(\mathsf{uses}(p) \cup \mathsf{uses}(q)) &&(\wedge_p) \\
p \le q &\iff \mathsf{uses}(q) \subseteq \mathsf{uses}(p) &&(\le_p)
\end{aligned}
```

The grade $`\langle \omega, 1 \rangle`$ allows exactly the pairs $`(0, 1)`$ and $`(1, 1)`$, the union of those of $`\langle 0, 1 \rangle`$ and of $`\mathbb{1}`$, which makes it their meet.
This meaning also chooses the seven grades among the nine pairs: $`\langle 1, 0 \rangle`$ allows no pair, since a use at run time is a use, and $`\langle \omega, 0 \rangle`$ allows only $`(0, 0)`$, as $`\mathbb{0}`$ does, while the seven grades allow non-empty sets of pairs, all different.

The projection of a grade on its run-time multiplicity is sound for the first components of its pairs, but not exact: $`\langle \omega, 1 \rangle`$ allows $`0`$ and $`1`$ uses at run time, which only $`\omega`$ allows among the multiplicities:

```math
\{a \mid (a, b) \in \mathsf{uses}(p)\} \subseteq \mathsf{uses}(\mathsf{run}(p)) \qquad (\mathsf{sound}_{\mathsf{run}})
```

### Properties

The properties below are theorems about the seven grades, each a named formula, which the other RFCs cite; the multiplicities satisfy the same, as the grades whose two components are equal.
They hold for all grades $`p`$, $`q`$ and $`r`$, and for every non-empty set $`S`$ of grades.

#### Modality

The seven grades form a modality of ADE, a semiring ordered by its meet, whose zero is well behaved, as its modes require:

```math
\begin{aligned}
& p \cdot (q + r) = p \cdot q + p \cdot r \text{ and } (q + r) \cdot p = q \cdot p + r \cdot p &&(\cdot_{+}) \\
& p \cdot (q \wedge r) = p \cdot q \wedge p \cdot r \text{ and } (q \wedge r) \cdot p = q \cdot p \wedge r \cdot p &&(\cdot_{\wedge}) \\
& p \le q \implies p + r \le q + r &&(+_{\le}) \\
& r \le p \text{ and } r \le q \iff r \le p \wedge q &&(\wedge_{\le}) \\
& \mathbb{0} \ne \mathbb{1}, \quad p + q = \mathbb{0} \implies p = q = \mathbb{0}, \quad p \wedge q = \mathbb{0} \implies p = q = \mathbb{0}, &&(\mathbb{0}_{p}) \\
& \quad p \cdot q = \mathbb{0} \implies p = \mathbb{0} \text{ or } q = \mathbb{0}
\end{aligned}
```

The two excluded pairs would break the last property: $`\langle 1, 0 \rangle \cdot \langle 0, 1 \rangle`$ and $`\langle \omega, 0 \rangle \cdot \langle 0, 1 \rangle`$ are both $`\mathbb{0}`$.
The three modes form a mode structure of the formalization of ADE, which defines modes abstractly.

#### Greatest Lower Bounds

Every non-empty set of grades has a greatest lower bound, its meet, which the usage of the [recursion](https://github.com/sic-lang/rfcs/pull/34) of the data and codata types takes over all the shapes of a term:

```math
\begin{aligned}
& (\forall p \in S.\ \textstyle\bigwedge S \le p) \text{ and } ((\forall p \in S.\ r \le p) \implies r \le \textstyle\bigwedge S) &&(\bigwedge_{p})
\end{aligned}
```

The meet of a family is superadditive, and the multiplication by a grade commutes with it, for every family $`(p_i)_{i \in I}`$ and $`(q_i)_{i \in I}`$ indexed by a non-empty set $`I`$:

```math
\begin{aligned}
\textstyle\bigwedge_{i \in I} p_i + \bigwedge_{i \in I} q_i &\le \textstyle\bigwedge_{i \in I} (p_i + q_i) &&(\bigwedge_{+}) \\
r \cdot \textstyle\bigwedge_{i \in I} p_i &= \textstyle\bigwedge_{i \in I} r \cdot p_i &&(\bigwedge_{\cdot})
\end{aligned}
```

These are the greatest lower bounds that [Eriksson, Abel and Danielsson](https://doi.org/10.1145/3828677) call well behaved, which their usage rule of recursion needs for the family of the usages of all the unfoldings of a recursion, each a linear form in the usages of the branches.
They assume them, since a modality may be infinite; here they follow from $`(\cdot_{\wedge})`$, $`(+_{\le})`$ and $`(\wedge_{\le})`$, since a family of grades takes at most seven values, so that its meet is a finite meet.

#### Projection

The projection on the run-time multiplicity is a homomorphism of modalities, which preserves the operations, the order and the units:

```math
\begin{aligned}
& \mathsf{run}(p + q) = \mathsf{run}(p) + \mathsf{run}(q), \quad \mathsf{run}(p \cdot q) = \mathsf{run}(p) \cdot \mathsf{run}(q), &&(\mathsf{run}_{\mathsf{op}}) \\
& \quad \mathsf{run}(p \wedge q) = \mathsf{run}(p) \wedge \mathsf{run}(q), \quad \mathsf{run}(\mathbb{0}) = 0, \quad \mathsf{run}(\mathbb{1}) = 1 \\
& p \le q \implies \mathsf{run}(p) \le \mathsf{run}(q) &&(\mathsf{run}_{\le})
\end{aligned}
```

The modes project on the two modes of ADE, whose modality is the multiplicities, the two erased modes on $`\mathbb{0}^{\mathsf{m}}`$ and the mode of run time on $`\mathbb{1}^{\mathsf{m}}`$, and the projection commutes with the mode of a grade and with the product of a mode by a grade:

```math
\begin{aligned}
& \mathsf{run}(\mathbb{0}\mathbb{0}^{\mathsf{m}}) = \mathsf{run}(\mathbb{0}\mathbb{1}^{\mathsf{m}}) = \mathbb{0}^{\mathsf{m}}, \quad \mathsf{run}(\mathbb{1}\mathbb{1}^{\mathsf{m}}) = \mathbb{1}^{\mathsf{m}} &&(\mathsf{run}_{m}) \\
& \mathsf{run}(\llcorner p \lrcorner) = \llcorner \mathsf{run}(p) \lrcorner, \quad \ulcorner \mathsf{run}(m) \urcorner = \mathsf{run}(\ulcorner m \urcorner), &&(\mathsf{run}_{\odot}) \\
& \quad \mathsf{run}(m \odot p) = \mathsf{run}(m) \odot \mathsf{run}(p)
\end{aligned}
```

A derivation of usage in the three modes thus projects on a derivation in the two modes of ADE, with the run-time multiplicities for grades, which the [core](https://github.com/sic-lang/rfcs/pull/24) states as its projection lemma: the erasure of a term is read on its run-time multiplicities alone, and the mode $`\mathbb{0}\mathbb{1}^{\mathsf{m}}`$ changes nothing to what runs.

## Drawbacks

- The grade $`\langle \omega, 1 \rangle`$, `affine / linear`, exists to keep the multiplication distributive over the meet, rather than for a need of programs.
- Seven grades, among which a programmer chooses on every binder, are many: the surface language has to infer most of them, which no RFC designs yet.
- The meaning counts the uses that a term makes, not those that a program makes when it runs, which depend on the evaluation order; the multiplicities $`1`$ and $`\omega`$ at run time wait for the RFC of the calling convention to mean a number of uses.

## Rationale and Alternatives

- The grades are pairs of multiplicities, one for each axis, rather than a flat set of named grades: the operations and the order act on each component, which gives their tables and their properties at once, and the names of the grades in Sic are read off the components.
- The order is the meet, as in ADE, rather than the reverse inclusion of the abstract interpretation turned into an order of its own: the rules of ADE and their formalization use the meet as the order, so that the grades instantiate them as they are.
- The meet is the best abstraction of the union of the uses, so that a variable used differently by two branches gets the grade that allows both, rather than the join, which would allow fewer uses than either branch makes.
- The excluded pairs $`\langle 1, 0 \rangle`$ and $`\langle \omega, 0 \rangle`$ are left out rather than identified with $`\mathbb{0}`$: they have no meaning of their own, and keeping them would break the well-behaved zero that the modes of ADE require.
- The properties of the greatest lower bounds are stated for arbitrary families and proved by finiteness, rather than assumed as Eriksson, Abel and Danielsson do: a reader checks them on seven grades, and the usage of recursion cites them without a proof obligation of its own.
- Conscious exclusions, each with what is lost, what remains, and whether it can be added later:
  - Exact counts above one, such as a grade for exactly two uses: a resource used twice is unrestricted; the pairs of multiplicities would extend to pairs of larger modalities, as the [exact usage](https://doi.org/10.1145/3341714) of Granule, at the cost of larger tables and of the finiteness that proves the properties above.
  - A greatest grade that allows no number of uses, the best abstraction of the empty set: no operation needs it, and no multiplicity can be added above $`0`$, $`1`$ and $`\omega`$ without breaking the distributivity, since $`(0 \wedge 1) \cdot \varnothing = 0 \cdot \varnothing \wedge 1 \cdot \varnothing`$ would give $`\omega \cdot \varnothing = 0`$, hence $`\varnothing + \varnothing = 0`$ since $`\omega = 1 + 1`$, and $`\varnothing = 0`$ by the monotonicity of the addition.

## Prior Art

- The graded type theory of [Abel, Danielsson and Eriksson](https://doi.org/10.1145/3607862), extended in their [journal version](https://arxiv.org/abs/2603.29716) and [formalized in Agda](https://github.com/graded-type-theory/graded-type-theory), parametrizes its rules by a modality, a semiring ordered by its meet with a well-behaved zero, and by a mode structure; the seven grades and the three modes instantiate both.
  [Eriksson, Abel and Danielsson](https://doi.org/10.1145/3828677) add the well-behaved greatest lower bounds that the usage of recursion needs.
- Grades on binders come from [McBride](https://doi.org/10.1007/978-3-319-30936-1_12) and the quantitative type theory of [Atkey](https://doi.org/10.1145/3209108.3209189), which [Idris 2](https://arxiv.org/abs/2104.00480) implements with the multiplicities $`0`$, $`1`$ and $`\omega`$, and [Linear Haskell](https://ghc.gitlab.haskell.org/ghc/doc/users_guide/exts/linear_types.html) with $`1`$ and $`\omega`$.
- The [graded modal dependent type theory](https://arxiv.org/abs/2010.13163) of Moon, Eades and Orchard carries grades in typing, and [Granule](https://doi.org/10.1145/3341714) is a language built on graded modal types, whose semirings include exact counts.
- [Verus](https://doi.org/10.1145/3586037) separates the code that runs from the specifications and proofs by [modes of variables](https://verus-lang.github.io/verus/guide/reference-var-modes.html), and tracks ghost resources linearly, which the grades `none / linear` and `linear / unrestricted` express here.
- The abstract interpretation of [Cousot and Cousot](https://doi.org/10.1145/512950.512973) and its [best abstractions](https://doi.org/10.1145/567752.567778) give the meaning of the multiplicities and of the grades.

## Unresolved Questions

- What do the run-time multiplicities $`1`$ and $`\omega`$ mean for a program that runs?
  The meaning counts the uses that a term makes, and the uses made when it runs depend on the evaluation order, which the RFC of the calling convention fixes.
