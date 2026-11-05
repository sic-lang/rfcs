# Modes

This annex defines the modes, the settings in which the usage of a term is checked, with their structure on the grades, the two modes of Abel, Danielsson and Eriksson on the multiplicities, and the projection of the former on the latter.
It builds on the [grades](03-grades.md).

## Definitions

The type system has three modes, each named after its grade $`\ulcorner m \urcorner`$, with which a variable checked in the mode $`m`$ uses itself:

| Mode | Grade | Counts |
| --- | --- | --- |
| $`\mathbb{0}\mathbb{0}^{\mathsf{m}}`$ | $`\mathbb{0}`$ | no use |
| $`\mathbb{0}\mathbb{1}^{\mathsf{m}}`$ | $`\langle 0, 1 \rangle`$ | all the uses, none at run time |
| $`\mathbb{1}\mathbb{1}^{\mathsf{m}}`$ | $`\mathbb{1}`$ | all the uses and the uses at run time |

A term used with the grade $`p`$ is checked in the mode $`\llcorner p \lrcorner`$ of this grade:

```math
\begin{aligned}
& \text{and} &&(\mathsf{mode}_p) \\
& \quad \llcorner \mathbb{0} \lrcorner = \mathbb{0}\mathbb{0}^{\mathsf{m}} \\
& \quad \llcorner \langle 0, \pi \rangle \lrcorner = \mathbb{0}\mathbb{1}^{\mathsf{m}} \text{ if } \pi \ne 0 \\
& \quad \llcorner \langle \pi_1, \pi_2 \rangle \lrcorner = \mathbb{1}\mathbb{1}^{\mathsf{m}} \text{ if } \pi_1 \ne 0
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
& \ulcorner m_1 \cdot^{\mathsf{m}} m_2 \urcorner = \ulcorner m_1 \urcorner \cdot \ulcorner m_2 \urcorner &&(\mathsf{closed}_m) \\
& \text{and} &&(\mathsf{erased}_m) \\
& \quad m_1 \cdot^{\mathsf{m}} m_2 = \mathbb{0}\mathbb{0}^{\mathsf{m}} \text{ if } m_1 = \mathbb{0}\mathbb{0}^{\mathsf{m}} \text{ or } m_2 = \mathbb{0}\mathbb{0}^{\mathsf{m}} \\
& \quad m_1 \cdot^{\mathsf{m}} m_2 = \mathbb{0}\mathbb{1}^{\mathsf{m}} \text{ if } \mathbb{0}\mathbb{0}^{\mathsf{m}} \notin \{m_1, m_2\} \text{ and } \mathbb{0}\mathbb{1}^{\mathsf{m}} \in \{m_1, m_2\} \\
& \quad m_1 \cdot^{\mathsf{m}} m_2 = \mathbb{1}\mathbb{1}^{\mathsf{m}} \text{ if } m_1 = m_2 = \mathbb{1}\mathbb{1}^{\mathsf{m}}
\end{aligned}
```

### Modes of Abel, Danielsson and Eriksson

The graded type theory of [Abel, Danielsson and Eriksson](https://doi.org/10.1145/3607862) has two modes, $`\mathbb{0}^{\mathsf{m}}`$ and $`\mathbb{1}^{\mathsf{m}}`$, which have on the multiplicities the structure that the three modes have on the grades, written alike:

| Mode | Multiplicity | Counts |
| --- | --- | --- |
| $`\mathbb{0}^{\mathsf{m}}`$ | $`0`$ | no use |
| $`\mathbb{1}^{\mathsf{m}}`$ | $`1`$ | the uses |

```math
\begin{aligned}
& \text{and} &&(\mathsf{mode}_\pi) \\
& \quad \llcorner 0 \lrcorner = \mathbb{0}^{\mathsf{m}} \\
& \quad \llcorner \pi \lrcorner = \mathbb{1}^{\mathsf{m}} \text{ if } \pi \ne 0 \\
& \text{and} &&(\mathsf{product}_\pi) \\
& \quad m_1 \cdot^{\mathsf{m}} m_2 = \llcorner \ulcorner m_1 \urcorner \cdot \ulcorner m_2 \urcorner \lrcorner \\
& \quad m \odot \pi = m \cdot^{\mathsf{m}} \llcorner \pi \lrcorner \\
& \ulcorner m_1 \cdot^{\mathsf{m}} m_2 \urcorner = \ulcorner m_1 \urcorner \cdot \ulcorner m_2 \urcorner &&(\mathsf{closed}_\pi)
\end{aligned}
```

The three modes project on these two as the grades project on their run-time multiplicity, the two erased modes on $`\mathbb{0}^{\mathsf{m}}`$ and the mode of run time on $`\mathbb{1}^{\mathsf{m}}`$:

```math
\begin{aligned}
& \text{and} &&(\mathsf{run}_m) \\
& \quad \mathsf{run}(\mathbb{0}\mathbb{0}^{\mathsf{m}}) = \mathbb{0}^{\mathsf{m}} \\
& \quad \mathsf{run}(\mathbb{0}\mathbb{1}^{\mathsf{m}}) = \mathbb{0}^{\mathsf{m}} \\
& \quad \mathsf{run}(\mathbb{1}\mathbb{1}^{\mathsf{m}}) = \mathbb{1}^{\mathsf{m}}
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
& \quad \mathbb{1}\mathbb{1}^{\mathsf{m}} \cdot^{\mathsf{m}} m = m \\
& \quad \mathbb{0}\mathbb{0}^{\mathsf{m}} \cdot^{\mathsf{m}} m = \mathbb{0}\mathbb{0}^{\mathsf{m}} \\
& \quad \ulcorner \mathbb{0}\mathbb{0}^{\mathsf{m}} \urcorner = \mathbb{0} \\
& \quad \llcorner \ulcorner m \urcorner \lrcorner = m \\
& \quad \llcorner p \lrcorner \cdot^{\mathsf{m}} \llcorner q \lrcorner = \llcorner p \cdot q \lrcorner \\
& \quad p \cdot \ulcorner \llcorner p \lrcorner \urcorner = \ulcorner \llcorner p \lrcorner \urcorner \cdot p = p \\
& \quad p \le q \text{ and } q \le \ulcorner m \urcorner \cdot q \implies p \le \ulcorner m \urcorner \cdot p
\end{aligned}
```

The projection is a homomorphism of mode structures: it commutes with the mode of a grade, with the grade of a mode and with the product of a mode by a grade, the structure on the right being that of the two modes on the multiplicities:

```math
\begin{aligned}
& \text{and} &&(\mathsf{run}_{\odot}) \\
& \quad \mathsf{run}(\llcorner p \lrcorner) = \llcorner \mathsf{run}(p) \lrcorner \\
& \quad \ulcorner \mathsf{run}(m) \urcorner = \mathsf{run}(\ulcorner m \urcorner) \\
& \quad \mathsf{run}(m \odot p) = \mathsf{run}(m) \odot \mathsf{run}(p)
\end{aligned}
```
