# Modalities

This annex defines the modalities, the structures of the multiplicities and of the grades, with their order and the properties that follow from their laws.
It builds on the [notation](01-notation.md).

## Definitions

A modality $`\mathcal{M}`$, as [Abel, Danielsson and Eriksson](https://doi.org/10.1145/3607862) define it, is a set of elements $`\xi`$ with a zero $`0^{\xi}`$, a unit $`1^{\xi}`$, an addition $`+`$, a multiplication $`\cdot`$ and a meet $`\wedge`$, which form a semiring whose addition and multiplication distribute over the meet, with a well-behaved zero:

```math
\begin{aligned}
& (\xi_1 + \xi_2) + \xi_3 = \xi_1 + (\xi_2 + \xi_3) &&(\mathsf{semiring}_\xi.\mathsf{assoc}_{+}) \\[1em]
& \xi_1 + \xi_2 = \xi_2 + \xi_1 &&(\mathsf{semiring}_\xi.\mathsf{comm}_{+}) \\[1em]
& 0^{\xi} + \xi = \xi &&(\mathsf{semiring}_\xi.\mathsf{unit}_{+}) \\[1em]
& (\xi_1 \cdot \xi_2) \cdot \xi_3 = \xi_1 \cdot (\xi_2 \cdot \xi_3) &&(\mathsf{semiring}_\xi.\mathsf{assoc}_{\cdot}) \\[1em]
& 1^{\xi} \cdot \xi = \xi &&(\mathsf{semiring}_\xi.\mathsf{lunit}_{\cdot}) \\[1em]
& \xi \cdot 1^{\xi} = \xi &&(\mathsf{semiring}_\xi.\mathsf{runit}_{\cdot}) \\[1em]
& 0^{\xi} \cdot \xi = 0^{\xi} &&(\mathsf{semiring}_\xi.\mathsf{lzero}_{\cdot}) \\[1em]
& \xi \cdot 0^{\xi} = 0^{\xi} &&(\mathsf{semiring}_\xi.\mathsf{rzero}_{\cdot}) \\[1em]
& (\xi_1 \wedge \xi_2) \wedge \xi_3 = \xi_1 \wedge (\xi_2 \wedge \xi_3) &&(\mathsf{meet}_\xi.\mathsf{assoc}) \\[1em]
& \xi_1 \wedge \xi_2 = \xi_2 \wedge \xi_1 &&(\mathsf{meet}_\xi.\mathsf{comm}) \\[1em]
& \xi \wedge \xi = \xi &&(\mathsf{meet}_\xi.\mathsf{idem}) \\[1em]
& \xi_1 \cdot (\xi_2 + \xi_3) = (\xi_1 \cdot \xi_2) + (\xi_1 \cdot \xi_3) &&({\cdot}{+}_\xi.\mathsf{left}) \\[1em]
& (\xi_2 + \xi_3) \cdot \xi_1 = (\xi_2 \cdot \xi_1) + (\xi_3 \cdot \xi_1) &&({\cdot}{+}_\xi.\mathsf{right}) \\[1em]
& \xi_1 \cdot (\xi_2 \wedge \xi_3) = (\xi_1 \cdot \xi_2) \wedge (\xi_1 \cdot \xi_3) &&({\cdot}{\wedge}_\xi.\mathsf{left}) \\[1em]
& (\xi_2 \wedge \xi_3) \cdot \xi_1 = (\xi_2 \cdot \xi_1) \wedge (\xi_3 \cdot \xi_1) &&({\cdot}{\wedge}_\xi.\mathsf{right}) \\[1em]
& \xi_1 + (\xi_2 \wedge \xi_3) = (\xi_1 + \xi_2) \wedge (\xi_1 + \xi_3) &&({+}{\wedge}_\xi.\mathsf{left}) \\[1em]
& (\xi_2 \wedge \xi_3) + \xi_1 = (\xi_2 + \xi_1) \wedge (\xi_3 + \xi_1) &&({+}{\wedge}_\xi.\mathsf{right}) \\[1em]
& 0^{\xi} \ne 1^{\xi} &&(0_\xi.1) \\[1em]
& \xi_1 + \xi_2 = 0^{\xi} \implies \xi_1 = 0^{\xi} \text{ and } \xi_2 = 0^{\xi} &&(0_\xi.{+}) \\[1em]
& \xi_1 \wedge \xi_2 = 0^{\xi} \implies \xi_1 = 0^{\xi} \text{ and } \xi_2 = 0^{\xi} &&(0_\xi.{\wedge}) \\[1em]
& \xi_1 \cdot \xi_2 = 0^{\xi} \implies \xi_1 = 0^{\xi} \text{ or } \xi_2 = 0^{\xi} &&(0_\xi.{\cdot})
\end{aligned}
```

A modality is ordered by its meet:

```math
\begin{aligned}
& \xi_1 \le \xi_2 \iff \xi_1 = \xi_1 \wedge \xi_2 &&(\mathsf{order}_\xi)
\end{aligned}
```

## Properties

In every modality, the addition is monotone and the meet is the greatest lower bound of its operands:

```math
\begin{aligned}
& \xi_1 \le \xi_2 \implies \xi_1 + \xi_3 \le \xi_2 + \xi_3 &&({+}{\le}_\xi) \\[1em]
& \xi_3 \le \xi_1 \text{ and } \xi_3 \le \xi_2 \iff \xi_3 \le \xi_1 \wedge \xi_2 &&({\wedge}{\le}_\xi)
\end{aligned}
```
