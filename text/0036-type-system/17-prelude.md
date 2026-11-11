# Prelude

This annex defines the prelude, three type declarations that the type system uses for its own needs: a unit, a pair and a type of positions; it then defines the packing of a telescope into nested pairs, and of its arguments into nested constructors of pairs, the unpacking of a term of a packing, and the positions of the recursive destructors and their resumption, with the properties of these packings and of the unpacking.
Its definitions build on the [substitution](09-substitution.md) and on the [recursive destructors](13-typing.md#destructors-of-a-block), and the typing reads them; its properties build on the [usage](11-usage.md), the [ownership](12-ownership.md) and the [typing](13-typing.md).

## Definitions

This section gives the declarations of the prelude and the signature that holds them, then the packing of the telescopes and of their arguments, their unpacking, and the positions.

### Declarations

The unit `Unit` has, at each level $`l`$, a single constructor without fields, in the universe $`U_l`$:

```math
\begin{aligned}
& \mathsf{data}.\{;\ l;\ \mid \top\}\ \varepsilon : U_l\ \mathsf{where}\ \mathsf{Unit} \mathrel{▶} {00}^{\gamma} \mathrel{≔} \mathsf{mk} : \varepsilon &&(\mathsf{prelude}.\mathsf{Unit})
\end{aligned}
```

The pair `Pair` holds a term $`x`$ of a type $`A`$ of any sort, used with the grade $`p`$ and of the requirement $`r`$, and a term of $`X[x]`$, a type of a universe that depends on $`x`$, used once and requiring the ownership $`{11}^{\mathsf{p}}`$ of a new value, that of every packing of arguments, so that the unpacking keeps the ownership of each entry; it lives in a universe whatever the sort of $`A`$, and its constraint admits the instances at which a proposition $`A`$ has a grade without use at run time, as the [formation of its fields](13-typing.md#fields-of-a-block) requires:

```math
\begin{aligned}
& \mathsf{data}.\{s;\ l_1, l_2;\ p, r \mid s = \Omega \implies \llcorner p \lrcorner \ne {11}^{\mathsf{m}}\} &&(\mathsf{prelude}.\mathsf{Pair}) \\
& \quad (A : s_{l_1},\ X : (x : A \mathrel{▶} {\omega\omega}^{\mathsf{p}};\ {\omega\omega}^{\mathsf{p}} \mathrel{◀} {\omega\omega}^{\mathsf{p}} \vdash U_{l_2} \mathrel{◀} {\omega\omega}^{\mathsf{p}})) : U_{l_1 \sqcup l_2} \\
& \quad \mathsf{where}\ \mathsf{Pair} \mathrel{▶} {00}^{\gamma} \bullet p \bullet {11}^{\mathsf{p}} \mathrel{≔} \mathsf{mk} : (x : A \mathrel{▶} p;\ {\omega\omega}^{\mathsf{p}} \mathrel{◀} r,\ y : X[x] \mathrel{▶} {11}^{\mathsf{p}};\ {00}^{\mathsf{p}} \mathrel{◀} {11}^{\mathsf{p}})
\end{aligned}
```

The type of positions `Step` holds either a term of a type $`A`$ of a universe, used with the grade $`p`$ and requiring the ownership $`{11}^{\mathsf{p}}`$ of a new value, that of every packing of arguments, by its constructor $`\mathsf{next}`$, or a term of a type $`B`$ of any sort, used with the grade $`q`$ and of the requirement $`r`$, by its constructor $`\mathsf{done}`$; it lives in a universe whatever the sort of $`B`$, and its constraint admits the instances at which a proposition $`B`$ has a grade without use at run time:

```math
\begin{aligned}
& \mathsf{data}.\{s;\ l_1, l_2;\ p, q, r \mid s = \Omega \implies \llcorner q \lrcorner \ne {11}^{\mathsf{m}}\}\ (A : U_{l_1},\ B : s_{l_2}) : U_{l_1 \sqcup l_2} &&(\mathsf{prelude}.\mathsf{Step}) \\
& \quad \mathsf{where}\ \mathsf{Step} \mathrel{▶} {00}^{\gamma} \bullet p \bullet q \mathrel{≔} \mathsf{next} : (x : A \mathrel{▶} p;\ {00}^{\mathsf{p}} \mathrel{◀} {11}^{\mathsf{p}}) \mid \mathsf{done} : (x : B \mathrel{▶} q;\ {00}^{\mathsf{p}} \mathrel{◀} r)
\end{aligned}
```

The prelude is the signature of the three declarations, in this order, and a signature holds the prelude when it holds each of them:

```math
\begin{aligned}
& \mathsf{prelude} = \varnothing,\ \mathsf{Unit},\ \mathsf{Pair},\ \mathsf{Step} &&(\mathsf{prelude}_\Sigma) \\[1em]
& \Sigma \ni \mathsf{prelude} \iff \forall e \in \mathsf{prelude}.\ e \in \Sigma &&(\mathsf{prelude}_\in)
\end{aligned}
```

### Packing

A telescope packs into nested pairs, which need the sort of each of its entries, given by a [telescope in sorts](13-typing.md#telescopes-in-a-sort).
The level $`\mathsf{level}_{\bar\kappa}(l)`$ of a packing is the join of the levels of the sorts $`\bar\kappa`$ and of $`l`$; the packing $`\langle \Theta \rangle_{\bar\kappa;\ l}`$ of the telescope $`\Theta`$, whose entries live in the sorts $`\bar\kappa`$, is the pair of its first entry, with its grade and its requirement, and of the packing of the rest, ending with the unit of the level $`l`$; the packing $`\langle \bar t \rangle_{\Theta;\ \bar\kappa;\ l}`$ of arguments of $`\Theta`$ is the pair of the first argument and of the packing of the others, as arguments of the rest of the telescope instantiated by the first, ending with the constructor of the unit:

```math
\begin{aligned}
& \mathsf{level}_{()}(l) = l &&(\mathsf{level}_{\bar\kappa}) \\
& \mathsf{level}_{(s_{l'},\ \bar\kappa)}(l) = l' \sqcup \mathsf{level}_{\bar\kappa}(l) \\[1em]
& \langle \varepsilon \rangle_{();\ l} = \mathsf{Unit}.\{;\ l;\}\ () &&(\mathsf{pack}_\Theta) \\
& \langle x : A \mathrel{▶} p;\ q \mathrel{◀} r,\ \Theta \rangle_{(s_{l'},\ \bar\kappa);\ l} = \mathsf{Pair}.\{s;\ l', \mathsf{level}_{\bar\kappa}(l);\ p, r\}\ (A,\ x.\, \langle \Theta \rangle_{\bar\kappa;\ l}) \\[1em]
& \langle () \rangle_{\varepsilon;\ ();\ l} = (\mathsf{Unit}.\{;\ l;\}\ ()).\mathsf{mk}() &&(\mathsf{pack}_{\bar t}) \\
& \langle (t,\ \bar t) \rangle_{(x : A \mathrel{▶} p;\ q \mathrel{◀} r,\ \Theta);\ (s_{l'},\ \bar\kappa);\ l} = (\mathsf{Pair}.\{s;\ l', \mathsf{level}_{\bar\kappa}(l);\ p, r\}\ (A,\ x.\, \langle \Theta \rangle_{\bar\kappa;\ l})).\mathsf{mk}(t,\ \langle \bar t \rangle_{\Theta[t / x];\ \bar\kappa;\ l})
\end{aligned}
```

### Unpacking

The unpacking $`\mathsf{unpack}_r\ u : \langle \Theta \rangle_{\bar\kappa;\ l}\ \mathsf{return}\ C\ \mathsf{with}\ b`$ of the term $`u`$ of the packing of $`\Theta`$ into the term $`b`$, over the variables of $`\Theta`$, is a recursor on each pair, then on the unit, each using its term with the grade $`r`$, with the motive $`z.\, C`$, which does not depend on the term $`z`$ eliminated; the branch of the pair unpacks its second field into $`b`$, which does not use the variable $`y`$ of this field:

```math
\begin{aligned}
& \mathsf{unpack}_r\ u : \langle \varepsilon \rangle_{();\ l}\ \mathsf{return}\ C\ \mathsf{with}\ b = \mathsf{rec}_r\ (\mathsf{Unit}.\{;\ l;\}\ ())\ u\ \mathsf{return}\ z.\, C\ \mathsf{with}\ \mathsf{Unit}.\mathsf{mk}() \Rightarrow b &&(\mathsf{unpack}) \\
& \mathsf{unpack}_r\ u : \langle x : A \mathrel{▶} p;\ q \mathrel{◀} r',\ \Theta \rangle_{(s_{l'},\ \bar\kappa);\ l}\ \mathsf{return}\ C\ \mathsf{with}\ b = \mathsf{rec}_r\ (\mathsf{Pair}.\{s;\ l', \mathsf{level}_{\bar\kappa}(l);\ p, r'\}\ (A,\ x.\, \langle \Theta \rangle_{\bar\kappa;\ l}))\ u \\
& \quad \mathsf{return}\ z.\, C\ \mathsf{with}\ \mathsf{Pair}.\mathsf{mk}(x,\ y) \Rightarrow \mathsf{unpack}_r\ y : \langle \Theta \rangle_{\bar\kappa;\ l}\ \mathsf{return}\ C\ \mathsf{with}\ b
\end{aligned}
```

### Positions

A recursive destructor of a block of codata types gives back, in a branch of a corecursor, a position: a new state, packed, from which the corecursor goes on, or a term already built.
The grade $`q_s`$ of a term already built, of the quality $`s`$, is $`{11}^{\mathsf{p}}`$ in a universe, and $`{01}^{\mathsf{p}}`$, without use at run time, in a universe of propositions, as the constraint of the type of positions requires; the type of positions $`\mathsf{pos}_{r;\ \chi}(\Theta : \bar\kappa,\ T : s_{l'})`$ of a corecursor of the grade $`r`$ whose state $`\Theta`$ lives in the sorts $`\bar\kappa`$, at the terms already built of the type $`T`$ of the sort $`s_{l'}`$ that the ownership $`\chi`$ requires, is the instance of `Step` at the packing of the state, of the level $`\mathsf{level}_{\bar\kappa}(l)`$, where $`l = \mathsf{level}_{\bar\kappa}(0)`$ is the join of the levels of $`\bar\kappa`$, and at $`T`$:

```math
\begin{aligned}
& q_U = {11}^{\mathsf{p}} &&(q_s) \\
& q_\Omega = {01}^{\mathsf{p}} \\[1em]
& \mathsf{pos}_{r;\ \chi}(\Theta : \bar\kappa,\ T : s_{l'}) = \mathsf{Step}.\{s;\ \mathsf{level}_{\bar\kappa}(l), l';\ r, q_s, \chi\}\ (\langle \Theta \rangle_{\bar\kappa;\ l},\ T) &&(\mathsf{pos})
\end{aligned}
```

In a block $`\mathcal{D}`$ of codata types $`D_1, \dots, D_k`$, whose states are $`\bar\Theta = (\Theta_1 : \bar\kappa_1,\ \dots,\ \Theta_k : \bar\kappa_k)`$, the type $`\mathsf{pos}_{\bar\Theta;\ r;\ \chi}(B,\ T : \kappa)`$ of the branch of a destructor whose result is $`B`$, at the type $`T`$ of this result, is the type of the positions of the state of the type of the block that $`B`$ names, if the destructor is recursive, and $`T`$ otherwise:

```math
\begin{aligned}
& \mathsf{pos}_{\bar\Theta;\ r;\ \chi}(B,\ T : \kappa) = \mathsf{pos}_{r;\ \chi}(\Theta_j : \bar\kappa_j,\ T : \kappa) \text{ if } \mathsf{rec}_{\mathcal{D}}(B) = D_j &&(\mathsf{pos}_{\bar\Theta}) \\
& \mathsf{pos}_{\bar\Theta;\ r;\ \chi}(B,\ T : \kappa) = T \text{ otherwise}
\end{aligned}
```

The resumption $`\mathsf{resume}_{r;\ \chi}(v,\ T : \kappa,\ \bar\Theta,\ \bar g)`$ of the position $`v`$ of the instance $`T = D_j.\{\bar s;\ \bar l;\ \bar p\}\ \bar a`$, of the sort $`\kappa`$, by the corecursor of the grade $`r`$ with the states $`\bar\Theta`$ and the branches $`\bar g`$, is a recursor on $`v`$, with the motive $`z.\, T`$, which unpacks a new state into the corecursor of $`T`$ from the variables $`\bar y_j`$ of the state $`\Theta_j`$ of $`D_j`$, of the sorts $`\bar\kappa_j`$ and of the join $`l_j = \mathsf{level}_{\bar\kappa_j}(0)`$ of their levels, and gives a term already built itself; the resumption $`\mathsf{resume}_{B;\ r;\ \chi}(v,\ T : \kappa,\ \bar\Theta,\ \bar g)`$ of the term $`v`$ of the branch of a destructor whose result is $`B`$, observed in a corecursor of the instance $`T = D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a`$, is the resumption of $`v`$ by the corecursor of the type of the block that $`B`$ names, if the destructor is recursive, and $`v`$ otherwise:

```math
\begin{aligned}
& \mathsf{resume}_{r;\ \chi}(v,\ T : \kappa,\ \bar\Theta,\ \bar g) = \mathsf{rec}_{{11}^{\mathsf{p}}}\ \mathsf{pos}_{r;\ \chi}(\Theta_j : \bar\kappa_j,\ T : \kappa)\ v\ \mathsf{return}\ z.\, T\ \mathsf{with} &&(\mathsf{resume}) \\
& \quad (\mathsf{Step}.\mathsf{next}(x) \Rightarrow \mathsf{unpack}_r\ x : \langle \Theta_j \rangle_{\bar\kappa_j;\ l_j}\ \mathsf{return}\ T\ \mathsf{with}\ \mathsf{corec}_r\ T\ \mathsf{from}\ \bar y_j\ \mathsf{return}\ \bar\Theta\ \mathsf{with}\ \bar g,\ \mathsf{Step}.\mathsf{done}(x) \Rightarrow x) \\[1em]
& \mathsf{resume}_{B;\ r;\ \chi}(v,\ D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a : \kappa,\ \bar\Theta,\ \bar g) = \mathsf{resume}_{r;\ \chi}(v,\ D_j.\{\bar s;\ \bar l;\ \bar p\}\ \bar a : \kappa,\ \bar\Theta,\ \bar g) \text{ if } \mathsf{rec}_{\mathcal{D}}(B) = D_j &&(\mathsf{resume}_B) \\
& \mathsf{resume}_{B;\ r;\ \chi}(v,\ T : \kappa,\ \bar\Theta,\ \bar g) = v \text{ otherwise}
\end{aligned}
```

## Properties

The prelude is a well-formed signature: each of its declarations is well formed in the declarations before it, at every instance that its constraint admits:

```math
\begin{aligned}
& \vdash \mathsf{prelude} &&(\mathsf{prelude}_{\vdash})
\end{aligned}
```

In a signature that holds the prelude, the packing of a telescope is a type of the universe of its level, the packing of arguments of the telescope is a term of it, the packing of arguments uses the variables as the arguments do, each pair using its first term with the grade of its entry and the rest once, and the packing of arguments that satisfy the requirements of their entries has the ownership $`{11}^{\mathsf{p}}`$ of a new value, as every constructor:

```math
\begin{aligned}
& \text{⟹} &&(\mathsf{pack}_{\Theta:}) \\
& \quad \text{and} \\
& \qquad \Sigma \ni \mathsf{prelude} \\
& \qquad \Sigma;\ \Gamma \vdash \Theta : \bar\kappa \le l \\
& \quad \Sigma;\ \Gamma \vdash \langle \Theta \rangle_{\bar\kappa;\ l} : U_{\mathsf{level}_{\bar\kappa}(l)} \\[1em]
& \text{⟹} &&(\mathsf{pack}_{\bar t:}) \\
& \quad \text{and} \\
& \qquad \Sigma \ni \mathsf{prelude} \\
& \qquad \Sigma;\ \Gamma \vdash \Theta : \bar\kappa \le l \\
& \qquad \Sigma;\ \Gamma \vdash \bar t : \Theta \\
& \quad \Sigma;\ \Gamma \vdash \langle \bar t \rangle_{\Theta;\ \bar\kappa;\ l} : \langle \Theta \rangle_{\bar\kappa;\ l} \\[1em]
& \text{⟹} &&(\mathsf{pack}_{\bar t▶}) \\
& \quad \text{and} \\
& \qquad \Sigma \ni \mathsf{prelude} \\
& \qquad \Sigma;\ \gamma \vdash \bar t \mathrel{▶} \bar p;\ m \text{ for the grades } \bar p \text{ of } \Theta \\
& \quad \Sigma;\ \gamma \vdash \langle \bar t \rangle_{\Theta;\ \bar\kappa;\ l} \mathrel{▶} m \\[1em]
& \text{⟹} &&(\mathsf{pack}_{\bar t◀}) \\
& \quad \text{and} \\
& \qquad \Sigma \ni \mathsf{prelude} \\
& \qquad \Sigma;\ \varphi \vdash \bar t \mathrel{◀} \bar o;\ \Theta;\ m \\
& \quad \Sigma;\ \varphi \vdash \langle \bar t \rangle_{\Theta;\ \bar\kappa;\ l} \mathrel{◀} {11}^{\mathsf{p}};\ m
\end{aligned}
```

In a signature that holds the prelude, the unpacking of a term of the packing of a telescope, into a term over the variables of the telescope whose type does not depend on them, has this type; the unpacking of the packing of arguments is the term at the arguments; and a term over a term $`z`$ of the packing is the unpacking of the term it is at into the term at the packing $`\langle \bar x \rangle_{\Theta;\ \bar\kappa;\ l}`$ of the variables $`\bar x`$ of the telescope:

```math
\begin{aligned}
& \text{⟹} &&(\mathsf{unpack}_{:}) \\
& \quad \text{and} \\
& \qquad \Sigma \ni \mathsf{prelude} \\
& \qquad \Sigma;\ \Gamma \vdash \Theta : \bar\kappa \le l \\
& \qquad \Sigma;\ \Gamma \vdash u : \langle \Theta \rangle_{\bar\kappa;\ l} \\
& \qquad \Sigma;\ \Gamma \vdash C : \kappa \\
& \qquad \Sigma;\ \Gamma,\ \Theta \vdash b : C \\
& \quad \Sigma;\ \Gamma \vdash \mathsf{unpack}_r\ u : \langle \Theta \rangle_{\bar\kappa;\ l}\ \mathsf{return}\ C\ \mathsf{with}\ b : C \\[1em]
& \text{⟹} &&(\mathsf{unpack}_\beta) \\
& \quad \text{and} \\
& \qquad \Sigma \ni \mathsf{prelude} \\
& \qquad \Sigma;\ \Gamma \vdash \Theta : \bar\kappa \le l \\
& \qquad \Sigma;\ \Gamma \vdash \bar t : \Theta \\
& \qquad \Sigma;\ \Gamma \vdash C : \kappa \\
& \qquad \Sigma;\ \Gamma,\ \Theta \vdash b : C \\
& \quad \Sigma;\ \Gamma \vdash \mathsf{unpack}_r\ \langle \bar t \rangle_{\Theta;\ \bar\kappa;\ l} : \langle \Theta \rangle_{\bar\kappa;\ l}\ \mathsf{return}\ C\ \mathsf{with}\ b \equiv b[\bar t / \Theta] : C \\[1em]
& \text{⟹} &&(\mathsf{unpack}_\eta) \\
& \quad \text{and} \\
& \qquad \Sigma \ni \mathsf{prelude} \\
& \qquad \Sigma;\ \Gamma \vdash \Theta : \bar\kappa \le l \\
& \qquad \Sigma;\ \Gamma \vdash u : \langle \Theta \rangle_{\bar\kappa;\ l} \\
& \qquad \Sigma;\ \Gamma \vdash C : \kappa \\
& \qquad \Sigma;\ \Gamma,\ z : \langle \Theta \rangle_{\bar\kappa;\ l} \vdash e : C \\
& \quad \Sigma;\ \Gamma \vdash e[u / z] \equiv \mathsf{unpack}_r\ u : \langle \Theta \rangle_{\bar\kappa;\ l}\ \mathsf{return}\ C\ \mathsf{with}\ e[\langle \bar x \rangle_{\Theta;\ \bar\kappa;\ l} / z] : C
\end{aligned}
```

In a signature that holds the prelude, the unpacking uses the variables of its term $`r`$ times and those of its term $`b`$, which uses the variable of each entry of the telescope $`\ulcorner m \urcorner \cdot r`$ times its grade, its motive using no variable, as a [recursor](11-usage.md) does; and it has the ownership of $`b`$, checked with the ownership $`o`$ of its term times the requirement of each entry, times the grade $`\ulcorner m \urcorner \cdot r`$ times the grade of the entry, for the variable of the entry, as a [recursor](12-ownership.md) does, the second field of each pair requiring $`{11}^{\mathsf{p}}`$ and having the grade $`{11}^{\mathsf{p}}`$, and $`\ulcorner m \urcorner \cdot r`$ being idempotent, so that the nested recursors scale it once:

```math
\begin{aligned}
& \text{⟹} &&(\mathsf{unpack}_{▶}) \\
& \quad \text{and} \\
& \qquad \Sigma \ni \mathsf{prelude} \\
& \qquad \Sigma;\ {00}^{\gamma} \vdash C \mathrel{▶} {00}^{\mathsf{m}} \\
& \qquad \Sigma;\ \gamma \vdash u \mathrel{▶} m \odot r \\
& \qquad \Theta \text{ has the grades } p_1, \dots, p_n \\
& \qquad \Sigma;\ \delta \bullet (\ulcorner m \urcorner \cdot r \cdot p_1) \bullet \dots \bullet (\ulcorner m \urcorner \cdot r \cdot p_n) \vdash b \mathrel{▶} m \\
& \quad \Sigma;\ (r \cdot^{\gamma} \gamma) +^{\gamma} \delta \vdash \mathsf{unpack}_r\ u : \langle \Theta \rangle_{\bar\kappa;\ l}\ \mathsf{return}\ C\ \mathsf{with}\ b \mathrel{▶} m \\[1em]
& \text{⟹} &&(\mathsf{unpack}_{◀}) \\
& \quad \text{and} \\
& \qquad \Sigma \ni \mathsf{prelude} \\
& \qquad \Sigma;\ \varphi \vdash u \mathrel{◀} o;\ m \odot r \\
& \qquad \text{the entries of } \Theta \text{ require } r_1, \dots, r_n \\
& \qquad \Theta \text{ has the grades } q_1, \dots, q_n \\
& \qquad \Sigma;\ \varphi,\ x_1 \mathrel{◀} o \cdot r_1 \cdot (\ulcorner m \urcorner \cdot r \cdot q_1), \dots, x_n \mathrel{◀} o \cdot r_n \cdot (\ulcorner m \urcorner \cdot r \cdot q_n) \vdash b \mathrel{◀} p;\ m \\
& \quad \Sigma;\ \varphi \vdash \mathsf{unpack}_r\ u : \langle \Theta \rangle_{\bar\kappa;\ l}\ \mathsf{return}\ C\ \mathsf{with}\ b \mathrel{◀} p;\ m
\end{aligned}
```
