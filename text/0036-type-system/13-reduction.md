# Reduction

This annex defines the weak head reduction, its head normal forms and the computation of the closed terms, and their properties.
It builds on the [syntax](07-syntax.md) and on the instances of the entries, which the [typing](12-typing.md) defines.

## Definitions

The judgment $`\Sigma \vdash t \longrightarrow u`$ reads: in the signature $`\Sigma`$, the term $`t`$ reduces to $`u`$ in one step of weak head reduction.
The reduction is untyped, and defined on the terms of every scope, with their level variables.

The core reduces by one rule, which unfolds a constant definition to its body at the instance of its variables; the steps of the terms of the declared types, and the head normal forms among these terms, are given by the kinds of type declarations, in their annexes:

```math
\frac{\begin{gathered}{}(f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \mathrel{≔} t) \in \Sigma \\ \bar s',\ \bar l',\ \bar p' \text{ as many as } \bar s,\ \bar l,\ \bar p\end{gathered}}{\Sigma \vdash f.\{\bar s';\ \bar l';\ \bar p'\} \longrightarrow t[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p]}\;(\delta_{\longrightarrow})
```

A term is neutral when its reduction is stuck on a variable or on a declared constant, which has no body to unfold, and a head normal form when it is a sort, an instance of a declared type or a neutral term:

```math
\begin{aligned}
& {\mathrel{::=}} &&(\mathsf{neutral}_t) \\
& \quad \text{a neutral term in } \Sigma \\
& \quad {\mid} \\
& \qquad x[\bar t] \\
& \qquad f.\{\bar s';\ \bar l';\ \bar p'\} \text{ if } (f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p) \in \Sigma \\[1em]
& \text{a head normal form in } \Sigma \mathrel{::=} \kappa \mid D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a \mid \text{a neutral term in } \Sigma &&(\mathsf{whnf}_t)
\end{aligned}
```

The judgment $`\Sigma \vdash t \longrightarrow^{*} u`$ reads: $`t`$ reduces to $`u`$ in some steps, none or a step followed by the others:

```math
\begin{gathered}
\frac{}{\Sigma \vdash t \longrightarrow^{*} t}\;({\longrightarrow^{*}}.\mathsf{refl}) \\[1em]
\frac{\begin{gathered}{}\Sigma \vdash t \longrightarrow u_1 \\ \Sigma \vdash u_1 \longrightarrow^{*} u_2\end{gathered}}{\Sigma \vdash t \longrightarrow^{*} u_2}\;({\longrightarrow^{*}}.\mathsf{step})
\end{gathered}
```

A closed term is a term in the empty scope without level variables.
The judgment $`\Sigma \vdash t \Downarrow v`$ reads: the closed term $`t`$ computes to the closed term $`v`$, a head normal form that it reduces to, stuck on no variable:

```math
\begin{aligned}
& \text{⟺} &&(\Downarrow) \\
& \quad \Sigma \vdash t \Downarrow v \\
& \quad \text{and} \\
& \qquad \Sigma \vdash t \longrightarrow^{*} v \\
& \qquad v \text{ is a head normal form in } \Sigma
\end{aligned}
```

## Properties

In a signature whose names are [distinct](07-syntax.md), as those of a well-formed signature are by $`(\mathsf{distinct}_\Sigma)`$, a head normal form does not reduce, since a declared constant has no body, and the reduction, its steps and the computation are deterministic, since a constant has one entry:

```math
\begin{aligned}
& \text{⟹} &&(\mathsf{normal}_{\longrightarrow}) \\
& \quad \text{and} \\
& \qquad \text{the names of } \Sigma \text{ are distinct} \\
& \qquad t \text{ is a head normal form in } \Sigma \\
& \quad \text{not } \Sigma \vdash t \longrightarrow u \\[1em]
& \text{⟹} &&(\mathsf{det}_{\longrightarrow}) \\
& \quad \text{and} \\
& \qquad \text{the names of } \Sigma \text{ are distinct} \\
& \qquad \Sigma \vdash t \longrightarrow u_1 \\
& \qquad \Sigma \vdash t \longrightarrow u_2 \\
& \quad u_1 = u_2 \\[1em]
& \text{⟹} &&(\mathsf{det}_{\longrightarrow^{*}}) \\
& \quad \text{and} \\
& \qquad \text{the names of } \Sigma \text{ are distinct} \\
& \qquad \Sigma \vdash t \longrightarrow^{*} u_1 \\
& \qquad u_1 \text{ is a head normal form in } \Sigma \\
& \qquad \Sigma \vdash t \longrightarrow^{*} u_2 \\
& \qquad u_2 \text{ is a head normal form in } \Sigma \\
& \quad u_1 = u_2 \\[1em]
& \text{⟹} &&(\mathsf{det}_{\Downarrow}) \\
& \quad \text{and} \\
& \qquad \text{the names of } \Sigma \text{ are distinct} \\
& \qquad \Sigma \vdash t \Downarrow v_1 \\
& \qquad \Sigma \vdash t \Downarrow v_2 \\
& \quad v_1 = v_2
\end{aligned}
```
