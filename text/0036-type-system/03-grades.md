# Grades

This annex defines the grades, which count the uses of a variable at run time and in total, with their operations, their order, their projection on the run-time multiplicity, their meaning and their properties.
It builds on the [multiplicities](02-multiplicities.md).

## Definitions

A grade is a pair $`\langle \pi_1, \pi_2 \rangle`$ of multiplicities, whose first multiplicity counts the uses at run time and the second all the uses, erased or not.
The uses at run time are among all the uses, so a pair whose second multiplicity is $`0`$ has $`0`$ as its first multiplicity too: of the nine pairs, the seven others are the grades:

```math
\begin{aligned}
& \langle \pi_1, \pi_2 \rangle \text{ is a grade} \iff (\pi_2 = 0 \implies \pi_1 = 0) &&(\mathsf{syntax}_p)
\end{aligned}
```

A grade is written as its two multiplicities side by side, with the exponent $`\mathsf{p}`$, such as $`{01}^{\mathsf{p}}`$ for $`\langle 0, 1 \rangle`$; a grade whose multiplicities are variables keeps the angle brackets, as $`\langle \pi_1, \pi_2 \rangle`$, since $`\pi_1 \pi_2`$ would read as a product.

Each grade has a name in Sic, made of the names of its two multiplicities: `none`, `linear` and `unrestricted` for $`0`$, $`1`$ and $`\omega`$, except a run-time multiplicity $`\omega`$ under a total multiplicity $`1`$, named `affine` since it counts at most one use, in the order of their multiplicities, $`0`$, $`1`$, then $`\omega`$:

| Name | Grade |
| --- | --- |
| `none / none` | $`{00}^{\mathsf{p}}`$ |
| `none / linear` | $`{01}^{\mathsf{p}}`$ |
| `none / unrestricted` | $`{0\omega}^{\mathsf{p}}`$ |
| `linear / linear` | $`{11}^{\mathsf{p}}`$ |
| `linear / unrestricted` | $`{1\omega}^{\mathsf{p}}`$ |
| `affine / linear` | $`{\omega 1}^{\mathsf{p}}`$ |
| `unrestricted / unrestricted` | $`{\omega\omega}^{\mathsf{p}}`$ |

The operations act on each multiplicity, and the seven grades are closed under them:

```math
\begin{aligned}
& \text{and} &&(\mathsf{op}_p) \\
& \quad \langle \pi_1, \pi_2 \rangle + \langle \pi_3, \pi_4 \rangle = \langle \pi_1 + \pi_3,\ \pi_2 + \pi_4 \rangle \\
& \quad \langle \pi_1, \pi_2 \rangle \cdot \langle \pi_3, \pi_4 \rangle = \langle \pi_1 \cdot \pi_3,\ \pi_2 \cdot \pi_4 \rangle \\
& \quad \langle \pi_1, \pi_2 \rangle \wedge \langle \pi_3, \pi_4 \rangle = \langle \pi_1 \wedge \pi_3,\ \pi_2 \wedge \pi_4 \rangle
\end{aligned}
```

The grades are ordered by their meet, which means that a variable of grade $`p`$ may be used where the grade $`q`$ is expected:

```math
\begin{aligned}
& p \le q \iff p = p \wedge q &&(\mathsf{order}_p)
\end{aligned}
```

It is the order of the multiplicities on each component:

```math
\begin{aligned}
& \langle \pi_1, \pi_2 \rangle \le \langle \pi_3, \pi_4 \rangle \iff \pi_1 \le \pi_3 \text{ and } \pi_2 \le \pi_4 &&(\mathsf{componentwise}_p)
\end{aligned}
```

The grades that allow discarding a variable are exactly those that allow duplicating it:

```math
\begin{aligned}
& \text{and} &&(\mathsf{discard}_p) \\
& \quad p \le {00}^{\mathsf{p}} \iff p \le p + p \\
& \quad p \le {00}^{\mathsf{p}} \iff p \in \{{00}^{\mathsf{p}},\ {0\omega}^{\mathsf{p}},\ {\omega\omega}^{\mathsf{p}}\}
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

This meaning chooses the seven grades among the nine pairs: $`\langle 1, 0 \rangle`$ allows no pair, since a use at run time is a use, and $`\langle \omega, 0 \rangle`$ allows only $`(0, 0)`$, as $`{00}^{\mathsf{p}}`$ does, while the seven grades allow non-empty sets of pairs, all different:

```math
\begin{aligned}
& \text{and} &&(\mathsf{excluded}_p) \\
& \quad \mathsf{uses}(\langle 1, 0 \rangle) = \varnothing \\
& \quad \mathsf{uses}(\langle \omega, 0 \rangle) = \mathsf{uses}({00}^{\mathsf{p}}) \\[1em]
& \text{and} &&(\mathsf{distinct}_p) \\
& \quad \mathsf{uses}(p) \ne \varnothing \\
& \quad \mathsf{uses}(p) = \mathsf{uses}(q) \implies p = q
\end{aligned}
```

The best grade for a set $`S`$ of pairs of numbers of uses is defined as for the multiplicities, and the operations and the order are again those of the numbers of uses, on each component:

```math
\begin{aligned}
& \text{⟺} &&(\mathsf{best}_p) \\
& \quad \mathsf{best}(S) = p \\
& \quad \text{and} \\
& \qquad S \subseteq \mathsf{uses}(p) \\
& \qquad \forall q.\ S \subseteq \mathsf{uses}(q) \implies \mathsf{uses}(p) \subseteq \mathsf{uses}(q) \\[1em]
& \mathsf{best}(S) = p \text{ and } \mathsf{best}(S) = q \implies p = q &&(\mathsf{unique}_p) \\[1em]
& {=} &&(+_p) \\
& \quad p + q \\
& \quad \mathsf{best}( \\
& \qquad \{(n_1 + n_3,\ n_2 + n_4) \mid (n_1, n_2) \in \mathsf{uses}(p), \\
& \qquad (n_3, n_4) \in \mathsf{uses}(q)\}) \\[1em]
& {=} &&(\cdot_p) \\
& \quad p \cdot q \\
& \quad \mathsf{best}( \\
& \qquad \{(n_1 \cdot n_3,\ n_2 \cdot n_4) \mid (n_1, n_2) \in \mathsf{uses}(p), \\
& \qquad (n_3, n_4) \in \mathsf{uses}(q)\}) \\[1em]
& p \wedge q = \mathsf{best}(\mathsf{uses}(p) \cup \mathsf{uses}(q)) &&(\wedge_p) \\[1em]
& p \le q \iff \mathsf{uses}(q) \subseteq \mathsf{uses}(p) &&(\le_p)
\end{aligned}
```

The projection on the run-time multiplicity is sound for the first components of the pairs, but not exact: $`{\omega 1}^{\mathsf{p}}`$ allows $`0`$ and $`1`$ uses at run time, which only $`\omega`$ allows among the multiplicities, and $`\omega`$ allows $`2`$:

```math
\begin{aligned}
& \{n_1 \mid (n_1, n_2) \in \mathsf{uses}(p)\} \subseteq \mathsf{uses}(\mathsf{run}(p)) &&(\mathsf{sound}_{\mathsf{run}}) \\[1em]
& \text{and} &&(\mathsf{inexact}_{\mathsf{run}}) \\
& \quad 2 \in \mathsf{uses}(\mathsf{run}({\omega 1}^{\mathsf{p}})) \\
& \quad 2 \notin \{n_1 \mid (n_1, n_2) \in \mathsf{uses}({\omega 1}^{\mathsf{p}})\}
\end{aligned}
```

## Properties

The properties of the grades are those of a modality and of its greatest lower bounds.

### Modality

The seven grades form a modality of [Abel, Danielsson and Eriksson](https://doi.org/10.1145/3607862), as the multiplicities do:

```math
\begin{aligned}
& \text{and} &&(\mathsf{semiring}_p) \\
& \quad (p + q) + r = p + (q + r) \\
& \quad p + q = q + p \\
& \quad {00}^{\mathsf{p}} + p = p \\
& \quad (p \cdot q) \cdot r = p \cdot (q \cdot r) \\
& \quad {11}^{\mathsf{p}} \cdot p = p \cdot {11}^{\mathsf{p}} = p \\
& \quad {00}^{\mathsf{p}} \cdot p = p \cdot {00}^{\mathsf{p}} = {00}^{\mathsf{p}} \\[1em]
& \text{and} &&(\mathsf{meet}_p) \\
& \quad (p \wedge q) \wedge r = p \wedge (q \wedge r) \\
& \quad p \wedge q = q \wedge p \\
& \quad p \wedge p = p \\[1em]
& \text{and} &&({\cdot}{+}_p) \\
& \quad p \cdot (q + r) = (p \cdot q) + (p \cdot r) \\
& \quad (q + r) \cdot p = (q \cdot p) + (r \cdot p) \\[1em]
& \text{and} &&({\cdot}{\wedge}_p) \\
& \quad p \cdot (q \wedge r) = (p \cdot q) \wedge (p \cdot r) \\
& \quad (q \wedge r) \cdot p = (q \cdot p) \wedge (r \cdot p) \\[1em]
& \text{and} &&({+}{\wedge}_p) \\
& \quad p + (q \wedge r) = (p + q) \wedge (p + r) \\
& \quad (q \wedge r) + p = (q + p) \wedge (r + p) \\[1em]
& p \le q \implies p + r \le q + r &&({+}{\le}_p) \\[1em]
& r \le p \text{ and } r \le q \iff r \le p \wedge q &&({\wedge}{\le}_p) \\[1em]
& \text{and} &&(0_p) \\
& \quad {00}^{\mathsf{p}} \ne {11}^{\mathsf{p}} \\
& \quad p + q = {00}^{\mathsf{p}} \implies p = {00}^{\mathsf{p}} \text{ and } q = {00}^{\mathsf{p}} \\
& \quad p \wedge q = {00}^{\mathsf{p}} \implies p = {00}^{\mathsf{p}} \text{ and } q = {00}^{\mathsf{p}} \\
& \quad p \cdot q = {00}^{\mathsf{p}} \implies p = {00}^{\mathsf{p}} \text{ or } q = {00}^{\mathsf{p}}
\end{aligned}
```

### Greatest Lower Bounds

Every non-empty set $`S`$ of grades has a greatest lower bound $`\bigwedge S`$:

```math
\begin{aligned}
& \text{and} &&(\textstyle\bigwedge_p) \\
& \quad \forall p \in S.\ \textstyle\bigwedge S \le p \\
& \quad (\forall p \in S.\ r \le p) \implies r \le \textstyle\bigwedge S
\end{aligned}
```

For all families $`(p_i)_{i \in I}`$ and $`(q_i)_{i \in I}`$ of grades indexed by a non-empty set $`I`$, the greatest lower bound is superadditive, and the multiplication by a grade commutes with it, as [Eriksson, Abel and Danielsson](https://doi.org/10.1145/3828677) require of well-behaved greatest lower bounds:

```math
\begin{aligned}
& \textstyle\bigwedge_{i \in I} p_i + \bigwedge_{i \in I} q_i \le \bigwedge_{i \in I} (p_i + q_i) &&(\textstyle\bigwedge{+}_p) \\[1em]
& r \cdot \textstyle\bigwedge_{i \in I} p_i = \bigwedge_{i \in I} (r \cdot p_i) &&(\textstyle\bigwedge{\cdot}_p)
\end{aligned}
```
