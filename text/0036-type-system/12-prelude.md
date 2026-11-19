# Prelude

This annex defines the prelude, three type declarations that the type system uses for its own needs: a unit, a pair and a type of positions; it then defines the packing of a telescope into nested pairs, and of its arguments into nested constructors of pairs, the unpacking of a term of a packing, and the positions of the recursive destructors and their resumption.
It builds on the [grades](04-grades.md), the [modes](05-modes.md), the [levels](06-levels.md), the [sorts](07-sorts.md), the [syntax](08-syntax.md), with its [recursive destructors](08-syntax.md#destructors-of-a-block), and the [substitution](09-substitution.md).

## Definitions

This section gives the declarations of the prelude and the signature that holds them, then the packing of the telescopes and of their arguments, their unpacking, and the positions.

### Declarations

The unit `Unit` has, at each level $`l`$, a single constructor without fields, in the universe $`U_l`$:

```math
\begin{aligned}
& \mathsf{data}.\{;\ l;\ \mid \top\}\ \varepsilon : U_l\ \mathsf{where}\ \mathsf{Unit} \mathrel{▶} {00}^{\gamma} \oplus \varnothing \mathrel{≔} \mathsf{mk} : \varepsilon &&(\mathsf{prelude}.\mathsf{Unit})
\end{aligned}
```

The pair `Pair` holds a term $`x`$ of a type $`A`$ of any sort, used with the grade $`p`$ and of the requirement $`r`$, and a term of $`X[x]`$, a type of a universe that depends on $`x`$, used once and requiring the ownership $`{11}^{\mathsf{p}}`$ of a new value, that of every packing of arguments, so that the unpacking keeps the ownership of each entry; it lives in a universe whatever the sort of $`A`$, and its constraint admits the instances at which a proposition $`A`$ has a grade without use at run time, as the formation of its fields requires, and it is strictly positive in both its parameters:

```math
\begin{aligned}
& \mathsf{data}.\{s;\ l_1, l_2;\ p, r \mid s = \Omega \implies \llcorner p \lrcorner \ne {11}^{\mathsf{m}}\} &&(\mathsf{prelude}.\mathsf{Pair}) \\
& \quad (A : s_{l_1},\ X : (x : A \mathrel{▶} {\omega\omega}^{\mathsf{p}};\ {\omega\omega}^{\mathsf{p}} \mathrel{◀} {\omega\omega}^{\mathsf{p}} \vdash U_{l_2} \mathrel{◀} {\omega\omega}^{\mathsf{p}})) : U_{l_1 \sqcup l_2} \\
& \quad \mathsf{where} \\
& \qquad \mathsf{Pair} \mathrel{▶} {00}^{\gamma} \bullet p \bullet {11}^{\mathsf{p}} \oplus \{A, X\} \mathrel{≔} \\
& \qquad \quad \mathsf{mk} : (x : A \mathrel{▶} p;\ {\omega\omega}^{\mathsf{p}} \mathrel{◀} r,\ y : X[x] \mathrel{▶} {11}^{\mathsf{p}};\ {00}^{\mathsf{p}} \mathrel{◀} {11}^{\mathsf{p}})
\end{aligned}
```

The type of positions `Step` holds either a term of a type $`A`$ of a universe, used with the grade $`p`$ and requiring the ownership $`{11}^{\mathsf{p}}`$ of a new value, that of every packing of arguments, by its constructor $`\mathsf{next}`$, or a term of a type $`B`$ of any sort, used with the grade $`q`$ and of the requirement $`r`$, by its constructor $`\mathsf{done}`$; it lives in a universe whatever the sort of $`B`$, its constraint admits the instances at which a proposition $`B`$ has a grade without use at run time, and it is strictly positive in both its parameters:

```math
\begin{aligned}
& \mathsf{data}.\{s;\ l_1, l_2;\ p, q, r \mid s = \Omega \implies \llcorner q \lrcorner \ne {11}^{\mathsf{m}}\} &&(\mathsf{prelude}.\mathsf{Step}) \\
& \quad (A : U_{l_1},\ B : s_{l_2}) : U_{l_1 \sqcup l_2} \\
& \quad \mathsf{where} \\
& \qquad \mathsf{Step} \mathrel{▶} {00}^{\gamma} \bullet p \bullet q \oplus \{A, B\} \mathrel{≔} \\
& \qquad \quad {\mid} \\
& \qquad \qquad \mathsf{next} : (x : A \mathrel{▶} p;\ {00}^{\mathsf{p}} \mathrel{◀} {11}^{\mathsf{p}}) \\
& \qquad \qquad \mathsf{done} : (x : B \mathrel{▶} q;\ {00}^{\mathsf{p}} \mathrel{◀} r)
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

A telescope packs into nested pairs, which need the sort of each of its entries, given by a telescope in sorts.
The level $`\mathsf{level}_{\bar\kappa}(l)`$ of a packing is the join of the levels of the sorts $`\bar\kappa`$ and of $`l`$; the packing $`{\langle \Theta \rangle_{\bar\kappa;\ l}}`$ of the telescope $`\Theta`$, whose entries live in the sorts $`\bar\kappa`$, is the pair of its first entry, with its grade and its requirement, and of the packing of the rest, ending with the unit of the level $`l`$; the packing $`{\langle \bar t \rangle_{\Theta;\ \bar\kappa;\ l}}`$ of arguments of $`\Theta`$ is the pair of the first argument and of the packing of the others, as arguments of the rest of the telescope instantiated by the first, ending with the constructor of the unit:

```math
\begin{aligned}
& \mathsf{level}_{()}(l) = l &&(\mathsf{level}_{\bar\kappa}) \\
& \mathsf{level}_{(s_{l'},\ \bar\kappa)}(l) = l' \sqcup \mathsf{level}_{\bar\kappa}(l) \\[1em]
& \langle \varepsilon \rangle_{();\ l} = \mathsf{Unit}.\{;\ l;\}\ () &&(\mathsf{pack}_\Theta) \\[1em]
& {=} \\
& \quad \langle x : A \mathrel{▶} p;\ q \mathrel{◀} r,\ \Theta \rangle_{(s_{l'},\ \bar\kappa);\ l} \\
& \quad \mathsf{Pair}.\{s;\ l', \mathsf{level}_{\bar\kappa}(l);\ p, r\}\ (A,\ x.\, \langle \Theta \rangle_{\bar\kappa;\ l}) \\[1em]
& \langle () \rangle_{\varepsilon;\ ();\ l} = (\mathsf{Unit}.\{;\ l;\}\ ()).\mathsf{mk}() &&(\mathsf{pack}_{\bar t}) \\[1em]
& {=} \\
& \quad \langle (t,\ \bar t) \rangle_{(x : A \mathrel{▶} p;\ q \mathrel{◀} r,\ \Theta);\ (s_{l'},\ \bar\kappa);\ l} \\
& \quad (\mathsf{Pair}.\{s;\ l', \mathsf{level}_{\bar\kappa}(l);\ p, r\}\ (A,\ x.\, \langle \Theta \rangle_{\bar\kappa;\ l})).\mathsf{mk}(t,\ \langle \bar t \rangle_{\Theta[t / x];\ \bar\kappa;\ l})
\end{aligned}
```

### Unpacking

The unpacking $`{\mathsf{unpack}_r\ u : \langle \Theta \rangle_{\bar\kappa;\ l}\ \mathsf{return}\ C : \kappa\ \mathsf{with}\ b}`$ of the term $`u`$ of the packing of $`\Theta`$ into the term $`b`$, over the variables of $`\Theta`$, is a recursor on each pair, then on the unit, each using its term with the grade $`r`$, with the motive $`{z.\, C}`$ of the sort $`\kappa`$, which does not depend on the term $`z`$ eliminated; the branch of the pair unpacks its second field into $`b`$, which does not use the variable $`y`$ of this field, and these recursors, on types without nested field, carry the ownership $`{11}^{\mathsf{p}}`$ twice:

```math
\begin{aligned}
& {=} &&(\mathsf{unpack}) \\
& \quad \mathsf{unpack}_r\ u : \langle \varepsilon \rangle_{();\ l}\ \mathsf{return}\ C : \kappa\ \mathsf{with}\ b \\
& \quad \mathsf{rec}_{r;\ {11}^{\mathsf{p}};\ {11}^{\mathsf{p}}}\ (\mathsf{Unit}.\{;\ l;\}\ ())\ u\ \mathsf{return}\ z.\, C : \kappa\ \mathsf{with}\ \mathsf{Unit}.\mathsf{mk}() \Rightarrow b \\[1em]
& {=} \\
& \quad \mathsf{unpack}_r\ u : \langle x : A \mathrel{▶} p;\ q \mathrel{◀} r',\ \Theta \rangle_{(s_{l'},\ \bar\kappa);\ l}\ \mathsf{return}\ C : \kappa\ \mathsf{with}\ b \\
& \quad \mathsf{rec}_{r;\ {11}^{\mathsf{p}};\ {11}^{\mathsf{p}}}\ (\mathsf{Pair}.\{s;\ l', \mathsf{level}_{\bar\kappa}(l);\ p, r'\}\ (A,\ x.\, \langle \Theta \rangle_{\bar\kappa;\ l}))\ u \\
& \qquad \mathsf{return}\ z.\, C : \kappa \\
& \qquad \mathsf{with}\ \mathsf{Pair}.\mathsf{mk}(x,\ y) \Rightarrow \mathsf{unpack}_r\ y : \langle \Theta \rangle_{\bar\kappa;\ l}\ \mathsf{return}\ C : \kappa\ \mathsf{with}\ b
\end{aligned}
```

### Positions

A recursive destructor of a block of codata types gives back, in a branch of a corecursor, a position: a new state, packed, from which the corecursor goes on, or a term already built.
The grade $`q_s`$ of a term already built, of the quality $`s`$, is $`{11}^{\mathsf{p}}`$ in a universe, and $`{01}^{\mathsf{p}}`$, without use at run time, in a universe of propositions, as the constraint of the type of positions requires; the type of positions $`{\mathsf{pos}_{r;\ \chi}(\Theta : \bar\kappa,\ T : s_{l'})}`$ of a corecursor of the grade $`r`$ whose state $`\Theta`$ lives in the sorts $`\bar\kappa`$, at the terms already built of the type $`T`$ of the sort $`s_{l'}`$ that the ownership $`\chi`$ requires, is the instance of `Step` at the packing of the state, of the level $`\mathsf{level}_{\bar\kappa}(l)`$, where $`{l = \mathsf{level}_{\bar\kappa}(0)}`$ is the join of the levels of $`\bar\kappa`$, and at $`T`$:

```math
\begin{aligned}
& q_U = {11}^{\mathsf{p}} &&(q_s) \\
& q_\Omega = {01}^{\mathsf{p}} \\[1em]
& \mathsf{pos}_{r;\ \chi}(\Theta : \bar\kappa,\ T : s_{l'}) = \mathsf{Step}.\{s;\ \mathsf{level}_{\bar\kappa}(l), l';\ r, q_s, \chi\}\ (\langle \Theta \rangle_{\bar\kappa;\ l},\ T) &&(\mathsf{pos})
\end{aligned}
```

In a block $`\mathcal{D}`$ of codata types $`{D_1, \dots, D_k}`$, whose states are $`{\bar\Theta = (\Theta_1 : \bar\kappa_1,\ \dots,\ \Theta_k : \bar\kappa_k)}`$, the type $`{\mathsf{pos}_{\bar\Theta;\ r;\ \chi}(B,\ T : \kappa)}`$ of the branch of a destructor whose result is $`B`$, at the type $`T`$ of this result, is the type of the positions of the state of the type of the block that $`B`$ names, if the destructor is recursive, and $`T`$ otherwise:

```math
\begin{aligned}
& \mathsf{pos}_{\bar\Theta;\ r;\ \chi}(B,\ T : \kappa) = \mathsf{pos}_{r;\ \chi}(\Theta_j : \bar\kappa_j,\ T : \kappa) \text{ if } \mathsf{rec}_{\mathcal{D}}(B) = D_j &&(\mathsf{pos}_{\bar\Theta}) \\
& \mathsf{pos}_{\bar\Theta;\ r;\ \chi}(B,\ T : \kappa) = T \text{ otherwise}
\end{aligned}
```

The resumption $`{\mathsf{resume}_{r;\ \chi}(v,\ T : \kappa,\ \bar\Theta,\ \bar g)}`$ of the position $`v`$ of the instance $`{T = D_j.\{\bar s;\ \bar l;\ \bar p\}\ \bar a}`$, of the sort $`\kappa`$, by the corecursor of the grade $`r`$ with the states $`\bar\Theta`$ and the branches $`\bar g`$, is a recursor on $`v`$, which carries the ownership $`{11}^{\mathsf{p}}`$ twice as those of the unpacking do, with the motive $`{z.\, T}`$, which unpacks a new state into the corecursor of $`T`$ from the variables $`\bar y_j`$ of the state $`\Theta_j`$ of $`D_j`$, of the sorts $`\bar\kappa_j`$ and of the join $`{l_j = \mathsf{level}_{\bar\kappa_j}(0)}`$ of their levels, and gives a term already built itself; the resumption $`{\mathsf{resume}_{B;\ r;\ \chi}(v,\ T : \kappa,\ \bar\Theta,\ \bar g)}`$ of the term $`v`$ of the branch of a destructor whose result is $`B`$, observed in a corecursor of the instance $`{T = D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a}`$, is the resumption of $`v`$ by the corecursor of the type of the block that $`B`$ names, if the destructor is recursive, and $`v`$ otherwise:

```math
\begin{aligned}
& {=} &&(\mathsf{resume}) \\
& \quad \mathsf{resume}_{r;\ \chi}(v,\ T : \kappa,\ \bar\Theta,\ \bar g) \\
& \quad \mathsf{rec}_{{11}^{\mathsf{p}};\ {11}^{\mathsf{p}};\ {11}^{\mathsf{p}}}\ \mathsf{pos}_{r;\ \chi}(\Theta_j : \bar\kappa_j,\ T : \kappa)\ v \\
& \qquad \mathsf{return}\ z.\, T : \kappa \\
& \qquad \mathsf{with} \\
& \qquad \quad (\mathsf{Step}.\mathsf{next}(x) \Rightarrow \\
& \qquad \qquad \phantom{(}\mathsf{unpack}_r\ x : \langle \Theta_j \rangle_{\bar\kappa_j;\ l_j}\ \mathsf{return}\ T : \kappa\ \mathsf{with}\ \mathsf{corec}_r\ T\ \mathsf{from}\ \bar y_j\ \mathsf{return}\ \bar\Theta\ \mathsf{with}\ \bar g, \\
& \qquad \quad \phantom{(}\mathsf{Step}.\mathsf{done}(x) \Rightarrow x) \\[1em]
& {=} \text{ if} &&(\mathsf{resume}_B) \\
& \quad \mathsf{resume}_{B;\ r;\ \chi}(v,\ D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a : \kappa,\ \bar\Theta,\ \bar g) \\
& \quad \mathsf{resume}_{r;\ \chi}(v,\ D_j.\{\bar s;\ \bar l;\ \bar p\}\ \bar a : \kappa,\ \bar\Theta,\ \bar g) \\
& \quad \mathsf{rec}_{\mathcal{D}}(B) = D_j \\[1em]
& \mathsf{resume}_{B;\ r;\ \chi}(v,\ T : \kappa,\ \bar\Theta,\ \bar g) = v \text{ otherwise}
\end{aligned}
```
