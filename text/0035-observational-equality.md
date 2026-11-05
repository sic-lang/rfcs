# RFC 0035: Observational Equality

- Pull request: [sic-lang/rfcs#35](https://github.com/sic-lang/rfcs/pull/35)

## Summary

This RFC defines the equality of Sic as a strict proposition that computes on the types and on the terms of the [graded dependent core](https://github.com/sic-lang/rfcs/pull/24): two terms are equal when they cannot be told apart by any observation, as the observational equality of [Pujet and Tabareau](https://doi.org/10.1145/3498693) and [Pujet, Leray and Tabareau](https://doi.org/10.1145/3719342) defines it.
It gives the three primitives, reflexivity, transport and cast, and the equality of the terms of every kind of declaration of the [data and codata types](https://github.com/sic-lang/rfcs/pull/34), constructor by constructor for the data types and observation by observation for the codata types, where the equality of two recursive codata terms is their bisimilarity; it adds the quotients as a third kind of declaration, and leaves the indexed families out, since an annex elaborates them into data types with non-uniform parameters and equalities.
The proofs of equality are erased, and a cast costs nothing at run time.

## Motivation

A dependently typed language needs an equality that its programs prove and use: to state that a function is correct, to transport a value along an equality of types, and to reason about functions and streams by their observations.
The identity type of Martin-Löf type theory lacks the extensionality of functions and of propositions, which its users assume as axioms that block computation; the observational equality computes instead, and gives both extensionalities as its rules, at the price of a cast that must be shown to cost nothing.
This RFC gives this equality to the core, generic in the declarations, so that every type declared by a kind of declaration gets its equality and its cast from its constructors or its destructors, and the quotients, the one construct that the data and codata types do not give, as a kind of declaration of its own.

## Proposal

The proposal first fixes the notation, then defines the equality, with its primitives, the equality of types, the equality of the terms of the data and codata types, the cast of their terms, the quotients, the conversion and the erasure of its terms.
It then gives the meaning of the equality, as the setoid model, and the properties expected of it.

### Notation

This RFC uses the notation and the conventions of the [core](https://github.com/sic-lang/rfcs/pull/24) and of the [data and codata types](https://github.com/sic-lang/rfcs/pull/34), with the letters below for its own objects:

| Letters | Denote |
| --- | --- |
| $`e`$ | Proofs of equalities |
| $`R`$ | The relation of a quotient, a proposition on two terms of its carrier |

The equality is written $`t \sim_A u`$, a proposition of the sort $`\Omega_l`$ of the level of $`A`$; its rules are named after the symbol $`\sim`$, with the polarity of the kind they concern as an exponent, and the rules of the cast after $`\mathsf{cast}`$.
The connectives of the propositions are the instances in $`\Omega`$ of the declarations of the [data and codata types](https://github.com/sic-lang/rfcs/pull/34), which the signature holds before the first equality: the true and the false propositions $`\top`$ and $`\bot`$, the conjunction $`P \wedge Q`$, which is the pair whose second field may depend on the first, the implication $`P \Rightarrow Q`$ and the quantification $`\forall (x : A).\, P`$, which are the functions into a proposition.
The equality of two telescopes of terms, field by field, is written $`\bar t \sim_\Theta \bar u`$, and the cast of a telescope of terms along a proof, field by field, $`\mathsf{cast}_\Theta(e,\ \bar t)`$; both are defined below, by recursion on the telescope.
As in the core, a variable left free in a formula is universally quantified over the kind that its letter names, and a rule holds for every instance of its schematic variables; the rules of the equality and of the cast that are written as equations, since their premises are those of the formation of the equality, are rules as well.

### Equality

The equality is a strict proposition on two terms of a type, with no rule of introduction but reflexivity, no rule of elimination but transport and cast, and rules of computation that reduce it on the canonical forms of its type and of its terms.

#### Formation of Equalities

Two terms of a type have an equality, a proposition at the level of the type; the equality of two proofs is true, by irrelevance, so that the rules below concern the types of the universes:

```math
\frac{\Sigma;\ \Gamma \vdash A : \kappa \quad \kappa \in \{U_l, \Omega_l\} \quad \Sigma;\ \Gamma \vdash t : A \quad \Sigma;\ \Gamma \vdash u : A}{\Sigma;\ \Gamma \vdash t \sim_A u : \Omega_l}\;(\sim)
\qquad
\frac{\Sigma;\ \Gamma \vdash A : \Omega_l \quad \Sigma;\ \Gamma \vdash t : A \quad \Sigma;\ \Gamma \vdash u : A}{\Sigma;\ \Gamma \vdash t \sim_A u \equiv \top : \Omega_l}\;(\sim_{\mathsf{irr}})
```

An equality is a type that mentions its terms in erased positions only, as every type the core writes: it uses no variable, and its parts are checked in the mode $`\mathbb{0}\mathbb{0}^{\mathsf{m}}`$:

```math
\frac{\Sigma;\ \gamma_1 \mathrel{▶_{\mathbb{0}\mathbb{0}^{\mathsf{m}}}} A \quad \Sigma;\ \gamma_2 \mathrel{▶_{\mathbb{0}\mathbb{0}^{\mathsf{m}}}} t \quad \Sigma;\ \gamma_3 \mathrel{▶_{\mathbb{0}\mathbb{0}^{\mathsf{m}}}} u}{\Sigma;\ \mathbb{0}^{\mathsf{c}} \mathrel{▶_m} t \sim_A u}\;(\sim_{\mathsf{m}})
```

Equality is also a congruence for the equalities, their proofs and their casts, with the premises of their rules.

#### Reflexivity

Every term is equal to itself, by a proof that carries its type and its term, so that the proof determines its type; a proof uses no variable at run time, and reflexivity uses none at all:

```math
\frac{\Sigma;\ \Gamma \vdash t : A \quad \Sigma;\ \Gamma \vdash A : U_l}{\Sigma;\ \Gamma \vdash \mathsf{refl}_A(t) : t \sim_A t}\;(\mathsf{refl})
\qquad
\frac{\Sigma;\ \gamma_1 \mathrel{▶_{\mathbb{0}\mathbb{0}^{\mathsf{m}}}} A \quad \Sigma;\ \gamma_2 \mathrel{▶_{\mathbb{0}\mathbb{0}^{\mathsf{m}}}} t}{\Sigma;\ \mathbb{0}^{\mathsf{c}} \mathrel{▶_m} \mathsf{refl}_A(t)}\;(\mathsf{refl}_{\mathsf{m}})
```

An equality is eliminated by transport into a proposition and by cast into a type, and nothing else: symmetry and transitivity are admissible, as the [properties](#properties) state, and the congruence of a term is an abbreviation of the transport, defined with it.

#### Transport

A proof of a proposition that holds of a term is transported along an equality to the same proposition of the equal term, as the eliminator $`J`$ of the identity type restricted to the propositions; the proposition may depend on the term through an abstraction, and the transport is a proof, which carries what it needs:

```math
\frac{\begin{gathered}{}\Sigma;\ \Gamma \vdash A : U_l \quad \Sigma;\ \Gamma,\ x : A \vdash P : \Omega_{l'} \quad \Sigma;\ \Gamma \vdash e : t \sim_A u \quad \Sigma;\ \Gamma \vdash v : P[t/x]\end{gathered}}{\Sigma;\ \Gamma \vdash \mathsf{transp}(x.\, P,\ e,\ v) : P[u/x]}\;(\mathsf{transp})
```

A transport uses its two proofs once each, in the mode of the transport, which is an erased mode, since a transport is a proof; its proposition and its terms use no variable:

```math
\frac{\Sigma;\ \gamma_1 \mathrel{▶_{\mathbb{0}\mathbb{0}^{\mathsf{m}}}} P \quad \Sigma;\ \gamma_2 \mathrel{▶_m} e \quad \Sigma;\ \gamma_3 \mathrel{▶_m} v}{\Sigma;\ \gamma_2 +^{\mathsf{c}} \gamma_3 \mathrel{▶_m} \mathsf{transp}(x.\, P,\ e,\ v)}\;(\mathsf{transp}_{\mathsf{m}})
```

A transport has no rule of computation: it is a proof, equal to every proof of its proposition by irrelevance, and never computes, as the [strict propositions](https://github.com/sic-lang/rfcs/pull/24) require.
The eliminator $`J`$ into a type is admissible too, as the [properties](#properties) state, and computes on reflexivity by the rule $`(\mathsf{cast}_{\mathsf{refl}})`$ below.

The congruence of a term $`f`$, of a type $`B`$ that does not depend on the variable $`x`$, is the transport, along the equality of two terms substituted for $`x`$, of the reflexivity of the term at the first: the abbreviation $`\mathsf{ap}(x.\, f,\ e)`$ is a proof, along which the rules of the equality of the types and of the terms cast, and the congruence of a type is $`\mathsf{ap}`$ at its sort:

```math
\begin{aligned}
\mathsf{ap}(x.\, f,\ e) &= \mathsf{transp}(y.\, f[t/x] \sim_B f[y/x],\ e,\ \mathsf{refl}_B(f[t/x])) : f[t/x] \sim_B f[u/x] \quad \text{if } e : t \sim_A u,\ f : B \text{ and } x \text{ is not free in } B &&(\mathsf{ap}_\sim)
\end{aligned}
```

When the type of $`f`$ depends on $`x`$, the right side is first cast to the type of the left side along the congruence of the types.
The congruence of a telescope of types $`\Theta`$, $`\mathsf{ap}(x.\, \Theta,\ e) : \Theta[t/x] \sim \Theta[u/x]`$, is the same transport of a proof of $`\Theta[t/x] \sim \Theta[t/x]`$, which the [equality of the telescopes](#equality-of-types) reduces to a conjunction of reflexivities once $`(\mathsf{cast}_{\mathsf{refl}})`$ removes the casts between equal types; by irrelevance, which proof is taken does not matter.

#### Cast

A term of a type is cast along an equality of types to the equal type; the cast carries both types and the proof, and the proof is erased, so that a cast is a term that computes as its term does, which the rules of computation below define type by type:

```math
\frac{\Sigma;\ \Gamma \vdash A : U_l \quad \Sigma;\ \Gamma \vdash B : U_l \quad \Sigma;\ \Gamma \vdash e : A \sim_{U_l} B \quad \Sigma;\ \Gamma \vdash t : A}{\Sigma;\ \Gamma \vdash \mathsf{cast}(A,\ B,\ e,\ t) : B}\;(\mathsf{cast})
\qquad
\frac{\Sigma;\ \gamma_1 \mathrel{▶_{\mathbb{0}\mathbb{0}^{\mathsf{m}}}} A \quad \Sigma;\ \gamma_2 \mathrel{▶_{\mathbb{0}\mathbb{0}^{\mathsf{m}}}} B \quad \Sigma;\ \gamma_3 \mathrel{▶_{\mathbb{0}\mathbb{0}^{\mathsf{m}}}} e \quad \Sigma;\ \gamma \mathrel{▶_m} t}{\Sigma;\ \gamma \mathrel{▶_m} \mathsf{cast}(A,\ B,\ e,\ t)}\;(\mathsf{cast}_{\mathsf{m}})
```

A cast uses its term as the term is used, and its types and its proof with $`\mathbb{0}`$: the proof is a proof, and the cast of a term costs the resources of the term alone.
A cast between equal types is the term itself, whatever the proof, which is the rule of conversion of [Pujet, Leray and Tabareau](https://doi.org/10.1145/3719342): it is a rule of equality on the head normal forms and the neutral terms, not a rule of reduction, since deciding it needs a comparison of the two types, which a reduction cannot make:

```math
\frac{\Sigma;\ \Gamma \vdash \mathsf{cast}(A,\ B,\ e,\ t) : B \quad \Sigma;\ \Gamma \vdash A \equiv B}{\Sigma;\ \Gamma \vdash \mathsf{cast}(A,\ B,\ e,\ t) \equiv t : B}\;(\mathsf{cast}_{\mathsf{refl}})
```

The rule makes the eliminator $`J`$ compute on reflexivity, and the recursor of an indexed family, which the annex on [indexed families](0035-observational-equality/indexed-families.md) derives, compute on open terms, as [Pujet, Leray and Tabareau](https://doi.org/10.1145/3719342) show it needs.

### Equality of Types

The equality of two types of a universe computes on their canonical forms: two universes or two universes of propositions at the same level are equal, two propositions are equal when each implies the other, and two instances of the same declared type are equal when their bodies are, at the same sorts and grades and equal levels, as the rule $`(D_\equiv)`$ of the [core](https://github.com/sic-lang/rfcs/pull/24) compares them; every other pair of canonical types is unequal.

```math
\begin{aligned}
U_k \sim_{U_n} U_k &\equiv \top &&(\sim_U) \\
\Omega_k \sim_{U_n} \Omega_k &\equiv \top &&(\sim_\Omega) \\
P \sim_{\Omega_l} Q &\equiv (P \Rightarrow Q) \wedge (Q \Rightarrow P) &&(\sim_{\mathsf{prop}}) \\
A \sim_{s_n} B &\equiv \bot \quad \text{if } A \text{ and } B \text{ are canonical, and not related by another rule} &&(\sim_{\ne})
\end{aligned}
```

The rules are rules of equality whose premises are those of the formation of the equality, written as equations, and $`(\sim_{\mathsf{prop}})`$ is the extensionality of propositions, which the strict propositions make consistent, since two equivalent propositions have the same proofs.
Two instances of a declared type are compared by their kind, which the [contract](#the-contract-extended) below asks of every kind: the instances $`T_1`$ and $`T_2`$ of a type $`D_j`$ with the same sorts $`\bar s`$ and grades $`\bar p`$, and levels equal by the equality of the [levels](https://github.com/sic-lang/rfcs/pull/24), are equal when the bodies of $`D_j`$ instantiated by them are, which the data and codata types state as the equality of the telescopes of their fields, or of the contexts of their destructors; two instances with different sorts or grades, or unequal levels, are unequal, as two different declared types:

```math
\begin{aligned}
T_1 \sim_{s_n} T_2 &\equiv \textstyle\bigwedge_{i} \Theta_{ji}[T_1] \sim \Theta_{ji}[T_2] &&(\sim^{+}_D) \\
T_1 \sim_{s_n} T_2 &\equiv \Xi_j[T_1] \sim \Xi_j[T_2] &&(\sim^{-}_D) \\
T_1 \sim_{s_n} T_2 &\equiv \bot \quad \text{if } T_1 \text{ and } T_2 \text{ are instances of different types, or of one type with} &&(\sim_{D\ne}) \\
& \quad \text{different sorts or grades, or unequal levels}
\end{aligned}
```

The equality of two telescopes of types is the conjunction of the equalities of their first types and, for every term of the first, of the equalities of the rest, the term cast to the second type, so that the rest of the telescopes are compared at equal terms; the equality of two contexts of destructors compares the arguments as telescopes, and the results for every pair of equal arguments, as the [meaning](https://github.com/sic-lang/rfcs/pull/34) of the codata types compares them:

```math
\begin{aligned}
\varepsilon \sim \varepsilon &= \top &&(\sim_{\mathsf{tel}\varepsilon}) \\
(x : A_1,\ \Theta_1) \sim (x : A_2,\ \Theta_2) &= (e : A_1 \sim_{\kappa} A_2) \wedge \forall (x : A_1).\, \Theta_1 \sim \Theta_2[\mathsf{cast}(A_1,\ A_2,\ e,\ x)/x] \quad \text{if } A_1 : \kappa &&(\sim_{\mathsf{tel},}) \\
\varepsilon \sim \varepsilon &= \top &&(\sim_{\mathsf{dtor}\varepsilon}) \\
(d : (\Theta_1 \vdash B_1),\ \Xi_1) \sim (d : (\Theta_2 \vdash B_2),\ \Xi_2) &= (e : \Theta_2 \sim \Theta_1) \wedge (e' : \forall (\bar x : \Theta_2).\, B_1[\mathsf{cast}_{\Theta_2}(e,\ \bar x)/\Theta_1] \sim_{\kappa} B_2) &&(\sim_{\mathsf{dtor},}) \\
& \quad \wedge \forall (\bar x.\, u : (\Theta_1 \vdash B_1)).\, \Xi_1[\bar x.\, u/d] \sim \Xi_2[\bar x.\, \mathsf{cast}(B_1[\bar x'/\Theta_1],\ B_2,\ e'[\bar x],\ u[\bar x'/\bar x])/d] \\
& \quad \text{where } \bar x' = \mathsf{cast}_{\Theta_2}(e,\ \bar x), \text{ if } B_1 \text{ and } B_2 \text{ live in } \kappa
\end{aligned}
```

In $`(\sim_{\mathsf{tel},})`$ and $`(\sim_{\mathsf{dtor},})`$, the conjunction binds its proof $`e`$ for the second conjunct, as the pair of the propositions allows.
In $`(\sim_{\mathsf{dtor},})`$, the equality of the arguments goes from the second telescope to the first, so that the arguments of the second destructor are cast to the first along $`e`$, and the results and the abstractions of the first along $`e'`$, with no symmetry, which has no proof term; the quantification over the abstractions of $`d`$ stands for the quantification over the functions that the [data and codata types](https://github.com/sic-lang/rfcs/pull/34) declare.
The equality of two instances of a recursive declared type is then a proposition that mentions the equality of the instances at its positions, which the rules unfold as far as the terms are compared; for a proposition that no rule unfolds further, the comparison ends on the terms, as the equality of two streams does below.

### Equality of Terms

The equality of two terms of a declared type computes on their canonical forms, which the kind of the declaration gives: constructor by constructor for the data types, and observation by observation for the codata types.

#### Equality of Data

Two terms of a data type built by the same constructor are equal when their fields are, field by field, each later field of the first term cast to the type of the field of the second, and two terms built by different constructors are unequal:

```math
\begin{aligned}
T_1.c_{ji}(\bar t) \sim_{T} T_2.c_{ji}(\bar u) &\equiv \bar t \sim_{\Theta_{ji}[T]} \bar u &&(\sim^{+}) \\
T_1.c_{ji}(\bar t) \sim_{T} T_2.c_{ji'}(\bar u) &\equiv \bot \quad \text{if } i \ne i' &&(\sim^{+}_{\ne}) \\
() \sim_{\varepsilon} () &= \top &&(\sim_{\mathsf{fields}\varepsilon}) \\
(t,\ \bar t) \sim_{(x : A,\ \Theta)} (u,\ \bar u) &= (e : t \sim_A u) \wedge \mathsf{cast}_{\Theta[t/x]}(\mathsf{ap}(x.\, \Theta,\ e),\ \bar t) \sim_{\Theta[u/x]} \bar u &&(\sim_{\mathsf{fields},})
\end{aligned}
```

In $`(\sim_{\mathsf{fields},})`$, the fields of the first term after $`t`$ are cast forward to the telescope at $`u`$, along the congruence of the telescope, so that the rest of the two terms are compared at one telescope; the equality of two terms of a recursive data type thus unfolds layer by layer, as far as their constructors go, and ends on the equalities of their non-recursive fields.

#### Equality of Codata

Two terms of a codata type are equal when every observation of the one is equal to the same observation of the other, on the same arguments, which is the bisimilarity of the two terms: a codata type in $`\Omega`$, declared right after the type, whose destructors are the equalities of the observations, and whose parameters are those of the type and the two terms.
For a recursive codata type, the bisimilarity is itself recursive, at the positions of the type in the results of its destructors: it is a coinductive proposition, whose proofs the [corecursor](https://github.com/sic-lang/rfcs/pull/34) builds in $`\Omega`$, as the bisimulations of [McBride](https://personal.cis.strath.ac.uk/conor.mcbride/pub/JUnfold/junfold.pdf) prove two coprograms equal by unfolding them:

```math
\begin{aligned}
& \mathsf{codata}.\{\bar s;\ \bar l;\ \bar p\}\ (\Delta,\ t : T_j,\ u : T_j) : \Omega_l\ \mathsf{where}\ D_j^{\sim} \mathrel{≔} d_{j1}^{\sim} :^{\mathbb{0}}_{\mathbb{0}} \Theta_{j1}[t.\bar d] \to (t'_{j1} \sim_{B_{j1}[u.\bar d][\bar x'_{j1}]} u.d_{j1}(\bar x'_{j1})) \mid \dots &&(\sim^{-}_{\mathsf{decl}}) \\
& \quad \text{where } t'_{ji} = \mathsf{cast}(B_{ji}[t.\bar d][\bar x_{ji}],\ B_{ji}[u.\bar d][\bar x'_{ji}],\ e_{ji},\ t.d_{ji}(\bar x_{ji})), \\
& \quad \text{and the equality at a position of } D_j \text{ in } B_{ji} \text{ is } D_j^{\sim} \text{ at the two observations} \\
t \sim_{T_j} u &\equiv D_j^{\sim}.\{\bar s;\ \bar l;\ \bar p\}\ (\bar a,\ t,\ u) &&(\sim^{-})
\end{aligned}
```

In the declaration, $`\bar x'_{ji}`$ are the arguments cast to the telescope of $`u`$ and $`e_{ji}`$ the proof of the equality of the result types, both built by the congruence $`\mathsf{ap}`$ from the equalities of the earlier observations, which the destructors $`d_{j1}^{\sim}, \dots, d_{j(i - 1)}^{\sim}`$ provide as second-order variables, so that the observation of $`t`$ is cast forward to the type of the observation of $`u`$; at a position of $`D_j`$ in a result type, the equality is the bisimilarity itself, so that the declaration is recursive exactly when $`D_j`$ is, and the equality at a nested position goes through the lifting of the nesting type, as the recursive results of the [recursor](https://github.com/sic-lang/rfcs/pull/34) do.
For a codata type that is not recursive, the bisimilarity is a conjunction of equalities, one per destructor, quantified over the arguments: for the type of functions, it is the extensionality of functions, and the rule $`(D^{-}_\eta)`$ of the core makes it decide the equality; for a recursive codata type, it gives back as a proposition the extensionality that the conversion withholds.
The grade of the destructors of the bisimilarity is $`\mathbb{0}`$ on both axes: a bisimilarity is a proof, and its observations are proofs.

#### Equality and Cast of the Telescopes

The cast of a telescope of terms along a proof of the equality of two telescopes of types casts each term along the equality of its type, instantiated by the terms before it and their casts, which the proof provides conjunct by conjunct:

```math
\begin{aligned}
\mathsf{cast}_{\varepsilon}(e,\ ()) &= () &&(\mathsf{cast}_{\mathsf{tel}\varepsilon}) \\
\mathsf{cast}_{(x : A_1,\ \Theta_1)}(e,\ (t,\ \bar t)) &= (t',\ \mathsf{cast}_{\Theta_1[t/x]}(e_2[t],\ \bar t)) \quad \text{where } t' = \mathsf{cast}(A_1,\ A_2,\ e_1,\ t), \text{ if } e : (x : A_1,\ \Theta_1) \sim (x : A_2,\ \Theta_2) &&(\mathsf{cast}_{\mathsf{tel},})
\end{aligned}
```

Here $`e_1`$ and $`e_2`$ are the two conjuncts of $`e`$, taken by the recursor of the conjunction, and $`e_2[t]`$ the second one applied to $`t`$, which proves $`\Theta_1[t/x] \sim \Theta_2[t'/x]`$.

### Cast of Terms

The cast of a term of a declared type to an equal instance computes on its canonical form, which the kind of the declaration gives: a constructor is cast field by field, and a codata term is cast lazily, observation by observation.

#### Cast of Data

A term built by a constructor is cast to the same constructor of the equal instance, its fields cast along the equality of the telescopes of the fields, which the proof of the equality of the instances provides for each constructor:

```math
\begin{aligned}
\mathsf{cast}(T_1,\ T_2,\ e,\ T_1.c_{ji}(\bar t)) &\equiv T_2.c_{ji}(\mathsf{cast}_{\Theta_{ji}[T_1]}(e_i,\ \bar t)) \quad \text{where } e_i \text{ is the conjunct of } e \text{ for } c_{ji} &&(\mathsf{cast}^{+})
\end{aligned}
```

The cast of a term of a recursive data type thus casts its fields layer by layer, as far as its constructors go, and the cast at a nested position goes through the map of the nesting type.

#### Cast of Codata

A term of a codata type is cast to the equal instance by a corecursor whose state holds the term, with the non-uniform arguments of its instance and the proof that its instance is equal to the one to build, and whose branch for each destructor casts the arguments back to the telescope of the term, observes the term, and casts the result forward, along the equalities that the proof provides destructor by destructor; at a recursive position, the branch puts the observation of the state, with the equality of the two positions, to be cast when it is observed, so that a stream is cast lazily:

```math
\begin{aligned}
\mathsf{cast}(T_1,\ T_2,\ e,\ t) &\equiv \mathsf{corec}_{\mathbb{1}}\ (\bar a_{1\mathsf{nu}},\ t,\ e)\ \mathsf{return}\ \bar S\ \mathsf{as}\ (\bar x_1,\ w,\ \varepsilon)\ \mathsf{with}\ D_1.d_{11}(\bar x_{11}) \Rightarrow \lceil v_{11} \rceil \mid \dots &&(\mathsf{cast}^{-}) \\
& \quad \text{where } S_j = (\bar x_1 :_{\mathbb{0}} \Delta_{\mathsf{nu}}[\bar a_{1\mathsf{u}}],\ w :_{\mathbb{1}} T_{1j}[\bar x_1],\ \varepsilon :_{\mathbb{0}} T_{1j}[\bar x_1] \sim_{s_n} T_{2j}[\bar x_{\mathsf{nu}}]) \quad \text{for each } j, \\
& \quad v_{ji} = \mathsf{cast}(B_{ji}[T_{1j}[\bar x_1]][w.\bar d][\bar x'_{ji}],\ B_{ji}[T_{2j}[\bar x_{\mathsf{nu}}]][c.\bar d][\bar x_{ji}],\ e_{ji},\ w.d_{ji}(\bar x'_{ji})) \\
& \quad \text{and } \bar x'_{ji} = \mathsf{cast}_{\Theta_{ji}[T_{2j}[\bar x_{\mathsf{nu}}]][c.\bar d]}(e_{ji1},\ \bar x_{ji})
\end{aligned}
```

Here $`T_{1j}[\bar b]`$ and $`T_{2j}[\bar b]`$ are the instances of $`D_j`$ with the sorts, levels, grades and uniform arguments of $`T_1`$ and of $`T_2`$, and the non-uniform arguments $`\bar b`$; the corecursor builds $`T_2`$, at its non-uniform arguments, from the state made of those of $`T_1`$, of $`t`$ and of $`e`$, and $`c`$ is the corecursor itself at the state of the branch.
At the state $`(\bar x_1,\ w,\ \varepsilon)`$ of the type $`D_j`$, the proof $`\varepsilon`$ reduces by $`(\sim^{-}_D)`$ to the equality of the contexts of destructors, whose conjunct for $`d_{ji}`$, instantiated with the observations of $`w`$ and of $`c`$ for the earlier destructors, gives $`e_{ji1}`$, the equality of the telescopes of arguments from the second instance to the first, along which the arguments are cast back, and $`e_{ji}`$, the equality of the result types at these arguments, along which the observation of $`w`$ is cast forward; the branches use $`\varepsilon`$ and $`\bar x_1`$ with $`\mathbb{0}`$, in types and proofs only.
Then $`\lceil \cdot \rceil`$ puts $`\mathsf{next}`$ at the positions of $`T_2`$ in the result, with the non-uniform arguments of the position in $`T_1`$, the term that the observation of $`w`$ holds there and the equality of the two positions, taken from $`e_{ji}`$, in place of the cast of this term, through the map of the nesting types.
A cast of the type of functions is then the function that casts its argument back, applies, and casts its result, as [Pujet and Tabareau](https://doi.org/10.1145/3498693) define it; a cast between two instances of a codata type that is not recursive is equal to its term when the instances are equal, by $`(\mathsf{cast}_{\mathsf{refl}})`$ and $`(D^{-}_\eta)`$.

#### Stuck Casts

A cast between two canonical types that no rule relates, whose equality is $`\bot`$, does not compute: it is a neutral term, stuck on its proof, as the elimination of the false proposition; no closed term proves $`\bot`$, so that no closed program reaches it, as the [properties](#properties) state.
A cast whose types are not canonical reduces them first, and a cast whose term is not canonical reduces it, so that the reduction of the casts is deterministic.

### Quotients

A quotient is a type whose terms are those of a type $`A`$, taken up to a relation $`R`$ that is an equivalence: the equality of two terms of the quotient is the relation, as in the type theory of [Pujet and Tabareau](https://doi.org/10.1145/3498693).
It is a third kind of declaration, which fulfills the contract of the [core](https://github.com/sic-lang/rfcs/pull/24): its block declares one type $`D`$, with a constructor $`c`$ whose single field is a term of $`A`$, and a relation on two terms of $`A`$ given with its proofs of reflexivity, symmetry and transitivity, each written with the variables it binds:

```math
\mathsf{quotient}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : U_l\ \mathsf{where}\ D \mathrel{≔} c : (x :^{\mathbb{0}}_{p} A)\ /\ (x,\ y).\, R\ \mathsf{by}\ (x).\, e_{\mathsf{r}},\ (x,\ y,\ h).\, e_{\mathsf{s}},\ (x,\ y,\ z,\ h_1,\ h_2).\, e_{\mathsf{t}}
```

#### Formation of Quotients

A quotient is well formed when its carrier $`A`$ lives in its universe, when its relation is a proposition on two terms of the carrier, and when the three proofs prove that the relation is an equivalence; the quotient does not refer to itself, since a recursive quotient would quotient a type by a relation on the quotient, and its parameters have the polarity that $`A`$ gives them, as the field of a data type with one constructor:

```math
\frac{\begin{gathered}{}\Sigma;\ \Delta \vdash A : U_l \quad \Sigma;\ \Delta,\ x : A,\ y : A \vdash R : \Omega_l \quad \Sigma;\ \Delta,\ x : A \vdash e_{\mathsf{r}} : R[x/y] \\ \Sigma;\ \Delta,\ x : A,\ y : A,\ h : R \vdash e_{\mathsf{s}} : R[y/x,\ x/y] \quad \Sigma;\ \Delta,\ x : A,\ y : A,\ z : A,\ h_1 : R,\ h_2 : R[y/x,\ z/y] \vdash e_{\mathsf{t}} : R[z/y] \\ D \text{ does not occur in } A \text{ or } R \quad \zeta \text{ is the usage of } A \text{ with the grade } p\end{gathered}}{\Sigma \vdash \mathsf{quotient}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : U_l\ \mathsf{where}\ D \mathrel{≔} c : (x :^{\mathbb{0}}_{p} A)\ /\ (x,\ y).\, R\ \mathsf{by}\ (x).\, e_{\mathsf{r}},\ (x,\ y,\ h).\, e_{\mathsf{s}},\ (x,\ y,\ z,\ h_1,\ h_2).\, e_{\mathsf{t}}}\;(\mathsf{quotient})
```

The usage of an instance of the quotient is that of a data type with the single field of $`c`$, by the rule $`(D^{+}_{\mathsf{m}})`$ of the [data types](https://github.com/sic-lang/rfcs/pull/34): the relation and its proofs use no variable, since they live in erased positions only.

#### Construction and Elimination of Quotients

A term of the quotient is the class of a term of the carrier, built by $`c`$ as by the constructor of a data type with one field, and used with the grade of the field; the rules of the quotients carry the exponent $`/`$, as those of the data and codata types carry their polarity:

```math
\frac{\Sigma;\ \Gamma \vdash T \quad \Sigma;\ \Gamma \vdash t : A[\bar a / \Delta]}{\Sigma;\ \Gamma \vdash T.c(t) : T}\;(D^{/}_{\mathsf{i}})
\qquad
\frac{\Sigma;\ \gamma \mathrel{▶_{m \odot p}} t}{\Sigma;\ p \cdot^{\mathsf{c}} \gamma \mathrel{▶_m} T.c(t)}\;(D^{/}_{\mathsf{i}\mathsf{m}})
```

A term of the quotient is eliminated by a recursor with one branch, which receives the term of the carrier, and a proof that the branch respects the relation: on two related terms, it gives equal results, the first cast to the type of the second along the equality of the classes that the relation gives.
The proof is omitted when the motive is a proposition, since two proofs are equal by irrelevance:

```math
\frac{\begin{gathered}{}\Sigma;\ \Gamma,\ z : T \vdash C : \kappa_C \quad \kappa_C \in \{U_{l_C}, \Omega_{l_C}\} \quad \Sigma;\ \Gamma \vdash t : T \quad \Sigma;\ \Gamma,\ x : A[\bar a / \Delta] \vdash u : C[T.c(x)/z] \\ \Sigma;\ \Gamma,\ x : A[\bar a / \Delta],\ y : A[\bar a / \Delta],\ h : R[\bar a / \Delta] \vdash e : \mathsf{cast}(C[T.c(x)/z],\ C[T.c(y)/z],\ e_h,\ u) \sim_{C[T.c(y)/z]} u[y/x] \text{ if } \kappa_C = U_{l_C}\end{gathered}}{\Sigma;\ \Gamma \vdash \mathsf{rec}_r\ t\ \mathsf{return}\ (z : T).\, C\ \mathsf{with}\ c(x) \Rightarrow u\ \mathsf{by}\ e : C[t/z]}\;(D^{/}_{\mathsf{rec}})
```

Here $`e_h`$ is the proof of $`C[T.c(x)/z] \sim C[T.c(y)/z]`$ that the congruence $`\mathsf{ap}`$ builds from $`h`$, a proof of $`T.c(x) \sim_T T.c(y)`$ by the rule $`(\sim^{/})`$ below.
The recursor uses the term with the grade $`r`$ it carries, and the branch uses the field as the grade of the field times $`r`$ allows, as the recursor of a data type with one constructor; the proof of respect uses no variable, since it is checked in the mode $`\mathbb{0}\mathbb{0}^{\mathsf{m}}`$, and the motive too:

```math
\frac{\begin{gathered}{}\Sigma;\ \mathbb{0}^{\mathsf{c}} \mathrel{▶_{\mathbb{0}\mathbb{0}^{\mathsf{m}}}} C \quad \Sigma;\ \gamma \mathrel{▶_{m \odot r}} t \quad \Sigma;\ \delta \bullet g \mathrel{▶_m} u \quad \Sigma;\ \gamma' \mathrel{▶_{\mathbb{0}\mathbb{0}^{\mathsf{m}}}} e \\ \ulcorner m \urcorner \cdot r \cdot p \le g\end{gathered}}{\Sigma;\ r \cdot^{\mathsf{c}} \gamma +^{\mathsf{c}} \delta \mathrel{▶_m} \mathsf{rec}_r\ t\ \mathsf{return}\ (z : T).\, C\ \mathsf{with}\ c(x) \Rightarrow u\ \mathsf{by}\ e}\;(D^{/}_{\mathsf{rec}\mathsf{m}})
```

Eliminating a class that has just been built runs the branch on its term, and two classes are equal exactly when their terms are related; a class is cast to an equal instance by casting its term:

```math
\begin{aligned}
\mathsf{rec}_r\ T.c(t)\ \mathsf{return}\ (z : T).\, C\ \mathsf{with}\ c(x) \Rightarrow u\ \mathsf{by}\ e &\equiv u[t/x] &&(D^{/}_{\mathsf{rec}\beta}) \\
T_1.c(t) \sim_{T} T_2.c(u) &\equiv R[\bar a / \Delta][t/x,\ u/y] &&(\sim^{/}) \\
T_1 \sim_{U_n} T_2 &\equiv (e : A[T_1] \sim_{U_n} A[T_2]) \wedge \forall (x\ y : A[T_1]).\, R[T_1] \sim_{\Omega_n} R[T_2][\mathsf{cast}(A[T_1], A[T_2], e, x)/x,\ \mathsf{cast}(A[T_1], A[T_2], e, y)/y] &&(\sim^{/}_{D}) \\
\mathsf{cast}(T_1,\ T_2,\ e,\ T_1.c(t)) &\equiv T_2.c(\mathsf{cast}(A[T_1],\ A[T_2],\ e_1,\ t)) \quad \text{where } e_1 \text{ is the first conjunct of } e &&(\mathsf{cast}^{/})
\end{aligned}
```

A quotient has no $`\eta`$ rule: its recursor on a neutral term stays neutral, since a term of the quotient is not determined by a term of the carrier.

### The Contract Extended

This RFC extends the contract of the [core](https://github.com/sic-lang/rfcs/pull/24) for every kind of declaration: a kind provides, for its instances and its terms, what the equality and the cast need, as the data types, the codata types and the quotients do above.

1. Equality of the instances: the rule that reduces $`T_1 \sim T_2`$, for two instances of a type of the kind with the same sorts and grades and equal levels, to the equality of their bodies, as $`(\sim^{+}_D)`$, $`(\sim^{-}_D)`$ and $`(\sim^{/}_{D})`$ do.
2. Equality of the terms: the rules that reduce $`t \sim_T u`$ on the canonical forms of its terms, as $`(\sim^{+})`$, $`(\sim^{+}_{\ne})`$, $`(\sim^{-})`$ and $`(\sim^{/})`$ do.
3. Cast: the rules that reduce $`\mathsf{cast}(T_1,\ T_2,\ e,\ t)`$ on the canonical forms of $`t`$, as $`(\mathsf{cast}^{+})`$, $`(\mathsf{cast}^{-})`$ and $`(\mathsf{cast}^{/})`$ do.
4. Erasure: the cast of a canonical form of the kind erases to the erasure of the form, so that the [erasure](#erasure) of the cast is the identity.
5. Obligations: the soundness of the rules above for the [meaning](#meaning) of the equality, and the preservation of usage by the reductions of the cast.

### Conversion

The equality and the cast add to the [conversion](https://github.com/sic-lang/rfcs/pull/24) of the core their computations and one rule of equality.
An equality of two terms reduces its type to a head normal form, then its terms, and applies the rule of its kind; an equality whose type or terms are neutral is a neutral type, as an equality of two variables.
A cast reduces its types, then its term, and applies the rule of its kind, or is stuck when the types are canonical and unrelated.
The rule $`(\mathsf{cast}_{\mathsf{refl}})`$ is decided on the head normal forms and the neutral terms: a cast is compared to a term by first comparing its types, and to another cast either by this rule on each side or by the congruence of the casts, which the algorithm tries in turn, as [Pujet, Leray and Tabareau](https://doi.org/10.1145/3719342) describe; the [properties](#properties) state that the equality stays decidable, and an implementation chooses how.

### Erasure

The proofs of equality are proofs, which the [erasure](https://github.com/sic-lang/rfcs/pull/24) of the core never extracts, and a cast erases to its term, so that a cast costs nothing at run time; a class of a quotient erases to its term, so that a quotient is represented by its carrier.
As in the [data and codata types](https://github.com/sic-lang/rfcs/pull/34), $`\lfloor t \rfloor`$ is the erasure of a position, $`t^\bullet`$ or $`t^\circ`$ when its grade is kept and $`\text{↯}`$ when it is erased:

| Term | $`t^\bullet`$ | $`t^\circ`$ |
| --- | --- | --- |
| $`t \sim_A u`$, $`\mathsf{refl}_A(t)`$, $`\mathsf{transp}(x.\, P,\ e,\ v)`$ | $`\text{↯}`$ | $`\text{↯}`$ |
| $`\mathsf{cast}(A,\ B,\ e,\ t)`$ | $`t^\bullet`$ | $`t^\circ`$ |
| $`T.c(t)`$ | $`\lfloor t \rfloor`$, at the grade $`p`$ | $`\lfloor t \rfloor`$, at the grade $`p`$ |
| $`\mathsf{rec}_r\ t\ \mathsf{return}\ (z : T).\, C\ \mathsf{with}\ c(x) \Rightarrow u\ \mathsf{by}\ e`$ | $`u^\bullet[\lfloor t \rfloor / x]`$, at the grade $`r`$ | $`u^\circ[\lfloor t \rfloor / x]`$, at the grade $`r`$ |

A proof of an equality, a transport and the proof of a cast are all checked in erased modes, so that $`t^\circ`$ keeps a proof that uses a permission counted once in total, and $`t^\bullet`$ removes it.
The soundness of this erasure, that a program and its extraction compute the same canonical term although the casts disappear, is a named [property](#properties): the cast of a canonical form is the canonical form of the cast fields, whose extraction is the extraction of the form, since every equality of types with a closed proof relates two instances of the same type with the same grades, which erase alike.

### Meaning

The equality completes the [meaning](https://github.com/sic-lang/rfcs/pull/24) of the judgments with the setoid model of [Altenkirch](https://doi.org/10.1109/LICS.1999.782636), as [Pujet and Tabareau](https://doi.org/10.1145/3498693) build it for their observational equality: every type comes with the equality of its canonical terms, which the meaning of the core already gives as $`\mathsf{eq}(A_0)`$, and the equality is the proposition that two terms are related by it.

#### Meaning of the Equality

The equality of two closed terms is a canonical proposition, which reduces on the canonical forms of its type and of its terms; its truth is the equality of the terms in the meaning of the core, for a type of a universe that computes to no universe $`U_j`$, and the equality of the two types with the same grades, for a type that computes to one; both clauses read the type up to computation, as the clauses of the core do, so that a type that computes to a universe without being written as one falls under the second:

```math
\begin{aligned}
\text{if } \Sigma \vDash A : U_k \text{ and } A \text{ computes to no universe } U_j \text{, then } \mathsf{true}(t \sim_A u) &\iff \Sigma \vDash t \equiv u : A &&(\mathsf{true}_\sim) \\
\text{if } A \Downarrow U_j \text{, then } \mathsf{true}(B \sim_A C) &\iff \Sigma \vDash B \equiv C : A \text{ and } \exists B_0, C_0.\ B \Downarrow B_0,\ C \Downarrow C_0 \text{ and } B_0, C_0 \text{ have the same grades} &&(\mathsf{true}_{\sim\mathsf{type}})
\end{aligned}
```

Two canonical types have the same grades when they are instances of one declared type with the same grades $`\bar p`$ and sorts $`\bar s`$, whose bodies, instantiated, have the same grades, or when they are the same sort; this is the only clause of the meaning of the core and of its kinds that reads the grades, which the rule $`(\sim_{D\ne})`$ needs: without it, a cast between two function types that differ only by a grade would be sound in the meaning, and break the usage of its term.
The reductions of the equality are then sound: $`(\sim_U)`$, $`(\sim_\Omega)`$, $`(\sim_{\mathsf{prop}})`$ and $`(\sim_{\ne})`$ follow the clauses of the universes and of the propositions, $`(\sim^{+}_D)`$, $`(\sim^{-}_D)`$ and $`(\sim^{/}_{D})`$ the clauses that relate the instances, $`(\sim^{+})`$ and $`(\sim^{+}_{\ne})`$ the clause $`(\mathsf{eq}_{\mathsf{con}})`$ of the data types, $`(\sim^{-})`$ the clause $`(\mathsf{eq}_{\mathsf{corec}})`$ of the codata types, whose greatest fixed point the truth of the bisimilarity is by $`(\mathsf{true}_{\mathsf{codata}})`$, and $`(\sim^{/})`$ the clause of the quotients below.
The rules $`(\sim)`$, $`(\sim_{\mathsf{irr}})`$, $`(\mathsf{refl})`$ and $`(\mathsf{transp})`$ are sound: a term is equal to itself, and a hypothetical judgment holds under equal substitutions, which transports a proof.

#### Meaning of the Cast

A cast is meaningful when its types are equal types, which its proof ensures, since no closed term proves a false proposition: it then computes as its term does, which the rules $`(\mathsf{cast}^{+})`$, $`(\mathsf{cast}^{-})`$ and $`(\mathsf{cast}^{/})`$ say, and is equal to its term in the meaning, which validates the rule $`(\mathsf{cast}_{\mathsf{refl}})`$ for every proof:

```math
\begin{aligned}
& \Sigma \vDash A \equiv B,\ \Sigma \vDash e : A \sim_{U_k} B \text{ and } \Sigma \vDash t : A &&(\mathsf{valid}_{\mathsf{cast}}) \\
\implies {}& \Sigma \vDash \mathsf{cast}(A,\ B,\ e,\ t) \equiv t : B
\end{aligned}
```

The rule $`(\mathsf{cast}_{\mathsf{refl}})`$ is thus sound, and so is $`(\mathsf{cast})`$.

#### Meaning of the Quotients

A quotient is meaningful when its carrier is a type, its relation a proposition on the carrier, and its proofs proofs, for every pair of equal arguments, as the rule $`(\mathsf{quotient})`$ checks; the canonical terms of an instance are the classes of the canonical terms of the carrier, and two of them are equal when their terms are related, which the relation decides as a proposition:

```math
\begin{aligned}
\text{if } \mathcal{D} \text{ is a quotient, then } \Sigma \vDash \mathcal{D} \iff {}& \Sigma \vDash \Delta \text{ and } \forall (\sigma_1, \sigma_2) \in \mathsf{eq}(\Delta).\ \Sigma \vDash A[\sigma_1] \equiv A[\sigma_2] : U_l, &&({\vDash}_{\mathsf{quotient}}) \\
& \quad \Sigma;\ x : A[\sigma_1],\ y : A[\sigma_1] \vDash R[\sigma_1] \equiv R[\sigma_2] : \Omega_l, \text{ and the three proofs are proofs} \\
\mathsf{eq}(T) = {}& \{(T_1.c(v),\ T_2.c(w)) \mid T_1, T_2 \text{ instances of } D,\ \Sigma \vDash v : A[T],\ \Sigma \vDash w : A[T],\ \mathsf{true}(R[T][v/x,\ w/y])\} \quad \text{if } T \text{ is a closed instance of a quotient } D \text{ of } \Sigma &&(\mathsf{eq}^{/}) \\
(T_1,\ T_2) \in \mathsf{eq}(U_n) &\quad \text{if } T_1 \text{ and } T_2 \text{ are closed instances of a quotient } D \text{ of } \Sigma,\ \Sigma \vDash A[T_1] \equiv A[T_2] : U_n, &&(\mathsf{eq}_{\mathsf{quotient}}) \\
& \quad \text{and } \Sigma;\ x : A[T_1],\ y : A[T_1] \vDash R[T_1] \equiv R[T_2] : \Omega_n
\end{aligned}
```

The relation $`\mathsf{eq}(T)`$ is a partial equivalence relation since $`R`$ is an equivalence, which the three proofs ensure, and the rules $`(\mathsf{quotient})`$, $`(D^{/}_{\mathsf{i}})`$, $`(D^{/}_{\mathsf{rec}})`$ and $`(D^{/}_{\mathsf{rec}\beta})`$ are then sound: the recursor respects the relation by its proof, so that its result does not depend on the term of the class.

### Properties

The properties below are theorems about the equality, each a named formula, which the formalization has to prove; the first ones are the admissible rules of the equality, the next ones discharge the obligations of the contract, and the last one is the guarantee that the erasure of the casts gives to the programs.
The symmetry and the transitivity of the equality, and the eliminator $`J`$ into a type, are admissible: the rules give a proof or a term for them, which no rule of this RFC names, so that the equality keeps its three primitives, and the term of $`J`$ computes when the two sides of its equality are equal, as on reflexivity:

```math
\begin{aligned}
& \Sigma;\ \Gamma \vdash e : t \sim_A u \implies \exists e'.\ \Sigma;\ \Gamma \vdash e' : u \sim_A t &&(\mathsf{sym}_\sim) \\
& \Sigma;\ \Gamma \vdash e_1 : t \sim_A u \text{ and } \Sigma;\ \Gamma \vdash e_2 : u \sim_A v \implies \exists e'.\ \Sigma;\ \Gamma \vdash e' : t \sim_A v &&(\mathsf{trans}_\sim) \\
& \Sigma;\ \Gamma,\ y : A \vdash C : U_{l'},\ \Sigma;\ \Gamma \vdash e : t \sim_A u \text{ and } \Sigma;\ \Gamma \vdash v : C[t/y] &&(J_\sim) \\
\implies {}& \exists J_e(v).\ \Sigma;\ \Gamma \vdash J_e(v) : C[u/y] \text{ and} \\
& \quad (\Sigma;\ \Gamma \vdash t \equiv u : A \implies \Sigma;\ \Gamma \vdash J_e(v) \equiv v : C[u/y])
\end{aligned}
```

```math
\begin{aligned}
& \text{the rules of the equality, of the cast and of the quotients are sound for the meaning above} &&(\mathsf{sound}_\sim) \\
& \Sigma;\ \gamma \mathrel{▶_m} t \text{ and } t \longrightarrow u \text{ by } (\mathsf{cast}^{+}),\ (\mathsf{cast}^{-}),\ (\mathsf{cast}^{/}) \text{ or } (D^{/}_{\mathsf{rec}\beta}) \implies \Sigma;\ \gamma \mathrel{▶_m} u &&(\mathsf{usage}_{\mathsf{cast}}) \\
& \Sigma;\ \Gamma \vdash t \equiv u : A \text{ stays decidable with the rule } (\mathsf{cast}_{\mathsf{refl}}) &&(\mathsf{decidable}_{\mathsf{cast}}) \\
& (\mathsf{hyp}_\iota) \implies \Sigma;\ \varepsilon \nvdash e : \bot, \text{ hence no closed program reaches a stuck cast} &&(\mathsf{consistent}_\sim) \\
& (\mathsf{hyp}_\bullet),\ \Sigma;\ \varepsilon \vdash t : A,\ \Sigma;\ \mathbb{0}^{\mathsf{c}} \mathrel{▶_{\mathbb{1}\mathbb{1}^{\mathsf{m}}}} t \text{ and } t \Downarrow v \implies t^\bullet \Downarrow v^\bullet, \text{ with the casts erased to their terms} &&(\mathsf{sound}_{\bullet\mathsf{cast}})
\end{aligned}
```

The extensionality of functions and of propositions follow from the rules $`(\sim^{-})`$ and $`(\sim_{\mathsf{prop}})`$, and the consistency follows from the soundness, since the setoid model refutes $`\bot`$, under the hypotheses $`(\mathsf{hyp}_\iota)`$ and $`(\mathsf{hyp}_\bullet)`$ of the [core](https://github.com/sic-lang/rfcs/pull/24) on the constants of the signature, as the consistency and the soundness of the erasure of the core are.
The soundness of the erasure of the casts is the risk of this RFC: a cast disappears at run time, so that the program that runs must compute the same values as the type theory does with the casts; the argument is that a closed proof of an equality of types relates two instances of one type with the same grades and equal fields, on which the cast is the identity up to the casts of the fields, that the proofs of equality held by the fields of a data type are erased, as every proof, and that a quotient is represented by its carrier.
No published proof covers it for the observational type theories, as the [unresolved questions](#unresolved-questions) say.

### Examples

The examples of this RFC are its annexes: the files of the directory that bears the name of this file, one file per example.
Each annex derives its formulas from the rules of this RFC, of which they are not part.

## Drawbacks

- Every cast carries its two types and its proof, and every proof of equality its type: the terms are meant to be checked, not written by hand, and the surface language infers what they carry.
- The conversion decides $`(\mathsf{cast}_{\mathsf{refl}})`$ by trying two rules on a cast, which costs a comparison of its types at each cast on the way; the cost is paid once per comparison, not at run time.
- The equality of two instances of a declared type is not the equality of their parameters: two vectors types of different lengths may be equal types, when their fields are, and an equality of instances gives back the equality of the fields only, not of the arguments, as in the type theory of [Pujet, Leray and Tabareau](https://doi.org/10.1145/3719342); the injectivity of the parameters, which the identity type gives, is lost, since it is inconsistent with the extensionality of propositions in the lowest universe.
- The soundness of the erasure of the casts, with the grades, is a proof obligation with no published precedent, as the [unresolved questions](#unresolved-questions) say.
- A recursive codata type has no $`\eta`$ in the conversion, so that two bisimilar streams are equal as a proposition only, and a program that needs them equal as types transports along the bisimilarity.

## Rationale and Alternatives

- The equality is observational rather than the identity type of Martin-Löf type theory, as in Agda, Lean and Rocq: the identity type lacks the extensionality of functions and of propositions, which the proofs of programs need at every turn, and the axioms that add them block the computation of the transports; the observational equality computes, gives both extensionalities as rules, and keeps the equality a strict proposition, so that its proofs are erased and its uniqueness holds by irrelevance.
  Univalence, which cubical type theories add to a proof-relevant equality, was not wanted: an equality in a strict proposition cannot carry an equivalence, and the extensionalities are all that the programs ask.
- The rule $`(\mathsf{cast}_{\mathsf{refl}})`$ is a rule of conversion rather than a rule of reduction, as [Pujet, Leray and Tabareau](https://doi.org/10.1145/3719342) have it: a reduction would have to decide an equality of types inside the reduction, which no framework of normalization supports; a rule of conversion is decided after the reduction, on the head normal forms, as the extensionalities are, and the algorithm tries the two rules that may apply.
  Without it, the recursor of an indexed family, derived by fording, would compute on closed terms only, since the transports along the equalities of the indices would stay in the way on open terms.
- The equality of two instances of a declared type gives the equality of their bodies, not of their parameters, as in the type theory of Pujet, Leray and Tabareau: the injectivity of the parameters, in the lowest universe, together with the extensionality of propositions, embeds a universe into itself, which is inconsistent; the equality of the bodies is what the cast needs, and the equality of the arguments is proved by hand where it holds.
- The equality of two instances reads their grades, and two instances with different grades are unequal: the meaning of the core ignores the grades, so that a function of a linear argument and a function of an unrestricted one are equal types in it, and a cast between them would let a program use a linear resource twice; the clause $`(\mathsf{true}_{\sim\mathsf{type}})`$ is the one place where the meaning reads the grades, and the weakening of a function stays an explicit abstraction.
- The equality of two recursive codata terms is their bisimilarity, a coinductive proposition, rather than an equality withheld from the recursive types or decided by unfolding: the bisimilarity gives back as a proposition the extensionality that the conversion withholds, is proved by the corecursor in $`\Omega`$, which the [data and codata types](https://github.com/sic-lang/rfcs/pull/34) allow for the recursive codata in $`\Omega`$, and is what [McBride](https://personal.cis.strath.ac.uk/conor.mcbride/pub/JUnfold/junfold.pdf) adds to observational type theory for the coinductive types.
- The transport is primitive and the eliminator $`J`$ admissible, as in the type theory of Pujet, Leray and Tabareau: the transport into a proposition needs no computation, since proofs are irrelevant, and the elimination into a type is a cast, which computes on the types; the symmetry and the transitivity are admissible too, and the congruence is an abbreviation of the transport, so that the equality has three primitives and no more.
  The admissible rules are properties, whose witnesses no rule names, rather than derived rules written in this RFC: the rules of the equality are then written with the primitives and the congruence only, which the equality of the arguments of two destructors states from the second to the first, so that the arguments are cast back without a symmetry, where the rule Eq-Π of [Pujet and Tabareau](https://doi.org/10.1145/3498693) casts along the inverse of the proof.
- The quotients are a kind of declaration that fulfills the whole contract, rather than a primitive type outside the kinds: a quotient has a formation, a usage, a constructor, a recursor, a meaning, a conversion and an erasure, as the data types do, and the contract gives them a place without a rule of the core; they are the construction that the data and codata types do not give, since a data type whose constructors identify terms is not a data type, and the equality is the one thing they add, as [Pujet and Tabareau](https://doi.org/10.1145/3498693) note that their quotients come for free with the observational equality.
- The indexed families are elaborated by fording rather than built into the core: native indices are a second mechanism, whose cast is stuck on the indices and whose unification is part of the kernel; the fording keeps the kernel to the non-uniform parameters of the data types and to the equality, as [Pujet, Leray and Tabareau](https://doi.org/10.1145/3719342) elaborate their indexed inductive types, at the price of the rule $`(\mathsf{cast}_{\mathsf{refl}})`$ for the derived recursors to compute on open terms.
  No rule, meaning or property of this RFC uses the families, which are written as data types with non-uniform parameters and fields of equality of grade $`\mathbb{0}`$, so the elaboration and the derived recursor are an [annex](0035-observational-equality/indexed-families.md).
- Conscious exclusions, each with what is lost, what remains, and whether it can be added later:
  - Univalence: two equivalent types are not equal, and a program transports along an equivalence by hand; it would need a proof-relevant equality, which the strict propositions exclude.
  - Higher inductive types other than the quotients: a type with constructors for its equalities and for the equalities of its equalities is not declared; the quotients give the types whose equality is a relation, and the set truncation of every type is built in, since the equality is a proposition; a kind of declaration for the higher inductive types of sets could be added, as the quotients were.

## Prior Art

- The observational type theory of [Altenkirch, McBride and Swierstra](https://doi.org/10.1145/1292597.1292608), the first equality that computes on the types and gives the extensionality of functions, which [McBride](https://personal.cis.strath.ac.uk/conor.mcbride/pub/JUnfold/junfold.pdf) extends to the coinductive types by bisimulation.
- The observational type theory with strict propositions of [Pujet and Tabareau](https://doi.org/10.1145/3498693), whose equality, transport, cast and quotients this RFC follows, and whose metatheory is formalized for a theory without indexed types and without grades; its extension to the inductive types of [Pujet, Leray and Tabareau](https://doi.org/10.1145/3719342), with the rule of conversion of the cast on equal types, the equality of the inductive types by their fields, and the indexed families by fording, whose normalization is formalized for the natural numbers and whose implementation extends Coq by rewrite rules.
- The setoid model of [Altenkirch](https://doi.org/10.1109/LICS.1999.782636), the meaning of the equality, and the fording of [McBride](https://era.ed.ac.uk/handle/1842/374), which elaborates the indexed families.
- The erasure of the proofs of an intensional equality and of the quotients, proved sound by [Danielsson](https://arxiv.org/abs/2609.08578) in the graded type theory of Abel, Danielsson and Eriksson, which covers neither the observational equality nor the cast.
- The quotient types of [Lean](https://lean-lang.org/doc/reference/latest/The-Type-System/Quotients/), primitive with their soundness axiom, from which Lean derives the extensionality of functions, and its axiom of propositional extensionality; here both are rules.

## Unresolved Questions

- Is the erasure of the casts sound with the grades?
  The argument above is a sketch: no complete published proof covers the soundness of erasure for an observational type theory, and the one of [Danielsson](https://arxiv.org/abs/2609.08578) covers the intensional identity type and the quotients only; the property $`(\mathsf{sound}_{\bullet\mathsf{cast}})`$ is a proof obligation of the formalization.
- Does the metatheory of [Pujet, Leray and Tabareau](https://doi.org/10.1145/3719342), formalized for the natural numbers, extend to the declarations of the data and codata types and to the grades?
  They expect the scheme of inductive types to pose no difficulty; the codata types, the bisimilarity and the grades are new.
- Is the setoid model consistent with the bisimilarity of the recursive codata types, as the quotient of the coinductive types by their bisimulation?
  No published proof covers exactly this combination.
- Does the metatheory of the quotients, which [Pujet and Tabareau](https://doi.org/10.1145/3498693) extend on paper only, carry over to the quotients as a kind of declaration?
