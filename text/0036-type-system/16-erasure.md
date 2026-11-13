# Erasure

This annex defines the erasure, which compiles a term to an untyped target language by replacing with $`\text{↯}`$ the parts whose grade is in a set of grades, the usage of the target language, and their properties.
It builds on the [grades](04-grades.md), the [modes](05-modes.md), the [syntax](08-syntax.md), the [vectors of multiplicities](10-grade-vectors.md#vectors-of-multiplicities), the [sets of grades](11-grade-sets.md), the [usage](12-usage.md) and the fields of a block, which the [typing](14-typing.md#fields-of-a-block) marks.

## Definitions

The target language has variables, all of the first order, the constants at the qualities and the grades of their instances, a value $`\text{↯}`$ that stands for what was erased, the constructors, by their case in their block, applied to terms for their fields, the recursors, at a multiplicity, with a branch for each constructor, the observations by a destructor, by its case in its block, applied to terms for its arguments, and the corecursors, with a state and a branch for each destructor, each term of the fields, of the arguments and of the state at a multiplicity:

```math
\begin{aligned}
& M \mathrel{::=} x \mid f.\{\bar s;\ \bar p\} \mid \text{↯} \mid c_i(\bar M) \mid \mathsf{rec}_\rho\ M\ \mathsf{with}\ \bar N \mid M.d_i(\bar M) \mid \mathsf{corec}\ \mathsf{from}\ \bar M\ \mathsf{with}\ \bar P &&(\mathsf{syntax}_M) \\[1em]
& \bar M \mathrel{::=} () \mid (M \mathrel{▶} \pi,\ \bar M) &&(\mathsf{syntax}_{\bar M}) \\[1em]
& \bar N \mathrel{::=} () \mid ((\bar x \mathrel{▶} \bar\pi;\ \bar y \mathrel{▶} \bar\pi' \leftarrow \bar k).\, N,\ \bar N) &&(\mathsf{syntax}_{\bar N}) \\[1em]
& \bar P \mathrel{::=} () \mid ((\bar y \mathrel{▶} \bar\pi;\ \bar z \mathrel{▶} \bar\pi' \circlearrowleft k).\, P,\ \bar P) &&(\mathsf{syntax}_{\bar P}) \\[1em]
& k \mathrel{::=} \bot \mid n \mid \text{↯}_n &&(\mathsf{syntax}_k)
\end{aligned}
```

A branch $`{(\bar x \mathrel{▶} \bar\pi;\ \bar y \mathrel{▶} \bar\pi' \leftarrow \bar k).\, N}`$ binds the variables $`\bar x`$ of the fields and $`\bar y`$ of the recursive results, as a branch of a recursor does, at the [multiplicities](03-multiplicities.md) $`\bar\pi`$ and $`\bar\pi'`$, which count their uses at run time, and $`\bar k`$ gives each recursive result the position of its field among $`\bar x`$, the first one at $`1`$, or $`\bot`$ when the result is erased, so that it is not computed.
A branch $`{(\bar y \mathrel{▶} \bar\pi;\ \bar z \mathrel{▶} \bar\pi' \circlearrowleft k).\, P}`$ binds the variables $`\bar y`$ of the state and $`\bar z`$ of the arguments, as a branch of a corecursor does, at the multiplicities $`\bar\pi`$ and $`\bar\pi'`$, and $`k`$ is its resumption: $`\bot`$ when its destructor is not recursive, the number $`n`$ of the entries of the state that the branch resumes, which the evaluation unpacks from the new state, or $`\text{↯}_n`$ when these $`n`$ entries are erased, so that the evaluation does not read the new state.
A term $`{M \mathrel{▶} \pi}`$ of a field, of an argument or of the state is stored at the multiplicity $`\pi`$ of its position, which bounds the uses of its value through this position, and a recursor $`{\mathsf{rec}_\rho\ M\ \mathsf{with}\ \bar N}`$ uses the value of $`M`$ at the multiplicity $`\rho`$, so that a branch reads each field within $`\rho`$ times its multiplicity: a value is computed once, but a cell of the multiplicity $`\omega`$ may read it several times, and each observation of a closure runs a branch again, which the multiplicities of the positions bound.
The multiplicities $`\bar\pi(\bar M)`$ of terms are those at which they are stored, in order:

```math
\begin{aligned}
& \bar\pi(()) = () &&(\mathsf{multiplicities}_{\bar M}) \\
& \bar\pi((M \mathrel{▶} \pi,\ \bar M)) = (\pi,\ \bar\pi(\bar M))
\end{aligned}
```

The target language keeps only what its [evaluation](17-evaluation.md) reads: the multiplicity of a binder goes with each variable that the evaluation binds, the multiplicity of a position with each value that the evaluation stores, a case chooses a branch, since the names of the constructors and of the destructors are distinct only in their type, and a branch does not bind the non-uniform parameters, which the corecursors do not have yet.

The erasure $`\lfloor t \rfloor_S`$ of a term $`t`$ replaces with $`\text{↯}`$ each position of $`t`$ whose grade is in the set $`S`$, a position being a subterm that a rule of usage checks with a grade of its own, as an argument $`t_j`$ of an entry of grade $`p_j`$ in $`{(\mathsf{tel}_{,▶})}`$.
It is defined on the terms whose scope has no second-order variable: a program is closed, and the motives and the branches of a recursor and the states and the branches of a corecursor bind variables only, while a second-order variable exists only in the contexts in which a declaration is checked, so that a variable has no arguments, and the target language no second-order variables.
It is defined in a signature $`\Sigma`$, which gives the grades of the fields of the constructors, of the arguments of the destructors and of the destructors, and the positions of the codata types in their blocks, and which the notation leaves implicit, as the rules of usage read their grades in the signature.

The grades $`\mathsf{grades}_\Sigma(T.c)`$ of the fields of the constructor $`c`$ of an instance $`{T = D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a}`$ are the grades of its telescope $`\Theta`$ at the instance $`\bar s`$, $`\bar p`$, in the last entry of $`\Sigma`$ that declares a type $`D`$ with a constructor $`c`$ and as many sort and grade variables as $`\bar s`$ and $`\bar p`$, and none when $`\Sigma`$ has no such entry:

```math
\begin{aligned}
& \mathsf{grades}_\Sigma(T.c) = \text{the grades of } \Theta \text{ if } (\mathsf{data}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa\ \mathsf{where}\ \dots;\ D \mathrel{▶} \zeta \mathrel{≔} \dots \mid c : \Theta \mid \dots;\ \dots) \text{ is this entry} &&(\mathsf{grades}_c) \\
& \mathsf{grades}_\Sigma(T.c) = () \text{ if } \Sigma \text{ has no such entry}
\end{aligned}
```

The grades $`\mathsf{grades}_\Sigma(T.d)`$ of the arguments of the destructor $`d`$ of an instance $`{T = D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a}`$ are the grades of its telescope $`\Theta`$ at the instance $`\bar s`$, $`\bar p`$, in the last entry of $`\Sigma`$ that declares a type $`D`$ with a destructor $`d`$ and as many sort and grade variables as $`\bar s`$ and $`\bar p`$, and none when $`\Sigma`$ has no such entry:

```math
\begin{aligned}
& \mathsf{grades}_\Sigma(T.d) = \text{the grades of } \Theta \text{ if } (\mathsf{codata}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa\ \mathsf{where}\ \dots;\ D \mathrel{▶} \zeta \mathrel{≔} \dots \mid d : (\Theta \vdash B \mathrel{◀} \psi) \mathrel{▶} p;\ q \mid \dots;\ \dots) \text{ is this entry} &&(\mathsf{grades}_d) \\
& \mathsf{grades}_\Sigma(T.d) = () \text{ if } \Sigma \text{ has no such entry}
\end{aligned}
```

The grades $`\mathsf{grades}_\Sigma(T.\bar g)`$ of the branches of a corecursor of an instance $`{T = D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a}`$ are the grades of the destructors of the block of $`D`$ at the instance $`\bar s`$, $`\bar p`$, in the order of the declaration, which is that of the branches, in the last entry of $`\Sigma`$ that declares a type $`D`$ and as many sort and grade variables as $`\bar s`$ and $`\bar p`$, and none when $`\Sigma`$ has no such entry:

```math
\begin{aligned}
& \mathsf{grades}_\Sigma(T.\bar g) = p_{11}, \dots, p_{kn_k} \text{ if } (\mathsf{codata}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} \bar d_1;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \bar d_k) \text{ is this entry, } D = D_h \text{ and } d_{ji} : (\Theta_{ji} \vdash B_{ji} \mathrel{◀} \psi_{ji}) \mathrel{▶} p_{ji};\ q_{ji} \text{ in } \bar d_j &&(\mathsf{grades}_{\bar g}) \\
& \mathsf{grades}_\Sigma(T.\bar g) = () \text{ if } \Sigma \text{ has no such entry}
\end{aligned}
```

The position $`\mathsf{position}_\Sigma(D)`$ of the declared type $`D`$ is its index $`h`$ in the last entry of $`\Sigma`$ that declares it, $`{D_1 \mathrel{▶} \zeta_1 \mathrel{≔} \dots;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \dots}`$ with $`{D = D_h}`$, and none when $`\Sigma`$ has no such entry:

```math
\begin{aligned}
& \mathsf{position}_\Sigma(D) = h \text{ if } D = D_h \text{ in this entry} &&(\mathsf{position}_D)
\end{aligned}
```

The case $`\mathsf{case}_\Sigma(D.c)`$ of the constructor $`c`$ of the type $`D`$ is its position $`i`$ among the constructors of the types of its block, in the order of the declaration, which is that of the branches of a recursor, in the last entry of $`\Sigma`$ that declares a type $`D`$ with a constructor $`c`$, and none when $`\Sigma`$ has no such entry; the case $`\mathsf{case}_\Sigma(D.d)`$ of a destructor is its position among the destructors of the types of its block, likewise:

```math
\begin{aligned}
& \mathsf{case}_\Sigma(D.c) = i \text{ if } c_i \text{ is the constructor } c \text{ of } D \text{ in } (\mathsf{data}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} c_1 : \Theta_1 \mid \dots;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \dots \mid c_n : \Theta_n) &&(\mathsf{case}_c) \\[1em]
& \mathsf{case}_\Sigma(D.d) = i \text{ if } d_i \text{ is the destructor } d \text{ of } D \text{ in } (\mathsf{codata}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} d_1 : \dots \mid \dots;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \dots \mid d_n : \dots) &&(\mathsf{case}_d)
\end{aligned}
```

The recursive fields $`\mathsf{recursive}_\Sigma(T)`$ of an instance $`{T = D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a}`$ give, for each constructor of the block of $`D`$, in the order of the declaration, the positions of its fields whose types are instances of a type of the block, which [$`\mathsf{rec}_{\mathcal{D}}(\Theta)`$](14-typing.md#fields-of-a-block) marks, at the instance $`\bar s`$, $`\bar p`$, in the last entry of $`\Sigma`$ that declares a type $`D`$ and as many sort and grade variables as $`\bar s`$ and $`\bar p`$, and none when $`\Sigma`$ has no such entry:

```math
\begin{aligned}
& \mathsf{recursive}_\Sigma(T) = \bar k_1, \dots, \bar k_n \text{ if } c_1 : \Theta_1,\ \dots,\ c_n : \Theta_n \text{ are the constructors of this entry and } \bar k_i \text{ the positions } j \text{ at which } \mathsf{rec}_{\mathcal{D}}(\Theta_i) \ne \bot &&(\mathsf{recursive}_c) \\
& \mathsf{recursive}_\Sigma(T) = () \text{ if } \Sigma \text{ has no such entry}
\end{aligned}
```

The resumed types $`\mathsf{resumed}_\Sigma(T)`$ of an instance $`{T = D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a}`$ give, for each destructor of the block of $`D`$, in the order of the declaration, the position in the block of the type of its result, when it is recursive, or $`\bot`$, at the instance $`\bar s`$, $`\bar p`$, in the last entry of $`\Sigma`$ that declares a type $`D`$ and as many sort and grade variables as $`\bar s`$ and $`\bar p`$, and none when $`\Sigma`$ has no such entry:

```math
\begin{aligned}
& \mathsf{resumed}_\Sigma(T) = h_1, \dots, h_n \text{ if } d_1 : (\Theta_1 \vdash B_1 \mathrel{◀} \psi_1),\ \dots,\ d_n : (\Theta_n \vdash B_n \mathrel{◀} \psi_n) \text{ are the destructors of this entry and } h_i \text{ is the position of } \mathsf{rec}_{\mathcal{D}}(B_i) \text{ in the block, or } \bot \text{ when } \mathsf{rec}_{\mathcal{D}}(B_i) = \bot &&(\mathsf{resumed}_d) \\
& \mathsf{resumed}_\Sigma(T) = () \text{ if } \Sigma \text{ has no such entry}
\end{aligned}
```

The grades $`\mathsf{grades}_\Sigma(T.\bar u)`$ of the branches of a recursor of an instance $`{T = D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a}`$ give, for each constructor of the block of $`D`$, in the order of the declaration, the grades of the entries of its telescope, at the instance $`\bar s`$, $`\bar p`$, in the last entry of $`\Sigma`$ that declares a type $`D`$ and as many sort and grade variables as $`\bar s`$ and $`\bar p`$, and none when $`\Sigma`$ has no such entry:

```math
\begin{aligned}
& \mathsf{grades}_\Sigma(T.\bar u) = \bar q_1, \dots, \bar q_n \text{ if } c_1 : \Theta_1,\ \dots,\ c_n : \Theta_n \text{ are the constructors of this entry and } \bar q_i \text{ the grades of } \Theta_i &&(\mathsf{grades}_{\bar u}) \\
& \mathsf{grades}_\Sigma(T.\bar u) = () \text{ if } \Sigma \text{ has no such entry}
\end{aligned}
```

The arguments $`\mathsf{arguments}_\Sigma(T.\bar g)`$ of the branches of a corecursor of an instance $`{T = D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a}`$ give, for each destructor of the block of $`D`$, in the order of the declaration, the position $`j`$ in the block of its type $`D_j`$, whose state the branch binds, and the grades of the entries of its telescope, at the instance $`\bar s`$, $`\bar p`$, in the last entry of $`\Sigma`$ that declares a type $`D`$ and as many sort and grade variables as $`\bar s`$ and $`\bar p`$, and none when $`\Sigma`$ has no such entry:

```math
\begin{aligned}
& \mathsf{arguments}_\Sigma(T.\bar g) = (j_1,\ \bar q_1), \dots, (j_n,\ \bar q_n) \text{ if } d_1 : (\Theta_1 \vdash B_1 \mathrel{◀} \psi_1),\ \dots,\ d_n : (\Theta_n \vdash B_n \mathrel{◀} \psi_n) \text{ are the destructors of this entry, } d_i \text{ a destructor of } D_{j_i} \text{ and } \bar q_i \text{ the grades of } \Theta_i &&(\mathsf{arguments}_{\bar g}) \\
& \mathsf{arguments}_\Sigma(T.\bar g) = () \text{ if } \Sigma \text{ has no such entry}
\end{aligned}
```

The skeleton $`\mathsf{skeleton}_\Sigma(T)`$ of an instance $`{T = D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a}`$ is the term of the target language that the type $`D`$ gives to its closed terms when each type of its block has one constructor at most: the constructor of the case of the only constructor of $`D`$, applied to $`\text{↯}`$ for each field that is not recursive and to the skeleton of the type of each recursive field, each at the multiplicity $`0`$, since a skeleton holds no value that a use at run time reads, and $`\text{↯}`$ when $`D`$ has no constructor or several.
It is built within the depth $`k`$ of the number of the types of the block, at the instance $`\bar s`$, $`\bar p`$, in the last entry of $`\Sigma`$ that declares a type $`D`$ and as many sort and grade variables as $`\bar s`$ and $`\bar p`$, and is $`\text{↯}`$ when $`\Sigma`$ has no such entry:

```math
\begin{aligned}
& \mathsf{skeleton}_\Sigma(T) = \mathsf{skeleton}^k(D) \text{ if } (\mathsf{data}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} \bar c_1;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \bar c_k) \text{ is this entry} &&(\mathsf{skeleton}_D) \\
& \mathsf{skeleton}_\Sigma(T) = \text{↯} \text{ if } \Sigma \text{ has no such entry} \\[1em]
& \mathsf{skeleton}^0(D_j) = \text{↯} \\
& \mathsf{skeleton}^{n + 1}(D_j) = c_i(M_1 \mathrel{▶} 0, \dots, M_a \mathrel{▶} 0) \text{ if } \bar c_j = (c : \Theta),\ i = \mathsf{case}_\Sigma(D_j.c) \text{ and } \Theta \text{ has } a \text{ entries} \\
& \mathsf{skeleton}^{n + 1}(D_j) = \text{↯} \text{ otherwise}
\end{aligned}
```

In the skeleton of a constructor $`{c : \Theta}`$, $`M_l`$ is $`\mathsf{skeleton}^n(D')`$ when the element $`l`$ of [$`\mathsf{rec}_{\mathcal{D}}(\Theta)`$](14-typing.md#fields-of-a-block) is a type $`D'`$ of the block, and $`\text{↯}`$ when it is $`\bot`$.
The depth is reached only on a type without closed term: along a path of a closed term, from a term to the term of one of its recursive fields, no type of the block comes twice, since each type has one constructor, so that the term would hold a term of the same form, without end.

The sorts and the instances have no representation in the target language, and are erased.
A constructor keeps its case and its fields, each erased at the grade of its field and stored at the multiplicity at run time of this grade, and a field whose grade the signature does not give, in a term that no rule types, is erased, and stored at $`\omega`$, which states nothing, as a constructor whose case it does not give is erased; a recursor keeps the multiplicity at run time of its grade $`r`$, its term when $`r`$ is not in $`S`$, and the skeleton of the type of its term otherwise, and its branches, which keep, for each recursive result, the position of its field, or $`\bot`$ when its grade is in $`S`$, and loses its instance and its motives, which are types.
An observation keeps its term, the case of its destructor and its arguments, each erased at the grade of its argument and stored at its multiplicity at run time, and a corecursor keeps its state, each entry erased at its grade times the grade $`r`$ of the corecursor and stored at its multiplicity at run time, since every observation that reaches the state uses it $`r`$ times, and its branches, each erased at the grade of its destructor, since its usage checks it in the mode of this grade, with the number of the entries of the state it resumes, and loses its instance and its states, which are types; the grades of the entries of the state are those of the state $`\Theta_h`$ of the type $`D_h`$ of its instance, with $`{h = \mathsf{position}_\Sigma(D)}`$, and an entry whose grade is not given, in a term that no rule types, is erased.
The erasure $`{\lfloor t \rfloor_{S, p}}`$ of a position of grade $`p`$ is $`\text{↯}`$ when $`{p \in S}`$, and $`\lfloor t \rfloor_S`$ otherwise, and the erasure of terms stores each at the multiplicity $`\mathsf{run}(p)`$ of its grade:

```math
\begin{aligned}
& \lfloor x \rfloor_S = x &&(\mathsf{erase}_t) \\
& \lfloor \kappa \rfloor_S = \text{↯} \\
& \lfloor f.\{\bar s;\ \bar l;\ \bar p\} \rfloor_S = f.\{\bar s;\ \bar p\} \\
& \lfloor D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a \rfloor_S = \text{↯} \\
& \lfloor T.c(\bar t) \rfloor_S = c_i(\lfloor \bar t \rfloor_{S, \mathsf{grades}_\Sigma(T.c)}) \text{ if } i = \mathsf{case}_\Sigma(D.c) \\
& \lfloor T.c(\bar t) \rfloor_S = \text{↯} \text{ otherwise} \\
& \lfloor \mathsf{rec}_r\ T\ t\ \mathsf{return}\ \bar C\ \mathsf{with}\ \bar u \rfloor_S = \mathsf{rec}_{\mathsf{run}(r)}\ \mathsf{skeleton}_\Sigma(T)\ \mathsf{with}\ \lfloor \bar u \rfloor_{S, r, \mathsf{recursive}_\Sigma(T), \mathsf{grades}_\Sigma(T.\bar u)} \text{ if } r \in S \\
& \lfloor \mathsf{rec}_r\ T\ t\ \mathsf{return}\ \bar C\ \mathsf{with}\ \bar u \rfloor_S = \mathsf{rec}_{\mathsf{run}(r)}\ \lfloor t \rfloor_S\ \mathsf{with}\ \lfloor \bar u \rfloor_{S, r, \mathsf{recursive}_\Sigma(T), \mathsf{grades}_\Sigma(T.\bar u)} \text{ if } r \notin S \\
& \lfloor t.(T.d)(\bar t) \rfloor_S = \lfloor t \rfloor_S.d_i(\lfloor \bar t \rfloor_{S, \mathsf{grades}_\Sigma(T.d)}) \text{ if } i = \mathsf{case}_\Sigma(D.d) \\
& \lfloor t.(T.d)(\bar t) \rfloor_S = \text{↯} \text{ otherwise} \\
& \lfloor \mathsf{corec}_r\ T\ \mathsf{from}\ \bar t\ \mathsf{return}\ \bar\Theta\ \mathsf{with}\ \bar g \rfloor_S = \mathsf{corec}\ \mathsf{from}\ \lfloor \bar t \rfloor_{S, r \cdot \bar q}\ \mathsf{with}\ \lfloor \bar g \rfloor_{S, \mathsf{grades}_\Sigma(T.\bar g), \bar k, \bar{\bar o}} \text{ if } \bar q \text{ are the grades of } \Theta_h,\ h = \mathsf{position}_\Sigma(D) \\
& \lfloor \mathsf{corec}_r\ T\ \mathsf{from}\ \bar t\ \mathsf{return}\ \bar\Theta\ \mathsf{with}\ \bar g \rfloor_S = \mathsf{corec}\ \mathsf{from}\ \lfloor \bar t \rfloor_{S, ()}\ \mathsf{with}\ \lfloor \bar g \rfloor_{S, \mathsf{grades}_\Sigma(T.\bar g), \bar k, \bar{\bar o}} \text{ otherwise} \\
& \lfloor t \rfloor_{S, p} = \text{↯} \text{ if } p \in S \\
& \lfloor t \rfloor_{S, p} = \lfloor t \rfloor_S \text{ if } p \notin S \\[1em]
& \lfloor () \rfloor_{S, \bar p} = () &&(\mathsf{erase}_{\bar t}) \\
& \lfloor (t,\ \bar t) \rfloor_{S, ()} = (\text{↯} \mathrel{▶} \omega,\ \lfloor \bar t \rfloor_{S, ()}) \\
& \lfloor (t,\ \bar t) \rfloor_{S, (p,\ \bar p)} = (\lfloor t \rfloor_{S, p} \mathrel{▶} \mathsf{run}(p),\ \lfloor \bar t \rfloor_{S, \bar p}) \\[1em]
& \lfloor () \rfloor_{S, r, \bar{\bar k}, \bar{\bar q}} = () &&(\mathsf{erase}_{\bar u}) \\
& \lfloor ((\bar x;\ \bar y \mathrel{▶} \bar e).\, u,\ \bar u) \rfloor_{S, r, \bar{\bar k}, \bar{\bar q}} = ((\bar x \mathrel{▶} \bar\pi;\ \bar y \mathrel{▶} \mathsf{run}(\bar e) \leftarrow \bar k').\, \lfloor u \rfloor_S,\ \lfloor \bar u \rfloor_{S, r, \bar{\bar k}', \bar{\bar q}'}) \\[1em]
& \lfloor () \rfloor_{S, \bar p, \bar k, \bar{\bar o}} = () &&(\mathsf{erase}_{\bar g}) \\
& \lfloor ((\bar x;\ \bar y;\ \bar z).\, g,\ \bar g) \rfloor_{S, (p,\ \bar p), \bar k, \bar{\bar o}} = ((\bar y \mathrel{▶} \mathsf{run}(\ulcorner {11}^{\mathsf{m}} \odot p \urcorner \cdot \bar o_1);\ \bar z \mathrel{▶} \mathsf{run}(\ulcorner {11}^{\mathsf{m}} \odot p \urcorner \cdot \bar o_2) \circlearrowleft k).\, \lfloor g \rfloor_{S, p},\ \lfloor \bar g \rfloor_{S, \bar p, \bar k', \bar{\bar o}'}) \text{ if } \bar x \text{ is empty} \\
& \lfloor ((\bar x;\ \bar y;\ \bar z).\, g,\ \bar g) \rfloor_{S, \bar p, \bar k, \bar{\bar o}} = ((\bar y \mathrel{▶} \omega;\ \bar z \mathrel{▶} \omega \circlearrowleft k).\, \text{↯},\ \lfloor \bar g \rfloor_{S, \bar p', \bar k', \bar{\bar o}'}) \text{ otherwise}
\end{aligned}
```

In the erasure of a corecursor, $`{T = D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a}`$, $`{\bar\Theta = (\bar x_1.\, \Theta_1 : \bar\kappa_1,\ \dots,\ \bar x_n.\, \Theta_n : \bar\kappa_n)}`$, $`{r \cdot \bar q}`$ multiplies each grade of $`\bar q`$ by $`r`$ on the left, and $`\bar k`$ gives each element $`h`$ of $`\mathsf{resumed}_\Sigma(T)`$ the number $`n`$ of the entries of $`\Theta_h`$ when $`\bar x_h`$ is empty and $`{r \notin S}`$, $`\text{↯}_n`$ when $`\bar x_h`$ is empty and $`{r \in S}`$, since the new state, a field of the grade $`r`$ of a position, is then erased, as are its entries, of the grades $`r \cdot \bar q`$, and $`\bot`$ otherwise.
In the erasure of a corecursor, $`\bar{\bar o}`$ also gives each element $`(j,\ \bar q)`$ of $`\mathsf{arguments}_\Sigma(T.\bar g)`$ the grades of the variables of the branch of its destructor: $`r \cdot q'_l`$ for the entry $`l`$ of the state, whose grade is $`q'_l`$ in $`\Theta_j`$, and $`q_l`$ for its argument $`l`$; a branch of a destructor of grade $`p`$ gives each variable of grade $`o`$ the multiplicity $`\mathsf{run}(\ulcorner {11}^{\mathsf{m}} \odot p \urcorner \cdot o)`$, applied to each grade of $`\bar o_1`$ and $`\bar o_2`$, since the [usage](12-usage.md#definitions) checks the branch in the mode $`{11}^{\mathsf{m}} \odot p`$ and gives its variables these grades times $`\ulcorner {11}^{\mathsf{m}} \odot p \urcorner`$; this multiplicity is $`0`$ when $`p`$ has no use at run time, since no observation then runs the branch, and does not depend on $`S`$, which only decides the erasure of the term of the branch.
A double bar marks a sequence of sequences: in the erasure of the branches of a recursor, $`\bar k`$ is the first sequence of $`\bar{\bar k}`$, or $`()`$ when it has none, $`\bar q`$ the first sequence of $`\bar{\bar q}`$, or $`()`$ when it has none, $`\bar{\bar k}'`$ and $`\bar{\bar q}'`$ the others, and $`k'_j`$ is $`\bot`$ when $`{e_j \in S}`$, and the $`j`$-th element of $`\bar k`$ otherwise, or $`\bot`$ when it has none; in the erasure of the branches of a corecursor, $`k`$ is the first element of $`\bar k`$, or $`\bot`$ when it has none, $`(\bar o_1,\ \bar o_2)`$ the first element of $`\bar{\bar o}`$, or $`((),\ ())`$ when it has none, a variable whose grade is not given having the multiplicity $`\omega`$, as do the variables of a branch without grade, and $`\bar k'`$, $`\bar p'`$ and $`\bar{\bar o}'`$ are the others.
The variable of the field $`l`$ of a branch of a recursor has the uses at run time of the field that the recursor gives minus those of the recursion on it, with the [subtraction](03-multiplicities.md) of the multiplicities:

```math
\begin{aligned}
& \pi_l = \mathsf{run}(r \cdot q_l) - \mathsf{run}(e_j \cdot r) \text{ if } l \text{ is the } j\text{-th element of } \bar k &&(\mathsf{erase}_{\bar u}.\pi) \\
& \pi_l = \mathsf{run}(r \cdot q_l) \text{ if } l \text{ is not in } \bar k \\
& \pi_l = \omega \text{ if } \bar q \text{ has no element } l
\end{aligned}
```

The usage leaves the branch the choice of the grade $`g_l`$ of the field, under the bound $`{r \cdot q_l \le g_l + e_j \cdot r}`$, and $`\pi_l`$ is the least multiplicity that this bound allows $`\mathsf{run}(g_l)`$, its only value when $`\mathsf{run}(r \cdot q_l)`$ is $`1`$, so that the syntax need not carry the grades of the fields; a field without grade, in a term that no rule types, states nothing.
A branch of a corecursor with non-uniform parameters, which the corecursors do not have yet, has no variables for them in the target language, and is erased.

A recursor whose grade is in $`S`$ eliminates a term that the erasure removes, which the [usage](12-usage.md#definitions) allows in the mode $`{11}^{\mathsf{m}}`$ only on a block whose types have one constructor at most: the type of the term then gives its form, which the skeleton rebuilds, so that the recursor runs the branch of the only constructor, and computes the recursive results that the branch uses, as the erasure of the eliminations of the pairs and of the unit of [Abel, Danielsson and Eriksson](https://github.com/graded-type-theory/graded-type-theory/blob/1f720ee636cb16aec130cc1ddc1c32acea8809d0/Graded/Erasure/Extraction.agda#L119-L137) runs their branch, which has no recursive result, on erased fields.

A constant keeps the qualities and the grades of its instance and loses its levels: the positions of its body that the erasure removes depend on the grades of the fields, of the arguments and of the destructors at the instances that its body names, which depend on its grade variables and on its sort variables, as the grade of the term already built of a position, $`{01}^{\mathsf{p}}`$ in a universe of propositions, and on nothing else, since the erasure follows the grades alone.
The term $`{f.\{\bar s;\ \bar p\}}`$ of the target language thus names the copy of $`f`$ compiled for the qualities $`\bar s`$ and the grades $`\bar p`$, the erasure of its body for this instance, as the [monomorphization](https://doc.rust-lang.org/book/ch10-01-syntax.html#performance-of-code-using-generics) of Rust compiles a copy of a generic function for each instance of its type parameters, so that no grade remains at run time: if the body of $`f`$ checks with its grade variable $`p`$ a position that computes from its parameter, the extraction erases this position in $`f.\{{00}^{\mathsf{p}}\}`$ and keeps it in $`f.\{{11}^{\mathsf{p}}\}`$, when $`f`$ has no sort variable.

A term checked in the mode $`m`$ does not count the uses of the positions that it checks in a more erased mode, whose grades form the [set](11-grade-sets.md#definitions) $`S^m`$.

The erasure $`\lfloor t \rfloor_{S^{{11}^{\mathsf{m}}}}`$ is thus the extraction $`t^\bullet`$ of [Abel, Danielsson and Eriksson](https://doi.org/10.1145/3607862), which removes what has no use at run time, and $`\lfloor t \rfloor_{S^{{01}^{\mathsf{m}}}}`$ keeps the proofs, the specifications and the permissions that the extraction removes, as the ghost code of [Verus](https://doi.org/10.1145/3586037) is checked but never run.

A variable occurs in a term of the target language when the term is the variable, or when the variable occurs in one of its subterms, a field of a constructor, the term or a branch of a recursor, the term or an argument of an observation, the state or a branch of a corecursor; it occurs in arguments or in branches when it occurs in one of them:

```math
\begin{gathered}
\frac{}{x \text{ occurs in } x}\;(\mathsf{occurs}_M.x) \\[1em]
\frac{x \text{ occurs in } \bar M}{x \text{ occurs in } c_i(\bar M)}\;(\mathsf{occurs}_M.c) \\[1em]
\frac{x \text{ occurs in } M}{x \text{ occurs in } \mathsf{rec}_\rho\ M\ \mathsf{with}\ \bar N}\;(\mathsf{occurs}_M.\mathsf{rec}) \\[1em]
\frac{x \text{ occurs in } \bar N}{x \text{ occurs in } \mathsf{rec}_\rho\ M\ \mathsf{with}\ \bar N}\;(\mathsf{occurs}_M.\mathsf{with}) \\[1em]
\frac{x \text{ occurs in } M}{x \text{ occurs in } M.d_i(\bar M)}\;(\mathsf{occurs}_M.\mathsf{obs}) \\[1em]
\frac{x \text{ occurs in } \bar M}{x \text{ occurs in } M.d_i(\bar M)}\;(\mathsf{occurs}_M.\mathsf{args}) \\[1em]
\frac{x \text{ occurs in } \bar M}{x \text{ occurs in } \mathsf{corec}\ \mathsf{from}\ \bar M\ \mathsf{with}\ \bar P}\;(\mathsf{occurs}_M.\mathsf{from}) \\[1em]
\frac{x \text{ occurs in } \bar P}{x \text{ occurs in } \mathsf{corec}\ \mathsf{from}\ \bar M\ \mathsf{with}\ \bar P}\;(\mathsf{occurs}_M.\mathsf{with}_{\bar P}) \\[1em]
\frac{x \text{ occurs in } M}{x \text{ occurs in } (M \mathrel{▶} \pi,\ \bar M)}\;(\mathsf{occurs}_{\bar M}.M) \\[1em]
\frac{x \text{ occurs in } \bar M}{x \text{ occurs in } (M \mathrel{▶} \pi,\ \bar M)}\;(\mathsf{occurs}_{\bar M}.\bar M) \\[1em]
\frac{x \text{ occurs in } N}{x \text{ occurs in } ((\bar x \mathrel{▶} \bar\pi;\ \bar y \mathrel{▶} \bar\pi' \leftarrow \bar k).\, N,\ \bar N)}\;(\mathsf{occurs}_{\bar N}.N) \\[1em]
\frac{x \text{ occurs in } \bar N}{x \text{ occurs in } ((\bar x \mathrel{▶} \bar\pi;\ \bar y \mathrel{▶} \bar\pi' \leftarrow \bar k).\, N,\ \bar N)}\;(\mathsf{occurs}_{\bar N}.\bar N) \\[1em]
\frac{x \text{ occurs in } P}{x \text{ occurs in } ((\bar y \mathrel{▶} \bar\pi;\ \bar z \mathrel{▶} \bar\pi' \circlearrowleft k).\, P,\ \bar P)}\;(\mathsf{occurs}_{\bar P}.P) \\[1em]
\frac{x \text{ occurs in } \bar P}{x \text{ occurs in } ((\bar y \mathrel{▶} \bar\pi;\ \bar z \mathrel{▶} \bar\pi' \circlearrowleft k).\, P,\ \bar P)}\;(\mathsf{occurs}_{\bar P}.\bar P)
\end{gathered}
```

In $`(\mathsf{occurs}_{\bar N}.N)`$ and $`(\mathsf{occurs}_{\bar P}.P)`$, the variable $`x`$ is not among the variables that the branch binds, since they take names that $`x`$ does not use.

A term of the target language is a skeleton when it is built of constructors and of $`\text{↯}`$ only, and terms are skeletons when each of them is:

```math
\begin{gathered}
\frac{}{\text{↯} \text{ is a skeleton}}\;(\mathsf{skeleton}_M.\text{↯}) \\[1em]
\frac{\bar M \text{ are skeletons}}{c_i(\bar M) \text{ is a skeleton}}\;(\mathsf{skeleton}_M.c) \\[1em]
\frac{}{() \text{ are skeletons}}\;(\mathsf{skeleton}_{\bar M}.\varepsilon) \\[1em]
\frac{M \text{ is a skeleton} \quad \bar M \text{ are skeletons}}{(M \mathrel{▶} \pi,\ \bar M) \text{ are skeletons}}\;(\mathsf{skeleton}_{\bar M}.{,})
\end{gathered}
```

The judgment $`{M \sqsubseteq N}`$ reads: the term $`M`$ of the target language is less defined than $`N`$, which is $`M`$ with some of its subterms $`\text{↯}`$ replaced by other terms, as the order of the approximants of the Böhm trees of [Kerinec, Manzonetto and Pagani](https://doi.org/10.23638/LMCS-16(3:6)2020), generated by the undefined value below every value; a constructor, a recursor, an observation and a corecursor are less defined than the same constructor, recursor, observation and corecursor when their subterms are, and arguments and branches when they are one by one, a branch of a recursor that does not compute a recursive result being less defined than one that computes it, and a recursor on a skeleton being less defined than a recursor on any term, since the skeleton holds nothing but what the type of the term gives:

```math
\begin{gathered}
\frac{}{\text{↯} \sqsubseteq M}\;({\sqsubseteq}.\text{↯}) \\[1em]
\frac{}{x \sqsubseteq x}\;({\sqsubseteq}.x) \\[1em]
\frac{}{f.\{\bar s;\ \bar p\} \sqsubseteq f.\{\bar s;\ \bar p\}}\;({\sqsubseteq}.f) \\[1em]
\frac{\bar M_1 \sqsubseteq \bar M_2}{c_i(\bar M_1) \sqsubseteq c_i(\bar M_2)}\;({\sqsubseteq}.c) \\[1em]
\frac{M_1 \sqsubseteq M_2 \quad \bar N_1 \sqsubseteq \bar N_2}{\mathsf{rec}_\rho\ M_1\ \mathsf{with}\ \bar N_1 \sqsubseteq \mathsf{rec}_\rho\ M_2\ \mathsf{with}\ \bar N_2}\;({\sqsubseteq}.\mathsf{rec}) \\[1em]
\frac{M_1 \text{ is a skeleton} \quad \bar N_1 \sqsubseteq \bar N_2}{\mathsf{rec}_\rho\ M_1\ \mathsf{with}\ \bar N_1 \sqsubseteq \mathsf{rec}_\rho\ M_2\ \mathsf{with}\ \bar N_2}\;({\sqsubseteq}.\mathsf{rec}_{\mathsf{skeleton}}) \\[1em]
\frac{M_1 \sqsubseteq M_2 \quad \bar M_1 \sqsubseteq \bar M_2}{M_1.d_i(\bar M_1) \sqsubseteq M_2.d_i(\bar M_2)}\;({\sqsubseteq}.d) \\[1em]
\frac{\bar M_1 \sqsubseteq \bar M_2 \quad \bar P_1 \sqsubseteq \bar P_2}{\mathsf{corec}\ \mathsf{from}\ \bar M_1\ \mathsf{with}\ \bar P_1 \sqsubseteq \mathsf{corec}\ \mathsf{from}\ \bar M_2\ \mathsf{with}\ \bar P_2}\;({\sqsubseteq}.\mathsf{corec}) \\[1em]
\frac{}{() \sqsubseteq ()}\;({\sqsubseteq}_{\bar M}.\varepsilon) \\[1em]
\frac{M_1 \sqsubseteq M_2 \quad \bar M_1 \sqsubseteq \bar M_2}{(M_1 \mathrel{▶} \pi,\ \bar M_1) \sqsubseteq (M_2 \mathrel{▶} \pi,\ \bar M_2)}\;({\sqsubseteq}_{\bar M}.{,}) \\[1em]
\frac{}{() \sqsubseteq ()}\;({\sqsubseteq}_{\bar N}.\varepsilon) \\[1em]
\frac{\begin{gathered}{}\forall j.\ k_{1j} = \bot \text{ or } k_{1j} = k_{2j} \\ N_1 \sqsubseteq N_2 \\ \bar N_1 \sqsubseteq \bar N_2\end{gathered}}{((\bar x \mathrel{▶} \bar\pi;\ \bar y \mathrel{▶} \bar\pi' \leftarrow \bar k_1).\, N_1,\ \bar N_1) \sqsubseteq ((\bar x \mathrel{▶} \bar\pi;\ \bar y \mathrel{▶} \bar\pi' \leftarrow \bar k_2).\, N_2,\ \bar N_2)}\;({\sqsubseteq}_{\bar N}.{,}) \\[1em]
\frac{}{() \sqsubseteq ()}\;({\sqsubseteq}_{\bar P}.\varepsilon) \\[1em]
\frac{\begin{gathered}{}k_1 = k_2 \text{ or } k_1 = \text{↯}_n \text{ and } k_2 = n \\ P_1 \sqsubseteq P_2 \\ \bar P_1 \sqsubseteq \bar P_2\end{gathered}}{((\bar y \mathrel{▶} \bar\pi;\ \bar z \mathrel{▶} \bar\pi' \circlearrowleft k_1).\, P_1,\ \bar P_1) \sqsubseteq ((\bar y \mathrel{▶} \bar\pi;\ \bar z \mathrel{▶} \bar\pi' \circlearrowleft k_2).\, P_2,\ \bar P_2)}\;({\sqsubseteq}_{\bar P}.{,})
\end{gathered}
```

The judgment $`{\nu \vdash M \mathrel{▶}}`$ reads: the term $`M`$ of the target language reads its variables as the [vector of multiplicities](10-grade-vectors.md#vectors-of-multiplicities) $`\nu`$ allows, as the [evaluation](17-evaluation.md) runs it.
A variable reads itself once, a constant and $`\text{↯}`$ read no variable, and a constructor, an observation and terms read the variables of their subterms, added.
A position $`{M \mathrel{▶} \pi}`$ is evaluated once, and its value is then read as its multiplicity allows, through a cell or by each observation of a closure, so that the position counts the reads of its term $`\pi`$ times, as the term of a recursor $`\rho`$ times.
A position of the multiplicity $`0`$ is still evaluated, but its value is never read: a closure that it holds is never observed, and would never release a linear variable that it captures, whether the term reads it or binds it inside, so that its term is a skeleton, which reads no variable and binds none, as the term of a recursor of the multiplicity $`0`$, whose fields are never read; reads of the multiplicity $`\omega`$ would also vanish in the product, and could read a variable of the multiplicity $`0`$.
A recursor evaluates its term once and runs a branch, which reads the variables of the scope as some $`\delta`$ allows, and its new variables as their binders allow; each recursive result that the branch computes, at the positions $`{k_j \ne \bot}`$, runs the recursor again, which reads the variables of the scope as $`\chi`$ allows again, and is read as its binder allows, so that $`\chi`$ bounds $`\delta`$ plus $`\chi`$ times the sum of the multiplicities $`\bar\pi'`$ of the binders of the results, as the [usage](12-usage.md#definitions) bounds the uses of the branches of a recursor; a result that the branch computes has a multiplicity other than $`0`$, since the recursion that computes it also reads its field, which a result never read would not count.
A corecursor evaluates its state once and captures its scope in a closure, each observation of which runs one branch, which reads the variables of the scope as some $`\delta_i`$ allows and its new variables as their binders allow, and a branch that resumes the corecursor, $`{k \ne \bot}`$, captures the scope again in a new closure, so that $`\delta`$ bounds $`\delta_i`$, and $`\delta_i`$ plus $`\delta`$ for such a branch.
In the rules, $`{\nu \bullet \bar\pi \bullet \bar\pi'}`$ extends $`\nu`$ by the multiplicities of the variables that a branch binds, in order:

```math
\begin{aligned}
& \nu \bullet (\pi_1, \dots, \pi_a) \bullet (\pi'_1, \dots, \pi'_b) = \nu \bullet \pi_1 \bullet \dots \bullet \pi_a \bullet \pi'_1 \bullet \dots \bullet \pi'_b &&(\bullet_\nu)
\end{aligned}
```

```math
\begin{gathered}
\frac{}{(0^{\nu},\ x \mathrel{≔} 1) \vdash x \mathrel{▶}}\;(\mathsf{usage}_M.x) \\[1em]
\frac{}{0^{\nu} \vdash f.\{\bar s;\ \bar p\} \mathrel{▶}}\;(\mathsf{usage}_M.f) \\[1em]
\frac{}{0^{\nu} \vdash \text{↯} \mathrel{▶}}\;(\mathsf{usage}_M.\text{↯}) \\[1em]
\frac{\nu \vdash \bar M \mathrel{▶}}{\nu \vdash c_i(\bar M) \mathrel{▶}}\;(\mathsf{usage}_M.c) \\[1em]
\frac{\begin{gathered}{}\nu \vdash M \mathrel{▶} \\ \rho = 0 \implies M \text{ is a skeleton} \\ \chi \vdash \bar N \mathrel{▶}\end{gathered}}{\rho \cdot^{\nu} \nu +^{\nu} \chi \vdash \mathsf{rec}_\rho\ M\ \mathsf{with}\ \bar N \mathrel{▶}}\;(\mathsf{usage}_M.\mathsf{rec}) \\[1em]
\frac{\nu_1 \vdash M \mathrel{▶} \quad \nu_2 \vdash \bar M \mathrel{▶}}{\nu_1 +^{\nu} \nu_2 \vdash M.d_i(\bar M) \mathrel{▶}}\;(\mathsf{usage}_M.d) \\[1em]
\frac{\nu \vdash \bar M \mathrel{▶} \quad \delta \vdash \bar P \mathrel{▶}}{\nu +^{\nu} \delta \vdash \mathsf{corec}\ \mathsf{from}\ \bar M\ \mathsf{with}\ \bar P \mathrel{▶}}\;(\mathsf{usage}_M.\mathsf{corec}) \\[1em]
\frac{\nu \vdash M \mathrel{▶} \quad \mu \le^{\nu} \nu}{\mu \vdash M \mathrel{▶}}\;(\mathsf{usage}_M.\mathsf{sub}) \\[1em]
\frac{}{0^{\nu} \vdash () \mathrel{▶}}\;(\mathsf{usage}_{\bar M}.\varepsilon) \\[1em]
\frac{\begin{gathered}{}\nu_1 \vdash M \mathrel{▶} \\ \pi = 0 \implies M \text{ is a skeleton} \\ \nu_2 \vdash \bar M \mathrel{▶}\end{gathered}}{\pi \cdot^{\nu} \nu_1 +^{\nu} \nu_2 \vdash (M \mathrel{▶} \pi,\ \bar M) \mathrel{▶}}\;(\mathsf{usage}_{\bar M}.{,}) \\[1em]
\frac{}{\chi \vdash () \mathrel{▶}}\;(\mathsf{usage}_{\bar N}.\varepsilon) \\[1em]
\frac{\begin{gathered}{}\delta \bullet \bar\pi \bullet \bar\pi' \vdash N \mathrel{▶} \\ \chi \le^{\nu} \delta +^{\nu} \Sigma\bar\pi' \cdot^{\nu} \chi \\ \forall j.\ k_j \ne \bot \implies \pi'_j \ne 0 \\ \chi \vdash \bar N \mathrel{▶}\end{gathered}}{\chi \vdash ((\bar x \mathrel{▶} \bar\pi;\ \bar y \mathrel{▶} \bar\pi' \leftarrow \bar k).\, N,\ \bar N) \mathrel{▶}}\;(\mathsf{usage}_{\bar N}.{,}) \\[1em]
\frac{}{\delta \vdash () \mathrel{▶}}\;(\mathsf{usage}_{\bar P}.\varepsilon) \\[1em]
\frac{\begin{gathered}{}\delta_i \bullet \bar\pi \bullet \bar\pi' \vdash P \mathrel{▶} \\ \delta \le^{\nu} \delta_i \\ k \ne \bot \implies \delta \le^{\nu} \delta_i +^{\nu} \delta \\ \delta \vdash \bar P \mathrel{▶}\end{gathered}}{\delta \vdash ((\bar y \mathrel{▶} \bar\pi;\ \bar z \mathrel{▶} \bar\pi' \circlearrowleft k).\, P,\ \bar P) \mathrel{▶}}\;(\mathsf{usage}_{\bar P}.{,})
\end{gathered}
```

## Properties

A variable whose grade is in a set $`S`$ is absent from the erasure by $`S`$ of a term checked in a mode whose uses $`S`$ does not erase, in a signature whose names are distinct, so that the usage and the erasure of a constructor read the grades of its fields in the same entry, and the erasure by a larger set is less defined, so that the extraction is the program that the proofs see with more parts erased:

```math
\begin{aligned}
& \text{⟹} &&(\mathsf{absent}_S) \\
& \quad \text{and} \\
& \qquad \text{the names of } \Sigma \text{ are distinct} \\
& \qquad S \text{ erases only what } m \text{ does not count} \\
& \qquad \Sigma;\ \gamma \vdash t \mathrel{▶} m \\
& \qquad \gamma(x) \in S \\
& \quad x \text{ does not occur in } \lfloor t \rfloor_S \\[1em]
& S_1 \subseteq S_2 \implies \lfloor t \rfloor_{S_2} \sqsubseteq \lfloor t \rfloor_{S_1} &&(\sqsubseteq_S)
\end{aligned}
```

The condition on the mode is needed: the variable $`x`$ checked in the mode $`{01}^{\mathsf{m}}`$ uses itself with the grade $`{01}^{\mathsf{p}}`$, which is in $`S^{{11}^{\mathsf{m}}}`$, but $`{\lfloor x \rfloor_{S^{{11}^{\mathsf{m}}}} = x}`$; Abel, Danielsson and Eriksson likewise state the absence for their mode `𝟙ᵐ` only, as [`erased-hasX`](https://github.com/graded-type-theory/graded-type-theory/blob/master/Graded/Erasure/Extraction/Properties/Usage.agda).

The erasure at run time keeps the usage: a term checked in the mode $`{11}^{\mathsf{m}}`$ in a signature whose names are distinct, so that the usage and the erasure read the grades of the fields, of the arguments and of the branches in the same entry, has an erasure that reads its variables as the run-time multiplicities of their grades allow:

```math
\begin{aligned}
& \text{⟹} &&(\mathsf{erase}_{▶}) \\
& \quad \text{and} \\
& \qquad \text{the names of } \Sigma \text{ are distinct} \\
& \qquad \Sigma;\ \gamma \vdash t \mathrel{▶} {11}^{\mathsf{m}} \\
& \quad \mathsf{run}(\gamma) \vdash \lfloor t \rfloor_{S^{{11}^{\mathsf{m}}}} \mathrel{▶}
\end{aligned}
```

The erasure removes the positions whose grade has no use at run time, which the usage counts $`0`$ times at run time, replacing them by $`\text{↯}`$, and the term of a recursor of such a grade by a skeleton, and keeps the others, which a term checked in the mode $`{11}^{\mathsf{m}}`$ checks in this mode again, at grades whose run-time multiplicity is $`1`$ or $`\omega`$, below $`1`$; it gives each binder the multiplicity that the usage gives its variable at run time, except the variable of a field of a branch of a recursor, whose multiplicity is the least that the bound on its grade allows, below this grade.
An instance, which the erasure replaces by $`\text{↯}`$, needs its [usage](12-usage.md#definitions) as a position of the grade $`{01}^{\mathsf{p}}`$, which uses no variable at run time, and a branch of a corecursor of a destructor without use at run time, whose term is $`\text{↯}`$, needs the multiplicity $`0`$ of its variables, while the usage already bounds the uses of the scope by none at run time, $`{\delta \le p \cdot \delta_i}`$ with $`\mathsf{run}(p) = 0`$.

The erasure states nothing on the ownership: it follows the grades of the usage alone, which the ownership reads without deciding what is erased, and what the ownership of a term guarantees of its erasure, the uses of a value during a run, needs the [evaluation](17-evaluation.md) of the target language.
