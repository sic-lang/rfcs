# Usage

This annex defines the judgment of usage, which checks how a term uses the variables of its scope, in a mode.
It builds on the [modes](05-modes.md), the [syntax](08-syntax.md) and the [grade vectors](10-grade-vectors.md).

## Definitions

The judgment $`\Sigma;\ \gamma \vdash t \mathrel{▶} m`$ reads: checked in the mode $`m`$, the term $`t`$ uses each variable of its scope as the grade that the vector $`\gamma`$, over this scope, gives it allows.
The judgment $`\Sigma;\ \gamma \vdash \bar t \mathrel{▶} \bar p;\ m`$ reads: checked in the mode $`m`$, the arguments $`\bar t`$ of a telescope whose grades are $`\bar p`$ use the variables of their scope as $`\gamma`$ allows.
The judgment $`\Sigma;\ \gamma \vdash \bar a \mathrel{▶} \zeta;\ m`$ reads: checked in the mode $`m`$, the arguments $`\bar a`$ of an instance whose type uses its parameters with the grades $`\zeta`$ use the variables of their scope as $`\gamma`$ allows.
The judgment $`\Sigma;\ \gamma \vdash \Theta \mathrel{▶} m`$ reads: checked in the mode $`m`$, the types of the telescope $`\Theta`$ use the variables of its scope as $`\gamma`$ allows, and the judgment $`\Sigma;\ \gamma \vdash \bar c \mathrel{▶} m`$ likewise for the telescopes of the fields of the constructors $`\bar c`$ of a data type, which the [formation](13-typing.md#type-declarations) of the type declarations reads.

Usage is defined on the term and the signature alone, without a context: the scope gives each variable the grades of its telescope, with which an application uses its arguments, and the signature gives each constant its mode.
The signature also gives each declared type the grades $`\zeta`$ with which it uses its parameters, and each constructor the grades of its fields; the usage of the recursors comes with their typing.

An application $`x[\bar t]`$ uses $`x`$ with the grade of the mode, and each argument $`t_j`$ with the grade $`p_j`$ of its entry, checked in the mode $`m \odot p_j`$; a variable with an empty telescope uses itself only:

```math
\begin{gathered}
\frac{\begin{gathered}{}x \text{ has the grades } \bar p \text{ in the scope of } x[\bar t] \\ \Sigma;\ \delta \vdash \bar t \mathrel{▶} \bar p;\ m\end{gathered}}{\Sigma;\ ({00}^{\gamma},\ x \mathrel{≔} \ulcorner m \urcorner) +^{\gamma} \delta \vdash x[\bar t] \mathrel{▶} m}\;(\mathsf{var}_{X▶}) \\[1em]
\frac{}{\Sigma;\ {00}^{\gamma} \vdash () \mathrel{▶} ();\ m}\;(\mathsf{tel}_{\varepsilon▶}) \\[1em]
\frac{\begin{gathered}{}\Sigma;\ \gamma \vdash t \mathrel{▶} m \odot p \\ \Sigma;\ \delta \vdash \bar t \mathrel{▶} \bar p;\ m\end{gathered}}{\Sigma;\ (p \cdot^{\gamma} \gamma) +^{\gamma} \delta \vdash (t,\ \bar t) \mathrel{▶} (p,\ \bar p);\ m}\;(\mathsf{tel}_{,▶})
\end{gathered}
```

A constant, defined or declared, uses no variable, in a mode $`m_1`$ that the mode $`m_2`$ of its entry allows, which $`m_1 \cdot^{\mathsf{m}} m_2 = m_1`$ states: a constant of the mode $`{00}^{\mathsf{m}}`$ is used in this mode only, one of the mode $`{01}^{\mathsf{m}}`$ in the modes $`{00}^{\mathsf{m}}`$ and $`{01}^{\mathsf{m}}`$, and one of the mode $`{11}^{\mathsf{m}}`$ in every mode.
A sort uses no variable:

```math
\begin{gathered}
\frac{\begin{gathered}{}f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m_2 \mathrel{◀} p \in \Sigma \\ m_1 \cdot^{\mathsf{m}} m_2 = m_1\end{gathered}}{\Sigma;\ {00}^{\gamma} \vdash f.\{\bar s';\ \bar l';\ \bar p'\} \mathrel{▶} m_1}\;(f_{▶}) \\[1em]
\frac{}{\Sigma;\ {00}^{\gamma} \vdash \kappa \mathrel{▶} m}\;(\kappa_{▶})
\end{gathered}
```

An instance of a declared type uses the variables of its arguments as many times as its type uses its parameters, as its grades $`\zeta`$ at the instance say, each argument checked in the mode of its grade, as the application of a second-order variable uses its arguments; a constructor uses the variables of its fields as the arguments of its telescope at the instance do, and the instance that it carries uses none; the abstraction $`\bar x.\, B`$ for a second-order parameter uses the variables $`\bar x`$ of its telescope as their grades allow, in the mode of its term:

```math
\begin{gathered}
\frac{\begin{gathered}{}D.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa \mathrel{▶} \zeta \in \Sigma \\ \bar s',\ \bar p' \text{ as many as } \bar s,\ \bar p \\ \Sigma;\ \delta \vdash \bar a \mathrel{▶} \zeta[\bar s' / \bar s,\ \bar p' / \bar p];\ m\end{gathered}}{\Sigma;\ \delta \vdash D.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a \mathrel{▶} m}\;(D_{▶}) \\[1em]
\frac{\begin{gathered}{}(\mathsf{data}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ \dots;\ D \mathrel{▶} \zeta \mathrel{≔} \dots \mid c : \Theta \mid \dots;\ \dots) \in \Sigma \\ \bar s',\ \bar p' \text{ as many as } \bar s,\ \bar p \\ \Theta[\bar s' / \bar s,\ \bar p' / \bar p] \text{ has the grades } \bar q \\ \Sigma;\ \gamma \vdash \bar t \mathrel{▶} \bar q;\ m\end{gathered}}{\Sigma;\ \gamma \vdash (D.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a).c(\bar t) \mathrel{▶} m}\;(c_{▶}) \\[1em]
\frac{}{\Sigma;\ {00}^{\gamma} \vdash () \mathrel{▶} \zeta;\ m}\;(\mathsf{arg}_{\varepsilon▶}) \\[1em]
\frac{\begin{gathered}{}\Sigma;\ \gamma \vdash \bar a \mathrel{▶} \zeta;\ m \\ \Sigma;\ \delta \vdash a \mathrel{▶} m \odot p\end{gathered}}{\Sigma;\ \gamma +^{\gamma} (p \cdot^{\gamma} \delta) \vdash (\bar a,\ a) \mathrel{▶} \zeta \bullet p;\ m}\;(\mathsf{arg}_{x▶}) \\[1em]
\frac{\begin{gathered}{}\Sigma;\ \gamma \vdash \bar a \mathrel{▶} \zeta;\ m \\ X \text{, the parameter of } \bar x.\, B \text{, has the grades } p_1, \dots, p_n \\ \Sigma;\ \delta \bullet (\ulcorner m \odot p \urcorner \cdot p_1) \bullet \dots \bullet (\ulcorner m \odot p \urcorner \cdot p_n) \vdash B \mathrel{▶} m \odot p\end{gathered}}{\Sigma;\ \gamma +^{\gamma} (p \cdot^{\gamma} \delta) \vdash (\bar a,\ \bar x.\, B) \mathrel{▶} \zeta \bullet p;\ m}\;(\mathsf{arg}_{X▶})
\end{gathered}
```

A term may be given grades lower than its uses:

```math
\frac{\begin{gathered}{}\Sigma;\ \gamma \vdash t \mathrel{▶} m \\ \delta \le^{\gamma} \gamma\end{gathered}}{\Sigma;\ \delta \vdash t \mathrel{▶} m}\;(\mathsf{sub}_{▶})
```

The types of a telescope use the variables of its scope as the types of the functions and of the pairs of [Abel, Danielsson and Eriksson](https://github.com/graded-type-theory/graded-type-theory/blob/1f720ee636cb16aec130cc1ddc1c32acea8809d0/Graded/Usage.agda#L363) do, entry by entry: the type of an entry counts its uses as many times as the grade $`p`$ of the entry says, checked in the mode $`m \odot p`$, and the types after it use the variable of the entry as $`\ulcorner m \urcorner \cdot q`$ allows, $`q`$ being its grade in these types; a telescope may be given grades lower than its uses, without which $`q`$ would have to be exactly the uses of the variable:

```math
\begin{gathered}
\frac{}{\Sigma;\ {00}^{\gamma} \vdash \varepsilon \mathrel{▶} m}\;(\Theta_{\varepsilon▶}) \\[1em]
\frac{\begin{gathered}{}\Sigma;\ \gamma \vdash A \mathrel{▶} m \odot p \\ \Sigma;\ \delta \bullet (\ulcorner m \urcorner \cdot q) \vdash \Theta \mathrel{▶} m\end{gathered}}{\Sigma;\ (p \cdot^{\gamma} \gamma) +^{\gamma} \delta \vdash (x : A \mathrel{▶} p;\ q \mathrel{◀} r,\ \Theta) \mathrel{▶} m}\;(\Theta_{,▶}) \\[1em]
\frac{\begin{gathered}{}\Sigma;\ \gamma \vdash \Theta \mathrel{▶} m \\ \delta \le^{\gamma} \gamma\end{gathered}}{\Sigma;\ \delta \vdash \Theta \mathrel{▶} m}\;(\mathsf{sub}_{\Theta▶})
\end{gathered}
```

The constructors $`\bar c`$ of a data type, $`c_1 : \Theta_1 \mid \dots \mid c_n : \Theta_n`$, or $`\varepsilon`$ when there is none, use the variables as the telescopes of their fields do, the uses of all the constructors added, since the type mentions all of them:

```math
\begin{gathered}
\frac{}{\Sigma;\ {00}^{\gamma} \vdash \varepsilon \mathrel{▶} m}\;(\bar c_{\varepsilon▶}) \\[1em]
\frac{\begin{gathered}{}\Sigma;\ \gamma \vdash \Theta \mathrel{▶} m \\ \Sigma;\ \delta \vdash \bar c \mathrel{▶} m\end{gathered}}{\Sigma;\ \gamma +^{\gamma} \delta \vdash (c : \Theta \mid \bar c) \mathrel{▶} m}\;(\bar c_{|▶})
\end{gathered}
```
