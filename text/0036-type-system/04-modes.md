# Modes

This annex defines the modes, the settings in which the usage of a term is checked, with their structure on the grades.
It builds on the [grades](03-grades.md).

## Definitions

The type system has three modes, each named after its grade $`\ulcorner m \urcorner`$, with which a variable checked in the mode $`m`$ uses itself:

```math
\begin{aligned}
& m \mathrel{::=} {00}^{\mathsf{m}} \mid {01}^{\mathsf{m}} \mid {11}^{\mathsf{m}} &&(\mathsf{syntax}_m) \\[1em]
& \text{and} &&(\mathsf{grade}_m) \\
& \quad \ulcorner {00}^{\mathsf{m}} \urcorner = {00}^{\mathsf{p}} \\
& \quad \ulcorner {01}^{\mathsf{m}} \urcorner = {01}^{\mathsf{p}} \\
& \quad \ulcorner {11}^{\mathsf{m}} \urcorner = {11}^{\mathsf{p}}
\end{aligned}
```

Each mode counts the uses as follows:

| Mode | Grade | Counts |
| --- | --- | --- |
| $`{00}^{\mathsf{m}}`$ | $`{00}^{\mathsf{p}}`$ | no use |
| $`{01}^{\mathsf{m}}`$ | $`{01}^{\mathsf{p}}`$ | all the uses, none at run time |
| $`{11}^{\mathsf{m}}`$ | $`{11}^{\mathsf{p}}`$ | all the uses and the uses at run time |

A term used with the grade $`p`$ is checked in the mode $`\llcorner p \lrcorner`$ of this grade:

```math
\begin{aligned}
& \text{and} &&(\mathsf{mode}_p) \\
& \quad \llcorner {00}^{\mathsf{p}} \lrcorner = {00}^{\mathsf{m}} \\
& \quad \llcorner \langle 0, \pi \rangle \lrcorner = {01}^{\mathsf{m}} \text{ if } \pi \ne 0 \\
& \quad \llcorner \langle \pi_1, \pi_2 \rangle \lrcorner = {11}^{\mathsf{m}} \text{ if } \pi_1 \ne 0
\end{aligned}
```

The product of two modes is the mode of the product of their grades, and, inside a term checked in the mode $`m`$, a subterm used with the grade $`p`$ is checked in the mode $`m \odot p`$:

```math
\begin{aligned}
& \text{and} &&(\mathsf{product}_m) \\
& \quad m_1 \cdot^{\mathsf{m}} m_2 = \llcorner \ulcorner m_1 \urcorner \cdot \ulcorner m_2 \urcorner \lrcorner \\
& \quad m \odot p = m \cdot^{\mathsf{m}} \llcorner p \lrcorner
\end{aligned}
```

The product of two modes is the more erased of the two:

```math
\begin{aligned}
& \text{and} &&(\mathsf{erased}_m) \\
& \quad m_1 \cdot^{\mathsf{m}} m_2 = {00}^{\mathsf{m}} \text{ if } m_1 = {00}^{\mathsf{m}} \text{ or } m_2 = {00}^{\mathsf{m}} \\
& \quad m_1 \cdot^{\mathsf{m}} m_2 = {01}^{\mathsf{m}} \text{ if } {00}^{\mathsf{m}} \notin \{m_1, m_2\} \text{ and } {01}^{\mathsf{m}} \in \{m_1, m_2\} \\
& \quad m_1 \cdot^{\mathsf{m}} m_2 = {11}^{\mathsf{m}} \text{ if } m_1 = m_2 = {11}^{\mathsf{m}}
\end{aligned}
```

## Properties

The three modes form a mode structure of the [formalization](https://github.com/graded-type-theory/graded-type-theory) of Abel, Danielsson and Eriksson over the grades, in which the grade of a product of modes is the product of their grades, and the mode of a sum or of a meet of grades is no more erased than the mode of each of them:

```math
\begin{aligned}
& (m_1 \cdot^{\mathsf{m}} m_2) \cdot^{\mathsf{m}} m_3 = m_1 \cdot^{\mathsf{m}} (m_2 \cdot^{\mathsf{m}} m_3) &&(\mathsf{structure}_m.\mathsf{assoc}) \\[1em]
& m_1 \cdot^{\mathsf{m}} m_2 = m_2 \cdot^{\mathsf{m}} m_1 &&(\mathsf{structure}_m.\mathsf{comm}) \\[1em]
& m \cdot^{\mathsf{m}} m = m &&(\mathsf{structure}_m.\mathsf{idem}) \\[1em]
& {11}^{\mathsf{m}} \cdot^{\mathsf{m}} m = m &&(\mathsf{structure}_m.\mathsf{unit}) \\[1em]
& {00}^{\mathsf{m}} \cdot^{\mathsf{m}} m = {00}^{\mathsf{m}} &&(\mathsf{structure}_m.\mathsf{zero}) \\[1em]
& \ulcorner {00}^{\mathsf{m}} \urcorner = {00}^{\mathsf{p}} &&(\mathsf{structure}_m.\mathsf{grade}_{00}) \\[1em]
& \llcorner \ulcorner m \urcorner \lrcorner = m &&(\mathsf{structure}_m.\mathsf{section}) \\[1em]
& \ulcorner m_1 \cdot^{\mathsf{m}} m_2 \urcorner = \ulcorner m_1 \urcorner \cdot \ulcorner m_2 \urcorner &&(\mathsf{structure}_m.\mathsf{grade}_{\cdot}) \\[1em]
& \llcorner p \lrcorner \cdot^{\mathsf{m}} \llcorner q \lrcorner = \llcorner p \cdot q \lrcorner &&(\mathsf{structure}_m.\mathsf{mode}_{\cdot}) \\[1em]
& p \cdot \ulcorner \llcorner p \lrcorner \urcorner = p &&(\mathsf{structure}_m.\mathsf{runit}) \\[1em]
& \ulcorner \llcorner p \lrcorner \urcorner \cdot p = p &&(\mathsf{structure}_m.\mathsf{lunit}) \\[1em]
& p \le q \text{ and } q \le \ulcorner m \urcorner \cdot q \implies p \le \ulcorner m \urcorner \cdot p &&(\mathsf{structure}_m.\mathsf{order}) \\[1em]
& \llcorner p \lrcorner \cdot^{\mathsf{m}} \llcorner p + q \lrcorner = \llcorner p \lrcorner &&(\mathsf{structure}_m.\mathsf{mode}_{+}) \\[1em]
& \llcorner p \lrcorner \cdot^{\mathsf{m}} \llcorner p \wedge q \lrcorner = \llcorner p \lrcorner &&(\mathsf{structure}_m.\mathsf{mode}_{\wedge})
\end{aligned}
```
