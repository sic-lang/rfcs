# Typing

This annex defines the judgments of typing and of equality, with those of the signatures, of the contexts, of the arguments of the telescopes and of the instances, of the telescopes in a sort, of the fields and of the destructors of a block, and of the entries of the signatures, and their properties.
It builds on the [sorts](07-sorts.md), the [substitution](09-substitution.md), the [usage](11-usage.md) and the [ownership](12-ownership.md).

## Definitions

This section gives the judgments, then their rules, by the objects they check: the signatures and their entries, the contexts, the types, the terms, the arguments, the telescopes in a sort, and the fields and the destructors of a block.

### Judgments

The judgments are those of Martin-Löf type theory, as [Nordström, Petersson and Smith](https://intuitionistic.wordpress.com/wp-content/uploads/2010/07/nordstrom-et-al-type-theory.pdf) present them, with judgments for the signatures and their entries, the contexts, the arguments and the telescopes in a sort:

| Judgment | Reading |
| --- | --- |
| $`\vdash \Sigma`$ | $`\Sigma`$ is a well-formed signature |
| $`\Sigma \vdash f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \mathrel{≔} t`$ | The constant definition is well formed |
| $`\Sigma \vdash f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p`$ | The constant declaration is well formed |
| $`\Sigma \vdash \Gamma`$ | $`\Gamma`$ is a well-formed context |
| $`\Sigma;\ \Gamma \vdash A`$ | $`A`$ is a type |
| $`\Sigma;\ \Gamma \vdash A \equiv B`$ | $`A`$ and $`B`$ are equal types |
| $`\Sigma;\ \Gamma \vdash t : A`$ | $`t`$ is a term of type $`A`$ |
| $`\Sigma;\ \Gamma \vdash t \equiv u : A`$ | $`t`$ and $`u`$ are equal terms of type $`A`$ |
| $`\Sigma;\ \Gamma \vdash \bar t : \Theta`$ | $`\bar t`$ are arguments of the telescope $`\Theta`$ |
| $`\Sigma;\ \Gamma \vdash \bar t \equiv \bar u : \Theta`$ | $`\bar t`$ and $`\bar u`$ are equal arguments of $`\Theta`$ |
| $`\Sigma;\ \Gamma \vdash \bar a : \Delta`$ | $`\bar a`$ are arguments of the parameters $`\Delta`$ |
| $`\Sigma;\ \Gamma \vdash \bar a_1 \equiv \bar a_2 : \Delta`$ | $`\bar a_1`$ and $`\bar a_2`$ are equal arguments of $`\Delta`$ |
| $`\Sigma;\ \Gamma \vdash \Theta : \kappa`$ | The telescope $`\Theta`$ lives in the sort $`\kappa`$ |
| $`\Sigma;\ \Gamma \vdash \Theta_1 \equiv \Theta_2 : \kappa`$ | $`\Theta_1`$ and $`\Theta_2`$ are equal telescopes in the sort $`\kappa`$ |
| $`\Sigma;\ \Gamma \vdash_{\mathcal{D}} \Theta : \kappa`$ | The fields $`\Theta`$ of a constructor of the block $`\mathcal{D}`$ live in the sort $`\kappa`$ |
| $`\Sigma;\ \Gamma \vdash_{\mathcal{D}} \bar d : \kappa`$ | The destructors $`\bar d`$ of a codata type of the block $`\mathcal{D}`$ live in the sort $`\kappa`$ |
| $`\Sigma \vdash \mathsf{data}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} \bar c_1;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \bar c_k`$ | The type declaration is well formed |
| $`\Sigma \vdash \mathsf{codata}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} \bar d_1;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \bar d_k`$ | The type declaration is well formed |

The judgments are defined together, except the last four, which build on the others.
Typing and equality carry no grade: the usage and the ownership of a term are checked by the judgments of [usage](11-usage.md) and of [ownership](12-ownership.md), which the rule of the constant definitions reads.
Equality is written $`\equiv`$, and $`=`$ in the premises of a rule is the equality of the metalanguage, which for the levels is the one of the [levels](06-levels.md), and for sequences of levels holds on each component.

A context has a variable $`x : A`$, written $`x : A \in \Gamma`$, when one of its entries is this variable, and a second-order variable $`X : (\Theta \vdash A \mathrel{◀} \psi)`$, written $`X : (\Theta \vdash A \mathrel{◀} \psi) \in \Gamma`$, likewise, by its last entry or by the entries before it; $`x \notin \Gamma`$ means that no entry of $`\Gamma`$ is a variable named $`x`$:

```math
\begin{gathered}
\frac{}{x : A \in (\Gamma,\ x : A)}\;(\in_\Gamma.x) \\[1em]
\frac{x : A \in \Gamma}{x : A \in (\Gamma,\ y : B)}\;(\in_\Gamma.x,y) \\[1em]
\frac{x : A \in \Gamma}{x : A \in (\Gamma,\ Y : (\Theta \vdash B \mathrel{◀} \psi))}\;(\in_\Gamma.x,Y) \\[1em]
\frac{}{X : (\Theta \vdash A \mathrel{◀} \psi) \in (\Gamma,\ X : (\Theta \vdash A \mathrel{◀} \psi))}\;(\in_\Gamma.X) \\[1em]
\frac{X : (\Theta \vdash A \mathrel{◀} \psi) \in \Gamma}{X : (\Theta \vdash A \mathrel{◀} \psi) \in (\Gamma,\ y : B)}\;(\in_\Gamma.X,y) \\[1em]
\frac{X : (\Theta_1 \vdash A \mathrel{◀} \psi_1) \in \Gamma}{X : (\Theta_1 \vdash A \mathrel{◀} \psi_1) \in (\Gamma,\ Y : (\Theta_2 \vdash B \mathrel{◀} \psi_2))}\;(\in_\Gamma.X,Y)
\end{gathered}
```

```math
\begin{aligned}
& x \notin \varepsilon &&(\notin_\Gamma) \\
& x \notin (\Gamma,\ y : B) \iff x \ne y \text{ and } x \notin \Gamma \\
& x \notin (\Gamma,\ Y : (\Theta \vdash B \mathrel{◀} \psi)) \iff x \ne Y \text{ and } x \notin \Gamma
\end{aligned}
```

The instance of an entry with the sort variables $`\bar s`$, the level variables $`\bar l`$ and the grade variables $`\bar p`$ at the qualities $`\bar s'`$, the levels $`\bar l'`$ and the grades $`\bar p'`$, as many as the variables of each kind, gives its type, its body, its parameters, its sort, and the grades, the constructors and the destructors of its types at the instance $`\bar s'`$, $`\bar p'`$, in which it [instantiates](09-substitution.md) the level variables $`[\bar l' / \bar l]`$; the rules write it $`A[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p]`$, as if the instance were substituted, and $`A[\bar s' / \bar s,\ \bar p' / \bar p]`$ when it keeps the level variables:

```math
\begin{aligned}
& A[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p] = A[\bar s' / \bar s,\ \bar p' / \bar p][\bar l' / \bar l] &&(\mathsf{inst}_e)
\end{aligned}
```

### Signatures and Entries

A signature is empty, or a signature extended by an entry that is well formed in it, and whose names no entry of the signature introduces, a type declaration naming each of its types once:

```math
\begin{gathered}
\frac{}{\vdash \varnothing}\;(\mathsf{sig}_\varnothing) \\[1em]
\frac{\begin{gathered}{}\Sigma \vdash f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \mathrel{≔} t \\ \text{no entry of } \Sigma \text{ introduces } f\end{gathered}}{\vdash \Sigma,\ f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \mathrel{≔} t}\;(\mathsf{sig}_{\mathsf{def}}) \\[1em]
\frac{\begin{gathered}{}\Sigma \vdash f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \\ \text{no entry of } \Sigma \text{ introduces } f\end{gathered}}{\vdash \Sigma,\ f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p}\;(\mathsf{sig}_{\mathsf{decl}}) \\[1em]
\frac{\begin{gathered}{}\Sigma \vdash \mathsf{data}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} \bar c_1;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \bar c_k \\ \text{the names } D_1, \dots, D_k \text{ are distinct} \\ \text{no entry of } \Sigma \text{ introduces one of } D_1, \dots, D_k\end{gathered}}{\vdash \Sigma,\ \mathsf{data}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} \bar c_1;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \bar c_k}\;(\mathsf{sig}_{\mathsf{data}}) \\[1em]
\frac{\begin{gathered}{}\Sigma \vdash \mathsf{codata}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} \bar d_1;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \bar d_k \\ \text{the names } D_1, \dots, D_k \text{ are distinct} \\ \text{no entry of } \Sigma \text{ introduces one of } D_1, \dots, D_k\end{gathered}}{\vdash \Sigma,\ \mathsf{codata}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} \bar d_1;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \bar d_k}\;(\mathsf{sig}_{\mathsf{codata}})
\end{gathered}
```

An entry is checked in the empty context, once with its level variables, and for each instance of its sort and grade variables, which are finitely many, so that its rules hold whatever instantiates them.
At each instance of its sort and grade variables, the type of a constant definition or declaration is a type of some sort, which may depend on the instance, and the body of a constant definition is a term of its type that uses no variable and has the ownership of the definition, in the mode of the definition:

```math
\begin{gathered}
\frac{\begin{aligned}& \forall \bar s',\ \bar p' \text{ as many as } \bar s,\ \bar p.\ \exists \kappa. \\ & \quad \text{and} \\ & \qquad \Sigma;\ \varepsilon \vdash A[\bar s' / \bar s,\ \bar p' / \bar p] : \kappa \\ & \qquad \Sigma;\ \varepsilon \vdash t[\bar s' / \bar s,\ \bar p' / \bar p] : A[\bar s' / \bar s,\ \bar p' / \bar p] \\ & \qquad \Sigma;\ {00}^{\gamma} \vdash t[\bar s' / \bar s,\ \bar p' / \bar p] \mathrel{▶} m \\ & \qquad \Sigma;\ \varepsilon \vdash t[\bar s' / \bar s,\ \bar p' / \bar p] \mathrel{◀} p;\ m\end{aligned}}{\Sigma \vdash f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \mathrel{≔} t}\;(\mathsf{def}) \\[1em]
\frac{\forall \bar s',\ \bar p' \text{ as many as } \bar s,\ \bar p.\ \exists \kappa.\ \Sigma;\ \varepsilon \vdash A[\bar s' / \bar s,\ \bar p' / \bar p] : \kappa}{\Sigma \vdash f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p}\;(\mathsf{decl})
\end{gathered}
```

### Contexts

A context is empty, in a well-formed signature, or a context extended by a variable whose type is a type in it, or by a second-order variable whose type is a type in it extended by its telescope, and the ownership of whose result has a constant or a factor, since the grades have no greatest element that an empty meet would be, with a name that the context does not have:

```math
\begin{gathered}
\frac{\vdash \Sigma}{\Sigma \vdash \varepsilon}\;(\mathsf{ctx}_\varepsilon) \\[1em]
\frac{\begin{gathered}{}\Sigma;\ \Gamma \vdash A \\ x \notin \Gamma\end{gathered}}{\Sigma \vdash \Gamma,\ x : A}\;(\mathsf{ctx}_x) \\[1em]
\frac{\begin{gathered}{}\Sigma;\ \Gamma,\ \Theta \vdash A \\ X \notin \Gamma \\ \psi \text{ has a constant or a factor}\end{gathered}}{\Sigma \vdash \Gamma,\ X : (\Theta \vdash A \mathrel{◀} \psi)}\;(\mathsf{ctx}_X)
\end{gathered}
```

### Types

A term of a sort is a type, and two equal terms of a sort are equal types; the equality of types is an equivalence:

```math
\begin{gathered}
\frac{\Sigma;\ \Gamma \vdash A : U_l}{\Sigma;\ \Gamma \vdash A}\;(U_{\mathsf{type}}) \\[1em]
\frac{\Sigma;\ \Gamma \vdash A : \Omega_l}{\Sigma;\ \Gamma \vdash A}\;(\Omega_{\mathsf{type}}) \\[1em]
\frac{\Sigma;\ \Gamma \vdash A}{\Sigma;\ \Gamma \vdash A \equiv A}\;(\mathsf{refl}_{\mathsf{type}}) \\[1em]
\frac{\Sigma;\ \Gamma \vdash A \equiv B}{\Sigma;\ \Gamma \vdash B \equiv A}\;(\mathsf{sym}_{\mathsf{type}}) \\[1em]
\frac{\begin{gathered}{}\Sigma;\ \Gamma \vdash A_1 \equiv A_2 \\ \Sigma;\ \Gamma \vdash A_2 \equiv A_3\end{gathered}}{\Sigma;\ \Gamma \vdash A_1 \equiv A_3}\;(\mathsf{trans}_{\mathsf{type}}) \\[1em]
\frac{\Sigma;\ \Gamma \vdash A \equiv B : U_l}{\Sigma;\ \Gamma \vdash A \equiv B}\;(U_{\mathsf{type}\equiv}) \\[1em]
\frac{\Sigma;\ \Gamma \vdash A \equiv B : \Omega_l}{\Sigma;\ \Gamma \vdash A \equiv B}\;(\Omega_{\mathsf{type}\equiv})
\end{gathered}
```

### Terms

A variable has the type of its entry, and an application of a second-order variable to arguments of its telescope has its type, in which the arguments are substituted for the variables of the telescope:

```math
\begin{gathered}
\frac{\begin{gathered}{}\Sigma \vdash \Gamma \\ x : A \in \Gamma\end{gathered}}{\Sigma;\ \Gamma \vdash x : A}\;(\mathsf{var}) \\[1em]
\frac{\begin{gathered}{}X : (\Theta \vdash A \mathrel{◀} \psi) \in \Gamma \\ \Sigma;\ \Gamma \vdash \bar t : \Theta\end{gathered}}{\Sigma;\ \Gamma \vdash X[\bar t] : A[\bar t / \Theta]}\;(\mathsf{var}_X)
\end{gathered}
```

An instance of a constant, defined or declared, has the type of its entry at this instance; a sort $`U_l`$ or $`\Omega_l`$ is in the universe above its level; an instance of a declared type, whose arguments are arguments of its parameters, is in the sort of its type declaration; a constructor of one of its types, applied to arguments of its fields at the instance that it carries, is a term of this instance:

```math
\begin{gathered}
\frac{\begin{gathered}{}\Sigma \vdash \Gamma \\ f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \in \Sigma \\ \bar s',\ \bar l',\ \bar p' \text{ as many as } \bar s,\ \bar l,\ \bar p\end{gathered}}{\Sigma;\ \Gamma \vdash f.\{\bar s';\ \bar l';\ \bar p'\} : A[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p]}\;(f) \\[1em]
\frac{\Sigma \vdash \Gamma}{\Sigma;\ \Gamma \vdash U_l : U_{l + 1}}\;(U) \\[1em]
\frac{\Sigma \vdash \Gamma}{\Sigma;\ \Gamma \vdash \Omega_l : U_{l + 1}}\;(\Omega) \\[1em]
\frac{\begin{gathered}{}D.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa \mathrel{▶} \zeta \in \Sigma \\ \bar s',\ \bar l',\ \bar p' \text{ as many as } \bar s,\ \bar l,\ \bar p \\ \Sigma;\ \Gamma \vdash \bar a : \Delta[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p]\end{gathered}}{\Sigma;\ \Gamma \vdash D.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a : \kappa[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p]}\;(D) \\[1em]
\frac{\begin{gathered}{}(\mathsf{data}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ \dots;\ D \mathrel{▶} \zeta \mathrel{≔} \dots \mid c : \Theta \mid \dots;\ \dots) \in \Sigma \\ \bar s',\ \bar l',\ \bar p' \text{ as many as } \bar s,\ \bar l,\ \bar p \\ \Sigma;\ \Gamma \vdash \bar a : \Delta[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p] \\ \Sigma;\ \Gamma \vdash \bar t : \Theta[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p][\bar a / \Delta]\end{gathered}}{\Sigma;\ \Gamma \vdash (D.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a).c(\bar t) : D.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a}\;(c)
\end{gathered}
```

A recursor eliminates a term of an instance of a type of a block, with a motive for each type of the block and a branch for each constructor of each type.
In its rules, the block $`\mathcal{D}`$ has the types $`D_1, \dots, D_k`$, the type $`D_j`$ the constructors $`\bar c_j = c_{j1} : \Theta_{j1} \mid \dots \mid c_{jn_j} : \Theta_{jn_j}`$, and the recursor eliminates a term of the type $`D_h`$; at the instance $`\bar s',\ \bar l',\ \bar p'`$ of its variables and at the arguments $`\bar a`$, $`T_j`$ is the instance $`D_j.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a`$ of each type and $`\Theta'_{ji}`$ the fields $`\Theta_{ji}[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p][\bar a / \Delta]`$ of each constructor, whose variables are $`\bar x_{ji}`$.
The parameters are uniform, so that the motives $`\bar C = (z.\, C_1,\ \dots,\ z.\, C_k)`$ bind the term only, and the branches $`\bar u = (D_1.c_{11}(\bar x_{11};\ \bar y_{11}) \Rightarrow u_{11},\ \dots,\ D_k.c_{kn_k}(\bar x_{kn_k};\ \bar y_{kn_k}) \Rightarrow u_{kn_k})`$ bind the fields and the recursive results.
The recursive results $`\mathsf{res}_{\bar C}(\mathsf{rec}_{\mathcal{D}}(\Theta_{ji}),\ \bar x_{ji})`$ of the fields of a constructor are a variable $`y : C_j[x / z]`$ for each variable $`x`$ of a recursive field of the type $`D_j`$, in order, the motive of the type of the field at the field, where [$`\mathsf{rec}_{\mathcal{D}}(\Theta)`$](#fields-of-a-block) gives the type of the block of each field of a telescope, or $`\bot`$; the recursive results $`\mathsf{res}_f(\mathsf{rec}_{\mathcal{D}}(\Theta),\ \bar t)`$ of terms of the fields are the terms $`f(D, t)`$ for each term $`t`$ of a recursive field of the type $`D`$, in order:

```math
\begin{aligned}
& \mathsf{res}_{\bar C}((),\ ()) = \varepsilon &&(\mathsf{results}) \\
& \mathsf{res}_{\bar C}((D_j,\ \bar D),\ (x,\ \bar x)) = (y : C_j[x / z],\ \mathsf{res}_{\bar C}(\bar D,\ \bar x)) \\
& \mathsf{res}_{\bar C}((\bot,\ \bar D),\ (x,\ \bar x)) = \mathsf{res}_{\bar C}(\bar D,\ \bar x) \\[1em]
& \mathsf{res}_f((),\ ()) = () &&(\mathsf{results}_t) \\
& \mathsf{res}_f((D,\ \bar D),\ (t,\ \bar t)) = (f(D, t),\ \mathsf{res}_f(\bar D,\ \bar t)) \\
& \mathsf{res}_f((\bot,\ \bar D),\ (t,\ \bar t)) = \mathsf{res}_f(\bar D,\ \bar t)
\end{aligned}
```

The recursor has the motive of the type of its term at the term; each motive is a type of one sort $`\kappa_C`$ over a term of its type, and each branch a term of the motive of its type at its constructor applied to the variables of its fields, in the context extended by its fields and its recursive results; the motives on a block of propositions that has a constructor are propositions, since the proofs of a proposition need not compute:

```math
\frac{\begin{gathered}{}(\mathsf{data}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} \bar c_1;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \bar c_k) \in \Sigma \\ \bar s',\ \bar l',\ \bar p' \text{ as many as } \bar s,\ \bar l,\ \bar p \\ \Sigma;\ \Gamma \vdash \bar a : \Delta[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p] \\ \Sigma;\ \Gamma \vdash t : T_h \\ \forall j.\ \Sigma;\ \Gamma,\ z : T_j \vdash C_j : \kappa_C \\ \forall j, i.\ \Sigma;\ \Gamma,\ \Theta'_{ji},\ \mathsf{res}_{\bar C}(\mathsf{rec}_{\mathcal{D}}(\Theta_{ji}),\ \bar x_{ji}) \vdash u_{ji} : C_j[T_j.c_{ji}(\bar x_{ji}) / z] \\ \kappa_C \text{ is a universe of propositions if } \kappa[\bar s' / \bar s,\ \bar p' / \bar p] \text{ is one and } \bar c_1, \dots, \bar c_k \text{ are not all empty}\end{gathered}}{\Sigma;\ \Gamma \vdash \mathsf{rec}_r\ T_h\ t\ \mathsf{return}\ \bar C\ \mathsf{with}\ \bar u : C_h[t / z]}\;(\mathsf{rec})
```

A codata type is observed by its destructors.
In the rules of the observations, the codata type $`D`$ has the destructors $`\bar d`$, and $`T`$ is its instance $`D.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a`$; the instance $`\bar d[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p] = (\bar d_1 \mid d : (\Theta \vdash B \mathrel{◀} \psi) \mathrel{▶} p;\ q \mid \bar d_2)`$ of the destructors decomposes them at the destructor $`d`$ observed, whose telescope and result are in the scope of the parameters extended by the destructors $`\bar d_1`$ before it.
An observation of a term of an instance, whose arguments are arguments of the parameters, by one of its destructors, applied to arguments of its telescope, is a term of its result at these arguments, the destructors before it being the [observations](09-substitution.md) $`[\bar a / \Delta,\ t.T / \bar d_1]`$ of the term by them:

```math
\frac{\begin{gathered}{}(\mathsf{codata}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ \dots;\ D \mathrel{▶} \zeta \mathrel{≔} \bar d;\ \dots) \in \Sigma \\ \bar s',\ \bar l',\ \bar p' \text{ as many as } \bar s,\ \bar l,\ \bar p \\ \bar d[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p] = (\bar d_1 \mid d : (\Theta \vdash B \mathrel{◀} \psi) \mathrel{▶} p;\ q \mid \bar d_2) \\ \Sigma;\ \Gamma \vdash \bar a : \Delta[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p] \\ \Sigma;\ \Gamma \vdash t : T \\ \Sigma;\ \Gamma \vdash \bar t : \Theta[\bar a / \Delta,\ t.T / \bar d_1]\end{gathered}}{\Sigma;\ \Gamma \vdash t.(T.d)(\bar t) : B[\bar a / \Delta,\ t.T / \bar d_1][\bar t / \Theta]}\;(d)
```

A corecursor builds a term of an instance of a type of a block of codata types from a state, with a state for each type of the block and a branch for each destructor of each type.
In its rules, the block has the types $`D_1, \dots, D_k`$, the type $`D_j`$ the destructors $`\bar d_j`$, and the corecursor builds a term of the type $`D_h`$; at the instance $`\bar s',\ \bar l',\ \bar p'`$ of its variables and at the arguments $`\bar a`$, $`T_j`$ is the instance $`D_j.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a`$ of each type, and $`\bar d_j[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p] = (\bar d_{ji,1} \mid d_{ji} : (\Theta_{ji} \vdash B_{ji} \mathrel{◀} \psi_{ji}) \mathrel{▶} p_{ji};\ q_{ji} \mid \bar d_{ji,2})`$ decomposes the destructors of each type at each of them.
The recursive destructors have the types of the block at the parameters themselves, which are thus uniform, so that the states $`\bar\Theta = (\Theta_1,\ \dots,\ \Theta_k)`$ bind none of them, and the branches $`\bar g = (D_1.d_{11}(;\ \bar y_1;\ \bar z_{11}) \Rightarrow g_{11},\ \dots,\ D_k.d_{kn_k}(;\ \bar y_k;\ \bar z_{kn_k}) \Rightarrow g_{kn_k})`$ bind the variables $`\bar y_j`$ of the state of their type and $`\bar z_{ji}`$ of the telescope of their destructor; $`c_j`$ is the corecursor $`\mathsf{corec}_r\ T_j\ \mathsf{from}\ \bar y_j\ \mathsf{return}\ \bar\Theta\ \mathsf{with}\ \bar g`$ of each type from the variables of its state.
A corecursor from arguments of the state of its type is a term of its instance; each state is a telescope of a sort $`\kappa_j`$ of its own, and each branch a term of the result of its destructor, over the variables of the state of its type and of the telescope of its destructor, the destructors before it being the observations $`[\bar a / \Delta,\ c_j.T_j / \bar d_{ji,1}]`$ of the corecursor of its type from the variables of its state:

```math
\frac{\begin{gathered}{}(\mathsf{codata}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} \bar d_1;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \bar d_k) \in \Sigma \\ \bar s',\ \bar l',\ \bar p' \text{ as many as } \bar s,\ \bar l,\ \bar p \\ \Sigma;\ \Gamma \vdash \bar a : \Delta[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p] \\ \Sigma;\ \Gamma \vdash \bar t : \Theta_h \\ \forall j.\ \Sigma;\ \Gamma \vdash \Theta_j : \kappa_j \\ \forall j, i.\ \Sigma;\ \Gamma,\ \Theta_j,\ \Theta_{ji}[\bar a / \Delta,\ c_j.T_j / \bar d_{ji,1}] \vdash g_{ji} : B_{ji}[\bar a / \Delta,\ c_j.T_j / \bar d_{ji,1}]\end{gathered}}{\Sigma;\ \Gamma \vdash \mathsf{corec}_r\ T_h\ \mathsf{from}\ \bar t\ \mathsf{return}\ \bar\Theta\ \mathsf{with}\ \bar g : T_h}\;(\mathsf{corec})
```

A term has every type equal to its own:

```math
\frac{\begin{gathered}{}\Sigma;\ \Gamma \vdash t : A \\ \Sigma;\ \Gamma \vdash A \equiv B\end{gathered}}{\Sigma;\ \Gamma \vdash t : B}\;(\mathsf{conv})
```

### Equal Terms

The equality of terms is an equivalence, which holds at every type equal to its own, and two proofs of a proposition are equal:

```math
\begin{gathered}
\frac{\Sigma;\ \Gamma \vdash t : A}{\Sigma;\ \Gamma \vdash t \equiv t : A}\;(\mathsf{refl}) \\[1em]
\frac{\Sigma;\ \Gamma \vdash t \equiv u : A}{\Sigma;\ \Gamma \vdash u \equiv t : A}\;(\mathsf{sym}) \\[1em]
\frac{\begin{gathered}{}\Sigma;\ \Gamma \vdash t_1 \equiv t_2 : A \\ \Sigma;\ \Gamma \vdash t_2 \equiv t_3 : A\end{gathered}}{\Sigma;\ \Gamma \vdash t_1 \equiv t_3 : A}\;(\mathsf{trans}) \\[1em]
\frac{\begin{gathered}{}\Sigma;\ \Gamma \vdash t \equiv u : A \\ \Sigma;\ \Gamma \vdash A \equiv B\end{gathered}}{\Sigma;\ \Gamma \vdash t \equiv u : B}\;(\mathsf{conv}_\equiv) \\[1em]
\frac{\begin{gathered}{}\Sigma;\ \Gamma \vdash t : A \\ \Sigma;\ \Gamma \vdash u : A \\ \Sigma;\ \Gamma \vdash A : \Omega_l\end{gathered}}{\Sigma;\ \Gamma \vdash t \equiv u : A}\;(\mathsf{irr})
\end{gathered}
```

Equal arguments give equal applications of a second-order variable, a constant definition unfolds to its body, and two instances of a constant, two sorts, two instances of a declared type with equal arguments, or two applications of a constructor at equal arguments of the instance and of its fields, at equal levels, are equal:

```math
\begin{gathered}
\frac{\begin{gathered}{}X : (\Theta \vdash A \mathrel{◀} \psi) \in \Gamma \\ \Sigma;\ \Gamma \vdash \bar t \equiv \bar u : \Theta\end{gathered}}{\Sigma;\ \Gamma \vdash X[\bar t] \equiv X[\bar u] : A[\bar t / \Theta]}\;(\mathsf{var}_{X\equiv}) \\[1em]
\frac{\begin{gathered}{}\Sigma \vdash \Gamma \\ f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \mathrel{≔} t \in \Sigma \\ \bar s',\ \bar l',\ \bar p' \text{ as many as } \bar s,\ \bar l,\ \bar p\end{gathered}}{\Sigma;\ \Gamma \vdash f.\{\bar s';\ \bar l';\ \bar p'\} \equiv t[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p] : A[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p]}\;(\delta) \\[1em]
\frac{\begin{gathered}{}\Sigma \vdash \Gamma \\ f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \in \Sigma \\ \bar s',\ \bar l_1,\ \bar p' \text{ as many as } \bar s,\ \bar l,\ \bar p \\ \bar l_2 \text{ as many as } \bar l \\ \bar l_1 = \bar l_2\end{gathered}}{\Sigma;\ \Gamma \vdash f.\{\bar s';\ \bar l_1;\ \bar p'\} \equiv f.\{\bar s';\ \bar l_2;\ \bar p'\} : A[\bar s' / \bar s,\ \bar l_1 / \bar l,\ \bar p' / \bar p]}\;(f_\equiv) \\[1em]
\frac{\begin{gathered}{}\Sigma \vdash \Gamma \\ l_1 = l_2\end{gathered}}{\Sigma;\ \Gamma \vdash U_{l_1} \equiv U_{l_2} : U_{l_1 + 1}}\;(U_\equiv) \\[1em]
\frac{\begin{gathered}{}\Sigma \vdash \Gamma \\ l_1 = l_2\end{gathered}}{\Sigma;\ \Gamma \vdash \Omega_{l_1} \equiv \Omega_{l_2} : U_{l_1 + 1}}\;(\Omega_\equiv) \\[1em]
\frac{\begin{gathered}{}D.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa \mathrel{▶} \zeta \in \Sigma \\ \bar s',\ \bar l_1,\ \bar p' \text{ as many as } \bar s,\ \bar l,\ \bar p \\ \bar l_2 \text{ as many as } \bar l \\ \Sigma;\ \Gamma \vdash \bar a_1 \equiv \bar a_2 : \Delta[\bar s' / \bar s,\ \bar l_1 / \bar l,\ \bar p' / \bar p] \\ \bar l_1 = \bar l_2\end{gathered}}{\Sigma;\ \Gamma \vdash D.\{\bar s';\ \bar l_1;\ \bar p'\}\ \bar a_1 \equiv D.\{\bar s';\ \bar l_2;\ \bar p'\}\ \bar a_2 : \kappa[\bar s' / \bar s,\ \bar l_1 / \bar l,\ \bar p' / \bar p]}\;(D_\equiv) \\[1em]
\frac{\begin{gathered}{}(\mathsf{data}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ \dots;\ D \mathrel{▶} \zeta \mathrel{≔} \dots \mid c : \Theta \mid \dots;\ \dots) \in \Sigma \\ \bar s',\ \bar l_1,\ \bar p' \text{ as many as } \bar s,\ \bar l,\ \bar p \\ \bar l_2 \text{ as many as } \bar l \\ \Sigma;\ \Gamma \vdash \bar a_1 \equiv \bar a_2 : \Delta[\bar s' / \bar s,\ \bar l_1 / \bar l,\ \bar p' / \bar p] \\ \bar l_1 = \bar l_2 \\ \Sigma;\ \Gamma \vdash \bar t \equiv \bar u : \Theta[\bar s' / \bar s,\ \bar l_1 / \bar l,\ \bar p' / \bar p][\bar a_1 / \Delta]\end{gathered}}{\Sigma;\ \Gamma \vdash (D.\{\bar s';\ \bar l_1;\ \bar p'\}\ \bar a_1).c(\bar t) \equiv (D.\{\bar s';\ \bar l_2;\ \bar p'\}\ \bar a_2).c(\bar u) : D.\{\bar s';\ \bar l_1;\ \bar p'\}\ \bar a_1}\;(c_\equiv)
\end{gathered}
```

Two recursors at equal arguments of the instance, at equal levels, on equal terms, with equal motives and equal branches, are equal, where $`T_j`$ and $`\Theta'_{ji}`$ are at the levels $`\bar l_1`$ and at the arguments $`\bar a_1`$; a recursor on a constructor applied to arguments of its fields, with the premises of $`(\mathsf{rec})`$, is equal to the branch of the constructor at these arguments and at their recursive results, where $`f(D_j, t)`$ is the recursor $`\mathsf{rec}_r\ T_j\ t\ \mathsf{return}\ \bar C\ \mathsf{with}\ \bar u`$; and a term $`e`$ over a term $`t`$ of a type whose single constructor has no recursive field is equal to the recursor on $`t`$, with the premises of $`(\mathsf{rec})`$, whose motive of the type is that of $`e`$ and whose branch is $`e`$ at the constructor applied to the variables of its fields, so that a recursor on such a type is never stuck:

```math
\begin{gathered}
\frac{\begin{gathered}{}(\mathsf{data}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} \bar c_1;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \bar c_k) \in \Sigma \\ \bar s',\ \bar l_1,\ \bar p' \text{ as many as } \bar s,\ \bar l,\ \bar p \\ \bar l_2 \text{ as many as } \bar l \\ \Sigma;\ \Gamma \vdash \bar a_1 \equiv \bar a_2 : \Delta[\bar s' / \bar s,\ \bar l_1 / \bar l,\ \bar p' / \bar p] \\ \bar l_1 = \bar l_2 \\ \Sigma;\ \Gamma \vdash t_1 \equiv t_2 : T_h \\ \forall j.\ \Sigma;\ \Gamma,\ z : T_j \vdash C_{1j} \equiv C_{2j} : \kappa_C \\ \forall j, i.\ \Sigma;\ \Gamma,\ \Theta'_{ji},\ \mathsf{res}_{\bar C_1}(\mathsf{rec}_{\mathcal{D}}(\Theta_{ji}),\ \bar x_{ji}) \vdash u_{1ji} \equiv u_{2ji} : C_{1j}[T_j.c_{ji}(\bar x_{ji}) / z] \\ \kappa_C \text{ is a universe of propositions if } \kappa[\bar s' / \bar s,\ \bar p' / \bar p] \text{ is one and } \bar c_1, \dots, \bar c_k \text{ are not all empty}\end{gathered}}{\Sigma;\ \Gamma \vdash \mathsf{rec}_r\ (D_h.\{\bar s';\ \bar l_1;\ \bar p'\}\ \bar a_1)\ t_1\ \mathsf{return}\ \bar C_1\ \mathsf{with}\ \bar u_1 \equiv \mathsf{rec}_r\ (D_h.\{\bar s';\ \bar l_2;\ \bar p'\}\ \bar a_2)\ t_2\ \mathsf{return}\ \bar C_2\ \mathsf{with}\ \bar u_2 : C_{1h}[t_1 / z]}\;(\mathsf{rec}_\equiv) \\[1em]
\frac{\begin{gathered}{}(\mathsf{data}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} \bar c_1;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \bar c_k) \in \Sigma \\ \bar s',\ \bar l',\ \bar p' \text{ as many as } \bar s,\ \bar l,\ \bar p \\ \Sigma;\ \Gamma \vdash \bar a : \Delta[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p] \\ \Sigma;\ \Gamma \vdash \bar t : \Theta'_{hi} \\ \forall j.\ \Sigma;\ \Gamma,\ z : T_j \vdash C_j : \kappa_C \\ \forall j, i.\ \Sigma;\ \Gamma,\ \Theta'_{ji},\ \mathsf{res}_{\bar C}(\mathsf{rec}_{\mathcal{D}}(\Theta_{ji}),\ \bar x_{ji}) \vdash u_{ji} : C_j[T_j.c_{ji}(\bar x_{ji}) / z] \\ \kappa_C \text{ is a universe of propositions if } \kappa[\bar s' / \bar s,\ \bar p' / \bar p] \text{ is one and } \bar c_1, \dots, \bar c_k \text{ are not all empty}\end{gathered}}{\Sigma;\ \Gamma \vdash \mathsf{rec}_r\ T_h\ (T_h.c_{hi}(\bar t))\ \mathsf{return}\ \bar C\ \mathsf{with}\ \bar u \equiv u_{hi}[\bar t / \bar x_{hi},\ \mathsf{res}_f(\mathsf{rec}_{\mathcal{D}}(\Theta_{hi}),\ \bar t) / \bar y_{hi}] : C_h[T_h.c_{hi}(\bar t) / z]}\;(\iota) \\[1em]
\frac{\begin{gathered}{}(\mathsf{data}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} \bar c_1;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \bar c_k) \in \Sigma \\ \bar s',\ \bar l',\ \bar p' \text{ as many as } \bar s,\ \bar l,\ \bar p \\ \bar c_h = c_{h1} : \Theta_{h1} \\ \mathsf{rec}_{\mathcal{D}}(\Theta_{h1}) = (\bot,\ \dots,\ \bot) \\ \Sigma;\ \Gamma \vdash \bar a : \Delta[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p] \\ \Sigma;\ \Gamma \vdash t : T_h \\ \Sigma;\ \Gamma,\ z : T_h \vdash e : C_h \\ D_h.c_{h1}(\bar x_{h1}) \Rightarrow e[T_h.c_{h1}(\bar x_{h1}) / z] \text{ is the branch of } c_{h1} \text{ in } \bar u \\ \forall j.\ \Sigma;\ \Gamma,\ z : T_j \vdash C_j : \kappa_C \\ \forall j, i.\ \Sigma;\ \Gamma,\ \Theta'_{ji},\ \mathsf{res}_{\bar C}(\mathsf{rec}_{\mathcal{D}}(\Theta_{ji}),\ \bar x_{ji}) \vdash u_{ji} : C_j[T_j.c_{ji}(\bar x_{ji}) / z] \\ \kappa_C \text{ is a universe of propositions if } \kappa[\bar s' / \bar s,\ \bar p' / \bar p] \text{ is one and } \bar c_1, \dots, \bar c_k \text{ are not all empty}\end{gathered}}{\Sigma;\ \Gamma \vdash e[t / z] \equiv \mathsf{rec}_r\ T_h\ t\ \mathsf{return}\ \bar C\ \mathsf{with}\ \bar u : C_h[t / z]}\;(\eta_c)
\end{gathered}
```

Two observations by the same destructor, at equal arguments of the instance, at equal levels, of equal terms, at equal arguments of its telescope, are equal, where $`T_1`$ and $`T_2`$ are the instances $`D.\{\bar s';\ \bar l_1;\ \bar p'\}\ \bar a_1`$ and $`D.\{\bar s';\ \bar l_2;\ \bar p'\}\ \bar a_2`$:

```math
\frac{\begin{gathered}{}(\mathsf{codata}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ \dots;\ D \mathrel{▶} \zeta \mathrel{≔} \bar d;\ \dots) \in \Sigma \\ \bar s',\ \bar l_1,\ \bar p' \text{ as many as } \bar s,\ \bar l,\ \bar p \\ \bar l_2 \text{ as many as } \bar l \\ \bar d[\bar s' / \bar s,\ \bar l_1 / \bar l,\ \bar p' / \bar p] = (\bar d_1 \mid d : (\Theta \vdash B \mathrel{◀} \psi) \mathrel{▶} p;\ q \mid \bar d_2) \\ \Sigma;\ \Gamma \vdash \bar a_1 \equiv \bar a_2 : \Delta[\bar s' / \bar s,\ \bar l_1 / \bar l,\ \bar p' / \bar p] \\ \bar l_1 = \bar l_2 \\ \Sigma;\ \Gamma \vdash t_1 \equiv t_2 : T_1 \\ \Sigma;\ \Gamma \vdash \bar t_1 \equiv \bar t_2 : \Theta[\bar a_1 / \Delta,\ t_1.T_1 / \bar d_1]\end{gathered}}{\Sigma;\ \Gamma \vdash t_1.(T_1.d)(\bar t_1) \equiv t_2.(T_2.d)(\bar t_2) : B[\bar a_1 / \Delta,\ t_1.T_1 / \bar d_1][\bar t_1 / \Theta]}\;(d_\equiv)
```

Two corecursors at equal arguments of the instance, at equal levels, from equal states, with equal states and equal branches, are equal, where $`T_j`$ and the destructors are at the levels $`\bar l_1`$ and at the arguments $`\bar a_1`$, and $`c_{1j}`$ is the corecursor $`\mathsf{corec}_r\ T_j\ \mathsf{from}\ \bar y_j\ \mathsf{return}\ \bar\Theta_1\ \mathsf{with}\ \bar g_1`$ of each type from the variables of its state; an observation of a corecursor by a destructor of its type, at arguments of its telescope, with the premises of $`(\mathsf{corec})`$, is equal to the branch of the destructor, with the terms of the state substituted for the variables of the state and the arguments for those of the telescope, where $`t_c`$ is the corecursor $`\mathsf{corec}_r\ T_h\ \mathsf{from}\ \bar t\ \mathsf{return}\ \bar\Theta\ \mathsf{with}\ \bar g`$:

```math
\begin{gathered}
\frac{\begin{gathered}{}(\mathsf{codata}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} \bar d_1;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \bar d_k) \in \Sigma \\ \bar s',\ \bar l_1,\ \bar p' \text{ as many as } \bar s,\ \bar l,\ \bar p \\ \bar l_2 \text{ as many as } \bar l \\ \Sigma;\ \Gamma \vdash \bar a_1 \equiv \bar a_2 : \Delta[\bar s' / \bar s,\ \bar l_1 / \bar l,\ \bar p' / \bar p] \\ \bar l_1 = \bar l_2 \\ \Sigma;\ \Gamma \vdash \bar t_1 \equiv \bar t_2 : \Theta_{1h} \\ \forall j.\ \Sigma;\ \Gamma \vdash \Theta_{1j} \equiv \Theta_{2j} : \kappa_j \\ \forall j, i.\ \Sigma;\ \Gamma,\ \Theta_{1j},\ \Theta_{ji}[\bar a_1 / \Delta,\ c_{1j}.T_j / \bar d_{ji,1}] \vdash g_{1ji} \equiv g_{2ji} : B_{ji}[\bar a_1 / \Delta,\ c_{1j}.T_j / \bar d_{ji,1}]\end{gathered}}{\Sigma;\ \Gamma \vdash \mathsf{corec}_r\ (D_h.\{\bar s';\ \bar l_1;\ \bar p'\}\ \bar a_1)\ \mathsf{from}\ \bar t_1\ \mathsf{return}\ \bar\Theta_1\ \mathsf{with}\ \bar g_1 \equiv \mathsf{corec}_r\ (D_h.\{\bar s';\ \bar l_2;\ \bar p'\}\ \bar a_2)\ \mathsf{from}\ \bar t_2\ \mathsf{return}\ \bar\Theta_2\ \mathsf{with}\ \bar g_2 : T_h}\;(\mathsf{corec}_\equiv) \\[1em]
\frac{\begin{gathered}{}(\mathsf{codata}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} \bar d_1;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \bar d_k) \in \Sigma \\ \bar s',\ \bar l',\ \bar p' \text{ as many as } \bar s,\ \bar l,\ \bar p \\ \Sigma;\ \Gamma \vdash \bar a : \Delta[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p] \\ \Sigma;\ \Gamma \vdash \bar t : \Theta_h \\ \Sigma;\ \Gamma \vdash \bar u : \Theta_{hi}[\bar a / \Delta,\ t_c.T_h / \bar d_{hi,1}] \\ \forall j.\ \Sigma;\ \Gamma \vdash \Theta_j : \kappa_j \\ \forall j, i.\ \Sigma;\ \Gamma,\ \Theta_j,\ \Theta_{ji}[\bar a / \Delta,\ c_j.T_j / \bar d_{ji,1}] \vdash g_{ji} : B_{ji}[\bar a / \Delta,\ c_j.T_j / \bar d_{ji,1}]\end{gathered}}{\Sigma;\ \Gamma \vdash t_c.(T_h.d_{hi})(\bar u) \equiv g_{hi}[\bar t / \bar y_h,\ \bar u / \bar z_{hi}] : B_{hi}[\bar a / \Delta,\ t_c.T_h / \bar d_{hi,1}][\bar u / \Theta_{hi}]}\;(\beta)
\end{gathered}
```

Two terms of an instance, whose arguments are arguments of the parameters, whose observations by each destructor, at the variables $`\bar z_i`$ of its telescope, are equal, the destructors before it being the observations of the first term, are equal, so that a term of a codata type is determined by its observations, where $`T`$ is the instance $`D.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a`$ and $`\bar d[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p] = (\bar d_{i,1} \mid d_i : (\Theta_i \vdash B_i \mathrel{◀} \psi_i) \mathrel{▶} p_i;\ q_i \mid \bar d_{i,2})`$ decomposes the destructors at each of them:

```math
\frac{\begin{gathered}{}(\mathsf{codata}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ \dots;\ D \mathrel{▶} \zeta \mathrel{≔} \bar d;\ \dots) \in \Sigma \\ \bar s',\ \bar l',\ \bar p' \text{ as many as } \bar s,\ \bar l,\ \bar p \\ \Sigma;\ \Gamma \vdash \bar a : \Delta[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p] \\ \Sigma;\ \Gamma \vdash t : T \\ \Sigma;\ \Gamma \vdash u : T \\ \forall i.\ \Sigma;\ \Gamma,\ \Theta_i[\bar a / \Delta,\ t.T / \bar d_{i,1}] \vdash t.(T.d_i)(\bar z_i) \equiv u.(T.d_i)(\bar z_i) : B_i[\bar a / \Delta,\ t.T / \bar d_{i,1}]\end{gathered}}{\Sigma;\ \Gamma \vdash t \equiv u : T}\;(\eta_d)
```

No rule equates two instances with different qualities or grades: two types that differ only by a grade are different types.

### Arguments

The arguments of a telescope are typed by its entries, each argument instantiating the types after it, whose grades typing ignores:

```math
\begin{gathered}
\frac{\Sigma \vdash \Gamma}{\Sigma;\ \Gamma \vdash () : \varepsilon}\;(\mathsf{tel}_\varepsilon) \\[1em]
\frac{\begin{gathered}{}\Sigma;\ \Gamma \vdash t : A \\ \Sigma;\ \Gamma \vdash \bar t : \Theta[t / x]\end{gathered}}{\Sigma;\ \Gamma \vdash (t,\ \bar t) : (x : A \mathrel{▶} p;\ q \mathrel{◀} r,\ \Theta)}\;(\mathsf{tel}_{,}) \\[1em]
\frac{\Sigma \vdash \Gamma}{\Sigma;\ \Gamma \vdash () \equiv () : \varepsilon}\;(\mathsf{tel}_{\varepsilon\equiv}) \\[1em]
\frac{\begin{gathered}{}\Sigma;\ \Gamma \vdash t \equiv u : A \\ \Sigma;\ \Gamma \vdash \bar t \equiv \bar u : \Theta[t / x]\end{gathered}}{\Sigma;\ \Gamma \vdash (t,\ \bar t) \equiv (u,\ \bar u) : (x : A \mathrel{▶} p;\ q \mathrel{◀} r,\ \Theta)}\;(\mathsf{tel}_{,\equiv})
\end{gathered}
```

The arguments of an instance are typed by the parameters of its type declaration, each argument instantiating the types after it, as a substitution of the second order of the parameters; the abstraction for a second-order variable is a term of its type under the variables $`\bar x`$ of its telescope:

```math
\begin{gathered}
\frac{\Sigma \vdash \Gamma}{\Sigma;\ \Gamma \vdash () : \varepsilon}\;(\mathsf{arg}_\varepsilon) \\[1em]
\frac{\begin{gathered}{}\Sigma;\ \Gamma \vdash \bar a : \Delta \\ \Sigma;\ \Gamma \vdash a : A[\bar a / \Delta]\end{gathered}}{\Sigma;\ \Gamma \vdash (\bar a,\ a) : (\Delta,\ x : A)}\;(\mathsf{arg}_x) \\[1em]
\frac{\begin{gathered}{}\Sigma;\ \Gamma \vdash \bar a : \Delta \\ \Sigma;\ \Gamma,\ \Theta[\bar a / \Delta] \vdash B : A[\bar a / \Delta]\end{gathered}}{\Sigma;\ \Gamma \vdash (\bar a,\ \bar x.\, B) : (\Delta,\ X : (\Theta \vdash A \mathrel{◀} \psi))}\;(\mathsf{arg}_X) \\[1em]
\frac{\Sigma \vdash \Gamma}{\Sigma;\ \Gamma \vdash () \equiv () : \varepsilon}\;(\mathsf{arg}_{\varepsilon\equiv}) \\[1em]
\frac{\begin{gathered}{}\Sigma;\ \Gamma \vdash \bar a_1 \equiv \bar a_2 : \Delta \\ \Sigma;\ \Gamma \vdash a_1 \equiv a_2 : A[\bar a_1 / \Delta]\end{gathered}}{\Sigma;\ \Gamma \vdash (\bar a_1,\ a_1) \equiv (\bar a_2,\ a_2) : (\Delta,\ x : A)}\;(\mathsf{arg}_{x\equiv}) \\[1em]
\frac{\begin{gathered}{}\Sigma;\ \Gamma \vdash \bar a_1 \equiv \bar a_2 : \Delta \\ \Sigma;\ \Gamma,\ \Theta[\bar a_1 / \Delta] \vdash B_1 \equiv B_2 : A[\bar a_1 / \Delta]\end{gathered}}{\Sigma;\ \Gamma \vdash (\bar a_1,\ \bar x.\, B_1) \equiv (\bar a_2,\ \bar x.\, B_2) : (\Delta,\ X : (\Theta \vdash A \mathrel{◀} \psi))}\;(\mathsf{arg}_{X\equiv})
\end{gathered}
```

### Telescopes in a Sort

A telescope lives in a sort $`\kappa`$ when each of its types lives in a sort that $`\kappa`$ [bounds](07-sorts.md), and an entry whose type is a proposition has a grade without use at run time:

```math
\begin{gathered}
\frac{\Sigma \vdash \Gamma}{\Sigma;\ \Gamma \vdash \varepsilon : \kappa}\;(\mathsf{tel}_{\kappa\varepsilon}) \\[1em]
\frac{\begin{gathered}{}\Sigma;\ \Gamma \vdash A : \kappa_1 \\ \kappa_1 \preceq \kappa_2 \\ \Sigma;\ \Gamma,\ x : A \vdash \Theta : \kappa_2 \\ \llcorner p \lrcorner \ne {11}^{\mathsf{m}} \text{ if the quality of } \kappa_1 \text{ is } \Omega\end{gathered}}{\Sigma;\ \Gamma \vdash (x : A \mathrel{▶} p;\ q \mathrel{◀} r,\ \Theta) : \kappa_2}\;(\mathsf{tel}_{\kappa,})
\end{gathered}
```

Two telescopes are equal in a sort $`\kappa`$ when their entries have the same grades, their types are equal types of sorts that $`\kappa`$ bounds, each under the entries before it in the first telescope, and an entry whose type is a proposition has a grade without use at run time:

```math
\begin{gathered}
\frac{\Sigma \vdash \Gamma}{\Sigma;\ \Gamma \vdash \varepsilon \equiv \varepsilon : \kappa}\;(\mathsf{tel}_{\kappa\varepsilon\equiv}) \\[1em]
\frac{\begin{gathered}{}\Sigma;\ \Gamma \vdash A_1 \equiv A_2 : \kappa_1 \\ \kappa_1 \preceq \kappa_2 \\ \Sigma;\ \Gamma,\ x : A_1 \vdash \Theta_1 \equiv \Theta_2 : \kappa_2 \\ \llcorner p \lrcorner \ne {11}^{\mathsf{m}} \text{ if the quality of } \kappa_1 \text{ is } \Omega\end{gathered}}{\Sigma;\ \Gamma \vdash (x : A_1 \mathrel{▶} p;\ q \mathrel{◀} r,\ \Theta_1) \equiv (x : A_2 \mathrel{▶} p;\ q \mathrel{◀} r,\ \Theta_2) : \kappa_2}\;(\mathsf{tel}_{\kappa,\equiv})
\end{gathered}
```

### Fields of a Block

A field of a constructor of a block of data types $`\mathcal{D}`$ is recursive when its type is an instance of a type of the block; $`\mathsf{rec}_{\mathcal{D}}(A)`$ names this type, $`\bot`$ when there is none, and $`\mathsf{rec}_{\mathcal{D}}(\Theta)`$ gives it for each field of a telescope, in order:

```math
\begin{aligned}
& \mathsf{rec}_{\mathcal{D}}(D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a) = D \text{ if } D \text{ is a type of } \mathcal{D} &&(\mathsf{recursive}_A) \\
& \mathsf{rec}_{\mathcal{D}}(A) = \bot \text{ otherwise} \\[1em]
& \mathsf{rec}_{\mathcal{D}}(\varepsilon) = () &&(\mathsf{recursive}_\Theta) \\
& \mathsf{rec}_{\mathcal{D}}(x : A \mathrel{▶} p;\ q \mathrel{◀} r,\ \Theta) = (\mathsf{rec}_{\mathcal{D}}(A),\ \mathsf{rec}_{\mathcal{D}}(\Theta))
\end{aligned}
```

The fields of a constructor of a block $`\mathcal{D} = \mathsf{data}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ \dots`$, at an instance $`\bar s'`$, $`\bar p'`$ of its sort and grade variables, live in a sort when those that are not recursive do, as the entries of a [telescope in a sort](#telescopes-in-a-sort), and each recursive field is a type $`D`$ of the block at this instance, at its level variables and at its parameters themselves $`\bar x_\Delta`$, the abstraction $`\bar x.\, X[\bar x]`$ for a second-order parameter $`X`$, a field on which no field after it depends:

```math
\begin{gathered}
\frac{\Sigma \vdash \Gamma}{\Sigma;\ \Gamma \vdash_{\mathcal{D}} \varepsilon : \kappa}\;(\mathsf{fields}_\varepsilon) \\[1em]
\frac{\begin{gathered}{}\mathsf{rec}_{\mathcal{D}}(A) = \bot \\ \Sigma;\ \Gamma \vdash A : \kappa_1 \\ \kappa_1 \preceq \kappa \\ \Sigma;\ \Gamma,\ x : A \vdash_{\mathcal{D}} \Theta : \kappa \\ \llcorner p \lrcorner \ne {11}^{\mathsf{m}} \text{ if the quality of } \kappa_1 \text{ is } \Omega\end{gathered}}{\Sigma;\ \Gamma \vdash_{\mathcal{D}} (x : A \mathrel{▶} p;\ q \mathrel{◀} r,\ \Theta) : \kappa}\;(\mathsf{fields}_{,}) \\[1em]
\frac{\begin{gathered}{}D \text{ is a type of } \mathcal{D} \\ x \text{ does not occur in } \Theta \\ \Sigma;\ \Gamma \vdash_{\mathcal{D}} \Theta : \kappa \\ \llcorner p \lrcorner \ne {11}^{\mathsf{m}} \text{ if the quality of } \kappa \text{ is } \Omega\end{gathered}}{\Sigma;\ \Gamma \vdash_{\mathcal{D}} (x : D.\{\bar s';\ \bar l;\ \bar p'\}\ \bar x_\Delta \mathrel{▶} p;\ q \mathrel{◀} r,\ \Theta) : \kappa}\;(\mathsf{fields}_{\mathsf{rec}})
\end{gathered}
```

### Destructors of a Block

A destructor of a codata type of a block of codata types $`\mathcal{D}`$ is recursive when its result is an instance of a type of the block, as a field is; $`\mathsf{rec}_{\mathcal{D}}(\bar d)`$ gives the type of the result of each destructor, in order:

```math
\begin{aligned}
& \mathsf{rec}_{\mathcal{D}}(\varepsilon) = () &&(\mathsf{recursive}_{\bar d}) \\
& \mathsf{rec}_{\mathcal{D}}(d : (\Theta \vdash B \mathrel{◀} \psi) \mathrel{▶} p;\ q \mid \bar d) = (\mathsf{rec}_{\mathcal{D}}(B),\ \mathsf{rec}_{\mathcal{D}}(\bar d))
\end{aligned}
```

The destructors $`\bar d`$ of a codata type of a block $`\mathcal{D} = \mathsf{codata}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ \dots`$, at an instance $`\bar s'`$, $`\bar p'`$ of its sort and grade variables, $`d_1 : (\Theta_1 \vdash B_1 \mathrel{◀} \psi_1) \mathrel{▶} p_1;\ q_1 \mid \dots \mid d_n : (\Theta_n \vdash B_n \mathrel{◀} \psi_n) \mathrel{▶} p_n;\ q_n`$, or $`\varepsilon`$ when there is none, live in a sort $`\kappa`$ of level $`l`$ when the arguments of each live in the universe $`U_l`$, whatever the quality of $`\kappa`$, so that a proposition may quantify over a type of its level.
The result of a destructor that is not recursive lives in a sort that $`\kappa`$ [bounds](07-sorts.md), a result that is a proposition having a grade without use at run time, and the destructor is a second-order variable of the context of the destructors after it, whose formation checks that the ownership of its result has a constant or a factor; the result of a recursive destructor is a type $`D`$ of the block at this instance, at its level variables and at its parameters themselves $`\bar x_\Delta`$, as the type of a recursive field is, with a grade without use at run time if $`\kappa`$ is a universe of propositions, and no destructor after it depends on it:

```math
\begin{gathered}
\frac{\Sigma \vdash \Gamma}{\Sigma;\ \Gamma \vdash_{\mathcal{D}} \varepsilon : \kappa}\;(\bar d_{\kappa\varepsilon}) \\[1em]
\frac{\begin{gathered}{}\mathsf{rec}_{\mathcal{D}}(B) = \bot \\ l \text{ is the level of } \kappa \\ \Sigma;\ \Gamma \vdash \Theta : U_l \\ \Sigma;\ \Gamma,\ \Theta \vdash B : \kappa_1 \\ \kappa_1 \preceq \kappa \\ \llcorner p \lrcorner \ne {11}^{\mathsf{m}} \text{ if the quality of } \kappa_1 \text{ is } \Omega \\ \Sigma;\ \Gamma,\ d : (\Theta \vdash B \mathrel{◀} \psi) \vdash_{\mathcal{D}} \bar d : \kappa\end{gathered}}{\Sigma;\ \Gamma \vdash_{\mathcal{D}} (d : (\Theta \vdash B \mathrel{◀} \psi) \mathrel{▶} p;\ q \mid \bar d) : \kappa}\;(\bar d_{\kappa|}) \\[1em]
\frac{\begin{gathered}{}D \text{ is a type of } \mathcal{D} \\ l \text{ is the level of } \kappa \\ \Sigma;\ \Gamma \vdash \Theta : U_l \\ \llcorner p \lrcorner \ne {11}^{\mathsf{m}} \text{ if the quality of } \kappa \text{ is } \Omega \\ d \text{ does not occur in } \bar d \\ \Sigma;\ \Gamma \vdash_{\mathcal{D}} \bar d : \kappa\end{gathered}}{\Sigma;\ \Gamma \vdash_{\mathcal{D}} (d : (\Theta \vdash D.\{\bar s';\ \bar l;\ \bar p'\}\ \bar x_\Delta \mathrel{◀} \psi) \mathrel{▶} p;\ q \mid \bar d) : \kappa}\;(\bar d_{\kappa\mathsf{rec}})
\end{gathered}
```

### Type Declarations

A block of data types $`\mathcal{D} = \mathsf{data}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} \bar c_1;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \bar c_k`$ is well formed when, at each instance of its sort and grade variables, its parameters form a context, the fields of each constructor live in its sort, and the constructors $`\bar c_j`$ of each type $`D_j`$ use the parameters as its grades $`\zeta_j`$ allow, the uses of all the constructors added, as their [usage](11-usage.md) adds them; the constructors of each type have distinct names.
The fields that are not recursive are checked in the signature $`\Sigma`$, which the block does not extend, so that the types of the block occur only as the types of the recursive fields, at its parameters, and the usage of the constructors in the signature $`\Sigma,\ \mathcal{D}`$, which reads the grades of the types of the block.
The fields of a type in a universe of propositions are propositions, by the rules $`(\mathsf{fields}_{,})`$ and $`(\mathsf{fields}_{\mathsf{rec}})`$:

```math
\frac{\begin{gathered}{}\begin{aligned}& \forall \bar s',\ \bar p' \text{ as many as } \bar s,\ \bar p. \\ & \quad \text{and} \\ & \qquad \Sigma \vdash \Delta[\bar s' / \bar s,\ \bar p' / \bar p] \\ & \qquad \forall j, i.\ \Sigma;\ \Delta[\bar s' / \bar s,\ \bar p' / \bar p] \vdash_{\mathcal{D}[\bar s' / \bar s,\ \bar p' / \bar p]} \Theta_{ji}[\bar s' / \bar s,\ \bar p' / \bar p] : \kappa[\bar s' / \bar s,\ \bar p' / \bar p] \\ & \qquad \forall j.\ \exists \gamma. \\ & \qquad \quad \text{and} \\ & \qquad \qquad \Sigma,\ \mathcal{D};\ \gamma \vdash \bar c_j[\bar s' / \bar s,\ \bar p' / \bar p] \mathrel{▶} {11}^{\mathsf{m}} \\ & \qquad \qquad \zeta_j[\bar s' / \bar s,\ \bar p' / \bar p] \le^{\gamma} \gamma\end{aligned} \\ \forall j.\ \text{the names } c_{j1}, \dots, c_{j n_j} \text{ are distinct}\end{gathered}}{\Sigma \vdash \mathcal{D}}\;(\mathsf{data})
```

A block of codata types is well formed likewise, with the destructors $`\bar d_j`$ of each type $`D_j`$ in place of its constructors: at each instance of its sort and grade variables, its parameters form a context, the destructors of each type live in its sort and use the parameters as its grades $`\zeta_j`$ allow, the uses of all the destructors added, as their [usage](11-usage.md) adds them; the destructors of each type have distinct names.
The arguments of the destructors and the results of those that are not recursive are checked in the signature $`\Sigma`$, which the block does not extend, so that the types of the block occur only as the results of the recursive destructors, at its parameters, and the usage of the destructors in the signature $`\Sigma,\ \mathcal{D}`$, which reads the grades of the types of the block:

```math
\frac{\begin{gathered}{}\begin{aligned}& \forall \bar s',\ \bar p' \text{ as many as } \bar s,\ \bar p. \\ & \quad \text{and} \\ & \qquad \Sigma \vdash \Delta[\bar s' / \bar s,\ \bar p' / \bar p] \\ & \qquad \forall j.\ \Sigma;\ \Delta[\bar s' / \bar s,\ \bar p' / \bar p] \vdash_{\mathcal{D}[\bar s' / \bar s,\ \bar p' / \bar p]} \bar d_j[\bar s' / \bar s,\ \bar p' / \bar p] : \kappa[\bar s' / \bar s,\ \bar p' / \bar p] \\ & \qquad \forall j.\ \exists \gamma. \\ & \qquad \quad \text{and} \\ & \qquad \qquad \Sigma,\ \mathcal{D};\ \gamma \vdash \bar d_j[\bar s' / \bar s,\ \bar p' / \bar p] \mathrel{▶} {11}^{\mathsf{m}} \\ & \qquad \qquad \zeta_j[\bar s' / \bar s,\ \bar p' / \bar p] \le^{\gamma} \gamma\end{aligned} \\ \forall j.\ \text{the names } d_{j1}, \dots, d_{j n_j} \text{ are distinct}\end{gathered}}{\Sigma \vdash \mathsf{codata}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} \bar d_1;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \bar d_k}\;(\mathsf{codata})
```

## Properties

Every judgment holds in a well-formed signature, and the signature that a well-formed signature extends is well formed:

```math
\begin{aligned}
& \Sigma \vdash f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \mathrel{≔} t \implies \vdash \Sigma &&(\mathsf{presup}_\Sigma.\mathsf{def}) \\[1em]
& \Sigma \vdash f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \implies \vdash \Sigma &&(\mathsf{presup}_\Sigma.\mathsf{decl}) \\[1em]
& \Sigma \vdash \Gamma \implies \vdash \Sigma &&(\mathsf{presup}_\Sigma.\Gamma) \\[1em]
& \Sigma;\ \Gamma \vdash A \implies \vdash \Sigma &&(\mathsf{presup}_\Sigma.A) \\[1em]
& \Sigma;\ \Gamma \vdash A \equiv B \implies \vdash \Sigma &&(\mathsf{presup}_\Sigma.A_\equiv) \\[1em]
& \Sigma;\ \Gamma \vdash t : A \implies \vdash \Sigma &&(\mathsf{presup}_\Sigma.t) \\[1em]
& \Sigma;\ \Gamma \vdash t \equiv u : A \implies \vdash \Sigma &&(\mathsf{presup}_\Sigma.t_\equiv) \\[1em]
& \Sigma;\ \Gamma \vdash \bar t : \Theta \implies \vdash \Sigma &&(\mathsf{presup}_\Sigma.\bar t) \\[1em]
& \Sigma;\ \Gamma \vdash \bar t \equiv \bar u : \Theta \implies \vdash \Sigma &&(\mathsf{presup}_\Sigma.\bar t_\equiv) \\[1em]
& \Sigma;\ \Gamma \vdash \bar a : \Delta \implies \vdash \Sigma &&(\mathsf{presup}_\Sigma.\bar a) \\[1em]
& \Sigma;\ \Gamma \vdash \bar a_1 \equiv \bar a_2 : \Delta \implies \vdash \Sigma &&(\mathsf{presup}_\Sigma.\bar a_\equiv) \\[1em]
& \Sigma;\ \Gamma \vdash \Theta : \kappa \implies \vdash \Sigma &&(\mathsf{presup}_\Sigma.\Theta) \\[1em]
& \Sigma;\ \Gamma \vdash \Theta_1 \equiv \Theta_2 : \kappa \implies \vdash \Sigma &&(\mathsf{presup}_\Sigma.\Theta_\equiv) \\[1em]
& \Sigma;\ \Gamma \vdash_{\mathcal{D}} \Theta : \kappa \implies \vdash \Sigma &&(\mathsf{presup}_\Sigma.\mathsf{fields}) \\[1em]
& \Sigma;\ \Gamma \vdash_{\mathcal{D}} \bar d : \kappa \implies \vdash \Sigma &&(\mathsf{presup}_\Sigma.\bar d) \\[1em]
& \Sigma \vdash \mathsf{data}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} \bar c_1;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \bar c_k \implies \vdash \Sigma &&(\mathsf{presup}_\Sigma.\mathsf{data}) \\[1em]
& \Sigma \vdash \mathsf{codata}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} \bar d_1;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \bar d_k \implies \vdash \Sigma &&(\mathsf{presup}_\Sigma.\mathsf{codata}) \\[1em]
& {\vdash \Sigma,\ e} \implies \vdash \Sigma &&(\mathsf{presup}_\Sigma.e)
\end{aligned}
```

The names of a well-formed signature are [distinct](08-syntax.md):

```math
\begin{aligned}
& \vdash \Sigma \implies \text{the names of } \Sigma \text{ are distinct} &&(\mathsf{distinct}_\Sigma)
\end{aligned}
```

The typing, the usage and the ownership are independent: for each of them, a term passes the two others and fails it, its variables being declared with their types, grades and ownerships, so that none of the three judgments follows from the two others.
The terms are in the empty signature, and are checked in the mode $`{11}^{\mathsf{m}}`$.

In the context $`\Gamma = x : U_0,\ X : (\Theta \vdash U_0 \mathrel{◀} {\omega\omega}^{\mathsf{p}})`$, where $`\Theta = (y : U_0 \mathrel{▶} {11}^{\mathsf{p}};\ {00}^{\mathsf{p}} \mathrel{◀} {\omega\omega}^{\mathsf{p}},\ z : U_0 \mathrel{▶} {11}^{\mathsf{p}};\ {00}^{\mathsf{p}} \mathrel{◀} {\omega\omega}^{\mathsf{p}})`$ has two entries used once, which require nothing of their arguments, with the vector of grades $`\gamma`$ that gives $`{11}^{\mathsf{p}}`$ to $`x`$ and to $`X`$, and the ownerships $`\varphi`$ that give $`x`$ the ownership $`{11}^{\mathsf{p}}`$, $`X[x, x]`$ uses $`x`$ twice, which its grade does not allow:

```math
\begin{aligned}
& \text{and} &&(\mathsf{independent}.{▶}) \\
& \quad \varnothing;\ \Gamma \vdash X[x, x] : U_0 \\
& \quad \varnothing;\ \varphi \vdash X[x, x] \mathrel{◀} {\omega\omega}^{\mathsf{p}};\ {11}^{\mathsf{m}} \\
& \quad \varnothing;\ \gamma \nvdash X[x, x] \mathrel{▶} {11}^{\mathsf{m}}
\end{aligned}
```

In the context $`\Gamma = x : U_0,\ X : (\Theta \vdash U_0 \mathrel{◀} {\omega\omega}^{\mathsf{p}})`$, where $`\Theta = (y : U_0 \mathrel{▶} {11}^{\mathsf{p}};\ {00}^{\mathsf{p}} \mathrel{◀} {11}^{\mathsf{p}})`$ has one entry used once, which requires its argument to be owned alone, with the vector of grades $`\gamma`$ that gives $`{11}^{\mathsf{p}}`$ to $`x`$ and to $`X`$, and the ownerships $`\varphi`$ that give $`x`$ the ownership $`{\omega\omega}^{\mathsf{p}}`$, $`X[x]`$ passes the shared $`x`$ to this entry:

```math
\begin{aligned}
& \text{and} &&(\mathsf{independent}.{◀}) \\
& \quad \varnothing;\ \Gamma \vdash X[x] : U_0 \\
& \quad \varnothing;\ \gamma \vdash X[x] \mathrel{▶} {11}^{\mathsf{m}} \\
& \quad \forall p.\ \varnothing;\ \varphi \nvdash X[x] \mathrel{◀} p;\ {11}^{\mathsf{m}}
\end{aligned}
```

In the empty context, with the vector of grades $`{00}^{\gamma}`$ and the ownerships $`\varphi`$ of the empty scope, which has no variable, $`U_0`$ is not a term of $`U_0`$, since the sorts are not cumulative:

```math
\begin{aligned}
& \text{and} &&(\mathsf{independent}.{:}) \\
& \quad \varnothing;\ {00}^{\gamma} \vdash U_0 \mathrel{▶} {11}^{\mathsf{m}} \\
& \quad \varnothing;\ \varphi \vdash U_0 \mathrel{◀} {\omega\omega}^{\mathsf{p}};\ {11}^{\mathsf{m}} \\
& \quad \varnothing;\ \varepsilon \nvdash U_0 : U_0
\end{aligned}
```
