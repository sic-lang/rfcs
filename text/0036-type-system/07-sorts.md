# Sorts

This annex defines the sorts, the universes whose elements are types or propositions, with their qualities, the join of their qualities, the relation by which a sort bounds another, and their properties.
It builds on the [levels](06-levels.md).

## Definitions

A sort $`\kappa`$ has a quality and a level: it is a universe $`U_l`$, whose elements are types, or a universe of propositions $`\Omega_l`$, whose elements are propositions.
The quality of a sort is $`U`$ or $`\Omega`$, as the sort qualities of [Rocq](https://rocq-prover.org/doc/master/refman/addendum/universe-polymorphism.html), and a sort variable $`s`$ stands for a quality, so that $`s_l`$ stands for $`U_l`$ or $`\Omega_l`$:

```math
\begin{aligned}
& s \mathrel{::=} U \mid \Omega &&(\mathsf{syntax}_s) \\[1em]
& \kappa \mathrel{::=} s_l &&(\mathsf{syntax}_\kappa)
\end{aligned}
```

The qualities are ordered by the propositions they hold, $`\Omega`$ below $`U`$, and the join of two qualities is $`\Omega`$ when both are, and $`U`$ otherwise:

```math
\begin{aligned}
& s_1 \le s_2 \iff (s_2 = \Omega \implies s_1 = \Omega) &&(\le_s) \\[1em]
& \Omega \sqcup \Omega = \Omega &&(\sqcup_s) \\
& U \sqcup s = U \\
& s \sqcup U = U
\end{aligned}
```

A join of sort variables stands for the join of the qualities that they stand for.

A sort $`\kappa_2`$ bounds a sort $`\kappa_1`$, written $`\kappa_1 \preceq \kappa_2`$, when the level of $`\kappa_1`$ is below that of $`\kappa_2`$ and the quality of $`\kappa_1`$ below that of $`\kappa_2`$, so that a universe of propositions bounds only universes of propositions:

```math
\begin{aligned}
& (s_1)_{l_1} \preceq (s_2)_{l_2} \iff s_1 \le s_2 \text{ and } l_1 \le l_2 &&(\preceq_\kappa)
\end{aligned}
```

## Properties

The join of two qualities is the least quality above both, and the join of the qualities of two sorts at the same level is the least sort that bounds both:

```math
\begin{aligned}
& s_1 \le s_1 \sqcup s_2 &&({\sqcup}{\le}_s.\mathsf{left}) \\[1em]
& s_2 \le s_1 \sqcup s_2 &&({\sqcup}{\le}_s.\mathsf{right}) \\[1em]
& s_1 \le s_3 \text{ and } s_2 \le s_3 \implies s_1 \sqcup s_2 \le s_3 &&({\sqcup}{\le}_s.\mathsf{least}) \\[1em]
& (s_1)_l \preceq (s_1 \sqcup s_2)_l &&({\sqcup}{\preceq}_\kappa.\mathsf{left}) \\[1em]
& (s_2)_l \preceq (s_1 \sqcup s_2)_l &&({\sqcup}{\preceq}_\kappa.\mathsf{right}) \\[1em]
& (s_1)_l \preceq \kappa \text{ and } (s_2)_l \preceq \kappa \implies (s_1 \sqcup s_2)_l \preceq \kappa &&({\sqcup}{\preceq}_\kappa.\mathsf{least})
\end{aligned}
```

The relation $`\preceq`$ is a preorder:

```math
\begin{aligned}
& \kappa \preceq \kappa &&(\mathsf{preorder}_\kappa.\mathsf{refl}) \\[1em]
& \kappa_1 \preceq \kappa_2 \text{ and } \kappa_2 \preceq \kappa_3 \implies \kappa_1 \preceq \kappa_3 &&(\mathsf{preorder}_\kappa.\mathsf{trans})
\end{aligned}
```
