# Liftings

This annex defines the lifting of a codata type at a set of its parameters, a codata type declared from it whose terms hold, for each observation of a term of the type, a term of a motive at each position of these parameters in the result; it defines the lifting of a type at a term, of the arguments of an instance, of the destructors of a codata type and of its parameters, the declaration of the lifting, and the signatures that hold it.
Its definitions build on the [syntax](08-syntax.md), on the [substitution](09-substitution.md) and on the variables that [do not occur](14-typing.md#strict-positivity) in a term, and the typing will read them for the recursive result of a field nested below a codata type.

## Definitions

This section gives the variables of a lifting, then the lifting of the types and of the arguments of their instances, of the destructors and of the parameters, and the declaration of the lifting with the signatures that hold it.

### Variables of a Lifting

The lifting of the type $`D`$ of a block of codata types $`{\mathcal{D} = \mathsf{codata}.\{\bar s;\ \bar l;\ \bar p \mid C_{\mathcal{D}}\}\ \Delta : \kappa\ \mathsf{where}\ \dots}`$ at a set $`\Pi`$ of its parameters is named $`D^\Pi`$, a name of the signature that $`D`$ and $`\Pi`$ determine.
It has the variables of the block and five more: the quality $`s_C`$ and the level $`l_C`$ of the sort of its motives, the grade $`r`$ of the recursor that computes its terms, the ownership $`\varsigma`$ that its destructors require of the value that they observe, and the ownership $`\chi`$ of their results.
Its parameters are those of the block, a motive $`C_Y`$ for each parameter $`Y`$ of $`\Pi`$, and a term $`y`$ of the type $`D`$ at these parameters; in the definitions of this section, $`\Pi`$, these variables and these motives are fixed, and a parameter is lifted when it is in $`\Pi`$.

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

### Types

The relation $`{A \uparrow u = A'}`$ reads: the type $`A'`$ is the type $`A`$ lifted at the term $`u`$ of $`A`$.
A parameter lifted, applied to arguments in which no parameter lifted occurs, is lifted to its motive at these arguments and at the term; an instance of a declared type of which an argument at least is lifted is lifted to the instance of the lifting of this type at the parameters of these arguments, at the variables of the lifting, at the arguments lifted and at the term:

```math
\begin{gathered}
\frac{\begin{gathered}{}Y \in \Pi \\ \text{no parameter of } \Pi \text{ occurs in } \bar t\end{gathered}}{Y[\bar t] \uparrow u = C_Y[\bar t,\ u]}\;(\uparrow_X) \\[1em]
\frac{\begin{gathered}{}\bar a \uparrow = (\Pi';\ \bar a') \\ \Pi' \ne \varnothing\end{gathered}}{D.\{\bar s';\ \bar l';\ \bar p'\}\ \bar a \uparrow u = D^{\Pi'}.\{\bar s', s_C;\ \bar l', l_C;\ \bar p', r, \varsigma, \chi\}\ (\bar a',\ u)}\;(\uparrow_D)
\end{gathered}
```

A type in which no parameter lifted occurs has no lifting, nor has a type in which one occurs otherwise, in a term or below a second-order variable.

The relation $`{\bar a \uparrow = (\Pi';\ \bar a')}`$ reads: the arguments $`\bar a'`$ are the arguments $`\bar a`$ of an instance lifted, and $`\Pi'`$ is the set of the parameters of the instance whose arguments are lifted.
An argument in which a parameter lifted occurs is followed by its motive, the argument lifted at a term $`z`$ of its own, under the variables that its abstraction binds, and an argument in which none occurs is kept; in these rules, $`Y`$ is the parameter of the instance whose argument is $`{\bar x.\, B}`$:

```math
\begin{gathered}
\frac{}{() \uparrow = (\varnothing;\ ())}\;(\uparrow_{\bar a\varepsilon}) \\[1em]
\frac{\begin{gathered}{}\bar a \uparrow = (\Pi';\ \bar a') \\ B \uparrow z = B'\end{gathered}}{(\bar a,\ \bar x.\, B) \uparrow = (\Pi' \cup \{Y\};\ (\bar a',\ \bar x.\, B,\ (\bar x, z).\, B'))}\;(\uparrow_{\bar a,}) \\[1em]
\frac{\begin{gathered}{}\bar a \uparrow = (\Pi';\ \bar a') \\ \text{no parameter of } \Pi \text{ occurs in } B\end{gathered}}{(\bar a,\ \bar x.\, B) \uparrow = (\Pi';\ (\bar a',\ \bar x.\, B))}\;(\uparrow_{\bar a\notin})
\end{gathered}
```

### Destructors

The relation $`{\bar d \uparrow y = \bar d'}`$ reads: the destructors $`\bar d'`$ are the destructors $`\bar d`$ of the type $`D`$ lifted at the term $`y`$ of its instance $`{T = D.\{\bar s;\ \bar l;\ \bar p\}\ \bar x_\Delta}`$ at the parameters themselves.
The lifting has each destructor whose result is lifted at the observation of $`y`$ by it, at its arguments $`\bar x`$, used $`r`$ times more, since the recursor eliminates this observation $`r`$ times, with this result, of the ownership $`\chi`$ whatever the ownerships of the arguments are, and the requirement $`\varsigma`$; it has no destructor for a destructor in whose result no parameter lifted occurs.
In the destructors after it, each destructor is the [observation](09-substitution.md) of $`y`$ by it, so that the destructors of the lifting do not depend on one another, and none is used by the types of those after it:

```math
\begin{gathered}
\frac{}{\varepsilon \uparrow y = \varepsilon}\;(\uparrow_{\bar d\varepsilon}) \\[1em]
\frac{\begin{gathered}{}B \uparrow y.(T.d)(\bar x) = B' \\ \bar d[y.T / d] \uparrow y = \bar d'\end{gathered}}{(d : (\Theta \vdash B \mathrel{◀} \psi) \mathrel{▶} p;\ q \mathrel{◀} \varsigma' \mid \bar d) \uparrow y = (d : (r \cdot \Theta \vdash B' \mathrel{◀} \chi) \mathrel{▶} \mathsf{grade}_{s_C}(p);\ {00}^{\mathsf{p}} \mathrel{◀} \varsigma \mid \bar d')}\;(\uparrow_{\bar d|}) \\[1em]
\frac{\begin{gathered}{}\text{no parameter of } \Pi \text{ occurs in } B \\ \bar d[y.T / d] \uparrow y = \bar d'\end{gathered}}{(d : (\Theta \vdash B \mathrel{◀} \psi) \mathrel{▶} p;\ q \mathrel{◀} \varsigma' \mid \bar d) \uparrow y = \bar d'}\;(\uparrow_{\bar d\notin})
\end{gathered}
```

### Parameters

The parameters $`{\Delta \uparrow}`$ of the lifting are the parameters $`\Delta`$ in which each parameter lifted is followed by its motive: a type of the sort $`{(s_C)_{l_C}}`$ over the telescope of the parameter and a term $`z`$ of it, which the motive may use as it wants and of which it requires nothing, and whose result has the least ownership, as a type:

```math
\begin{aligned}
& \varepsilon \uparrow = \varepsilon &&(\mathsf{params}_{\uparrow}) \\
& (\Delta,\ x : A) \uparrow = (\Delta \uparrow,\ x : A,\ C_x : (z : x \mathrel{▶} {\omega\omega}^{\mathsf{p}};\ {\omega\omega}^{\mathsf{p}} \mathrel{◀} {\omega\omega}^{\mathsf{p}} \vdash (s_C)_{l_C} \mathrel{◀} {\omega\omega}^{\mathsf{p}})) \text{ if } x \in \Pi \\
& (\Delta,\ x : A) \uparrow = (\Delta \uparrow,\ x : A) \text{ otherwise} \\
& (\Delta,\ X : (\Theta \vdash A \mathrel{◀} \psi)) \uparrow = (\Delta \uparrow,\ X : (\Theta \vdash A \mathrel{◀} \psi),\ C_X : (\Theta,\ z : X[\bar x] \mathrel{▶} {\omega\omega}^{\mathsf{p}};\ {\omega\omega}^{\mathsf{p}} \mathrel{◀} {\omega\omega}^{\mathsf{p}} \vdash (s_C)_{l_C} \mathrel{◀} {\omega\omega}^{\mathsf{p}})) \text{ if } X \in \Pi \\
& (\Delta,\ X : (\Theta \vdash A \mathrel{◀} \psi)) \uparrow = (\Delta \uparrow,\ X : (\Theta \vdash A \mathrel{◀} \psi)) \text{ otherwise}
\end{aligned}
```

In the fourth case, $`\bar x`$ are the variables of $`\Theta`$.

### Declaration

The lifting $`{\mathsf{lifting}_\Pi(\mathcal{D},\ D,\ \bar d')}`$ of the type $`D`$ of the block $`\mathcal{D}`$, whose sort is $`{\kappa = s_l}`$, at the parameters $`\Pi`$, with the destructors $`\bar d'`$, is a block of one codata type, since the types of a block share their parameters while each lifting has a term of its own type.
It has the constraint of the block, the parameters lifted followed by the term $`y`$, and the sort of the quality $`s_C`$ and of the level of the block joined to $`l_C`$; it uses its parameters with the grades $`\zeta`$ that give each of them the least grade $`{\omega\omega}^{\mathsf{p}}`$, which states nothing, and declares no parameter in which it is strictly positive:

```math
\begin{aligned}
& {=} &&(\mathsf{lifting}_{\mathcal{D}}) \\
& \quad \mathsf{lifting}_\Pi(\mathcal{D},\ D,\ \bar d') \\
& \quad \mathsf{codata}.\{\bar s, s_C;\ \bar l, l_C;\ \bar p, r, \varsigma, \chi \mid C_{\mathcal{D}}\}\ (\Delta \uparrow,\ y : D.\{\bar s;\ \bar l;\ \bar p\}\ \bar x_\Delta) : (s_C)_{l \sqcup l_C}\ \mathsf{where}\ D^\Pi \mathrel{▶} \zeta \oplus \varnothing \mathrel{≔} \bar d'
\end{aligned}
```

The destructors $`\bar d'`$ are those of the lifting of $`D`$ at $`\Pi`$, written $`{\mathcal{D} \vdash D \uparrow_\Pi \bar d'}`$, when $`D`$ is a type of the block and, at each instance of the variables of the lifting, they are its destructors $`\bar d_D`$ lifted at $`y`$, with the variables of the lifting at this instance; their names are those of the destructors of $`D`$ whose results are lifted, which are thus the same at each instance:

```math
\begin{aligned}
& \text{⟺} &&(\uparrow_{\mathcal{D}}) \\
& \quad \mathcal{D} \vdash D \uparrow_\Pi \bar d' \\
& \quad \text{and} \\
& \qquad D \text{ is a type of } \mathcal{D} \text{, a block of codata types} \\
& \qquad \forall \bar s',\ s'_C,\ \bar p',\ r',\ \varsigma',\ \chi' \text{ as many as } \bar s,\ s_C,\ \bar p,\ r,\ \varsigma,\ \chi.\ \bar d_D[\bar s' / \bar s,\ \bar p' / \bar p] \uparrow y = \bar d'[\bar s', s'_C / \bar s, s_C,\ \bar p', r', \varsigma', \chi' / \bar p, r, \varsigma, \chi]
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
& \qquad \quad \mathcal{D} \vdash D \uparrow_\Pi \bar d' \\
& \qquad \quad \mathsf{lifting}_\Pi(\mathcal{D},\ D,\ \bar d') \in \Sigma
\end{aligned}
```

The lifting is an entry of the signature as the others: the judgments of the signatures check it, so that a type whose lifting is not well formed, such as a recursive codata type, whose lifting is not at its parameters themselves, or a codata type with a result below a data type, which has no lifting, has no lifting that a well-formed signature holds.
