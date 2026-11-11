# Grade Vectors

This annex defines the vectors of the elements of a modality, with their operations, their order and their properties, then the vectors of grades, which give a grade to each variable of a scope, with their renaming.
It builds on the [modalities](02-modalities.md), the [grades](04-grades.md), the [syntax](08-syntax.md) and the [substitution](09-substitution.md).

## Vectors

This section defines the vectors over any modality, whose operations act on each index, and states the laws that they get from those of the modality.

### Definitions of the Vectors

A vector $`\mu`$ over a finite set of indices $`I`$ gives an element $`\mu(i)`$ of a [modality](02-modalities.md) $`\mathcal{M}`$ to each index $`i`$ of $`I`$, and two vectors over $`I`$ are equal when they give each index the same element:

```math
\begin{aligned}
& \mu(i) \in \mathcal{M} \text{ for every } i \in I &&(\mathsf{vector}_\mu) \\[1em]
& \mu_1 = \mu_2 \iff \forall i.\ \mu_1(i) = \mu_2(i) &&(\mathsf{equal}_\mu)
\end{aligned}
```

The vector $`0^{\mu}`$ gives each index the zero $`0^{\xi}`$ of the modality, and the operations of the modality act on each index:

```math
\begin{aligned}
& 0^{\mu}(i) = 0^{\xi} &&(\mathsf{op}_\mu.0) \\[1em]
& (\mu_1 +^{\mu} \mu_2)(i) = \mu_1(i) + \mu_2(i) &&(\mathsf{op}_\mu.{+}) \\[1em]
& (\xi \cdot^{\mu} \mu)(i) = \xi \cdot \mu(i) &&(\mathsf{op}_\mu.{\cdot}) \\[1em]
& (\mu_1 \wedge^{\mu} \mu_2)(i) = \mu_1(i) \wedge \mu_2(i) &&(\mathsf{op}_\mu.{\wedge})
\end{aligned}
```

The vectors are ordered by the [order](02-modalities.md#definitions) of the modality on each index:

```math
\begin{aligned}
& \mu_1 \le^{\mu} \mu_2 \iff \forall i.\ \mu_1(i) \le \mu_2(i) &&(\mathsf{order}_\mu)
\end{aligned}
```

The vector $`\mu \bullet \xi`$ over $`I`$ extended by an index $`i`$ gives $`i`$ the element $`\xi`$ and each other index its element in $`\mu`$, and the vector $`{(\mu,\ i \mathrel{≔} \xi)}`$ over the indices of $`\mu`$ gives the element $`\xi`$ to its index $`i`$ instead:

```math
\begin{aligned}
& (\mu \bullet \xi)(i) = \xi \text{ if } i \text{ is the index that extends } I &&(\bullet_\mu) \\
& (\mu \bullet \xi)(j) = \mu(j) \text{ if } j \in I \\[1em]
& (\mu,\ i \mathrel{≔} \xi)(i) = \xi &&(\mathsf{update}_\mu) \\
& (\mu,\ i \mathrel{≔} \xi)(j) = \mu(j) \text{ if } j \ne i
\end{aligned}
```

### Properties of the Vectors

The vectors satisfy on each index the laws of the modality, as the vectors of the [formalization](https://github.com/graded-type-theory/graded-type-theory) of Abel, Danielsson and Eriksson do: the addition and the multiplication by an element make them a module over the modality, and the operations are monotone:

```math
\begin{aligned}
& (\mu_1 +^{\mu} \mu_2) +^{\mu} \mu_3 = \mu_1 +^{\mu} (\mu_2 +^{\mu} \mu_3) &&(\mathsf{module}_\mu.\mathsf{assoc}_{+}) \\[1em]
& \mu_1 +^{\mu} \mu_2 = \mu_2 +^{\mu} \mu_1 &&(\mathsf{module}_\mu.\mathsf{comm}_{+}) \\[1em]
& 0^{\mu} +^{\mu} \mu = \mu &&(\mathsf{module}_\mu.\mathsf{unit}_{+}) \\[1em]
& \xi \cdot^{\mu} (\mu_1 +^{\mu} \mu_2) = (\xi \cdot^{\mu} \mu_1) +^{\mu} (\xi \cdot^{\mu} \mu_2) &&(\mathsf{module}_\mu.\mathsf{distrib}_{+^{\mu}}) \\[1em]
& (\xi_1 + \xi_2) \cdot^{\mu} \mu = (\xi_1 \cdot^{\mu} \mu) +^{\mu} (\xi_2 \cdot^{\mu} \mu) &&(\mathsf{module}_\mu.\mathsf{distrib}_{+}) \\[1em]
& (\xi_1 \cdot \xi_2) \cdot^{\mu} \mu = \xi_1 \cdot^{\mu} (\xi_2 \cdot^{\mu} \mu) &&(\mathsf{module}_\mu.\mathsf{assoc}_{\cdot}) \\[1em]
& 1^{\xi} \cdot^{\mu} \mu = \mu &&(\mathsf{module}_\mu.\mathsf{unit}_{\cdot}) \\[1em]
& 0^{\xi} \cdot^{\mu} \mu = 0^{\mu} &&(\mathsf{module}_\mu.\mathsf{lzero}_{\cdot}) \\[1em]
& \xi \cdot^{\mu} 0^{\mu} = 0^{\mu} &&(\mathsf{module}_\mu.\mathsf{rzero}_{\cdot}) \\[1em]
& \mu_1 \wedge^{\mu} \mu_2 = \mu_2 \wedge^{\mu} \mu_1 &&(\mathsf{meet}_\mu) \\[1em]
& \mu \le^{\mu} \mu &&(\mathsf{preorder}_\mu.\mathsf{refl}) \\[1em]
& \mu_1 \le^{\mu} \mu_2 \text{ and } \mu_2 \le^{\mu} \mu_3 \implies \mu_1 \le^{\mu} \mu_3 &&(\mathsf{preorder}_\mu.\mathsf{trans}) \\[1em]
& \mu_1 \le^{\mu} \mu_2 \text{ and } \mu_2 \le^{\mu} \mu_1 \implies \mu_1 = \mu_2 &&(\mathsf{antisymmetry}_\mu) \\[1em]
& \mu_1 \le^{\mu} \mu_2 \text{ and } \nu_1 \le^{\mu} \nu_2 \implies \mu_1 +^{\mu} \nu_1 \le^{\mu} \mu_2 +^{\mu} \nu_2 &&({+}{\le}_\mu) \\[1em]
& \mu_1 \le^{\mu} \mu_2 \implies \xi \cdot^{\mu} \mu_1 \le^{\mu} \xi \cdot^{\mu} \mu_2 &&({\cdot}{\le}_\mu) \\[1em]
& \mu_3 \le^{\mu} \mu_1 \text{ and } \mu_3 \le^{\mu} \mu_2 \iff \mu_3 \le^{\mu} \mu_1 \wedge^{\mu} \mu_2 &&({\wedge}{\le}_\mu)
\end{aligned}
```

The extension commutes with the operations, whatever the laws of the modality:

```math
\begin{aligned}
& 0^{\mu} \bullet 0^{\xi} = 0^{\mu} &&(\mathsf{op}{\bullet}_\mu.0) \\[1em]
& (\mu_1 \bullet \xi_1) +^{\mu} (\mu_2 \bullet \xi_2) = (\mu_1 +^{\mu} \mu_2) \bullet (\xi_1 + \xi_2) &&(\mathsf{op}{\bullet}_\mu.{+}) \\[1em]
& \xi_1 \cdot^{\mu} (\mu \bullet \xi_2) = (\xi_1 \cdot^{\mu} \mu) \bullet (\xi_1 \cdot \xi_2) &&(\mathsf{op}{\bullet}_\mu.{\cdot})
\end{aligned}
```

The equality and the order of two vectors are decidable when the equality of the modality is, since a vector has finitely many indices and the order of the modality is an equality:

```math
\begin{aligned}
& \mu_1 = \mu_2 \text{ is decidable} &&(\mathsf{decidable}_\mu.{=}) \\[1em]
& \mu_1 \le^{\mu} \mu_2 \text{ is decidable} &&(\mathsf{decidable}_\mu.{\le})
\end{aligned}
```

## Vectors of Grades

This section defines the vectors of grades, the vectors that the usage computes, and their renaming, then states how the renaming acts on their operations.

### Definitions of the Vectors of Grades

A vector of grades $`\gamma`$ over a scope is a vector over its variables, whatever their telescope, whose elements are [grades](04-grades.md), which form a modality, $`(\mathsf{modality}_p)`$; its zero $`{00}^{\gamma}`$ gives each variable the grade $`{00}^{\mathsf{p}}`$:

```math
\begin{aligned}
& \gamma(x) \text{ is a grade for every variable } x \text{ of the scope} &&(\mathsf{vector}_\gamma) \\[1em]
& {00}^{\gamma}(x) = {00}^{\mathsf{p}} &&(\mathsf{zero}_\gamma)
\end{aligned}
```

Its operations, its order, its extension and its update are those of the vectors, written $`{+^{\gamma}}`$, $`{\cdot^{\gamma}}`$, $`{\wedge^{\gamma}}`$, $`{\le^{\gamma}}`$, $`\gamma \bullet p`$ and $`{(\gamma,\ x \mathrel{≔} p)}`$, the extension giving its grade to the variable that extends the scope, and they satisfy the properties of the vectors, at the modality of the grades.

The vector $`\gamma[\alpha]`$, renamed by a [renaming](09-substitution.md#renamings) $`\alpha`$ of the scope of $`\gamma`$, gives each variable $`y`$ the sum of the grades of the variables that $`\alpha`$ renames to $`y`$, the grade $`{00}^{\mathsf{p}}`$ when there is none, so that the uses of two variables renamed to the same one add up:

```math
\begin{aligned}
& \gamma[\alpha](y) = \sum_{\alpha(x) = y} \gamma(x) &&(\mathsf{ren}_\gamma)
\end{aligned}
```

### Properties of the Vectors of Grades

This section states how the renaming acts on the operations of the vectors of grades.

The renaming commutes with the operations and keeps the order; under the variable that extends the scope, the renaming renames it to itself, as a substitution does:

```math
\begin{aligned}
& {00}^{\gamma}[\alpha] = {00}^{\gamma} &&(\mathsf{ren}_\gamma.{00}) \\[1em]
& (\gamma_1 +^{\gamma} \gamma_2)[\alpha] = \gamma_1[\alpha] +^{\gamma} \gamma_2[\alpha] &&(\mathsf{ren}_\gamma.{+}) \\[1em]
& (p \cdot^{\gamma} \gamma)[\alpha] = p \cdot^{\gamma} \gamma[\alpha] &&(\mathsf{ren}_\gamma.{\cdot}) \\[1em]
& \gamma_1 \le^{\gamma} \gamma_2 \implies \gamma_1[\alpha] \le^{\gamma} \gamma_2[\alpha] &&(\mathsf{ren}_\gamma.{\le}) \\[1em]
& ({00}^{\gamma},\ x \mathrel{≔} p)[\alpha] = ({00}^{\gamma},\ \alpha(x) \mathrel{≔} p) &&(\mathsf{ren}_\gamma.\mathsf{update}) \\[1em]
& (\gamma \bullet p)[\alpha] = \gamma[\alpha] \bullet p &&(\mathsf{ren}_\gamma.{\bullet})
\end{aligned}
```
