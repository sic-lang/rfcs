# Grade Vectors

This annex defines the vectors of grades, which give a grade to each variable of a scope, with their operations, their order, their renaming and their properties.
It builds on the [grades](04-grades.md), the [syntax](08-syntax.md) and the [substitution](09-substitution.md).

## Definitions

A vector of grades $`\gamma`$ over a scope gives a grade $`\gamma(x)`$ to each variable $`x`$ of the scope, whatever its telescope, and two vectors over a scope are equal when they give each variable the same grade:

```math
\begin{aligned}
& \gamma_1 = \gamma_2 \iff \forall x.\ \gamma_1(x) = \gamma_2(x) &&(\mathsf{equal}_\gamma)
\end{aligned}
```

The vector $`{00}^{\gamma}`$ gives each variable the grade $`{00}^{\mathsf{p}}`$, and the operations of the grades act on each variable:

```math
\begin{aligned}
& {00}^{\gamma}(x) = {00}^{\mathsf{p}} &&(\mathsf{op}_\gamma.{00}) \\[1em]
& (\gamma_1 +^{\gamma} \gamma_2)(x) = \gamma_1(x) + \gamma_2(x) &&(\mathsf{op}_\gamma.{+}) \\[1em]
& (p \cdot^{\gamma} \gamma)(x) = p \cdot \gamma(x) &&(\mathsf{op}_\gamma.{\cdot}) \\[1em]
& (\gamma_1 \wedge^{\gamma} \gamma_2)(x) = \gamma_1(x) \wedge \gamma_2(x) &&(\mathsf{op}_\gamma.{\wedge})
\end{aligned}
```

The vectors are ordered by the order of the grades on each variable:

```math
\begin{aligned}
& \gamma_1 \le^{\gamma} \gamma_2 \iff \forall x.\ \gamma_1(x) \le \gamma_2(x) &&(\mathsf{order}_\gamma)
\end{aligned}
```

The vector $`\gamma \bullet p`$ over the scope extended by a variable $`x`$ gives $`x`$ the grade $`p`$ and each other variable its grade in $`\gamma`$, and the vector $`(\gamma,\ x \mathrel{≔} p)`$ over the scope of $`\gamma`$ gives the grade $`p`$ to its variable $`x`$ instead:

```math
\begin{aligned}
& (\gamma \bullet p)(x) = p \text{ if } x \text{ is the variable that extends the scope} &&(\bullet_\gamma) \\
& (\gamma \bullet p)(y) = \gamma(y) \text{ if } y \text{ is a variable of the scope of } \gamma \\[1em]
& (\gamma,\ x \mathrel{≔} p)(x) = p &&(\mathsf{update}_\gamma) \\
& (\gamma,\ x \mathrel{≔} p)(y) = \gamma(y) \text{ if } y \ne x
\end{aligned}
```

The vector $`\gamma[\xi]`$, renamed by a [renaming](09-substitution.md#renamings) $`\xi`$ of the scope of $`\gamma`$, gives each variable $`y`$ the sum of the grades of the variables that $`\xi`$ renames to $`y`$, the grade $`{00}^{\mathsf{p}}`$ when there is none, so that the uses of two variables renamed to the same one add up:

```math
\begin{aligned}
& \gamma[\xi](y) = \sum_{\xi(x) = y} \gamma(x) &&(\mathsf{ren}_\gamma)
\end{aligned}
```

## Properties

The vectors satisfy on each variable the laws of the [grades](04-grades.md), as the vectors of the [formalization](https://github.com/graded-type-theory/graded-type-theory) of Abel, Danielsson and Eriksson do: the addition and the multiplication by a grade make them a module over the grades, and the operations are monotone:

```math
\begin{aligned}
& (\gamma_1 +^{\gamma} \gamma_2) +^{\gamma} \gamma_3 = \gamma_1 +^{\gamma} (\gamma_2 +^{\gamma} \gamma_3) &&(\mathsf{module}_\gamma.\mathsf{assoc}_{+}) \\[1em]
& \gamma_1 +^{\gamma} \gamma_2 = \gamma_2 +^{\gamma} \gamma_1 &&(\mathsf{module}_\gamma.\mathsf{comm}_{+}) \\[1em]
& {00}^{\gamma} +^{\gamma} \gamma = \gamma &&(\mathsf{module}_\gamma.\mathsf{unit}_{+}) \\[1em]
& p \cdot^{\gamma} (\gamma_1 +^{\gamma} \gamma_2) = (p \cdot^{\gamma} \gamma_1) +^{\gamma} (p \cdot^{\gamma} \gamma_2) &&(\mathsf{module}_\gamma.\mathsf{distrib}_{+^{\gamma}}) \\[1em]
& (p + q) \cdot^{\gamma} \gamma = (p \cdot^{\gamma} \gamma) +^{\gamma} (q \cdot^{\gamma} \gamma) &&(\mathsf{module}_\gamma.\mathsf{distrib}_{+}) \\[1em]
& (p \cdot q) \cdot^{\gamma} \gamma = p \cdot^{\gamma} (q \cdot^{\gamma} \gamma) &&(\mathsf{module}_\gamma.\mathsf{assoc}_{\cdot}) \\[1em]
& {11}^{\mathsf{p}} \cdot^{\gamma} \gamma = \gamma &&(\mathsf{module}_\gamma.\mathsf{unit}_{\cdot}) \\[1em]
& {00}^{\mathsf{p}} \cdot^{\gamma} \gamma = {00}^{\gamma} &&(\mathsf{module}_\gamma.\mathsf{lzero}_{\cdot}) \\[1em]
& p \cdot^{\gamma} {00}^{\gamma} = {00}^{\gamma} &&(\mathsf{module}_\gamma.\mathsf{rzero}_{\cdot}) \\[1em]
& \gamma_1 \wedge^{\gamma} \gamma_2 = \gamma_2 \wedge^{\gamma} \gamma_1 &&(\mathsf{meet}_\gamma) \\[1em]
& \gamma \le^{\gamma} \gamma &&(\mathsf{preorder}_\gamma.\mathsf{refl}) \\[1em]
& \gamma_1 \le^{\gamma} \gamma_2 \text{ and } \gamma_2 \le^{\gamma} \gamma_3 \implies \gamma_1 \le^{\gamma} \gamma_3 &&(\mathsf{preorder}_\gamma.\mathsf{trans}) \\[1em]
& \gamma_1 \le^{\gamma} \gamma_2 \text{ and } \gamma_2 \le^{\gamma} \gamma_1 \implies \gamma_1 = \gamma_2 &&(\mathsf{antisymmetry}_\gamma) \\[1em]
& \gamma_1 \le^{\gamma} \gamma_2 \text{ and } \delta_1 \le^{\gamma} \delta_2 \implies \gamma_1 +^{\gamma} \delta_1 \le^{\gamma} \gamma_2 +^{\gamma} \delta_2 &&({+}{\le}_\gamma) \\[1em]
& \gamma_1 \le^{\gamma} \gamma_2 \implies p \cdot^{\gamma} \gamma_1 \le^{\gamma} p \cdot^{\gamma} \gamma_2 &&({\cdot}{\le}_\gamma) \\[1em]
& \gamma_3 \le^{\gamma} \gamma_1 \text{ and } \gamma_3 \le^{\gamma} \gamma_2 \iff \gamma_3 \le^{\gamma} \gamma_1 \wedge^{\gamma} \gamma_2 &&({\wedge}{\le}_\gamma)
\end{aligned}
```

The extension commutes with the operations:

```math
\begin{aligned}
& {00}^{\gamma} \bullet {00}^{\mathsf{p}} = {00}^{\gamma} &&(\mathsf{op}{\bullet}_\gamma.{00}) \\[1em]
& (\gamma_1 \bullet p) +^{\gamma} (\gamma_2 \bullet q) = (\gamma_1 +^{\gamma} \gamma_2) \bullet (p + q) &&(\mathsf{op}{\bullet}_\gamma.{+}) \\[1em]
& r \cdot^{\gamma} (\gamma \bullet p) = (r \cdot^{\gamma} \gamma) \bullet (r \cdot p) &&(\mathsf{op}{\bullet}_\gamma.{\cdot})
\end{aligned}
```

The renaming commutes with the operations and keeps the order; under the variable that extends the scope, the renaming renames it to itself, as a substitution does:

```math
\begin{aligned}
& {00}^{\gamma}[\xi] = {00}^{\gamma} &&(\mathsf{ren}_\gamma.{00}) \\[1em]
& (\gamma_1 +^{\gamma} \gamma_2)[\xi] = \gamma_1[\xi] +^{\gamma} \gamma_2[\xi] &&(\mathsf{ren}_\gamma.{+}) \\[1em]
& (p \cdot^{\gamma} \gamma)[\xi] = p \cdot^{\gamma} \gamma[\xi] &&(\mathsf{ren}_\gamma.{\cdot}) \\[1em]
& \gamma_1 \le^{\gamma} \gamma_2 \implies \gamma_1[\xi] \le^{\gamma} \gamma_2[\xi] &&(\mathsf{ren}_\gamma.{\le}) \\[1em]
& ({00}^{\gamma},\ x \mathrel{≔} p)[\xi] = ({00}^{\gamma},\ \xi(x) \mathrel{≔} p) &&(\mathsf{ren}_\gamma.\mathsf{update}) \\[1em]
& (\gamma \bullet p)[\xi] = \gamma[\xi] \bullet p &&(\mathsf{ren}_\gamma.{\bullet})
\end{aligned}
```

The equality and the order of two vectors are decidable, since a scope has finitely many variables:

```math
\begin{aligned}
& \gamma_1 = \gamma_2 \text{ is decidable} &&(\mathsf{decidable}_\gamma.{=}) \\[1em]
& \gamma_1 \le^{\gamma} \gamma_2 \text{ is decidable} &&(\mathsf{decidable}_\gamma.{\le})
\end{aligned}
```
