# Liftings

This annex defines the lifting of a codata type at a set of its parameters, a codata type declared from it whose terms hold, for each observation of a term of the type, a term of a motive at each position of these parameters in the result; it defines the parameters of the lifting and its declaration, the lifting of a type at a term, of the arguments of an instance and of the destructors of a codata type, and the signatures that hold it, with the typing and the ownership of the lifting of a codata type without recursive destructor.
Its definitions build on the [syntax](08-syntax.md), on the [substitution](09-substitution.md), on the variables that [do not occur](14-typing.md#strict-positivity) in a term and on the [nesting](14-typing.md#nesting) of a type, and the typing will read them for the recursive result of a field nested below a codata type.

## Definitions

This section gives the variables of a lifting, its parameters and its declaration, then the lifting of the types and of the arguments of their instances and of the destructors, and the signatures that hold the lifting.

### Variables of a Lifting

The lifting of the type $`D`$ of a block of codata types $`{\mathcal{D} = \mathsf{codata}.\{\bar s;\ \bar l;\ \bar p \mid C_{\mathcal{D}}\}\ \Delta : \kappa\ \mathsf{where}\ \dots}`$ at a set $`\Pi`$ of its parameters is named $`D^\Pi`$, a name of the signature that $`D`$ and $`\Pi`$ determine and that determines them: the liftings of two types, or of a type at two sets of its parameters, have distinct names.
It has the variables of the block and these: the quality $`s_C`$ of the sorts of its motives, the level $`l_Y`$ of the sort of the motive of each parameter $`Y`$ of $`\Pi`$, written $`\bar l_\Pi`$ together, the grade $`r`$ of the recursor that computes its terms, the ownership $`\varsigma`$ that its destructors require of the value that they observe, and the ownership $`\chi`$ of their results.
Each motive has a level of its own, since a sort is equal to another at the same level only: a type lifted is a motive of the lifting of an instance whose argument it is, and its level is not the level of the motive of a parameter.
Its parameters are those of the block, a motive $`C_Y`$ for each parameter $`Y`$ of $`\Pi`$, and a term $`y`$ of the type $`D`$ at these parameters; in the definitions of this section, $`\Pi`$, these variables and these motives are fixed, and a parameter is lifted when it is in $`\Pi`$.

The type of the recursive result of a field nested below a codata type is the type of this field lifted at the types of its block, each of which has the motive of the recursor.
A block lifted $`\mathcal{B}`$ gives each of its types $`E`$ an instance $`T_E`$ of this type and a motive $`{z.\, C_E}`$, a type over a term $`z`$ of $`T_E`$, of the sort of the quality $`s_C`$ and of a level $`l_E`$; it is fixed as $`\Pi`$ is, and the declaration of a lifting lifts no block.
The positions of the types of the block in the type of the field are those of its [nesting](14-typing.md#fields-of-a-block), which the declaration of the field gives: at an instance, an argument of a parameter of the block may hold a type of the block too, which is no position of the block, so that the lifting follows the nesting rather than the names of the types.

The level $`{l \sqcup \bigsqcup \bar l'}`$ is the level $`l`$ [joined](06-levels.md) to each of the levels $`\bar l'`$:

```math
\begin{aligned}
& l \sqcup \textstyle\bigsqcup \varepsilon = l &&(\textstyle\bigsqcup_l) \\
& l \sqcup \textstyle\bigsqcup (l',\ \bar l') = (l \sqcup l') \sqcup \textstyle\bigsqcup \bar l'
\end{aligned}
```

The grade of the result of a destructor of the lifting is the grade of the [mode](05-modes.md) of the grade $`p`$ of the destructor that it lifts, since an observation reads the grade of its destructor by its mode only, without use at run time when the motives are propositions, as the [formation](14-typing.md#destructors-of-a-block) of a destructor whose result is a proposition requires:

```math
\begin{aligned}
& \mathsf{grade}_U(p) = \ulcorner \llcorner p \lrcorner \urcorner &&(\mathsf{grade}_{\uparrow}) \\
& \mathsf{grade}_\Omega(p) = \ulcorner \llcorner p \lrcorner \cdot^{\mathsf{m}} {01}^{\mathsf{m}} \urcorner
\end{aligned}
```

The telescope $`{r \cdot \Theta}`$ is the telescope $`\Theta`$ whose entries are used $`r`$ times more, with the same requirements, and whose variables the types after them use with the least grade $`{\omega\omega}^{\mathsf{p}}`$, which states nothing: the result of a destructor of the lifting uses its arguments more than the result that it lifts, in the observation at which its motive is:

```math
\begin{aligned}
& r \cdot \varepsilon = \varepsilon &&(\mathsf{scale}_\Theta) \\
& r \cdot (x : A \mathrel{▶} p;\ q \mathrel{◀} r',\ \Theta) = (x : A \mathrel{▶} r \cdot p;\ {\omega\omega}^{\mathsf{p}} \mathrel{◀} r',\ r \cdot \Theta)
\end{aligned}
```

### Parameters

The parameters $`{\Delta \uparrow}`$ of the lifting are the parameters $`\Delta`$ in which each parameter lifted is followed by its motive: a type over the telescope of the parameter and a term $`z`$ of it, of the sort of the quality $`s_C`$ and of the level of this motive, which the motive may use as it wants and of which it requires nothing, and whose result has the least ownership, as a type:

```math
\begin{aligned}
& \varepsilon \uparrow = \varepsilon &&(\mathsf{params}_{\uparrow}) \\[1em]
& {=} \text{ if} \\
& \quad (\Delta,\ x : A) \uparrow \\
& \quad (\Delta \uparrow, \\
& \quad \phantom{(}x : A, \\
& \quad \phantom{(}C_x : (z : x \mathrel{▶} {\omega\omega}^{\mathsf{p}};\ {\omega\omega}^{\mathsf{p}} \mathrel{◀} {\omega\omega}^{\mathsf{p}} \vdash (s_C)_{l_x} \mathrel{◀} {\omega\omega}^{\mathsf{p}})) \\
& \quad x \in \Pi \\[1em]
& (\Delta,\ x : A) \uparrow = (\Delta \uparrow,\ x : A) \text{ otherwise} \\[1em]
& {=} \text{ if} \\
& \quad (\Delta,\ X : (\Theta \vdash A \mathrel{◀} \psi)) \uparrow \\
& \quad (\Delta \uparrow, \\
& \quad \phantom{(}X : (\Theta \vdash A \mathrel{◀} \psi), \\
& \quad \phantom{(}C_X : (\Theta,\ z : X[\bar x] \mathrel{▶} {\omega\omega}^{\mathsf{p}};\ {\omega\omega}^{\mathsf{p}} \mathrel{◀} {\omega\omega}^{\mathsf{p}} \vdash (s_C)_{l_X} \mathrel{◀} {\omega\omega}^{\mathsf{p}})) \\
& \quad X \in \Pi \\[1em]
& (\Delta,\ X : (\Theta \vdash A \mathrel{◀} \psi)) \uparrow = (\Delta \uparrow,\ X : (\Theta \vdash A \mathrel{◀} \psi)) \text{ otherwise}
\end{aligned}
```

In the fourth case, $`\bar x`$ are the variables of $`\Theta`$.

### Declaration

The lifting $`{\mathsf{lifting}_\Pi(\mathcal{D},\ D,\ \bar d')}`$ of the type $`D`$ of the block $`\mathcal{D}`$, whose sort is $`{\kappa = s_l}`$, at the parameters $`\Pi`$, with the destructors $`\bar d'`$, is a block of one codata type, since the types of a block share their parameters while each lifting has a term of its own type.
It has the constraint of the block, the parameters lifted followed by the term $`y`$, and the sort of the quality $`s_C`$ and of the level of the block joined to the levels of the motives; it uses its parameters with the grades $`\zeta`$ that give each of them the least grade $`{\omega\omega}^{\mathsf{p}}`$, which states nothing, and declares no parameter in which it is strictly positive:

```math
\begin{aligned}
& {=} &&(\mathsf{lifting}_{\mathcal{D}}) \\
& \quad \mathsf{lifting}_\Pi(\mathcal{D},\ D,\ \bar d') \\
& \quad \mathsf{codata}.\{\bar s, s_C;\ \bar l, \bar l_\Pi;\ \bar p, r, \varsigma, \chi \mid C_{\mathcal{D}}\} \\
& \qquad (\Delta \uparrow,\ y : D.\{\bar s;\ \bar l;\ \bar p\}\ \bar x_\Delta) : (s_C)_{l \sqcup \bigsqcup \bar l_\Pi} \\
& \qquad \mathsf{where} \\
& \qquad \quad D^\Pi \mathrel{▶} \zeta \oplus \varnothing \mathrel{≔} \bar d'
\end{aligned}
```

### Types

The relation $`{\Sigma \vdash A \uparrow_\lambda u = A' : (s_C)_l}`$ reads: the type $`A'`$, of the level $`l`$, is the type $`A`$, whose nesting is $`\lambda`$, lifted at the term $`u`$ of $`A`$.
A parameter lifted, applied to arguments in which no parameter lifted occurs, without position, is lifted to its motive at these arguments and at the term, of the level of this motive; the instance $`T_E`$ of a type of the block lifted, at a position that holds this type, is lifted to its motive at the term, of the level of this motive; an instance of a declared type whose nesting is not a position, of which an argument at least is lifted, is lifted to the instance of the lifting of this type at the parameters of these arguments, which the signature declares, at the variables of the lifting, at the levels of the arguments lifted, at these arguments and at the term, of the level of the instance joined to these levels:

```math
\begin{gathered}
\frac{\begin{aligned}& Y \in \Pi \\[0.6em] & \text{no parameter of } \Pi \text{ occurs in } \bar t\end{aligned}}{\Sigma \vdash Y[\bar t] \uparrow_\bot u = C_Y[\bar t,\ u] : (s_C)_{l_Y}}\;(\uparrow_X) \\[2em]
\frac{E \text{ is a type of } \mathcal{B}}{\Sigma \vdash T_E \uparrow_E u = C_E[u / z] : (s_C)_{l_E}}\;(\uparrow_T) \\[2em]
\frac{\begin{aligned}& \lambda = \bot \text{ and each of } \bar\lambda \text{ is } \bot \text{, or } \lambda = (\bar\lambda) \\[0.6em] & D.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : s_l \mathrel{▶} \zeta \in \Sigma \\[0.6em] & \bar s',\ \bar l',\ \bar p' \text{ as many as } \bar s,\ \bar l,\ \bar p \\[0.6em] & \Sigma \vdash \bar a \uparrow_{\bar\lambda} = (\Pi';\ \bar l'';\ \bar a') \\[0.6em] & \Pi' \ne \varnothing \\[0.6em] & \mathsf{lifting}_{\Pi'}(\mathcal{D}',\ D,\ \bar d'') \in \Sigma\end{aligned}}{\begin{aligned}& \Sigma \\ & {\vdash}\ D.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a \uparrow_\lambda u \\ & {=}\ D^{\Pi'}.\{\bar s', s_C;\ \bar l', \bar l'';\ \bar p', r, \varsigma, \chi\}\ (\bar a',\ u) \\ & {:}\ (s_C)_{l[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p] \sqcup \bigsqcup \bar l''}\end{aligned}}\;(\uparrow_D)
\end{gathered}
```

In the rule $`(\uparrow_D)`$, $`\mathcal{D}'`$ is the block of the signature that declares $`D`$, and the signature declares the [lifting](#declaration) of $`D`$ at $`\Pi'`$ with some destructors $`\bar d''`$, whatever they are: the type lifted names this lifting, whose parameters and sort its declaration gives without its destructors, while the destructors of a lifting are defined from this relation.
In the rule $`(\uparrow_D)`$, $`\bar\lambda`$ are the nestings of the arguments, none of which has a position when the instance has none.
A type in which no parameter lifted occurs and whose nesting has no position has no lifting, nor has a type in which a parameter lifted occurs otherwise, in a term or below a second-order variable, nor an instance whose lifting the signature does not declare.

The relation $`{\Sigma \vdash \bar a \uparrow_{\bar\lambda} = (\Pi';\ \bar l;\ \bar a')}`$ reads: the arguments $`\bar a'`$ are the arguments $`\bar a`$ of an instance lifted, whose nestings are $`\bar\lambda`$, $`\Pi'`$ is the set of the parameters of the instance whose arguments are lifted, and $`\bar l`$ are the levels of these arguments lifted, in the order of the parameters.
An argument that is lifted is followed by its motive, the argument lifted at a term $`z`$ of its own, under the variables that its abstraction binds, and an argument in which no parameter lifted occurs and whose nesting has no position is kept; in these rules, $`Y`$ is the parameter of the instance whose argument is $`{\bar x.\, B}`$:

```math
\begin{gathered}
\frac{}{\Sigma \vdash () \uparrow_{()} = (\varnothing;\ \varepsilon;\ ())}\;(\uparrow_{\bar a\varepsilon}) \\[2em]
\frac{\begin{aligned}& \Sigma \vdash \bar a \uparrow_{\bar\lambda} = (\Pi';\ \bar l;\ \bar a') \\[0.6em] & \Sigma \vdash B \uparrow_\lambda z = B' : (s_C)_{l'}\end{aligned}}{\Sigma \vdash (\bar a,\ \bar x.\, B) \uparrow_{(\bar\lambda,\ \lambda)} = (\Pi' \cup \{Y\};\ (\bar l, l');\ (\bar a',\ \bar x.\, B,\ (\bar x, z).\, B'))}\;(\uparrow_{\bar a,}) \\[2em]
\frac{\begin{aligned}& \Sigma \vdash \bar a \uparrow_{\bar\lambda} = (\Pi';\ \bar l;\ \bar a') \\[0.6em] & \text{no parameter of } \Pi \text{ occurs in } B\end{aligned}}{\Sigma \vdash (\bar a,\ \bar x.\, B) \uparrow_{(\bar\lambda,\ \bot)} = (\Pi';\ \bar l;\ (\bar a',\ \bar x.\, B))}\;(\uparrow_{\bar a\notin})
\end{gathered}
```

### Destructors

The relation $`{\Sigma \vdash \bar d \uparrow y = \bar d'}`$ reads: the destructors $`\bar d'`$ are the destructors $`\bar d`$ of the type $`D`$ lifted at the term $`y`$ of its instance $`{T = D.\{\bar s;\ \bar l;\ \bar p\}\ \bar x_\Delta}`$ at the parameters themselves.
The lifting has each destructor whose result, which has no position since the declaration of a lifting lifts no block, is lifted at the observation of $`y`$ by it, at its arguments $`\bar x`$, used $`r`$ times more, since the recursor eliminates this observation $`r`$ times, with this result, of the ownership $`\chi`$ whatever the ownerships of the arguments are, and the requirement $`\varsigma`$; it has no destructor for a destructor in whose result no parameter lifted occurs.
The sort of the result lifted is bounded by the sort $`{\kappa' = (s_C)_{l \sqcup \bigsqcup \bar l_\Pi}}`$ of the lifting, where $`l`$ is the level of the sort of the block, as the [formation](14-typing.md#destructors-of-a-block) of a destructor requires of its result: the relation reads the syntax only, while the level of the lifting of an instance is the level of the type that it lifts, which nothing here compares to the level of the block.
In the destructors after it, each destructor is the [observation](09-substitution.md) of $`y`$ by it, so that the destructors of the lifting do not depend on one another, and none is used by the types of those after it:

```math
\begin{gathered}
\frac{}{\Sigma \vdash \varepsilon \uparrow y = \varepsilon}\;(\uparrow_{\bar d\varepsilon}) \\[2em]
\frac{\begin{aligned}& \Sigma \vdash B \uparrow_\bot y.(T.d)(\bar x) = B' : (s_C)_{l'} \\[0.6em] & (s_C)_{l'} \preceq \kappa' \\[0.6em] & \Sigma \vdash \bar d[y.T / d] \uparrow y = \bar d'\end{aligned}}{\begin{aligned}& \Sigma \\ & {\vdash}\ (d : (\Theta \vdash B \mathrel{◀} \psi) \mathrel{▶} p;\ q \mathrel{◀} \varsigma' \mid \bar d) \uparrow y \\ & {=}\ (d : (r \cdot \Theta \vdash B' \mathrel{◀} \chi) \mathrel{▶} \mathsf{grade}_{s_C}(p);\ {00}^{\mathsf{p}} \mathrel{◀} \varsigma \mid \bar d')\end{aligned}}\;(\uparrow_{\bar d|}) \\[2em]
\frac{\begin{aligned}& \text{no parameter of } \Pi \text{ occurs in } B \\[0.6em] & \Sigma \vdash \bar d[y.T / d] \uparrow y = \bar d'\end{aligned}}{\Sigma \vdash (d : (\Theta \vdash B \mathrel{◀} \psi) \mathrel{▶} p;\ q \mathrel{◀} \varsigma' \mid \bar d) \uparrow y = \bar d'}\;(\uparrow_{\bar d\notin})
\end{gathered}
```

### Signatures

The destructors $`\bar d'`$ are those of the lifting of $`D`$ at $`\Pi`$, written $`{\Sigma;\ \mathcal{D} \vdash D \uparrow_\Pi \bar d'}`$, when $`D`$ is a type of the block and, at each instance of the variables of the lifting, they are its destructors $`\bar d_D`$ lifted at $`y`$, with the variables of the lifting at this instance; their names are those of the destructors of $`D`$ whose results are lifted, which are thus the same at each instance:

```math
\begin{aligned}
& \text{⟺} &&(\uparrow_{\mathcal{D}}) \\
& \quad \Sigma;\ \mathcal{D} \vdash D \uparrow_\Pi \bar d' \\
& \quad \text{and} \\
& \qquad D \text{ is a type of } \mathcal{D} \text{, a block of codata types} \\
& \qquad \forall \bar s',\ s'_C,\ \bar p',\ r',\ \varsigma',\ \chi' \text{ as many as } \bar s,\ s_C,\ \bar p,\ r,\ \varsigma,\ \chi. \\
& \qquad \quad \Sigma \vdash \bar d_D[\bar s' / \bar s,\ \bar p' / \bar p] \uparrow y \\
& \qquad \quad {=}\ \bar d'[\bar s', s'_C / \bar s, s_C,\ \bar p', r', \varsigma', \chi' / \bar p, r, \varsigma, \chi]
\end{aligned}
```

A signature holds the lifting of its type $`D`$ at the parameters $`\Pi`$, written $`{D^\Pi \in \Sigma}`$, when it has a block that declares $`D`$ and the lifting of $`D`$ at $`\Pi`$, with its destructors, as it [holds the prelude](19-prelude.md#declarations):

```math
\begin{aligned}
& \text{⟺} &&(\in_{\uparrow}) \\
& \quad D^\Pi \in \Sigma \\
& \quad \exists \mathcal{D},\ \bar d'. \\
& \qquad \text{and} \\
& \qquad \quad \mathcal{D} \in \Sigma \\
& \qquad \quad \Sigma;\ \mathcal{D} \vdash D \uparrow_\Pi \bar d' \\
& \qquad \quad \mathsf{lifting}_\Pi(\mathcal{D},\ D,\ \bar d') \in \Sigma
\end{aligned}
```

The lifting is an entry of the signature, whose formation and whose ownership are checked as those of the others, so that a type whose lifting is not well formed, such as a recursive codata type, whose lifting is not at its parameters themselves, or a codata type with a result below a data type, which has no lifting, has no lifting that a well-formed signature holds.
The [formation](14-typing.md#signatures-and-entries) of the signatures has a rule of its own for it, which asks in addition for these destructors, and gives the name of a lifting to no other entry.
The [usage](12-usage.md#definitions) of the signatures has a rule of its own for it, which does not check its destructors.

## Properties

A type has one lifting at most, a well-formed signature holds the liftings that it declares, and the lifting of a codata type of which no destructor is [recursive](14-typing.md#destructors-of-a-block), at any instance, is well formed, and a signature followed by it has the ownerships of its entries.

In a signature whose [names are distinct](08-syntax.md), a type has one lifting at most at a term and at its nesting, of one level, and the arguments of an instance are lifted in one way at most at their nestings, with the same parameters lifted and the same levels:

```math
\begin{aligned}
& \text{⟹} &&(\mathsf{unique}_{\uparrow}) \\
& \quad \text{and} \\
& \qquad \text{the names of } \Sigma \text{ are distinct} \\
& \qquad \Sigma \vdash A \uparrow_\lambda u = A'_1 : (s_C)_{l_1} \\
& \qquad \Sigma \vdash A \uparrow_\lambda u = A'_2 : (s_C)_{l_2} \\
& \quad A'_1 = A'_2 \text{ and } l_1 = l_2 \\[1em]
& \text{⟹} &&(\mathsf{unique}_{\uparrow\bar a}) \\
& \quad \text{and} \\
& \qquad \text{the names of } \Sigma \text{ are distinct} \\
& \qquad \Sigma \vdash \bar a \uparrow_{\bar\lambda} = (\Pi_1;\ \bar l_1;\ \bar a'_1) \\
& \qquad \Sigma \vdash \bar a \uparrow_{\bar\lambda} = (\Pi_2;\ \bar l_2;\ \bar a'_2) \\
& \quad \Pi_1 = \Pi_2 \text{ and } \bar l_1 = \bar l_2 \text{ and } \bar a'_1 = \bar a'_2
\end{aligned}
```

A well-formed signature holds the lifting that it declares of a type of one of its blocks, with whatever destructors: they are those of this type lifted, which the rule $`(\uparrow_D)`$ therefore need not ask for:

```math
\begin{aligned}
& \text{⟹} &&(\mathsf{sig}_{\uparrow}) \\
& \quad \text{and} \\
& \qquad {}\vdash \Sigma \\
& \qquad \mathcal{D} \in \Sigma \\
& \qquad D \text{ is a type of } \mathcal{D} \\
& \qquad \mathsf{lifting}_\Pi(\mathcal{D},\ D,\ \bar d') \in \Sigma \\
& \quad \Sigma;\ \mathcal{D} \vdash D \uparrow_\Pi \bar d'
\end{aligned}
```

A well-formed signature gives a well-formed [type declaration](14-typing.md#type-declarations) to the lifting of a codata type of one of its blocks, of which no destructor is recursive, when each parameter lifted is a type, at the variables $`\bar x`$ of its telescope, in the parameters $`\Delta_1`$ before it followed by it, at each instance that the constraint of the block admits, and when no entry of the signature introduces its name $`D^\Pi`$: the motive of a parameter is a type over a term of this parameter, which neither the relation of the destructors lifted nor the strict positivity requires to be a type:

```math
\begin{aligned}
& \text{⟹} &&(\mathsf{lift}_\vdash) \\
& \quad \text{and} \\
& \qquad {}\vdash \Sigma \\
& \qquad \mathcal{D} \in \Sigma \\
& \qquad \Sigma;\ \mathcal{D} \vdash D \uparrow_\Pi \bar d' \\
& \qquad \text{no entry of } \Sigma \text{ introduces } D^\Pi \\
& \qquad \forall \bar s',\ \bar p' \text{ as many as } \bar s,\ \bar p.\ \mathsf{rec}_{\mathcal{D}}(\bar d_D[\bar s' / \bar s,\ \bar p' / \bar p]) = (\bot,\ \dots,\ \bot) \\
& \qquad \forall \bar s',\ \bar p' \text{ as many as } \bar s,\ \bar p.\ \forall \Delta_1,\ x,\ A,\ \Delta_2. \\
& \qquad \quad \text{⟹} \\
& \qquad \qquad \text{and} \\
& \qquad \qquad \quad C_{\mathcal{D}}[\bar s' / \bar s,\ \bar p' / \bar p] \\
& \qquad \qquad \quad \Delta[\bar s' / \bar s,\ \bar p' / \bar p] = (\Delta_1,\ x : A,\ \Delta_2) \\
& \qquad \qquad \quad x \in \Pi \\
& \qquad \qquad \Sigma;\ \Delta_1,\ x : A \vdash x \\
& \qquad \forall \bar s',\ \bar p' \text{ as many as } \bar s,\ \bar p.\ \forall \Delta_1,\ X,\ \Theta,\ A,\ \psi,\ \Delta_2. \\
& \qquad \quad \text{⟹} \\
& \qquad \qquad \text{and} \\
& \qquad \qquad \quad C_{\mathcal{D}}[\bar s' / \bar s,\ \bar p' / \bar p] \\
& \qquad \qquad \quad \Delta[\bar s' / \bar s,\ \bar p' / \bar p] = (\Delta_1,\ X : (\Theta \vdash A \mathrel{◀} \psi),\ \Delta_2) \\
& \qquad \qquad \quad X \in \Pi \\
& \qquad \qquad \Sigma;\ \Delta_1,\ X : (\Theta \vdash A \mathrel{◀} \psi),\ \Theta \vdash X[\bar x] \\
& \quad \Sigma \vdash \mathsf{lifting}_\Pi(\mathcal{D},\ D,\ \bar d')
\end{aligned}
```

A signature whose entries have their [ownerships](13-ownership.md#definitions), followed by the lifting of a codata type of which no destructor is recursive, at any instance, has the ownerships of its entries: the lifting has no recursive destructor either, since the result of each of its destructors is a motive, or an instance of the lifting of another type:

```math
\begin{aligned}
& \text{⟹} &&(\mathsf{lift}_{◀}) \\
& \quad \text{and} \\
& \qquad {}\vdash \Sigma \mathrel{◀} \\
& \qquad \Sigma;\ \mathcal{D} \vdash D \uparrow_\Pi \bar d' \\
& \qquad \forall \bar s',\ \bar p' \text{ as many as } \bar s,\ \bar p.\ \mathsf{rec}_{\mathcal{D}}(\bar d_D[\bar s' / \bar s,\ \bar p' / \bar p]) = (\bot,\ \dots,\ \bot) \\
& \quad {}\vdash (\Sigma,\ \mathsf{lifting}_\Pi(\mathcal{D},\ D,\ \bar d')) \mathrel{◀}
\end{aligned}
```
