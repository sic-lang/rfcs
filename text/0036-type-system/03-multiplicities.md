# Multiplicities

This annex defines the multiplicities, which count uses, with their operations, their order, their meaning and their properties.
It builds on the [modalities](02-modalities.md).

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
& 0 + \pi = \pi &&(\mathsf{op}_\pi.{+}) \\
& \pi + 0 = \pi \\
& \pi_1 + \pi_2 = \omega \text{ otherwise} \\[1em]
& 0 \cdot \pi = 0 &&(\mathsf{op}_\pi.{\cdot}) \\
& \pi \cdot 0 = 0 \\
& 1 \cdot \pi = \pi \\
& \pi \cdot 1 = \pi \\
& \omega \cdot \omega = \omega \\[1em]
& 0 \wedge 0 = 0 &&(\mathsf{op}_\pi.{\wedge}) \\
& 1 \wedge 1 = 1 \\
& \pi_1 \wedge \pi_2 = \omega \text{ otherwise}
\end{aligned}
```

The same operations as tables, whose rows give the left operand:

```math
\begin{aligned}
& \begin{array}{c|ccc}
  + & 0 & 1 & \omega \\ \hline
  0 & 0 & 1 & \omega \\
  1 & 1 & \omega & \omega \\
  \omega & \omega & \omega & \omega
\end{array} &&(\mathsf{table}_\pi.{+}) \\[1em]
& \begin{array}{c|ccc}
  \cdot & 0 & 1 & \omega \\ \hline
  0 & 0 & 0 & 0 \\
  1 & 0 & 1 & \omega \\
  \omega & 0 & \omega & \omega
\end{array} &&(\mathsf{table}_\pi.{\cdot}) \\[1em]
& \begin{array}{c|ccc}
  \wedge & 0 & 1 & \omega \\ \hline
  0 & 0 & \omega & \omega \\
  1 & \omega & 1 & \omega \\
  \omega & \omega & \omega & \omega
\end{array} &&(\mathsf{table}_\pi.{\wedge})
\end{aligned}
```

The multiplicities are ordered by their meet, as the modality that they form, $`(\mathsf{order}_\xi)`$.
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
& \mathsf{uses}(0) = \{0\} &&(\mathsf{uses}_\pi) \\
& \mathsf{uses}(1) = \{1\} \\
& \mathsf{uses}(\omega) = \mathbb{N}
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

The multiplicities form a [modality](02-modalities.md), whose laws and properties they have:

```math
\begin{aligned}
& \text{the multiplicities, with } 0,\ 1,\ +,\ \cdot,\ \wedge, \text{ form a modality} &&(\mathsf{modality}_\pi)
\end{aligned}
```
