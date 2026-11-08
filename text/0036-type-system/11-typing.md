# Typing

This annex defines the judgments of typing and of equality, with those of the signatures, of the contexts, of the arguments of the telescopes and of the instances, of the telescopes in a sort, and of the entries of the signatures, and their properties.
It builds on the [sorts](06-sorts.md), the [substitution](08-substitution.md) and the [usage](10-usage.md).

## Definitions

This section gives the judgments, then their rules, by the objects they check: the signatures and their entries, the contexts, the types, the terms, the arguments, and the telescopes in a sort.

### Judgments

The judgments are those of Martin-Löf type theory, as [Nordström, Petersson and Smith](https://intuitionistic.wordpress.com/wp-content/uploads/2010/07/nordstrom-et-al-type-theory.pdf) present them, with judgments for the signatures and their entries, the contexts, the arguments and the telescopes in a sort:

| Judgment | Reading |
| --- | --- |
| $`\vdash \Sigma`$ | $`\Sigma`$ is a well-formed signature |
| $`\Sigma \vdash f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{≔} t`$ | The constant definition is well formed |
| $`\Sigma \vdash f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m`$ | The constant declaration is well formed |
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

The judgments are defined together, except the last one, which builds on the others.
Typing and equality carry no grade: the usage of a term is checked by the judgment of [usage](10-usage.md), which the rule of the constant definitions reads.
Equality is written $`\equiv`$, and $`=`$ in the premises of a rule is the equality of the metalanguage, which for the levels is the one of the [levels](05-levels.md), and for sequences of levels holds on each component.

A context has a variable $`x : A`$, written $`x : A \in \Gamma`$, when one of its entries is this variable, and a second-order variable $`X : (\Theta \vdash A)`$, written $`X : (\Theta \vdash A) \in \Gamma`$, likewise, by its last entry or by the entries before it; $`x \notin \Gamma`$ means that no entry of $`\Gamma`$ is a variable named $`x`$:

```math
\begin{gathered}
\frac{}{x : A \in (\Gamma,\ x : A)}\;(\in_\Gamma.x) \\[1em]
\frac{x : A \in \Gamma}{x : A \in (\Gamma,\ y : B)}\;(\in_\Gamma.x,y) \\[1em]
\frac{x : A \in \Gamma}{x : A \in (\Gamma,\ Y : (\Theta \vdash B))}\;(\in_\Gamma.x,Y) \\[1em]
\frac{}{X : (\Theta \vdash A) \in (\Gamma,\ X : (\Theta \vdash A))}\;(\in_\Gamma.X) \\[1em]
\frac{X : (\Theta \vdash A) \in \Gamma}{X : (\Theta \vdash A) \in (\Gamma,\ y : B)}\;(\in_\Gamma.X,y) \\[1em]
\frac{X : (\Theta_1 \vdash A) \in \Gamma}{X : (\Theta_1 \vdash A) \in (\Gamma,\ Y : (\Theta_2 \vdash B))}\;(\in_\Gamma.X,Y)
\end{gathered}
```

```math
\begin{aligned}
& x \notin \varepsilon &&(\notin_\Gamma) \\
& x \notin (\Gamma,\ y : B) \iff x \ne y \text{ and } x \notin \Gamma \\
& x \notin (\Gamma,\ Y : (\Theta \vdash B)) \iff x \ne Y \text{ and } x \notin \Gamma
\end{aligned}
```

The instance of an entry with the sort variables $`\bar s`$, the level variables $`\bar l`$ and the grade variables $`\bar p`$ at the qualities $`\bar s'`$, the levels $`\bar l'`$ and the grades $`\bar p'`$, as many as the variables of each kind, gives its type, its body, its parameters and its sort at the instance $`\bar s'`$, $`\bar p'`$, in which it [instantiates](08-substitution.md) the level variables $`[\bar l' / \bar l]`$; the rules write it $`A[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p]`$, as if the instance were substituted, and $`A[\bar s' / \bar s,\ \bar p' / \bar p]`$ when it keeps the level variables:

```math
\begin{aligned}
& A[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p] = A[\bar s' / \bar s,\ \bar p' / \bar p][\bar l' / \bar l] &&(\mathsf{inst}_e)
\end{aligned}
```

### Signatures and Entries

A signature is empty, or a signature extended by an entry that is well formed in it, and whose name no entry of the signature introduces:

```math
\begin{gathered}
\frac{}{\vdash \varnothing}\;(\mathsf{sig}_\varnothing) \\[1em]
\frac{\begin{gathered}{}\Sigma \vdash f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{≔} t \\ \text{no entry of } \Sigma \text{ introduces } f\end{gathered}}{\vdash \Sigma,\ f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{≔} t}\;(\mathsf{sig}_{\mathsf{def}}) \\[1em]
\frac{\begin{gathered}{}\Sigma \vdash f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \\ \text{no entry of } \Sigma \text{ introduces } f\end{gathered}}{\vdash \Sigma,\ f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m}\;(\mathsf{sig}_{\mathsf{decl}})
\end{gathered}
```

The type declarations enter a signature by the rules of their kinds, in their annexes.

An entry is checked in the empty context, once with its level variables, and for each instance of its sort and grade variables, which are finitely many, so that its rules hold whatever instantiates them.
At each instance of its sort and grade variables, the type of a constant definition or declaration is a type of some sort, which may depend on the instance, and the body of a constant definition is a term of its type that uses no variable, in the mode of the definition:

```math
\begin{gathered}
\frac{\begin{aligned}& \forall \bar s',\ \bar p' \text{ as many as } \bar s,\ \bar p.\ \exists \kappa. \\ & \quad \text{and} \\ & \qquad \Sigma;\ \varepsilon \vdash A[\bar s' / \bar s,\ \bar p' / \bar p] : \kappa \\ & \qquad \Sigma;\ \varepsilon \vdash t[\bar s' / \bar s,\ \bar p' / \bar p] : A[\bar s' / \bar s,\ \bar p' / \bar p] \\ & \qquad \Sigma;\ {00}^{\gamma} \vdash t[\bar s' / \bar s,\ \bar p' / \bar p] \mathrel{▶} m\end{aligned}}{\Sigma \vdash f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{≔} t}\;(\mathsf{def}) \\[1em]
\frac{\forall \bar s',\ \bar p' \text{ as many as } \bar s,\ \bar p.\ \exists \kappa.\ \Sigma;\ \varepsilon \vdash A[\bar s' / \bar s,\ \bar p' / \bar p] : \kappa}{\Sigma \vdash f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m}\;(\mathsf{decl})
\end{gathered}
```

### Contexts

A context is empty, in a well-formed signature, or a context extended by a variable whose type is a type in it, or by a second-order variable whose type is a type in it extended by its telescope, with a name that the context does not have:

```math
\begin{gathered}
\frac{\vdash \Sigma}{\Sigma \vdash \varepsilon}\;(\mathsf{ctx}_\varepsilon) \\[1em]
\frac{\begin{gathered}{}\Sigma;\ \Gamma \vdash A \\ x \notin \Gamma\end{gathered}}{\Sigma \vdash \Gamma,\ x : A}\;(\mathsf{ctx}_x) \\[1em]
\frac{\begin{gathered}{}\Sigma;\ \Gamma,\ \Theta \vdash A \\ X \notin \Gamma\end{gathered}}{\Sigma \vdash \Gamma,\ X : (\Theta \vdash A)}\;(\mathsf{ctx}_X)
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
\frac{\begin{gathered}{}X : (\Theta \vdash A) \in \Gamma \\ \Sigma;\ \Gamma \vdash \bar t : \Theta\end{gathered}}{\Sigma;\ \Gamma \vdash X[\bar t] : A[\bar t / \Theta]}\;(\mathsf{var}_X)
\end{gathered}
```

An instance of a constant, defined or declared, has the type of its entry at this instance; a sort $`U_l`$ or $`\Omega_l`$ is in the universe above its level; an instance of a declared type, whose arguments are arguments of its parameters, is in the sort of its type declaration:

```math
\begin{gathered}
\frac{\begin{gathered}{}\Sigma \vdash \Gamma \\ f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \in \Sigma \\ \bar s',\ \bar l',\ \bar p' \text{ as many as } \bar s,\ \bar l,\ \bar p\end{gathered}}{\Sigma;\ \Gamma \vdash f.\{\bar s';\ \bar l';\ \bar p'\} : A[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p]}\;(f) \\[1em]
\frac{\Sigma \vdash \Gamma}{\Sigma;\ \Gamma \vdash U_l : U_{l + 1}}\;(U) \\[1em]
\frac{\Sigma \vdash \Gamma}{\Sigma;\ \Gamma \vdash \Omega_l : U_{l + 1}}\;(\Omega) \\[1em]
\frac{\begin{gathered}{}D.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa \in \Sigma \\ \bar s',\ \bar l',\ \bar p' \text{ as many as } \bar s,\ \bar l,\ \bar p \\ \Sigma;\ \Gamma \vdash \bar a : \Delta[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p]\end{gathered}}{\Sigma;\ \Gamma \vdash D.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a : \kappa[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p]}\;(D)
\end{gathered}
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

Equal arguments give equal applications of a second-order variable, a constant definition unfolds to its body, and two instances of a constant, two sorts, or two instances of a declared type with equal arguments, at equal levels, are equal:

```math
\begin{gathered}
\frac{\begin{gathered}{}X : (\Theta \vdash A) \in \Gamma \\ \Sigma;\ \Gamma \vdash \bar t \equiv \bar u : \Theta\end{gathered}}{\Sigma;\ \Gamma \vdash X[\bar t] \equiv X[\bar u] : A[\bar t / \Theta]}\;(\mathsf{var}_{X\equiv}) \\[1em]
\frac{\begin{gathered}{}\Sigma \vdash \Gamma \\ f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{≔} t \in \Sigma \\ \bar s',\ \bar l',\ \bar p' \text{ as many as } \bar s,\ \bar l,\ \bar p\end{gathered}}{\Sigma;\ \Gamma \vdash f.\{\bar s';\ \bar l';\ \bar p'\} \equiv t[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p] : A[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p]}\;(\delta) \\[1em]
\frac{\begin{gathered}{}\Sigma \vdash \Gamma \\ f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \in \Sigma \\ \bar s',\ \bar l_1,\ \bar p' \text{ as many as } \bar s,\ \bar l,\ \bar p \\ \bar l_2 \text{ as many as } \bar l \\ \bar l_1 = \bar l_2\end{gathered}}{\Sigma;\ \Gamma \vdash f.\{\bar s';\ \bar l_1;\ \bar p'\} \equiv f.\{\bar s';\ \bar l_2;\ \bar p'\} : A[\bar s' / \bar s,\ \bar l_1 / \bar l,\ \bar p' / \bar p]}\;(f_\equiv) \\[1em]
\frac{\begin{gathered}{}\Sigma \vdash \Gamma \\ l_1 = l_2\end{gathered}}{\Sigma;\ \Gamma \vdash U_{l_1} \equiv U_{l_2} : U_{l_1 + 1}}\;(U_\equiv) \\[1em]
\frac{\begin{gathered}{}\Sigma \vdash \Gamma \\ l_1 = l_2\end{gathered}}{\Sigma;\ \Gamma \vdash \Omega_{l_1} \equiv \Omega_{l_2} : U_{l_1 + 1}}\;(\Omega_\equiv) \\[1em]
\frac{\begin{gathered}{}D.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa \in \Sigma \\ \bar s',\ \bar l_1,\ \bar p' \text{ as many as } \bar s,\ \bar l,\ \bar p \\ \bar l_2 \text{ as many as } \bar l \\ \Sigma;\ \Gamma \vdash \bar a_1 \equiv \bar a_2 : \Delta[\bar s' / \bar s,\ \bar l_1 / \bar l,\ \bar p' / \bar p] \\ \bar l_1 = \bar l_2\end{gathered}}{\Sigma;\ \Gamma \vdash D.\{\bar s';\ \bar l_1;\ \bar p'\}\ \bar a_1 \equiv D.\{\bar s';\ \bar l_2;\ \bar p'\}\ \bar a_2 : \kappa[\bar s' / \bar s,\ \bar l_1 / \bar l,\ \bar p' / \bar p]}\;(D_\equiv)
\end{gathered}
```

No rule equates two instances with different qualities or grades: two types that differ only by a grade are different types.

### Arguments

The arguments of a telescope are typed by its entries, each argument instantiating the types after it, whose grades typing ignores:

```math
\begin{gathered}
\frac{\Sigma \vdash \Gamma}{\Sigma;\ \Gamma \vdash () : \varepsilon}\;(\mathsf{tel}_\varepsilon) \\[1em]
\frac{\begin{gathered}{}\Sigma;\ \Gamma \vdash t : A \\ \Sigma;\ \Gamma \vdash \bar t : \Theta[t / x]\end{gathered}}{\Sigma;\ \Gamma \vdash (t,\ \bar t) : (x : A \mathrel{▶} p;\ q,\ \Theta)}\;(\mathsf{tel}_{,}) \\[1em]
\frac{\Sigma \vdash \Gamma}{\Sigma;\ \Gamma \vdash () \equiv () : \varepsilon}\;(\mathsf{tel}_{\varepsilon\equiv}) \\[1em]
\frac{\begin{gathered}{}\Sigma;\ \Gamma \vdash t \equiv u : A \\ \Sigma;\ \Gamma \vdash \bar t \equiv \bar u : \Theta[t / x]\end{gathered}}{\Sigma;\ \Gamma \vdash (t,\ \bar t) \equiv (u,\ \bar u) : (x : A \mathrel{▶} p;\ q,\ \Theta)}\;(\mathsf{tel}_{,\equiv})
\end{gathered}
```

The arguments of an instance are typed by the parameters of its type declaration, each argument instantiating the types after it, as a substitution of the second order of the parameters; the abstraction for a second-order variable is a term of its type under the variables $`\bar x`$ of its telescope:

```math
\begin{gathered}
\frac{\Sigma \vdash \Gamma}{\Sigma;\ \Gamma \vdash () : \varepsilon}\;(\mathsf{arg}_\varepsilon) \\[1em]
\frac{\begin{gathered}{}\Sigma;\ \Gamma \vdash \bar a : \Delta \\ \Sigma;\ \Gamma \vdash a : A[\bar a / \Delta]\end{gathered}}{\Sigma;\ \Gamma \vdash (\bar a,\ a) : (\Delta,\ x : A)}\;(\mathsf{arg}_x) \\[1em]
\frac{\begin{gathered}{}\Sigma;\ \Gamma \vdash \bar a : \Delta \\ \Sigma;\ \Gamma,\ \Theta[\bar a / \Delta] \vdash B : A[\bar a / \Delta]\end{gathered}}{\Sigma;\ \Gamma \vdash (\bar a,\ \bar x.\, B) : (\Delta,\ X : (\Theta \vdash A))}\;(\mathsf{arg}_X) \\[1em]
\frac{\Sigma \vdash \Gamma}{\Sigma;\ \Gamma \vdash () \equiv () : \varepsilon}\;(\mathsf{arg}_{\varepsilon\equiv}) \\[1em]
\frac{\begin{gathered}{}\Sigma;\ \Gamma \vdash \bar a_1 \equiv \bar a_2 : \Delta \\ \Sigma;\ \Gamma \vdash a_1 \equiv a_2 : A[\bar a_1 / \Delta]\end{gathered}}{\Sigma;\ \Gamma \vdash (\bar a_1,\ a_1) \equiv (\bar a_2,\ a_2) : (\Delta,\ x : A)}\;(\mathsf{arg}_{x\equiv}) \\[1em]
\frac{\begin{gathered}{}\Sigma;\ \Gamma \vdash \bar a_1 \equiv \bar a_2 : \Delta \\ \Sigma;\ \Gamma,\ \Theta[\bar a_1 / \Delta] \vdash B_1 \equiv B_2 : A[\bar a_1 / \Delta]\end{gathered}}{\Sigma;\ \Gamma \vdash (\bar a_1,\ \bar x.\, B_1) \equiv (\bar a_2,\ \bar x.\, B_2) : (\Delta,\ X : (\Theta \vdash A))}\;(\mathsf{arg}_{X\equiv})
\end{gathered}
```

### Telescopes in a Sort

A telescope lives in a sort $`\kappa`$ when each of its types lives in a sort that $`\kappa`$ [bounds](06-sorts.md), and an entry whose type is a proposition has a grade without use at run time:

```math
\begin{gathered}
\frac{\Sigma \vdash \Gamma}{\Sigma;\ \Gamma \vdash \varepsilon : \kappa}\;(\mathsf{tel}_{\kappa\varepsilon}) \\[1em]
\frac{\begin{gathered}{}\Sigma;\ \Gamma \vdash A : \kappa_1 \\ \kappa_1 \preceq \kappa_2 \\ \Sigma;\ \Gamma,\ x : A \vdash \Theta : \kappa_2 \\ \llcorner p \lrcorner \ne {11}^{\mathsf{m}} \text{ if the quality of } \kappa_1 \text{ is } \Omega\end{gathered}}{\Sigma;\ \Gamma \vdash (x : A \mathrel{▶} p;\ q,\ \Theta) : \kappa_2}\;(\mathsf{tel}_{\kappa,})
\end{gathered}
```

## Properties

Every judgment holds in a well-formed signature, and the signature that a well-formed signature extends is well formed:

```math
\begin{aligned}
& \Sigma \vdash f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{≔} t \implies \vdash \Sigma &&(\mathsf{presup}_\Sigma.\mathsf{def}) \\[1em]
& \Sigma \vdash f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \implies \vdash \Sigma &&(\mathsf{presup}_\Sigma.\mathsf{decl}) \\[1em]
& \Sigma \vdash \Gamma \implies \vdash \Sigma &&(\mathsf{presup}_\Sigma.\Gamma) \\[1em]
& \Sigma;\ \Gamma \vdash A \implies \vdash \Sigma &&(\mathsf{presup}_\Sigma.A) \\[1em]
& \Sigma;\ \Gamma \vdash A \equiv B \implies \vdash \Sigma &&(\mathsf{presup}_\Sigma.A_\equiv) \\[1em]
& \Sigma;\ \Gamma \vdash t : A \implies \vdash \Sigma &&(\mathsf{presup}_\Sigma.t) \\[1em]
& \Sigma;\ \Gamma \vdash t \equiv u : A \implies \vdash \Sigma &&(\mathsf{presup}_\Sigma.t_\equiv) \\[1em]
& \Sigma;\ \Gamma \vdash \bar t : \Theta \implies \vdash \Sigma &&(\mathsf{presup}_\Sigma.\bar t) \\[1em]
& \Sigma;\ \Gamma \vdash \bar t \equiv \bar u : \Theta \implies \vdash \Sigma &&(\mathsf{presup}_\Sigma.\bar t_\equiv) \\[1em]
& \Sigma;\ \Gamma \vdash \bar a : \Delta \implies \vdash \Sigma &&(\mathsf{presup}_\Sigma.\bar a) \\[1em]
& \Sigma;\ \Gamma \vdash \bar a_1 \equiv \bar a_2 : \Delta \implies \vdash \Sigma &&(\mathsf{presup}_\Sigma.\bar a_\equiv) \\[1em]
& {\vdash \Sigma,\ e} \implies \vdash \Sigma &&(\mathsf{presup}_\Sigma.e)
\end{aligned}
```

The names of a well-formed signature are [distinct](07-syntax.md):

```math
\begin{aligned}
& \vdash \Sigma \implies \text{the names of } \Sigma \text{ are distinct} &&(\mathsf{distinct}_\Sigma)
\end{aligned}
```
