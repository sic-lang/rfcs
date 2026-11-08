# Ownership

This annex defines the judgment of ownership, which checks the ownership of the value of a term, in a mode.
It builds on the [grades](03-grades.md), the [modes](04-modes.md) and the [syntax](07-syntax.md).

## Definitions

The judgment $`\Sigma;\ \varphi \vdash t \mathrel{◀} p;\ m`$ reads: checked in the mode $`m`$, the value of the term $`t`$ has the ownership $`p`$, given the ownership $`\varphi`$ of each variable of its scope whose telescope is empty.
The judgment $`\Sigma;\ \varphi \vdash \bar t \mathrel{◀} \bar o;\ \Theta;\ m`$ reads: checked in the mode $`m`$, the arguments $`\bar t`$ of the telescope $`\Theta`$ have the ownerships $`\bar o`$, each satisfying the requirement of its entry.

Ownership is defined on the term and the signature alone, without a context, as usage is: the scope gives each second-order variable its telescope and the ownership $`\psi`$ of its result, and the signature gives each constant its ownership.
Unlike the vector of the usage, which each premise computes and the conclusion adds, $`\varphi`$ is the same in every premise, as the context of the typing is.
The ownership of the instances of the declared types, and of the terms that build and use them, is given by the kinds of type declarations, in their annexes.

The value of the ownership $`\psi`$ of the result of a second-order variable, given the ownerships $`\bar o`$ of its arguments, written $`\psi[\bar o / \bar x]`$ where $`\bar x`$ are the variables of its telescope, is the meet of its constant and of its terms, each variable taking the ownership of its argument.
The constant and the terms being optional, the value may be undefined: a meet with an undefined operand is its other operand, and an absent constant is undefined.
The variables are read in order, and $`\psi'`$ is $`\psi`$ without its term in $`x`$:

```math
\begin{aligned}
& \psi[(o,\ \bar o) / (x,\ \bar x)] = o \cdot \chi \wedge \psi'[\bar o / \bar x] \text{ if } \psi \text{ has the term } x \cdot \chi &&(\mathsf{value}_\psi) \\
& \psi[(o,\ \bar o) / (x,\ \bar x)] = \psi[\bar o / \bar x] \\
& \psi[\bar o / \bar x] = \chi_0 \text{ otherwise}
\end{aligned}
```

A variable whose telescope is empty has the ownership that $`\varphi`$ gives it.
An application $`X[\bar t]`$ of a second-order variable has the value of the ownership of its result, when it is defined, given the ownerships of its arguments; each argument $`t_j`$ is checked in the mode $`m \odot p_j`$ of the grade $`p_j`$ of its entry, as for the usage, and its ownership satisfies the requirement $`r_j`$ of its entry unless this mode is $`{00}^{\mathsf{m}}`$, in which the argument is not used:

```math
\begin{gathered}
\frac{}{\Sigma;\ \varphi \vdash x \mathrel{◀} \varphi(x);\ m}\;(\mathsf{var}_{◀}) \\[1em]
\frac{\begin{gathered}{}X \text{ has the telescope } \Theta \text{ and the ownership } \psi \text{ in the scope of } X[\bar t] \\ \Sigma;\ \varphi \vdash \bar t \mathrel{◀} \bar o;\ \Theta;\ m \\ \psi[\bar o / \bar x] = p\end{gathered}}{\Sigma;\ \varphi \vdash X[\bar t] \mathrel{◀} p;\ m}\;(\mathsf{var}_{X◀}) \\[1em]
\frac{}{\Sigma;\ \varphi \vdash () \mathrel{◀} ();\ \varepsilon;\ m}\;(\mathsf{tel}_{\varepsilon◀}) \\[1em]
\frac{\begin{gathered}{}\Sigma;\ \varphi \vdash t \mathrel{◀} o;\ m \odot p \\ \Sigma;\ \varphi \vdash \bar t \mathrel{◀} \bar o;\ \Theta;\ m \\ r \le o \text{ if } m \odot p \ne {00}^{\mathsf{m}}\end{gathered}}{\Sigma;\ \varphi \vdash (t,\ \bar t) \mathrel{◀} (o,\ \bar o);\ (x : A \mathrel{▶} p;\ q \mathrel{◀} r,\ \Theta);\ m}\;(\mathsf{tel}_{,◀})
\end{gathered}
```

A constant, defined or declared, has the ownership of its entry, in every mode.
A sort has the least ownership, $`{\omega\omega}^{\mathsf{p}}`$, which states nothing:

```math
\begin{gathered}
\frac{f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m_2 \mathrel{◀} p \in \Sigma}{\Sigma;\ \varphi \vdash f.\{\bar s';\ \bar l';\ \bar p'\} \mathrel{◀} p;\ m_1}\;(f_{◀}) \\[1em]
\frac{}{\Sigma;\ \varphi \vdash \kappa \mathrel{◀} {\omega\omega}^{\mathsf{p}};\ m}\;(\kappa_{◀})
\end{gathered}
```

A term may be given an ownership lower than its own, which states less:

```math
\frac{\begin{gathered}{}\Sigma;\ \varphi \vdash t \mathrel{◀} p;\ m \\ q \le p\end{gathered}}{\Sigma;\ \varphi \vdash t \mathrel{◀} q;\ m}\;(\mathsf{sub}_{◀})
```
