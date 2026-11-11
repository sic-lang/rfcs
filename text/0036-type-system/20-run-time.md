# Run Time

This annex defines the relation of run time between the closed terms and the values that their erasure computes, which states what the erasure of a term computes when it runs, and its properties.
It builds on the [erasure](16-erasure.md), the [evaluation](17-evaluation.md) and the [meaning](18-meaning.md).

## Definitions

The relation of run time relates a closed term of a closed type to the address of a value of the target language in a heap, when the value is what the erasure by $`S^{{11}^{\mathsf{m}}}`$ of the term computes.
It is defined on the heaps that the evaluation extends, by the graph of the relations of the types of each level, as the meaning defines the equality of the terms of each type.
It is stated in a program $`\mathcal{P}`$, which gives the constants of the target language their bodies, and an interpretation of the constant declarations, which the computations $`t \Downarrow v`$ of the closed terms use, as in the meaning.

### Extension of the Heaps

The evaluation only allocates, at the end of the heap, and never changes a value, so that the heap at a later point of a run extends the heap at an earlier point.
A heap $`H'`$ extends a heap $`H`$, written $`{H \sqsubseteq H'}`$, when $`H`$ is a prefix of $`H'`$, which keeps the value at each address of $`H`$:

```math
\begin{aligned}
& H \sqsubseteq H' \iff \exists \bar V.\ H' = (H,\ \bar V) &&(\sqsubseteq_H)
\end{aligned}
```

### Relations of Run Time

A relation of run time $`R`$ is a set of triples $`(H,\ t,\ \ell)`$ of a heap, a closed term and an address.
A closed term is related by $`{\circledR_\Downarrow(R)}`$ to an address when it computes to a canonical term that $`R`$ relates to it, and a position of the grade $`p`$ is related by $`R^p`$, which relates every term to every address when $`p`$ has no use at run time, since the erasure replaces such a position by $`\text{↯}`$:

```math
\begin{aligned}
& \circledR_\Downarrow(R) = \{(H,\ t,\ \ell) \mid \exists v.\ t \Downarrow v \text{ and } (H,\ v,\ \ell) \in R\} &&(\circledR_\Downarrow) \\[1em]
& R^p = \{(H,\ t,\ \ell) \mid p \notin S^{{11}^{\mathsf{m}}} \implies (H,\ t,\ \ell) \in R\} &&(\circledR_p)
\end{aligned}
```

The canonical terms of an instance of a data type are its constructors, at any instance of its type, as in the meaning, and a constructor $`c_{ji}`$ is related to the constructor of its case in the target language whose fields the relation $`S_i`$ of the fields of $`c_{ji}`$ relates to its own, $`(H,\ \bar t,\ \bar\ell) \in S_i`$:

```math
\begin{aligned}
& = &&(\circledR_c) \\
& \quad \circledR_c(D_j,\ \bar S) \\
& \quad \{(H,\ T.c_{ji}(\bar t),\ \ell) \mid T \text{ is an instance of } D_j,\ H(\ell) = c_{i'}(\bar\ell) \text{ with } i' = \mathsf{case}_\Sigma(D_j.c_{ji}) \text{ and } (H,\ \bar t,\ \bar\ell) \in S_i\}
\end{aligned}
```

The relations of the instances of the types of a block are given together, as their equalities are: given relations $`\bar X`$, one $`X_D`$ for each type $`D`$ of the block, and the relation $`S_{j'i}(\bar X)`$ of the fields of each constructor $`c_{j'i}`$ that relates its recursive fields of the type $`D`$ by $`X_D`$, the relation of the instances is the least family of relations closed under $`(\circledR_c)`$:

```math
\begin{aligned}
& \text{⟺} &&(\circledR_\mu) \\
& \quad (H,\ v,\ \ell) \in \circledR_\mu(D_j,\ \bar S) \\
& \quad \forall \bar X.\ (\forall j'.\ \circledR_c(D_{j'},\ \bar S_{j'}(\bar X)) \subseteq X_{D_{j'}}) \implies (H,\ v,\ \ell) \in X_{D_j}
\end{aligned}
```

The canonical terms of an instance of a codata type are its corecursors, and a corecursor is related to an address when the relation $`S`$ of the destructors of the type relates its observations $`\mathsf{obs}(v)`$ to it:

```math
\begin{aligned}
& = &&(\circledR_d) \\
& \quad \circledR_d(D_j,\ S) \\
& \quad \{(H,\ v,\ \ell) \mid v \text{ is a corecursor of an instance of } D_j \text{ and } (H,\ \mathsf{obs}(v),\ \ell) \in S\}
\end{aligned}
```

The relations of the instances of the types of a block of codata types are the greatest family of relations consistent with $`(\circledR_d)`$, given the relation $`S_{j'}(\bar X)`$ of the destructors of each type $`D_{j'}`$ that relates the results of its recursive destructors of the type $`D`$ by $`X_D`$, so that a term and a value are related as far as they are observed:

```math
\begin{aligned}
& \text{⟺} &&(\circledR_\nu) \\
& \quad (H,\ v,\ \ell) \in \circledR_\nu(D_j,\ \bar S) \\
& \quad \exists \bar X.\ (\forall j'.\ X_{D_{j'}} \subseteq \circledR_d(D_{j'},\ S_{j'}(\bar X))) \text{ and } (H,\ v,\ \ell) \in X_{D_j}
\end{aligned}
```

A closed abstraction $`f`$ for the destructor of the case $`i`$, whose arguments have the relation $`S_\Theta`$ and whose result type has the relation $`F(\bar t)`$ at the arguments $`\bar t`$, is related to the value at the address $`\ell`$ when, in each heap that extends $`H`$, its observation at arguments that $`S_\Theta`$ relates to addresses gives a value that $`F`$ relates to the result of $`f`$; the heap of the observation extends $`H`$, since the arguments may be computed after the value at $`\ell`$:

```math
\begin{aligned}
& \text{⟺} &&(\circledR_{\bar x}) \\
& \quad (H,\ f,\ \ell) \in \circledR_{\bar x}(i,\ S_\Theta,\ F) \\
& \quad \forall H' \sqsupseteq H.\ \forall (H',\ \bar t,\ \bar\ell) \in S_\Theta.\ \exists \ell',\ H''. \\
& \qquad \text{and} \\
& \qquad \quad \mathcal{P};\ H' \vdash \ell.d_i(\bar\ell) \Downarrow \ell';\ H'' \\
& \qquad \quad (H'',\ f[\bar t / \bar x],\ \ell') \in F(\bar t)
\end{aligned}
```

### Graph of the Relations of Run Time

The graph $`\mathsf{rt}(U_n)`$ relates each type $`v`$ of the universe $`U_n`$ to its relation of run time $`R`$, written $`{(v,\ R) \in \mathsf{rt}(U_n)}`$; the propositions have no graph of their own, since their terms are related to every address.
A universe relates every term to every address, since its terms, types, are erased:

```math
\begin{aligned}
& (U_l,\ \{(H,\ t,\ \ell) \mid t \text{ is a closed term}\}) \in \mathsf{rt}(U_n) \text{ if } [\![l]\!] + 1 = n &&(\mathsf{rt}_U) \\[1em]
& (\Omega_l,\ \{(H,\ t,\ \ell) \mid t \text{ is a closed term}\}) \in \mathsf{rt}(U_n) \text{ if } [\![l]\!] + 1 = n &&(\mathsf{rt}_\Omega)
\end{aligned}
```

The type of a field, or of the result of a destructor, has the relation of the graph of a universe that $`U_n`$ bounds, or relates every term to every address when it is a proposition:

```math
\begin{aligned}
& (v,\ \circledR_\Downarrow(R)) \in \mathsf{rt}_\Downarrow(U_n) \text{ if } (v,\ R) \in \mathsf{rt}(U_m) \text{ with } m \le n &&(\mathsf{rt}_\Downarrow) \\
& (v,\ \{(H,\ t,\ \ell) \mid t \text{ is a closed term}\}) \in \mathsf{rt}_\Downarrow(U_n) \text{ if } (v,\ b) \in \mathsf{ty}(\Omega_m) \text{ with } m \le n
\end{aligned}
```

An instance of a data type in a universe has the relation $`(\circledR_\mu)`$ when the fields of the constructors of the types of its block, at its instance and its arguments, are telescopes of run time in $`U_n`$, with the relations $`\bar S(\bar X)`$, whatever the relations $`\bar X`$ of the recursive fields, which take the relation $`{\circledR_\Downarrow(X_D)}`$ at the positions $`\mathsf{rec}_{\mathcal{D}}(\Theta_{j'i})`$ of the recursive fields of the type $`D`$; an instance of a codata type has the relation $`(\circledR_\nu)`$ when the destructors of the types of its block are of run time in $`U_n`$, likewise:

```math
\begin{aligned}
& (T,\ \circledR_\mu(D_j,\ \bar S)) \in \mathsf{rt}(U_n) \text{ if} &&(\mathsf{rt}_D) \\
& \quad \text{and} \\
& \qquad T = D_j.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a \text{ is a closed instance of a data type of a block } \mathcal{D} \text{ of } \Sigma \\
& \qquad \kappa[T] = U_l \text{ and } [\![l]\!] = n \\
& \qquad \forall \bar X.\ \forall j', i.\ (\Theta_{j'i}[T],\ S_{j'i}(\bar X)) \in \mathsf{rt}(U_n)[\mathsf{rec}_{\mathcal{D}}(\Theta_{j'i}) \mapsto \circledR_\Downarrow(X_D)] \\[1em]
& (T,\ \circledR_\nu(D_j,\ \bar S)) \in \mathsf{rt}(U_n) \text{ if} &&(\mathsf{rt}_d) \\
& \quad \text{and} \\
& \qquad T = D_j.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a \text{ is a closed instance of a codata type of a block } \mathcal{D} \text{ of } \Sigma \\
& \qquad \kappa[T] = U_l \text{ and } [\![l]\!] = n \\
& \qquad \forall \bar X.\ \forall j'.\ (\bar d_{j'}[T],\ S_{j'}(\bar X)) \in \mathsf{rt}_{D_{j'}}(U_n)[\mathsf{rec}_{\mathcal{D}}(\bar d_{j'}) \mapsto \circledR_\Downarrow(X_D)]
\end{aligned}
```

The graph $`\mathsf{rt}(U_n)[\bar R]`$ of the telescopes relates a closed telescope $`\Theta`$ to the relation $`S`$ of the terms of its fields to the addresses of their values, written $`{(\Theta,\ S) \in \mathsf{rt}(U_n)[\bar R]}`$, where $`\bar R`$ gives a relation $`R`$ at the position of each recursive field, and $`\bot`$ at the others.
A first type that is not a recursive field computes to a type whose terms have the equality $`F`$ in the meaning and the relation $`R`$ at run time: the first term is one that the meaning gives to it, related by $`R^p`$ at the grade $`p`$ of the entry, and the rest is a telescope of run time for each term that the meaning gives to it, on which it depends even when the entry is erased.
A first type that is a recursive field has the relation $`R`$ that $`\bar R`$ gives it, at the grade of the entry, and the rest is the same for every term of it:

```math
\begin{aligned}
& (\varepsilon,\ \{(H,\ (),\ ())\}) \in \mathsf{rt}(U_n)[\bar R] &&(\mathsf{rt}_{\Theta\varepsilon}) \\[1em]
& \in \text{ if} &&(\mathsf{rt}_{\Theta,}) \\
& \quad ((x : A \mathrel{▶} p;\ q \mathrel{◀} r,\ \Theta),\ \{(H,\ (a,\ \bar t),\ (\ell,\ \bar\ell)) \mid (a,\ a) \in F,\ (H,\ a,\ \ell) \in R^p \text{ and } (H,\ \bar t,\ \bar\ell) \in G(a)\}) \\
& \quad \mathsf{rt}(U_n)[\bot,\ \bar R] \\
& \quad \text{and} \\
& \qquad \exists v,\ \kappa_1.\ A \Downarrow v,\ \kappa_1 \preceq U_n,\ (v,\ F) \in \mathsf{ty}_\Downarrow(\kappa_1) \text{ and } (v,\ R) \in \mathsf{rt}_\Downarrow(U_n) \\
& \qquad \forall (a,\ a) \in F.\ (\Theta[a / x],\ G(a)) \in \mathsf{rt}(U_n)[\bar R] \\[1em]
& \in \text{ if} &&(\mathsf{rt}_{\Theta\mathsf{rec}}) \\
& \quad ((x : A \mathrel{▶} p;\ q \mathrel{◀} r,\ \Theta),\ \{(H,\ (a,\ \bar t),\ (\ell,\ \bar\ell)) \mid (H,\ a,\ \ell) \in R^p \text{ and } (H,\ \bar t,\ \bar\ell) \in G\}) \\
& \quad \mathsf{rt}(U_n)[R,\ \bar R] \\
& \quad \text{and} \\
& \qquad \forall a.\ (\Theta[a / x],\ G) \in \mathsf{rt}(U_n)[\bar R]
\end{aligned}
```

The graph $`\mathsf{rt}_D(U_n)[\bar R]`$ of the destructors of the type $`D`$ relates closed destructors $`\bar d`$ to the relation $`S`$ of the families $`\bar f`$ of closed abstractions for them to the addresses of values, written $`{(\bar d,\ S) \in \mathsf{rt}_D(U_n)[\bar R]}`$, where $`\bar R`$ gives a relation $`R`$ at the position of each recursive destructor, and $`\bot`$ at the others.
The arguments of the first destructor are a telescope in $`U_n`$, with the equality $`S_\Theta`$, and of run time, with the relation $`R_\Theta`$.
If the destructor is not recursive, its result type computes at the arguments that the meaning gives, to types with the equality $`F(\bar t)`$ and the relation of run time $`R(\bar t)`$: its abstraction is one that the meaning gives to it, related by $`(\circledR_{\bar x})`$ at its case when its grade $`p`$ has a use at run time, and the destructors after it are of run time for each abstraction that the meaning gives to it.
If it is recursive, its results have the relation $`R`$ that $`\bar R`$ gives it, and the destructors after it are the same for every abstraction for it:

```math
\begin{aligned}
& (\varepsilon,\ \{(H,\ \bar f,\ \ell) \mid \bar f \text{ is a family of closed abstractions}\}) \in \mathsf{rt}_D(U_n)[\bar R] &&(\mathsf{rt}_{\bar d\varepsilon}) \\[1em]
& \in \text{ if} &&(\mathsf{rt}_{\bar d|}) \\
& \quad ((d : (\Theta \vdash B \mathrel{◀} \psi) \mathrel{▶} p;\ q \mid \bar d),\ \{(H,\ \bar f,\ \ell) \mid (f_d,\ f_d) \in E,\ (p \notin S^{{11}^{\mathsf{m}}} \implies (H,\ f_d,\ \ell) \in \circledR_{\bar x}(i,\ R_\Theta,\ R)) \text{ and } (H,\ \bar f,\ \ell) \in G(f_d)\}) \\
& \quad \mathsf{rt}_D(U_n)[\bot,\ \bar R] \\
& \quad \text{and} \\
& \qquad i = \mathsf{case}_\Sigma(D.d) \\
& \qquad (\Theta,\ S_\Theta) \in \mathsf{ty}(U_n) \\
& \qquad (\Theta,\ R_\Theta) \in \mathsf{rt}(U_n) \\
& \qquad \forall (\bar t,\ \bar t) \in S_\Theta.\ \exists v.\ B[\bar t / \bar x] \Downarrow v \\
& \qquad \forall (\bar t,\ \bar t) \in S_\Theta.\ \forall v.\ B[\bar t / \bar x] \Downarrow v \implies \exists \kappa_1 \preceq U_n.\ (v,\ F(\bar t)) \in \mathsf{ty}_\Downarrow(\kappa_1) \\
& \qquad \forall (\bar t,\ \bar t) \in S_\Theta.\ \forall v.\ B[\bar t / \bar x] \Downarrow v \implies (v,\ R(\bar t)) \in \mathsf{rt}_\Downarrow(U_n) \\
& \qquad E = \{(f_1,\ f_2) \mid \forall (\bar t,\ \bar u) \in S_\Theta.\ (f_1[\bar t / \bar x],\ f_2[\bar u / \bar x]) \in F(\bar t)\} \\
& \qquad \forall (f,\ f) \in E.\ (\bar d[f / d],\ G(f)) \in \mathsf{rt}_D(U_n)[\bar R] \\[1em]
& \in \text{ if} &&(\mathsf{rt}_{\bar d\mathsf{rec}}) \\
& \quad ((d : (\Theta \vdash B \mathrel{◀} \psi) \mathrel{▶} p;\ q \mid \bar d),\ \{(H,\ \bar f,\ \ell) \mid (p \notin S^{{11}^{\mathsf{m}}} \implies (H,\ f_d,\ \ell) \in \circledR_{\bar x}(i,\ R_\Theta,\ \bar t \mapsto R)) \text{ and } (H,\ \bar f,\ \ell) \in G\}) \\
& \quad \mathsf{rt}_D(U_n)[R,\ \bar R] \\
& \quad \text{and} \\
& \qquad i = \mathsf{case}_\Sigma(D.d) \\
& \qquad (\Theta,\ R_\Theta) \in \mathsf{rt}(U_n) \\
& \qquad \forall f.\ (\bar d[f / d],\ G) \in \mathsf{rt}_D(U_n)[\bar R]
\end{aligned}
```

At each level $`n`$, the relations $`\mathsf{rt}(U_n)`$, $`\mathsf{rt}(U_n)[\bar R]`$ and $`\mathsf{rt}_D(U_n)[\bar R]`$ are the least relations with these clauses, given the relations of the levels below $`n`$, as those of the meaning are.

A closed canonical type has the relation of run time that a universe gives it, and a proposition relates every term to every address; a closed term is related to an address at a closed type when the type computes to a type or a proposition whose relation relates the term to the address:

```math
\begin{aligned}
& \circledR(v) = R \text{ if } (v,\ R) \in \mathsf{rt}(U_n) &&(\circledR_{\mathsf{type}}) \\[1em]
& \circledR(v) = \{(H,\ t,\ \ell) \mid t \text{ is a closed term}\} \text{ if } (v,\ b) \in \mathsf{ty}(\Omega_n) &&(\circledR_{\mathsf{prop}}) \\[1em]
& t \circledR_H \ell : A \iff \exists v.\ A \Downarrow v \text{ and } (H,\ t,\ \ell) \in \circledR_\Downarrow(\circledR(v)) &&(\circledR_A)
\end{aligned}
```

## Properties

The extension of the heaps keeps the values, and the evaluation extends the heap:

```math
\begin{aligned}
& \text{⟹} &&(\sqsubseteq_H.\mathsf{get}) \\
& \quad \text{and} \\
& \qquad H \sqsubseteq H' \\
& \qquad H(\ell) = V \\
& \quad H'(\ell) = V \\[1em]
& \text{⟹} &&(\mathsf{ext}_\Downarrow) \\
& \quad \mathcal{P};\ H;\ E \vdash M \Downarrow \ell;\ H' \\
& \quad H \sqsubseteq H'
\end{aligned}
```
