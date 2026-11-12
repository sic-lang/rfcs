# Run Time

This annex defines the relation of run time between the closed terms of a closed type and the values that their erasure computes, which states what the erasure of a term computes when it runs, the validity at run time of a term in a context, which extends it to open terms, and their properties.
It builds on the [erasure](16-erasure.md), the [evaluation](17-evaluation.md) and the [meaning](18-meaning.md), which gives each closed canonical type its [relation of run time](18-meaning.md#relations-of-run-time).

## Definitions

The relation of run time relates a closed term of a closed type to the address of a value of the target language in a heap, when the value is what the erasure by $`S^{{11}^{\mathsf{m}}}`$ of the term computes.
A closed term is related to an address at a closed type when the type computes to a type or a proposition whose relation relates the term to the address:

```math
\begin{aligned}
& t \circledR_H \ell : A \iff \exists v.\ A \Downarrow v \text{ and } (H,\ t,\ \ell) \in \circledR_\Downarrow(\circledR(v)) &&(\circledR_A)
\end{aligned}
```

A closed substitution $`\theta`$ of a context whose variables are all of the first order is related, with the grades $`\gamma`$, to an environment $`E`$ in a heap $`H`$ when each variable whose grade is not in $`S^{{11}^{\mathsf{m}}}`$, so that the erasure keeps its uses, is related to its address at its type; the erasure keeps no abstraction, so that a second-order variable has no address:

```math
\begin{aligned}
& (\varepsilon,\ \varepsilon) \in \circledR_H(\varepsilon;\ \varepsilon) &&(\circledR_\varepsilon) \\[1em]
& \text{⟺} &&(\circledR_x) \\
& \quad ((\theta,\ t),\ (E,\ x \mapsto \ell)) \in \circledR_H(\Gamma,\ x : A;\ \gamma \bullet p) \\
& \quad \text{and} \\
& \qquad (\theta,\ E) \in \circledR_H(\Gamma;\ \gamma) \\
& \qquad p \notin S^{{11}^{\mathsf{m}}} \implies t \circledR_H \ell : A[\theta]
\end{aligned}
```

A term is valid at run time with the grades $`\gamma`$ in a context whose variables are all of the first order when, for each closed substitution $`\theta`$ that the meaning relates to itself and each environment that is related to it in a heap, its erasure by $`S^{{11}^{\mathsf{m}}}`$ evaluates to an address in a heap that extends this heap, to which the substituted term is related at the substituted type:

```math
\begin{aligned}
& \text{⟺} &&({\vDash}^{\circledR}) \\
& \quad \Sigma;\ \gamma;\ \Gamma \vDash^{\circledR} t : A \\
& \quad \forall \theta, H, E. \\
& \qquad \text{⟹} \\
& \qquad\quad \text{and} \\
& \qquad\qquad (\theta,\ \theta) \in \mathsf{eq}(\Gamma) \\
& \qquad\qquad (\theta,\ E) \in \circledR_H(\Gamma;\ \gamma) \\
& \qquad\quad \exists \ell, H'. \\
& \qquad\qquad \text{and} \\
& \qquad\qquad\quad \mathcal{P};\ H;\ E \vdash \lfloor t \rfloor_{S^{{11}^{\mathsf{m}}}} \Downarrow \ell;\ H' \\
& \qquad\qquad\quad H \sqsubseteq H' \\
& \qquad\qquad\quad t[\theta] \circledR_{H'} \ell : A[\theta]
\end{aligned}
```

## Properties

A term related to an address in a heap stays related to it in each heap that extends it, since the relations of the data types read only values that the heap keeps, and those of the codata types relate the observations in each heap that extends it:

```math
\begin{aligned}
& \text{⟹} &&(\mathsf{ext}_\circledR) \\
& \quad \text{and} \\
& \qquad \text{the names of } \Sigma \text{ are distinct} \\
& \qquad H \sqsubseteq H' \\
& \qquad t \circledR_H \ell : A \\
& \quad t \circledR_{H'} \ell : A
\end{aligned}
```

A term valid at run time with some grades is valid with lower grades, as the rule $`(\mathsf{sub}_{▶})`$ of the usage gives a term grades lower than its uses, since $`S^{{11}^{\mathsf{m}}}`$ holds each grade above one of its grades:

```math
\begin{aligned}
& \text{⟹} &&(\mathsf{sub}^{\circledR}) \\
& \quad \text{and} \\
& \qquad \delta \le^{\gamma} \gamma \\
& \qquad \Sigma;\ \gamma;\ \Gamma \vDash^{\circledR} t : A \\
& \quad \Sigma;\ \delta;\ \Gamma \vDash^{\circledR} t : A
\end{aligned}
```
