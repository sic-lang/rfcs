# Levels

This annex defines the levels, which index the sorts, with their values, their equality, their order and their properties.
It builds on the [notation](01-notation.md).

## Definitions

A level is $`0`$, a successor $`l + 1`$, the larger $`l_1 \sqcup l_2`$ of two levels, or a level variable, which stands for any natural number:

```math
\begin{aligned}
& l \mathrel{::=} 0 \mid l + 1 \mid l \sqcup l \mid \text{a level variable} &&(\mathsf{syntax}_l)
\end{aligned}
```

A level is not a term: it uses no variable of a context, and appears only as the index of a sort.

## Meaning

An assignment $`\rho`$ gives a natural number $`\rho(l)`$ to each level variable $`l`$, and the value $`[\![l]\!]_\rho`$ of a level $`l`$ under $`\rho`$ follows its syntax:

```math
\begin{aligned}
& \text{and} &&(\mathsf{value}_l) \\
& \quad [\![0]\!]_\rho = 0 \\
& \quad [\![l + 1]\!]_\rho = [\![l]\!]_\rho + 1 \\
& \quad [\![l_1 \sqcup l_2]\!]_\rho = \max([\![l_1]\!]_\rho,\ [\![l_2]\!]_\rho) \\
& \quad [\![l]\!]_\rho = \rho(l) \text{ if } l \text{ is a level variable}
\end{aligned}
```

Two levels are equal when their values are equal whatever numbers their variables take, and ordered when their values are ordered whatever numbers their variables take, so that the values are the meaning of the levels, and the equality and the order are exact for it by construction:

```math
\begin{aligned}
& l_1 = l_2 \iff \forall \rho.\ [\![l_1]\!]_\rho = [\![l_2]\!]_\rho &&(=_l) \\[1em]
& l_1 \le l_2 \iff \forall \rho.\ [\![l_1]\!]_\rho \le [\![l_2]\!]_\rho &&(\le_l)
\end{aligned}
```

The equality $`=`$ of two levels is therefore this one, and not the equality of their syntax, in every annex.

## Properties

The equality is an equivalence, and the order a preorder, whose equivalence is the equality and which is the order of the larger of two levels:

```math
\begin{aligned}
& \text{and} &&(\mathsf{equiv}_l) \\
& \quad l = l \\
& \quad l_1 = l_2 \implies l_2 = l_1 \\
& \quad l_1 = l_2 \text{ and } l_2 = l_3 \implies l_1 = l_3 \\[1em]
& \text{and} &&(\mathsf{preorder}_l) \\
& \quad l \le l \\
& \quad l_1 \le l_2 \text{ and } l_2 \le l_3 \implies l_1 \le l_3 \\[1em]
& l_1 = l_2 \iff l_1 \le l_2 \text{ and } l_2 \le l_1 &&(\mathsf{antisymmetry}_l) \\[1em]
& l_1 \le l_2 \iff l_1 \sqcup l_2 = l_2 &&({\le}{\sqcup}_l)
\end{aligned}
```

The equality and the order of two levels are decidable, though each quantifies over infinitely many assignments:

```math
\begin{aligned}
& \text{and} &&(\mathsf{decidable}_l) \\
& \quad l_1 = l_2 \text{ is decidable} \\
& \quad l_1 \le l_2 \text{ is decidable}
\end{aligned}
```
