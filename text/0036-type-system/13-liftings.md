# Liftings

This annex defines the lifting of a codata type at a set of its parameters, a codata type declared from it whose terms hold, for each observation of a term of the type, a term of a motive at each position of these parameters in the result; it defines the parameters of the lifting and its declaration, the lifting of a type at a term and of the arguments of an instance, the factor of the result of a destructor of a lifting, the lifting of the destructors of a codata type, and the signatures that hold it, with the uniqueness of the lifting and of its factor and the destructors of the lifting at an instance.
Its definitions build on the [syntax](08-syntax.md), on the [substitution](09-substitution.md), on the variables that [do not occur](15-typing.md#strict-positivity) in a term and on the [nesting](08-syntax.md#nesting) of a type, and the [recursive results](14-recursive-results.md) read them for the result of a field nested below a codata type.

## Definitions

This section gives the variables of a lifting, its parameters and its declaration, then the lifting of the types and of the arguments of their instances, the factors of the results of the destructors of a lifting, the lifting of the destructors, and the signatures that hold the lifting.

### Variables of a Lifting

The lifting of the type $`D`$ of a block of codata types $`{\mathcal{D} = \mathsf{codata}.\{\bar s;\ \bar l;\ \bar p \mid C_{\mathcal{D}}\}\ \Delta : \kappa\ \mathsf{where}\ \dots}`$ at a set $`\Pi`$ of its parameters is named $`D^\Pi`$, a name of the signature that $`D`$ and $`\Pi`$ determine and that determines them: the liftings of two types, or of a type at two sets of its parameters, have distinct names.
It has the variables of the block and these: the quality $`s_C`$ of the sorts of its motives, the level $`l_Y`$ of the sort of the motive of each parameter $`Y`$ of $`\Pi`$, written $`\bar l_\Pi`$ together, the grade $`r`$ of the recursor that computes its terms, the ownership $`\varsigma`$ that its destructors require of the value that they observe, and the factor $`\pi_Y`$ and the ownership $`\chi_Y`$ of the recursive results whose type is the motive of each parameter $`Y`$ of $`\Pi`$, written $`\overline{\pi, \chi}_\Pi`$ together, in the order of the parameters.
Each motive has a level of its own, since a sort is equal to another at the same level only, and a factor and an ownership of its own: a type lifted is a motive of the lifting of an instance whose argument it is, whose level is not the level of the motive of a parameter, and whose recursive result may be a corecursor, of its own factor and owned alone, rather than a result of the recursor.
Its parameters are those of the block, a motive $`C_Y`$ for each parameter $`Y`$ of $`\Pi`$, and a term $`y`$ of the type $`D`$ at these parameters; in the definitions of this section, $`\Pi`$, these variables and these motives are fixed, and a parameter is lifted when it is in $`\Pi`$.

The type of the recursive result of a field nested below a codata type is the type of this field lifted at the types of its block, each of which has the motive of the recursor.
A block lifted $`\mathcal{B}`$ gives each of its types $`E`$ an instance $`T_E`$ of this type and a motive $`{z.\, C_E}`$, a type over a term $`z`$ of $`T_E`$, of the sort of the quality $`s_C`$ and of a level $`l_E`$, and the ownership $`\chi`$ of the results of the recursor; it is fixed as $`\Pi`$ is, and the declaration of a lifting lifts no block.
The positions of the types of the block in the type of the field are those of its [nesting](08-syntax.md#fields-of-a-block), which the declaration of the field gives: at an instance, an argument of a parameter of the block may hold a type of the block too, which is no position of the block, so that the lifting follows the nesting rather than the names of the types.

The level $`{l \sqcup \bigsqcup \bar l'}`$ is the level $`l`$ [joined](06-levels.md) to each of the levels $`\bar l'`$:

```math
\begin{aligned}
& l \sqcup \textstyle\bigsqcup \varepsilon = l &&(\textstyle\bigsqcup_l) \\
& l \sqcup \textstyle\bigsqcup (l',\ \bar l') = (l \sqcup l') \sqcup \textstyle\bigsqcup \bar l'
\end{aligned}
```

The grade of the result of a destructor of the lifting is the grade of the [mode](05-modes.md) of the grade $`p`$ of the destructor that it lifts, since an observation reads the grade of its destructor by its mode only, without use at run time when the motives are propositions, as the [formation](15-typing.md#destructors-of-a-block) of a destructor whose result is a proposition requires:

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
& \quad \mathsf{codata}.\{\bar s, s_C;\ \bar l, \bar l_\Pi;\ \bar p, r, \varsigma, \overline{\pi, \chi}_\Pi \mid C_{\mathcal{D}}\} \\
& \qquad (\Delta \uparrow,\ y : D.\{\bar s;\ \bar l;\ \bar p\}\ \bar x_\Delta) : (s_C)_{l \sqcup \bigsqcup \bar l_\Pi} \\
& \qquad \mathsf{where} \\
& \qquad \quad D^\Pi \mathrel{▶} \zeta \oplus \varnothing \mathrel{≔} \bar d'
\end{aligned}
```

### Types

The relation $`{\Sigma \vdash A \uparrow_\lambda u = A' : (s_C)_l \mathrel{\triangleright} \pi;\ \chi'}`$ reads: the type $`A'`$, of the level $`l`$, is the type $`A`$, whose nesting is $`\lambda`$, lifted at the term $`u`$ of $`A`$, and the recursive result whose type it is has the factor $`\pi`$ and the ownership $`\chi'`$.
A parameter lifted, applied to arguments in which no parameter lifted occurs, without position, is lifted to its motive at these arguments and at the term, of the level, the factor and the ownership of this motive; an instance of a type $`E`$ of the block lifted, at a position that holds this type, is lifted to its motive at the term, whatever its variables and its arguments are, of the level of this motive, of the factor $`{11}^{\mathsf{p}}`$, since its recursive result runs the recursor once, and of the ownership $`\chi`$ of the results of the recursor; an instance of a declared type whose nesting is not a position, of which an argument at least is lifted, is lifted to the instance of the lifting of this type at the parameters of these arguments, which the signature declares, at the variables of the lifting, at the levels, the factors and the ownerships of the arguments lifted, at these arguments and at the term, of the level of the instance joined to these levels, of its factor, and of the ownership $`{11}^{\mathsf{p}}`$, since its recursive result is a new value, a corecursor:

```math
\begin{gathered}
\frac{\begin{aligned}& Y \in \Pi \\[0.6em] & \text{no parameter of } \Pi \text{ occurs in } \bar t\end{aligned}}{\Sigma \vdash Y[\bar t] \uparrow_\bot u = C_Y[\bar t,\ u] : (s_C)_{l_Y} \mathrel{\triangleright} \pi_Y;\ \chi_Y}\;(\uparrow_X) \\[2em]
\frac{E \text{ is a type of } \mathcal{B}}{\Sigma \vdash E.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a \uparrow_E u = C_E[u / z] : (s_C)_{l_E} \mathrel{\triangleright} {11}^{\mathsf{p}};\ \chi}\;(\uparrow_T) \\[2em]
\frac{\begin{aligned}& \lambda = \bot \text{ and each of } \bar\lambda \text{ is } \bot \text{, or } \lambda = (\bar\lambda) \\[0.6em] & D.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : s_l \mathrel{▶} \zeta \in \Sigma \\[0.6em] & \bar s',\ \bar l',\ \bar p' \text{ as many as } \bar s,\ \bar l,\ \bar p \\[0.6em] & \Sigma \vdash \bar a \uparrow_{\bar\lambda} = (\Pi';\ \bar l'';\ \overline{\pi'', \chi''};\ \bar a') \\[0.6em] & \Pi' \ne \varnothing \\[0.6em] & \mathsf{lifting}_{\Pi'}(\mathcal{D}',\ D,\ \bar d'') \in \Sigma \\[0.6em] & A' = D^{\Pi'}.\{\bar s', s_C;\ \bar l', \bar l'';\ \bar p', r, \varsigma, \overline{\pi'', \chi''}\}\ (\bar a',\ u) \\[0.6em] & \Sigma \vdash \mathsf{factor}_{\bar\pi_\Pi}(A') = \pi\end{aligned}}{\begin{aligned}& \Sigma \\ & {\vdash}\ D.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a \uparrow_\lambda u = A' \\ & {:}\ (s_C)_{l[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p] \sqcup \bigsqcup \bar l''} \\ & {\triangleright}\ \pi;\ {11}^{\mathsf{p}}\end{aligned}}\;(\uparrow_D)
\end{gathered}
```

In the rule $`(\uparrow_T)`$, the position tells that the instance is $`T_E`$, the one that the motive is over, which a well-formed declaration ensures: the rule does not compare them.
In the rule $`(\uparrow_D)`$, $`\mathcal{D}'`$ is the block of the signature that declares $`D`$, and the signature declares the [lifting](#declaration) of $`D`$ at $`\Pi'`$ with some destructors $`\bar d''`$, whatever they are: the type lifted names this lifting, whose parameters and sort its declaration gives without its destructors, while the destructors of a lifting are defined from this relation.
In the rule $`(\uparrow_D)`$, $`\bar\lambda`$ are the nestings of the arguments, none of which has a position when the instance has none, and $`\bar\pi_\Pi`$ gives the motive of each parameter $`Y`$ of $`\Pi`$ its factor $`\pi_Y`$, which the [factor](#factors) of an instance of a lifting does not read.
A type in which no parameter lifted occurs and whose nesting has no position has no lifting, nor has a type in which a parameter lifted occurs otherwise, in a term or below a second-order variable, nor an instance whose lifting the signature does not declare.

The relation $`{\Sigma \vdash \bar a \uparrow_{\bar\lambda} = (\Pi';\ \bar l;\ \overline{\pi, \chi};\ \bar a')}`$ reads: the arguments $`\bar a'`$ are the arguments $`\bar a`$ of an instance lifted, whose nestings are $`\bar\lambda`$, $`\Pi'`$ is the set of the parameters of the instance whose arguments are lifted, $`\bar l`$ are the levels of these arguments lifted, and $`\overline{\pi, \chi}`$ the factors and the ownerships of the recursive results whose types they are, in the order of the parameters.
An argument that is lifted is followed by its motive, the argument lifted at a term $`z`$ of its own, under the variables that its abstraction binds, and an argument in which no parameter lifted occurs and whose nesting has no position is kept; in these rules, $`Y`$ is the parameter of the instance whose argument is $`{\bar x.\, B}`$:

```math
\begin{gathered}
\frac{}{\Sigma \vdash () \uparrow_{()} = (\varnothing;\ \varepsilon;\ \varepsilon;\ ())}\;(\uparrow_{\bar a\varepsilon}) \\[2em]
\frac{\begin{aligned}& \Sigma \vdash \bar a \uparrow_{\bar\lambda} = (\Pi';\ \bar l;\ \overline{\pi, \chi};\ \bar a') \\[0.6em] & \Sigma \vdash B \uparrow_\lambda z = B' : (s_C)_{l'} \mathrel{\triangleright} \pi';\ \chi'\end{aligned}}{\begin{aligned}& \Sigma \\ & {\vdash}\ (\bar a,\ \bar x.\, B) \uparrow_{(\bar\lambda,\ \lambda)} \\ & {=}\ (\Pi' \cup \{Y\};\ (\bar l, l');\ (\overline{\pi, \chi}, \pi', \chi');\ (\bar a',\ \bar x.\, B,\ (\bar x, z).\, B'))\end{aligned}}\;(\uparrow_{\bar a,}) \\[2em]
\frac{\begin{aligned}& \Sigma \vdash \bar a \uparrow_{\bar\lambda} = (\Pi';\ \bar l;\ \overline{\pi, \chi};\ \bar a') \\[0.6em] & \text{no parameter of } \Pi \text{ occurs in } B\end{aligned}}{\Sigma \vdash (\bar a,\ \bar x.\, B) \uparrow_{(\bar\lambda,\ \bot)} = (\Pi';\ \bar l;\ \overline{\pi, \chi};\ (\bar a',\ \bar x.\, B))}\;(\uparrow_{\bar a\notin})
\end{gathered}
```

### Factors

The relation $`{\Sigma \vdash \mathsf{factor}_{\bar\pi}(B) = \pi}`$ reads: the result $`B`$ of a destructor of a lifting has the factor $`\pi`$, a grade, which multiplies the uses of the scope by the recursive result that this destructor observes, where $`\bar\pi`$ gives the motive of each parameter lifted a factor; $`{\Sigma \vdash \mathsf{factor}_{\bar\pi}(\bar d) = \hat\pi}`$ reads: the destructors $`\bar d`$ have the meet $`\hat\pi`$ of their grades times the factors of their results, or $`\bot`$ when there is none, where $`{\pi \wedge \bot = \pi}`$.
The motive of a parameter lifted, at its arguments, has the factor that $`\bar\pi`$ gives it, the factor of the recursive results whose type it is, which an instance of the lifting gives.
An instance of a lifting that the signature declares has the meet of the grades of its destructors times their factors, at the factors that this instance gives the motives of its parameters, since its recursive result is a corecursor, an observation of which runs one branch, at the grade of its destructor, as the [usage](17-usage.md#definitions) of a corecursor bounds its uses by those of each branch; it has the factor $`{00}^{\mathsf{p}}`$ when the lifting has no destructor, since its recursive result is then never observed:

```math
\begin{gathered}
\frac{\bar\pi \text{ gives } C_Y \text{ the factor } \pi}{\Sigma \vdash \mathsf{factor}_{\bar\pi}(C_Y[\bar t]) = \pi}\;(\mathsf{factor}_X) \\[2em]
\frac{\begin{aligned}& \mathsf{lifting}_{\Pi'}(\mathcal{D}',\ D,\ \bar d') \in \Sigma \\[0.6em] & \bar s',\ \bar p' \text{ as many as the sort and grade variables of the lifting} \\[0.6em] & \Sigma \vdash \mathsf{factor}_{\bar\pi_\uparrow[\bar p' / \bar p_\uparrow]}(\bar d'[\bar s' / \bar s_\uparrow,\ \bar p' / \bar p_\uparrow]) = \hat\pi \\[0.6em] & \pi = \hat\pi \text{ when } \hat\pi \ne \bot \text{, and } \pi = {00}^{\mathsf{p}} \text{ when } \hat\pi = \bot\end{aligned}}{\Sigma \vdash \mathsf{factor}_{\bar\pi}(D^{\Pi'}.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a) = \pi}\;(\mathsf{factor}_D) \\[2em]
\frac{}{\Sigma \vdash \mathsf{factor}_{\bar\pi}(\varepsilon) = \bot}\;(\mathsf{factor}_{\bar d\varepsilon}) \\[2em]
\frac{\Sigma \vdash \mathsf{factor}_{\bar\pi}(B) = \pi \quad \Sigma \vdash \mathsf{factor}_{\bar\pi}(\bar d) = \hat\pi}{\Sigma \vdash \mathsf{factor}_{\bar\pi}(d : (\Theta \vdash B \mathrel{◀} \psi) \mathrel{▶} p;\ q \mathrel{◀} \varsigma \mid \bar d) = (p \cdot \pi) \wedge \hat\pi}\;(\mathsf{factor}_{\bar d,})
\end{gathered}
```

In the rule $`(\mathsf{factor}_D)`$, $`\bar s_\uparrow`$ and $`\bar p_\uparrow`$ are the sort and grade variables of the lifting of $`D`$ at $`\Pi'`$, $`{\bar s, s_C}`$ and $`{\bar p, r, \varsigma, \overline{\pi, \chi}_{\Pi'}}`$ of its block $`\mathcal{D}'`$, and $`\bar\pi_\uparrow`$ gives the motive of each parameter $`Y`$ of $`\Pi'`$ its factor $`\pi_Y`$, so that $`{\bar\pi_\uparrow[\bar p' / \bar p_\uparrow]}`$ gives it the factor that the instance gives it.
The factor is a relation, as the lifting is: an instance of a lifting that the signature does not declare has no factor, and a result of a destructor of a lifting is a motive or an instance of a lifting.

### Destructors

The relation $`{\Sigma \vdash \bar d \uparrow y = \bar d'}`$ reads: the destructors $`\bar d'`$ are the destructors $`\bar d`$ of the type $`D`$ lifted at the term $`y`$ of its instance $`{T = D.\{\bar s;\ \bar l;\ \bar p\}\ \bar x_\Delta}`$ at the parameters themselves.
The lifting has each destructor whose result, which has no position since the declaration of a lifting lifts no block, is lifted at the observation of $`y`$ by it, at its arguments $`\bar x`$, used $`{r \cdot \pi}`$ times more, where $`\pi`$ is the factor of the recursive result whose type is the result lifted, since the recursor eliminates this observation $`r`$ times and this recursive result uses the scope $`\pi`$ times, with this result, of the ownership $`\chi'`$ of this recursive result whatever the ownerships of the arguments are, and the requirement $`\varsigma`$; it has no destructor for a destructor in whose result no parameter lifted occurs.
The sort of the result lifted is bounded by the sort $`{\kappa' = (s_C)_{l \sqcup \bigsqcup \bar l_\Pi}}`$ of the lifting, where $`l`$ is the level of the sort of the block, as the [formation](15-typing.md#destructors-of-a-block) of a destructor requires of its result: the relation reads the syntax only, while the level of the lifting of an instance is the level of the type that it lifts, which nothing here compares to the level of the block.
In the destructors after it, each destructor is the [observation](09-substitution.md) of $`y`$ by it, so that the destructors of the lifting do not depend on one another, and none is used by the types of those after it:

```math
\begin{gathered}
\frac{}{\Sigma \vdash \varepsilon \uparrow y = \varepsilon}\;(\uparrow_{\bar d\varepsilon}) \\[2em]
\frac{\begin{aligned}& \Sigma \vdash B \uparrow_\bot y.(T.d)(\bar x) = B' : (s_C)_{l'} \mathrel{\triangleright} \pi;\ \chi' \\[0.6em] & (s_C)_{l'} \preceq \kappa' \\[0.6em] & \Sigma \vdash \bar d[y.T / d] \uparrow y = \bar d'\end{aligned}}{\begin{aligned}& \Sigma \\ & {\vdash}\ (d : (\Theta \vdash B \mathrel{◀} \psi) \mathrel{▶} p;\ q \mathrel{◀} \varsigma' \mid \bar d) \uparrow y \\ & {=}\ (d : ((r \cdot \pi) \cdot \Theta \vdash B' \mathrel{◀} \chi') \mathrel{▶} \mathsf{grade}_{s_C}(p);\ {00}^{\mathsf{p}} \mathrel{◀} \varsigma \mid \bar d')\end{aligned}}\;(\uparrow_{\bar d|}) \\[2em]
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
& \qquad \forall \bar s',\ s'_C,\ \bar p',\ r',\ \varsigma',\ \overline{\pi', \chi'} \\
& \qquad \text{as many as } \bar s,\ s_C,\ \bar p,\ r,\ \varsigma,\ \overline{\pi, \chi}_\Pi. \\
& \qquad \quad \Sigma \vdash \bar d_D[\bar s' / \bar s,\ \bar p' / \bar p] \uparrow y \\
& \qquad \quad {=}\ \bar d'[\bar s', s'_C / \bar s, s_C,\ \bar p', r', \varsigma', \overline{\pi', \chi'} / \bar p, r, \varsigma, \overline{\pi, \chi}_\Pi]
\end{aligned}
```

A signature holds the lifting of its type $`D`$ at the parameters $`\Pi`$, written $`{D^\Pi \in \Sigma}`$, when it has a block that declares $`D`$ and the lifting of $`D`$ at $`\Pi`$, with its destructors, as it [holds the prelude](12-prelude.md#declarations):

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
The [formation](15-typing.md#signatures-and-entries) of the signatures has a rule of its own for it, which asks in addition for these destructors, and gives the name of a lifting to no other entry.
The [usage](17-usage.md#definitions) of the signatures has a rule of its own for it, which does not check its destructors.

## Properties

A type has one lifting at most, the result of a destructor of a lifting one factor at most, and the result of a destructor of a lifting, at an instance, is the result of the destructor that it lifts, lifted at an observation.

In a signature whose [names are distinct](08-syntax.md), a type has one lifting at most at a term and at its nesting, of one level, one factor and one ownership, and the arguments of an instance are lifted in one way at most at their nestings, with the same parameters lifted, the same levels, the same factors and the same ownerships:

```math
\begin{aligned}
& \text{⟹} &&(\mathsf{unique}_{\uparrow}) \\
& \quad \text{and} \\
& \qquad \text{the names of } \Sigma \text{ are distinct} \\
& \qquad \Sigma \vdash A \uparrow_\lambda u = A'_1 : (s_C)_{l_1} \mathrel{\triangleright} \pi_1;\ \chi'_1 \\
& \qquad \Sigma \vdash A \uparrow_\lambda u = A'_2 : (s_C)_{l_2} \mathrel{\triangleright} \pi_2;\ \chi'_2 \\
& \quad A'_1 = A'_2 \text{ and } l_1 = l_2 \text{ and } \pi_1 = \pi_2 \text{ and } \chi'_1 = \chi'_2 \\[1em]
& \text{⟹} &&(\mathsf{unique}_{\uparrow\bar a}) \\
& \quad \text{and} \\
& \qquad \text{the names of } \Sigma \text{ are distinct} \\
& \qquad \Sigma \vdash \bar a \uparrow_{\bar\lambda} = (\Pi_1;\ \bar l_1;\ \overline{\pi, \chi}_1;\ \bar a'_1) \\
& \qquad \Sigma \vdash \bar a \uparrow_{\bar\lambda} = (\Pi_2;\ \bar l_2;\ \overline{\pi, \chi}_2;\ \bar a'_2) \\
& \quad \Pi_1 = \Pi_2 \text{ and } \bar l_1 = \bar l_2 \text{ and } \overline{\pi, \chi}_1 = \overline{\pi, \chi}_2 \text{ and } \bar a'_1 = \bar a'_2
\end{aligned}
```

In a signature whose names are distinct, the result of a destructor of a lifting has one factor at most, since an instance of a lifting names one declaration:

```math
\begin{aligned}
& \text{⟹} &&(\mathsf{unique}_{\mathsf{factor}}) \\
& \quad \text{and} \\
& \qquad \text{the names of } \Sigma \text{ are distinct} \\
& \qquad \Sigma \vdash \mathsf{factor}_{\bar\pi}(B) = \pi_1 \\
& \qquad \Sigma \vdash \mathsf{factor}_{\bar\pi}(B) = \pi_2 \\
& \quad \pi_1 = \pi_2
\end{aligned}
```

In a signature whose names are distinct, the destructor of the lifting of $`D`$ at $`\Pi`$ that lifts a destructor $`d`$ of $`D`$, at the instance of the lifting that the instance $`{T = D.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a}`$ lifted at a term $`t`$ is, has the arguments of $`d`$ at the arguments $`\bar a`$ and at the [observations](09-substitution.md) of $`t`$ by the destructors $`\bar d_1`$ before $`d`$, used $`{r \cdot \pi}`$ times more, and its result is the result of $`d`$, at these arguments and observations, lifted at the observation of $`t`$ by $`d`$, at the variables $`\bar x`$ of its arguments: the type of the recursive result of this observation, of the factor $`\pi`$.
The arguments $`\bar a`$ and this result are lifted where no parameter is lifted, whatever the block lifted is, as the type of a field of a block is, while the destructors $`\bar d'`$ are those of the lifting at $`\Pi`$: the arguments lifted $`\bar a'`$ give each parameter of $`\Pi`$ its motive, $`\overline{\pi'', \chi''}`$ the factor and the ownership of this motive, and the result is lifted at its [nesting](08-syntax.md#nesting), where $`{\Lambda = (\Delta \mapsto \bar\lambda)}`$ gives the parameters the nestings of the arguments, no position to the destructors and no object to a declared type.
The destructors $`\bar d'_1`$ of the lifting before it are given any abstractions $`\bar f`$, on which neither its arguments nor its result depend:

```math
\begin{aligned}
& \text{⟹} &&(\mathsf{inst}_{\uparrow}) \\
& \quad \text{and} \\
& \qquad \text{the names of } \Sigma \text{ are distinct} \\
& \qquad \mathcal{D} \in \Sigma \\
& \qquad \Sigma;\ \mathcal{D} \vdash D \uparrow_\Pi \bar d' \\
& \qquad \bar s',\ \bar l',\ \bar p' \text{ as many as } \bar s,\ \bar l,\ \bar p \\
& \qquad \Sigma \vdash \bar a \uparrow_{\bar\lambda} = (\Pi;\ \bar l'';\ \overline{\pi'', \chi''};\ \bar a') \\
& \qquad {=} \\
& \qquad \quad \bar d_D[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p] \\
& \qquad \quad (\bar d_1 \mid d : (\Theta \vdash B \mathrel{◀} \psi) \mathrel{▶} p;\ q \mathrel{◀} \varsigma_0 \mid \bar d_2) \\
& \qquad {=} \\
& \qquad \quad \bar d'[\bar s' / \bar s,\ \bar l', \bar l'' / \bar l, \bar l_\Pi,\ \bar p', \overline{\pi'', \chi''} / \bar p, \overline{\pi, \chi}_\Pi] \\
& \qquad \quad (\bar d'_1 \mid d : (\Theta' \vdash B' \mathrel{◀} \psi') \mathrel{▶} p';\ q' \mathrel{◀} \varsigma' \mid \bar d'_2) \\
& \quad \exists l_0,\ \pi,\ \chi'. \\
& \qquad \text{and} \\
& \qquad \quad {=} \\
& \qquad \qquad \Theta'[(\bar a',\ t) / (\Delta \uparrow,\ y),\ \bar f / \bar d'_1] \\
& \qquad \qquad (r \cdot \pi) \cdot \Theta[\bar a / \Delta,\ t.T / \bar d_1] \\
& \qquad \quad \Sigma \\
& \qquad \quad {\vdash}\ B[\bar a / \Delta,\ t.T / \bar d_1] \uparrow_{\mathsf{nest}_\Lambda(B)} t.(T.d)(\bar x) \\
& \qquad \quad {=}\ B'[(\bar a',\ t) / (\Delta \uparrow,\ y),\ \bar f / \bar d'_1] \\
& \qquad \quad {:}\ (s_C)_{l_0} \\
& \qquad \quad {\triangleright}\ \pi;\ \chi'
\end{aligned}
```
