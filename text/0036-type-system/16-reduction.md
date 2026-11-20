# Reduction

This annex defines the weak head reduction, its head normal forms and the computation of the closed terms, and their properties.
It builds on the [syntax](08-syntax.md), on the [instances of the entries](09-substitution.md#instances-of-the-entries), on the [resumption](12-prelude.md#positions) of the positions, on the [recursive results](14-recursive-results.md) of the terms of the fields of a constructor and on the [typing](15-typing.md#properties), by the existence of these results.

## Definitions

The judgment $`{\Sigma \vdash t \longrightarrow u}`$ reads: in the signature $`\Sigma`$, the term $`t`$ reduces to $`u`$ in one step of weak head reduction.
The reduction is untyped, and defined on the terms of every scope, with their level variables.

The reduction unfolds a constant definition to its body at the instance of its variables, steps a recursor on a constructor applied to the terms of its fields to the branch of the constructor, the terms substituted for the variables of the fields and their [recursive results](14-recursive-results.md#terms-of-the-results) $`\bar t'`$ for those of the recursive results, and reduces the term that a recursor eliminates; the block $`\mathcal{D}`$, written as in the [typing](15-typing.md#terms), gives the constructor its branch, at the position of the constructor in the block.
The recursive results are those of the terms of the fields $`{\Theta''_{hi} = \Theta_{hi}[\bar s'' / \bar s,\ \bar l'' / \bar l,\ \bar p'' / \bar p][\bar a'' / \Delta]}`$ of the constructor at the instance of the recursor, the instance that the constructor carries playing no part, and the recursor fixes the variables of their definitions as in the typing: the block lifted gives each type $`D_j`$ its instance $`{D_j.\{\bar s'';\ \bar l'';\ \bar p''\}\ \bar a''}`$ and the motive $`{z.\, C_j}`$, at the level of $`\kappa_C`$, no parameter is lifted, $`s_C`$ is the quality of $`\kappa_C`$, and $`r`$, $`\varsigma`$ and $`\chi`$ are those of the recursor; the result of the term of a recursive field is the recursor on it, at the instance of the recursor, and that of the term of a nested field the corecursor of a lifting.
A recursor on a constructor whose terms have no recursive results does not step; in a well-formed signature, the terms of fields whose recursive results have types, as the typing of the recursor asks, have recursive results, by $`(\mathsf{exists}_{\mathsf{res}\Theta})`$ of the [typing](15-typing.md#properties).
It steps an observation of a corecursor to the branch of the destructor in the corecursor, the terms of the state and the arguments substituted for its variables, and reduces the term that an observation observes; the block of codata types, whose type $`D_j`$ has the destructors $`{\bar d_j = d_{j1} : \dots \mid \dots \mid d_{jn_j} : \dots}`$ and the state whose variables are $`\bar y_j`$, gives the destructor its branch, at the position of the destructor in the block, and the instance that the observation carries plays no part, as that of a recursor does not.
The term of the branch is [resumed](12-prelude.md#positions) if the destructor is recursive, so that a new state that it gives becomes the corecursor from it, where $`{\bar d_h[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p] = (\bar d_{hi,1} \mid d_{hi} : (\Theta_{hi} \vdash B_{hi} \mathrel{◀} \psi_{hi}) \mathrel{▶} p_{hi};\ q_{hi} \mathrel{◀} \varsigma_{hi} \mid \bar d_{hi,2})}`$ decomposes the destructors at the instance of the corecursor, $`{\kappa' = \kappa[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p]}`$ is the sort of the block at this instance, and $`\chi_{hi}`$ is the constant of $`\psi_{hi}`$, $`{\omega\omega}^{\mathsf{p}}`$ if it has none; the parameters of the block are uniform, so that the branch binds none of them:

```math
\frac{\begin{aligned}& (f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \mathrel{≔} t) \in \Sigma \\[0.6em] & \bar s',\ \bar l',\ \bar p' \text{ as many as } \bar s,\ \bar l,\ \bar p\end{aligned}}{\Sigma \vdash f.\{\bar s';\ \bar l';\ \bar p'\} \longrightarrow t[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p]}\;(\delta_{\longrightarrow})
```

```math
\begin{gathered}
\frac{\begin{aligned}& {\in} \\ & \quad \mathsf{data}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa \\ & \qquad \mathsf{where} \\ & \qquad \quad D_1 \mathrel{▶} \zeta_1 \oplus \Pi_1 \mathrel{≔} \bar c_1; \\ & \qquad \quad \dots; \\ & \qquad \quad D_k \mathrel{▶} \zeta_k \oplus \Pi_k \mathrel{≔} \bar c_k \\ & \quad \Sigma \\[0.6em] & \bar u = (D_1.c_{11}(\bar x_{11};\ \bar y_{11} \mathrel{▶} \bar e_{11}) \Rightarrow u_{11},\ \dots,\ D_k.c_{kn_k}(\bar x_{kn_k};\ \bar y_{kn_k} \mathrel{▶} \bar e_{kn_k}) \Rightarrow u_{kn_k}) \\[0.6em] & \bar s'',\ \bar l'',\ \bar p'' \text{ as many as } \bar s,\ \bar l,\ \bar p \\[0.6em] & \bar t \text{ as many as } \bar x_{hi} \\[0.6em] & f(D_j, t) = \mathsf{rec}_{r;\ \varsigma;\ \chi}\ (D_j.\{\bar s'';\ \bar l'';\ \bar p''\}\ \bar a'')\ t\ \mathsf{return}\ \bar C : \kappa_C\ \mathsf{with}\ \bar u \\[0.6em] & \Sigma \vdash \mathsf{res}_{f;\ \mathsf{nest}_{\mathcal{D}}(\Theta_{hi})}(\bar t : \Theta''_{hi}) = \bar t'\end{aligned}}{\begin{aligned}& \Sigma \\ & {\vdash}\ \mathsf{rec}_{r;\ \varsigma;\ \chi}\ (D.\{\bar s'';\ \bar l'';\ \bar p''\}\ \bar a'')\ ((D_h.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a).c_{hi}(\bar t)) \\ & \qquad \mathsf{return}\ \bar C : \kappa_C \\ & \qquad \mathsf{with}\ \bar u \\ & {\longrightarrow}\ u_{hi}[\bar t / \bar x_{hi},\ \bar t' / \bar y_{hi}]\end{aligned}}\;(\iota_{\longrightarrow}) \\[2em]
\frac{\Sigma \vdash t \longrightarrow t'}{\Sigma \vdash \mathsf{rec}_{r;\ \varsigma;\ \chi}\ T\ t\ \mathsf{return}\ \bar C : \kappa_C\ \mathsf{with}\ \bar u \longrightarrow \mathsf{rec}_{r;\ \varsigma;\ \chi}\ T\ t'\ \mathsf{return}\ \bar C : \kappa_C\ \mathsf{with}\ \bar u}\;(\mathsf{rec}_{\longrightarrow}) \\[2em]
\frac{\begin{aligned}& {\in} \\ & \quad \mathsf{codata}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa \\ & \qquad \mathsf{where} \\ & \qquad \quad D_1 \mathrel{▶} \zeta_1 \oplus \Pi_1 \mathrel{≔} \bar d_1; \\ & \qquad \quad \dots; \\ & \qquad \quad D_k \mathrel{▶} \zeta_k \oplus \Pi_k \mathrel{≔} \bar d_k \\ & \quad \Sigma \\[0.6em] & \bar g = (D_1.d_{11}(;\ \bar y_1;\ \bar z_{11}) \Rightarrow g_{11},\ \dots,\ D_k.d_{kn_k}(;\ \bar y_k;\ \bar z_{kn_k}) \Rightarrow g_{kn_k}) \\[0.6em] & \bar s',\ \bar l',\ \bar p' \text{ as many as } \bar s,\ \bar l,\ \bar p \\[0.6em] & \bar t \text{ as many as } \bar y_h \\[0.6em] & \bar u \text{ as many as } \bar z_{hi}\end{aligned}}{\begin{aligned}& \Sigma \\ & {\vdash}\ (\mathsf{corec}_r\ (D_h.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a)\ \mathsf{from}\ \bar t\ \mathsf{return}\ \bar\Theta\ \mathsf{with}\ \bar g).(T.d_{hi})(\bar u) \\ & {\longrightarrow}\ \mathsf{resume}_{B_{hi};\ r;\ \chi_{hi}}(g_{hi}[\bar t / \bar y_h,\ \bar u / \bar z_{hi}],\ D_h.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a : \kappa',\ \bar\Theta,\ \bar g)\end{aligned}}\;(\beta_{\longrightarrow}) \\[2em]
\frac{\Sigma \vdash t \longrightarrow t'}{\Sigma \vdash t.(T.d)(\bar t) \longrightarrow t'.(T.d)(\bar t)}\;(d_{\longrightarrow})
\end{gathered}
```

A term is neutral when its reduction is stuck on a variable or on a declared constant, which has no body to unfold, or a recursor or an observation of a neutral term, and a head normal form when it is a sort, an instance of a declared type, a constructor applied to the terms of its fields, which it does not compute, a corecursor, which computes only when it is observed, an equality $`{t \mathrel{{\sim}.\{s;\ l\}_A} u}`$, which no rule computes, whatever its type and its terms, or a neutral term; a recursor on a neutral term of a type with a single constructor is neutral too, since the reduction does not apply $`(\eta_c)`$, which only the [equality](15-typing.md) gives:

```math
\begin{aligned}
& {\mathrel{::=}} &&(\mathsf{neutral}_t) \\
& \quad \text{a neutral term in } \Sigma \\
& \quad {\mid} \\
& \qquad x[\bar t] \\
& \qquad f.\{\bar s';\ \bar l';\ \bar p'\} \text{ if } (f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p) \in \Sigma \\
& \qquad \mathsf{rec}_{r;\ \varsigma;\ \chi}\ T\ n\ \mathsf{return}\ \bar C : \kappa_C\ \mathsf{with}\ \bar u \text{ if } n \text{ is a neutral term in } \Sigma \\
& \qquad n.(T.d)(\bar t) \text{ if } n \text{ is a neutral term in } \Sigma \\[1em]
& {\mathrel{::=}} &&(\mathsf{whnf}_t) \\
& \quad \text{a head normal form in } \Sigma \\
& \quad {\mid} \\
& \qquad \kappa \\
& \qquad D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a \\
& \qquad (D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a).c(\bar t) \\
& \qquad \mathsf{corec}_r\ (D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a)\ \mathsf{from}\ \bar t\ \mathsf{return}\ \bar\Theta\ \mathsf{with}\ \bar g \\
& \qquad t \mathrel{{\sim}.\{s;\ l\}_A} u \\
& \qquad \text{a neutral term in } \Sigma
\end{aligned}
```

The judgment $`{\Sigma \vdash t \longrightarrow^{*} u}`$ reads: $`t`$ reduces to $`u`$ in some steps, none or a step followed by the others:

```math
\begin{gathered}
\frac{}{\Sigma \vdash t \longrightarrow^{*} t}\;({\longrightarrow^{*}}.\mathsf{refl}) \\[2em]
\frac{\begin{aligned}& \Sigma \vdash t \longrightarrow u_1 \\[0.6em] & \Sigma \vdash u_1 \longrightarrow^{*} u_2\end{aligned}}{\Sigma \vdash t \longrightarrow^{*} u_2}\;({\longrightarrow^{*}}.\mathsf{step})
\end{gathered}
```

A closed term is a term in the empty scope without level variables.
The judgment $`{\Sigma \vdash t \Downarrow v}`$ reads: the closed term $`t`$ computes to the closed term $`v`$, a head normal form that it reduces to, stuck on no variable:

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

In a signature whose names are [distinct](08-syntax.md), as those of a well-formed signature are by $`(\mathsf{distinct}_\Sigma)`$, a head normal form does not reduce, since a declared constant has no body and a neutral term is neither a constructor nor a corecursor, and the reduction, its steps and the computation are deterministic, since a constant has one entry, a constructor one position in the block of its type, the terms of its fields the recursive results of one sequence of terms at most, by $`(\mathsf{unique}_{\mathsf{res}\Theta})`$ of the [recursive results](14-recursive-results.md#properties), and a destructor one position in the block of the type of a corecursor:

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
