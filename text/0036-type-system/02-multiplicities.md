# Multiplicities

This annex defines the multiplicities, which count the uses of a variable, with their operations, their order, their meaning and their properties.
It builds on the [notation](01-notation.md).

## Definitions

A multiplicity is $`0`$, $`1`$ or $`\omega`$, where $`\omega`$ stands for any number of uses, none included, as in the linear modality of [Abel, Danielsson and Eriksson](https://doi.org/10.1145/3607862).
The multiplicities are added, multiplied and met by the following tables, whose rows give the left operand:

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

The multiplicities are ordered by their meet: $`\pi_1 \le \pi_2`$ when $`\pi_1 = \pi_1 \wedge \pi_2`$.
A variable of multiplicity $`\omega`$ may then be used where any multiplicity is expected, while $`0`$ and $`1`$ are not comparable:

```math
\begin{aligned}
& \text{and} &&(\mathsf{order}_\pi) \\
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
& \text{and} &&(\mathsf{semiring}_\pi) \\
& \quad (\pi_1 + \pi_2) + \pi_3 = \pi_1 + (\pi_2 + \pi_3) \\
& \quad \pi_1 + \pi_2 = \pi_2 + \pi_1 \\
& \quad 0 + \pi = \pi \\
& \quad (\pi_1 \cdot \pi_2) \cdot \pi_3 = \pi_1 \cdot (\pi_2 \cdot \pi_3) \\
& \quad 1 \cdot \pi = \pi \cdot 1 = \pi \\
& \quad 0 \cdot \pi = \pi \cdot 0 = 0 \\[1em]
& \text{and} &&(\mathsf{meet}_\pi) \\
& \quad (\pi_1 \wedge \pi_2) \wedge \pi_3 = \pi_1 \wedge (\pi_2 \wedge \pi_3) \\
& \quad \pi_1 \wedge \pi_2 = \pi_2 \wedge \pi_1 \\
& \quad \pi \wedge \pi = \pi \\[1em]
& \text{and} &&({\cdot}{+}_\pi) \\
& \quad \pi_1 \cdot (\pi_2 + \pi_3) = (\pi_1 \cdot \pi_2) + (\pi_1 \cdot \pi_3) \\
& \quad (\pi_2 + \pi_3) \cdot \pi_1 = (\pi_2 \cdot \pi_1) + (\pi_3 \cdot \pi_1) \\[1em]
& \text{and} &&({\cdot}{\wedge}_\pi) \\
& \quad \pi_1 \cdot (\pi_2 \wedge \pi_3) = (\pi_1 \cdot \pi_2) \wedge (\pi_1 \cdot \pi_3) \\
& \quad (\pi_2 \wedge \pi_3) \cdot \pi_1 = (\pi_2 \cdot \pi_1) \wedge (\pi_3 \cdot \pi_1) \\[1em]
& \text{and} &&({+}{\wedge}_\pi) \\
& \quad \pi_1 + (\pi_2 \wedge \pi_3) = (\pi_1 + \pi_2) \wedge (\pi_1 + \pi_3) \\
& \quad (\pi_2 \wedge \pi_3) + \pi_1 = (\pi_2 + \pi_1) \wedge (\pi_3 + \pi_1) \\[1em]
& \pi_1 \le \pi_2 \implies \pi_1 + \pi_3 \le \pi_2 + \pi_3 &&({+}{\le}_\pi) \\[1em]
& \pi_3 \le \pi_1 \text{ and } \pi_3 \le \pi_2 \iff \pi_3 \le \pi_1 \wedge \pi_2 &&({\wedge}{\le}_\pi) \\[1em]
& \text{and} &&(0_\pi) \\
& \quad 0 \ne 1 \\
& \quad \pi_1 + \pi_2 = 0 \implies \pi_1 = 0 \text{ and } \pi_2 = 0 \\
& \quad \pi_1 \wedge \pi_2 = 0 \implies \pi_1 = 0 \text{ and } \pi_2 = 0 \\
& \quad \pi_1 \cdot \pi_2 = 0 \implies \pi_1 = 0 \text{ or } \pi_2 = 0
\end{aligned}
```
