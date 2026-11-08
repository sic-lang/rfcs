# Usage

This annex defines the judgment of usage, which checks how a term uses the variables of its scope, in a mode.
It builds on the [modes](04-modes.md), the [syntax](07-syntax.md) and the [grade vectors](09-grade-vectors.md).

## Definitions

The judgment $`\Sigma;\ \gamma \vdash t \mathrel{▶} m`$ reads: checked in the mode $`m`$, the term $`t`$ uses each variable of its scope as the grade that the vector $`\gamma`$, over this scope, gives it allows.
The judgment $`\Sigma;\ \gamma \vdash \bar t \mathrel{▶} \bar p;\ m`$ reads: checked in the mode $`m`$, the arguments $`\bar t`$ of a telescope whose grades are $`\bar p`$ use the variables of their scope as $`\gamma`$ allows.

Usage is defined on the term and the signature alone, without a context: the scope gives each variable the grades of its telescope, with which an application uses its arguments, and the signature gives each constant its mode.
The usage of the instances of the declared types, and of the terms that build and use them, is given by the kinds of type declarations, in their annexes.

An application $`x[\bar t]`$ uses $`x`$ with the grade of the mode, and each argument $`t_j`$ with the grade $`p_j`$ of its entry, checked in the mode $`m \odot p_j`$; a variable with an empty telescope uses itself only:

```math
\begin{gathered}
\frac{\begin{gathered}{}x \text{ has the grades } \bar p \text{ in the scope of } x[\bar t] \\ \Sigma;\ \delta \vdash \bar t \mathrel{▶} \bar p;\ m\end{gathered}}{\Sigma;\ ({00}^{\gamma},\ x \mathrel{≔} \ulcorner m \urcorner) +^{\gamma} \delta \vdash x[\bar t] \mathrel{▶} m}\;(\mathsf{var}_{X\mathsf{m}}) \\[1em]
\frac{}{\Sigma;\ {00}^{\gamma} \vdash () \mathrel{▶} ();\ m}\;(\mathsf{tel}_{\varepsilon\mathsf{m}}) \\[1em]
\frac{\begin{gathered}{}\Sigma;\ \gamma \vdash t \mathrel{▶} m \odot p \\ \Sigma;\ \delta \vdash \bar t \mathrel{▶} \bar p;\ m\end{gathered}}{\Sigma;\ (p \cdot^{\gamma} \gamma) +^{\gamma} \delta \vdash (t,\ \bar t) \mathrel{▶} (p,\ \bar p);\ m}\;(\mathsf{tel}_{,\mathsf{m}})
\end{gathered}
```

A constant, defined or declared, uses no variable, in a mode $`m_1`$ that the mode $`m_2`$ of its entry allows, which $`m_1 \cdot^{\mathsf{m}} m_2 = m_1`$ states: a constant of the mode $`{00}^{\mathsf{m}}`$ is used in this mode only, one of the mode $`{01}^{\mathsf{m}}`$ in the modes $`{00}^{\mathsf{m}}`$ and $`{01}^{\mathsf{m}}`$, and one of the mode $`{11}^{\mathsf{m}}`$ in every mode.
A sort uses no variable:

```math
\begin{gathered}
\frac{\begin{gathered}{}f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m_2 \in \Sigma \\ m_1 \cdot^{\mathsf{m}} m_2 = m_1\end{gathered}}{\Sigma;\ {00}^{\gamma} \vdash f.\{\bar s';\ \bar l';\ \bar p'\} \mathrel{▶} m_1}\;(f_{\mathsf{m}}) \\[1em]
\frac{}{\Sigma;\ {00}^{\gamma} \vdash \kappa \mathrel{▶} m}\;(\kappa_{\mathsf{m}})
\end{gathered}
```

A term may be given grades lower than its uses:

```math
\frac{\begin{gathered}{}\Sigma;\ \gamma \vdash t \mathrel{▶} m \\ \delta \le^{\gamma} \gamma\end{gathered}}{\Sigma;\ \delta \vdash t \mathrel{▶} m}\;(\mathsf{sub})
```
