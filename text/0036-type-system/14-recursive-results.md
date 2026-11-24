# Recursive Results

This annex defines the recursive results of the fields of a constructor, which a branch of a recursor binds after its fields: their types (the motive of its type for a recursive field and the type of the field lifted for a field nested below a codata type), their factors, and the terms that the computation of a recursor gives them, with their properties, and the skeletons of the data types and the shapes of the recursive results, which the ownership and the erasure of a recursor read.
It builds on the [multiplicities](03-multiplicities.md), the [grades](04-grades.md), the [modes](05-modes.md), the [syntax](08-syntax.md), with the [nesting](08-syntax.md#nesting) of the fields of a block and the [cases](08-syntax.md#cases), the [substitution](09-substitution.md) and the [liftings](13-liftings.md).

## Definitions

This section gives the types and the factors of the recursive results of the fields of a telescope, then the terms of these results, then the skeletons and the shapes.
In its definitions, the block lifted $`\mathcal{B}`$, the set $`\Pi`$ of the parameters lifted and the variables $`s_C`$, $`r`$, $`\varsigma`$ and $`\chi`$ are fixed, as in the definitions of the [liftings](13-liftings.md#variables-of-a-lifting): a recursor gives them the types of its block, each with its instance and its motive, no parameter lifted, the quality of the sort of its motives, its grade and its two ownerships.

The results are relations, as the lifting is: a field whose type has no lifting, since the signature does not declare it, has no result.
The [nesting](08-syntax.md#fields-of-a-block) of each field, which its declaration gives, tells whether it has a result: a field without position has none, a field whose nesting is a position that holds a type of the block is recursive, and a field whose nesting is that of an instance, $`(\bar\lambda)`$, is nested.

### Types of the Results

The relation $`{\Sigma \vdash \Theta \uparrow_{\bar\lambda} = \Theta^{\uparrow} \mathrel{\triangleright} \bar\pi}`$ reads: the recursive results $`\Theta^{\uparrow}`$ are those of the fields $`\Theta`$, whose nestings are $`\bar\lambda`$, a variable $`y`$ with its type for each field whose nesting has a position, in order, and $`\bar\pi`$ are their factors, one for each result, in the same order, which multiply the uses of the scope by each use of the result.
A field without position has no result; the result of a recursive field $`x`$ of the type $`E`$ of the block lifted has the motive of $`E`$ at the field, and the factor $`{11}^{\mathsf{p}}`$, since it runs the recursor once, on the field; the result of a nested field $`{x : A}`$ has the type $`A`$ [lifted](13-liftings.md#types) at the field, and the factor that the lifting gives it:

```math
\begin{gathered}
\frac{}{\Sigma \vdash \varepsilon \uparrow_{()} = \varepsilon \mathrel{\triangleright} ()}\;(\uparrow_{\Theta\varepsilon}) \\[2em]
\frac{\Sigma \vdash \Theta \uparrow_{\bar\lambda} = \Theta^{\uparrow} \mathrel{\triangleright} \bar\pi}{\Sigma \vdash (x : A \mathrel{▶} p;\ q \mathrel{◀} r',\ \Theta) \uparrow_{(\bot,\ \bar\lambda)} = \Theta^{\uparrow} \mathrel{\triangleright} \bar\pi}\;(\uparrow_{\Theta\bot}) \\[2em]
\frac{\begin{aligned}& E \text{ is a type of } \mathcal{B} \\[0.6em] & \Sigma \vdash \Theta \uparrow_{\bar\lambda} = \Theta^{\uparrow} \mathrel{\triangleright} \bar\pi\end{aligned}}{\Sigma \vdash (x : A \mathrel{▶} p;\ q \mathrel{◀} r',\ \Theta) \uparrow_{(E,\ \bar\lambda)} = (y : C_E[x / z],\ \Theta^{\uparrow}) \mathrel{\triangleright} ({11}^{\mathsf{p}},\ \bar\pi)}\;(\uparrow_{\Theta T}) \\[2em]
\frac{\begin{aligned}& \Sigma \vdash A \uparrow_{(\bar\lambda')} x = A' : (s_C)_l \mathrel{\triangleright} \pi;\ \chi' \\[0.6em] & \Sigma \vdash \Theta \uparrow_{\bar\lambda} = \Theta^{\uparrow} \mathrel{\triangleright} \bar\pi\end{aligned}}{\Sigma \vdash (x : A \mathrel{▶} p;\ q \mathrel{◀} r',\ \Theta) \uparrow_{((\bar\lambda'),\ \bar\lambda)} = (y : A',\ \Theta^{\uparrow}) \mathrel{\triangleright} (\pi,\ \bar\pi)}\;(\uparrow_{\Theta\lambda})
\end{gathered}
```

The type of a result is in the scope of the fields, of which it mentions its own, and no field nor result depends on a result, so that the results come after all the fields; the branch of a recursor gives each of them its grade.
The rule $`(\uparrow_{\Theta T})`$ does not read the type of the field, as the rule $`(\uparrow_T)`$ of the liftings does not compare an instance: the position tells that the field is a term of the instance that the motive is over.

### Terms of the Results

The relation $`{\Sigma \vdash \mathsf{res}_{f;\ \lambda}(t : A) = t'}`$ reads: the term $`t'`$ is the recursive result of the term $`t`$ of the type $`A`$, whose nesting is $`\lambda`$, where $`{f(E, u)}`$ is the result of a term $`u`$ of a type $`E`$ of the block lifted.
The result of a term of an instance of a type of the block, at a position that holds this type, is $`f`$ at it.
The result of a term $`t`$ of an instance $`{T = D.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a}`$ of a codata type whose nesting is not a position, of which an argument at least is lifted, is the corecursor of the instance of the lifting of $`D`$ that $`T`$ [lifted](13-liftings.md#types) at $`t`$ is, without state, whose branch of each destructor of the lifting is the result of the observation of $`t`$ by the destructor of $`D`$ of the same name, at the variables of its arguments: the type of this observation is the result of the destructor at the arguments of the instance, the destructors before it being the [observations](09-substitution.md) of $`t`$ by them, and its nesting is that of this result, where $`{\Lambda = (\Delta \mapsto \bar\lambda)}`$ gives the parameters the nestings of the arguments, no position to the destructors and no object to a declared type:

```math
\begin{gathered}
\frac{E \text{ is a type of } \mathcal{B}}{\Sigma \vdash \mathsf{res}_{f;\ E}(t : E.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a) = f(E, t)}\;(\mathsf{res}_T) \\[2em]
\frac{\begin{aligned}& \lambda = \bot \text{ and each of } \bar\lambda \text{ is } \bot \text{, or } \lambda = (\bar\lambda) \\[0.6em] & \mathcal{D}' \in \Sigma \\[0.6em] & \bar s',\ \bar l',\ \bar p' \text{ as many as } \bar s,\ \bar l,\ \bar p \\[0.6em] & \Sigma \vdash \bar a \uparrow_{\bar\lambda} = (\Pi';\ \bar l'';\ \overline{\pi'', \chi''};\ \bar a') \\[0.6em] & \Pi' \ne \varnothing \\[0.6em] & \mathsf{lifting}_{\Pi'}(\mathcal{D}',\ D,\ \bar d'') \in \Sigma \\[0.6em] & \bar d'' = (d_1 : \dots \mid \dots \mid d_n : \dots) \\[0.6em] & \forall i. \\ & \quad {=} \\ & \qquad \bar d[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p] \\ & \qquad (\bar d_{i,1} \mid d_i : (\Theta_i \vdash B_i \mathrel{◀} \psi_i) \mathrel{▶} p_i;\ q_i \mathrel{◀} \varsigma_i \mid \bar d_{i,2}) \\[0.6em] & \forall i. \\ & \quad \Sigma \\ & \quad {\vdash}\ \mathsf{res}_{f;\ \mathsf{nest}_\Lambda(B_i)}(t.(T.d_i)(\bar z_i) : B_i[\bar a / \Delta,\ t.T / \bar d_{i,1}]) \\ & \quad {=}\ g_i\end{aligned}}{\begin{aligned}& \Sigma \\ & {\vdash}\ \mathsf{res}_{f;\ \lambda}(t : D.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a) \\ & {=}\ \mathsf{corec}_r\ (D^{\Pi'}.\{\bar s', s_C;\ \bar l', \bar l'';\ \bar p', r, \varsigma, \overline{\pi'', \chi''}\}\ (\bar a',\ t)) \\ & \qquad \mathsf{from}\ () \\ & \qquad \mathsf{return}\ (\varepsilon : ()) \\ & \qquad \mathsf{with}\ (D^{\Pi'}.d_1(;\ ;\ \bar z_1) \Rightarrow g_1,\ \dots,\ D^{\Pi'}.d_n(;\ ;\ \bar z_n) \Rightarrow g_n)\end{aligned}}\;(\mathsf{res}_D)
\end{gathered}
```

In the rule $`(\mathsf{res}_D)`$, $`{\mathcal{D}' = \mathsf{codata}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa\ \mathsf{where}\ \dots}`$ is a block of codata types whose type $`D`$ has the destructors $`\bar d`$, $`\bar\lambda`$ are the nestings of the arguments, none of which has a position when the instance has none, and $`\bar z_i`$ are the variables of $`\Theta_i`$, which the branch binds.
The signature declares the lifting of $`D`$ at $`\Pi'`$ with destructors $`\bar d''`$, whose names $`{d_1, \dots, d_n}`$ give the corecursor its branches: each is asked to be the name of a destructor of $`D`$, which the destructors of a [lifting that a well-formed signature holds](13-liftings.md#signatures) are.
The result of an observation follows the result of its destructor at the arguments of the instance, which is not a part of the type of the field, down to the terms of the types of the block: the terms of the results are thus a relation by rules too.

The relation $`{\Sigma \vdash \mathsf{res}_{f;\ \bar\lambda}(\bar t : \Theta) = \bar t'}`$ reads: the terms $`\bar t'`$ are the recursive results of the terms $`\bar t`$ of the fields $`\Theta`$, whose nestings are $`\bar\lambda`$, a term for each field whose nesting has a position, in order: the terms that the variables of the [types of the results](#types-of-the-results) stand for.
The term of a field without position has no result, the result of the term $`t`$ of a recursive field of the type $`E`$ is $`{f(E, t)}`$, and the result of the term of a nested field is its recursive result, at the type of the field, where the terms of the fields before it are substituted for their variables:

```math
\begin{gathered}
\frac{}{\Sigma \vdash \mathsf{res}_{f;\ ()}(() : \varepsilon) = ()}\;(\mathsf{res}_{\Theta\varepsilon}) \\[2em]
\frac{\Sigma \vdash \mathsf{res}_{f;\ \bar\lambda}(\bar t : \Theta[t / x]) = \bar t'}{\Sigma \vdash \mathsf{res}_{f;\ (\bot,\ \bar\lambda)}((t,\ \bar t) : (x : A \mathrel{▶} p;\ q \mathrel{◀} r',\ \Theta)) = \bar t'}\;(\mathsf{res}_{\Theta\bot}) \\[2em]
\frac{\Sigma \vdash \mathsf{res}_{f;\ \bar\lambda}(\bar t : \Theta[t / x]) = \bar t'}{\Sigma \vdash \mathsf{res}_{f;\ (E,\ \bar\lambda)}((t,\ \bar t) : (x : A \mathrel{▶} p;\ q \mathrel{◀} r',\ \Theta)) = (f(E, t),\ \bar t')}\;(\mathsf{res}_{\Theta T}) \\[2em]
\frac{\begin{aligned}& \Sigma \vdash \mathsf{res}_{f;\ (\bar\lambda')}(t : A) = t' \\[0.6em] & \Sigma \vdash \mathsf{res}_{f;\ \bar\lambda}(\bar t : \Theta[t / x]) = \bar t'\end{aligned}}{\Sigma \vdash \mathsf{res}_{f;\ ((\bar\lambda'),\ \bar\lambda)}((t,\ \bar t) : (x : A \mathrel{▶} p;\ q \mathrel{◀} r',\ \Theta)) = (t',\ \bar t')}\;(\mathsf{res}_{\Theta\lambda})
\end{gathered}
```

### Skeletons

A skeleton $`Z`$ is the empty skeleton $`\square`$, which holds nothing, or the constructor $`c_i`$ of the case $`i`$ in its block applied to a skeleton for each of its fields:

```math
\begin{aligned}
& Z \mathrel{::=} \square \mid c_i\langle Z_1, \dots, Z_a \rangle &&(\mathsf{syntax}_Z)
\end{aligned}
```

The skeleton $`\mathsf{skeleton}_\Sigma(T)`$ of an instance $`{T = D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a}`$ is the skeleton that the type $`D`$ gives to its closed terms when each type of its block has one constructor at most: the constructor of the case of the only constructor of $`D`$, applied to $`\square`$ for each field that is not recursive and to the skeleton of the type of each recursive field, and $`\square`$ when $`D`$ has no constructor or several.
It is built within the depth $`k`$ of the number of the types of the block, at the instance $`\bar s`$, $`\bar p`$, in the last entry of $`\Sigma`$ that declares a type $`D`$ and as many sort and grade variables as $`\bar s`$ and $`\bar p`$, and is $`\square`$ when $`\Sigma`$ has no such entry:

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
& \mathsf{skeleton}_\Sigma(T) = \square \text{ if } \Sigma \text{ has no such entry} \\[1em]
& \mathsf{skeleton}^0(D_j) = \square \\[1em]
& \mathsf{skeleton}^{n + 1}(D_j) = c_i\langle Z_1, \dots, Z_a \rangle \\
& \quad \text{if} \\
& \qquad \text{and} \\
& \qquad \quad \bar c_j = (c : \Theta) \\
& \qquad \quad i = \mathsf{case}_\Sigma(D_j.c) \\
& \qquad \quad \Theta \text{ has } a \text{ entries} \\[1em]
& \mathsf{skeleton}^{n + 1}(D_j) = \square \text{ otherwise}
\end{aligned}
```

In the skeleton of a constructor $`{c : \Theta}`$, $`Z_l`$ is $`\mathsf{skeleton}^n(D')`$ when the element $`l`$ of $`\mathsf{rec}_{\mathcal{D}}(\Theta)`$, defined with the [fields of a block](08-syntax.md#fields-of-a-block), is a type $`D'`$ of the block, and $`\square`$ when it is $`\bot`$.
The depth is reached only on a type without closed term: along a path of a closed term, from a term to the term of one of its recursive fields, no type of the block comes twice, since each type has one constructor, so that the term would hold a term of the same form, without end.

### Shapes

A shape $`\Xi`$ gives, for each destructor that the lifting keeps, in order, without the terms of its branch, what the evaluation needs to build this branch: the case $`i`$ of the destructor that it lifts in its block, its multiplicity $`\rho`$, the multiplicities and the requirements $`{\bar\pi \mathrel{◀} \bar\varrho}`$ of its arguments in the observation of the field and $`{\bar\pi' \mathrel{◀} \bar\varrho'}`$ in the lifted destructor, the ownership $`\psi`$ of the result of the lifted destructor and the ownership $`\varsigma`$ that it requires of the value that it observes, the same ownerships $`\psi_0`$ and $`\varsigma_0`$ of the destructor that it lifts, which the observation of the field reads, and the shape $`\Upsilon`$ of its result.
The multiplicities and the ownerships of a shape are those of an axis of the grades, the uses at run time for the shapes that the erasure reads.
The shape of a result is $`\star_Z`$ when the type lifted is a motive, so that the result is the recursor itself, where $`Z`$ is the skeleton of the motive, on which the recursor of the multiplicity $`0`$ runs instead of the observation, and the shape $`\Xi`$ of the next lifting when the type lifted is an instance of a lifting, two levels of nesting deep or more.

```math
\begin{aligned}
& {\mathrel{::=}} &&(\mathsf{syntax}_\Xi) \\
& \quad \Xi \\
& \quad {\mid} \\
& \qquad () \\
& \qquad ((i,\ \rho,\ \bar\pi \mathrel{◀} \bar\varrho,\ \bar\pi' \mathrel{◀} \bar\varrho',\ \psi,\ \varsigma,\ \psi_0,\ \varsigma_0,\ \Upsilon),\ \Xi) \\[1em]
& \Upsilon \mathrel{::=} \star_Z \mid \Xi &&(\mathsf{syntax}_\Upsilon)
\end{aligned}
```

The factor $`\mathsf{factor}(\Xi)`$ of a shape is the multiplicity by which the uses of the scope of the recursor by the result that it shapes are multiplied, as the [factor](13-liftings.md#factors) of a lifting is: the meet of the multiplicities at run time of its destructors times the factors of their results, $`0`$ without destructor, since the result is then never observed, and $`1`$ for the recursor itself:

```math
\begin{aligned}
& \mathsf{factor}(()) = 0 &&(\mathsf{factor}_\Xi) \\
& \mathsf{factor}(((i,\ \rho',\ \bar\pi \mathrel{◀} \bar\varrho,\ \bar\pi' \mathrel{◀} \bar\varrho',\ \psi,\ \varsigma,\ \psi_0,\ \varsigma_0,\ \Upsilon),\ ())) = \rho' \cdot \mathsf{factor}(\Upsilon) \\
& {=} \text{ if } \Xi \ne () \\
& \quad \mathsf{factor}(((i,\ \rho',\ \bar\pi \mathrel{◀} \bar\varrho,\ \bar\pi' \mathrel{◀} \bar\varrho',\ \psi,\ \varsigma,\ \psi_0,\ \varsigma_0,\ \Upsilon),\ \Xi)) \\
& \quad (\rho' \cdot \mathsf{factor}(\Upsilon)) \wedge \mathsf{factor}(\Xi) \\[1em]
& \mathsf{factor}(\star_Z) = 1 &&(\mathsf{factor}_\Upsilon)
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
& \star_Z \text{ fits } \rho &&(\mathsf{fits}_\Upsilon)
\end{aligned}
```

### Shapes of the Types

The shape $`{\mathsf{shape}^\Lambda_{\Sigma; m; \beta}(A,\ \lambda)}`$ of the recursive result whose type is $`A`$, of the nesting $`\lambda`$, is read on the syntax of $`A`$ as the [lifting](13-liftings.md#types) lifts it, at the variables $`s_C`$, $`r`$ and $`\varsigma`$ of a lifting, which the recursor gives, in the mode $`m`$ and on the [axis](04-grades.md#definitions) $`\beta`$ of the grades: its shape $`\Upsilon`$, its factor $`\pi`$ and its ownership $`\chi'`$, written $`{\Upsilon;\ \pi;\ \chi'}`$, where $`\Lambda`$ gives a variable lifted a position that holds its shape, $`\bot`$ to the other variables, and the shape of the result of the recursor to each type of the block, which a position names, and $`\Sigma`$ declares the liftings whose shapes it reads, the types lifted and their cases.
A variable lifted, applied to arguments, has the shape that the position of its nesting holds; an instance of a type of the block, at a position, the shape given to this type; and an instance of another declared type whose nesting is not a position, of which an argument at least has a shape and each argument whose nesting has a position has one, the shape and the factor of the lifting of this type at the shapes of these arguments, with the ownership $`{11}^{\mathsf{p}}`$, since its recursive result is a corecursor; any other type has no shape.
The shapes $`{\mathsf{shape}^\Lambda_{\Sigma; m; \beta}(\bar a,\ \bar\lambda)}`$ of the arguments $`\bar a`$ of an instance, of the nestings $`\bar\lambda`$, are the shape of each argument, under the variables that its abstraction binds, which have no position, or $`\bot`$ when it has none and its nesting has no position.
An argument whose nesting has a position and that has no shape gives the instance no shapes, rather than being left out: the lifting of the instance lifts this argument, and a shape read at fewer parameters would change in a signature that declares the lifting that it lacks:

```math
\begin{aligned}
& \mathsf{shape}^\Lambda_{\Sigma; m; \beta}(x[\bar t],\ \lambda) = h \text{ if } \Lambda(x) \text{ is a position that holds } h &&(\mathsf{shape}_A) \\
& \mathsf{shape}^\Lambda_{\Sigma; m; \beta}(D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a,\ \lambda) = \Lambda(D) \\
& \quad \text{if } \lambda \text{ is a position and } \Lambda \text{ gives an object to } D \\
& {=} \\
& \quad \mathsf{shape}^\Lambda_{\Sigma; m; \beta}(D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a,\ \lambda) \\
& \quad \Xi;\ \pi;\ {11}^{\mathsf{p}} \\
& \quad \text{if} \\
& \qquad \text{and} \\
& \qquad \quad \lambda = \bot \text{ and each of } \bar\lambda \text{ is } \bot \text{, or } \lambda = (\bar\lambda) \\
& \qquad \quad \bar\lambda' = \mathsf{shape}^\Lambda_{\Sigma; m; \beta}(\bar a,\ \bar\lambda) \\
& \qquad \quad \text{not each of } \bar\lambda' \text{ is } \bot \\
& \qquad \quad \mathsf{shape}_{\Sigma; m; \beta}(D.\{\bar s;\ \bar p\},\ \bar\lambda') = \Xi;\ \pi \\
& \mathsf{shape}^\Lambda_{\Sigma; m; \beta}(A,\ \lambda) \text{ is not defined otherwise} \\[1em]
& \mathsf{shape}^\Lambda_{\Sigma; m; \beta}((),\ ()) = () &&(\mathsf{shape}_{\bar a}) \\
& {=} \\
& \quad \mathsf{shape}^\Lambda_{\Sigma; m; \beta}((\bar a,\ \bar x.\, B),\ (\bar\lambda,\ \lambda)) \\
& \quad (\bar\lambda',\ h) \\
& \quad \text{if} \\
& \qquad \text{and} \\
& \qquad \quad \mathsf{shape}^\Lambda_{\Sigma; m; \beta}(\bar a,\ \bar\lambda) = \bar\lambda' \\
& \qquad \quad \mathsf{shape}^\Lambda_{\Sigma; m; \beta}(B,\ \lambda) = h \\
& {=} \\
& \quad \mathsf{shape}^\Lambda_{\Sigma; m; \beta}((\bar a,\ \bar x.\, B),\ (\bar\lambda,\ \lambda)) \\
& \quad (\bar\lambda',\ \bot) \\
& \quad \text{if} \\
& \qquad \text{and} \\
& \qquad \quad \mathsf{shape}^\Lambda_{\Sigma; m; \beta}(\bar a,\ \bar\lambda) = \bar\lambda' \\
& \qquad \quad \mathsf{shape}^\Lambda_{\Sigma; m; \beta}(B,\ \lambda) \text{ is not defined} \\
& \qquad \quad \lambda = \bot \\
& \mathsf{shape}^\Lambda_{\Sigma; m; \beta}(\bar a,\ \bar\lambda) \text{ is not defined otherwise}
\end{aligned}
```

The shape $`{\mathsf{shape}^\Lambda_{\Sigma; m; \beta}(D,\ \bar d) = \Xi;\ \hat\pi}`$ of the destructors $`\bar d`$ of the type $`D`$ is the shape of the lifting of $`D`$, with an element for each destructor whose result has a shape, in order, and the meet of their grades in the lifting times the factors of their results, or $`\bot`$ when there is none, where $`{\pi \wedge \bot = \pi}`$, as the [factor](13-liftings.md#factors) of a lifting is.
The element of a destructor is read from the destructor that the lifting lifts, as the [lifting](13-liftings.md#destructors) of the destructors declares it, its grades and its ownerships on the axis $`\beta`$: its case $`i`$ in its block, $`0`$ when the signature gives it none, the multiplicity of its grade in the lifting, the parameters of its arguments in the observation, the same arguments used the grade of the recursor times the factor of its result more and scaled by the mode $`{m \odot p'}`$ of its grade $`p'`$ in the lifting, as the usage of a corecursor scales the variables of a branch in the mode $`m`$, and its erasure its arguments in the mode $`{11}^{\mathsf{m}}`$, the ownership of the recursive result whose type is its result, the requirement of the lifting, the ownerships of the destructor that it lifts and the shape of its result:

```math
\begin{aligned}
& \mathsf{shape}^\Lambda_{\Sigma; m; \beta}(D,\ \varepsilon) = ();\ \bot &&(\mathsf{shape}_{\bar d}) \\
& {=} \\
& \quad \mathsf{shape}^\Lambda_{\Sigma; m; \beta}(D,\ (d : (\Theta \vdash B \mathrel{◀} \psi') \mathrel{▶} p;\ q \mathrel{◀} \varsigma' \mid \bar d)) \\
& \quad ((i,\ \rho,\ \bar\pi \mathrel{◀} \bar\varrho,\ \bar\pi' \mathrel{◀} \bar\varrho,\ \psi,\ \beta(\varsigma),\ \psi_0,\ \varsigma_0,\ \Upsilon),\ \Xi);\ (p' \cdot \pi) \wedge \hat\pi \\
& \quad \text{if} \\
& \qquad \text{and} \\
& \qquad \quad \mathsf{shape}^\Lambda_{\Sigma; m; \beta}(B,\ \bot) = \Upsilon;\ \pi;\ \chi' \\
& \qquad \quad \mathsf{shape}^\Lambda_{\Sigma; m; \beta}(D,\ \bar d) = \Xi;\ \hat\pi \\
& \qquad \quad p' = \mathsf{grade}_{s_C}(p) \\
& \qquad \quad \bar q \mathrel{◀} \bar r \text{ are the parameters of } \Theta \\
& \qquad \quad \rho = \beta(p') \\
& \qquad \quad \bar\pi = \beta(\bar q) \\
& \qquad \quad \bar\varrho = \beta(\bar r) \\
& \qquad \quad \bar\pi' = \beta(\ulcorner m \odot p' \urcorner \cdot ((r \cdot \pi) \cdot \bar q)) \\
& \qquad \quad \psi = \beta(\chi') \\
& \qquad \quad \psi_0 = \beta(\psi') \\
& \qquad \quad \varsigma_0 = \beta(\varsigma') \\
& \qquad \quad i = \mathsf{case}_\Sigma(D.d) \text{ if it is defined, and } i = 0 \text{ otherwise} \\
& {=} \\
& \quad \mathsf{shape}^\Lambda_{\Sigma; m; \beta}(D,\ (d : (\Theta \vdash B \mathrel{◀} \psi') \mathrel{▶} p;\ q \mathrel{◀} \varsigma' \mid \bar d)) \\
& \quad \mathsf{shape}^\Lambda_{\Sigma; m; \beta}(D,\ \bar d) \\
& \quad \text{if } \mathsf{shape}^\Lambda_{\Sigma; m; \beta}(B,\ \bot) \text{ is not defined}
\end{aligned}
```

The shape $`{\mathsf{shape}_{\Sigma; m; \beta}(D.\{\bar s';\ \bar p'\},\ \bar\lambda') = \Xi;\ \pi}`$ of the lifting of the type $`D`$ at the instance $`\bar s'`$, $`\bar p'`$, at the shapes $`\bar\lambda'`$ of its parameters, $`\bot`$ for a parameter that is not lifted, is read in the last entry of $`\Sigma`$ that declares the lifting of $`D`$ at the parameters lifted: it is the shape of the destructors of $`D`$ at this instance, where each parameter lifted has its shape, in the last entry before the lifting that declares a codata type $`D`$ and as many sort and grade variables as $`\bar s'`$ and $`\bar p'`$, with the factor $`{00}^{\mathsf{p}}`$ when the lifting has no destructor.
The result of a destructor of a lifting is an instance of a lifting that the signature declares before it, since the signature [declares its liftings in order](13-liftings.md#signatures), so that the shape of a lifting reads, for the shapes of the results of its destructors, only the entries before it, without a bound on the depth, and it reads the declaration of the type lifted and its cases in these entries too, which a well-formed signature declares before the lifting, so that the shape of a lifting does not depend on the entries after it, which a signature with more entries adds.
The shape is a function on the syntax, which the erasure computes in the mode $`{11}^{\mathsf{m}}`$ on the axis $`\mathsf{run}`$, and an instance of a lifting that the signature does not declare has none:

```math
\begin{aligned}
& \mathsf{shape}_{\varnothing; m; \beta}(D.\{\bar s';\ \bar p'\},\ \bar\lambda') \text{ is not defined} &&(\mathsf{shape}_\Sigma) \\
& {=} \\
& \quad \mathsf{shape}_{(\Sigma,\ e); m; \beta}(D.\{\bar s';\ \bar p'\},\ \bar\lambda') \\
& \quad \Xi;\ \pi \\
& \quad \text{if} \\
& \qquad \text{and} \\
& \qquad \quad e = \mathsf{lifting}_{\Pi'}(\mathcal{D}',\ D,\ \bar d'') \text{ for some } \mathcal{D}' \text{ and } \bar d'' \\
& \qquad \quad \mathsf{codata}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa \\
& \qquad \qquad \mathsf{where} \\
& \qquad \qquad \quad \dots;\ D \mathrel{▶} \zeta \oplus \Pi \mathrel{≔} \bar d;\ \dots \\
& \qquad \quad \text{is the last entry of } \Sigma \text{ that declares a codata type } D \\
& \qquad \quad \text{and as many sort and grade variables as } \bar s' \text{ and } \bar p' \\
& \qquad \quad \Lambda \text{ gives each parameter } x_j \text{ of } \Delta \text{ the element } \lambda'_j \\
& \qquad \quad \Lambda \text{ gives no other variable a position and no type an object} \\
& \qquad \quad \mathsf{shape}^\Lambda_{\Sigma; m; \beta}(D,\ \bar d[\bar s' / \bar s,\ \bar p' / \bar p]) = \Xi;\ \hat\pi \\
& \qquad \quad \pi = \hat\pi \text{ when } \hat\pi \ne \bot \text{, and } \pi = {00}^{\mathsf{p}} \text{ when } \hat\pi = \bot \\
& {=} \\
& \quad \mathsf{shape}_{(\Sigma,\ e); m; \beta}(D.\{\bar s';\ \bar p'\},\ \bar\lambda') \\
& \quad \mathsf{shape}_{\Sigma; m; \beta}(D.\{\bar s';\ \bar p'\},\ \bar\lambda') \\
& \quad \text{if } e \text{ is not a lifting of } D \text{ at } \Pi' \\
& \mathsf{shape}_{(\Sigma,\ e); m; \beta}(D.\{\bar s';\ \bar p'\},\ \bar\lambda') \text{ is not defined otherwise}
\end{aligned}
```

In the rule $`(\mathsf{shape}_\Sigma)`$, $`\Pi'`$ is the set of the parameters of $`D`$ whose elements of $`\bar\lambda'`$ are positions, and $`\Pi`$ the parameters at which $`D`$ is strictly positive, which the shape does not read.
In the rules $`(\mathsf{shape}_A)`$ and $`(\mathsf{shape}_{\bar a})`$, an element of $`\bar\lambda'`$ is a position that holds a shape or $`\bot`$, and $`h`$ is a shape $`{\Upsilon;\ \pi;\ \chi'}`$.

### Shapes of the Nested Fields

The shapes of the nested fields of a constructor are those of their types, at the nestings of these types in its block, which the ownership of a recursor and its erasure read.
The shapes $`\Lambda_\Sigma(\mathcal{D}.\{\bar s';\ \bar p'\})`$ of the types of a block of data types $`{\mathcal{D} = \mathsf{data}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \dots;\ \dots;\ D_k \mathrel{▶} \dots}`$ at the [instance](09-substitution.md#instances-of-the-entries) $`\bar s'`$, $`\bar p'`$ of its sort and grade variables, written $`{\mathcal{D}.\{\bar s';\ \bar p'\}}`$, give each type $`D_j`$ of the block the shape of the recursor itself, on the [skeleton](#skeletons) of $`D_j`$ at this instance, which the recursor of the multiplicity $`0`$ runs on, the factor $`{11}^{\mathsf{p}}`$ and the ownership $`\chi`$, as the [lifting](13-liftings.md#types) of the block gives them, no object to the other types, and no position to the variables, since the lifting of a block lifts no variable; the skeleton reads the instance of $`D_j`$ by its sort and grade arguments only, and $`\bar x_\Delta`$ are the [parameters themselves](08-syntax.md#telescopes-and-contexts) of $`\Delta`$:

```math
\begin{aligned}
& \Lambda_\Sigma(\mathcal{D}.\{\bar s';\ \bar p'\})(D_j) = \star_Z;\ {11}^{\mathsf{p}};\ \chi &&(\mathsf{shape}_{\mathcal{D}}) \\
& \quad \text{where } Z = \mathsf{skeleton}_\Sigma(D_j.\{\bar s';\ \bar l;\ \bar p'\}\ \bar x_\Delta) \\
& \Lambda_\Sigma(\mathcal{D}.\{\bar s';\ \bar p'\})(D) \text{ is not defined if } D \text{ is not a type of } \mathcal{D} \\
& \Lambda_\Sigma(\mathcal{D}.\{\bar s';\ \bar p'\})(x) = \bot
\end{aligned}
```

The shapes $`{\mathsf{shapes}^\Lambda_{\Sigma; m; \beta}(\Theta,\ \bar\lambda)}`$ of the nested fields of the telescope $`\Theta`$, whose nestings are $`\bar\lambda`$, are, for each field, in order, the shape $`\Xi`$ of the lifting of its type when it has one, and $`\bot`$ otherwise: a field without position has no shape, and the shape of a recursive field is $`\star_Z`$, the recursor itself, which is not the shape of a lifting:

```math
\begin{aligned}
& \mathsf{shapes}^\Lambda_{\Sigma; m; \beta}(\varepsilon,\ ()) = () &&(\mathsf{shapes}_\Theta) \\
& {=} \\
& \quad \mathsf{shapes}^\Lambda_{\Sigma; m; \beta}((x : A \mathrel{▶} p;\ q \mathrel{◀} r',\ \Theta),\ (\lambda,\ \bar\lambda)) \\
& \quad (\Xi,\ \mathsf{shapes}^\Lambda_{\Sigma; m; \beta}(\Theta,\ \bar\lambda)) \\
& \quad \text{if } \mathsf{shape}^\Lambda_{\Sigma; m; \beta}(A,\ \lambda) = \Xi;\ \pi;\ \chi' \\
& {=} \text{ otherwise} \\
& \quad \mathsf{shapes}^\Lambda_{\Sigma; m; \beta}((x : A \mathrel{▶} p;\ q \mathrel{◀} r',\ \Theta),\ (\lambda,\ \bar\lambda)) \\
& \quad (\bot,\ \mathsf{shapes}^\Lambda_{\Sigma; m; \beta}(\Theta,\ \bar\lambda))
\end{aligned}
```

The shapes $`{\mathsf{shapes}_{\Sigma; m; \beta}(\mathcal{D}.\{\bar s';\ \bar p'\},\ \Theta)}`$ of the nested fields of a constructor $`{c : \Theta}`$ of the block $`\mathcal{D}`$ at the instance $`\bar s'`$, $`\bar p'`$ are those of its fields at this instance, at their [nestings](08-syntax.md#fields-of-a-block) $`\mathsf{nest}_{\mathcal{D}}(\Theta)`$, where the types of the block have their shapes $`\Lambda_\Sigma(\mathcal{D}.\{\bar s';\ \bar p'\})`$:

```math
\begin{aligned}
& {=} &&(\mathsf{shapes}_c) \\
& \quad \mathsf{shapes}_{\Sigma; m; \beta}(\mathcal{D}.\{\bar s';\ \bar p'\},\ \Theta) \\
& \quad \mathsf{shapes}^{\Lambda_\Sigma(\mathcal{D}.\{\bar s';\ \bar p'\})}_{\Sigma; m; \beta}(\Theta[\bar s' / \bar s,\ \bar p' / \bar p],\ \mathsf{nest}_{\mathcal{D}}(\Theta))
\end{aligned}
```

### Ownerships of the Shapes

The ownerships of a shape are those that the lifting gives its destructors, and the requirements that the recursions on the observations of a nested field ask of them, on the axis of the shape.
The shape of each nested result has the ownerships $`\varsigma`$ and $`\chi`$, written $`{\Xi \mathrel{◀} \varsigma;\ \chi}`$: each lifted destructor requires $`\varsigma`$ of the value that it observes, and its result has the ownership $`\mathsf{own}_\chi(\Upsilon)`$, $`\chi`$ for the recursor itself and $`1`$ for the corecursor of the next lifting, whatever the ownerships of its arguments, as the [lifting](13-liftings.md#destructors) declares them.
The ownerships $`\mathsf{args}_\varsigma(\Upsilon,\ \bar o,\ \bar\pi \mathrel{◀} \bar\varrho,\ \bar\pi')`$ of the arguments of the observation that the branch of a lifted destructor builds, given the ownerships $`\bar o`$ of the arguments of its branch, are those of their variables, which the observation sees at $`\mathsf{scale}_\varsigma(\Upsilon)`$, $`1`$ when the recursor runs on it in the branch, and $`\varsigma`$ when the corecursor of the next lifting captures it, times the multiplicities $`\bar\pi'`$ of the arguments of the branch, and the requirement of its position for an argument of the multiplicity $`0`$, which is erased, and an erased argument has every ownership, its requirement among them.
The shape of a nested result meets the requirements of the recursions on the observations of the field, whose branches see the term of the recursor at the ownership $`o`$, written $`{\Xi \text{ meets } o;\ \varsigma}`$: for each destructor observed on the axis of the shape, the requirement $`\varsigma_0`$ of the destructor that it lifts on the value that it observes is within $`o`$, and, for all the ownerships $`\bar o`$ of the arguments of its branch that meet their requirements, the arguments of the observation meet the requirements of their positions in it, the [value](08-syntax.md#telescopes-and-contexts) of the ownership $`\psi_0`$ of its result at their ownerships is defined, and the shape of its result meets the requirements in turn; a destructor of the multiplicity $`0`$ is never observed at run time, and has an erased branch, which observes nothing, so that nothing is asked of it nor of its result.
The observations of the field keep the ownership $`o`$, written $`{\Xi \text{ keeps } o;\ \varsigma}`$, when, for each destructor observed, for all the ownerships of the arguments of its branch that meet their requirements, the value of $`\psi_0`$ at the ownerships of the arguments of the observation, when it is defined, keeps $`o`$, and the observations from the shape of its result keep it in turn.
The shape requires $`o`$, written $`{\Xi \text{ requires } o;\ \varsigma}`$, when it meets the requirements and keeps $`o`$, so that each observation has an ownership within $`o`$, as each level of the recursion has: the ownership of a recursor asks the first of the shapes of its nested fields, and the requirement of its recursion reads the values of the ownerships of the results along the paths of the shapes, for the second.

```math
\begin{aligned}
& \mathsf{own}_\chi(\star_Z) = \chi &&(\mathsf{own}_\Upsilon) \\
& \mathsf{own}_\chi(\Xi) = 1 \\[1em]
& \mathsf{scale}_\varsigma(\star_Z) = 1 &&(\mathsf{scale}_\Upsilon) \\
& \mathsf{scale}_\varsigma(\Xi) = \varsigma \\[1em]
& () \mathrel{◀} \varsigma;\ \chi &&(\mathsf{uniform}_\Xi) \\[1em]
& {\iff} \\
& \quad ((i,\ \rho',\ \bar\pi \mathrel{◀} \bar\varrho,\ \bar\pi' \mathrel{◀} \bar\varrho',\ \psi,\ \varsigma',\ \psi_0,\ \varsigma_0,\ \Upsilon),\ \Xi) \mathrel{◀} \varsigma;\ \chi \\
& \quad \text{and} \\
& \qquad \varsigma' = \varsigma \\
& \qquad \psi = \mathsf{own}_\chi(\Upsilon) \\
& \qquad \Upsilon \mathrel{◀} \varsigma;\ \chi \\
& \qquad \Xi \mathrel{◀} \varsigma;\ \chi \\[1em]
& \star_Z \mathrel{◀} \varsigma;\ \chi &&(\mathsf{uniform}_\Upsilon) \\[1em]
& \mathsf{args}_\varsigma(\Upsilon,\ \bar o,\ \bar\pi \mathrel{◀} \bar\varrho,\ \bar\pi') = (o'_1, \dots, o'_{|\bar\pi|}) &&(\mathsf{args}_\Xi) \\
& \quad \text{where} \\
& \qquad \text{and} \\
& \qquad \quad o'_k = \varrho_k \text{ if } \pi_k = 0 \\
& \qquad \quad o'_k = \mathsf{scale}_\varsigma(\Upsilon) \cdot (o_k \cdot \pi'_k) \text{ otherwise} \\[1em]
& () \text{ meets } o;\ \varsigma &&(\mathsf{meets}_\Xi) \\[1em]
& {\iff} \\
& \quad ((i,\ \rho',\ \bar\pi \mathrel{◀} \bar\varrho,\ \bar\pi' \mathrel{◀} \bar\varrho',\ \psi,\ \varsigma',\ \psi_0,\ \varsigma_0,\ \Upsilon),\ \Xi) \text{ meets } o;\ \varsigma \\
& \quad \text{and} \\
& \qquad \text{⟹} \\
& \qquad \quad \rho' \ne 0 \\
& \qquad \quad \text{and} \\
& \qquad \qquad \varsigma_0 \le o \\
& \qquad \qquad \forall \bar o, \bar o'. \\
& \qquad \qquad \quad \text{⟹} \\
& \qquad \qquad \qquad \text{and} \\
& \qquad \qquad \qquad \quad \bar\varrho' \le \bar o \\
& \qquad \qquad \qquad \quad \bar o' = \mathsf{args}_\varsigma(\Upsilon,\ \bar o,\ \bar\pi \mathrel{◀} \bar\varrho,\ \bar\pi') \\
& \qquad \qquad \qquad \text{and} \\
& \qquad \qquad \qquad \quad \bar\varrho \le \bar o' \\
& \qquad \qquad \qquad \quad \exists v.\ \psi_0[\bar o'] = v \\
& \qquad \qquad \Upsilon \text{ meets } o;\ \varsigma \\
& \qquad \Xi \text{ meets } o;\ \varsigma \\[1em]
& \star_Z \text{ meets } o;\ \varsigma &&(\mathsf{meets}_\Upsilon) \\[1em]
& () \text{ keeps } o;\ \varsigma &&(\mathsf{keeps}_\Xi) \\[1em]
& {\iff} \\
& \quad ((i,\ \rho',\ \bar\pi \mathrel{◀} \bar\varrho,\ \bar\pi' \mathrel{◀} \bar\varrho',\ \psi,\ \varsigma',\ \psi_0,\ \varsigma_0,\ \Upsilon),\ \Xi) \text{ keeps } o;\ \varsigma \\
& \quad \text{and} \\
& \qquad \text{⟹} \\
& \qquad \quad \rho' \ne 0 \\
& \qquad \quad \text{and} \\
& \qquad \qquad \forall \bar o, \bar o', v. \\
& \qquad \qquad \quad \text{⟹} \\
& \qquad \qquad \qquad \text{and} \\
& \qquad \qquad \qquad \quad \bar\varrho' \le \bar o \\
& \qquad \qquad \qquad \quad \bar o' = \mathsf{args}_\varsigma(\Upsilon,\ \bar o,\ \bar\pi \mathrel{◀} \bar\varrho,\ \bar\pi') \\
& \qquad \qquad \qquad \quad \psi_0[\bar o'] = v \\
& \qquad \qquad \qquad o \le o \cdot v \\
& \qquad \qquad \Upsilon \text{ keeps } o;\ \varsigma \\
& \qquad \Xi \text{ keeps } o;\ \varsigma \\[1em]
& \star_Z \text{ keeps } o;\ \varsigma &&(\mathsf{keeps}_\Upsilon) \\[1em]
& {\iff} &&(\mathsf{requires}_\Xi) \\
& \quad \Xi \text{ requires } o;\ \varsigma \\
& \quad \text{and} \\
& \qquad \Xi \text{ meets } o;\ \varsigma \\
& \qquad \Xi \text{ keeps } o;\ \varsigma
\end{aligned}
```

The products $`\mathsf{prefixes}_\varsigma(\pi,\ \Xi)`$ along the prefixes of the paths of a shape, other than the empty one, after a prefix of the product $`\pi`$, give, for each destructor observed, the product $`\pi`$ times the value of the ownership $`\psi_0`$ of the result of the destructor that it lifts at the least ownerships of the arguments of its branch, their requirements, or $`1`$ when this value is not defined, then the products along the prefixes of the paths of the shape of its result, after this one: a destructor never observed extends no path, and the recursor itself ends them.
What the shape of a nested field gives the requirement of the recursion, $`\mathsf{recursion}_\varsigma(\Xi)`$, is the product along each prefix $`{d_1 \dots d_h}`$ of its paths, the empty one included, $`{\varsigma \cdot \psi^-_1 \cdot \ldots \cdot \psi^-_h}`$, of the requirement $`\varsigma`$ of the corecursors on the values that they observe and of the values $`\psi^-`$ of the ownerships of the results of the destructors of the prefix at the least ownerships of their arguments:

```math
\begin{aligned}
& \mathsf{prefixes}_\varsigma(\pi,\ ()) = \varnothing &&(\mathsf{prefixes}_\Xi) \\
& {=} \text{ if } \rho' = 0 \\
& \quad \mathsf{prefixes}_\varsigma(\pi,\ ((i,\ \rho',\ \bar\pi \mathrel{◀} \bar\varrho,\ \bar\pi' \mathrel{◀} \bar\varrho',\ \psi,\ \varsigma',\ \psi_0,\ \varsigma_0,\ \Upsilon),\ \Xi)) \\
& \quad \mathsf{prefixes}_\varsigma(\pi,\ \Xi) \\
& {=} \text{ otherwise} \\
& \quad \mathsf{prefixes}_\varsigma(\pi,\ ((i,\ \rho',\ \bar\pi \mathrel{◀} \bar\varrho,\ \bar\pi' \mathrel{◀} \bar\varrho',\ \psi,\ \varsigma',\ \psi_0,\ \varsigma_0,\ \Upsilon),\ \Xi)) \\
& \quad \{\pi \cdot v\} \cup \mathsf{prefixes}_\varsigma(\pi \cdot v,\ \Upsilon) \cup \mathsf{prefixes}_\varsigma(\pi,\ \Xi) \\
& \quad \text{where} \\
& \qquad \text{and} \\
& \qquad \quad v = \psi_0[\mathsf{args}_\varsigma(\Upsilon,\ \bar\varrho',\ \bar\pi \mathrel{◀} \bar\varrho,\ \bar\pi')] \text{ if it is defined} \\
& \qquad \quad v = 1 \text{ otherwise} \\[1em]
& \mathsf{prefixes}_\varsigma(\pi,\ \star_Z) = \varnothing &&(\mathsf{prefixes}_\Upsilon) \\[1em]
& \mathsf{recursion}_\varsigma(\Xi) = \{\varsigma\} \cup \mathsf{prefixes}_\varsigma(\varsigma,\ \Xi) &&(\mathsf{recursion}_\Xi)
\end{aligned}
```

## Properties

In a signature whose [names are distinct](08-syntax.md), the fields of a telescope have the recursive results of one telescope at most at their nestings, with one sequence of factors, a term has one recursive result at most at its type and at its nesting, and the terms of the fields of a telescope have the recursive results of one sequence of terms at most, since a type has [one lifting at most](13-liftings.md#properties), a name one declaration and a destructor one position in its type:

```math
\begin{aligned}
& \text{⟹} &&(\mathsf{unique}_{\uparrow\Theta}) \\
& \quad \text{and} \\
& \qquad \text{the names of } \Sigma \text{ are distinct} \\
& \qquad \Sigma \vdash \Theta \uparrow_{\bar\lambda} = \Theta^{\uparrow}_1 \mathrel{\triangleright} \bar\pi_1 \\
& \qquad \Sigma \vdash \Theta \uparrow_{\bar\lambda} = \Theta^{\uparrow}_2 \mathrel{\triangleright} \bar\pi_2 \\
& \quad \text{and} \\
& \qquad \Theta^{\uparrow}_1 = \Theta^{\uparrow}_2 \\
& \qquad \bar\pi_1 = \bar\pi_2 \\[1em]
& \text{⟹} &&(\mathsf{unique}_{\mathsf{res}}) \\
& \quad \text{and} \\
& \qquad \text{the names of } \Sigma \text{ are distinct} \\
& \qquad \Sigma \vdash \mathsf{res}_{f;\ \lambda}(t : A) = t'_1 \\
& \qquad \Sigma \vdash \mathsf{res}_{f;\ \lambda}(t : A) = t'_2 \\
& \quad t'_1 = t'_2 \\[1em]
& \text{⟹} &&(\mathsf{unique}_{\mathsf{res}\Theta}) \\
& \quad \text{and} \\
& \qquad \text{the names of } \Sigma \text{ are distinct} \\
& \qquad \Sigma \vdash \mathsf{res}_{f;\ \bar\lambda}(\bar t : \Theta) = \bar t'_1 \\
& \qquad \Sigma \vdash \mathsf{res}_{f;\ \bar\lambda}(\bar t : \Theta) = \bar t'_2 \\
& \quad \bar t'_1 = \bar t'_2
\end{aligned}
```
