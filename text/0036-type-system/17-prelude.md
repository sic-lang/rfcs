# Prelude

This annex defines the prelude, three type declarations that the type system uses for its own needs: a unit, a pair and a type of positions; it then defines the packing of a telescope into nested pairs, and of its arguments into nested constructors of pairs, and the unpacking of a term of a packing, with the properties of these packings and of the unpacking.
It builds on the [usage](11-usage.md), the [ownership](12-ownership.md) and the [typing](13-typing.md).

## Definitions

This section gives the declarations of the prelude and the signature that holds them, then the packing of the telescopes and of their arguments.

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

The type of positions `Step` holds either a term of a type $`A`$ of a universe, used with the grade $`p`$, by its constructor $`\mathsf{next}`$, or a term of a type $`B`$ of any sort, used with the grade $`q`$, by its constructor $`\mathsf{done}`$; it lives in a universe whatever the sort of $`B`$, and its constraint admits the instances at which a proposition $`B`$ has a grade without use at run time:

```math
\begin{aligned}
& \mathsf{data}.\{s;\ l_1, l_2;\ p, q \mid s = \Omega \implies \llcorner q \lrcorner \ne {11}^{\mathsf{m}}\}\ (A : U_{l_1},\ B : s_{l_2}) : U_{l_1 \sqcup l_2} &&(\mathsf{prelude}.\mathsf{Step}) \\
& \quad \mathsf{where}\ \mathsf{Step} \mathrel{▶} {00}^{\gamma} \bullet p \bullet q \mathrel{≔} \mathsf{next} : (x : A \mathrel{▶} p;\ {00}^{\mathsf{p}} \mathrel{◀} {\omega\omega}^{\mathsf{p}}) \mid \mathsf{done} : (x : B \mathrel{▶} q;\ {00}^{\mathsf{p}} \mathrel{◀} {\omega\omega}^{\mathsf{p}})
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

A telescope packs into nested pairs, which need the sort of each of its entries, while a telescope in a sort only bounds them; the telescope $`\Theta`$ lives in the sorts $`\bar\kappa`$ below the level $`l`$, $`\Sigma;\ \Gamma \vdash \Theta : \bar\kappa \le l`$, when the type of each entry lives in its sort, of a level below $`l`$, and an entry whose type is a proposition has a grade without use at run time, as in a [telescope in a sort](13-typing.md#telescopes-in-a-sort):

```math
\begin{gathered}
\frac{\Sigma \vdash \Gamma}{\Sigma;\ \Gamma \vdash \varepsilon : () \le l}\;(\mathsf{tel}_{\bar\kappa\varepsilon}) \\[1em]
\frac{\begin{gathered}{}\Sigma;\ \Gamma \vdash A : s_{l'} \\ l' \le l \\ \Sigma;\ \Gamma,\ x : A \vdash \Theta : \bar\kappa \le l \\ \llcorner p \lrcorner \ne {11}^{\mathsf{m}} \text{ if } s \text{ is } \Omega\end{gathered}}{\Sigma;\ \Gamma \vdash (x : A \mathrel{▶} p;\ q \mathrel{◀} r,\ \Theta) : (s_{l'},\ \bar\kappa) \le l}\;(\mathsf{tel}_{\bar\kappa,})
\end{gathered}
```

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
