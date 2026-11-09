# Reduction

This annex defines the weak head reduction, its head normal forms and the computation of the closed terms, and their properties.
It builds on the [syntax](08-syntax.md) and on the instances of the entries, which the [typing](13-typing.md) defines.

## Definitions

The judgment $`\Sigma \vdash t \longrightarrow u`$ reads: in the signature $`\Sigma`$, the term $`t`$ reduces to $`u`$ in one step of weak head reduction.
The reduction is untyped, and defined on the terms of every scope, with their level variables.

The reduction unfolds a constant definition to its body at the instance of its variables, steps a recursor on a constructor applied to the terms of its fields to the branch of the constructor, the terms substituted for the variables of the fields, and reduces the term that a recursor eliminates; the block, written as in the [typing](13-typing.md#terms), gives the constructor its branch, at the position of the constructor in the block:

```math
\frac{\begin{gathered}{}(f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \mathrel{≔} t) \in \Sigma \\ \bar s',\ \bar l',\ \bar p' \text{ as many as } \bar s,\ \bar l,\ \bar p\end{gathered}}{\Sigma \vdash f.\{\bar s';\ \bar l';\ \bar p'\} \longrightarrow t[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p]}\;(\delta_{\longrightarrow})
```

```math
\begin{gathered}
\frac{\begin{gathered}{}(\mathsf{data}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} \bar c_1;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \bar c_k) \in \Sigma \\ \bar u = (D_1.c_{11}(\bar x_{11}) \Rightarrow u_{11},\ \dots,\ D_k.c_{kn_k}(\bar x_{kn_k}) \Rightarrow u_{kn_k}) \\ \bar t \text{ as many as } \bar x_{hi}\end{gathered}}{\Sigma \vdash \mathsf{rec}_r\ T\ ((D_h.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a).c_{hi}(\bar t))\ \mathsf{return}\ \bar C\ \mathsf{with}\ \bar u \longrightarrow u_{hi}[\bar t / \bar x_{hi}]}\;(\iota_{\longrightarrow}) \\[1em]
\frac{\Sigma \vdash t \longrightarrow t'}{\Sigma \vdash \mathsf{rec}_r\ T\ t\ \mathsf{return}\ \bar C\ \mathsf{with}\ \bar u \longrightarrow \mathsf{rec}_r\ T\ t'\ \mathsf{return}\ \bar C\ \mathsf{with}\ \bar u}\;(\mathsf{rec}_{\longrightarrow})
\end{gathered}
```

A term is neutral when its reduction is stuck on a variable or on a declared constant, which has no body to unfold, or a recursor on a neutral term, and a head normal form when it is a sort, an instance of a declared type, a constructor applied to the terms of its fields, which it does not compute, or a neutral term:

```math
\begin{aligned}
& {\mathrel{::=}} &&(\mathsf{neutral}_t) \\
& \quad \text{a neutral term in } \Sigma \\
& \quad {\mid} \\
& \qquad x[\bar t] \\
& \qquad f.\{\bar s';\ \bar l';\ \bar p'\} \text{ if } (f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p) \in \Sigma \\
& \qquad \mathsf{rec}_r\ T\ n\ \mathsf{return}\ \bar C\ \mathsf{with}\ \bar u \text{ if } n \text{ is a neutral term in } \Sigma \\[1em]
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

In a signature whose names are [distinct](08-syntax.md), as those of a well-formed signature are by $`(\mathsf{distinct}_\Sigma)`$, a head normal form does not reduce, since a declared constant has no body and a neutral term is no constructor, and the reduction, its steps and the computation are deterministic, since a constant has one entry, and a constructor one position in the block of its type:

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
