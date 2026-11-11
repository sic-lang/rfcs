# Usage

This annex defines the judgment of usage, which checks how a term uses the variables of its scope, in a mode, and its properties.
It builds on the [modes](05-modes.md), the [syntax](08-syntax.md), the [substitution](09-substitution.md) and the [grade vectors](10-grade-vectors.md).

## Definitions

The judgment $`\Sigma;\ \gamma \vdash t \mathrel{▶} m`$ reads: checked in the mode $`m`$, the term $`t`$ uses each variable of its scope as the grade that the vector $`\gamma`$, over this scope, gives it allows.
The judgment $`\Sigma;\ \gamma \vdash \bar t \mathrel{▶} \bar p;\ m`$ reads: checked in the mode $`m`$, the arguments $`\bar t`$ of a telescope whose grades are $`\bar p`$ use the variables of their scope as $`\gamma`$ allows.
The judgment $`\Sigma;\ \gamma \vdash \bar a \mathrel{▶} \zeta;\ m`$ reads: checked in the mode $`m`$, the arguments $`\bar a`$ of an instance whose type uses its parameters with the grades $`\zeta`$ use the variables of their scope as $`\gamma`$ allows.
The judgment $`\Sigma;\ \gamma \vdash \Theta \mathrel{▶} m`$ reads: checked in the mode $`m`$, the types of the telescope $`\Theta`$ use the variables of its scope as $`\gamma`$ allows, the judgment $`\Sigma;\ \gamma \vdash \bar c \mathrel{▶} m`$ likewise for the telescopes of the fields of the constructors $`\bar c`$ of a data type, and the judgment $`\Sigma;\ \gamma \vdash \bar d \mathrel{▶} m`$ likewise for the arguments and the results of the destructors $`\bar d`$ of a codata type, which the [formation](13-typing.md#type-declarations) of the type declarations reads.

Usage is defined on the term and the signature alone, without a context: the scope gives each variable the grades of its telescope, with which an application uses its arguments, and the signature gives each constant its mode.
The signature also gives each declared type the grades $`\zeta`$ with which it uses its parameters, each constructor the grades of its fields, which the usage of the constructors and of the recursors reads at their instance, and each destructor its grade and the grades of its arguments, which the usage of the observations reads at their instance.

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
\frac{\begin{gathered}{}D.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa \mathrel{▶} \zeta \in \Sigma \\ \bar s',\ \bar p' \text{ as many as } \bar s,\ \bar p \\ \Sigma;\ \delta \vdash \bar a \mathrel{▶} \zeta[\bar s' / \bar s,\ \bar p' / \bar p];\ m\end{gathered}}{\Sigma;\ \delta \vdash D.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a \mathrel{▶} m}\;(D_{▶}) \\[1em]
\frac{\begin{gathered}{}(\mathsf{data}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa\ \mathsf{where}\ \dots;\ D \mathrel{▶} \zeta \mathrel{≔} \dots \mid c : \Theta \mid \dots;\ \dots) \in \Sigma \\ \bar s',\ \bar p' \text{ as many as } \bar s,\ \bar p \\ \Theta[\bar s' / \bar s,\ \bar p' / \bar p] \text{ has the grades } \bar q \\ \Sigma;\ \gamma \vdash \bar t \mathrel{▶} \bar q;\ m\end{gathered}}{\Sigma;\ \gamma \vdash (D.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a).c(\bar t) \mathrel{▶} m}\;(c_{▶}) \\[1em]
\frac{}{\Sigma;\ {00}^{\gamma} \vdash () \mathrel{▶} \zeta;\ m}\;(\mathsf{arg}_{\varepsilon▶}) \\[1em]
\frac{\begin{gathered}{}\Sigma;\ \gamma \vdash \bar a \mathrel{▶} \zeta;\ m \\ \Sigma;\ \delta \vdash a \mathrel{▶} m \odot p\end{gathered}}{\Sigma;\ \gamma +^{\gamma} (p \cdot^{\gamma} \delta) \vdash (\bar a,\ a) \mathrel{▶} \zeta \bullet p;\ m}\;(\mathsf{arg}_{x▶}) \\[1em]
\frac{\begin{gathered}{}\Sigma;\ \gamma \vdash \bar a \mathrel{▶} \zeta;\ m \\ X \text{, the parameter of } \bar x.\, B \text{, has the grades } p_1, \dots, p_n \\ \Sigma;\ \delta \bullet (\ulcorner m \odot p \urcorner \cdot p_1) \bullet \dots \bullet (\ulcorner m \odot p \urcorner \cdot p_n) \vdash B \mathrel{▶} m \odot p\end{gathered}}{\Sigma;\ \gamma +^{\gamma} (p \cdot^{\gamma} \delta) \vdash (\bar a,\ \bar x.\, B) \mathrel{▶} \zeta \bullet p;\ m}\;(\mathsf{arg}_{X▶})
\end{gathered}
```

A recursor, written as in its [typing](13-typing.md#terms), uses the variables of its term $`r`$ times, the term checked in the mode $`m \odot r`$, and those of its branches, as the eliminations of the pairs and of the natural numbers without $`\mathsf{nr}`$ of [Abel, Danielsson and Eriksson](https://github.com/graded-type-theory/graded-type-theory/blob/1f720ee636cb16aec130cc1ddc1c32acea8809d0/Graded/Usage.agda) do.
Each branch uses the variables of the scope as $`\delta_{ji}`$, the variable of its field $`x_{jil}`$ with the grade $`g_{jil}`$ and that of the recursive result of a recursive field with the grade $`e_{jil}`$ that the branch gives it in its grades $`\bar e_{ji}`$, those of the recursive fields in order, the grade $`e_{jil}`$ of a field that is not recursive being $`0`$.
A use of the recursive result of a field runs the recursor on the field again, which uses the field $`r`$ times and the variables of the scope as $`\chi`$: the uses of a field and of its recursive result must cover $`\ulcorner m \urcorner \cdot r`$ times the grade of the field, and $`\chi`$ the uses of each branch and of its recursive results, since one branch runs at each step.
Its motives, which are types, use no variable, checked in the mode $`{00}^{\mathsf{m}}`$; in the mode $`{11}^{\mathsf{m}}`$, a recursor on a block of which a type has two constructors or more uses its term at run time, since the constructor of the term chooses the branch that runs:

```math
\frac{\begin{gathered}{}\mathcal{D} = (\mathsf{data}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} \bar c_1;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \bar c_k) \in \Sigma \\ \bar s',\ \bar p' \text{ as many as } \bar s,\ \bar p \\ \forall j.\ \Sigma;\ {00}^{\gamma} \vdash C_j \mathrel{▶} {00}^{\mathsf{m}} \\ \Sigma;\ \gamma \vdash t \mathrel{▶} m \odot r \\ \forall j, i.\ \Theta_{ji}[\bar s' / \bar s,\ \bar p' / \bar p] \text{ has the grades } q_{ji1}, \dots, q_{jik_{ji}} \\ \bar u = (D_1.c_{11}(\bar x_{11};\ \bar y_{11} \mathrel{▶} \bar e_{11}) \Rightarrow u_{11},\ \dots,\ D_k.c_{kn_k}(\bar x_{kn_k};\ \bar y_{kn_k} \mathrel{▶} \bar e_{kn_k}) \Rightarrow u_{kn_k}) \\ \forall j, i.\ \bar e_{ji} \text{ are the grades } e_{jil} \text{ at the positions } l \text{ at which } \mathsf{rec}_{\mathcal{D}}(\Theta_{ji}) \text{ is not } \bot \text{, in order} \\ \forall j, i, l.\ e_{jil} = 0 \text{ if } \mathsf{rec}_{\mathcal{D}}(\Theta_{ji}) \text{ is } \bot \text{ at } l \\ \forall j, i.\ \Sigma;\ \delta_{ji} \bullet g_{ji1} \bullet \dots \bullet g_{jik_{ji}} \bullet \bar e_{ji} \vdash u_{ji} \mathrel{▶} m \\ \forall j, i, l.\ \ulcorner m \urcorner \cdot r \cdot q_{jil} \le g_{jil} + e_{jil} \cdot r \\ \forall j, i.\ \chi \le^{\gamma} \delta_{ji} +^{\gamma} (e_{ji1} + \dots + e_{jik_{ji}}) \cdot^{\gamma} \chi \\ \llcorner r \lrcorner = {11}^{\mathsf{m}} \text{ if } m = {11}^{\mathsf{m}} \text{ and one of } \bar c_1, \dots, \bar c_k \text{ has two constructors or more}\end{gathered}}{\Sigma;\ (r \cdot^{\gamma} \gamma) +^{\gamma} \chi \vdash \mathsf{rec}_r\ (D_h.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a)\ t\ \mathsf{return}\ \bar C\ \mathsf{with}\ \bar u \mathrel{▶} m}\;(\mathsf{rec}_{▶})
```

An observation, written as in its [typing](13-typing.md#terms), uses the variables of its term once, the term checked in the mode $`m`$, and those of its arguments as the arguments of the telescope of the destructor at the instance do, and the instance it carries uses none; the mode must allow the grade $`p`$ of the destructor, as the mode of a constant must, so that a result without use at run time is observed only in a term without use at run time:

```math
\frac{\begin{gathered}{}(\mathsf{codata}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa\ \mathsf{where}\ \dots;\ D \mathrel{▶} \zeta \mathrel{≔} \bar d;\ \dots) \in \Sigma \\ \bar s',\ \bar p' \text{ as many as } \bar s,\ \bar p \\ \bar d[\bar s' / \bar s,\ \bar p' / \bar p] = (\bar d_1 \mid d : (\Theta \vdash B \mathrel{◀} \psi) \mathrel{▶} p;\ q \mid \bar d_2) \\ \Theta \text{ has the grades } p_1, \dots, p_n \\ \Sigma;\ \gamma \vdash t \mathrel{▶} m \\ \Sigma;\ \delta \vdash \bar t \mathrel{▶} p_1, \dots, p_n;\ m \\ m \cdot^{\mathsf{m}} \llcorner p \lrcorner = m\end{gathered}}{\Sigma;\ \gamma +^{\gamma} \delta \vdash t.((D.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a).d)(\bar t) \mathrel{▶} m}\;(d_{▶})
```

A corecursor, written as in its [typing](13-typing.md#terms), uses the variables of its state $`r`$ times, the state checked in the mode $`m \odot r`$ as arguments of the state of its type, and those of its branches, each checked in the mode $`m_{ji} = m \odot p_{ji}`$ of the grade of its destructor, with uses $`\delta_{ji}`$ counted $`p_{ji}`$ times: an observation runs one branch, so that the corecursor uses the variables as a lower bound $`\delta`$ of these uses allows, as the eliminations of the pairs of [Abel, Danielsson and Eriksson](https://github.com/graded-type-theory/graded-type-theory/blob/1f720ee636cb16aec130cc1ddc1c32acea8809d0/Graded/Usage.agda) share the uses of their branches.
Each branch uses the variable of an entry of the state as $`\ulcorner m_{ji} \urcorner \cdot r`$ times the grade of the entry allows, and that of an argument as $`\ulcorner m_{ji} \urcorner`$ times the grade of its entry allows, as the result of a destructor uses its arguments; its states, which are types, use no variable, checked in the mode $`{00}^{\mathsf{m}}`$, and the instance it carries uses none:

```math
\frac{\begin{gathered}{}(\mathsf{codata}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} \bar d_1;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \bar d_k) \in \Sigma \\ \bar s',\ \bar p' \text{ as many as } \bar s,\ \bar p \\ \forall j.\ \Sigma;\ {00}^{\gamma} \vdash \Theta_j \mathrel{▶} {00}^{\mathsf{m}} \\ \forall j.\ \Theta_j \text{ has the grades } q_{j1}, \dots, q_{jn_j} \\ \Sigma;\ \gamma \vdash \bar t \mathrel{▶} q_{h1}, \dots, q_{hn_h};\ m \odot r \\ \forall j, i.\ \bar d_j[\bar s' / \bar s,\ \bar p' / \bar p] = (\bar d_{ji,1} \mid d_{ji} : (\Theta_{ji} \vdash B_{ji} \mathrel{◀} \psi_{ji}) \mathrel{▶} p_{ji};\ q'_{ji} \mid \bar d_{ji,2}) \\ \forall j, i.\ \Theta_{ji} \text{ has the grades } p_{ji1}, \dots, p_{jia_{ji}} \\ \forall j, i.\ \Sigma;\ \delta_{ji} \bullet (\ulcorner m_{ji} \urcorner \cdot r \cdot q_{j1}) \bullet \dots \bullet (\ulcorner m_{ji} \urcorner \cdot r \cdot q_{jn_j}) \bullet (\ulcorner m_{ji} \urcorner \cdot p_{ji1}) \bullet \dots \bullet (\ulcorner m_{ji} \urcorner \cdot p_{jia_{ji}}) \vdash g_{ji} \mathrel{▶} m_{ji} \\ \forall j, i.\ \delta \le^{\gamma} p_{ji} \cdot^{\gamma} \delta_{ji}\end{gathered}}{\Sigma;\ (r \cdot^{\gamma} \gamma) +^{\gamma} \delta \vdash \mathsf{corec}_r\ (D_h.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a)\ \mathsf{from}\ \bar t\ \mathsf{return}\ \bar\Theta\ \mathsf{with}\ \bar g \mathrel{▶} m}\;(\mathsf{corec}_{▶})
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

The destructors $`\bar d`$ of a codata type, $`d_1 : (\Theta_1 \vdash B_1 \mathrel{◀} \psi_1) \mathrel{▶} p_1;\ q_1 \mid \dots \mid d_n : (\Theta_n \vdash B_n \mathrel{◀} \psi_n) \mathrel{▶} p_n;\ q_n`$, or $`\varepsilon`$ when there is none, use the variables as the entries of a telescope do, each destructor as one entry: its arguments and its result count their uses as many times as its grade $`p`$ says, checked in the mode $`m' = m \odot p`$, its result using each argument $`x_i`$ of $`\Theta`$ as $`\ulcorner m' \urcorner \cdot q_i`$ allows, as the types after the entry of $`x_i`$ do, and the destructors after it use $`d`$ as $`\ulcorner m \urcorner \cdot q`$ allows; destructors may be given grades lower than their uses, as a telescope may:

```math
\begin{gathered}
\frac{}{\Sigma;\ {00}^{\gamma} \vdash \varepsilon \mathrel{▶} m}\;(\bar d_{\varepsilon▶}) \\[1em]
\frac{\begin{gathered}{}\Sigma;\ \gamma \vdash \Theta \mathrel{▶} m \odot p \\ \Theta = (x_1 : A_1 \mathrel{▶} p_1;\ q_1 \mathrel{◀} r_1,\ \dots,\ x_n : A_n \mathrel{▶} p_n;\ q_n \mathrel{◀} r_n) \\ \Sigma;\ \delta \bullet (\ulcorner m \odot p \urcorner \cdot q_1) \bullet \dots \bullet (\ulcorner m \odot p \urcorner \cdot q_n) \vdash B \mathrel{▶} m \odot p \\ \Sigma;\ \eta \bullet (\ulcorner m \urcorner \cdot q) \vdash \bar d \mathrel{▶} m\end{gathered}}{\Sigma;\ (p \cdot^{\gamma} (\gamma +^{\gamma} \delta)) +^{\gamma} \eta \vdash (d : (\Theta \vdash B \mathrel{◀} \psi) \mathrel{▶} p;\ q \mid \bar d) \mathrel{▶} m}\;(\bar d_{|▶}) \\[1em]
\frac{\begin{gathered}{}\Sigma;\ \gamma \vdash \bar d \mathrel{▶} m \\ \delta \le^{\gamma} \gamma\end{gathered}}{\Sigma;\ \delta \vdash \bar d \mathrel{▶} m}\;(\mathsf{sub}_{\bar d▶})
\end{gathered}
```

## Properties

Usage is stable under the [renamings](09-substitution.md#renamings): renamed, a term uses the variables as the [vector renamed](10-grade-vectors.md) allows, and the arguments of an instance keep the grades of their parameters, which the renaming does not change:

```math
\begin{aligned}
& \Sigma;\ \gamma \vdash t \mathrel{▶} m \implies \Sigma;\ \gamma[\xi] \vdash t[\xi] \mathrel{▶} m &&(\mathsf{ren}_{▶}.t) \\[1em]
& \Sigma;\ \gamma \vdash \bar t \mathrel{▶} \bar p;\ m \implies \Sigma;\ \gamma[\xi] \vdash \bar t[\xi] \mathrel{▶} \bar p;\ m &&(\mathsf{ren}_{▶}.\bar t) \\[1em]
& \Sigma;\ \gamma \vdash \bar a \mathrel{▶} \zeta;\ m \implies \Sigma;\ \gamma[\xi] \vdash \bar a[\xi] \mathrel{▶} \zeta;\ m &&(\mathsf{ren}_{▶}.\bar a) \\[1em]
& \Sigma;\ \gamma \vdash \Theta \mathrel{▶} m \implies \Sigma;\ \gamma[\xi] \vdash \Theta[\xi] \mathrel{▶} m &&(\mathsf{ren}_{▶}.\Theta)
\end{aligned}
```
