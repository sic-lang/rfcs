# Recursive Results

This annex defines the recursive results of the fields of a constructor, which a branch of a recursor binds after its fields: their types, the motive of its type for a recursive field and the type of the field lifted for a field nested below a codata type, and the terms that the computation of a recursor gives them, with their properties.
It builds on the [syntax](08-syntax.md), on the [substitution](09-substitution.md), on the [nesting](14-typing.md#nesting) of the fields of a block and on the [liftings](20-liftings.md), and the typing and the reduction of the recursors will read its definitions.

## Definitions

This section gives the types of the recursive results of the fields of a telescope, then the terms of these results.
In its definitions, the block lifted $`\mathcal{B}`$, the set $`\Pi`$ of the parameters lifted and the variables $`s_C`$, $`r`$, $`\varsigma`$ and $`\chi`$ are fixed, as in the definitions of the [liftings](20-liftings.md#variables-of-a-lifting): a recursor gives them the types of its block, each with its instance and its motive, no parameter lifted, the quality of the sort of its motives, its grade and its two ownerships.

The results are relations, as the lifting is: a field whose type has no lifting, since the signature does not declare it, has no result.
The [nesting](14-typing.md#fields-of-a-block) of each field, which its declaration gives, tells whether it has a result: a field without position has none, a field whose nesting is a position that holds a type of the block is recursive, and a field whose nesting is that of an instance, $`(\bar\lambda)`$, is nested.

### Types of the Results

The relation $`{\Sigma \vdash \Theta \uparrow_{\bar\lambda} = \Theta^{\uparrow}}`$ reads: the recursive results $`\Theta^{\uparrow}`$ are those of the fields $`\Theta`$, whose nestings are $`\bar\lambda`$, a variable $`y`$ with its type for each field whose nesting has a position, in order.
A field without position has no result; the result of a recursive field $`x`$ of the type $`E`$ of the block lifted has the motive of $`E`$ at the field; the result of a nested field $`{x : A}`$ has the type $`A`$ [lifted](20-liftings.md#types) at the field:

```math
\begin{gathered}
\frac{}{\Sigma \vdash \varepsilon \uparrow_{()} = \varepsilon}\;(\uparrow_{\Theta\varepsilon}) \\[2em]
\frac{\Sigma \vdash \Theta \uparrow_{\bar\lambda} = \Theta^{\uparrow}}{\Sigma \vdash (x : A \mathrel{▶} p;\ q \mathrel{◀} r',\ \Theta) \uparrow_{(\bot,\ \bar\lambda)} = \Theta^{\uparrow}}\;(\uparrow_{\Theta\bot}) \\[2em]
\frac{\begin{aligned}& E \text{ is a type of } \mathcal{B} \\[0.6em] & \Sigma \vdash \Theta \uparrow_{\bar\lambda} = \Theta^{\uparrow}\end{aligned}}{\Sigma \vdash (x : A \mathrel{▶} p;\ q \mathrel{◀} r',\ \Theta) \uparrow_{(E,\ \bar\lambda)} = (y : C_E[x / z],\ \Theta^{\uparrow})}\;(\uparrow_{\Theta T}) \\[2em]
\frac{\begin{aligned}& \Sigma \vdash A \uparrow_{(\bar\lambda')} x = A' : (s_C)_l \\[0.6em] & \Sigma \vdash \Theta \uparrow_{\bar\lambda} = \Theta^{\uparrow}\end{aligned}}{\Sigma \vdash (x : A \mathrel{▶} p;\ q \mathrel{◀} r',\ \Theta) \uparrow_{((\bar\lambda'),\ \bar\lambda)} = (y : A',\ \Theta^{\uparrow})}\;(\uparrow_{\Theta\lambda})
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
\frac{\begin{aligned}& \lambda = \bot \text{ and each of } \bar\lambda \text{ is } \bot \text{, or } \lambda = (\bar\lambda) \\[0.6em] & \mathcal{D}' \in \Sigma \\[0.6em] & \bar s',\ \bar l',\ \bar p' \text{ as many as } \bar s,\ \bar l,\ \bar p \\[0.6em] & \Sigma \vdash \bar a \uparrow_{\bar\lambda} = (\Pi';\ \bar l'';\ \bar a') \\[0.6em] & \Pi' \ne \varnothing \\[0.6em] & \mathsf{lifting}_{\Pi'}(\mathcal{D}',\ D,\ \bar d'') \in \Sigma \\[0.6em] & \bar d'' = (d_1 : \dots \mid \dots \mid d_n : \dots) \\[0.6em] & \forall i. \\ & \quad {=} \\ & \qquad \bar d[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p] \\ & \qquad (\bar d_{i,1} \mid d_i : (\Theta_i \vdash B_i \mathrel{◀} \psi_i) \mathrel{▶} p_i;\ q_i \mathrel{◀} \varsigma_i \mid \bar d_{i,2}) \\[0.6em] & \forall i. \\ & \quad \Sigma \\ & \quad {\vdash}\ \mathsf{res}_{f;\ \mathsf{nest}_\Lambda(B_i)}(t.(T.d_i)(\bar z_i) : B_i[\bar a / \Delta,\ t.T / \bar d_{i,1}]) \\ & \quad {=}\ g_i\end{aligned}}{\begin{aligned}& \Sigma \\ & {\vdash}\ \mathsf{res}_{f;\ \lambda}(t : D.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a) \\ & {=}\ \mathsf{corec}_r\ (D^{\Pi'}.\{\bar s', s_C;\ \bar l', \bar l'';\ \bar p', r, \varsigma, \chi\}\ (\bar a',\ t)) \\ & \qquad \mathsf{from}\ () \\ & \qquad \mathsf{return}\ (\varepsilon : ()) \\ & \qquad \mathsf{with}\ (D^{\Pi'}.d_1(;\ ;\ \bar z_1) \Rightarrow g_1,\ \dots,\ D^{\Pi'}.d_n(;\ ;\ \bar z_n) \Rightarrow g_n)\end{aligned}}\;(\mathsf{res}_D)
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

## Properties

In a signature whose [names are distinct](08-syntax.md), the fields of a telescope have the recursive results of one telescope at most at their nestings, a term has one recursive result at most at its type and at its nesting, and the terms of the fields of a telescope have the recursive results of one sequence of terms at most, since a type has [one lifting at most](20-liftings.md#properties), a name one declaration and a destructor one position in its type:

```math
\begin{aligned}
& \text{⟹} &&(\mathsf{unique}_{\uparrow\Theta}) \\
& \quad \text{and} \\
& \qquad \text{the names of } \Sigma \text{ are distinct} \\
& \qquad \Sigma \vdash \Theta \uparrow_{\bar\lambda} = \Theta^{\uparrow}_1 \\
& \qquad \Sigma \vdash \Theta \uparrow_{\bar\lambda} = \Theta^{\uparrow}_2 \\
& \quad \Theta^{\uparrow}_1 = \Theta^{\uparrow}_2 \\[1em]
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
& \qquad \Sigma \vdash \Theta \uparrow_{\bar\lambda} = \Theta^{\uparrow} \\
& \qquad \bar t \text{ as many as the fields of } \Theta \\
& \quad \exists \bar t'.\ \Sigma \vdash \mathsf{res}_{f;\ \bar\lambda}(\bar t : \Theta) = \bar t'
\end{aligned}
```
