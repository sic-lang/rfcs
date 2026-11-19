# Recursive Results

This annex defines the recursive results of the fields of a constructor, which a branch of a recursor binds after its fields: their types (the motive of its type for a recursive field and the type of the field lifted for a field nested below a codata type), their factors, and the terms that the computation of a recursor gives them, with their properties, and the skeletons of the data types and the shapes of the recursive results, which the erasure of a recursor reads.
It builds on the [syntax](08-syntax.md), on the [substitution](09-substitution.md), on the [nesting](14-typing.md#nesting) of the fields of a block, on the [liftings](20-liftings.md) and on the target language of the [erasure](16-erasure.md#definitions), and the [typing](14-typing.md#terms), the [usage](12-usage.md#definitions), the [reduction](15-reduction.md) and the [erasure](16-erasure.md) of the recursors read its definitions.

## Definitions

This section gives the types and the factors of the recursive results of the fields of a telescope, then the terms of these results, then the skeletons and the shapes.
In its definitions, the block lifted $`\mathcal{B}`$, the set $`\Pi`$ of the parameters lifted and the variables $`s_C`$, $`r`$, $`\varsigma`$ and $`\chi`$ are fixed, as in the definitions of the [liftings](20-liftings.md#variables-of-a-lifting): a recursor gives them the types of its block, each with its instance and its motive, no parameter lifted, the quality of the sort of its motives, its grade and its two ownerships.

The results are relations, as the lifting is: a field whose type has no lifting, since the signature does not declare it, has no result.
The [nesting](14-typing.md#fields-of-a-block) of each field, which its declaration gives, tells whether it has a result: a field without position has none, a field whose nesting is a position that holds a type of the block is recursive, and a field whose nesting is that of an instance, $`(\bar\lambda)`$, is nested.

### Types of the Results

The relation $`{\Sigma \vdash \Theta \uparrow_{\bar\lambda} = \Theta^{\uparrow} \mathrel{\triangleright} \bar\pi}`$ reads: the recursive results $`\Theta^{\uparrow}`$ are those of the fields $`\Theta`$, whose nestings are $`\bar\lambda`$, a variable $`y`$ with its type for each field whose nesting has a position, in order, and $`\bar\pi`$ are their factors, one for each result, in the same order, which multiply the uses of the scope by each use of the result.
A field without position has no result; the result of a recursive field $`x`$ of the type $`E`$ of the block lifted has the motive of $`E`$ at the field, and the factor $`{11}^{\mathsf{p}}`$, since it runs the recursor once, on the field; the result of a nested field $`{x : A}`$ has the type $`A`$ [lifted](20-liftings.md#types) at the field, and the factor that the lifting gives it:

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
The result of a term $`t`$ of an instance $`{T = D.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a}`$ of a codata type whose nesting is not a position, of which an argument at least is lifted, is the corecursor of the instance of the lifting of $`D`$ that $`T`$ [lifted](20-liftings.md#types) at $`t`$ is, without state, whose branch of each destructor of the lifting is the result of the observation of $`t`$ by the destructor of $`D`$ of the same name, at the variables of its arguments: the type of this observation is the result of the destructor at the arguments of the instance, the destructors before it being the [observations](09-substitution.md) of $`t`$ by them, and its nesting is that of this result, where $`{\Lambda = (\Delta \mapsto \bar\lambda)}`$ gives the parameters the nestings of the arguments, no position to the destructors and no object to a declared type:

```math
\begin{gathered}
\frac{E \text{ is a type of } \mathcal{B}}{\Sigma \vdash \mathsf{res}_{f;\ E}(t : E.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a) = f(E, t)}\;(\mathsf{res}_T) \\[2em]
\frac{\begin{aligned}& \lambda = \bot \text{ and each of } \bar\lambda \text{ is } \bot \text{, or } \lambda = (\bar\lambda) \\[0.6em] & \mathcal{D}' \in \Sigma \\[0.6em] & \bar s',\ \bar l',\ \bar p' \text{ as many as } \bar s,\ \bar l,\ \bar p \\[0.6em] & \Sigma \vdash \bar a \uparrow_{\bar\lambda} = (\Pi';\ \bar l'';\ \overline{\pi'', \chi''};\ \bar a') \\[0.6em] & \Pi' \ne \varnothing \\[0.6em] & \mathsf{lifting}_{\Pi'}(\mathcal{D}',\ D,\ \bar d'') \in \Sigma \\[0.6em] & \bar d'' = (d_1 : \dots \mid \dots \mid d_n : \dots) \\[0.6em] & \forall i. \\ & \quad {=} \\ & \qquad \bar d[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p] \\ & \qquad (\bar d_{i,1} \mid d_i : (\Theta_i \vdash B_i \mathrel{◀} \psi_i) \mathrel{▶} p_i;\ q_i \mathrel{◀} \varsigma_i \mid \bar d_{i,2}) \\[0.6em] & \forall i. \\ & \quad \Sigma \\ & \quad {\vdash}\ \mathsf{res}_{f;\ \mathsf{nest}_\Lambda(B_i)}(t.(T.d_i)(\bar z_i) : B_i[\bar a / \Delta,\ t.T / \bar d_{i,1}]) \\ & \quad {=}\ g_i\end{aligned}}{\begin{aligned}& \Sigma \\ & {\vdash}\ \mathsf{res}_{f;\ \lambda}(t : D.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a) \\ & {=}\ \mathsf{corec}_r\ (D^{\Pi'}.\{\bar s', s_C;\ \bar l', \bar l'';\ \bar p', r, \varsigma, \overline{\pi'', \chi''}\}\ (\bar a',\ t)) \\ & \qquad \mathsf{from}\ () \\ & \qquad \mathsf{return}\ (\varepsilon : ()) \\ & \qquad \mathsf{with}\ (D^{\Pi'}.d_1(;\ ;\ \bar z_1) \Rightarrow g_1,\ \dots,\ D^{\Pi'}.d_n(;\ ;\ \bar z_n) \Rightarrow g_n)\end{aligned}}\;(\mathsf{res}_D)
\end{gathered}
```

In the rule $`(\mathsf{res}_D)`$, $`{\mathcal{D}' = \mathsf{codata}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa\ \mathsf{where}\ \dots}`$ is a block of codata types whose type $`D`$ has the destructors $`\bar d`$, $`\bar\lambda`$ are the nestings of the arguments, none of which has a position when the instance has none, and $`\bar z_i`$ are the variables of $`\Theta_i`$, which the branch binds.
The signature declares the lifting of $`D`$ at $`\Pi'`$ with destructors $`\bar d''`$, whose names $`{d_1, \dots, d_n}`$ give the corecursor its branches: each is asked to be the name of a destructor of $`D`$, which the destructors of a [lifting that a well-formed signature holds](20-liftings.md#signatures) are.
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

### Shapes

A shape $`\Xi`$ gives, for each destructor that the lifting keeps, in order, without the terms of its branch, what the evaluation needs to build this branch: the case $`i`$ of the destructor that it lifts in its block, its multiplicity $`\rho`$, the multiplicities and the requirements $`{\bar\pi \mathrel{◀} \bar\varrho}`$ of its arguments in the observation of the field and $`{\bar\pi' \mathrel{◀} \bar\varrho'}`$ in the lifted destructor, the ownership $`\psi`$ of the result of the lifted destructor and the ownership $`\varsigma`$ that it requires of the value that it observes, the same ownerships $`\psi_0`$ and $`\varsigma_0`$ of the destructor that it lifts, which the observation of the field reads, and the shape $`\Upsilon`$ of its result.
The multiplicities and the ownerships of a shape are those of an axis of the grades, the uses at run time for the shapes that the erasure reads.
The shape of a result is $`\star_M`$ when the type lifted is a motive, so that the result is the recursor itself, where $`M`$ is the skeleton of the motive, on which the recursor of the multiplicity $`0`$ runs instead of the observation, and the shape $`\Xi`$ of the next lifting when the type lifted is an instance of a lifting, two levels of nesting deep or more.

```math
\begin{aligned}
& {\mathrel{::=}} &&(\mathsf{syntax}_\Xi) \\
& \quad \Xi \\
& \quad {\mid} \\
& \qquad () \\
& \qquad ((i,\ \rho,\ \bar\pi \mathrel{◀} \bar\varrho,\ \bar\pi' \mathrel{◀} \bar\varrho',\ \psi,\ \varsigma,\ \psi_0,\ \varsigma_0,\ \Upsilon),\ \Xi) \\[1em]
& \Upsilon \mathrel{::=} \star_M \mid \Xi &&(\mathsf{syntax}_\Upsilon)
\end{aligned}
```

The factor $`\mathsf{factor}(\Xi)`$ of a shape is the multiplicity by which the uses of the scope of the recursor by the result that it shapes are multiplied, as the [factor](20-liftings.md#factors) of a lifting is: the meet of the multiplicities at run time of its destructors times the factors of their results, $`0`$ without destructor, since the result is then never observed, and $`1`$ for the recursor itself:

```math
\begin{aligned}
& \mathsf{factor}(()) = 0 &&(\mathsf{factor}_\Xi) \\
& \mathsf{factor}(((i,\ \rho',\ \bar\pi \mathrel{◀} \bar\varrho,\ \bar\pi' \mathrel{◀} \bar\varrho',\ \psi,\ \varsigma,\ \psi_0,\ \varsigma_0,\ \Upsilon),\ ())) = \rho' \cdot \mathsf{factor}(\Upsilon) \\
& {=} \text{ if } \Xi \ne () \\
& \quad \mathsf{factor}(((i,\ \rho',\ \bar\pi \mathrel{◀} \bar\varrho,\ \bar\pi' \mathrel{◀} \bar\varrho',\ \psi,\ \varsigma,\ \psi_0,\ \varsigma_0,\ \Upsilon),\ \Xi)) \\
& \quad (\rho' \cdot \mathsf{factor}(\Upsilon)) \wedge \mathsf{factor}(\Xi) \\[1em]
& \mathsf{factor}(\star_M) = 1 &&(\mathsf{factor}_\Upsilon)
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

### Shapes of the Types

The shape $`{\mathsf{shape}^\Lambda_{\Sigma; m; \beta}(A,\ \lambda)}`$ of the recursive result whose type is $`A`$, of the nesting $`\lambda`$, is read on the syntax of $`A`$ as the [lifting](20-liftings.md#types) lifts it, at the variables $`s_C`$, $`r`$ and $`\varsigma`$ of a lifting, which the recursor gives, in the mode $`m`$ and on the [axis](04-grades.md#definitions) $`\beta`$ of the grades: its shape $`\Upsilon`$, its factor $`\pi`$ and its ownership $`\chi'`$, written $`{\Upsilon;\ \pi;\ \chi'}`$, where $`\Lambda`$ gives a variable lifted a position that holds its shape, $`\bot`$ to the other variables, and the shape of the result of the recursor to each type of the block, which a position names, and $`\Sigma`$ declares the liftings whose shapes it reads, the types lifted and their cases.
A variable lifted, applied to arguments, has the shape that the position of its nesting holds; an instance of a type of the block, at a position, the shape given to this type; and an instance of another declared type whose nesting is not a position, of which an argument at least has a shape, the shape and the factor of the lifting of this type at the shapes of these arguments, with the ownership $`{11}^{\mathsf{p}}`$, since its recursive result is a corecursor; any other type has no shape.
The shapes $`{\mathsf{shape}^\Lambda_{\Sigma; m; \beta}(\bar a,\ \bar\lambda)}`$ of the arguments $`\bar a`$ of an instance, of the nestings $`\bar\lambda`$, are the shape of each argument, under the variables that its abstraction binds, which have no position, or $`\bot`$ when it has none:

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
& \quad (\mathsf{shape}^\Lambda_{\Sigma; m; \beta}(\bar a,\ \bar\lambda),\ h) \\
& \quad \text{if } \mathsf{shape}^\Lambda_{\Sigma; m; \beta}(B,\ \lambda) = h \\
& {=} \\
& \quad \mathsf{shape}^\Lambda_{\Sigma; m; \beta}((\bar a,\ \bar x.\, B),\ (\bar\lambda,\ \lambda)) \\
& \quad (\mathsf{shape}^\Lambda_{\Sigma; m; \beta}(\bar a,\ \bar\lambda),\ \bot) \\
& \quad \text{if } \mathsf{shape}^\Lambda_{\Sigma; m; \beta}(B,\ \lambda) \text{ is not defined}
\end{aligned}
```

The shape $`{\mathsf{shape}^\Lambda_{\Sigma; m; \beta}(D,\ \bar d) = \Xi;\ \hat\pi}`$ of the destructors $`\bar d`$ of the type $`D`$ is the shape of the lifting of $`D`$, with an element for each destructor whose result has a shape, in order, and the meet of their grades in the lifting times the factors of their results, or $`\bot`$ when there is none, where $`{\pi \wedge \bot = \pi}`$, as the [factor](20-liftings.md#factors) of a lifting is.
The element of a destructor is read from the destructor that the lifting lifts, as the [lifting](20-liftings.md#destructors) of the destructors declares it, its grades and its ownerships on the axis $`\beta`$: its case $`i`$ in its block, $`0`$ when the signature gives it none, the multiplicity of its grade in the lifting, the parameters of its arguments in the observation, the same arguments used the grade of the recursor times the factor of its result more and scaled by the mode $`{m \odot p'}`$ of its grade $`p'`$ in the lifting, as the [usage](12-usage.md#definitions) of a corecursor scales the variables of a branch in the mode $`m`$, and its [erasure](16-erasure.md#definitions) its arguments in the mode $`{11}^{\mathsf{m}}`$, the ownership of the recursive result whose type is its result, the requirement of the lifting, the ownerships of the destructor that it lifts and the shape of its result:

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
The result of a destructor of a lifting is an instance of a lifting that the signature declares before it, since the signature declares its liftings in order, so that the shape of a lifting reads, for the shapes of the results of its destructors, only the entries before it, without a bound on the depth, and it reads the declaration of the type lifted and its cases in these entries too, which a well-formed signature declares before the lifting, so that the shape of a lifting does not depend on the entries after it, which a signature with more entries adds.
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
& \qquad \quad \text{is the last entry of } \Sigma \text{ that declares a type } D \\
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

### Ownerships of the Shapes

The shape of each nested result has the ownerships $`\varsigma`$ and $`\chi`$, written $`{\Xi \mathrel{◀} \varsigma;\ \chi}`$: each lifted destructor requires $`\varsigma`$ of the value that it observes, and its result has the ownership $`\mathsf{own}_\chi(\Upsilon)`$, $`\chi`$ for the recursor itself and $`1`$ for the corecursor of the next lifting, whatever the ownerships of its arguments, as the [lifting](20-liftings.md#destructors) declares them.
The shape of a nested result also meets the requirements of the recursions on the observations of the field, whose branches see the term of the recursor at the ownership $`o`$, written $`{\Xi \text{ meets } o;\ \varsigma}`$: for each destructor observed at run time, the requirement $`\varsigma_0`$ of the destructor that it lifts on the value that it observes is within $`o`$, and, for all the ownerships $`\bar o`$ of the arguments of its branch that meet their requirements, the arguments of the observation, of the ownerships $`\bar o'`$, meet the requirements of their positions in it, and the value of the ownership $`\psi_0`$ of its result at $`\bar o'`$ is defined and keeps $`o`$, so that the observation has an ownership within $`o`$, as each level of the recursion has; the observation sees the arguments of the branch at $`\mathsf{scale}_\varsigma(\Upsilon)`$, $`1`$ when the recursor runs on it in the branch, and $`\varsigma`$ when the corecursor of the next lifting captures it, and an erased argument, $`\text{↯}`$, has every ownership, its requirement among them.

```math
\begin{aligned}
& \mathsf{own}_\chi(\star_M) = \chi &&(\mathsf{own}_\Upsilon) \\
& \mathsf{own}_\chi(\Xi) = 1 \\[1em]
& \mathsf{scale}_\varsigma(\star_M) = 1 &&(\mathsf{scale}_\Upsilon) \\
& \mathsf{scale}_\varsigma(\Xi) = \varsigma \\[1em]
& () \mathrel{◀} \varsigma;\ \chi &&(\mathsf{uniform}_\Xi) \\[1em]
& {\iff} \\
& \quad ((i,\ \rho',\ \bar\pi \mathrel{◀} \bar\varrho,\ \bar\pi' \mathrel{◀} \bar\varrho',\ \psi,\ \varsigma',\ \psi_0,\ \varsigma_0,\ \Upsilon),\ \Xi) \mathrel{◀} \varsigma;\ \chi \\
& \quad \text{and} \\
& \qquad \varsigma' = \varsigma \\
& \qquad \psi = \mathsf{own}_\chi(\Upsilon) \\
& \qquad \Upsilon \mathrel{◀} \varsigma;\ \chi \\
& \qquad \Xi \mathrel{◀} \varsigma;\ \chi \\[1em]
& \star_M \mathrel{◀} \varsigma;\ \chi &&(\mathsf{uniform}_\Upsilon) \\[1em]
& () \text{ meets } o;\ \varsigma &&(\mathsf{meets}_\Xi) \\[1em]
& {\iff} \\
& \quad ((i,\ \rho',\ \bar\pi \mathrel{◀} \bar\varrho,\ \bar\pi' \mathrel{◀} \bar\varrho',\ \psi,\ \varsigma',\ \psi_0,\ \varsigma_0,\ \Upsilon),\ \Xi) \text{ meets } o;\ \varsigma \\
& \quad \text{and} \\
& \qquad {\implies} \\
& \qquad \quad \rho' \ne 0 \\
& \qquad \quad \text{and} \\
& \qquad \qquad \varsigma_0 \le o \\
& \qquad \qquad \forall \bar o.\ \bar\varrho' \le \bar o \implies \bar\varrho \le \bar o' \text{ and } \exists v.\ \psi_0[\bar o'] = v \text{ and } o \le o \cdot v \\
& \qquad \Upsilon \text{ meets } o;\ \varsigma \\
& \qquad \Xi \text{ meets } o;\ \varsigma \\
& \quad \text{where} \\
& \qquad \text{and} \\
& \qquad \quad o'_k = \varrho_k \text{ if } \pi_k = 0 \\
& \qquad \quad o'_k = \mathsf{scale}_\varsigma(\Upsilon) \cdot (o_k \cdot \pi'_k) \text{ otherwise} \\[1em]
& \star_M \text{ meets } o;\ \varsigma &&(\mathsf{meets}_\Upsilon)
\end{aligned}
```

## Properties

In a signature whose [names are distinct](08-syntax.md), the fields of a telescope have the recursive results of one telescope at most at their nestings, with one sequence of factors, a term has one recursive result at most at its type and at its nesting, and the terms of the fields of a telescope have the recursive results of one sequence of terms at most, since a type has [one lifting at most](20-liftings.md#properties), a name one declaration and a destructor one position in its type:

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

In a well-formed signature, where no parameter is lifted, the terms of fields whose recursive results have types have recursive results, whatever the results $`f`$ of the terms of the types of the block are: the signature declares each lifting after the destructors that it lifts, so that the result of each observation of a term of a type lifted exists, down to the terms of the types of the block, and a recursor on a constructor is never stuck for want of a recursive result:

```math
\begin{aligned}
& \text{⟹} &&(\mathsf{exists}_{\mathsf{res}\Theta}) \\
& \quad \text{and} \\
& \qquad {}\vdash \Sigma \\
& \qquad \Pi = \varnothing \\
& \qquad \Sigma \vdash \Theta \uparrow_{\bar\lambda} = \Theta^{\uparrow} \mathrel{\triangleright} \bar\pi \\
& \qquad \bar t \text{ as many as the fields of } \Theta \\
& \quad \exists \bar t'.\ \Sigma \vdash \mathsf{res}_{f;\ \bar\lambda}(\bar t : \Theta) = \bar t'
\end{aligned}
```
