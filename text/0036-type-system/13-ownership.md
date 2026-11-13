# Ownership

This annex defines the judgment of ownership, which checks the ownership of the value of a term, in a mode, the ownership of the entries of a signature, and their properties.
It builds on the [grades](04-grades.md), the [modes](05-modes.md), the [syntax](08-syntax.md) and the [substitution](09-substitution.md).

## Definitions

The judgment $`{\Sigma;\ \varphi \vdash t \mathrel{◀} p;\ m}`$ reads: checked in the mode $`m`$, the value of the term $`t`$ has the ownership $`p`$, given the ownership $`\varphi`$ of each variable of its scope whose telescope is empty.
The judgment $`{\Sigma;\ \varphi \vdash \bar t \mathrel{◀} \bar o;\ \Theta;\ m}`$ reads: checked in the mode $`m`$, the arguments $`\bar t`$ of the telescope $`\Theta`$ have the ownerships $`\bar o`$, each satisfying the requirement of its entry.
The judgment $`{\vdash \Sigma \mathrel{◀}}`$ reads: the values of the entries of the signature $`\Sigma`$ have their ownerships.

Ownership is defined on the term and the signature alone, without a context, as usage is: the scope gives each second-order variable its telescope and the ownership $`\psi`$ of its result, and the signature gives each constant its ownership.
Unlike the vector of the usage, which each premise computes and the conclusion adds, $`\varphi`$ is the same in every premise, as the context of the typing is.
The declared types give the ownership of their instances, the data types that of their constructors and of their recursors, and the codata types that of their observations, below.

The value of the ownership $`\psi`$ of the result of a second-order variable, given the ownerships $`\bar o`$ of its arguments, written $`\psi[\bar o / \bar x]`$ where $`\bar x`$ are the variables of its telescope, is the meet of its constant and of its factors, each variable taking the ownership of its argument.
The constant and the factors being optional, the value may be undefined: a meet with an undefined operand is its other operand, and an absent constant is undefined.
The variables are read in order, and $`\psi'`$ is $`\psi`$ without the factor of $`x`$:

```math
\begin{aligned}
& \psi[(o,\ \bar o) / (x,\ \bar x)] = o \cdot \chi \wedge \psi'[\bar o / \bar x] \text{ if } x \text{ has the coefficient } \chi \text{ in } \psi &&(\mathsf{value}_\psi) \\
& \psi[(o,\ \bar o) / (x,\ \bar x)] = \psi[\bar o / \bar x] \\
& \psi[\bar o / \bar x] = \chi_0 \text{ otherwise}
\end{aligned}
```

A variable whose telescope is empty has the ownership that $`\varphi`$ gives it.
An application $`X[\bar t]`$ of a second-order variable has the value of the ownership of its result, when it is defined, given the ownerships of its arguments; each argument $`t_j`$ is checked in the mode $`{m \odot p_j}`$ of the grade $`p_j`$ of its entry, as for the usage, and its ownership satisfies the requirement $`r_j`$ of its entry unless this mode is $`{00}^{\mathsf{m}}`$, in which the argument is not used; each argument on whose variable $`\psi`$ has a factor is checked in the mode $`m`$ of the application, $`{m \odot p_j = m}`$, as for an observation, below:

```math
\begin{gathered}
\frac{}{\Sigma;\ \varphi \vdash x \mathrel{◀} \varphi(x);\ m}\;(\mathsf{var}_{◀}) \\[1em]
\frac{\begin{gathered}{}X \text{ has the telescope } \Theta \text{ and the ownership } \psi \text{ in the scope of } X[\bar t] \\ \Sigma;\ \varphi \vdash \bar t \mathrel{◀} \bar o;\ \Theta;\ m \\ \psi[\bar o / \bar x] = p \\ \Theta \text{ has the grades } p_1, \dots, p_n \\ \forall j.\ \psi \text{ has a factor of } x_j \implies m \odot p_j = m\end{gathered}}{\Sigma;\ \varphi \vdash X[\bar t] \mathrel{◀} p;\ m}\;(\mathsf{var}_{X◀}) \\[1em]
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

An instance of a declared type is a type, and has the least ownership, as a sort.
A constructor builds a new value, whose ownership is $`{11}^{\mathsf{p}}`$ whatever its fields: what the value holds is stated by the requirements of the entries of its fields, which its arguments satisfy, as those of a telescope, unless they are not used:

```math
\begin{gathered}
\frac{}{\Sigma;\ \varphi \vdash D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a \mathrel{◀} {\omega\omega}^{\mathsf{p}};\ m}\;(D_{◀}) \\[1em]
\frac{\begin{gathered}{}(\mathsf{data}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa\ \mathsf{where}\ \dots;\ D \mathrel{▶} \zeta \mathrel{≔} \dots \mid c : \Theta \mid \dots;\ \dots) \in \Sigma \\ \bar s',\ \bar p' \text{ as many as } \bar s,\ \bar p \\ \Sigma;\ \varphi \vdash \bar t \mathrel{◀} \bar o;\ \Theta[\bar s' / \bar s,\ \bar p' / \bar p];\ m\end{gathered}}{\Sigma;\ \varphi \vdash (D.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a).c(\bar t) \mathrel{◀} {11}^{\mathsf{p}};\ m}\;(c_{◀})
\end{gathered}
```

A variable that a recursor or a corecursor binds has the ownership of the value it receives times the grade with which its scope uses it, which the syntax gives, so that a value received once and used twice through its variable is shared, and the ownership reads no derivation of the usage.
A recursor, written as in its [typing](14-typing.md#terms), has the ownership of its branches, each checked with the ownership $`o`$ of the term times the requirement of the entry of each field, times the grade $`{\ulcorner m \urcorner \cdot r \cdot q}`$ with which the branch uses the field of the grade $`q`$, for the variable of the field, written $`{\varphi,\ x_1 \mathrel{◀} o \cdot r_1 \cdot (\ulcorner m \urcorner \cdot r \cdot q_1), \dots, x_n \mathrel{◀} o \cdot r_n \cdot (\ulcorner m \urcorner \cdot r \cdot q_n)}`$, and with the ownership $`p`$ of the recursor times the grade that the branch gives each recursive result, for its variable, written $`{\bar y \mathrel{◀} p \cdot \bar e}`$: a field of a value owned alone has the ownership that its entry requires, a field of a shared value is shared, since an other owner of the value reaches it, and a recursive result is a result of the recursor:

```math
\frac{\begin{gathered}{}(\mathsf{data}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} \bar c_1;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \bar c_k) \in \Sigma \\ \bar s',\ \bar p' \text{ as many as } \bar s,\ \bar p \\ \Sigma;\ \varphi \vdash t \mathrel{◀} o;\ m \odot r \\ \forall j, i.\ \text{the entries of } \Theta_{ji}[\bar s' / \bar s,\ \bar p' / \bar p] \text{ require } r_{ji1}, \dots, r_{jik_{ji}} \\ \forall j, i.\ \Theta_{ji}[\bar s' / \bar s,\ \bar p' / \bar p] \text{ has the grades } q_{ji1}, \dots, q_{jik_{ji}} \\ \bar u = (D_1.c_{11}(\bar x_{11};\ \bar y_{11} \mathrel{▶} \bar e_{11}) \Rightarrow u_{11},\ \dots,\ D_k.c_{kn_k}(\bar x_{kn_k};\ \bar y_{kn_k} \mathrel{▶} \bar e_{kn_k}) \Rightarrow u_{kn_k}) \\ \forall j, i.\ \Sigma;\ \varphi,\ x_{ji1} \mathrel{◀} o \cdot r_{ji1} \cdot (\ulcorner m \urcorner \cdot r \cdot q_{ji1}), \dots, x_{jik_{ji}} \mathrel{◀} o \cdot r_{jik_{ji}} \cdot (\ulcorner m \urcorner \cdot r \cdot q_{jik_{ji}}),\ \bar y_{ji} \mathrel{◀} p \cdot \bar e_{ji} \vdash u_{ji} \mathrel{◀} p;\ m\end{gathered}}{\Sigma;\ \varphi \vdash \mathsf{rec}_r\ (D_h.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a)\ t\ \mathsf{return}\ \bar C\ \mathsf{with}\ \bar u \mathrel{◀} p;\ m}\;(\mathsf{rec}_{◀})
```

An observation, written as in its [typing](14-typing.md#terms), has the ownership $`o`$ of its term times the value of the ownership $`\psi`$ of the result of its destructor, given the ownerships of its arguments, which satisfy the requirements of the entries of the telescope of the destructor, as the arguments of a telescope do: the result of a value owned alone has the ownership that its destructor gives it, and the result of a shared value is shared, since an other owner of the value may observe it.
Each argument on whose variable $`\psi`$ has a factor is checked in the mode $`m`$ of the observation, $`{m \odot p_j = m}`$, so that the value of $`\psi`$ reads only the ownerships that the mode counts, as the [usage](12-usage.md#definitions) counts only the uses of these arguments: an argument checked in a more erased mode is erased with them, and a result used at run time can neither be nor reach a value that is not there:

```math
\frac{\begin{gathered}{}(\mathsf{codata}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa\ \mathsf{where}\ \dots;\ D \mathrel{▶} \zeta \mathrel{≔} \bar d;\ \dots) \in \Sigma \\ \bar s',\ \bar p' \text{ as many as } \bar s,\ \bar p \\ \bar d[\bar s' / \bar s,\ \bar p' / \bar p] = (\bar d_1 \mid d : (\Theta \vdash B \mathrel{◀} \psi) \mathrel{▶} p;\ q \mid \bar d_2) \\ \Sigma;\ \varphi \vdash t \mathrel{◀} o;\ m \\ \Sigma;\ \varphi \vdash \bar t \mathrel{◀} \bar o;\ \Theta;\ m \\ \psi[\bar o / \bar x] = r \\ \Theta \text{ has the grades } p_1, \dots, p_n \\ \forall j.\ \psi \text{ has a factor of } x_j \implies m \odot p_j = m\end{gathered}}{\Sigma;\ \varphi \vdash t.((D.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a).d)(\bar t) \mathrel{◀} o \cdot r;\ m}\;(d_{◀})
```

A corecursor, written as in its [typing](14-typing.md#terms), builds a new value, whose ownership is $`{11}^{\mathsf{p}}`$ whatever its state, whose terms satisfy the requirements of the entries of the state of its type, checked in the mode $`{m \odot r}`$, as the arguments of a telescope do.
Each branch, checked in the mode $`{m_{ji} = m \odot p_{ji}}`$ of the grade of its destructor, with the requirement of its entry, which the value owned alone holds, times the grade $`{\ulcorner m_{ji} \urcorner \cdot r \cdot q}`$ with which the branch uses the entry of the grade $`q`$, for the variable of each entry of the state, written $`{\varphi,\ y_{j1} \mathrel{◀} r_{j1} \cdot (\ulcorner m_{ji} \urcorner \cdot r \cdot q_{j1}), \dots, y_{jn_j} \mathrel{◀} r_{jn_j} \cdot (\ulcorner m_{ji} \urcorner \cdot r \cdot q_{jn_j})}`$, has the ownership $`\psi_{ji}[\bar o / \bar x]`$ of the result of its destructor for all the ownerships $`\bar o`$ of its arguments that satisfy the requirements of their entries, each unless its argument is checked in the mode $`{00}^{\mathsf{m}}`$, as in $`{(\mathsf{tel}_{,◀})}`$, each times the grade $`{\ulcorner m_{ji} \urcorner \cdot p}`$ with which the branch uses the argument of the grade $`p`$, for its variable, written $`{\varphi,\ z_{ji1} \mathrel{◀} o_1 \cdot (\ulcorner m_{ji} \urcorner \cdot p_{ji1}), \dots, z_{jia_{ji}} \mathrel{◀} o_{a_{ji}} \cdot (\ulcorner m_{ji} \urcorner \cdot p_{jia_{ji}})}`$: an observation reads $`\psi`$ at the ownerships of its arguments, whatever they are; the branch of a [recursive](14-typing.md#destructors-of-a-block) destructor has the ownership $`{11}^{\mathsf{p}}`$ of a new value instead, since the observation [resumes](19-prelude.md#positions) its position by a recursor, which gives the term already built of the position the ownership $`\chi`$ that the position requires of it only when the position is owned alone:

```math
\frac{\begin{gathered}{}\mathcal{D} = (\mathsf{codata}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} \bar d_1;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \bar d_k) \in \Sigma \\ \bar s',\ \bar p' \text{ as many as } \bar s,\ \bar p \\ \Sigma;\ \varphi \vdash \bar t \mathrel{◀} \bar o_t;\ \Theta_h;\ m \odot r \\ \forall j.\ \text{the entries of } \Theta_j \text{ require } r_{j1}, \dots, r_{jn_j} \\ \forall j.\ \Theta_j \text{ has the grades } q_{j1}, \dots, q_{jn_j} \\ \forall j, i.\ \bar d_j[\bar s' / \bar s,\ \bar p' / \bar p] = (\bar d_{ji,1} \mid d_{ji} : (\Theta_{ji} \vdash B_{ji} \mathrel{◀} \psi_{ji}) \mathrel{▶} p_{ji};\ q_{ji} \mid \bar d_{ji,2}) \\ \forall j, i.\ \Theta_{ji} \text{ has the grades } p_{ji1}, \dots, p_{jia_{ji}} \\ \forall j, i, \bar o, o.\ \bar o \text{ satisfies the requirements of } \Theta_{ji} \text{ in the mode } m_{ji} \text{ and } (\mathsf{rec}_{\mathcal{D}}(B_{ji}) = \bot \text{ and } \psi_{ji}[\bar o / \bar x] = o \text{ or } \mathsf{rec}_{\mathcal{D}}(B_{ji}) \ne \bot \text{ and } o = {11}^{\mathsf{p}}) \implies \Sigma;\ \varphi,\ y_{j1} \mathrel{◀} r_{j1} \cdot (\ulcorner m_{ji} \urcorner \cdot r \cdot q_{j1}), \dots, y_{jn_j} \mathrel{◀} r_{jn_j} \cdot (\ulcorner m_{ji} \urcorner \cdot r \cdot q_{jn_j}),\ z_{ji1} \mathrel{◀} o_1 \cdot (\ulcorner m_{ji} \urcorner \cdot p_{ji1}), \dots, z_{jia_{ji}} \mathrel{◀} o_{a_{ji}} \cdot (\ulcorner m_{ji} \urcorner \cdot p_{jia_{ji}}) \vdash g_{ji} \mathrel{◀} o;\ m_{ji}\end{gathered}}{\Sigma;\ \varphi \vdash \mathsf{corec}_r\ (D_h.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a)\ \mathsf{from}\ \bar t\ \mathsf{return}\ \bar\Theta\ \mathsf{with}\ \bar g \mathrel{◀} {11}^{\mathsf{p}};\ m}\;(\mathsf{corec}_{◀})
```

A term may be given an ownership lower than its own, which states less:

```math
\frac{\begin{gathered}{}\Sigma;\ \varphi \vdash t \mathrel{◀} p;\ m \\ q \le p\end{gathered}}{\Sigma;\ \varphi \vdash t \mathrel{◀} q;\ m}\;(\mathsf{sub}_{◀})
```

The values of the entries of a signature have their ownerships when, at each instance of its sort and grade variables, the value of the body of each constant definition has the ownership of the definition, in its mode, without variable, and, at each instance that the constraint $`C`$ of a block of codata types admits, the ownership $`\psi`$ of the result of each recursive destructor is a constant $`\chi`$, which the ownerships of its arguments do not change, below the ownership $`{11}^{\mathsf{p}}`$ of a new value, which an observation that [resumes](19-prelude.md#positions) the corecursor gives; a constant declaration has no body, and the constructors of a block of data types give the ownerships of their values.
Each entry is checked in the signature before it, as its [formation](14-typing.md#signatures-and-entries) is:

```math
\begin{gathered}
\frac{}{\vdash \varnothing \mathrel{◀}}\;(\mathsf{sig}_{\varnothing◀}) \\[1em]
\frac{\begin{gathered}{}\vdash \Sigma \mathrel{◀} \\ \forall \bar s',\ \bar p' \text{ as many as } \bar s,\ \bar p.\ \Sigma;\ \varepsilon \vdash t[\bar s' / \bar s,\ \bar p' / \bar p] \mathrel{◀} p;\ m\end{gathered}}{\vdash (\Sigma,\ f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \mathrel{≔} t) \mathrel{◀}}\;(\mathsf{sig}_{\mathsf{def}◀}) \\[1em]
\frac{\vdash \Sigma \mathrel{◀}}{\vdash (\Sigma,\ f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p) \mathrel{◀}}\;(\mathsf{sig}_{\mathsf{decl}◀}) \\[1em]
\frac{\begin{gathered}{}\mathcal{D} = (\mathsf{data}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} \bar c_1;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \bar c_k) \\ \vdash \Sigma \mathrel{◀}\end{gathered}}{\vdash (\Sigma,\ \mathcal{D}) \mathrel{◀}}\;(\mathsf{sig}_{\mathsf{data}◀}) \\[1em]
\frac{\begin{gathered}{}\mathcal{D} = (\mathsf{codata}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} \bar d_1;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \bar d_k) \\ \vdash \Sigma \mathrel{◀} \\ \begin{aligned}& \forall \bar s',\ \bar p' \text{ as many as } \bar s,\ \bar p.\ \forall j, i. \\ & \quad \text{⟹} \\ & \qquad \text{and} \\ & \qquad \quad C[\bar s' / \bar s,\ \bar p' / \bar p] \\ & \qquad \quad \bar d_j[\bar s' / \bar s,\ \bar p' / \bar p] = (\bar d_{ji,1} \mid d_{ji} : (\Theta_{ji} \vdash B_{ji} \mathrel{◀} \psi_{ji}) \mathrel{▶} p_{ji};\ q_{ji} \mid \bar d_{ji,2}) \\ & \qquad \quad \mathsf{rec}_{\mathcal{D}}(B_{ji}) \ne \bot \\ & \qquad \exists \chi. \\ & \qquad \quad \text{and} \\ & \qquad \qquad \psi_{ji} = \chi \\ & \qquad \qquad \chi \le {11}^{\mathsf{p}}\end{aligned}\end{gathered}}{\vdash (\Sigma,\ \mathcal{D}) \mathrel{◀}}\;(\mathsf{sig}_{\mathsf{codata}◀})
\end{gathered}
```

## Properties

Ownership is stable under the [renamings](09-substitution.md#renamings): renamed, a term has the same ownership, given ownerships $`\varphi'`$ of the variables that give the image of each variable its ownership, as the types of a context are renamed:

```math
\begin{aligned}
& \forall x.\ \varphi'(\alpha(x)) = \varphi(x) \text{ and } \Sigma;\ \varphi \vdash t \mathrel{◀} p;\ m \implies \Sigma;\ \varphi' \vdash t[\alpha] \mathrel{◀} p;\ m &&(\mathsf{ren}_{◀}.t) \\[1em]
& \forall x.\ \varphi'(\alpha(x)) = \varphi(x) \text{ and } \Sigma;\ \varphi \vdash \bar t \mathrel{◀} \bar o;\ \Theta;\ m \implies \Sigma;\ \varphi' \vdash \bar t[\alpha] \mathrel{◀} \bar o;\ \Theta[\alpha];\ m &&(\mathsf{ren}_{◀}.\bar t)
\end{aligned}
```
