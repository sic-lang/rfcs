# Meaning

This annex defines the meaning of the judgments of the typing, with the interpretation of the constant declarations and the equality of the canonical terms of the sorts, and its properties.
It builds on the [levels](06-levels.md), the [sorts](07-sorts.md), the [substitution](09-substitution.md), the [typing](13-typing.md) and the [reduction](14-reduction.md).

The judgments mean what the meaning explanations of Martin-Löf type theory say of them, as [Nordström, Petersson and Smith](https://intuitionistic.wordpress.com/wp-content/uploads/2010/07/nordstrom-et-al-type-theory.pdf) present them: a judgment is true when its terms compute as it says.
The meaning ignores the grades, the modes and the ownerships, as the typing does outside the judgments of usage and of ownership that the rule of the constant definitions reads.
What the usage and the ownership of a term guarantee of its erasure when it runs is not stated here: these guarantees need the evaluation order that the RFC of the calling convention fixes.

## Definitions

This section gives the levels without variables, the interpretation of the constant declarations and the equality of the canonical terms of the sorts, of the data types and of the codata types, then the meaning of each judgment of the typing, by the objects it checks, and the interpretations that give each constant declaration a term of its type.
The meaning of a judgment is written with $`\vDash`$ in place of $`\vdash`$.

### Levels Without Variables

A closed term has no level variable, and an assignment $`\rho`$ of natural numbers to the level variables gives a closed instance of an object with level variables.
The level $`\underline{n}`$ is the level without variables whose value is the natural number $`n`$, and the instantiation $`[\rho]`$ of a term, of arguments, of a telescope, of a context or of a sort [instantiates](09-substitution.md) each of its level variables $`l`$ by the level whose value is $`\rho(l)`$:

```math
\begin{aligned}
& \underline{0} = 0 &&(\mathsf{numeral}_l) \\
& \underline{n + 1} = \underline{n} + 1 \\[1em]
& [\rho] = [\underline{\rho(\bar l)} / \bar l] \text{ where } \bar l \text{ are the level variables} &&(\mathsf{inst}_\rho)
\end{aligned}
```

### Interpretation of the Constants

A constant declaration has no body to compute: the meaning takes an interpretation $`\iota`$, which gives each constant declaration $`f`$, at each instance $`\bar s',\ \bar p'`$ of its sort and grade variables, a term $`\iota(f.\{\bar s';\ \bar p'\})`$ without variables, in which its level variables may occur.
The signature $`\iota(\Sigma)`$ is $`\Sigma`$ in which each constant declaration becomes the constant definition whose body is its interpretation, $`\iota(f)`$ being the body whose instance at $`\bar s',\ \bar p'`$ is $`\iota(f.\{\bar s';\ \bar p'\})`$:

```math
\begin{aligned}
& \iota(\varnothing) = \varnothing &&(\mathsf{interpret}_\Sigma) \\
& \iota(\Sigma,\ f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p) = \iota(\Sigma),\ f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \mathrel{≔} \iota(f) \\
& \iota(\Sigma,\ e) = \iota(\Sigma),\ e \text{ otherwise}
\end{aligned}
```

In the meaning, a closed term $`t`$ computes to $`v`$, written $`t \Downarrow v`$, when $`\iota(\Sigma) \vdash t \Downarrow v`$, as the formula $`(\Downarrow)`$ of the [reduction](14-reduction.md) defines it, so that the meaning has the single reduction of the typing.
The computation, the equality $`\mathsf{eq}`$ and the meaning of the judgments all depend on the signature $`\Sigma`$ and on the interpretation $`\iota`$, which their notation omits.

### Equality of the Canonical Terms

A closed canonical type $`v`$ is known by its canonical terms and by their equality $`\mathsf{eq}(v)`$, a relation between closed terms, which the sorts, the data types and the codata types give, together with the types themselves.
The graph $`\mathsf{ty}(U_n)`$ of the universe $`U_n`$ relates each of its types $`v`$ to the equality $`R`$ of its canonical terms, written $`(v,\ R) \in \mathsf{ty}(U_n)`$, and the graph $`\mathsf{ty}(\Omega_n)`$ of the universe of propositions $`\Omega_n`$ relates each of its propositions $`v`$ to its truth $`b`$, written $`(v,\ b) \in \mathsf{ty}(\Omega_n)`$.
A graph gives one type at a time, and two types are equal when they have the same equality of terms, so that two types that the typing does not equate may be equal in the meaning, such as two data types without constructors.
The value $`[\![l]\!]`$ of a level $`l`$ without variables is its [value](06-levels.md) under any assignment.

The closed terms of a type that is not a proposition are equal when they compute to canonical terms that the equality of its canonical terms relates, and those of a proposition when it is true:

```math
\begin{aligned}
& \mathsf{eq}_\Downarrow(R) = \{(t,\ u) \mid \exists v,\ w.\ t \Downarrow v,\ u \Downarrow w \text{ and } (v,\ w) \in R\} &&(\mathsf{eq}_\Downarrow) \\[1em]
& (v,\ \mathsf{eq}_\Downarrow(R)) \in \mathsf{ty}_\Downarrow(U_n) \text{ if } (v,\ R) \in \mathsf{ty}(U_n) &&(\mathsf{ty}_\Downarrow) \\
& (v,\ \{(t,\ u) \mid b\}) \in \mathsf{ty}_\Downarrow(\Omega_n) \text{ if } (v,\ b) \in \mathsf{ty}(\Omega_n)
\end{aligned}
```

A universe is a type of the universe above its level, whose terms are the types of the universe below, equal when they have the same equality of terms, and a universe of propositions one whose terms are the propositions of the universe below, equal when they have the same truth:

```math
\begin{aligned}
& \in &&(\mathsf{ty}_U) \\
& \quad (U_l,\ \{(A,\ B) \mid \exists R.\ (A,\ R) \in \mathsf{ty}(U_{n - 1}) \text{ and } (B,\ R) \in \mathsf{ty}(U_{n - 1})\}) \\
& \quad \mathsf{ty}(U_n) \text{ if } [\![l]\!] + 1 = n \\[1em]
& \in &&(\mathsf{ty}_\Omega) \\
& \quad (\Omega_l,\ \{(A,\ B) \mid \exists b_1,\ b_2.\ (A,\ b_1) \in \mathsf{ty}(\Omega_{n - 1}),\ (B,\ b_2) \in \mathsf{ty}(\Omega_{n - 1}) \text{ and } b_1 \iff b_2\}) \\
& \quad \mathsf{ty}(U_n) \text{ if } [\![l]\!] + 1 = n
\end{aligned}
```

A data type $`D_j`$ of a type declaration $`\mathsf{data}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ \dots`$ of the signature, whose constructors are $`c_{j1} : \Theta_{j1} \mid \dots \mid c_{j n_j} : \Theta_{j n_j}`$, has, at a closed instance $`T = D_j.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a`$, the sort and the fields of its declaration at the instance of its variables and at the arguments of its parameters:

```math
\begin{aligned}
& \kappa[T] = \kappa[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p] &&(\mathsf{inst}_T) \\
& \Theta_{ji}[T] = \Theta_{ji}[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p][\bar a / \Delta]
\end{aligned}
```

A codata type $`D_j`$ of a type declaration $`\mathsf{codata}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ \dots`$ of the signature, whose destructors are $`\bar d_j`$, has likewise, at a closed instance $`T`$, the sort $`\kappa[T]`$ and the destructors of its declaration at the instance of its variables and at the arguments of its parameters:

```math
\begin{aligned}
& \bar d_j[T] = \bar d_j[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p][\bar a / \Delta] &&(\mathsf{inst}_{\bar d})
\end{aligned}
```

The canonical terms of an instance are its constructors, at any instance of its type, since the instance that a constructor carries only determines the type of the term, and two of them are equal when they are the same constructor with fields that the equality $`S_i`$ of the terms of the fields of the constructor $`c_{ji}`$ relates; a proposition declared as a data type is true when one of its constructors has terms for its fields:

```math
\begin{aligned}
& = &&(\mathsf{eq}_c) \\
& \quad \mathsf{eq}_c(D_j,\ \bar S) \\
& \quad \{(T_1.c_{ji}(\bar t),\ T_2.c_{ji}(\bar u)) \mid T_1 \text{ and } T_2 \text{ are instances of } D_j \text{ and } (\bar t,\ \bar u) \in S_i\} \\[1em]
& \mathsf{true}(D_j,\ \bar S) \iff \exists i,\ \bar t.\ (\bar t,\ \bar t) \in S_i &&(\mathsf{true}_D)
\end{aligned}
```

An instance in a universe is a type of it, and an instance in a universe of propositions a proposition of it, when the fields of its constructors are telescopes in its sort, whose terms are equal by the relations $`\bar S`$:

```math
\begin{aligned}
& (T,\ \mathsf{eq}_c(D_j,\ \bar S)) \in \mathsf{ty}(U_n) \text{ if} &&(\mathsf{ty}_D) \\
& \quad \text{and} \\
& \qquad T = D_j.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a \text{ is a closed instance of a data type of } \Sigma \\
& \qquad \kappa[T] = U_l \text{ and } [\![l]\!] = n \\
& \qquad \forall i.\ (\Theta_{ji}[T],\ S_i) \in \mathsf{ty}(U_n) \\[1em]
& (T,\ \mathsf{true}(D_j,\ \bar S)) \in \mathsf{ty}(\Omega_n) \text{ if} &&(\mathsf{ty}_{D\Omega}) \\
& \quad \text{and} \\
& \qquad T = D_j.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a \text{ is a closed instance of a data type of } \Sigma \\
& \qquad \kappa[T] = \Omega_l \text{ and } [\![l]\!] = n \\
& \qquad \forall i.\ (\Theta_{ji}[T],\ S_i) \in \mathsf{ty}(\Omega_n)
\end{aligned}
```

The canonical terms of an instance of a codata type are its corecursors, at any instance of its type, as for the constructors, and two of them are equal when their observations are related by the equality $`S`$ of the destructors of the type: the observations $`\mathsf{obs}(v)`$ of a corecursor $`v`$ of the instance $`T_v`$ it carries are the closed abstractions $`\bar x.\, v.(T_v.d)(\bar x)`$, one for each destructor $`d`$, over the variables of its arguments, so that two corecursors are equal when their observations at equal arguments are equal, as the partial equivalence relations of the types of functions relate them; a proposition declared as a codata type is true when $`S`$ relates some abstractions to themselves, so that each of its destructors has a result at all its arguments:

```math
\begin{aligned}
& = &&(\mathsf{eq}_d) \\
& \quad \mathsf{eq}_d(D_j,\ S) \\
& \quad \{(v,\ w) \mid v \text{ and } w \text{ are corecursors of instances of } D_j \text{ and } (\mathsf{obs}(v),\ \mathsf{obs}(w)) \in S\} \\[1em]
& \mathsf{true}_d(S) \iff \exists \bar f.\ (\bar f,\ \bar f) \in S &&(\mathsf{true}_d)
\end{aligned}
```

An instance of a codata type in a universe is a type of it, and an instance in a universe of propositions a proposition of it, when its destructors are in its sort, with the equality $`S`$ of the abstractions for them:

```math
\begin{aligned}
& (T,\ \mathsf{eq}_d(D_j,\ S)) \in \mathsf{ty}(U_n) \text{ if} &&(\mathsf{ty}_d) \\
& \quad \text{and} \\
& \qquad T = D_j.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a \text{ is a closed instance of a codata type of } \Sigma \\
& \qquad \kappa[T] = U_l \text{ and } [\![l]\!] = n \\
& \qquad (\bar d_j[T],\ S) \in \mathsf{ty}(U_n) \\[1em]
& (T,\ \mathsf{true}_d(S)) \in \mathsf{ty}(\Omega_n) \text{ if} &&(\mathsf{ty}_{d\Omega}) \\
& \quad \text{and} \\
& \qquad T = D_j.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a \text{ is a closed instance of a codata type of } \Sigma \\
& \qquad \kappa[T] = \Omega_l \text{ and } [\![l]\!] = n \\
& \qquad (\bar d_j[T],\ S) \in \mathsf{ty}(\Omega_n)
\end{aligned}
```

The graph $`\mathsf{ty}(s_n)`$ of the telescopes in the sort $`s_n`$, of the quality $`s`$ at the level $`n`$, relates a closed telescope $`\Theta`$ to the equality $`S`$ of the terms of its fields, written $`(\Theta,\ S) \in \mathsf{ty}(s_n)`$.
A telescope is in it when its first type computes to a type of a sort that $`s_n`$ [bounds](07-sorts.md), and its rest is for each term of it, the same for equal terms, as the condition on the families of types of [Abel, Öhman and Vezzosi](https://doi.org/10.1145/3158111) requires:

```math
\begin{aligned}
& (\varepsilon,\ \{((),\ ())\}) \in \mathsf{ty}(s_n) &&(\mathsf{ty}_{\Theta\varepsilon}) \\[1em]
& \in \text{ if} &&(\mathsf{ty}_{\Theta,}) \\
& \quad ((x : A \mathrel{▶} p;\ q \mathrel{◀} r,\ \Theta),\ \{((a_1,\ \bar t),\ (a_2,\ \bar u)) \mid (a_1,\ a_2) \in F \text{ and } (\bar t,\ \bar u) \in G(a_1)\}) \\
& \quad \mathsf{ty}(s_n) \\
& \quad \text{and} \\
& \qquad \exists v,\ \kappa_1.\ A \Downarrow v,\ \kappa_1 \preceq s_n \text{ and } (v,\ F) \in \mathsf{ty}_\Downarrow(\kappa_1) \\
& \qquad \forall (a,\ a) \in F.\ (\Theta[a / x],\ G(a)) \in \mathsf{ty}(s_n) \\
& \qquad \forall (a_1,\ a_2) \in F.\ G(a_1) = G(a_2)
\end{aligned}
```

The graph $`\mathsf{ty}(s_n)`$ relates likewise closed destructors $`\bar d`$ to the equality $`S`$ of the families $`\bar f`$ of closed abstractions for them, one abstraction $`f_d`$ for each destructor $`d`$, written $`(\bar d,\ S) \in \mathsf{ty}(s_n)`$.
Destructors are in it when the arguments $`\Theta`$ of the first one are a telescope in the universe $`U_n`$, whatever the quality $`s`$, its result type computes at equal arguments $`\bar t`$, and to types of sorts that $`s_n`$ bounds, with an equality $`F(\bar t)`$ of their terms that is the same for equal arguments, and the destructors after it are for each abstraction for it, the same for equal abstractions, two abstractions being equal when they give equal results at equal arguments:

```math
\begin{aligned}
& (\varepsilon,\ \{(\bar f,\ \bar g) \mid \bar f \text{ and } \bar g \text{ are families of closed abstractions}\}) \in \mathsf{ty}(s_n) &&(\mathsf{ty}_{\bar d\varepsilon}) \\[1em]
& \in \text{ if} &&(\mathsf{ty}_{\bar d|}) \\
& \quad ((d : (\Theta \vdash B \mathrel{◀} \psi) \mathrel{▶} p;\ q \mid \bar d),\ \{(\bar f,\ \bar g) \mid (f_d,\ g_d) \in E \text{ and } (\bar f,\ \bar g) \in G(f_d)\}) \\
& \quad \mathsf{ty}(s_n) \\
& \quad \text{and} \\
& \qquad (\Theta,\ S_\Theta) \in \mathsf{ty}(U_n) \\
& \qquad \forall (\bar t,\ \bar t) \in S_\Theta.\ \exists v.\ B[\bar t / \bar x] \Downarrow v \\
& \qquad \forall (\bar t,\ \bar t) \in S_\Theta.\ \forall v.\ B[\bar t / \bar x] \Downarrow v \implies \exists \kappa_1 \preceq s_n.\ (v,\ F(\bar t)) \in \mathsf{ty}_\Downarrow(\kappa_1) \\
& \qquad \forall (\bar t_1,\ \bar t_2) \in S_\Theta.\ F(\bar t_1) = F(\bar t_2) \\
& \qquad E = \{(f_1,\ f_2) \mid \forall (\bar t,\ \bar u) \in S_\Theta.\ (f_1[\bar t / \bar x],\ f_2[\bar u / \bar x]) \in F(\bar t)\} \\
& \qquad \forall (f,\ f) \in E.\ (\bar d[f / d],\ G(f)) \in \mathsf{ty}(s_n) \\
& \qquad \forall (f_1,\ f_2) \in E.\ G(f_1) = G(f_2)
\end{aligned}
```

At each level $`n`$, the relations $`\mathsf{ty}(U_n)`$, $`\mathsf{ty}(\Omega_n)`$ and $`\mathsf{ty}(s_n)`$, of the telescopes and of the destructors, are the least relations with these clauses, given the relations of the levels below $`n`$, which the clauses read for the universes of these levels and for the fields and the results of destructors whose types are of a sort below $`s_n`$; the levels are defined one after the other, and at each level a least relation defines the equality of the terms of each type it gives together with the types themselves.
The block is not recursive, so that the fields and the destructors of an instance are given before it, and its relations are not circular.

A closed canonical type has the equality that a universe gives it, and a proposition the equality of its proofs: all the closed terms when it is true, and none when it is false; a closed canonical type is a proposition when a universe of propositions gives it, and a closed type computes to a proposition when its canonical form is one:

```math
\begin{aligned}
& \mathsf{eq}(v) = R \text{ if } (v,\ R) \in \mathsf{ty}(U_n) &&(\mathsf{eq}_{\mathsf{type}}) \\[1em]
& \mathsf{eq}(v) = \{(t,\ u) \mid t \text{ and } u \text{ are closed terms}\} \text{ if } (v,\ b) \in \mathsf{ty}(\Omega_n) \text{ with a true } b &&(\mathsf{eq}_{\mathsf{true}}) \\[1em]
& \mathsf{eq}(v) = \varnothing \text{ if } (v,\ b) \in \mathsf{ty}(\Omega_n) \text{ with a false } b &&(\mathsf{eq}_{\mathsf{false}}) \\[1em]
& v \text{ is a proposition} \iff \exists n,\ b.\ (v,\ b) \in \mathsf{ty}(\Omega_n) &&(\mathsf{prop}_v) \\[1em]
& A \text{ computes to a proposition} \iff \exists v.\ A \Downarrow v \text{ and } v \text{ is a proposition} &&(\mathsf{prop}_\Downarrow)
\end{aligned}
```

The relation $`\mathsf{eq}(v)`$ is defined only for the closed canonical types that these clauses give, and is then unique when the names of the signature are distinct, by $`(\mathsf{unique}_{\mathsf{eq}})`$.

### Closed Judgments

A closed judgment requires the names of its signature to be distinct, as every judgment of the typing implies that its signature is well formed, whose names are distinct, so that a closed term computes to one canonical term at most.
Two closed types are equal when they compute to canonical types with the same equality of terms, and two closed terms are equal terms of a type that does not compute to a proposition when they compute to canonical terms that its equality relates; the terms of a proposition need not compute, since its equality relates the terms themselves:

```math
\begin{aligned}
& \text{⟺} &&(\vDash_{\mathsf{type}\equiv}) \\
& \quad \Sigma \vDash A \equiv B \\
& \quad \text{and} \\
& \qquad \text{the names of } \Sigma \text{ are distinct} \\
& \qquad \exists v_1,\ v_2,\ R.\ A \Downarrow v_1,\ B \Downarrow v_2,\ \mathsf{eq}(v_1) = R \text{ and } \mathsf{eq}(v_2) = R \\[1em]
& \Sigma \vDash A \iff \Sigma \vDash A \equiv A &&(\vDash_{\mathsf{type}}) \\[1em]
& \text{⟺ if } A \text{ does not compute to a proposition} &&(\vDash_\equiv) \\
& \quad \Sigma \vDash t \equiv u : A \\
& \quad \text{and} \\
& \qquad \Sigma \vDash A \\
& \qquad \exists v,\ w_1,\ w_2.\ A \Downarrow v,\ t \Downarrow w_1,\ u \Downarrow w_2 \text{ and } (w_1,\ w_2) \in \mathsf{eq}(v) \\[1em]
& \text{⟺ if } A \text{ computes to a proposition} &&(\vDash_{\equiv\Omega}) \\
& \quad \Sigma \vDash t \equiv u : A \\
& \quad \text{and} \\
& \qquad \Sigma \vDash A \\
& \qquad \exists v.\ A \Downarrow v \text{ and } (t,\ u) \in \mathsf{eq}(v) \\[1em]
& \Sigma \vDash t : A \iff \Sigma \vDash t \equiv t : A &&(\vDash)
\end{aligned}
```

### Signatures and Entries

A signature is meaningful when its names are [distinct](08-syntax.md), as the rules of the [signatures](13-typing.md) require, and each of its entries is meaningful in the whole signature, written $`\Sigma \vDash e`$ for an entry $`e`$ of $`\Sigma`$.
An entry is not made meaningful in the signature before it alone: a type declaration quantifies over the closed terms of its fields, which a larger signature may add, so that a type meaningful in a signature need not be in a larger one, while the typing ensures that it is:

```math
\begin{aligned}
& \text{⟺} &&({\vDash}\mathsf{sig}) \\
& \quad \vDash \Sigma \\
& \quad \text{and} \\
& \qquad \text{the names of } \Sigma \text{ are distinct} \\
& \qquad \forall e \in \Sigma.\ \Sigma \vDash e
\end{aligned}
```

A type declaration is meaningful when, at each instance of its sort and grade variables, the fields of each of its constructors are a [telescope in its sort](#telescopes-in-a-sort), in the context of its parameters, the constructors of each of its types having distinct names when the [names of the signature](08-syntax.md) are; the parameters need no meaning of their own, since that of the fields holds it, and an instance reads the meaning of its arguments only:

```math
\begin{aligned}
& \text{⟺} &&({\vDash}\mathsf{data}) \\
& \quad \Sigma \vDash \mathsf{data}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} \bar c_1;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \bar c_k \\
& \quad \forall \bar s',\ \bar p' \text{ as many as } \bar s,\ \bar p.\ \forall j, i.\ \Sigma;\ \Delta[\bar s' / \bar s,\ \bar p' / \bar p] \vDash \Theta_{ji}[\bar s' / \bar s,\ \bar p' / \bar p] : \kappa[\bar s' / \bar s,\ \bar p' / \bar p]
\end{aligned}
```

A block of codata types is meaningful likewise when, at each instance of its sort and grade variables, the destructors of each of its types are [in its sort](#destructors-in-a-sort), in the context of its parameters:

```math
\begin{aligned}
& \text{⟺} &&({\vDash}\mathsf{codata}) \\
& \quad \Sigma \vDash \mathsf{codata}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} \bar d_1;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \bar d_k \\
& \quad \forall \bar s',\ \bar p' \text{ as many as } \bar s,\ \bar p.\ \forall j.\ \Sigma;\ \Delta[\bar s' / \bar s,\ \bar p' / \bar p] \vDash \bar d_j[\bar s' / \bar s,\ \bar p' / \bar p] : \kappa[\bar s' / \bar s,\ \bar p' / \bar p]
\end{aligned}
```

A constant definition is meaningful when its body is a term of its type, and a constant declaration when its interpretation is, at each instance of their sort and grade variables and each assignment of their level variables:

```math
\begin{aligned}
& \text{⟺} &&({\vDash}\mathsf{def}) \\
& \quad \Sigma \vDash f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \mathrel{≔} t \\
& \quad \forall \bar s',\ \bar p' \text{ as many as } \bar s,\ \bar p.\ \forall \rho. \\
& \qquad \Sigma \vDash t[\bar s' / \bar s,\ \bar p' / \bar p][\rho] : A[\bar s' / \bar s,\ \bar p' / \bar p][\rho] \\[1em]
& \text{⟺} &&({\vDash}\mathsf{decl}) \\
& \quad \Sigma \vDash f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \\
& \quad \forall \bar s',\ \bar p' \text{ as many as } \bar s,\ \bar p.\ \forall \rho. \\
& \qquad \Sigma \vDash \iota(f.\{\bar s';\ \bar p'\})[\rho] : A[\bar s' / \bar s,\ \bar p' / \bar p][\rho]
\end{aligned}
```

The meaning of a signature with constant declarations is thus relative to an interpretation: an axiom is meaningful only if its proposition is true, and a foreign constant only if some term of the core has its type.

### Contexts and Hypothetical Judgments

A judgment in a context $`\Gamma`$ holds under every pair of equal closed substitutions of $`\Gamma`$, of the second order, which give each variable equal closed terms of its type, and each second-order variable abstractions whose instances by equal arguments are equal terms of its type; a telescope $`\Theta`$ and the parameters $`\Delta`$ of a type declaration have the equal substitutions of the contexts they form, and their arguments are the substitutions $`[\bar t / \Theta]`$ and $`[\bar a / \Delta]`$:

```math
\begin{aligned}
& \mathsf{eq}(\varepsilon) = \{((),\ ())\} &&(\mathsf{eq}_\varepsilon) \\[1em]
& = &&(\mathsf{eq}_x) \\
& \quad \mathsf{eq}(\Gamma,\ x : A) \\
& \quad \{((\theta_1,\ a_1),\ (\theta_2,\ a_2)) \mid (\theta_1,\ \theta_2) \in \mathsf{eq}(\Gamma) \text{ and } \Sigma \vDash a_1 \equiv a_2 : A[\theta_1]\} \\[1em]
& = &&(\mathsf{eq}_X) \\
& \quad \mathsf{eq}(\Gamma,\ X : (\Theta \vdash A \mathrel{◀} \psi)) \\
& \quad \{((\theta_1,\ \bar x.\, B_1),\ (\theta_2,\ \bar x.\, B_2)) \mid \\
& \qquad (\theta_1,\ \theta_2) \in \mathsf{eq}(\Gamma) \text{ and} \\
& \qquad \forall (\sigma_1,\ \sigma_2) \in \mathsf{eq}(\Theta[\theta_1]).\ \Sigma \vDash B_1[\sigma_1] \equiv B_2[\sigma_2] : A[\theta_1,\ \sigma_1]\}
\end{aligned}
```

A context is meaningful when its last type is a type in the context before it, which makes this context meaningful too:

```math
\begin{aligned}
& \Sigma \vDash \varepsilon \iff \text{the names of } \Sigma \text{ are distinct} &&({\vDash}\mathsf{ctx}_\varepsilon) \\[1em]
& \Sigma \vDash \Gamma,\ x : A \iff \Sigma;\ \Gamma \vDash A &&({\vDash}\mathsf{ctx}_x) \\[1em]
& \Sigma \vDash \Gamma,\ X : (\Theta \vdash A \mathrel{◀} \psi) \iff \Sigma;\ \Gamma,\ \Theta \vDash A &&({\vDash}\mathsf{ctx}_X)
\end{aligned}
```

A judgment in a context requires the context to be meaningful, and holds under every pair of its equal closed substitutions:

```math
\begin{aligned}
& \text{⟺} &&({\vDash}\Gamma_{\mathsf{type}\equiv}) \\
& \quad \Sigma;\ \Gamma \vDash A \equiv B \\
& \quad \text{and} \\
& \qquad \Sigma \vDash \Gamma \\
& \qquad \forall (\theta_1,\ \theta_2) \in \mathsf{eq}(\Gamma).\ \Sigma \vDash A[\theta_1] \equiv B[\theta_2] \\[1em]
& \Sigma;\ \Gamma \vDash A \iff \Sigma;\ \Gamma \vDash A \equiv A &&({\vDash}\Gamma_{\mathsf{type}}) \\[1em]
& \text{⟺} &&({\vDash}\Gamma_\equiv) \\
& \quad \Sigma;\ \Gamma \vDash t \equiv u : A \\
& \quad \text{and} \\
& \qquad \Sigma;\ \Gamma \vDash A \\
& \qquad \forall (\theta_1,\ \theta_2) \in \mathsf{eq}(\Gamma).\ \Sigma \vDash t[\theta_1] \equiv u[\theta_2] : A[\theta_1] \\[1em]
& \Sigma;\ \Gamma \vDash t : A \iff \Sigma;\ \Gamma \vDash t \equiv t : A &&({\vDash}\Gamma) \\[1em]
& \text{⟺} &&({\vDash}\Gamma_{\mathsf{tel}\equiv}) \\
& \quad \Sigma;\ \Gamma \vDash \bar t \equiv \bar u : \Theta \\
& \quad \text{and} \\
& \qquad \Sigma \vDash \Gamma \\
& \qquad \forall (\theta_1,\ \theta_2) \in \mathsf{eq}(\Gamma).\ ([\bar t[\theta_1] / \Theta[\theta_1]],\ [\bar u[\theta_2] / \Theta[\theta_1]]) \in \mathsf{eq}(\Theta[\theta_1]) \\[1em]
& \Sigma;\ \Gamma \vDash \bar t : \Theta \iff \Sigma;\ \Gamma \vDash \bar t \equiv \bar t : \Theta &&({\vDash}\Gamma_{\mathsf{tel}}) \\[1em]
& \text{⟺} &&({\vDash}\Gamma_{\mathsf{arg}\equiv}) \\
& \quad \Sigma;\ \Gamma \vDash \bar a_1 \equiv \bar a_2 : \Delta \\
& \quad \text{and} \\
& \qquad \Sigma \vDash \Gamma \\
& \qquad \forall (\theta_1,\ \theta_2) \in \mathsf{eq}(\Gamma).\ ([\bar a_1[\theta_1] / \Delta],\ [\bar a_2[\theta_2] / \Delta]) \in \mathsf{eq}(\Delta) \\[1em]
& \Sigma;\ \Gamma \vDash \bar a : \Delta \iff \Sigma;\ \Gamma \vDash \bar a \equiv \bar a : \Delta &&({\vDash}\Gamma_{\mathsf{arg}})
\end{aligned}
```

### Telescopes in a Sort

Two closed telescopes are equal in a sort $`\kappa`$ when their first types are equal types of a sort that $`\kappa`$ bounds, and the rest of them equal for every pair of equal terms of these types, whatever their grades, as the rule $`(\mathsf{tel}_{\kappa,})`$ checks; a telescope lives in a sort in a context when its instances by equal closed substitutions of the context are equal in it:

```math
\begin{aligned}
& \Sigma \vDash \varepsilon \equiv \varepsilon : \kappa \iff \text{the names of } \Sigma \text{ are distinct} &&({\vDash}\mathsf{tel}_{\kappa\varepsilon}) \\[1em]
& \text{⟺} &&({\vDash}\mathsf{tel}_{\kappa,}) \\
& \quad \Sigma \vDash (x : A_1 \mathrel{▶} p_1;\ q_1 \mathrel{◀} r_1,\ \Theta_1) \equiv (x : A_2 \mathrel{▶} p_2;\ q_2 \mathrel{◀} r_2,\ \Theta_2) : \kappa \\
& \quad \text{and} \\
& \qquad \exists \kappa_1 \preceq \kappa.\ \Sigma \vDash A_1 \equiv A_2 : \kappa_1 \\
& \qquad \forall a_1,\ a_2.\ \Sigma \vDash a_1 \equiv a_2 : A_1 \implies \Sigma \vDash \Theta_1[a_1 / x] \equiv \Theta_2[a_2 / x] : \kappa \\[1em]
& \text{⟺} &&({\vDash}\Gamma_{\mathsf{tel}\kappa}) \\
& \quad \Sigma;\ \Gamma \vDash \Theta : \kappa \\
& \quad \text{and} \\
& \qquad \Sigma \vDash \Gamma \\
& \qquad \forall (\theta_1,\ \theta_2) \in \mathsf{eq}(\Gamma).\ \Sigma \vDash \Theta[\theta_1] \equiv \Theta[\theta_2] : \kappa
\end{aligned}
```

### Destructors in a Sort

Destructors live in a sort $`\kappa`$ in a context when the premises of the rules [$`(\bar d_{\kappa\varepsilon})`$ and $`(\bar d_{\kappa|})`$](13-typing.md) are meaningful: the arguments of the first one are a telescope in the universe of the level of $`\kappa`$, its result is a term of a sort that $`\kappa`$ bounds, in the context extended by its arguments, and the destructors after it live in $`\kappa`$, in the context extended by it, a second-order variable whose equal substitutions are the equal abstractions for it:

```math
\begin{aligned}
& \Sigma;\ \Gamma \vDash \varepsilon : \kappa \iff \Sigma \vDash \Gamma &&({\vDash}\bar d_{\kappa\varepsilon}) \\[1em]
& \text{⟺} &&({\vDash}\bar d_{\kappa|}) \\
& \quad \Sigma;\ \Gamma \vDash (d : (\Theta \vdash B \mathrel{◀} \psi) \mathrel{▶} p;\ q \mid \bar d) : \kappa \\
& \quad \text{and} \\
& \qquad \Sigma;\ \Gamma \vDash \Theta : U_l \text{ where } l \text{ is the level of } \kappa \\
& \qquad \exists \kappa_1 \preceq \kappa.\ \Sigma;\ \Gamma,\ \Theta \vDash B : \kappa_1 \\
& \qquad \Sigma;\ \Gamma,\ d : (\Theta \vdash B \mathrel{◀} \psi) \vDash \bar d : \kappa
\end{aligned}
```

### Level Variables

A judgment $`\mathcal{J}`$ in a context $`\Gamma`$ whose objects have level variables is true when it is true at every assignment of its level variables, as an entry checked once with its level variables is used at any levels:

```math
\begin{aligned}
& \Sigma;\ \Gamma \vDash \mathcal{J} \iff \forall \rho.\ \Sigma;\ \Gamma[\rho] \vDash \mathcal{J}[\rho] &&(\vDash_\rho)
\end{aligned}
```

### Interpretations of a Signature

An interpretation $`\iota`$ interprets a signature when it gives each constant declaration of the signature a term of its type, in the whole signature:

```math
\begin{aligned}
& \text{⟺} &&(\mathsf{hyp}_\iota) \\
& \quad \iota \text{ interprets } \Sigma \\
& \quad \forall (f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p) \in \Sigma.\ \Sigma \vDash f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p
\end{aligned}
```

## Properties

In a signature whose names are distinct, the equality of the terms of a closed canonical type is a partial equivalence relation, symmetric and transitive, and is unique, so that the notation $`\mathsf{eq}(v)`$ names one relation; the names of the signature make a closed term compute to one canonical term at most and a declared type the data type or the codata type of one declaration:

```math
\begin{aligned}
& \text{⟹} &&(\mathsf{per}_{\mathsf{eq}}.\mathsf{symm}) \\
& \quad \text{and} \\
& \qquad \text{the names of } \Sigma \text{ are distinct} \\
& \qquad \mathsf{eq}(v) = R \text{ and } (t_1,\ t_2) \in R \\
& \quad (t_2,\ t_1) \in R \\[1em]
& \text{⟹} &&(\mathsf{per}_{\mathsf{eq}}.\mathsf{trans}) \\
& \quad \text{and} \\
& \qquad \text{the names of } \Sigma \text{ are distinct} \\
& \qquad \mathsf{eq}(v) = R,\ (t_1,\ t_2) \in R \text{ and } (t_2,\ t_3) \in R \\
& \quad (t_1,\ t_3) \in R \\[1em]
& \text{⟹} &&(\mathsf{unique}_{\mathsf{eq}}) \\
& \quad \text{and} \\
& \qquad \text{the names of } \Sigma \text{ are distinct} \\
& \qquad \mathsf{eq}(v) = R_1 \text{ and } \mathsf{eq}(v) = R_2 \\
& \quad R_1 = R_2
\end{aligned}
```

A meaningful signature has [distinct](08-syntax.md) names, as a well-formed one does, so that the computation is deterministic, by $`(\mathsf{det}_{\Downarrow})`$; and the meaning is exact for the proofs: two closed terms are equal proofs of a proposition exactly when each of them is a proof of it, as the rule $`(\mathsf{irr})`$ says:

```math
\begin{aligned}
& \vDash \Sigma \implies \text{the names of } \Sigma \text{ are distinct} &&(\mathsf{distinct}_{\vDash\Sigma}) \\[1em]
& \text{⟹} &&(\mathsf{exact}_\Omega) \\
& \quad \Sigma \vDash A : \Omega_l \\
& \quad \Sigma \vDash t \equiv u : A \iff \Sigma \vDash t : A \text{ and } \Sigma \vDash u : A
\end{aligned}
```

Every judgment of the typing is meaningful under an interpretation that interprets its signature, which is the soundness of the typing; a judgment whose objects have level variables is then meaningful at every assignment of them, by $`(\vDash_\rho)`$:

```math
\begin{aligned}
& \iota \text{ interprets } \Sigma \text{ and } \vdash \Sigma \implies \vDash \Sigma &&(\mathsf{sound}.\Sigma) \\[1em]
& \text{⟹} &&(\mathsf{sound}.\mathsf{def}) \\
& \quad \text{and} \\
& \qquad \iota \text{ interprets } \Sigma \\
& \qquad \Sigma \vdash f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \mathrel{≔} t \\
& \quad \Sigma \vDash f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \mathrel{≔} t \\[1em]
& \text{⟹} &&(\mathsf{sound}.\mathsf{decl}) \\
& \quad \text{and} \\
& \qquad \iota \text{ interprets } \Sigma,\ f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \\
& \qquad \Sigma \vdash f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \\
& \quad \Sigma,\ f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \vDash f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \\[1em]
& \text{⟹} &&(\mathsf{sound}.\mathsf{data}) \\
& \quad \text{and} \\
& \qquad \iota \text{ interprets } \Sigma \\
& \qquad \Sigma \vdash \mathsf{data}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} \bar c_1;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \bar c_k \\
& \quad \Sigma \vDash \mathsf{data}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} \bar c_1;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \bar c_k \\[1em]
& \text{⟹} &&(\mathsf{sound}.\mathsf{codata}) \\
& \quad \text{and} \\
& \qquad \iota \text{ interprets } \Sigma \\
& \qquad \Sigma \vdash \mathsf{codata}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} \bar d_1;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \bar d_k \\
& \quad \Sigma \vDash \mathsf{codata}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} \bar d_1;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \bar d_k \\[1em]
& \iota \text{ interprets } \Sigma \text{ and } \Sigma \vdash \Gamma \implies \Sigma \vDash \Gamma &&(\mathsf{sound}.\Gamma) \\[1em]
& \iota \text{ interprets } \Sigma \text{ and } \Sigma;\ \Gamma \vdash A \implies \Sigma;\ \Gamma \vDash A &&(\mathsf{sound}.A) \\[1em]
& \iota \text{ interprets } \Sigma \text{ and } \Sigma;\ \Gamma \vdash A \equiv B \implies \Sigma;\ \Gamma \vDash A \equiv B &&(\mathsf{sound}.A_\equiv) \\[1em]
& \iota \text{ interprets } \Sigma \text{ and } \Sigma;\ \Gamma \vdash t : A \implies \Sigma;\ \Gamma \vDash t : A &&(\mathsf{sound}.t) \\[1em]
& \iota \text{ interprets } \Sigma \text{ and } \Sigma;\ \Gamma \vdash t \equiv u : A \implies \Sigma;\ \Gamma \vDash t \equiv u : A &&(\mathsf{sound}.t_\equiv) \\[1em]
& \iota \text{ interprets } \Sigma \text{ and } \Sigma;\ \Gamma \vdash \bar t : \Theta \implies \Sigma;\ \Gamma \vDash \bar t : \Theta &&(\mathsf{sound}.\bar t) \\[1em]
& \iota \text{ interprets } \Sigma \text{ and } \Sigma;\ \Gamma \vdash \bar t \equiv \bar u : \Theta \implies \Sigma;\ \Gamma \vDash \bar t \equiv \bar u : \Theta &&(\mathsf{sound}.\bar t_\equiv) \\[1em]
& \iota \text{ interprets } \Sigma \text{ and } \Sigma;\ \Gamma \vdash \bar a : \Delta \implies \Sigma;\ \Gamma \vDash \bar a : \Delta &&(\mathsf{sound}.\bar a) \\[1em]
& \iota \text{ interprets } \Sigma \text{ and } \Sigma;\ \Gamma \vdash \bar a_1 \equiv \bar a_2 : \Delta \implies \Sigma;\ \Gamma \vDash \bar a_1 \equiv \bar a_2 : \Delta &&(\mathsf{sound}.\bar a_\equiv) \\[1em]
& \iota \text{ interprets } \Sigma \text{ and } \Sigma;\ \Gamma \vdash \Theta : \kappa \implies \Sigma;\ \Gamma \vDash \Theta : \kappa &&(\mathsf{sound}.\Theta) \\[1em]
& \iota \text{ interprets } \Sigma \text{ and } \Sigma;\ \Gamma \vdash \bar d : \kappa \implies \Sigma;\ \Gamma \vDash \bar d : \kappa &&(\mathsf{sound}.\bar d)
\end{aligned}
```

The soundness of a constant declaration rests on the interpretation alone: its typing checks its type but gives it no term, so that a well-formed constant declaration is meaningful only by an interpretation, as $`f : \Omega_0`$ shows, which is well formed while the core gives $`\Omega_0`$ no proposition, hence no term.
