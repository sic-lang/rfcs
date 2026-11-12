# Erasure

This annex defines the erasure, which compiles a term to an untyped target language by replacing with $`\text{↯}`$ the parts whose grade is in a set of grades, and its properties.
It builds on the [grades](04-grades.md), the [modes](05-modes.md), the [syntax](08-syntax.md), the [sets of grades](11-grade-sets.md), the [usage](12-usage.md) and the fields of a block, which the [typing](14-typing.md#fields-of-a-block) marks.

## Definitions

The target language has variables, all of the first order, the constants at the qualities and the grades of their instances, a value $`\text{↯}`$ that stands for what was erased, the constructors, by their case in their block, applied to terms for their fields, the recursors, with a branch for each constructor, the observations by a destructor, by its case in its block, applied to terms for its arguments, and the corecursors, with a state and a branch for each destructor:

```math
\begin{aligned}
& M \mathrel{::=} x \mid f.\{\bar s;\ \bar p\} \mid \text{↯} \mid c_i(\bar M) \mid \mathsf{rec}\ M\ \mathsf{with}\ \bar N \mid M.d_i(\bar M) \mid \mathsf{corec}\ \mathsf{from}\ \bar M\ \mathsf{with}\ \bar P &&(\mathsf{syntax}_M) \\[1em]
& \bar M \mathrel{::=} () \mid (M,\ \bar M) &&(\mathsf{syntax}_{\bar M}) \\[1em]
& \bar N \mathrel{::=} () \mid ((\bar x;\ \bar y \leftarrow \bar k).\, N,\ \bar N) &&(\mathsf{syntax}_{\bar N}) \\[1em]
& \bar P \mathrel{::=} () \mid ((\bar y;\ \bar z \circlearrowleft k).\, P,\ \bar P) &&(\mathsf{syntax}_{\bar P}) \\[1em]
& k \mathrel{::=} \bot \mid n \mid \text{↯}_n &&(\mathsf{syntax}_k)
\end{aligned}
```

A branch $`{(\bar x;\ \bar y \leftarrow \bar k).\, N}`$ binds the variables $`\bar x`$ of the fields and $`\bar y`$ of the recursive results, as a branch of a recursor does, and $`\bar k`$ gives each recursive result the position of its field among $`\bar x`$, the first one at $`1`$, or $`\bot`$ when the result is erased, so that it is not computed.
A branch $`{(\bar y;\ \bar z \circlearrowleft k).\, P}`$ binds the variables $`\bar y`$ of the state and $`\bar z`$ of the arguments, as a branch of a corecursor does, and $`k`$ is its resumption: $`\bot`$ when its destructor is not recursive, the number $`n`$ of the entries of the state that the branch resumes, which the evaluation unpacks from the new state, or $`\text{↯}_n`$ when these $`n`$ entries are erased, so that the evaluation does not read the new state.
The target language keeps only what its [evaluation](17-evaluation.md) reads: a case chooses a branch, since the names of the constructors and of the destructors are distinct only in their type, and a branch does not bind the non-uniform parameters, which the corecursors do not have yet.

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

The skeleton $`\mathsf{skeleton}_\Sigma(T)`$ of an instance $`{T = D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a}`$ is the term of the target language that the type $`D`$ gives to its closed terms when each type of its block has one constructor at most: the constructor of the case of the only constructor of $`D`$, applied to $`\text{↯}`$ for each field that is not recursive and to the skeleton of the type of each recursive field, and $`\text{↯}`$ when $`D`$ has no constructor or several.
It is built within the depth $`k`$ of the number of the types of the block, at the instance $`\bar s`$, $`\bar p`$, in the last entry of $`\Sigma`$ that declares a type $`D`$ and as many sort and grade variables as $`\bar s`$ and $`\bar p`$, and is $`\text{↯}`$ when $`\Sigma`$ has no such entry:

```math
\begin{aligned}
& \mathsf{skeleton}_\Sigma(T) = \mathsf{skeleton}^k(D) \text{ if } (\mathsf{data}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} \bar c_1;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \bar c_k) \text{ is this entry} &&(\mathsf{skeleton}_D) \\
& \mathsf{skeleton}_\Sigma(T) = \text{↯} \text{ if } \Sigma \text{ has no such entry} \\[1em]
& \mathsf{skeleton}^0(D_j) = \text{↯} \\
& \mathsf{skeleton}^{n + 1}(D_j) = c_i(M_1, \dots, M_a) \text{ if } \bar c_j = (c : \Theta),\ i = \mathsf{case}_\Sigma(D_j.c) \text{ and } \Theta \text{ has } a \text{ entries} \\
& \mathsf{skeleton}^{n + 1}(D_j) = \text{↯} \text{ otherwise}
\end{aligned}
```

In the skeleton of a constructor $`{c : \Theta}`$, $`M_l`$ is $`\mathsf{skeleton}^n(D')`$ when the element $`l`$ of [$`\mathsf{rec}_{\mathcal{D}}(\Theta)`$](14-typing.md#fields-of-a-block) is a type $`D'`$ of the block, and $`\text{↯}`$ when it is $`\bot`$.
The depth is reached only on a type without closed term: along a path of a closed term, from a term to the term of one of its recursive fields, no type of the block comes twice, since each type has one constructor, so that the term would hold a term of the same form, without end.

The sorts and the instances have no representation in the target language, and are erased.
A constructor keeps its case and its fields, each erased at the grade of its field, and a field whose grade the signature does not give, in a term that no rule types, is erased, as a constructor whose case it does not give; a recursor keeps its term when its grade $`r`$ is not in $`S`$, and the skeleton of the type of its term otherwise, and its branches, which keep, for each recursive result, the position of its field, or $`\bot`$ when its grade is in $`S`$, and loses its instance and its motives, which are types.
An observation keeps its term, the case of its destructor and its arguments, each erased at the grade of its argument, and a corecursor keeps its state, each entry erased at its grade times the grade $`r`$ of the corecursor, since every observation that reaches the state uses it $`r`$ times, and its branches, each erased at the grade of its destructor, since its usage checks it in the mode of this grade, with the number of the entries of the state it resumes, and loses its instance and its states, which are types; the grades of the entries of the state are those of the state $`\Theta_h`$ of the type $`D_h`$ of its instance, with $`{h = \mathsf{position}_\Sigma(D)}`$, and an entry whose grade is not given, in a term that no rule types, is erased.
The erasure $`{\lfloor t \rfloor_{S, p}}`$ of a position of grade $`p`$ is $`\text{↯}`$ when $`{p \in S}`$, and $`\lfloor t \rfloor_S`$ otherwise:

```math
\begin{aligned}
& \lfloor x \rfloor_S = x &&(\mathsf{erase}_t) \\
& \lfloor \kappa \rfloor_S = \text{↯} \\
& \lfloor f.\{\bar s;\ \bar l;\ \bar p\} \rfloor_S = f.\{\bar s;\ \bar p\} \\
& \lfloor D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a \rfloor_S = \text{↯} \\
& \lfloor T.c(\bar t) \rfloor_S = c_i(\lfloor \bar t \rfloor_{S, \mathsf{grades}_\Sigma(T.c)}) \text{ if } i = \mathsf{case}_\Sigma(D.c) \\
& \lfloor T.c(\bar t) \rfloor_S = \text{↯} \text{ otherwise} \\
& \lfloor \mathsf{rec}_r\ T\ t\ \mathsf{return}\ \bar C\ \mathsf{with}\ \bar u \rfloor_S = \mathsf{rec}\ \mathsf{skeleton}_\Sigma(T)\ \mathsf{with}\ \lfloor \bar u \rfloor_{S, \mathsf{recursive}_\Sigma(T)} \text{ if } r \in S \\
& \lfloor \mathsf{rec}_r\ T\ t\ \mathsf{return}\ \bar C\ \mathsf{with}\ \bar u \rfloor_S = \mathsf{rec}\ \lfloor t \rfloor_S\ \mathsf{with}\ \lfloor \bar u \rfloor_{S, \mathsf{recursive}_\Sigma(T)} \text{ if } r \notin S \\
& \lfloor t.(T.d)(\bar t) \rfloor_S = \lfloor t \rfloor_S.d_i(\lfloor \bar t \rfloor_{S, \mathsf{grades}_\Sigma(T.d)}) \text{ if } i = \mathsf{case}_\Sigma(D.d) \\
& \lfloor t.(T.d)(\bar t) \rfloor_S = \text{↯} \text{ otherwise} \\
& \lfloor \mathsf{corec}_r\ T\ \mathsf{from}\ \bar t\ \mathsf{return}\ \bar\Theta\ \mathsf{with}\ \bar g \rfloor_S = \mathsf{corec}\ \mathsf{from}\ \lfloor \bar t \rfloor_{S, r \cdot \bar q}\ \mathsf{with}\ \lfloor \bar g \rfloor_{S, \mathsf{grades}_\Sigma(T.\bar g), \bar k} \text{ if } \bar q \text{ are the grades of } \Theta_h,\ h = \mathsf{position}_\Sigma(D) \\
& \lfloor \mathsf{corec}_r\ T\ \mathsf{from}\ \bar t\ \mathsf{return}\ \bar\Theta\ \mathsf{with}\ \bar g \rfloor_S = \mathsf{corec}\ \mathsf{from}\ \lfloor \bar t \rfloor_{S, ()}\ \mathsf{with}\ \lfloor \bar g \rfloor_{S, \mathsf{grades}_\Sigma(T.\bar g), \bar k} \text{ otherwise} \\
& \lfloor t \rfloor_{S, p} = \text{↯} \text{ if } p \in S \\
& \lfloor t \rfloor_{S, p} = \lfloor t \rfloor_S \text{ if } p \notin S \\[1em]
& \lfloor () \rfloor_{S, \bar p} = () &&(\mathsf{erase}_{\bar t}) \\
& \lfloor (t,\ \bar t) \rfloor_{S, ()} = (\text{↯},\ \lfloor \bar t \rfloor_{S, ()}) \\
& \lfloor (t,\ \bar t) \rfloor_{S, (p,\ \bar p)} = (\lfloor t \rfloor_{S, p},\ \lfloor \bar t \rfloor_{S, \bar p}) \\[1em]
& \lfloor () \rfloor_{S, \bar{\bar k}} = () &&(\mathsf{erase}_{\bar u}) \\
& \lfloor ((\bar x;\ \bar y \mathrel{▶} \bar e).\, u,\ \bar u) \rfloor_{S, \bar{\bar k}} = ((\bar x;\ \bar y \leftarrow \bar k').\, \lfloor u \rfloor_S,\ \lfloor \bar u \rfloor_{S, \bar{\bar k}'}) \\[1em]
& \lfloor () \rfloor_{S, \bar p, \bar k} = () &&(\mathsf{erase}_{\bar g}) \\
& \lfloor ((\bar x;\ \bar y;\ \bar z).\, g,\ \bar g) \rfloor_{S, (p,\ \bar p), \bar k} = ((\bar y;\ \bar z \circlearrowleft k).\, \lfloor g \rfloor_{S, p},\ \lfloor \bar g \rfloor_{S, \bar p, \bar k'}) \text{ if } \bar x \text{ is empty} \\
& \lfloor ((\bar x;\ \bar y;\ \bar z).\, g,\ \bar g) \rfloor_{S, \bar p, \bar k} = ((\bar y;\ \bar z \circlearrowleft k).\, \text{↯},\ \lfloor \bar g \rfloor_{S, \bar p', \bar k'}) \text{ otherwise}
\end{aligned}
```

In the erasure of a corecursor, $`{T = D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a}`$, $`{\bar\Theta = (\bar x_1.\, \Theta_1 : \bar\kappa_1,\ \dots,\ \bar x_n.\, \Theta_n : \bar\kappa_n)}`$, $`{r \cdot \bar q}`$ multiplies each grade of $`\bar q`$ by $`r`$ on the left, and $`\bar k`$ gives each element $`h`$ of $`\mathsf{resumed}_\Sigma(T)`$ the number $`n`$ of the entries of $`\Theta_h`$ when $`\bar x_h`$ is empty and $`{r \notin S}`$, $`\text{↯}_n`$ when $`\bar x_h`$ is empty and $`{r \in S}`$, since the new state, a field of the grade $`r`$ of a position, is then erased, as are its entries, of the grades $`r \cdot \bar q`$, and $`\bot`$ otherwise.
A double bar marks a sequence of sequences: in the erasure of the branches of a recursor, $`\bar k`$ is the first sequence of $`\bar{\bar k}`$, or $`()`$ when it has none, $`\bar{\bar k}'`$ the others, and $`k'_j`$ is $`\bot`$ when $`{e_j \in S}`$, and the $`j`$-th element of $`\bar k`$ otherwise, or $`\bot`$ when it has none; in the erasure of the branches of a corecursor, $`k`$ is the first element of $`\bar k`$, or $`\bot`$ when it has none, and $`\bar k'`$ and $`\bar p'`$ are the others.
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
\frac{x \text{ occurs in } M}{x \text{ occurs in } \mathsf{rec}\ M\ \mathsf{with}\ \bar N}\;(\mathsf{occurs}_M.\mathsf{rec}) \\[1em]
\frac{x \text{ occurs in } \bar N}{x \text{ occurs in } \mathsf{rec}\ M\ \mathsf{with}\ \bar N}\;(\mathsf{occurs}_M.\mathsf{with}) \\[1em]
\frac{x \text{ occurs in } M}{x \text{ occurs in } M.d_i(\bar M)}\;(\mathsf{occurs}_M.\mathsf{obs}) \\[1em]
\frac{x \text{ occurs in } \bar M}{x \text{ occurs in } M.d_i(\bar M)}\;(\mathsf{occurs}_M.\mathsf{args}) \\[1em]
\frac{x \text{ occurs in } \bar M}{x \text{ occurs in } \mathsf{corec}\ \mathsf{from}\ \bar M\ \mathsf{with}\ \bar P}\;(\mathsf{occurs}_M.\mathsf{from}) \\[1em]
\frac{x \text{ occurs in } \bar P}{x \text{ occurs in } \mathsf{corec}\ \mathsf{from}\ \bar M\ \mathsf{with}\ \bar P}\;(\mathsf{occurs}_M.\mathsf{with}_{\bar P}) \\[1em]
\frac{x \text{ occurs in } M}{x \text{ occurs in } (M,\ \bar M)}\;(\mathsf{occurs}_{\bar M}.M) \\[1em]
\frac{x \text{ occurs in } \bar M}{x \text{ occurs in } (M,\ \bar M)}\;(\mathsf{occurs}_{\bar M}.\bar M) \\[1em]
\frac{x \text{ occurs in } N}{x \text{ occurs in } ((\bar x;\ \bar y \leftarrow \bar k).\, N,\ \bar N)}\;(\mathsf{occurs}_{\bar N}.N) \\[1em]
\frac{x \text{ occurs in } \bar N}{x \text{ occurs in } ((\bar x;\ \bar y \leftarrow \bar k).\, N,\ \bar N)}\;(\mathsf{occurs}_{\bar N}.\bar N) \\[1em]
\frac{x \text{ occurs in } P}{x \text{ occurs in } ((\bar y;\ \bar z \circlearrowleft k).\, P,\ \bar P)}\;(\mathsf{occurs}_{\bar P}.P) \\[1em]
\frac{x \text{ occurs in } \bar P}{x \text{ occurs in } ((\bar y;\ \bar z \circlearrowleft k).\, P,\ \bar P)}\;(\mathsf{occurs}_{\bar P}.\bar P)
\end{gathered}
```

In $`(\mathsf{occurs}_{\bar N}.N)`$ and $`(\mathsf{occurs}_{\bar P}.P)`$, the variable $`x`$ is not among the variables that the branch binds, since they take names that $`x`$ does not use.

A term of the target language is a skeleton when it is built of constructors and of $`\text{↯}`$ only, and terms are skeletons when each of them is:

```math
\begin{gathered}
\frac{}{\text{↯} \text{ is a skeleton}}\;(\mathsf{skeleton}_M.\text{↯}) \\[1em]
\frac{\bar M \text{ are skeletons}}{c_i(\bar M) \text{ is a skeleton}}\;(\mathsf{skeleton}_M.c) \\[1em]
\frac{}{() \text{ are skeletons}}\;(\mathsf{skeleton}_{\bar M}.\varepsilon) \\[1em]
\frac{M \text{ is a skeleton} \quad \bar M \text{ are skeletons}}{(M,\ \bar M) \text{ are skeletons}}\;(\mathsf{skeleton}_{\bar M}.{,})
\end{gathered}
```

The judgment $`{M \sqsubseteq N}`$ reads: the term $`M`$ of the target language is less defined than $`N`$, which is $`M`$ with some of its subterms $`\text{↯}`$ replaced by other terms, as the order of the approximants of the Böhm trees of [Kerinec, Manzonetto and Pagani](https://doi.org/10.23638/LMCS-16(3:6)2020), generated by the undefined value below every value; a constructor, a recursor, an observation and a corecursor are less defined than the same constructor, recursor, observation and corecursor when their subterms are, and arguments and branches when they are one by one, a branch of a recursor that does not compute a recursive result being less defined than one that computes it, and a recursor on a skeleton being less defined than a recursor on any term, since the skeleton holds nothing but what the type of the term gives:

```math
\begin{gathered}
\frac{}{\text{↯} \sqsubseteq M}\;({\sqsubseteq}.\text{↯}) \\[1em]
\frac{}{x \sqsubseteq x}\;({\sqsubseteq}.x) \\[1em]
\frac{}{f.\{\bar s;\ \bar p\} \sqsubseteq f.\{\bar s;\ \bar p\}}\;({\sqsubseteq}.f) \\[1em]
\frac{\bar M_1 \sqsubseteq \bar M_2}{c_i(\bar M_1) \sqsubseteq c_i(\bar M_2)}\;({\sqsubseteq}.c) \\[1em]
\frac{M_1 \sqsubseteq M_2 \quad \bar N_1 \sqsubseteq \bar N_2}{\mathsf{rec}\ M_1\ \mathsf{with}\ \bar N_1 \sqsubseteq \mathsf{rec}\ M_2\ \mathsf{with}\ \bar N_2}\;({\sqsubseteq}.\mathsf{rec}) \\[1em]
\frac{M_1 \text{ is a skeleton} \quad \bar N_1 \sqsubseteq \bar N_2}{\mathsf{rec}\ M_1\ \mathsf{with}\ \bar N_1 \sqsubseteq \mathsf{rec}\ M_2\ \mathsf{with}\ \bar N_2}\;({\sqsubseteq}.\mathsf{rec}_{\mathsf{skeleton}}) \\[1em]
\frac{M_1 \sqsubseteq M_2 \quad \bar M_1 \sqsubseteq \bar M_2}{M_1.d_i(\bar M_1) \sqsubseteq M_2.d_i(\bar M_2)}\;({\sqsubseteq}.d) \\[1em]
\frac{\bar M_1 \sqsubseteq \bar M_2 \quad \bar P_1 \sqsubseteq \bar P_2}{\mathsf{corec}\ \mathsf{from}\ \bar M_1\ \mathsf{with}\ \bar P_1 \sqsubseteq \mathsf{corec}\ \mathsf{from}\ \bar M_2\ \mathsf{with}\ \bar P_2}\;({\sqsubseteq}.\mathsf{corec}) \\[1em]
\frac{}{() \sqsubseteq ()}\;({\sqsubseteq}_{\bar M}.\varepsilon) \\[1em]
\frac{M_1 \sqsubseteq M_2 \quad \bar M_1 \sqsubseteq \bar M_2}{(M_1,\ \bar M_1) \sqsubseteq (M_2,\ \bar M_2)}\;({\sqsubseteq}_{\bar M}.{,}) \\[1em]
\frac{}{() \sqsubseteq ()}\;({\sqsubseteq}_{\bar N}.\varepsilon) \\[1em]
\frac{\begin{gathered}{}\forall j.\ k_{1j} = \bot \text{ or } k_{1j} = k_{2j} \\ N_1 \sqsubseteq N_2 \\ \bar N_1 \sqsubseteq \bar N_2\end{gathered}}{((\bar x;\ \bar y \leftarrow \bar k_1).\, N_1,\ \bar N_1) \sqsubseteq ((\bar x;\ \bar y \leftarrow \bar k_2).\, N_2,\ \bar N_2)}\;({\sqsubseteq}_{\bar N}.{,}) \\[1em]
\frac{}{() \sqsubseteq ()}\;({\sqsubseteq}_{\bar P}.\varepsilon) \\[1em]
\frac{\begin{gathered}{}k_1 = k_2 \text{ or } k_1 = \text{↯}_n \text{ and } k_2 = n \\ P_1 \sqsubseteq P_2 \\ \bar P_1 \sqsubseteq \bar P_2\end{gathered}}{((\bar y;\ \bar z \circlearrowleft k_1).\, P_1,\ \bar P_1) \sqsubseteq ((\bar y;\ \bar z \circlearrowleft k_2).\, P_2,\ \bar P_2)}\;({\sqsubseteq}_{\bar P}.{,})
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

The erasure states nothing on the ownership: it follows the grades of the usage alone, which the ownership reads without deciding what is erased, and what the ownership of a term guarantees of its erasure, the uses of a value during a run, needs the [evaluation](17-evaluation.md) of the target language.
