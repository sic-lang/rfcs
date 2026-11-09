# Reduction

This annex defines the weak head reduction, its head normal forms and the computation of the closed terms, and their properties.
It builds on the [syntax](08-syntax.md) and on the instances of the entries, which the [typing](13-typing.md) defines.

## Definitions

The judgment $`\Sigma \vdash t \longrightarrow u`$ reads: in the signature $`\Sigma`$, the term $`t`$ reduces to $`u`$ in one step of weak head reduction.
The reduction is untyped, and defined on the terms of every scope, with their level variables.

The reduction has one rule, which unfolds a constant definition to its body at the instance of its variables; the step of the recursor comes with its typing:

```math
\frac{\begin{gathered}{}(f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \mathrel{≔} t) \in \Sigma \\ \bar s',\ \bar l',\ \bar p' \text{ as many as } \bar s,\ \bar l,\ \bar p\end{gathered}}{\Sigma \vdash f.\{\bar s';\ \bar l';\ \bar p'\} \longrightarrow t[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p]}\;(\delta_{\longrightarrow})
```

A term is neutral when its reduction is stuck on a variable or on a declared constant, which has no body to unfold, and a head normal form when it is a sort, an instance of a declared type, a constructor applied to the terms of its fields, which it does not compute, or a neutral term:

```math
\begin{aligned}
& {\mathrel{::=}} &&(\mathsf{neutral}_t) \\
& \quad \text{a neutral term in } \Sigma \\
& \quad {\mid} \\
& \qquad x[\bar t] \\
& \qquad f.\{\bar s';\ \bar l';\ \bar p'\} \text{ if } (f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p) \in \Sigma \\[1em]
& {\mathrel{::=}} &&(\mathsf{whnf}_t) \\
& \quad \text{a head normal form in } \Sigma \\
& \quad {\mid} \\
& \qquad \kappa \\
& \qquad D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a \\
& \qquad (D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a).c(\bar t) \\
& \qquad \text{a neutral term in } \Sigma
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

In a signature whose names are [distinct](08-syntax.md), as those of a well-formed signature are by $`(\mathsf{distinct}_\Sigma)`$, a head normal form does not reduce, since a declared constant has no body, and the reduction, its steps and the computation are deterministic, since a constant has one entry:

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
