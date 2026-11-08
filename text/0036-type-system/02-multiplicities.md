# Multiplicities

This annex defines the multiplicities, which count uses, with their operations, their order, their meaning and their properties.
It builds on the [notation](01-notation.md).

## Definitions

A use is an access to a value through a variable.

A multiplicity is $`0`$, $`1`$ or $`\omega`$, where $`\omega`$ stands for any number of uses, none included, as in the linear modality of [Abel, Danielsson and Eriksson](https://doi.org/10.1145/3607862):

```math
\begin{aligned}
& \pi \mathrel{::=} 0 \mid 1 \mid \omega &&(\mathsf{syntax}_\pi)
\end{aligned}
```

The multiplicities are added, multiplied and met by cases, $`0`$ being neutral for the addition and absorbing for the multiplication, $`1`$ neutral for the multiplication, and $`\omega`$ the result of every other case:

```math
\begin{aligned}
& \text{and} &&(\mathsf{op}_\pi) \\
& \quad 0 + \pi = \pi \\
& \quad \pi + 0 = \pi \\
& \quad \pi_1 + \pi_2 = \omega \text{ if } \pi_1 \ne 0 \text{ and } \pi_2 \ne 0 \\
& \quad 0 \cdot \pi = \pi \cdot 0 = 0 \\
& \quad 1 \cdot \pi = \pi \cdot 1 = \pi \\
& \quad \omega \cdot \omega = \omega \\
& \quad 0 \wedge 0 = 0 \\
& \quad 1 \wedge 1 = 1 \\
& \quad \pi_1 \wedge \pi_2 = \omega \text{ if } \pi_1 \ne \pi_2 \text{ or } \pi_1 = \omega
\end{aligned}
```

The same operations as tables, whose rows give the left operand:

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

The multiplicities are ordered by their meet:

```math
\begin{aligned}
& \pi_1 \le \pi_2 \iff \pi_1 = \pi_1 \wedge \pi_2 &&(\mathsf{order}_\pi)
\end{aligned}
```

A lower multiplicity allows more numbers of uses, and so states less about them, as their meaning shows: $`\omega`$ is below every multiplicity, while $`0`$ and $`1`$ are not comparable:

```math
\begin{aligned}
& \text{and} &&(\mathsf{compare}_\pi) \\
& \quad \omega \le 0 \\
& \quad \omega \le 1 \\
& \quad 0 \not\le 1 \\
& \quad 1 \not\le 0
\end{aligned}
```

## Meaning

The multiplicities are an [abstract interpretation](https://doi.org/10.1145/512950.512973) of the numbers of uses, in the sense of Cousot and Cousot: each stands for the numbers of uses it allows, and each operation is the [best abstraction](https://doi.org/10.1145/567752.567778) of the same operation on the numbers.
The order is the reverse inclusion, so that a lower multiplicity allows more numbers of uses, the reverse of the usual order of abstract interpretation.

```math
\begin{aligned}
& \text{and} &&(\mathsf{uses}_\pi) \\
& \quad \mathsf{uses}(0) = \{0\} \\
& \quad \mathsf{uses}(1) = \{1\} \\
& \quad \mathsf{uses}(\omega) = \mathbb{N}
\end{aligned}
```

The best multiplicity for a set $`S`$ of numbers of uses allows all of them, and allows the fewest numbers among the multiplicities that do; there is at most one:

```math
\begin{aligned}
& \text{⟺} &&(\mathsf{best}_\pi) \\
& \quad \mathsf{best}(S) = \pi_1 \\
& \quad \text{and} \\
& \qquad S \subseteq \mathsf{uses}(\pi_1) \\
& \qquad \forall \pi_2.\ S \subseteq \mathsf{uses}(\pi_2) \implies \mathsf{uses}(\pi_1) \subseteq \mathsf{uses}(\pi_2) \\[1em]
& \mathsf{best}(S) = \pi_1 \text{ and } \mathsf{best}(S) = \pi_2 \implies \pi_1 = \pi_2 &&(\mathsf{unique}_\pi)
\end{aligned}
```

The empty set has no best multiplicity, since $`0`$ and $`1`$ both allow its elements and neither allows fewer numbers than the other, but no operation needs it.
The operations and the order are those of the numbers of uses:

```math
\begin{aligned}
& \pi_1 + \pi_2 = \mathsf{best}(\{n_1 + n_2 \mid n_1 \in \mathsf{uses}(\pi_1),\ n_2 \in \mathsf{uses}(\pi_2)\}) &&(+_\pi) \\[1em]
& \pi_1 \cdot \pi_2 = \mathsf{best}(\{n_1 \cdot n_2 \mid n_1 \in \mathsf{uses}(\pi_1),\ n_2 \in \mathsf{uses}(\pi_2)\}) &&(\cdot_\pi) \\[1em]
& \pi_1 \wedge \pi_2 = \mathsf{best}(\mathsf{uses}(\pi_1) \cup \mathsf{uses}(\pi_2)) &&(\wedge_\pi) \\[1em]
& \pi_1 \le \pi_2 \iff \mathsf{uses}(\pi_2) \subseteq \mathsf{uses}(\pi_1) &&(\le_\pi)
\end{aligned}
```

## Properties

The multiplicities form a modality of [Abel, Danielsson and Eriksson](https://doi.org/10.1145/3607862): a semiring whose addition and multiplication distribute over its meet, ordered by its meet, with a well-behaved zero.

```math
\begin{aligned}
& (\pi_1 + \pi_2) + \pi_3 = \pi_1 + (\pi_2 + \pi_3) &&(\mathsf{semiring}_\pi.\mathsf{assoc}_{+}) \\[1em]
& \pi_1 + \pi_2 = \pi_2 + \pi_1 &&(\mathsf{semiring}_\pi.\mathsf{comm}_{+}) \\[1em]
& 0 + \pi = \pi &&(\mathsf{semiring}_\pi.\mathsf{unit}_{+}) \\[1em]
& (\pi_1 \cdot \pi_2) \cdot \pi_3 = \pi_1 \cdot (\pi_2 \cdot \pi_3) &&(\mathsf{semiring}_\pi.\mathsf{assoc}_{\cdot}) \\[1em]
& 1 \cdot \pi = \pi &&(\mathsf{semiring}_\pi.\mathsf{lunit}_{\cdot}) \\[1em]
& \pi \cdot 1 = \pi &&(\mathsf{semiring}_\pi.\mathsf{runit}_{\cdot}) \\[1em]
& 0 \cdot \pi = 0 &&(\mathsf{semiring}_\pi.\mathsf{lzero}_{\cdot}) \\[1em]
& \pi \cdot 0 = 0 &&(\mathsf{semiring}_\pi.\mathsf{rzero}_{\cdot}) \\[1em]
& (\pi_1 \wedge \pi_2) \wedge \pi_3 = \pi_1 \wedge (\pi_2 \wedge \pi_3) &&(\mathsf{meet}_\pi.\mathsf{assoc}) \\[1em]
& \pi_1 \wedge \pi_2 = \pi_2 \wedge \pi_1 &&(\mathsf{meet}_\pi.\mathsf{comm}) \\[1em]
& \pi \wedge \pi = \pi &&(\mathsf{meet}_\pi.\mathsf{idem}) \\[1em]
& \pi_1 \cdot (\pi_2 + \pi_3) = (\pi_1 \cdot \pi_2) + (\pi_1 \cdot \pi_3) &&({\cdot}{+}_\pi.\mathsf{left}) \\[1em]
& (\pi_2 + \pi_3) \cdot \pi_1 = (\pi_2 \cdot \pi_1) + (\pi_3 \cdot \pi_1) &&({\cdot}{+}_\pi.\mathsf{right}) \\[1em]
& \pi_1 \cdot (\pi_2 \wedge \pi_3) = (\pi_1 \cdot \pi_2) \wedge (\pi_1 \cdot \pi_3) &&({\cdot}{\wedge}_\pi.\mathsf{left}) \\[1em]
& (\pi_2 \wedge \pi_3) \cdot \pi_1 = (\pi_2 \cdot \pi_1) \wedge (\pi_3 \cdot \pi_1) &&({\cdot}{\wedge}_\pi.\mathsf{right}) \\[1em]
& \pi_1 + (\pi_2 \wedge \pi_3) = (\pi_1 + \pi_2) \wedge (\pi_1 + \pi_3) &&({+}{\wedge}_\pi.\mathsf{left}) \\[1em]
& (\pi_2 \wedge \pi_3) + \pi_1 = (\pi_2 + \pi_1) \wedge (\pi_3 + \pi_1) &&({+}{\wedge}_\pi.\mathsf{right}) \\[1em]
& \pi_1 \le \pi_2 \implies \pi_1 + \pi_3 \le \pi_2 + \pi_3 &&({+}{\le}_\pi) \\[1em]
& \pi_3 \le \pi_1 \text{ and } \pi_3 \le \pi_2 \iff \pi_3 \le \pi_1 \wedge \pi_2 &&({\wedge}{\le}_\pi) \\[1em]
& 0 \ne 1 &&(0_\pi.1) \\[1em]
& \pi_1 + \pi_2 = 0 \implies \pi_1 = 0 \text{ and } \pi_2 = 0 &&(0_\pi.{+}) \\[1em]
& \pi_1 \wedge \pi_2 = 0 \implies \pi_1 = 0 \text{ and } \pi_2 = 0 &&(0_\pi.{\wedge}) \\[1em]
& \pi_1 \cdot \pi_2 = 0 \implies \pi_1 = 0 \text{ or } \pi_2 = 0 &&(0_\pi.{\cdot})
\end{aligned}
```
