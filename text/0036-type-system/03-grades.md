# Grades

This annex defines the grades, which count the uses of a variable at run time and in total, with their operations, their order, their projection on the run-time multiplicity, their meaning and their properties.
It builds on the [multiplicities](02-multiplicities.md).

## Definitions

A grade is a pair of multiplicities, written in angle brackets, whose first multiplicity counts the uses at run time and the second all the uses, erased or not.
The uses at run time are among all the uses, so a pair whose second multiplicity is $`0`$ has $`0`$ as its first multiplicity too: of the nine pairs, the seven others are the grades.
The grade $`\langle 0, 0 \rangle`$ is written $`\mathbb{0}`$ and $`\langle 1, 1 \rangle`$ is written $`\mathbb{1}`$.

Each grade has a name in Sic, made of the names of its two multiplicities: `none`, `linear` and `unrestricted` for $`0`$, $`1`$ and $`\omega`$, except a run-time multiplicity $`\omega`$ under a total multiplicity $`1`$, named `affine` since it counts at most one use:

| Name | Grade |
| --- | --- |
| `affine / linear` | $`\langle \omega, 1 \rangle`$ |
| `linear / linear` | $`\mathbb{1}`$ |
| `linear / unrestricted` | $`\langle 1, \omega \rangle`$ |
| `none / linear` | $`\langle 0, 1 \rangle`$ |
| `none / none` | $`\mathbb{0}`$ |
| `none / unrestricted` | $`\langle 0, \omega \rangle`$ |
| `unrestricted / unrestricted` | $`\langle \omega, \omega \rangle`$ |

The operations act on each multiplicity, and the seven grades are closed under them:

```math
\begin{aligned}
& \langle \pi_1, \pi_2 \rangle + \langle \pi_3, \pi_4 \rangle = \langle \pi_1 + \pi_3,\ \pi_2 + \pi_4 \rangle &&(\mathsf{op}_p) \\
& \langle \pi_1, \pi_2 \rangle \cdot \langle \pi_3, \pi_4 \rangle = \langle \pi_1 \cdot \pi_3,\ \pi_2 \cdot \pi_4 \rangle \\
& \langle \pi_1, \pi_2 \rangle \wedge \langle \pi_3, \pi_4 \rangle = \langle \pi_1 \wedge \pi_3,\ \pi_2 \wedge \pi_4 \rangle
\end{aligned}
```

The grades are ordered by their meet, $`p \le q`$ when $`p = p \wedge q`$, which means that a variable of grade $`p`$ may be used where the grade $`q`$ is expected; it is the order of the multiplicities on each component:

```math
\begin{aligned}
& \langle \pi_1, \pi_2 \rangle \le \langle \pi_3, \pi_4 \rangle \iff \pi_1 \le \pi_3 \text{ and } \pi_2 \le \pi_4 &&(\mathsf{order}_p)
\end{aligned}
```

The grades that allow discarding a variable are exactly those that allow duplicating it:

```math
\begin{aligned}
& p \le \mathbb{0} \iff p \le p + p &&(\mathsf{discard}_p) \\
& p \le \mathbb{0} \iff p \in \{\mathbb{0},\ \langle 0, \omega \rangle,\ \langle \omega, \omega \rangle\}
\end{aligned}
```

The run-time multiplicity of a grade is its projection:

```math
\begin{aligned}
& \mathsf{run}(\langle \pi_1, \pi_2 \rangle) = \pi_1 &&(\mathsf{run}_p)
\end{aligned}
```

## Meaning

A pair of multiplicities stands for the pairs of numbers of uses it allows, at run time and in total, the uses at run time being among all the uses, so that a grade is an abstract interpretation of these pairs, as a multiplicity is of the numbers of uses:

```math
\begin{aligned}
& {=} &&(\mathsf{uses}_p) \\
& \quad \mathsf{uses}(\langle \pi_1, \pi_2 \rangle) \\
& \quad \{(n_1, n_2) \mid n_1 \in \mathsf{uses}(\pi_1),\ n_2 \in \mathsf{uses}(\pi_2),\ n_1 \le n_2\}
\end{aligned}
```

This meaning chooses the seven grades among the nine pairs: $`\langle 1, 0 \rangle`$ allows no pair, since a use at run time is a use, and $`\langle \omega, 0 \rangle`$ allows only $`(0, 0)`$, as $`\mathbb{0}`$ does, while the seven grades allow non-empty sets of pairs, all different:

```math
\begin{aligned}
& \mathsf{uses}(\langle 1, 0 \rangle) = \varnothing &&(\mathsf{excluded}_p) \\
& \mathsf{uses}(\langle \omega, 0 \rangle) = \mathsf{uses}(\mathbb{0}) \\
& \mathsf{uses}(p) \ne \varnothing &&(\mathsf{distinct}_p) \\
& \mathsf{uses}(p) = \mathsf{uses}(q) \implies p = q
\end{aligned}
```

The best grade for a set $`S`$ of pairs of numbers of uses is defined as for the multiplicities, and the operations and the order are again those of the numbers of uses, on each component:

```math
\begin{aligned}
& \text{⟺} &&(\mathsf{best}_p) \\
& \quad \mathsf{best}(S) = p \\
& \quad \text{and} \\
& \qquad S \subseteq \mathsf{uses}(p) \\
& \qquad \forall q.\ S \subseteq \mathsf{uses}(q) \implies \mathsf{uses}(p) \subseteq \mathsf{uses}(q) \\
& \mathsf{best}(S) = p \text{ and } \mathsf{best}(S) = q \implies p = q &&(\mathsf{unique}_p) \\
& {=} &&(+_p) \\
& \quad p + q \\
& \quad \mathsf{best}( \\
& \qquad \{(n_1 + n_3,\ n_2 + n_4) \mid (n_1, n_2) \in \mathsf{uses}(p), \\
& \qquad (n_3, n_4) \in \mathsf{uses}(q)\}) \\
& {=} &&(\cdot_p) \\
& \quad p \cdot q \\
& \quad \mathsf{best}( \\
& \qquad \{(n_1 \cdot n_3,\ n_2 \cdot n_4) \mid (n_1, n_2) \in \mathsf{uses}(p), \\
& \qquad (n_3, n_4) \in \mathsf{uses}(q)\}) \\
& p \wedge q = \mathsf{best}(\mathsf{uses}(p) \cup \mathsf{uses}(q)) &&(\wedge_p) \\
& p \le q \iff \mathsf{uses}(q) \subseteq \mathsf{uses}(p) &&(\le_p)
\end{aligned}
```

The projection on the run-time multiplicity is sound for the first components of the pairs, but not exact: $`\langle \omega, 1 \rangle`$ allows $`0`$ and $`1`$ uses at run time, which only $`\omega`$ allows among the multiplicities, and $`\omega`$ allows $`2`$:

```math
\begin{aligned}
& \{n_1 \mid (n_1, n_2) \in \mathsf{uses}(p)\} \subseteq \mathsf{uses}(\mathsf{run}(p)) &&(\mathsf{sound}_{\mathsf{run}}) \\
& 2 \in \mathsf{uses}(\mathsf{run}(\langle \omega, 1 \rangle)) &&(\mathsf{inexact}_{\mathsf{run}}) \\
& 2 \notin \{n_1 \mid (n_1, n_2) \in \mathsf{uses}(\langle \omega, 1 \rangle)\}
\end{aligned}
```

## Properties

The properties of the grades are those of a modality, of its greatest lower bounds, and of its projection on the run-time multiplicity.

### Modality

The seven grades form a modality of [Abel, Danielsson and Eriksson](https://doi.org/10.1145/3607862), as the multiplicities do:

```math
\begin{aligned}
& (p + q) + r = p + (q + r) &&(\mathsf{semiring}_p) \\
& p + q = q + p \\
& \mathbb{0} + p = p \\
& (p \cdot q) \cdot r = p \cdot (q \cdot r) \\
& \mathbb{1} \cdot p = p \cdot \mathbb{1} = p \\
& \mathbb{0} \cdot p = p \cdot \mathbb{0} = \mathbb{0} \\
& (p \wedge q) \wedge r = p \wedge (q \wedge r) &&(\mathsf{meet}_p) \\
& p \wedge q = q \wedge p \\
& p \wedge p = p \\
& p \cdot (q + r) = (p \cdot q) + (p \cdot r) &&({\cdot}{+}_p) \\
& (q + r) \cdot p = (q \cdot p) + (r \cdot p) \\
& p \cdot (q \wedge r) = (p \cdot q) \wedge (p \cdot r) &&({\cdot}{\wedge}_p) \\
& (q \wedge r) \cdot p = (q \cdot p) \wedge (r \cdot p) \\
& p + (q \wedge r) = (p + q) \wedge (p + r) &&({+}{\wedge}_p) \\
& (q \wedge r) + p = (q + p) \wedge (r + p) \\
& p \le q \implies p + r \le q + r &&({+}{\le}_p) \\
& r \le p \text{ and } r \le q \iff r \le p \wedge q &&({\wedge}{\le}_p) \\
& \mathbb{0} \ne \mathbb{1} &&(\mathbb{0}_p) \\
& p + q = \mathbb{0} \implies p = \mathbb{0} \text{ and } q = \mathbb{0} \\
& p \wedge q = \mathbb{0} \implies p = \mathbb{0} \text{ and } q = \mathbb{0} \\
& p \cdot q = \mathbb{0} \implies p = \mathbb{0} \text{ or } q = \mathbb{0}
\end{aligned}
```

### Greatest Lower Bounds

Every non-empty set $`S`$ of grades has a greatest lower bound $`\bigwedge S`$:

```math
\begin{aligned}
& \forall p \in S.\ \textstyle\bigwedge S \le p &&(\textstyle\bigwedge_p) \\
& (\forall p \in S.\ r \le p) \implies r \le \textstyle\bigwedge S
\end{aligned}
```

For all families $`(p_i)_{i \in I}`$ and $`(q_i)_{i \in I}`$ of grades indexed by a non-empty set $`I`$, the greatest lower bound is superadditive, and the multiplication by a grade commutes with it, as [Eriksson, Abel and Danielsson](https://doi.org/10.1145/3828677) require of well-behaved greatest lower bounds:

```math
\begin{aligned}
& \textstyle\bigwedge_{i \in I} p_i + \bigwedge_{i \in I} q_i \le \bigwedge_{i \in I} (p_i + q_i) &&(\textstyle\bigwedge{+}_p) \\
& r \cdot \textstyle\bigwedge_{i \in I} p_i = \bigwedge_{i \in I} (r \cdot p_i) &&(\textstyle\bigwedge{\cdot}_p)
\end{aligned}
```

### Projection

The projection on the run-time multiplicity is a homomorphism of modalities, which preserves the operations, the units and the order:

```math
\begin{aligned}
& \mathsf{run}(p + q) = \mathsf{run}(p) + \mathsf{run}(q) &&(\mathsf{run}_{\mathsf{op}}) \\
& \mathsf{run}(p \cdot q) = \mathsf{run}(p) \cdot \mathsf{run}(q) \\
& \mathsf{run}(p \wedge q) = \mathsf{run}(p) \wedge \mathsf{run}(q) \\
& \mathsf{run}(\mathbb{0}) = 0 \\
& \mathsf{run}(\mathbb{1}) = 1 \\
& p \le q \implies \mathsf{run}(p) \le \mathsf{run}(q) &&(\mathsf{run}_{\le})
\end{aligned}
```
