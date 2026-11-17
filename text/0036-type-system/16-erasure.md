# Erasure

This annex defines the erasure, which compiles a term to an untyped target language by replacing with $`\text{↯}`$ the parts whose grade is in a set of grades, the usage and the ownership of the target language, and their properties.
It builds on the [grades](04-grades.md), the [modes](05-modes.md), the [syntax](08-syntax.md), the [vectors of multiplicities](10-grade-vectors.md#vectors-of-multiplicities), the [sets of grades](11-grade-sets.md), the [usage](12-usage.md), the [ownership](13-ownership.md) and the fields of a block, which the [typing](14-typing.md#fields-of-a-block) marks.

## Definitions

The target language has variables, all of the first order, the constants at the qualities and the grades of their instances, a value $`\text{↯}`$ that stands for what was erased, the constructors, by their case in their block, applied to terms for their fields, the recursors, at a multiplicity, with a branch for each constructor, the observations by a destructor, by its case in its block, applied to terms for its arguments, with the ownership of the result of the destructor, and the corecursors, with a state and a branch for each destructor, each term of the fields, of the arguments and of the state at a multiplicity and at a requirement:

```math
\begin{aligned}
& {\mathrel{::=}} &&(\mathsf{syntax}_M) \\
& \quad M \\
& \quad {\mid} \\
& \qquad x \\
& \qquad f.\{\bar s;\ \bar p\} \\
& \qquad \text{↯} \\
& \qquad c_i(\bar M) \\
& \qquad \mathsf{rec}_\rho\ M \mathrel{◀} \varrho\ \mathsf{with}\ \bar N \\
& \qquad M.d_i(\bar M) \mathrel{◀} \psi \mathrel{◀} \varsigma \\
& \qquad \mathsf{corec}\ \mathsf{from}\ \bar M\ \mathsf{with}\ \bar P \\[1em]
& \bar M \mathrel{::=} () \mid (M \mathrel{▶} \pi \mathrel{◀} \varrho,\ \bar M) &&(\mathsf{syntax}_{\bar M}) \\[1em]
& \bar N \mathrel{::=} () \mid ((\bar x \mathrel{▶} \bar\pi \mathrel{◀} \bar\kappa;\ \bar y \mathrel{▶} \bar\pi' \leftarrow \bar w).\, N,\ \bar N) &&(\mathsf{syntax}_{\bar N}) \\[1em]
& \bar P \mathrel{::=} () \mid ((\bar y \mathrel{▶} \bar\pi \mathrel{◀} \bar\varrho;\ \bar z \mathrel{▶} \bar\pi' \mathrel{◀} \bar\varrho' \circlearrowleft k \mathrel{◀} \psi \mathrel{◀} \varsigma).\, P,\ \bar P) &&(\mathsf{syntax}_{\bar P}) \\[1em]
& w \mathrel{::=} \bot \mid n \mid n.\Xi &&(\mathsf{syntax}_w) \\[1em]
& {\mathrel{::=}} &&(\mathsf{syntax}_\Xi) \\
& \quad \Xi \\
& \quad {\mid} \\
& \qquad () \\
& \qquad ((i,\ \rho,\ \bar\pi \mathrel{◀} \bar\varrho,\ \bar\pi' \mathrel{◀} \bar\varrho',\ \psi,\ \varsigma,\ \psi_0,\ \varsigma_0,\ \Upsilon),\ \Xi) \\[1em]
& \Upsilon \mathrel{::=} \star_M \mid \Xi &&(\mathsf{syntax}_\Upsilon) \\[1em]
& k \mathrel{::=} \bot \mid n \mid \text{↯}_n &&(\mathsf{syntax}_k)
\end{aligned}
```

A branch $`{(\bar x \mathrel{▶} \bar\pi \mathrel{◀} \bar\kappa;\ \bar y \mathrel{▶} \bar\pi' \leftarrow \bar w).\, N}`$ binds the variables $`\bar x`$ of the fields and $`\bar y`$ of the recursive results, as a branch of a recursor does, at the [multiplicities](03-multiplicities.md) $`\bar\pi`$ and $`\bar\pi'`$, which count their uses at run time, each variable of a field with the coefficient $`\kappa`$ of its ownership, a multiplicity, which multiplies the ownership at run time of the term of the recursor, and $`\bar w`$ gives each recursive result what computes it: the position $`n`$ of its field among $`\bar x`$, the first one at $`1`$, when the recursor on the field computes it, $`n.\Xi`$ when the field at the position $`n`$ is nested and the result is the corecursor of a lifting of the shape $`\Xi`$, which the evaluation builds from the branches of the recursor, as the rule $`(\mathsf{res}_D)`$ of the [terms of the results](21-recursive-results.md#terms-of-the-results) builds it from the observations of the field, or $`\bot`$ when the result is erased, so that it is not computed.
A shape $`\Xi`$ gives, for each destructor that the lifting keeps, in order, without the terms of its branch, what the evaluation needs to build this branch: the case $`i`$ of the destructor that it lifts in its block, its multiplicity $`\rho`$ at run time, the multiplicities and the requirements $`{\bar\pi \mathrel{◀} \bar\varrho}`$ of its arguments in the observation of the field and $`{\bar\pi' \mathrel{◀} \bar\varrho'}`$ in the lifted destructor, the ownership $`\psi`$ of the result of the lifted destructor and the ownership $`\varsigma`$ that it requires of the value that it observes, the same ownerships $`\psi_0`$ and $`\varsigma_0`$ of the destructor that it lifts, which the observation of the field reads, and the shape $`\Upsilon`$ of its result.
The shape of a result is $`\star_M`$ when the type lifted is a motive, so that the result is the recursor itself, where $`M`$ is the skeleton of the motive, on which the recursor of the multiplicity $`0`$ runs instead of the observation, and the shape $`\Xi`$ of the next lifting when the type lifted is an instance of a lifting, two levels of nesting deep or more.
A branch $`{(\bar y \mathrel{▶} \bar\pi \mathrel{◀} \bar\varrho;\ \bar z \mathrel{▶} \bar\pi' \mathrel{◀} \bar\varrho' \circlearrowleft k \mathrel{◀} \psi \mathrel{◀} \varsigma).\, P}`$ binds the variables $`\bar y`$ of the state and $`\bar z`$ of the arguments, as a branch of a corecursor does, at the multiplicities $`\bar\pi`$ and $`\bar\pi'`$ and at the requirements $`\bar\varrho`$ and $`\bar\varrho'`$ of their entries, $`\psi`$ is the ownership of the result of its destructor, $`\varsigma`$ the ownership that its destructor requires of the value that it observes, and $`k`$ is its resumption: $`\bot`$ when its destructor is not recursive, the number $`n`$ of the entries of the state that the branch resumes, which the evaluation unpacks from the new state, or $`\text{↯}_n`$ when these $`n`$ entries are erased, so that the evaluation does not read the new state.
A term $`{M \mathrel{▶} \pi \mathrel{◀} \varrho}`$ of a field, of an argument or of the state is stored at the multiplicity $`\pi`$ of its position, which bounds the uses of its value through this position, and at the requirement $`\varrho`$ of its position, a multiplicity, which the ownership at run time of its value satisfies, and a recursor $`{\mathsf{rec}_\rho\ M \mathrel{◀} \varrho\ \mathsf{with}\ \bar N}`$ uses the value of $`M`$ at the multiplicity $`\rho`$, so that a branch reads each field within $`\rho`$ times its multiplicity, and its branches assume of the term of each level of the recursion the ownership of $`M`$ times the requirement $`\varrho`$ of its recursion, which is within the requirement times the uses of each recursive field that a recursion eliminates: a value is computed once, but a cell of the multiplicity $`\omega`$ may read it several times, and each observation of a closure runs a branch again, which the multiplicities of the positions bound.
The ownerships of the target language are those at run time, multiplicities, since the projection on the run-time multiplicity keeps the product and the meet of the grades: the ownership $`\psi`$ of the result of a destructor has the [syntax](08-syntax.md) of the ownership of the result of a second-order variable, with multiplicities as its constant and its coefficients, and $`\psi_\bot`$ is the ownership without constant and without factor; the requirement $`\varsigma`$ of a destructor on the value that it observes is a multiplicity.
The multiplicities $`\bar\pi(\bar M)`$ and the requirements $`\bar\varrho(\bar M)`$ of terms are those at which they are stored, in order:

```math
\begin{aligned}
& \bar\pi(()) = () &&(\mathsf{multiplicities}_{\bar M}) \\
& \bar\pi((M \mathrel{▶} \pi \mathrel{◀} \varrho,\ \bar M)) = (\pi,\ \bar\pi(\bar M)) \\[1em]
& \bar\varrho(()) = () &&(\mathsf{requirements}_{\bar M}) \\
& \bar\varrho((M \mathrel{▶} \pi \mathrel{◀} \varrho,\ \bar M)) = (\varrho,\ \bar\varrho(\bar M))
\end{aligned}
```

The factor $`\mathsf{factor}(\Xi)`$ of a shape is the multiplicity by which the uses of the scope of the recursor by the result that it shapes are multiplied, as the [factor](20-liftings.md#factors) of a lifting is: the meet of the multiplicities at run time of its destructors times the factors of their results, $`0`$ without destructor, since the result is then never observed, and $`1`$ for the recursor itself; the factor of a recursive result is $`0`$ when it is erased, $`1`$ when the recursor on its field computes it, and the factor of its shape when it is nested:

```math
\begin{aligned}
& \mathsf{factor}(()) = 0 &&(\mathsf{factor}_\Xi) \\
& \mathsf{factor}(((i,\ \rho',\ \bar\pi \mathrel{◀} \bar\varrho,\ \bar\pi' \mathrel{◀} \bar\varrho',\ \psi,\ \varsigma,\ \psi_0,\ \varsigma_0,\ \Upsilon),\ ())) = \rho' \cdot \mathsf{factor}(\Upsilon) \\
& {=} \text{ if } \Xi \ne () \\
& \quad \mathsf{factor}(((i,\ \rho',\ \bar\pi \mathrel{◀} \bar\varrho,\ \bar\pi' \mathrel{◀} \bar\varrho',\ \psi,\ \varsigma,\ \psi_0,\ \varsigma_0,\ \Upsilon),\ \Xi)) \\
& \quad (\rho' \cdot \mathsf{factor}(\Upsilon)) \wedge \mathsf{factor}(\Xi) \\[1em]
& \mathsf{factor}(\star_M) = 1 &&(\mathsf{factor}_\Upsilon) \\[1em]
& \mathsf{factor}(\bot) = 0 &&(\mathsf{factor}_w) \\
& \mathsf{factor}(n) = 1 \\
& \mathsf{factor}(n.\Xi) = \mathsf{factor}(\Xi)
\end{aligned}
```

A shape fits the recursor of the multiplicity $`\rho`$, written $`{\Xi \text{ fits } \rho}`$, when the multiplicity at run time of each argument of each lifted destructor is within $`\rho`$ times the multiplicity at run time of the destructor times the factor of its result times the multiplicity of the argument in the observation, at every depth, as a lifting scales the arguments of the destructors that it lifts, since the observation by the lifted destructor reads its arguments as many times as the recursor reads the observation that it builds, and a destructor never observed reads none:

```math
\begin{aligned}
& () \text{ fits } \rho &&(\mathsf{fits}_\Xi) \\[1em]
& {\iff} \\
& \quad ((i,\ \rho',\ \bar\pi \mathrel{◀} \bar\varrho,\ \bar\pi' \mathrel{◀} \bar\varrho',\ \psi,\ \varsigma,\ \psi_0,\ \varsigma_0,\ \Upsilon),\ \Xi) \text{ fits } \rho \\
& \quad \text{and} \\
& \qquad \forall k \le |\bar\pi'|.\ \pi'_k \le (\rho \cdot (\rho' \cdot \mathsf{factor}(\Upsilon))) \cdot \pi_k \\
& \qquad \Upsilon \text{ fits } \rho \\
& \qquad \Xi \text{ fits } \rho \\[1em]
& \star_M \text{ fits } \rho &&(\mathsf{fits}_\Upsilon)
\end{aligned}
```

The branches $`\mathsf{branches}_{\rho, \varrho}(\Xi,\ O,\ \bar N)`$ built from the shape $`\Xi`$, for the recursor of the multiplicity $`\rho`$, of the requirement $`\varrho`$ of its recursion and of the branches $`\bar N`$, on the observations of the term $`O`$, the path from the field, are a branch for each destructor of the shape, without state, which binds new variables $`\bar z`$ for its arguments, observes $`O`$ by the destructor that it lifts at these arguments, each at the multiplicity and at the requirement of its argument in the observation, or $`\text{↯}`$ at the multiplicity $`0`$, since a value of this multiplicity is never read and must be a skeleton, and gives the result $`\mathsf{body}_{\rho, \varrho}(\Upsilon,\ O',\ \bar N)`$ of this observation $`O'`$, or $`\text{↯}`$ when the destructor is never observed at run time.
This result is the recursor on the observation, for $`\star_M`$, or the recursor of the multiplicity $`0`$ on the skeleton $`M`$ of the motive when $`\rho`$ is $`0`$, as the erasure of a recursor on an erased term, and the corecursor without state of the next lifting, whose branches observe $`O'`$ in turn, for a shape $`\Xi`$.
The term $`\mathsf{nested}_{\rho, \varrho}(x,\ \Xi,\ \bar N)`$ of a nested result, at run time, is the corecursor without state of its shape, whose branches observe the field, the variable $`x`$, so that its scope is the scope of the recursor with $`x`$:

```math
\begin{aligned}
& \mathsf{branches}_{\rho, \varrho}((),\ O,\ \bar N) = () &&(\mathsf{branches}_\Xi) \\[1em]
& {=} \\
& \quad \mathsf{branches}_{\rho, \varrho}(((i,\ \rho',\ \bar\pi \mathrel{◀} \bar\varrho,\ \bar\pi' \mathrel{◀} \bar\varrho',\ \psi,\ \varsigma,\ \psi_0,\ \varsigma_0,\ \Upsilon),\ \Xi),\ O,\ \bar N) \\
& \quad ((() \mathrel{▶} () \mathrel{◀} ();\ \bar z \mathrel{▶} \bar\pi' \mathrel{◀} \bar\varrho' \circlearrowleft \bot \mathrel{◀} \psi \mathrel{◀} \varsigma).\, P,\ \mathsf{branches}_{\rho, \varrho}(\Xi,\ O,\ \bar N)) \\
& \quad \text{where} \\
& \qquad \text{and} \\
& \qquad \quad P = \text{↯} \text{ if } \rho' = 0 \\
& \qquad \quad P = \mathsf{body}_{\rho, \varrho}(\Upsilon,\ O.d_i(\bar M) \mathrel{◀} \psi_0 \mathrel{◀} \varsigma_0,\ \bar N) \text{ otherwise} \\
& \qquad \quad \bar M = (M_1 \mathrel{▶} \pi_1 \mathrel{◀} \varrho_1,\ \dots,\ M_c \mathrel{▶} \pi_c \mathrel{◀} \varrho_c) \\
& \qquad \quad M_k = \text{↯} \text{ if } \pi_k = 0 \\
& \qquad \quad M_k = z_k \text{ otherwise} \\
& \qquad \quad \bar z = z_1, \dots, z_c \text{ do not occur in } O \text{ nor in } \bar N \\[1em]
& \mathsf{body}_{\rho, \varrho}(\star_M,\ O,\ \bar N) = \mathsf{rec}_\rho\ O \mathrel{◀} \varrho\ \mathsf{with}\ \bar N \text{ if } \rho \ne 0 &&(\mathsf{body}_\Upsilon) \\
& \mathsf{body}_{\rho, \varrho}(\star_M,\ O,\ \bar N) = \mathsf{rec}_0\ M \mathrel{◀} \varrho\ \mathsf{with}\ \bar N \text{ if } \rho = 0 \\
& \mathsf{body}_{\rho, \varrho}(\Xi,\ O,\ \bar N) = \mathsf{corec}\ \mathsf{from}\ ()\ \mathsf{with}\ \mathsf{branches}_{\rho, \varrho}(\Xi,\ O,\ \bar N) \\[1em]
& \mathsf{nested}_{\rho, \varrho}(x,\ \Xi,\ \bar N) = \mathsf{corec}\ \mathsf{from}\ ()\ \mathsf{with}\ \mathsf{branches}_{\rho, \varrho}(\Xi,\ x,\ \bar N) &&(\mathsf{nested}_\Xi)
\end{aligned}
```

The target language keeps only what its [evaluation](17-evaluation.md) reads: the multiplicity of a binder goes with each variable that the evaluation binds, the multiplicity of a position with each value that the evaluation stores, the requirement of a position, the coefficient or the requirement of a binder and the ownership of the result of a destructor with what the evaluation checks of the ownerships, a case chooses a branch, since the names of the constructors and of the destructors are distinct only in their type, and a branch does not bind the non-uniform parameters, which the corecursors do not have yet.

The erasure $`\lfloor t \rfloor_S`$ of a term $`t`$ replaces with $`\text{↯}`$ each position of $`t`$ whose grade is in the set $`S`$, a position being a subterm that a rule of usage checks with a grade of its own, as an argument $`t_j`$ of an entry of grade $`p_j`$ in $`{(\mathsf{tel}_{,▶})}`$.
It is defined on the terms whose scope has no second-order variable: a program is closed, and the motives and the branches of a recursor and the states and the branches of a corecursor bind variables only, while a second-order variable exists only in the contexts in which a declaration is checked, so that a variable has no arguments, and the target language no second-order variables.
It is defined in a signature $`\Sigma`$, which gives the grades and the requirements of the fields of the constructors and of the arguments of the destructors, the grades of the destructors, the ownerships of their results, and the positions of the codata types in their blocks, and which the notation leaves implicit, as the rules of usage read their grades in the signature.

The parameters $`\mathsf{parameters}_\Sigma(T.c)`$ of the fields of the constructor $`c`$ of an instance $`{T = D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a}`$ are the parameters of its telescope $`\Theta`$ at the instance $`\bar s`$, $`\bar p`$, in the last entry of $`\Sigma`$ that declares a type $`D`$ with a constructor $`c`$ and as many sort and grade variables as $`\bar s`$ and $`\bar p`$, and none when $`\Sigma`$ has no such entry:

```math
\begin{aligned}
& \mathsf{parameters}_\Sigma(T.c) = \text{the parameters of } \Theta &&(\mathsf{parameters}_c) \\
& \quad \text{if} \\
& \qquad \mathsf{data}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa \\
& \qquad \quad \mathsf{where} \\
& \qquad \qquad \dots; \\
& \qquad \qquad D \mathrel{▶} \zeta \oplus \Pi \mathrel{≔} \dots \mid c : \Theta \mid \dots; \\
& \qquad \qquad \dots \\
& \qquad \quad \text{is this entry} \\[1em]
& \mathsf{parameters}_\Sigma(T.c) = () \text{ if } \Sigma \text{ has no such entry}
\end{aligned}
```

The parameters $`\mathsf{parameters}_\Sigma(T.d)`$ of the destructor $`d`$ of an instance $`{T = D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a}`$ are the parameters of its telescope $`\Theta`$, the ownership $`\psi`$ of its result and the ownership $`\varsigma`$ that it requires of the value that it observes at the instance $`\bar s`$, $`\bar p`$, in the last entry of $`\Sigma`$ that declares a type $`D`$ with a destructor $`d`$ and as many sort and grade variables as $`\bar s`$ and $`\bar p`$, and no parameter, an ownership without constant and without factor and the requirement $`{\omega\omega}^{\mathsf{p}}`$, which states nothing, when $`\Sigma`$ has no such entry:

```math
\begin{aligned}
& \mathsf{parameters}_\Sigma(T.d) = (\text{the parameters of } \Theta,\ \psi,\ \varsigma) &&(\mathsf{parameters}_d) \\
& \quad \text{if} \\
& \qquad \mathsf{codata}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa \\
& \qquad \quad \mathsf{where} \\
& \qquad \qquad \dots; \\
& \qquad \qquad D \mathrel{▶} \zeta \oplus \Pi \mathrel{≔} \dots \mid d : (\Theta \vdash B \mathrel{◀} \psi) \mathrel{▶} p;\ q \mathrel{◀} \varsigma \mid \dots; \\
& \qquad \qquad \dots \\
& \qquad \quad \text{is this entry} \\[1em]
& \mathsf{parameters}_\Sigma(T.d) = ((),\ \psi_\bot,\ {\omega\omega}^{\mathsf{p}}) \text{ if } \Sigma \text{ has no such entry}
\end{aligned}
```

The grades $`\mathsf{grades}_\Sigma(T.\bar g)`$ of the branches of a corecursor of an instance $`{T = D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a}`$ are the grades of the destructors of the block of $`D`$ at the instance $`\bar s`$, $`\bar p`$, in the order of the declaration, which is that of the branches, in the last entry of $`\Sigma`$ that declares a type $`D`$ and as many sort and grade variables as $`\bar s`$ and $`\bar p`$, and none when $`\Sigma`$ has no such entry:

```math
\begin{aligned}
& \mathsf{grades}_\Sigma(T.\bar g) = p_{11}, \dots, p_{kn_k} &&(\mathsf{grades}_{\bar g}) \\
& \quad \text{if} \\
& \qquad \text{and} \\
& \qquad \quad \mathsf{codata}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa \\
& \qquad \qquad \mathsf{where} \\
& \qquad \qquad \quad D_1 \mathrel{▶} \zeta_1 \oplus \Pi_1 \mathrel{≔} \bar d_1; \\
& \qquad \qquad \quad \dots; \\
& \qquad \qquad \quad D_k \mathrel{▶} \zeta_k \oplus \Pi_k \mathrel{≔} \bar d_k \\
& \qquad \qquad \text{is this entry} \\
& \qquad \quad D = D_h \\
& \qquad \quad d_{ji} : (\Theta_{ji} \vdash B_{ji} \mathrel{◀} \psi_{ji}) \mathrel{▶} p_{ji};\ q_{ji} \mathrel{◀} \varsigma_{ji} \text{ in } \bar d_j \\[1em]
& \mathsf{grades}_\Sigma(T.\bar g) = () \text{ if } \Sigma \text{ has no such entry}
\end{aligned}
```

The position $`\mathsf{position}_\Sigma(D)`$ of the declared type $`D`$ is its index $`h`$ in the last entry of $`\Sigma`$ that declares it, $`{D_1 \mathrel{▶} \zeta_1 \oplus \Pi_1 \mathrel{≔} \dots;\ \dots;\ D_k \mathrel{▶} \zeta_k \oplus \Pi_k \mathrel{≔} \dots}`$ with $`{D = D_h}`$, and none when $`\Sigma`$ has no such entry:

```math
\begin{aligned}
& \mathsf{position}_\Sigma(D) = h \text{ if } D = D_h \text{ in this entry} &&(\mathsf{position}_D)
\end{aligned}
```

The case $`\mathsf{case}_\Sigma(D.c)`$ of the constructor $`c`$ of the type $`D`$ is its position $`i`$ among the constructors of the types of its block, in the order of the declaration, which is that of the branches of a recursor, in the last entry of $`\Sigma`$ that declares a type $`D`$ with a constructor $`c`$, and none when $`\Sigma`$ has no such entry; the case $`\mathsf{case}_\Sigma(D.d)`$ of a destructor is its position among the destructors of the types of its block, likewise:

```math
\begin{aligned}
& \mathsf{case}_\Sigma(D.c) = i &&(\mathsf{case}_c) \\
& \quad \text{if} \\
& \qquad c_i \text{ is the constructor } c \text{ of } D \text{ in} \\
& \qquad \quad \mathsf{data}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa \\
& \qquad \qquad \mathsf{where} \\
& \qquad \qquad \quad D_1 \mathrel{▶} \zeta_1 \oplus \Pi_1 \mathrel{≔} c_1 : \Theta_1 \mid \dots; \\
& \qquad \qquad \quad \dots; \\
& \qquad \qquad \quad D_k \mathrel{▶} \zeta_k \oplus \Pi_k \mathrel{≔} \dots \mid c_n : \Theta_n \\[1em]
& \mathsf{case}_\Sigma(D.d) = i &&(\mathsf{case}_d) \\
& \quad \text{if} \\
& \qquad d_i \text{ is the destructor } d \text{ of } D \text{ in} \\
& \qquad \quad \mathsf{codata}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa \\
& \qquad \qquad \mathsf{where} \\
& \qquad \qquad \quad D_1 \mathrel{▶} \zeta_1 \oplus \Pi_1 \mathrel{≔} d_1 : \dots \mid \dots; \\
& \qquad \qquad \quad \dots; \\
& \qquad \qquad \quad D_k \mathrel{▶} \zeta_k \oplus \Pi_k \mathrel{≔} \dots \mid d_n : \dots
\end{aligned}
```

The recursive fields $`\mathsf{recursive}_\Sigma(T)`$ of an instance $`{T = D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a}`$ give, for each constructor of the block of $`D`$, in the order of the declaration, the positions of its fields whose types are instances of a type of the block, which $`\mathsf{rec}_{\mathcal{D}}(\Theta)`$, defined with the [fields of a block](14-typing.md#fields-of-a-block), marks, at the instance $`\bar s`$, $`\bar p`$, in the last entry of $`\Sigma`$ that declares a type $`D`$ and as many sort and grade variables as $`\bar s`$ and $`\bar p`$, and none when $`\Sigma`$ has no such entry:

```math
\begin{aligned}
& \mathsf{recursive}_\Sigma(T) = \bar k_1, \dots, \bar k_n &&(\mathsf{recursive}_c) \\
& \quad \text{if} \\
& \qquad \text{and} \\
& \qquad \quad c_1 : \Theta_1,\ \dots,\ c_n : \Theta_n \text{ are the constructors of this entry} \\
& \qquad \quad \bar k_i \text{ the positions } j \text{ at which } \mathsf{rec}_{\mathcal{D}}(\Theta_i) \ne \bot \\[1em]
& \mathsf{recursive}_\Sigma(T) = () \text{ if } \Sigma \text{ has no such entry}
\end{aligned}
```

The resumed types $`\mathsf{resumed}_\Sigma(T)`$ of an instance $`{T = D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a}`$ give, for each destructor of the block of $`D`$, in the order of the declaration, the position in the block of the type of its result, when it is recursive, or $`\bot`$, at the instance $`\bar s`$, $`\bar p`$, in the last entry of $`\Sigma`$ that declares a type $`D`$ and as many sort and grade variables as $`\bar s`$ and $`\bar p`$, and none when $`\Sigma`$ has no such entry:

```math
\begin{aligned}
& \mathsf{resumed}_\Sigma(T) = h_1, \dots, h_n &&(\mathsf{resumed}_d) \\
& \quad \text{if} \\
& \qquad \text{and} \\
& \qquad \quad d_1 : (\Theta_1 \vdash B_1 \mathrel{◀} \psi_1),\ \dots,\ d_n : (\Theta_n \vdash B_n \mathrel{◀} \psi_n) \text{ are the destructors of this entry} \\
& \qquad \quad h_i \text{ is the position of } \mathsf{rec}_{\mathcal{D}}(B_i) \text{ in the block, or } \bot \text{ when } \mathsf{rec}_{\mathcal{D}}(B_i) = \bot \\[1em]
& \mathsf{resumed}_\Sigma(T) = () \text{ if } \Sigma \text{ has no such entry}
\end{aligned}
```

The parameters $`\mathsf{parameters}_\Sigma(T.\bar u)`$ of the branches of a recursor of an instance $`{T = D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a}`$ give, for each constructor of the block of $`D`$, in the order of the declaration, the parameters of its telescope, at the instance $`\bar s`$, $`\bar p`$, in the last entry of $`\Sigma`$ that declares a type $`D`$ and as many sort and grade variables as $`\bar s`$ and $`\bar p`$, and none when $`\Sigma`$ has no such entry:

```math
\begin{aligned}
& \mathsf{parameters}_\Sigma(T.\bar u) = \bar q_1 \mathrel{◀} \bar r_1, \dots, \bar q_n \mathrel{◀} \bar r_n &&(\mathsf{parameters}_{\bar u}) \\
& \quad \text{if} \\
& \qquad \text{and} \\
& \qquad \quad c_1 : \Theta_1,\ \dots,\ c_n : \Theta_n \text{ are the constructors of this entry} \\
& \qquad \quad \bar q_i \mathrel{◀} \bar r_i \text{ the parameters of } \Theta_i \\[1em]
& \mathsf{parameters}_\Sigma(T.\bar u) = () \text{ if } \Sigma \text{ has no such entry}
\end{aligned}
```

The requirement $`\mathsf{recursion}_\Sigma(T, r)`$ of the recursion of a recursor of the grade $`r`$ on an instance $`T`$ is the requirement $`\hat r`$ that the [ownership](13-ownership.md#definitions) of the recursor gives the term at each level of the recursion, in the mode $`{11}^{\mathsf{m}}`$, read from its recursive fields and the parameters of their entries, a field without parameter, in a term that no rule types, giving the pair $`{{11}^{\mathsf{p}} \mathrel{◀} {\omega\omega}^{\mathsf{p}}}`$, which states nothing:

```math
\begin{aligned}
& \mathsf{recursion}_\Sigma(T, r) = \mathsf{recursion}(\{r \cdot q_{il} \mathrel{◀} r_{il} \mid l \in \bar k_i\}) &&(\mathsf{recursion}_c) \\
& \quad \text{where} \\
& \qquad \text{and} \\
& \qquad \quad \mathsf{recursive}_\Sigma(T) = \bar k_1, \dots, \bar k_n \\
& \qquad \quad \mathsf{parameters}_\Sigma(T.\bar u) = \bar q_1 \mathrel{◀} \bar r_1, \dots, \bar q_n \mathrel{◀} \bar r_n
\end{aligned}
```

The arguments $`\mathsf{arguments}_\Sigma(T.\bar g)`$ of the branches of a corecursor of an instance $`{T = D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a}`$ give, for each destructor of the block of $`D`$, in the order of the declaration, the position $`j`$ in the block of its type $`D_j`$, whose state the branch binds, the parameters of its telescope, the ownership of its result and the ownership that it requires of the value that it observes, at the instance $`\bar s`$, $`\bar p`$, in the last entry of $`\Sigma`$ that declares a type $`D`$ and as many sort and grade variables as $`\bar s`$ and $`\bar p`$, and none when $`\Sigma`$ has no such entry:

```math
\begin{aligned}
& \mathsf{arguments}_\Sigma(T.\bar g) = (j_1,\ \bar q_1 \mathrel{◀} \bar r_1,\ \psi_1,\ \varsigma_1), \dots, (j_n,\ \bar q_n \mathrel{◀} \bar r_n,\ \psi_n,\ \varsigma_n) &&(\mathsf{arguments}_{\bar g}) \\
& \quad \text{if} \\
& \qquad \text{and} \\
& \qquad \quad d_1 : (\Theta_1 \vdash B_1 \mathrel{◀} \psi_1) \mathrel{▶} p_1;\ q_1 \mathrel{◀} \varsigma_1, \\
& \qquad \quad \dots, \\
& \qquad \quad d_n : (\Theta_n \vdash B_n \mathrel{◀} \psi_n) \mathrel{▶} p_n;\ q_n \mathrel{◀} \varsigma_n \\
& \qquad \qquad \text{are the destructors of this entry} \\
& \qquad \quad d_i \text{ a destructor of } D_{j_i} \\
& \qquad \quad \bar q_i \mathrel{◀} \bar r_i \text{ the parameters of } \Theta_i \\[1em]
& \mathsf{arguments}_\Sigma(T.\bar g) = () \text{ if } \Sigma \text{ has no such entry}
\end{aligned}
```

The skeleton $`\mathsf{skeleton}_\Sigma(T)`$ of an instance $`{T = D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a}`$ is the term of the target language that the type $`D`$ gives to its closed terms when each type of its block has one constructor at most: the constructor of the case of the only constructor of $`D`$, applied to $`\text{↯}`$ for each field that is not recursive and to the skeleton of the type of each recursive field, each at the multiplicity $`0`$, since a skeleton holds no value that a use at run time reads, and at the requirement $`\omega`$, which states nothing, and $`\text{↯}`$ when $`D`$ has no constructor or several.
It is built within the depth $`k`$ of the number of the types of the block, at the instance $`\bar s`$, $`\bar p`$, in the last entry of $`\Sigma`$ that declares a type $`D`$ and as many sort and grade variables as $`\bar s`$ and $`\bar p`$, and is $`\text{↯}`$ when $`\Sigma`$ has no such entry:

```math
\begin{aligned}
& \mathsf{skeleton}_\Sigma(T) = \mathsf{skeleton}^k(D) &&(\mathsf{skeleton}_D) \\
& \quad \text{if} \\
& \qquad \mathsf{data}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa \\
& \qquad \quad \mathsf{where} \\
& \qquad \qquad D_1 \mathrel{▶} \zeta_1 \oplus \Pi_1 \mathrel{≔} \bar c_1; \\
& \qquad \qquad \dots; \\
& \qquad \qquad D_k \mathrel{▶} \zeta_k \oplus \Pi_k \mathrel{≔} \bar c_k \\
& \qquad \quad \text{is this entry} \\[1em]
& \mathsf{skeleton}_\Sigma(T) = \text{↯} \text{ if } \Sigma \text{ has no such entry} \\[1em]
& \mathsf{skeleton}^0(D_j) = \text{↯} \\[1em]
& \mathsf{skeleton}^{n + 1}(D_j) = c_i(M_1 \mathrel{▶} 0 \mathrel{◀} \omega, \dots, M_a \mathrel{▶} 0 \mathrel{◀} \omega) \\
& \quad \text{if} \\
& \qquad \text{and} \\
& \qquad \quad \bar c_j = (c : \Theta) \\
& \qquad \quad i = \mathsf{case}_\Sigma(D_j.c) \\
& \qquad \quad \Theta \text{ has } a \text{ entries} \\[1em]
& \mathsf{skeleton}^{n + 1}(D_j) = \text{↯} \text{ otherwise}
\end{aligned}
```

In the skeleton of a constructor $`{c : \Theta}`$, $`M_l`$ is $`\mathsf{skeleton}^n(D')`$ when the element $`l`$ of $`\mathsf{rec}_{\mathcal{D}}(\Theta)`$, defined with the [fields of a block](14-typing.md#fields-of-a-block), is a type $`D'`$ of the block, and $`\text{↯}`$ when it is $`\bot`$.
The depth is reached only on a type without closed term: along a path of a closed term, from a term to the term of one of its recursive fields, no type of the block comes twice, since each type has one constructor, so that the term would hold a term of the same form, without end.

The sorts and the instances have no representation in the target language, and are erased.
A constructor keeps its case and its fields, each erased at the grade of its field and stored at the multiplicity at run time of this grade and at the requirement at run time of its requirement, and a field whose parameter the signature does not give, in a term that no rule types, is erased, and stored at $`\omega`$ and at the requirement $`\omega`$, which state nothing, as a constructor whose case it does not give is erased; a recursor keeps the multiplicity at run time of its grade $`r`$, its term and the requirement at run time of its recursion when $`r`$ is not in $`S`$, and the skeleton of the type of its term and the requirement $`\omega`$ otherwise, which states nothing, since the variables of the fields of the skeleton have the ownership $`0`$ whatever the ownership of the term, and its branches, which keep, for each recursive result, the position of its field, or $`\bot`$ when its grade is in $`S`$, and loses its instance and its motives, which are types.
An observation keeps its term, the case of its destructor, the ownership at run time of the result of its destructor, $`\mathsf{run}(\psi)`$, which applies $`\mathsf{run}`$ to its constant and to its coefficients, the ownership at run time $`\mathsf{run}(\varsigma)`$ that its destructor requires of the value that it observes, and its arguments, each erased at the grade of its argument and stored at its multiplicity at run time and at its requirement at run time, and a corecursor keeps its state, each entry erased at its grade times the grade $`r`$ of the corecursor and stored at its multiplicity at run time, since every observation that reaches the state uses it $`r`$ times, and at its requirement at run time, and its branches, each erased at the grade of its destructor, since its usage checks it in the mode of this grade, with the number of the entries of the state it resumes, the ownership at run time of the result of its destructor and the ownership at run time that its destructor requires of the value that it observes, and loses its instance and its states, which are types; the parameters of the entries of the state are those of the state $`\Theta_h`$ of the type $`D_h`$ of its instance, with $`{h = \mathsf{position}_\Sigma(D)}`$, and an entry whose parameter is not given, in a term that no rule types, is erased.
The erasure $`{\lfloor t \rfloor_{S, p}}`$ of a position of grade $`p`$ is $`\text{↯}`$ when $`{p \in S}`$, and $`\lfloor t \rfloor_S`$ otherwise, and the erasure of terms at the parameters $`{\bar p \mathrel{◀} \bar r}`$ stores each at the multiplicity $`\mathsf{run}(p)`$ of its grade and at the requirement $`\mathsf{run}(r)`$ of its requirement:

```math
\begin{aligned}
& \lfloor x \rfloor_S = x &&(\mathsf{erase}_t) \\
& \lfloor \kappa \rfloor_S = \text{↯} \\
& \lfloor f.\{\bar s;\ \bar l;\ \bar p\} \rfloor_S = f.\{\bar s;\ \bar p\} \\
& \lfloor D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a \rfloor_S = \text{↯} \\
& \lfloor T.c(\bar t) \rfloor_S = c_i(\lfloor \bar t \rfloor_{S, \mathsf{parameters}_\Sigma(T.c)}) \text{ if } i = \mathsf{case}_\Sigma(D.c) \\
& \lfloor T.c(\bar t) \rfloor_S = \text{↯} \text{ otherwise} \\[1em]
& {=} \text{ if} \\
& \quad \lfloor \mathsf{rec}_{r;\ \varsigma;\ \chi}\ T\ t\ \mathsf{return}\ \bar C : \kappa_C\ \mathsf{with}\ \bar u \rfloor_S \\
& \quad \mathsf{rec}_{\mathsf{run}(r)}\ \mathsf{skeleton}_\Sigma(T) \mathrel{◀} \omega \\
& \qquad \mathsf{with}\ \lfloor \bar u \rfloor_{S, r, \mathsf{recursive}_\Sigma(T), \mathsf{parameters}_\Sigma(T.\bar u)} \\
& \quad r \in S \\[1em]
& {=} \text{ if} \\
& \quad \lfloor \mathsf{rec}_{r;\ \varsigma;\ \chi}\ T\ t\ \mathsf{return}\ \bar C : \kappa_C\ \mathsf{with}\ \bar u \rfloor_S \\
& \quad \mathsf{rec}_{\mathsf{run}(r)}\ \lfloor t \rfloor_S \mathrel{◀} \mathsf{run}(\mathsf{recursion}_\Sigma(T, r)) \\
& \qquad \mathsf{with}\ \lfloor \bar u \rfloor_{S, r, \mathsf{recursive}_\Sigma(T), \mathsf{parameters}_\Sigma(T.\bar u)} \\
& \quad r \notin S \\[1em]
& \lfloor t.(T.d)(\bar t) \rfloor_S = \lfloor t \rfloor_S.d_i(\lfloor \bar t \rfloor_{S, \bar q \mathrel{◀} \bar r}) \mathrel{◀} \mathsf{run}(\psi) \mathrel{◀} \mathsf{run}(\varsigma) \\
& \quad \text{if} \\
& \qquad \text{and} \\
& \qquad \quad i = \mathsf{case}_\Sigma(D.d) \\
& \qquad \quad (\bar q \mathrel{◀} \bar r,\ \psi,\ \varsigma) = \mathsf{parameters}_\Sigma(T.d) \\[1em]
& \lfloor t.(T.d)(\bar t) \rfloor_S = \text{↯} \text{ otherwise} \\[1em]
& {=} \text{ if} \\
& \quad \lfloor \mathsf{corec}_r\ T\ \mathsf{from}\ \bar t\ \mathsf{return}\ \bar\Theta\ \mathsf{with}\ \bar g \rfloor_S \\
& \quad \mathsf{corec} \\
& \qquad \mathsf{from}\ \lfloor \bar t \rfloor_{S, r \cdot \bar q \mathrel{◀} \bar r} \\
& \qquad \mathsf{with}\ \lfloor \bar g \rfloor_{S, \mathsf{grades}_\Sigma(T.\bar g), \bar k, \bar{\bar o}} \\
& \quad \text{and} \\
& \qquad \bar q \mathrel{◀} \bar r \text{ are the parameters of } \Theta_h \\
& \qquad h = \mathsf{position}_\Sigma(D) \\[1em]
& {=} \text{ otherwise} \\
& \quad \lfloor \mathsf{corec}_r\ T\ \mathsf{from}\ \bar t\ \mathsf{return}\ \bar\Theta\ \mathsf{with}\ \bar g \rfloor_S \\
& \quad \mathsf{corec}\ \mathsf{from}\ \lfloor \bar t \rfloor_{S, ()}\ \mathsf{with}\ \lfloor \bar g \rfloor_{S, \mathsf{grades}_\Sigma(T.\bar g), \bar k, \bar{\bar o}} \\[1em]
& \lfloor t \rfloor_{S, p} = \text{↯} \text{ if } p \in S \\
& \lfloor t \rfloor_{S, p} = \lfloor t \rfloor_S \text{ if } p \notin S \\[1em]
& \lfloor () \rfloor_{S, \bar p \mathrel{◀} \bar r} = () &&(\mathsf{erase}_{\bar t}) \\
& \lfloor (t,\ \bar t) \rfloor_{S, ()} = (\text{↯} \mathrel{▶} \omega \mathrel{◀} \omega,\ \lfloor \bar t \rfloor_{S, ()}) \\
& \lfloor (t,\ \bar t) \rfloor_{S, (p \mathrel{◀} r,\ \bar p \mathrel{◀} \bar r)} = (\lfloor t \rfloor_{S, p} \mathrel{▶} \mathsf{run}(p) \mathrel{◀} \mathsf{run}(r),\ \lfloor \bar t \rfloor_{S, \bar p \mathrel{◀} \bar r}) \\[1em]
& \lfloor () \rfloor_{S, r, \bar{\bar k}, \bar{\bar q} \mathrel{◀} \bar{\bar r}} = () &&(\mathsf{erase}_{\bar u}) \\[1em]
& {=} \\
& \quad \lfloor ((\bar x;\ \bar y \mathrel{▶} \bar e).\, u,\ \bar u) \rfloor_{S, r, \bar{\bar k}, \bar{\bar q} \mathrel{◀} \bar{\bar r}} \\
& \quad ((\bar x \mathrel{▶} \bar\pi \mathrel{◀} \bar\kappa;\ \bar y \mathrel{▶} \mathsf{run}(\bar e) \leftarrow \bar w).\, \lfloor u \rfloor_S,\ \lfloor \bar u \rfloor_{S, r, \bar{\bar w}', \bar{\bar q}' \mathrel{◀} \bar{\bar r}'}) \\[1em]
& \lfloor () \rfloor_{S, \bar p, \bar k, \bar{\bar o}} = () &&(\mathsf{erase}_{\bar g}) \\[1em]
& {=} \text{ if} \\
& \quad \lfloor ((\bar x;\ \bar y;\ \bar z).\, g,\ \bar g) \rfloor_{S, (p,\ \bar p), \bar k, \bar{\bar o}} \\
& \quad ((\bar y \mathrel{▶} \mathsf{run}(\ulcorner {11}^{\mathsf{m}} \odot p \urcorner \cdot \bar o_1) \mathrel{◀} \mathsf{run}(\bar r_1); \\
& \quad \phantom{((}\bar z \mathrel{▶} \mathsf{run}(\ulcorner {11}^{\mathsf{m}} \odot p \urcorner \cdot \bar o_2) \mathrel{◀} \mathsf{run}(\bar r_2) \circlearrowleft k \mathrel{◀} \mathsf{run}(\psi) \mathrel{◀} \mathsf{run}(\varsigma)).\, \lfloor g \rfloor_{S, p}, \\
& \quad \phantom{(}\lfloor \bar g \rfloor_{S, \bar p, \bar k', \bar{\bar o}'}) \\
& \quad \bar x \text{ is empty} \\[1em]
& {=} \text{ otherwise} \\
& \quad \lfloor ((\bar x;\ \bar y;\ \bar z).\, g,\ \bar g) \rfloor_{S, \bar p, \bar k, \bar{\bar o}} \\
& \quad ((\bar y \mathrel{▶} \omega \mathrel{◀} \omega;\ \bar z \mathrel{▶} \omega \mathrel{◀} \omega \circlearrowleft k \mathrel{◀} \psi_\bot \mathrel{◀} \omega).\, \text{↯},\ \lfloor \bar g \rfloor_{S, \bar p', \bar k', \bar{\bar o}'})
\end{aligned}
```

In the erasure of a corecursor, $`{T = D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a}`$, $`{\bar\Theta = (\bar x_1.\, \Theta_1 : \bar\kappa_1,\ \dots,\ \bar x_n.\, \Theta_n : \bar\kappa_n)}`$, $`{r \cdot \bar q \mathrel{◀} \bar r}`$ multiplies each grade of $`\bar q`$ by $`r`$ on the left and keeps the requirements $`\bar r`$, and $`\bar k`$ gives each element $`h`$ of $`\mathsf{resumed}_\Sigma(T)`$ the number $`n`$ of the entries of $`\Theta_h`$ when $`\bar x_h`$ is empty and $`{r \notin S}`$, $`\text{↯}_n`$ when $`\bar x_h`$ is empty and $`{r \in S}`$, since the new state, a field of the grade $`r`$ of a position, is then erased, as are its entries, of the grades $`r \cdot \bar q`$, and $`\bot`$ otherwise.
In the erasure of a corecursor, $`\bar{\bar o}`$ also gives each element $`(j,\ \bar q \mathrel{◀} \bar r,\ \psi,\ \varsigma)`$ of $`\mathsf{arguments}_\Sigma(T.\bar g)`$ the parameters of the variables of the branch of its destructor, the ownership of its result and the requirement on the value observed, $`{(\bar o_1 \mathrel{◀} \bar r_1,\ \bar o_2 \mathrel{◀} \bar r_2,\ \psi,\ \varsigma)}`$: $`r \cdot q'_l \mathrel{◀} r'_l`$ for the entry $`l`$ of the state, whose parameter is $`q'_l \mathrel{◀} r'_l`$ in $`\Theta_j`$, and $`q_l \mathrel{◀} r_l`$ for its argument $`l`$; the ownership $`\psi`$ is read for the arguments of the branch, a coefficient beyond them being absent, in a term that no rule types; a branch of a destructor of grade $`p`$ gives each variable of grade $`o`$ the multiplicity $`\mathsf{run}(\ulcorner {11}^{\mathsf{m}} \odot p \urcorner \cdot o)`$, applied to each grade of $`\bar o_1`$ and $`\bar o_2`$, since the [usage](12-usage.md#definitions) checks the branch in the mode $`{11}^{\mathsf{m}} \odot p`$ and gives its variables these grades times $`\ulcorner {11}^{\mathsf{m}} \odot p \urcorner`$; this multiplicity is $`0`$ when $`p`$ has no use at run time, since no observation then runs the branch, and does not depend on $`S`$, which only decides the erasure of the term of the branch.
A double bar marks a sequence of sequences: in the erasure of the branches of a recursor, $`\bar k`$ is the first sequence of $`\bar{\bar k}`$, or $`()`$ when it has none, $`{\bar q \mathrel{◀} \bar r}`$ the first sequence of $`{\bar{\bar q} \mathrel{◀} \bar{\bar r}}`$, or $`()`$ when it has none, $`\bar{\bar k}'`$ and $`{\bar{\bar q}' \mathrel{◀} \bar{\bar r}'}`$ the others, and $`w_j`$ is $`\bot`$ when $`{e_j \in S}`$, and the $`j`$-th element of $`\bar k`$ otherwise, or $`\bot`$ when it has none; in the erasure of the branches of a corecursor, $`k`$ is the first element of $`\bar k`$, or $`\bot`$ when it has none, $`{(\bar o_1 \mathrel{◀} \bar r_1,\ \bar o_2 \mathrel{◀} \bar r_2,\ \psi)}`$ the first element of $`\bar{\bar o}`$, or $`((),\ (),\ \psi_\bot)`$ when it has none, a variable whose parameter is not given having the multiplicity and the requirement $`\omega`$, as do the variables of a branch without grade, whose result has the ownership $`\psi_\bot`$, and $`\bar k'`$, $`\bar p'`$ and $`\bar{\bar o}'`$ are the others.
The variable of the field $`l`$ of a branch of a recursor, whose parameter is $`{q_l \mathrel{◀} r_l}`$ in $`{\bar q \mathrel{◀} \bar r}`$, has the uses at run time of the field that the recursor gives minus those of the recursion on it, with the [subtraction](03-multiplicities.md) of the multiplicities, and the coefficient of its ownership is the requirement of the field times the uses of the field that the recursor gives, at run time, as the [ownership](13-ownership.md) of the branch gives the variable the ownership of the term times $`{r_l \cdot (r \cdot q_l)}`$, in the mode $`{11}^{\mathsf{m}}`$:

```math
\begin{aligned}
& \pi_l = \mathsf{run}(r \cdot q_l) - \mathsf{run}(e_j \cdot r) \text{ if } l \text{ is the } j\text{-th element of } \bar k &&(\mathsf{erase}_{\bar u}.\pi) \\
& \pi_l = \mathsf{run}(r \cdot q_l) \text{ if } l \text{ is not in } \bar k \\
& \pi_l = \omega \text{ if } \bar q \text{ has no element } l \\[1em]
& \kappa_l = \mathsf{run}(r_l \cdot (r \cdot q_l)) &&(\mathsf{erase}_{\bar u}.\kappa) \\
& \kappa_l = \omega \text{ if } \bar q \text{ has no element } l
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
\frac{}{x \text{ occurs in } x}\;(\mathsf{occurs}_M.x) \\[2em]
\frac{x \text{ occurs in } \bar M}{x \text{ occurs in } c_i(\bar M)}\;(\mathsf{occurs}_M.c) \\[2em]
\frac{x \text{ occurs in } M}{x \text{ occurs in } \mathsf{rec}_\rho\ M \mathrel{◀} \varrho\ \mathsf{with}\ \bar N}\;(\mathsf{occurs}_M.\mathsf{rec}) \\[2em]
\frac{x \text{ occurs in } \bar N}{x \text{ occurs in } \mathsf{rec}_\rho\ M \mathrel{◀} \varrho\ \mathsf{with}\ \bar N}\;(\mathsf{occurs}_M.\mathsf{with}) \\[2em]
\frac{x \text{ occurs in } M}{x \text{ occurs in } M.d_i(\bar M) \mathrel{◀} \psi \mathrel{◀} \varsigma}\;(\mathsf{occurs}_M.\mathsf{obs}) \\[2em]
\frac{x \text{ occurs in } \bar M}{x \text{ occurs in } M.d_i(\bar M) \mathrel{◀} \psi \mathrel{◀} \varsigma}\;(\mathsf{occurs}_M.\mathsf{args}) \\[2em]
\frac{x \text{ occurs in } \bar M}{x \text{ occurs in } \mathsf{corec}\ \mathsf{from}\ \bar M\ \mathsf{with}\ \bar P}\;(\mathsf{occurs}_M.\mathsf{from}) \\[2em]
\frac{x \text{ occurs in } \bar P}{x \text{ occurs in } \mathsf{corec}\ \mathsf{from}\ \bar M\ \mathsf{with}\ \bar P}\;(\mathsf{occurs}_M.\mathsf{with}_{\bar P}) \\[2em]
\frac{x \text{ occurs in } M}{x \text{ occurs in } (M \mathrel{▶} \pi \mathrel{◀} \varrho,\ \bar M)}\;(\mathsf{occurs}_{\bar M}.M) \\[2em]
\frac{x \text{ occurs in } \bar M}{x \text{ occurs in } (M \mathrel{▶} \pi \mathrel{◀} \varrho,\ \bar M)}\;(\mathsf{occurs}_{\bar M}.\bar M) \\[2em]
\frac{x \text{ occurs in } N}{x \text{ occurs in } ((\bar x \mathrel{▶} \bar\pi \mathrel{◀} \bar\kappa;\ \bar y \mathrel{▶} \bar\pi' \leftarrow \bar w).\, N,\ \bar N)}\;(\mathsf{occurs}_{\bar N}.N) \\[2em]
\frac{x \text{ occurs in } \bar N}{x \text{ occurs in } ((\bar x \mathrel{▶} \bar\pi \mathrel{◀} \bar\kappa;\ \bar y \mathrel{▶} \bar\pi' \leftarrow \bar w).\, N,\ \bar N)}\;(\mathsf{occurs}_{\bar N}.\bar N) \\[2em]
\frac{x \text{ occurs in } P}{x \text{ occurs in } ((\bar y \mathrel{▶} \bar\pi \mathrel{◀} \bar\varrho;\ \bar z \mathrel{▶} \bar\pi' \mathrel{◀} \bar\varrho' \circlearrowleft k \mathrel{◀} \psi \mathrel{◀} \varsigma).\, P,\ \bar P)}\;(\mathsf{occurs}_{\bar P}.P) \\[2em]
\frac{x \text{ occurs in } \bar P}{x \text{ occurs in } ((\bar y \mathrel{▶} \bar\pi \mathrel{◀} \bar\varrho;\ \bar z \mathrel{▶} \bar\pi' \mathrel{◀} \bar\varrho' \circlearrowleft k \mathrel{◀} \psi \mathrel{◀} \varsigma).\, P,\ \bar P)}\;(\mathsf{occurs}_{\bar P}.\bar P)
\end{gathered}
```

In $`(\mathsf{occurs}_{\bar N}.N)`$ and $`(\mathsf{occurs}_{\bar P}.P)`$, the variable $`x`$ is not among the variables that the branch binds, since they take names that $`x`$ does not use.

A term of the target language is a skeleton when it is built of constructors and of $`\text{↯}`$ only, and terms are skeletons when each of them is:

```math
\begin{gathered}
\frac{}{\text{↯} \text{ is a skeleton}}\;(\mathsf{skeleton}_M.\text{↯}) \\[2em]
\frac{\bar M \text{ are skeletons}}{c_i(\bar M) \text{ is a skeleton}}\;(\mathsf{skeleton}_M.c) \\[2em]
\frac{}{() \text{ are skeletons}}\;(\mathsf{skeleton}_{\bar M}.\varepsilon) \\[2em]
\frac{M \text{ is a skeleton} \quad \bar M \text{ are skeletons}}{(M \mathrel{▶} \pi \mathrel{◀} \varrho,\ \bar M) \text{ are skeletons}}\;(\mathsf{skeleton}_{\bar M}.{,})
\end{gathered}
```

The judgment $`{M \sqsubseteq N}`$ reads: the term $`M`$ of the target language is less defined than $`N`$, which is $`M`$ with some of its subterms $`\text{↯}`$ replaced by other terms, as the order of the approximants of the Böhm trees of [Kerinec, Manzonetto and Pagani](https://doi.org/10.23638/LMCS-16(3:6)2020), generated by the undefined value below every value; a constructor, a recursor, an observation and a corecursor are less defined than the same constructor, recursor, observation and corecursor when their subterms are, and arguments and branches when they are one by one, a branch of a recursor that does not compute a recursive result being less defined than one that computes it, and a recursor on a skeleton being less defined than a recursor on any term, since the skeleton holds nothing but what the type of the term gives:

```math
\begin{gathered}
\frac{}{\text{↯} \sqsubseteq M}\;({\sqsubseteq}.\text{↯}) \\[2em]
\frac{}{x \sqsubseteq x}\;({\sqsubseteq}.x) \\[2em]
\frac{}{f.\{\bar s;\ \bar p\} \sqsubseteq f.\{\bar s;\ \bar p\}}\;({\sqsubseteq}.f) \\[2em]
\frac{\bar M_1 \sqsubseteq \bar M_2}{c_i(\bar M_1) \sqsubseteq c_i(\bar M_2)}\;({\sqsubseteq}.c) \\[2em]
\frac{M_1 \sqsubseteq M_2 \quad \bar N_1 \sqsubseteq \bar N_2}{\mathsf{rec}_\rho\ M_1 \mathrel{◀} \varrho\ \mathsf{with}\ \bar N_1 \sqsubseteq \mathsf{rec}_\rho\ M_2 \mathrel{◀} \varrho\ \mathsf{with}\ \bar N_2}\;({\sqsubseteq}.\mathsf{rec}) \\[2em]
\frac{M_1 \text{ is a skeleton} \quad \bar N_1 \sqsubseteq \bar N_2}{\mathsf{rec}_\rho\ M_1 \mathrel{◀} \omega\ \mathsf{with}\ \bar N_1 \sqsubseteq \mathsf{rec}_\rho\ M_2 \mathrel{◀} \varrho\ \mathsf{with}\ \bar N_2}\;({\sqsubseteq}.\mathsf{rec}_{\mathsf{skeleton}}) \\[2em]
\frac{M_1 \sqsubseteq M_2 \quad \bar M_1 \sqsubseteq \bar M_2}{M_1.d_i(\bar M_1) \mathrel{◀} \psi \mathrel{◀} \varsigma \sqsubseteq M_2.d_i(\bar M_2) \mathrel{◀} \psi \mathrel{◀} \varsigma}\;({\sqsubseteq}.d) \\[2em]
\frac{\bar M_1 \sqsubseteq \bar M_2 \quad \bar P_1 \sqsubseteq \bar P_2}{\mathsf{corec}\ \mathsf{from}\ \bar M_1\ \mathsf{with}\ \bar P_1 \sqsubseteq \mathsf{corec}\ \mathsf{from}\ \bar M_2\ \mathsf{with}\ \bar P_2}\;({\sqsubseteq}.\mathsf{corec}) \\[2em]
\frac{}{() \sqsubseteq ()}\;({\sqsubseteq}_{\bar M}.\varepsilon) \\[2em]
\frac{M_1 \sqsubseteq M_2 \quad \bar M_1 \sqsubseteq \bar M_2}{(M_1 \mathrel{▶} \pi \mathrel{◀} \varrho,\ \bar M_1) \sqsubseteq (M_2 \mathrel{▶} \pi \mathrel{◀} \varrho,\ \bar M_2)}\;({\sqsubseteq}_{\bar M}.{,}) \\[2em]
\frac{}{() \sqsubseteq ()}\;({\sqsubseteq}_{\bar N}.\varepsilon) \\[2em]
\frac{\begin{aligned}& \forall j.\ w_{1j} = \bot \text{ or } w_{1j} = w_{2j} \\[0.6em] & N_1 \sqsubseteq N_2 \\[0.6em] & \bar N_1 \sqsubseteq \bar N_2\end{aligned}}{((\bar x \mathrel{▶} \bar\pi \mathrel{◀} \bar\kappa;\ \bar y \mathrel{▶} \bar\pi' \leftarrow \bar w_1).\, N_1,\ \bar N_1) \sqsubseteq ((\bar x \mathrel{▶} \bar\pi \mathrel{◀} \bar\kappa;\ \bar y \mathrel{▶} \bar\pi' \leftarrow \bar w_2).\, N_2,\ \bar N_2)}\;({\sqsubseteq}_{\bar N}.{,}) \\[2em]
\frac{}{() \sqsubseteq ()}\;({\sqsubseteq}_{\bar P}.\varepsilon) \\[2em]
\frac{\begin{aligned}& k_1 = k_2 \text{ or } k_1 = \text{↯}_n \text{ and } k_2 = n \\[0.6em] & P_1 \sqsubseteq P_2 \\[0.6em] & \bar P_1 \sqsubseteq \bar P_2\end{aligned}}{\begin{aligned}& {\sqsubseteq} \\ & \quad ((\bar y \mathrel{▶} \bar\pi \mathrel{◀} \bar\varrho;\ \bar z \mathrel{▶} \bar\pi' \mathrel{◀} \bar\varrho' \circlearrowleft k_1 \mathrel{◀} \psi \mathrel{◀} \varsigma).\, P_1,\ \bar P_1) \\ & \quad ((\bar y \mathrel{▶} \bar\pi \mathrel{◀} \bar\varrho;\ \bar z \mathrel{▶} \bar\pi' \mathrel{◀} \bar\varrho' \circlearrowleft k_2 \mathrel{◀} \psi \mathrel{◀} \varsigma).\, P_2,\ \bar P_2)\end{aligned}}\;({\sqsubseteq}_{\bar P}.{,})
\end{gathered}
```

The judgment $`{\nu \vdash M \mathrel{▶}}`$ reads: the term $`M`$ of the target language reads its variables as the [vector of multiplicities](10-grade-vectors.md#vectors-of-multiplicities) $`\nu`$ allows, as the [evaluation](17-evaluation.md) runs it.
A variable reads itself once, a constant and $`\text{↯}`$ read no variable, and a constructor, an observation and terms read the variables of their subterms, added.
A position $`{M \mathrel{▶} \pi \mathrel{◀} \varrho}`$ is evaluated once, and its value is then read as its multiplicity allows, through a cell or by each observation of a closure, so that the position counts the reads of its term $`\pi`$ times, as the term of a recursor $`\rho`$ times.
A position of the multiplicity $`0`$ is still evaluated, but its value is never read: a closure that it holds is never observed, and would never release a linear variable that it captures, whether the term reads it or binds it inside, so that its term is a skeleton, which reads no variable and binds none, as the term of a recursor of the multiplicity $`0`$, whose fields are never read; reads of the multiplicity $`\omega`$ would also vanish in the product, and could read a variable of the multiplicity $`0`$.
A recursor evaluates its term once and runs a branch, which reads the variables of the scope as some $`\delta`$ allows, and its new variables as their binders allow; each recursive result that the branch computes, at the positions $`{w_j \ne \bot}`$, runs the recursor again, which reads the variables of the scope as $`\chi`$ allows again, and is read as its binder allows, so that $`\chi`$ bounds $`\delta`$ plus $`\chi`$ times the sum $`\Sigma_{w_j \ne \bot}\, \pi'_j`$ of the multiplicities of the binders of the results that the branch computes, an erased result running no recursion, as the [usage](12-usage.md#definitions) bounds the uses of the branches of a recursor; a result that the branch computes has a multiplicity other than $`0`$, since the recursion that computes it also reads its field, which a result never read would not count.
A corecursor evaluates its state once and captures its scope in a closure, each observation of which runs one branch, which reads the variables of the scope as some $`\delta_i`$ allows and its new variables as their binders allow, and a branch that resumes the corecursor, $`{k \ne \bot}`$, captures the scope again in a new closure, so that $`\delta`$ bounds $`\delta_i`$, and $`\delta_i`$ plus $`\delta`$ for such a branch.
In the rules, $`{\nu \bullet \bar\pi \bullet \bar\pi'}`$ extends $`\nu`$ by the multiplicities of the variables that a branch binds, in order:

```math
\begin{aligned}
& \nu \bullet (\pi_1, \dots, \pi_a) \bullet (\pi'_1, \dots, \pi'_b) = \nu \bullet \pi_1 \bullet \dots \bullet \pi_a \bullet \pi'_1 \bullet \dots \bullet \pi'_b &&(\bullet_\nu)
\end{aligned}
```

```math
\begin{gathered}
\frac{}{(0^{\nu},\ x \mathrel{≔} 1) \vdash x \mathrel{▶}}\;(\mathsf{usage}_M.x) \\[2em]
\frac{}{0^{\nu} \vdash f.\{\bar s;\ \bar p\} \mathrel{▶}}\;(\mathsf{usage}_M.f) \\[2em]
\frac{}{0^{\nu} \vdash \text{↯} \mathrel{▶}}\;(\mathsf{usage}_M.\text{↯}) \\[2em]
\frac{\nu \vdash \bar M \mathrel{▶}}{\nu \vdash c_i(\bar M) \mathrel{▶}}\;(\mathsf{usage}_M.c) \\[2em]
\frac{\begin{aligned}& \nu \vdash M \mathrel{▶} \\[0.6em] & \rho = 0 \implies M \text{ is a skeleton} \\[0.6em] & \chi \vdash \bar N \mathrel{▶}\end{aligned}}{\rho \cdot^{\nu} \nu +^{\nu} \chi \vdash \mathsf{rec}_\rho\ M \mathrel{◀} \varrho\ \mathsf{with}\ \bar N \mathrel{▶}}\;(\mathsf{usage}_M.\mathsf{rec}) \\[2em]
\frac{\nu_1 \vdash M \mathrel{▶} \quad \nu_2 \vdash \bar M \mathrel{▶}}{\nu_1 +^{\nu} \nu_2 \vdash M.d_i(\bar M) \mathrel{◀} \psi \mathrel{◀} \varsigma \mathrel{▶}}\;(\mathsf{usage}_M.d) \\[2em]
\frac{\nu \vdash \bar M \mathrel{▶} \quad \delta \vdash \bar P \mathrel{▶}}{\nu +^{\nu} \delta \vdash \mathsf{corec}\ \mathsf{from}\ \bar M\ \mathsf{with}\ \bar P \mathrel{▶}}\;(\mathsf{usage}_M.\mathsf{corec}) \\[2em]
\frac{\nu \vdash M \mathrel{▶} \quad \mu \le^{\nu} \nu}{\mu \vdash M \mathrel{▶}}\;(\mathsf{usage}_M.\mathsf{sub}) \\[2em]
\frac{}{0^{\nu} \vdash () \mathrel{▶}}\;(\mathsf{usage}_{\bar M}.\varepsilon) \\[2em]
\frac{\begin{aligned}& \nu_1 \vdash M \mathrel{▶} \\[0.6em] & \pi = 0 \implies M \text{ is a skeleton} \\[0.6em] & \nu_2 \vdash \bar M \mathrel{▶}\end{aligned}}{\pi \cdot^{\nu} \nu_1 +^{\nu} \nu_2 \vdash (M \mathrel{▶} \pi \mathrel{◀} \varrho,\ \bar M) \mathrel{▶}}\;(\mathsf{usage}_{\bar M}.{,}) \\[2em]
\frac{}{\chi \vdash () \mathrel{▶}}\;(\mathsf{usage}_{\bar N}.\varepsilon) \\[2em]
\frac{\begin{aligned}& \delta \bullet \bar\pi \bullet \bar\pi' \vdash N \mathrel{▶} \\[0.6em] & \chi \le^{\nu} \delta +^{\nu} (\Sigma_{w_j \ne \bot}\, \pi'_j) \cdot^{\nu} \chi \\[0.6em] & \forall j.\ w_j \ne \bot \implies \pi'_j \ne 0 \\[0.6em] & \chi \vdash \bar N \mathrel{▶}\end{aligned}}{\chi \vdash ((\bar x \mathrel{▶} \bar\pi \mathrel{◀} \bar\kappa;\ \bar y \mathrel{▶} \bar\pi' \leftarrow \bar w).\, N,\ \bar N) \mathrel{▶}}\;(\mathsf{usage}_{\bar N}.{,}) \\[2em]
\frac{}{\delta \vdash () \mathrel{▶}}\;(\mathsf{usage}_{\bar P}.\varepsilon) \\[2em]
\frac{\begin{aligned}& \delta_i \bullet \bar\pi \bullet \bar\pi' \vdash P \mathrel{▶} \\[0.6em] & \delta \le^{\nu} \delta_i \\[0.6em] & k \ne \bot \implies \delta \le^{\nu} \delta_i +^{\nu} \delta \\[0.6em] & \delta \vdash \bar P \mathrel{▶}\end{aligned}}{\delta \vdash ((\bar y \mathrel{▶} \bar\pi \mathrel{◀} \bar\varrho;\ \bar z \mathrel{▶} \bar\pi' \mathrel{◀} \bar\varrho' \circlearrowleft k \mathrel{◀} \psi \mathrel{◀} \varsigma).\, P,\ \bar P) \mathrel{▶}}\;(\mathsf{usage}_{\bar P}.{,})
\end{gathered}
```

The judgment $`{\Omega;\ \varphi \vdash M \mathrel{◀} o}`$ reads: the value of the term $`M`$ of the target language has the ownership $`o`$ at run time, a multiplicity, given the ownership $`\varphi(x)`$ of each variable $`x`$ and the ownership $`\Omega(f)`$ of each constant $`f`$; $`{\Omega;\ \varphi \vdash \bar M \mathrel{◀} \bar o}`$ reads: the terms $`\bar M`$ have the ownerships $`\bar o`$, each satisfying the requirement of its position.
It follows the [ownership](13-ownership.md) on the run-time components that the target language keeps, the ownerships being multiplicities, ordered as the multiplicities are, $`\omega`$ the least, which states nothing, and the value $`\psi[\bar o]`$ of the ownership $`\psi`$ of the result of a destructor at the ownerships $`\bar o`$ of its arguments being defined as $`(\mathsf{value}_\psi)`$ defines it, on multiplicities.
A variable has the ownership that $`\varphi`$ gives it, a constant the one that $`\Omega`$ gives it, and $`\text{↯}`$, which the evaluation never reads, every ownership; a constructor builds a new value, of the ownership $`1`$, whose fields satisfy the requirements of their positions, $`\bar\varrho(\bar M) \le \bar o`$, as an observation and a corecursor require of their arguments and of their state.
A recursor has the ownership $`o'`$ of its branches, each checked with the ownership $`o`$ of its term times the requirement $`\varrho`$ of its recursion times the coefficient $`\kappa`$ of each variable of a field, and $`o'`$ times the multiplicity $`\pi'`$ of each variable of a recursive result, written $`{\varphi \bullet o \cdot \bar\kappa \bullet o' \cdot \bar\pi'}`$ as $`(\bullet_\nu)`$ extends a vector; an observation has the ownership $`o`$ of its term times the value of $`\psi`$ at the ownerships of its arguments, and $`o`$ satisfies the requirement $`\varsigma`$ of its destructor on the value that it observes.
A corecursor builds a new value, of the ownership $`1`$, and each branch has, for all the ownerships $`\bar o`$ of its arguments that satisfy their requirements $`\bar\varrho'`$, the value of the ownership $`\psi`$ of the result of its destructor at $`\bar o`$, or the ownership $`1`$ of a new value when it resumes the corecursor, $`{k \ne \bot}`$, given the ownership $`\varsigma \cdot \varphi(x)`$ of each variable $`x`$ of the scope, $`\varsigma`$ times its ownership, the ownership $`\varsigma \cdot \varrho \cdot \pi`$ of the variable of each entry of the state, of the requirement $`\varsigma`$ of its destructor on the value that it observes, of the requirement $`\varrho`$ and of the multiplicity $`\pi`$, and $`o \cdot \pi'`$ of the variable of each argument, of the ownership $`o`$ and the multiplicity $`\pi'`$, as the [ownership](13-ownership.md#definitions) of the source language checks them; the ownership $`\psi`$ of the result of a destructor whose branch resumes the corecursor is a constant, as the [ownership of a signature](13-ownership.md#definitions) requires of a recursive destructor, since the evaluation gives the term already built of a position the constant of $`\psi`$ as its requirement, which a factor would let an observation exceed, its value then depending on the ownerships of the arguments.
A position satisfies its requirement in every case, without the exception of the mode $`{00}^{\mathsf{m}}`$ of the source language: the erasure replaces with $`\text{↯}`$ every position that the source language does not check, whose ownership no value of an ownership $`\psi`$ reads, since $`(d_{◀})`$ admits a factor of $`\psi`$ only on an argument checked in the mode of the observation:

```math
\begin{gathered}
\frac{}{\Omega;\ \varphi \vdash x \mathrel{◀} \varphi(x)}\;(\mathsf{own}_M.x) \\[2em]
\frac{}{\Omega;\ \varphi \vdash f.\{\bar s;\ \bar p\} \mathrel{◀} \Omega(f)}\;(\mathsf{own}_M.f) \\[2em]
\frac{}{\Omega;\ \varphi \vdash \text{↯} \mathrel{◀} o}\;(\mathsf{own}_M.\text{↯}) \\[2em]
\frac{\Omega;\ \varphi \vdash \bar M \mathrel{◀} \bar o}{\Omega;\ \varphi \vdash c_i(\bar M) \mathrel{◀} 1}\;(\mathsf{own}_M.c) \\[2em]
\frac{\Omega;\ \varphi \vdash M \mathrel{◀} o \quad \Omega;\ \varphi \vdash \bar N \mathrel{◀} o \cdot \varrho;\ o'}{\Omega;\ \varphi \vdash \mathsf{rec}_\rho\ M \mathrel{◀} \varrho\ \mathsf{with}\ \bar N \mathrel{◀} o'}\;(\mathsf{own}_M.\mathsf{rec}) \\[2em]
\frac{\begin{aligned}& \Omega;\ \varphi \vdash M \mathrel{◀} o \\[0.6em] & \Omega;\ \varphi \vdash \bar M \mathrel{◀} \bar o \\[0.6em] & \psi[\bar o] = v \\[0.6em] & \varsigma \le o\end{aligned}}{\Omega;\ \varphi \vdash M.d_i(\bar M) \mathrel{◀} \psi \mathrel{◀} \varsigma \mathrel{◀} o \cdot v}\;(\mathsf{own}_M.d) \\[2em]
\frac{\Omega;\ \varphi \vdash \bar M \mathrel{◀} \bar o \quad \Omega;\ \varphi \vdash \bar P \mathrel{◀}}{\Omega;\ \varphi \vdash \mathsf{corec}\ \mathsf{from}\ \bar M\ \mathsf{with}\ \bar P \mathrel{◀} 1}\;(\mathsf{own}_M.\mathsf{corec}) \\[2em]
\frac{\Omega;\ \varphi \vdash M \mathrel{◀} p \quad q \le p}{\Omega;\ \varphi \vdash M \mathrel{◀} q}\;(\mathsf{own}_M.\mathsf{sub}) \\[2em]
\frac{}{\Omega;\ \varphi \vdash () \mathrel{◀} ()}\;(\mathsf{own}_{\bar M}.\varepsilon) \\[2em]
\frac{\begin{aligned}& \Omega;\ \varphi \vdash M \mathrel{◀} o \\[0.6em] & \varrho \le o \\[0.6em] & \Omega;\ \varphi \vdash \bar M \mathrel{◀} \bar o\end{aligned}}{\Omega;\ \varphi \vdash (M \mathrel{▶} \pi \mathrel{◀} \varrho,\ \bar M) \mathrel{◀} (o,\ \bar o)}\;(\mathsf{own}_{\bar M}.{,}) \\[2em]
\frac{}{\Omega;\ \varphi \vdash () \mathrel{◀} o;\ o'}\;(\mathsf{own}_{\bar N}.\varepsilon) \\[2em]
\frac{\begin{aligned}& \Omega;\ \varphi \bullet o \cdot \bar\kappa \bullet o' \cdot \bar\pi' \vdash N \mathrel{◀} o' \\[0.6em] & \Omega;\ \varphi \vdash \bar N \mathrel{◀} o;\ o'\end{aligned}}{\Omega;\ \varphi \vdash ((\bar x \mathrel{▶} \bar\pi \mathrel{◀} \bar\kappa;\ \bar y \mathrel{▶} \bar\pi' \leftarrow \bar w).\, N,\ \bar N) \mathrel{◀} o;\ o'}\;(\mathsf{own}_{\bar N}.{,}) \\[2em]
\frac{}{\Omega;\ \varphi \vdash () \mathrel{◀}}\;(\mathsf{own}_{\bar P}.\varepsilon) \\[2em]
\frac{\begin{aligned}& \forall \bar o, v. \\ & \quad \text{⟹} \\ & \qquad \text{and} \\ & \qquad \quad \bar\varrho' \le \bar o \\ & \qquad \quad \text{or} \\ & \qquad \qquad \text{and} \\ & \qquad \qquad \quad k = \bot \\ & \qquad \qquad \quad \psi[\bar o] = v \\ & \qquad \qquad \text{and} \\ & \qquad \qquad \quad k \ne \bot \\ & \qquad \qquad \quad v = 1 \\ & \qquad \Omega;\ \varsigma \cdot \varphi \bullet \varsigma \cdot \bar\varrho \cdot \bar\pi \bullet \bar o \cdot \bar\pi' \\ & \qquad {\vdash}\ P \mathrel{◀} v \\[0.6em] & k \ne \bot \implies \exists \chi.\ \psi = \chi \\[0.6em] & \Omega;\ \varphi \vdash \bar P \mathrel{◀}\end{aligned}}{\Omega;\ \varphi \vdash ((\bar y \mathrel{▶} \bar\pi \mathrel{◀} \bar\varrho;\ \bar z \mathrel{▶} \bar\pi' \mathrel{◀} \bar\varrho' \circlearrowleft k \mathrel{◀} \psi \mathrel{◀} \varsigma).\, P,\ \bar P) \mathrel{◀}}\;(\mathsf{own}_{\bar P}.{,})
\end{gathered}
```

In the rules, $`o \cdot \bar\kappa`$, $`\bar\varrho \cdot \bar\pi`$ and $`\bar o \cdot \bar\pi'`$ multiply the sequences element by element.

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

The erasure at run time keeps the ownership: a term checked in the mode $`{11}^{\mathsf{m}}`$ in a signature whose names are distinct, so that the ownership and the erasure read the parameters of the fields, of the arguments and of the branches in the same entry, and whose entries have their ownerships, so that the result of each recursive destructor has a constant ownership, has an erasure whose ownership at run time is the run-time multiplicity of its own, given the run-time multiplicities $`\mathsf{run}(\varphi)`$ of the ownerships of its variables, and ownerships $`\Omega`$ of the constants that are the run-time multiplicities of those of their entries, defined or declared:

```math
\begin{aligned}
& \text{⟹} &&(\mathsf{erase}_{◀}) \\
& \quad \text{and} \\
& \qquad \text{the names of } \Sigma \text{ are distinct} \\
& \qquad \vdash \Sigma \mathrel{◀} \\
& \qquad \forall f,\ p'.\ f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p' \text{ is an entry of } \Sigma \implies \Omega(f) = \mathsf{run}(p') \\
& \qquad \Sigma;\ \varphi \vdash t \mathrel{◀} p;\ {11}^{\mathsf{m}} \\
& \quad \Omega;\ \mathsf{run}(\varphi) \vdash \lfloor t \rfloor_{S^{{11}^{\mathsf{m}}}} \mathrel{◀} \mathsf{run}(p)
\end{aligned}
```

The erasure keeps the positions that the mode $`{11}^{\mathsf{m}}`$ checks in this mode again, which satisfy their requirements, and replaces the others with $`\text{↯}`$, which has every ownership and whose ownership no value of the ownership of a result reads; the run-time multiplicity keeps the product and the meet of the grades, so that the coefficients and the multiplicities that the erasure stores give the variables of the branches the run-time multiplicities of their ownerships, and a branch of a corecursor, checked for the ownerships of its arguments at run time, is checked by the source language for ownerships of the grades above their requirements, which have these run-time multiplicities.
The term of a recursor whose grade has no use at run time becomes a skeleton, of the ownership $`1`$, and the variables of its fields have the ownership $`0`$, whatever the ownership of the term and the requirement of the recursion.

The erasure removes the positions whose grade has no use at run time, which the usage counts $`0`$ times at run time, replacing them by $`\text{↯}`$, and the term of a recursor of such a grade by a skeleton, and keeps the others, which a term checked in the mode $`{11}^{\mathsf{m}}`$ checks in this mode again, at grades whose run-time multiplicity is $`1`$ or $`\omega`$, below $`1`$; it gives each binder the multiplicity that the usage gives its variable at run time, except the variable of a field of a branch of a recursor, whose multiplicity is the least that the bound on its grade allows, below this grade.
An instance, which the erasure replaces by $`\text{↯}`$, needs its [usage](12-usage.md#definitions) as a position of the grade $`{01}^{\mathsf{p}}`$, which uses no variable at run time, and a branch of a corecursor of a destructor without use at run time, whose term is $`\text{↯}`$, needs the multiplicity $`0`$ of its variables, while the usage already bounds the uses of the scope by none at run time, $`{\delta \le p \cdot \delta_i}`$ with $`\mathsf{run}(p) = 0`$.

The erasure decides what it removes by the grades of the usage alone, which the ownership reads without deciding what is erased; it keeps at run time the requirements of the positions, the coefficients and the requirements of the binders and the ownerships of the results of the destructors, which the [evaluation](17-evaluation.md) checks against the values that it stores, and which the ownership of the target language reads, $`(\mathsf{erase}_{◀})`$; what the ownership of a term guarantees of its erasure, the uses of a value during a run, needs the evaluation of the target language.
