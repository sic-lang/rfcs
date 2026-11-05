# Modes

This annex defines the modes, the settings in which the usage of a term is checked, with their structure on the grades.
It builds on the [grades](03-grades.md).

## Definitions

The type system has three modes, each named after its grade $`\ulcorner m \urcorner`$, with which a variable checked in the mode $`m`$ uses itself:

| Mode | Grade | Counts |
| --- | --- | --- |
| $`{00}^{\mathsf{m}}`$ | $`{00}^{\mathsf{g}}`$ | no use |
| $`{01}^{\mathsf{m}}`$ | $`{01}^{\mathsf{g}}`$ | all the uses, none at run time |
| $`{11}^{\mathsf{m}}`$ | $`{11}^{\mathsf{g}}`$ | all the uses and the uses at run time |

A term used with the grade $`p`$ is checked in the mode $`\llcorner p \lrcorner`$ of this grade:

```math
\begin{aligned}
& \text{and} &&(\mathsf{mode}_p) \\
& \quad \llcorner {00}^{\mathsf{g}} \lrcorner = {00}^{\mathsf{m}} \\
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

The grades of the three modes are closed under multiplication, so that the grade of a product is the product of the grades, and the product of two modes is the more erased of the two:

```math
\begin{aligned}
& \ulcorner m_1 \cdot^{\mathsf{m}} m_2 \urcorner = \ulcorner m_1 \urcorner \cdot \ulcorner m_2 \urcorner &&(\mathsf{closed}_m) \\[1em]
& \text{and} &&(\mathsf{erased}_m) \\
& \quad m_1 \cdot^{\mathsf{m}} m_2 = {00}^{\mathsf{m}} \text{ if } m_1 = {00}^{\mathsf{m}} \text{ or } m_2 = {00}^{\mathsf{m}} \\
& \quad m_1 \cdot^{\mathsf{m}} m_2 = {01}^{\mathsf{m}} \text{ if } {00}^{\mathsf{m}} \notin \{m_1, m_2\} \text{ and } {01}^{\mathsf{m}} \in \{m_1, m_2\} \\
& \quad m_1 \cdot^{\mathsf{m}} m_2 = {11}^{\mathsf{m}} \text{ if } m_1 = m_2 = {11}^{\mathsf{m}}
\end{aligned}
```

## Properties

The three modes form a mode structure of the [formalization](https://github.com/graded-type-theory/graded-type-theory) of Abel, Danielsson and Eriksson over the grades:

```math
\begin{aligned}
& \text{and} &&(\mathsf{structure}_m) \\
& \quad (m_1 \cdot^{\mathsf{m}} m_2) \cdot^{\mathsf{m}} m_3 = m_1 \cdot^{\mathsf{m}} (m_2 \cdot^{\mathsf{m}} m_3) \\
& \quad m_1 \cdot^{\mathsf{m}} m_2 = m_2 \cdot^{\mathsf{m}} m_1 \\
& \quad m \cdot^{\mathsf{m}} m = m \\
& \quad {11}^{\mathsf{m}} \cdot^{\mathsf{m}} m = m \\
& \quad {00}^{\mathsf{m}} \cdot^{\mathsf{m}} m = {00}^{\mathsf{m}} \\
& \quad \ulcorner {00}^{\mathsf{m}} \urcorner = {00}^{\mathsf{g}} \\
& \quad \llcorner \ulcorner m \urcorner \lrcorner = m \\
& \quad \llcorner p \lrcorner \cdot^{\mathsf{m}} \llcorner q \lrcorner = \llcorner p \cdot q \lrcorner \\
& \quad p \cdot \ulcorner \llcorner p \lrcorner \urcorner = \ulcorner \llcorner p \lrcorner \urcorner \cdot p = p \\
& \quad p \le q \text{ and } q \le \ulcorner m \urcorner \cdot q \implies p \le \ulcorner m \urcorner \cdot p
\end{aligned}
```
