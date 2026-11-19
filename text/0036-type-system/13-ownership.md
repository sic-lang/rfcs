# Ownership

This annex defines the judgment of ownership, which checks the ownership of the value of a term, in a mode, the ownership of the entries of a signature, and their properties.
It builds on the [grades](04-grades.md), the [modes](05-modes.md), the [syntax](08-syntax.md), the [substitution](09-substitution.md), and the shapes of the [recursive results](21-recursive-results.md#shapes-of-the-nested-fields), which the ownership of a recursor reads.

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
\frac{}{\Sigma;\ \varphi \vdash x \mathrel{◀} \varphi(x);\ m}\;(\mathsf{var}_{◀}) \\[2em]
\frac{\begin{aligned}& X \text{ has the telescope } \Theta \text{ and the ownership } \psi \text{ in the scope of } X[\bar t] \\[0.6em] & \Sigma;\ \varphi \vdash \bar t \mathrel{◀} \bar o;\ \Theta;\ m \\[0.6em] & \psi[\bar o / \bar x] = p \\[0.6em] & \Theta \text{ has the grades } p_1, \dots, p_n \\[0.6em] & \forall j.\ \psi \text{ has a factor of } x_j \implies m \odot p_j = m\end{aligned}}{\Sigma;\ \varphi \vdash X[\bar t] \mathrel{◀} p;\ m}\;(\mathsf{var}_{X◀}) \\[2em]
\frac{}{\Sigma;\ \varphi \vdash () \mathrel{◀} ();\ \varepsilon;\ m}\;(\mathsf{tel}_{\varepsilon◀}) \\[2em]
\frac{\begin{aligned}& \Sigma;\ \varphi \vdash t \mathrel{◀} o;\ m \odot p \\[0.6em] & \Sigma;\ \varphi \vdash \bar t \mathrel{◀} \bar o;\ \Theta;\ m \\[0.6em] & r \le o \text{ if } m \odot p \ne {00}^{\mathsf{m}}\end{aligned}}{\Sigma;\ \varphi \vdash (t,\ \bar t) \mathrel{◀} (o,\ \bar o);\ (x : A \mathrel{▶} p;\ q \mathrel{◀} r,\ \Theta);\ m}\;(\mathsf{tel}_{,◀})
\end{gathered}
```

A constant, defined or declared, has the ownership of its entry, in every mode.
A sort has the least ownership, $`{\omega\omega}^{\mathsf{p}}`$, which states nothing:

```math
\begin{gathered}
\frac{f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m_2 \mathrel{◀} p \in \Sigma}{\Sigma;\ \varphi \vdash f.\{\bar s';\ \bar l';\ \bar p'\} \mathrel{◀} p;\ m_1}\;(f_{◀}) \\[2em]
\frac{}{\Sigma;\ \varphi \vdash \kappa \mathrel{◀} {\omega\omega}^{\mathsf{p}};\ m}\;(\kappa_{◀})
\end{gathered}
```

An instance of a declared type is a type, and has the least ownership, as a sort.
A constructor builds a new value, whose ownership is $`{11}^{\mathsf{p}}`$ whatever its fields: what the value holds is stated by the requirements of the entries of its fields, which its arguments satisfy, as those of a telescope, unless they are not used:

```math
\begin{gathered}
\frac{}{\Sigma;\ \varphi \vdash D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a \mathrel{◀} {\omega\omega}^{\mathsf{p}};\ m}\;(D_{◀}) \\[2em]
\frac{\begin{aligned}& {\in} \\ & \quad \mathsf{data}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa \\ & \qquad \mathsf{where} \\ & \qquad \quad \dots; \\ & \qquad \quad D \mathrel{▶} \zeta \oplus \Pi \mathrel{≔} \dots \mid c : \Theta \mid \dots; \\ & \qquad \quad \dots \\ & \quad \Sigma \\[0.6em] & \bar s',\ \bar p' \text{ as many as } \bar s,\ \bar p \\[0.6em] & \Sigma;\ \varphi \vdash \bar t \mathrel{◀} \bar o;\ \Theta[\bar s' / \bar s,\ \bar p' / \bar p];\ m\end{aligned}}{\Sigma;\ \varphi \vdash (D.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a).c(\bar t) \mathrel{◀} {11}^{\mathsf{p}};\ m}\;(c_{◀})
\end{gathered}
```

A variable that a recursor or a corecursor binds has the ownership of the value it receives times the grade with which its scope uses it, which the syntax gives, so that a value received once and used twice through its variable is shared, and the ownership reads no derivation of the usage.
A recursor, written as in its [typing](14-typing.md#terms), has the ownership of its branches, each checked with the ownership $`o`$ of the term times the requirement $`\hat r`$ of its recursion times the requirement of the entry of each field, times the grade $`{\ulcorner m \urcorner \cdot r \cdot q}`$ with which the branch uses the field of the grade $`q`$, for the variable of the field, written $`{\varphi,\ x_1 \mathrel{◀} o \cdot \hat r \cdot r_1 \cdot (\ulcorner m \urcorner \cdot r \cdot q_1), \dots, x_n \mathrel{◀} o \cdot \hat r \cdot r_n \cdot (\ulcorner m \urcorner \cdot r \cdot q_n)}`$, and with the ownership of each recursive result times the grade that the branch gives it, for its variable, written $`{\bar y \mathrel{◀} \mathsf{own}_p(\bar\lambda) \cdot \bar e}`$, the ownership $`p`$ of the recursor for the result of a recursive field, a result of the recursor, and $`{11}^{\mathsf{p}}`$ for the result of a nested field, the corecursor of a lifting, a new value: a field of a value owned alone has the ownership that its entry requires, a field of a shared value is shared, since an other owner of the value reaches it, a recursive result is a result of the recursor, and a nested result is a new value, which a recursor of a shared result can observe at the requirement $`\varsigma`$ of the lifted destructors.
Here $`\bar\lambda`$ are the [nestings](14-typing.md#fields-of-a-block) of the fields, and $`{\mathsf{own}_p(\bar\lambda) \cdot \bar e}`$ gives each recursive result the ownership $`\mathsf{own}_p(\lambda)`$ of the nesting $`\lambda`$ of its field times its grade, $`(\mathsf{own}_{\bar\lambda})`$, one result for each element of $`\bar\lambda`$ that is not $`\bot`$, in order.
The requirement $`\hat r`$ of the recursion is the meet, on each [axis](04-grades.md#definitions) of the grades, of $`1`$, of the coefficient of the variable of each recursive field that the recursor uses, the requirement $`r_l`$ of its entry times the grade $`{\ulcorner m \urcorner \cdot r \cdot q_l}`$ with which the branch uses it, and, for each nested field that the recursor uses and each prefix $`{d_1 \dots d_h}`$ of a path of its [shape](21-recursive-results.md#ownerships-of-the-shapes), the empty one included, of the requirement $`r_l`$ times the product $`{\varsigma \cdot \psi^-_1 \cdot \ldots \cdot \psi^-_h}`$ along the prefix times this grade, a field without use being eliminated by no recursion: the branches run at each level of the recursion, on the term and then on a recursive field or on an observation of a nested field, and a recursion is a use of its field, whose ownership is the ownership of the value that holds it times the coefficient of the variable of the field, as that of its variable, or of an observation, whose ownership the products along its path bound, so that they see the term at the ownership $`{o \cdot \hat r}`$, which every level has, since the grades are idempotent, $`{\hat r \cdot \hat r = \hat r}`$, and $`\hat r`$ is below the coefficient of each recursive field that the recursor uses.
Every value that a recursion observes then keeps the ownership $`{o \cdot \hat r}`$, the value at the end of each prefix of a path, which the next destructor of the path observes, as the value at its end, on which the recursion runs, so that one check of the branches covers the recursions on the observations of the nested fields too.
The requirement $`\mathsf{recursion}(K;\ L)`$ of a recursion reads a set $`K`$ of pairs $`{u \mathrel{◀} r}`$ of grades, the grade $`u`$ with which a recursive field is used and the requirement $`r`$ of its entry, and, for each axis $`\beta`$, a set $`L(\beta)`$ of pairs $`{\pi \mathrel{◀} \varrho}`$ of multiplicities on the axis, the multiplicity $`\pi`$ with which a nested field is used and its requirement times the product along a prefix of a path of its shape, $`\varrho`$:

```math
\begin{aligned}
& {=} &&(\mathsf{recursion}_p) \\
& \quad \mathsf{recursion}(K;\ L) \\
& \quad \langle \\
& \qquad {\wedge} \\
& \qquad \quad 1 \wedge \bigwedge \{\pi_3 \cdot \pi_1 \mid (\langle \pi_1, \pi_2 \rangle \mathrel{◀} \langle \pi_3, \pi_4 \rangle) \in K,\ \pi_1 \ne 0\} \\
& \qquad \quad \bigwedge \{\varrho \cdot \pi \mid (\pi \mathrel{◀} \varrho) \in L(\mathsf{run}),\ \pi \ne 0\}, \\
& \qquad {\wedge} \\
& \qquad \quad 1 \wedge \bigwedge \{\pi_4 \cdot \pi_2 \mid (\langle \pi_1, \pi_2 \rangle \mathrel{◀} \langle \pi_3, \pi_4 \rangle) \in K,\ \pi_2 \ne 0\} \\
& \qquad \quad \bigwedge \{\varrho \cdot \pi \mid (\pi \mathrel{◀} \varrho) \in L(\mathsf{total}),\ \pi \ne 0\} \\
& \quad \rangle
\end{aligned}
```

The requirement $`{\mathsf{recursion}_{\Sigma; m}(\mathcal{D}.\{\bar s';\ \bar p'\};\ s_C,\ r,\ \varsigma,\ \chi)}`$ of the recursion of a recursor checked in the mode $`m`$, of the quality $`s_C`$ of the sorts of its motives, of the grade $`r`$ and of the ownerships $`\varsigma`$ and $`\chi`$, on the block of data types $`{\mathcal{D} = \mathsf{data}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \oplus \Pi_1 \mathrel{≔} \bar c_1;\ \dots;\ D_k \mathrel{▶} \zeta_k \oplus \Pi_k \mathrel{≔} \bar c_k}`$, at the instance $`\bar s'`$, $`\bar p'`$ of its sort and grade variables, where $`\Theta_{ji}`$ is the telescope of the constructor $`c_{ji}`$ of $`\bar c_j`$, reads its recursive fields, those at which $`\mathsf{rec}_{\mathcal{D}}(\Theta_{ji})`$, defined with the [fields of a block](14-typing.md#fields-of-a-block), is not $`\bot`$, and the [shapes of its nested fields](21-recursive-results.md#shapes-of-the-nested-fields) in the mode $`m`$ on each axis, at these values of the variables $`s_C`$, $`r`$, $`\varsigma`$ and $`\chi`$ that the [recursive results](21-recursive-results.md#definitions) fix:

```math
\begin{aligned}
& {=} &&(\mathsf{recursion}_{\mathcal{D}}) \\
& \quad \mathsf{recursion}_{\Sigma; m}(\mathcal{D}.\{\bar s';\ \bar p'\};\ s_C,\ r,\ \varsigma,\ \chi) \\
& \quad \mathsf{recursion}(K;\ L) \\
& \quad \text{where} \\
& \qquad \text{and} \\
& \qquad \quad K = \{\ulcorner m \urcorner \cdot r \cdot q_{jil} \mathrel{◀} r_{jil} \mid \\
& \qquad \qquad \text{the element } l \text{ of } \mathsf{rec}_{\mathcal{D}}(\Theta_{ji}) \text{ is not } \bot\} \\
& \qquad \quad L(\beta) = \{\beta(\ulcorner m \urcorner \cdot r \cdot q_{jil}) \mathrel{◀} \beta(r_{jil}) \cdot \pi \mid \\
& \qquad \qquad \text{and} \\
& \qquad \qquad \quad \Xi_{jil,\beta} \ne \bot \\
& \qquad \qquad \quad \pi \in \mathsf{recursion}_{\beta(\varsigma)}(\Xi_{jil,\beta})\} \\
& \qquad \quad \forall j, i.\ \text{the entries of } \Theta_{ji}[\bar s' / \bar s,\ \bar p' / \bar p] \text{ require } r_{ji1}, \dots, r_{jik_{ji}} \\
& \qquad \quad \forall j, i.\ \Theta_{ji}[\bar s' / \bar s,\ \bar p' / \bar p] \text{ has the grades } q_{ji1}, \dots, q_{jik_{ji}} \\
& \qquad \quad \forall j, i, \beta.\ \mathsf{shapes}_{\Sigma; m; \beta}(\mathcal{D}.\{\bar s';\ \bar p'\},\ \Theta_{ji}) = \Xi_{ji1,\beta}, \dots, \Xi_{jik_{ji},\beta}
\end{aligned}
```

The ownership $`\mathsf{own}_p(\lambda)`$ of the recursive result of a field of the nesting $`\lambda`$, in a branch of a recursor of the ownership $`p`$, is $`{11}^{\mathsf{p}}`$ for a nested field, whose result is the corecursor of a lifting, a new value, and $`p`$ for a recursive field, whose result is a result of the recursor.
The ownerships $`\mathsf{own}_p(\bar\lambda)`$ of the recursive results of fields of the nestings $`\bar\lambda`$ are one ownership for each element of $`\bar\lambda`$ that is not $`\bot`$, in order, since a field without position has no result.
The head $`\mathsf{own}`$ names one notion, the ownership of the value of a recursive result, on three syntaxes: the nestings here, the [shapes](21-recursive-results.md#ownerships-of-the-shapes) of the nested results, $`(\mathsf{own}_\Upsilon)`$, and the positions of the recursive results in the target language of the [erasure](16-erasure.md#definitions), $`(\mathsf{own}_w)`$:

```math
\begin{aligned}
& \mathsf{own}_p(\lambda) = {11}^{\mathsf{p}} \text{ if } \lambda = (\bar\lambda) &&(\mathsf{own}_\lambda) \\
& \mathsf{own}_p(\lambda) = p \text{ otherwise} \\[1em]
& \mathsf{own}_p(()) = () &&(\mathsf{own}_{\bar\lambda}) \\
& \mathsf{own}_p((\bot,\ \bar\lambda)) = \mathsf{own}_p(\bar\lambda) \\
& \mathsf{own}_p((\lambda,\ \bar\lambda)) = (\mathsf{own}_p(\lambda),\ \mathsf{own}_p(\bar\lambda)) \text{ if } \lambda \ne \bot
\end{aligned}
```

Each nested field of the block has a shape on each axis, which reads the liftings that the signature declares, so that the requirement of the recursion reads its paths, and its shape meets the requirements of the recursions on its observations at the ownership $`{o \cdot \hat r}`$ on the axis: each destructor that it observes requires of the value that it observes an ownership within $`{o \cdot \hat r}`$, which every observed value has, the arguments of its observation meet the requirements of their positions in it, since the lifted destructor uses its arguments the grade of the recursor times the factor of its result more, so that an argument required owned alone would otherwise reach the destructor that it lifts shared, and the ownership of its result has a value at them.
When the block has a nested field, each branch is checked a second time, with the scope at $`{\varsigma \cdot \varphi}`$, the ownership $`\chi`$ and the results at $`{\mathsf{own}_\chi(\bar\lambda) \cdot \bar e}`$: the corecursor of a nested result captures the scope, which its observations see at the requirement $`\varsigma`$ of its destructors, and runs the recursor on the observations of the field, whose results have the ownership $`\chi`$, so that the branches run at these ownerships, every branch, since a recursion from a nested result may reach any constructor; the ownership is not monotone in $`\varphi`$, so that the first check does not cover the second, which is the first when $`{\varsigma = {11}^{\mathsf{p}}}`$ and $`{\chi = p}`$.
The variables $`s_C`$, $`r`$, $`\varsigma`$ and $`\chi`$ of the shapes and of the requirement of the recursion are those of the recursor, $`s_C`$ being the quality of the sort $`\kappa_C`$ of its motives, a premise of the rule:

```math
\frac{\begin{aligned}& \mathcal{D} \in \Sigma \\[0.6em] & {=} \\ & \quad \mathcal{D} \\ & \quad \mathsf{data}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa \\ & \qquad \mathsf{where} \\ & \qquad \quad D_1 \mathrel{▶} \zeta_1 \oplus \Pi_1 \mathrel{≔} \bar c_1; \\ & \qquad \quad \dots; \\ & \qquad \quad D_k \mathrel{▶} \zeta_k \oplus \Pi_k \mathrel{≔} \bar c_k \\[0.6em] & \bar s',\ \bar p' \text{ as many as } \bar s,\ \bar p \\[0.6em] & s_C \text{ is the quality of } \kappa_C \\[0.6em] & \Sigma;\ \varphi \vdash t \mathrel{◀} o;\ m \odot r \\[0.6em] & \forall j, i.\ \text{the entries of } \Theta_{ji}[\bar s' / \bar s,\ \bar p' / \bar p] \text{ require } r_{ji1}, \dots, r_{jik_{ji}} \\[0.6em] & \forall j, i.\ \Theta_{ji}[\bar s' / \bar s,\ \bar p' / \bar p] \text{ has the grades } q_{ji1}, \dots, q_{jik_{ji}} \\[0.6em] & \forall j, i.\ \mathsf{nest}_{\mathcal{D}}(\Theta_{ji}) = \lambda_{ji1}, \dots, \lambda_{jik_{ji}} \\[0.6em] & \forall j, i, \beta.\ \mathsf{shapes}_{\Sigma; m; \beta}(\mathcal{D}.\{\bar s';\ \bar p'\},\ \Theta_{ji}) = \Xi_{ji1,\beta}, \dots, \Xi_{jik_{ji},\beta} \\[0.6em] & \forall j, i, l, \beta, \bar\lambda.\ \lambda_{jil} = (\bar\lambda) \implies \Xi_{jil,\beta} \ne \bot \\[0.6em] & \hat r = \mathsf{recursion}_{\Sigma; m}(\mathcal{D}.\{\bar s';\ \bar p'\};\ s_C,\ r,\ \varsigma,\ \chi) \\[0.6em] & \forall j, i, l, \beta.\ \Xi_{jil,\beta} \ne \bot \implies \Xi_{jil,\beta} \text{ meets } \beta(o \cdot \hat r);\ \beta(\varsigma) \\[0.6em] & \bar u = (D_1.c_{11}(\bar x_{11};\ \bar y_{11} \mathrel{▶} \bar e_{11}) \Rightarrow u_{11},\ \dots,\ D_k.c_{kn_k}(\bar x_{kn_k};\ \bar y_{kn_k} \mathrel{▶} \bar e_{kn_k}) \Rightarrow u_{kn_k}) \\[0.6em] & \forall j, i.\ \bar x_{ji} = x_{ji1}, \dots, x_{jik_{ji}} \\[0.6em] & \forall j, i.\ \bar y_{ji} \text{ has a variable for each of } \lambda_{ji1}, \dots, \lambda_{jik_{ji}} \text{ that is not } \bot \\[0.6em] & \forall j, i. \\ & \quad \Sigma; \\ & \qquad \varphi, \\ & \qquad x_{ji1} \mathrel{◀} o \cdot \hat r \cdot r_{ji1} \cdot (\ulcorner m \urcorner \cdot r \cdot q_{ji1}), \\ & \qquad \dots, \\ & \qquad x_{jik_{ji}} \mathrel{◀} o \cdot \hat r \cdot r_{jik_{ji}} \cdot (\ulcorner m \urcorner \cdot r \cdot q_{jik_{ji}}), \\ & \qquad \bar y_{ji} \mathrel{◀} \mathsf{own}_p(\bar\lambda_{ji}) \cdot \bar e_{ji} \\ & \quad {\vdash}\ u_{ji} \mathrel{◀} p;\ m \\[0.6em] & \forall j, i. \\ & \quad \Sigma; \\ & \qquad \varsigma \cdot \varphi, \\ & \qquad x_{ji1} \mathrel{◀} o \cdot \hat r \cdot r_{ji1} \cdot (\ulcorner m \urcorner \cdot r \cdot q_{ji1}), \\ & \qquad \dots, \\ & \qquad x_{jik_{ji}} \mathrel{◀} o \cdot \hat r \cdot r_{jik_{ji}} \cdot (\ulcorner m \urcorner \cdot r \cdot q_{jik_{ji}}), \\ & \qquad \bar y_{ji} \mathrel{◀} \mathsf{own}_\chi(\bar\lambda_{ji}) \cdot \bar e_{ji} \\ & \quad {\vdash}\ u_{ji} \mathrel{◀} \chi;\ m \\ & \quad \text{if } \exists j', i', l, \bar\lambda.\ \lambda_{j'i'l} = (\bar\lambda)\end{aligned}}{\Sigma;\ \varphi \vdash \mathsf{rec}_{r;\ \varsigma;\ \chi}\ (D_h.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a)\ t\ \mathsf{return}\ \bar C : \kappa_C\ \mathsf{with}\ \bar u \mathrel{◀} p;\ m}\;(\mathsf{rec}_{◀})
```

An observation, written as in its [typing](14-typing.md#terms), has the ownership $`o`$ of its term times the value of the ownership $`\psi`$ of the result of its destructor, given the ownerships of its arguments, which satisfy the requirements of the entries of the telescope of the destructor, as the arguments of a telescope do: the result of a value owned alone has the ownership that its destructor gives it, and the result of a shared value is shared, since an other owner of the value may observe it.
Each argument on whose variable $`\psi`$ has a factor is checked in the mode $`m`$ of the observation, $`{m \odot p_j = m}`$, so that the value of $`\psi`$ reads only the ownerships that the mode counts, as the [usage](12-usage.md#definitions) counts only the uses of these arguments: an argument checked in a more erased mode is erased with them, and a result used at run time can neither be nor reach a value that is not there.
The ownership of the term satisfies the requirement $`\varsigma`$ of the destructor on the value that it observes, in every mode, since the branch of the destructor in a corecursor gives the entries of the state and the variables of its scope the ownerships that a value of the ownership $`\varsigma`$ holds, and every observation of a value reads the same state and the same variables:

```math
\frac{\begin{aligned}& {\in} \\ & \quad \mathsf{codata}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa \\ & \qquad \mathsf{where} \\ & \qquad \quad \dots; \\ & \qquad \quad D \mathrel{▶} \zeta \oplus \Pi \mathrel{≔} \bar d; \\ & \qquad \quad \dots \\ & \quad \Sigma \\[0.6em] & \bar s',\ \bar p' \text{ as many as } \bar s,\ \bar p \\[0.6em] & \bar d[\bar s' / \bar s,\ \bar p' / \bar p] = (\bar d_1 \mid d : (\Theta \vdash B \mathrel{◀} \psi) \mathrel{▶} p;\ q \mathrel{◀} \varsigma \mid \bar d_2) \\[0.6em] & \Sigma;\ \varphi \vdash t \mathrel{◀} o;\ m \\[0.6em] & \Sigma;\ \varphi \vdash \bar t \mathrel{◀} \bar o;\ \Theta;\ m \\[0.6em] & \psi[\bar o / \bar x] = r \\[0.6em] & \Theta \text{ has the grades } p_1, \dots, p_n \\[0.6em] & \forall j.\ \psi \text{ has a factor of } x_j \implies m \odot p_j = m \\[0.6em] & \varsigma \le o\end{aligned}}{\Sigma;\ \varphi \vdash t.((D.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a).d)(\bar t) \mathrel{◀} o \cdot r;\ m}\;(d_{◀})
```

A corecursor, written as in its [typing](14-typing.md#terms), builds a new value, whose ownership is $`{11}^{\mathsf{p}}`$ whatever its state, whose terms satisfy the requirements of the entries of the state of its type, checked in the mode $`{m \odot r}`$, as the arguments of a telescope do.
Each branch, checked in the mode $`{m_{ji} = m \odot p_{ji}}`$ of the grade of its destructor, with the ownership $`\varsigma_{ji}`$ that its destructor requires of the value that it observes times the requirement of its entry, the ownership that a value of the ownership $`\varsigma_{ji}`$ gives the entry, as for the field of a recursor, times the grade $`{\ulcorner m_{ji} \urcorner \cdot r \cdot q}`$ with which the branch uses the entry of the grade $`q`$, for the variable of each entry of the state, and $`\varsigma_{ji}`$ times its ownership for each variable of the scope, the ownership that a value of the ownership $`\varsigma_{ji}`$ gives what it captures, written $`{\varsigma_{ji} \cdot \varphi,\ y_{j1} \mathrel{◀} \varsigma_{ji} \cdot r_{j1} \cdot (\ulcorner m_{ji} \urcorner \cdot r \cdot q_{j1}), \dots, y_{jn_j} \mathrel{◀} \varsigma_{ji} \cdot r_{jn_j} \cdot (\ulcorner m_{ji} \urcorner \cdot r \cdot q_{jn_j})}`$, has the ownership $`\psi_{ji}[\bar o / \bar x]`$ of the result of its destructor for all the ownerships $`\bar o`$ of its arguments that satisfy the requirements of their entries, each unless its argument is checked in the mode $`{00}^{\mathsf{m}}`$, as in $`{(\mathsf{tel}_{,◀})}`$, each times the grade $`{\ulcorner m_{ji} \urcorner \cdot p}`$ with which the branch uses the argument of the grade $`p`$, for its variable, written $`{\varphi,\ z_{ji1} \mathrel{◀} o_1 \cdot (\ulcorner m_{ji} \urcorner \cdot p_{ji1}), \dots, z_{jia_{ji}} \mathrel{◀} o_{a_{ji}} \cdot (\ulcorner m_{ji} \urcorner \cdot p_{jia_{ji}})}`$: an observation reads $`\psi`$ at the ownerships of its arguments, whatever they are; the branch of a [recursive](14-typing.md#destructors-of-a-block) destructor has the ownership $`{11}^{\mathsf{p}}`$ of a new value instead, since the observation [resumes](19-prelude.md#positions) its position by a recursor, which gives the term already built of the position the ownership $`\chi`$ that the position requires of it only when the position is owned alone:

```math
\frac{\begin{aligned}& \mathcal{D} \in \Sigma \\[0.6em] & {=} \\ & \quad \mathcal{D} \\ & \quad \mathsf{codata}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa \\ & \qquad \mathsf{where} \\ & \qquad \quad D_1 \mathrel{▶} \zeta_1 \oplus \Pi_1 \mathrel{≔} \bar d_1; \\ & \qquad \quad \dots; \\ & \qquad \quad D_k \mathrel{▶} \zeta_k \oplus \Pi_k \mathrel{≔} \bar d_k \\[0.6em] & \bar s',\ \bar p' \text{ as many as } \bar s,\ \bar p \\[0.6em] & \Sigma;\ \varphi \vdash \bar t \mathrel{◀} \bar o_t;\ \Theta_h;\ m \odot r \\[0.6em] & \forall j.\ \text{the entries of } \Theta_j \text{ require } r_{j1}, \dots, r_{jn_j} \\[0.6em] & \forall j.\ \Theta_j \text{ has the grades } q_{j1}, \dots, q_{jn_j} \\[0.6em] & \forall j, i.\ \bar d_j[\bar s' / \bar s,\ \bar p' / \bar p] = (\bar d_{ji,1} \mid d_{ji} : (\Theta_{ji} \vdash B_{ji} \mathrel{◀} \psi_{ji}) \mathrel{▶} p_{ji};\ q_{ji} \mathrel{◀} \varsigma_{ji} \mid \bar d_{ji,2}) \\[0.6em] & \forall j, i.\ m_{ji} = m \odot p_{ji} \\[0.6em] & \forall j, i.\ \Theta_{ji} \text{ has the grades } p_{ji1}, \dots, p_{jia_{ji}} \\[0.6em] & \forall j, i, \bar o, o. \\ & \quad \text{⟹} \\ & \qquad \text{and} \\ & \qquad \quad \bar o \text{ satisfies the requirements of } \Theta_{ji} \text{ in the mode } m_{ji} \\ & \qquad \quad \text{or} \\ & \qquad \qquad \text{and} \\ & \qquad \qquad \quad \mathsf{rec}_{\mathcal{D}}(B_{ji}) = \bot \\ & \qquad \qquad \quad \psi_{ji}[\bar o / \bar x] = o \\ & \qquad \qquad \text{and} \\ & \qquad \qquad \quad \mathsf{rec}_{\mathcal{D}}(B_{ji}) \ne \bot \\ & \qquad \qquad \quad o = {11}^{\mathsf{p}} \\ & \qquad \Sigma; \\ & \qquad \quad \varsigma_{ji} \cdot \varphi, \\ & \qquad \quad y_{j1} \mathrel{◀} \varsigma_{ji} \cdot r_{j1} \cdot (\ulcorner m_{ji} \urcorner \cdot r \cdot q_{j1}), \dots, y_{jn_j} \mathrel{◀} \varsigma_{ji} \cdot r_{jn_j} \cdot (\ulcorner m_{ji} \urcorner \cdot r \cdot q_{jn_j}), \\ & \qquad \quad z_{ji1} \mathrel{◀} o_1 \cdot (\ulcorner m_{ji} \urcorner \cdot p_{ji1}), \dots, z_{jia_{ji}} \mathrel{◀} o_{a_{ji}} \cdot (\ulcorner m_{ji} \urcorner \cdot p_{jia_{ji}}) \\ & \qquad {\vdash}\ g_{ji} \mathrel{◀} o;\ m_{ji}\end{aligned}}{\begin{aligned}& \Sigma;\ \varphi \\ & {\vdash}\ \mathsf{corec}_r\ (D_h.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a) \\ & \qquad \mathsf{from}\ \bar t \\ & \qquad \mathsf{return}\ \bar\Theta \\ & \qquad \mathsf{with}\ \bar g \\ & \mathrel{◀} {11}^{\mathsf{p}};\ m\end{aligned}}\;(\mathsf{corec}_{◀})
```

A term may be given an ownership lower than its own, which states less:

```math
\frac{\begin{aligned}& \Sigma;\ \varphi \vdash t \mathrel{◀} p;\ m \\[0.6em] & q \le p\end{aligned}}{\Sigma;\ \varphi \vdash t \mathrel{◀} q;\ m}\;(\mathsf{sub}_{◀})
```

The values of the entries of a signature have their ownerships when, at each instance of its sort and grade variables, the value of the body of each constant definition has the ownership of the definition, in its mode, without variable, and the ownership $`\psi`$ of the result of each recursive destructor of a block of codata types is a constant $`\chi`$, which the ownerships of its arguments do not change, at each instance, so that the erasure keeps a constant at every instance of a corecursor, and, at each instance that the constraint $`C`$ of the block admits, below the ownership $`{11}^{\mathsf{p}}`$ of a new value, which an observation that [resumes](19-prelude.md#positions) the corecursor gives; a constant declaration has no body, and the constructors of a block of data types give the ownerships of their values.
Each entry is checked in the signature before it, as its [formation](14-typing.md#signatures-and-entries) is:

```math
\begin{gathered}
\frac{}{\vdash \varnothing \mathrel{◀}}\;(\mathsf{sig}_{\varnothing◀}) \\[2em]
\frac{\begin{aligned}& \vdash \Sigma \mathrel{◀} \\[0.6em] & \forall \bar s',\ \bar p' \text{ as many as } \bar s,\ \bar p.\ \Sigma;\ \varepsilon \vdash t[\bar s' / \bar s,\ \bar p' / \bar p] \mathrel{◀} p;\ m\end{aligned}}{\vdash (\Sigma,\ f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \mathrel{≔} t) \mathrel{◀}}\;(\mathsf{sig}_{\mathsf{def}◀}) \\[2em]
\frac{\vdash \Sigma \mathrel{◀}}{\vdash (\Sigma,\ f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p) \mathrel{◀}}\;(\mathsf{sig}_{\mathsf{decl}◀}) \\[2em]
\frac{\begin{aligned}& {=} \\ & \quad \mathcal{D} \\ & \quad \mathsf{data}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa \\ & \qquad \mathsf{where} \\ & \qquad \quad D_1 \mathrel{▶} \zeta_1 \oplus \Pi_1 \mathrel{≔} \bar c_1; \\ & \qquad \quad \dots; \\ & \qquad \quad D_k \mathrel{▶} \zeta_k \oplus \Pi_k \mathrel{≔} \bar c_k \\[0.6em] & \vdash \Sigma \mathrel{◀}\end{aligned}}{\vdash (\Sigma,\ \mathcal{D}) \mathrel{◀}}\;(\mathsf{sig}_{\mathsf{data}◀}) \\[2em]
\frac{\begin{aligned}& {=} \\ & \quad \mathcal{D} \\ & \quad \mathsf{codata}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa \\ & \qquad \mathsf{where} \\ & \qquad \quad D_1 \mathrel{▶} \zeta_1 \oplus \Pi_1 \mathrel{≔} \bar d_1; \\ & \qquad \quad \dots; \\ & \qquad \quad D_k \mathrel{▶} \zeta_k \oplus \Pi_k \mathrel{≔} \bar d_k \\[0.6em] & \vdash \Sigma \mathrel{◀} \\[0.6em] & \begin{aligned}& \forall \bar s',\ \bar p' \text{ as many as } \bar s,\ \bar p.\ \forall j, i. \\ & \quad \text{⟹} \\ & \qquad \text{and} \\ & \qquad \quad \bar d_j[\bar s' / \bar s,\ \bar p' / \bar p] = (\bar d_{ji,1} \mid d_{ji} : (\Theta_{ji} \vdash B_{ji} \mathrel{◀} \psi_{ji}) \mathrel{▶} p_{ji};\ q_{ji} \mathrel{◀} \varsigma_{ji} \mid \bar d_{ji,2}) \\ & \qquad \quad \mathsf{rec}_{\mathcal{D}}(B_{ji}) \ne \bot \\ & \qquad \exists \chi. \\ & \qquad \quad \text{and} \\ & \qquad \qquad \psi_{ji} = \chi \\ & \qquad \qquad C[\bar s' / \bar s,\ \bar p' / \bar p] \implies \chi \le {11}^{\mathsf{p}}\end{aligned}\end{aligned}}{\vdash (\Sigma,\ \mathcal{D}) \mathrel{◀}}\;(\mathsf{sig}_{\mathsf{codata}◀})
\end{gathered}
```

## Properties

Ownership is stable under the [renamings](09-substitution.md#renamings): renamed, a term has the same ownership, given ownerships $`\varphi'`$ of the variables that give the image of each variable its ownership, as the types of a context are renamed:

```math
\begin{aligned}
& \forall x.\ \varphi'(\alpha(x)) = \varphi(x) \text{ and } \Sigma;\ \varphi \vdash t \mathrel{◀} p;\ m \implies \Sigma;\ \varphi' \vdash t[\alpha] \mathrel{◀} p;\ m &&(\mathsf{ren}_{◀}.t) \\[1em]
& \text{⟹} &&(\mathsf{ren}_{◀}.\bar t) \\
& \quad \text{and} \\
& \qquad \forall x.\ \varphi'(\alpha(x)) = \varphi(x) \\
& \qquad \Sigma;\ \varphi \vdash \bar t \mathrel{◀} \bar o;\ \Theta;\ m \\
& \quad \Sigma;\ \varphi' \vdash \bar t[\alpha] \mathrel{◀} \bar o;\ \Theta[\alpha];\ m
\end{aligned}
```

Ownership holds in every signature that has more entries after its own, all of distinct names, since it reads its signature by the entries that it has, its constants, its data types and its codata types, and by the shapes of the nested fields of a block, which the requirement of the recursion of a recursor reads: each nested field has a shape at each position of its type, and the shape of a lifting reads only the entries before it, so that an entry after them, of another name, is no lifting that a shape reads, while a signature that has the entries of its own among others may give a shape a lifting that it lacked, or an entry of the same name as one of them.
The judgment $`{\vdash \Sigma \mathrel{◀}}`$ checks the body of a constant definition in the signature before it, which every later signature extends by entries after it:

```math
\begin{aligned}
& \text{⟹} &&(\mathsf{ext}_{◀}.t) \\
& \quad \text{and} \\
& \qquad \text{the names of } \Sigma,\ e_1, \dots, e_n \text{ are distinct} \\
& \qquad \Sigma;\ \varphi \vdash t \mathrel{◀} p;\ m \\
& \quad \Sigma,\ e_1, \dots, e_n;\ \varphi \vdash t \mathrel{◀} p;\ m \\[1em]
& \text{⟹} &&(\mathsf{ext}_{◀}.\bar t) \\
& \quad \text{and} \\
& \qquad \text{the names of } \Sigma,\ e_1, \dots, e_n \text{ are distinct} \\
& \qquad \Sigma;\ \varphi \vdash \bar t \mathrel{◀} \bar o;\ \Theta;\ m \\
& \quad \Sigma,\ e_1, \dots, e_n;\ \varphi \vdash \bar t \mathrel{◀} \bar o;\ \Theta;\ m
\end{aligned}
```
