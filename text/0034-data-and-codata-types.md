# RFC 0034: Data and Codata Types

- Pull request: [sic-lang/rfcs#34](https://github.com/sic-lang/rfcs/pull/34)

## Summary

This RFC defines the two kinds of declarations that give the [graded dependent core](https://github.com/sic-lang/rfcs/pull/24) of Sic its types: the data types, known by their constructors and eliminated by a recursor, and the codata types, known by their destructors and introduced by a corecursor.
A block of data or codata types may be recursive, strictly positive through the parameters of the types declared before it, with parameters that its recursive occurrences may change; the recursor and the corecursor are the only recursion of the core, and their usage counts the resources of every unfolding at once.
Functions, records, sums, units, natural numbers and streams are instances of the two kinds, not built in, and each kind fulfills the contract of the core: its rules, its meaning as a least or a greatest fixed point, its conversion and its erasure.
The rules use three declarations of the two kinds, a prelude that no program names: the type of the positions of a corecursor, a pair and a unit.

## Motivation

A dependently typed language needs types whose terms are built, such as numbers and lists, and types whose terms are observed, such as functions, objects and streams; a graded language needs their eliminations and their introductions to count the uses of their parts, and a total language needs its recursion to be checked.
Most type theories build the functions in, declare the inductive types, and treat the coinductive types as a late addition; here the two polarities of [Zeilberger](https://noamz.org/thesis.pdf) are the only two mechanisms, dual in every rule, and the functions are a codata type among others.
This RFC gives the rules of both kinds, the recursion of each, with the usage of its unfoldings after [Eriksson, Abel and Danielsson](https://doi.org/10.1145/3828677), and what the [core](https://github.com/sic-lang/rfcs/pull/24) asks of a kind of declaration: its meaning, its conversion, its erasure and its obligations.

## Proposal

The proposal first fixes the notation, then defines the declarations of both kinds, their polarity, their positivity, their prelude and their liftings, the data types with their constructors and their recursor, the codata types with their destructors and their corecursor, the conversion and the erasure of their terms.
It then gives their meaning, as least and greatest fixed points, and the properties that the kinds bring to the core.

### Notation

This RFC uses the notation and the conventions of the [core](https://github.com/sic-lang/rfcs/pull/24), with the letters below for its own objects:

| Letters | Denote |
| --- | --- |
| $`c, d`$ | Constructors and destructors |
| $`\mathcal{D}`$ | A declaration, a block of data types or of codata types |
| $`D_j, T_j`$ | The types of the block, and their instances; $`D, T`$ when the block has one type |
| $`h`$ | The index of the type of the block that a recursor eliminates or a corecursor introduces |
| $`\Theta_{ji}`$ | The fields of the constructor $`c_{ji}`$, or the arguments of the destructor $`d_{ji}`$ |
| $`B_{ji}`$ | The result type of the destructor $`d_{ji}`$ |
| $`\bar y`$ | The recursive results of a branch of the recursor, one per recursive field |
| $`C_j`$ | The motives, the result types of a recursor |
| $`S_j`$ | The states of a corecursor, telescopes whose entries carry the grades $`r_{jl}`$ |
| $`\bar s, \bar w, \bar e`$ | A state, the variables bound to the state in the branches, and a new state |
| $`F, G`$ | Types in which the types of the block occur |
| $`P`$ | A predicate on the terms of a type, as a second-order variable |
| $`\pi`$ | The grade of a position of a type of the block in a field, and the index of the rules of observation |
| $`\chi`$ | The usage of the unfoldings of a recursion |

A block is written with its types separated by semicolons, each with its constructors or its destructors separated by bars; in the rules, $`n_j`$ is the number of constructors or destructors of $`D_j`$, and $`k`$ the number of types of the block.
The rules of the data types carry the exponent $`+`$ and those of the codata types the exponent $`-`$, so that two dual rules differ only by their sign; the rules that both kinds share have no sign.
The index $`\mathsf{rec}`$ names the recursor, and $`\pi`$ names the observation of a codata term by a destructor, as the [core](https://github.com/sic-lang/rfcs/pull/24) names every observation.
As in the core, a variable left free in a formula is universally quantified over the kind that its letter names, and a rule holds for every instance of its schematic variables; in a section whose opening sentence fixes the block $`\mathcal{D}`$ and its instances, the block, with the types, constructors, destructors, telescopes and grades it declares, and the signature $`\Sigma`$ are the parameters of the rules and of the formulas of the section, which the convention does not quantify.

The types of ADE, its functions, its weak and strong pairs and units, its empty type and its natural numbers with their recursor, are instances of the two kinds, declared as codata and data types; this RFC declares none of them, and gives no example; the three declarations of its [prelude](#prelude) serve the type system, and no program names them.

### Declarations

A declaration of this RFC is a block of data types or a block of codata types, whose header the [core](https://github.com/sic-lang/rfcs/pull/24) fixes: a kind, the sort, level and grade variables, the parameters $`\Delta`$ and the sort $`\kappa`$ that the types of the block share.

#### Blocks

A data type is known by its constructors, each with the telescope of its fields, and a codata type by its destructors, each with the telescope of its arguments, its result type and two grades:

```math
\mathsf{data}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{≔} c_{11} : \Theta_{11} \mid \dots \mid c_{1n_1} : \Theta_{1n_1};\ \dots;\ D_k \mathrel{≔} c_{k1} : \Theta_{k1} \mid \dots \mid c_{kn_k} : \Theta_{kn_k}
```

```math
\mathsf{codata}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{≔} d_{11} :^{q_{11}}_{p_{11}} \Theta_{11} \to B_{11} \mid \dots;\ \dots;\ D_k \mathrel{≔} d_{k1} :^{q_{k1}}_{p_{k1}} \Theta_{k1} \to B_{k1} \mid \dots
```

A block is homogeneous: all its types are data types, or all are codata types, as the polarity of the block.
A destructor carries two grades: $`p`$ for the uses of its result, and $`q`$ for its uses in the arguments and the results of the destructors after it; the last destructor carries a grade $`q`$ too, which only has to allow no use.
A data type may have no constructor and a codata type no destructor.

The types of a block may occur in its bodies, which makes the block recursive: in the fields of its constructors or in the results of its destructors, directly or nested in the types declared before it, as the [positivity](#positivity) allows.
A block whose types occur in no body is not recursive, and so is every block of one type that does not refer to itself.
Types that are inductive in some positions and coinductive in others are declared by nesting a block of one polarity in a block of the other, which fixes the order of their fixed points, as the types of [Basold and Geuvers](https://doi.org/10.1145/2933575.2934514) do: a process that takes finitely many steps before it observes itself again is a codata type whose observation returns a data type of steps, declared before, at a parameter of which the codata type occurs.

#### Polarity

A parameter of a type of the block is a type parameter when its type is a sort, or a telescope that ends in a sort; the types of the block occur in bodies only at type parameters of other types, and the polarity of a type parameter says how the type uses it.
The polarity of a type parameter $`X`$ of a type $`D_j`$ is computed from the occurrences of $`X`$ in the bodies of $`D_j`$:

- An occurrence of $`X`$ is strictly positive when it is the type of a field, the result type of a destructor, or nested in such a type at a strictly positive type parameter of a type declared before the block, through strictly positive occurrences only.
- An occurrence is negative when it is in an argument of a destructor, or at a negative type parameter of a type declared before the block, with strictly positive occurrences on the way, or at a strictly positive parameter with one negative step on the way.
- Every other occurrence is mixed: at a mixed parameter, at a parameter that is not a type parameter, in a term, in the arguments of a second-order variable, or with two negative steps on the way.
- An occurrence of $`X`$ in an argument of an occurrence of a type of the block is ignored when the argument is $`X`$ itself, passed unchanged, and mixed otherwise.

A type parameter is strictly positive when all its occurrences are, negative when all are negative, unused when it has none, and mixed otherwise.
The polarity is part of the formation of the block, as the [contract](https://github.com/sic-lang/rfcs/pull/24) requires, so that a later block may nest its types at the strictly positive parameters of this one.
A parameter that is not a type parameter has no polarity.

#### Positivity

A type of the block occurs strictly positively in a body when it is the type of a field, the result type of a destructor, or nested in such a type at strictly positive type parameters of types declared before the block, through strictly positive occurrences only, and never in an argument of an occurrence of a type of the block.
A block is well formed only when all the occurrences of its types are strictly positive, which is the strict positivity of [Coquand and Paulin](https://doi.org/10.1007/3-540-52335-9_47) extended through the parameters, as the nested inductive types of [Lean](https://lean-lang.org/doc/reference/latest/The-Type-System/Inductive-Types/#nested-inductive-types) and [Rocq](https://rocq-prover.org/doc/master/refman/language/core/inductive.html) extend it: a type whose children are given by a function, or stored in a list, is a tree.

#### Uniformity

A parameter of the block is uniform when every occurrence of a type of the block in the bodies passes it unchanged, as the variable of the parameter itself, and when the parameters that its type depends on are uniform; it is non-uniform otherwise, as the parameters after the bar of [Rocq](https://rocq-prover.org/doc/master/refman/language/core/inductive.html).
Uniformity is computed, not declared: the non-uniform parameters, written $`\Delta_{\mathsf{nu}}`$ with the variables $`\bar x_{\mathsf{nu}}`$, are the parameters that a recursion lets vary, as the argument of an accessibility predicate or the element type of a type nested in itself, while the uniform parameters, written $`\Delta_{\mathsf{u}}`$, stay fixed.
For an instance $`T_j = D_j.\{\bar s;\ \bar l;\ \bar p\}\ \bar a`$ with the arguments $`\bar a_{\mathsf{u}}`$ and $`\bar a_{\mathsf{nu}}`$ for the two kinds of parameters, $`T_j[\bar b]`$ is the instance with the non-uniform arguments $`\bar b`$ in place of $`\bar a_{\mathsf{nu}}`$, and a body $`\Theta_{ji}[\bar a_{\mathsf{u}}]`$ or $`B_{ji}[\bar a_{\mathsf{u}}]`$ is the body with the uniform arguments substituted, in which the non-uniform parameters stay variables.

#### Formation

A block of data types is well formed when the fields of each constructor live in its sort, its parameters forming a context, which the fields imply unless there is no constructor, when its occurrences are strictly positive, and when its types use their parameters as the grades $`\zeta`$ say, which the [usage](#usage-of-data-types) of the instances reads.
The fields of a data type in a universe of propositions are thus propositions, since irrelevance would otherwise equate data that hold different values:

```math
\frac{\begin{gathered}{}\Sigma,\ \mathcal{D};\ \Delta \vdash \Theta_{ji} : \kappa \quad c_{ji} \ne c_{ji'} \text{ for } i \ne i' \quad \text{for each } j, i \\ \mathcal{D} \text{ is strictly positive} \quad \zeta \text{ is the usage of } \mathcal{D} \\ \Sigma \vdash \Delta \text{ if } n_j = 0 \text{ for some } j\end{gathered}}{\Sigma \vdash \mathsf{data}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{≔} \dots;\ \dots;\ D_k \mathrel{≔} \dots}\;(\mathsf{data})
```

The bodies are checked in the signature extended by the block itself, so that its types are types in them, with the rule $`(D)`$ of the [core](https://github.com/sic-lang/rfcs/pull/24); the positivity ensures that this circle is well founded.
A block of codata types is well formed when the arguments of each destructor live in any sort at its level $`l`$, and its result, a telescope of one entry with the grades of the destructor, in its sort; the earlier destructors are second-order variables in the types of each one, so that a destructor may depend on the results of those before it:

```math
\frac{\begin{gathered}{}\kappa = s_l \quad \Sigma,\ \mathcal{D};\ \Delta_{ji} \vdash \Theta_{ji} : U_l \quad \Sigma,\ \mathcal{D};\ \Delta_{ji},\ \Theta_{ji} \vdash (d_{ji} :^{q_{ji}}_{p_{ji}} B_{ji}) : \kappa \quad d_{ji} \ne d_{ji'} \text{ for } i \ne i' \quad \text{for each } j, i \\ \Delta_{ji} \;=\; \Delta,\ d_{j1} : (\Theta_{j1} \vdash B_{j1}),\ \dots,\ d_{j(i - 1)} : (\Theta_{j(i - 1)} \vdash B_{j(i - 1)}) \\ \mathcal{D} \text{ is strictly positive} \quad \zeta \text{ is the usage of } \mathcal{D} \\ \Sigma \vdash \Delta \text{ if } n_j = 0 \text{ for some } j\end{gathered}}{\Sigma \vdash \mathsf{codata}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{≔} \dots;\ \dots;\ D_k \mathrel{≔} \dots}\;(\mathsf{codata})
```

The usage $`\zeta`$ of the block gives each type $`D_j`$ a vector $`\zeta_j`$ over $`\Delta`$, the grades with which its body uses the parameters, and the [usage](#usage-of-data-types) of each kind says how it is computed.

#### Prelude

Three declarations of the two kinds serve the rules of this RFC, which the signature holds before the first term that uses them, a recursor on a nested field or a corecursor: the type of the positions of a corecursor, a pair and a unit, the last two of which pack a telescope.
They are the prelude of the signature, and none of them is recursive: their formation needs neither the liftings nor the type of positions, which they serve, so that there is no circle.
The type of positions $`S \oplus T`$ holds either a new state, used as its grade variable $`r`$ says, or a term already built; the pair holds two fields with a grade variable each, the second depending on the first through a second-order parameter; the unit holds nothing.
Each field has a sort variable of its own, and a type of the prelude lives in the join of the sorts of its fields, which the [core](https://github.com/sic-lang/rfcs/pull/24) defines: a pair of a term and of a proof lives in a universe, and a pair of two proofs in a universe of propositions.

```math
\begin{aligned}
& \mathsf{data}.\{s_1, s_2;\ l_1, l_2;\ r\}\ (S : s_{1 l_1},\ T : s_{2 l_2}) : (s_1 \sqcup s_2)_{l_1 \sqcup l_2}\ \mathsf{where}\ {\oplus} \mathrel{≔} \mathsf{next} : (e :^{\mathbb{0}}_{r} S) \mid \mathsf{done} : (t :^{\mathbb{0}}_{\mathbb{1}} T) \\
& \mathsf{data}.\{s_1, s_2;\ l_1, l_2;\ p_1, q_1, p_2\}\ (A : s_{1 l_1},\ B : (x : A \vdash s_{2 l_2})) : (s_1 \sqcup s_2)_{l_1 \sqcup l_2}\ \mathsf{where}\ \mathsf{Pair} \mathrel{≔} \mathsf{mk} : (x :^{q_1}_{p_1} A,\ y :^{\mathbb{0}}_{p_2} B[x]) \\
& \mathsf{data}.\{s;\ l\} : s_l\ \mathsf{where}\ \mathsf{Unit} \mathrel{≔} \mathsf{mk} : ()
\end{aligned}
```

A telescope $`\Theta`$ that lives in a sort $`\kappa`$ is packed at $`\kappa`$ in a type $`\langle \Theta \rangle`$ of $`\kappa`$: the nested pairs of its entries, with their grades, which end with the unit of $`\kappa`$, so that the joins of the sorts and of the levels give $`\kappa`$ back; its terms are written $`\langle \bar t \rangle`$, the nested pairs of the terms of the telescope, at the instance that the position of the term determines:

```math
\begin{aligned}
\langle \varepsilon \rangle &= \mathsf{Unit}.\{s;\ l\} \quad \text{for } \kappa = s_l &&(\langle \Theta \rangle_\varepsilon) \\
\langle x :^{q}_{p} A,\ \Theta \rangle &= \mathsf{Pair}.\{s_1, s_2;\ l_1, l_2;\ p, q, \mathbb{1}\}\ (A,\ x.\, \langle \Theta \rangle) \quad \text{for } A : s_{1 l_1} \text{ and } \langle \Theta \rangle : s_{2 l_2} &&(\langle \Theta \rangle_{,}) \\
\langle \rangle &= \langle \varepsilon \rangle.\mathsf{mk}() &&(\langle \bar t \rangle_\varepsilon) \\
\langle t,\ \bar t \rangle &= \langle x :^{q}_{p} A,\ \Theta \rangle.\mathsf{mk}(t,\ \langle \bar t \rangle) &&(\langle \bar t \rangle_{,})
\end{aligned}
```

A term $`\langle \bar t \rangle`$ is taken apart by the recursors of its pairs, which the rule $`(D^{+}_\eta)`$ below makes equal to its parts, so that a branch written on the variables of a packed telescope, as the branches on $`\mathsf{next}`$ of the corecursor, abbreviates the branch on the packed term followed by these recursors; the type of positions of a telescope $`S`$ of states is written $`S \oplus T`$, over $`\langle S \rangle`$.

The prelude exists for the type system, and the surface language never names a declaration of the prelude, neither its types, nor its constructors, nor its recursors: only the constructs of the surface language elaborate to them.
The keywords $`\mathsf{next}`$ and $`\mathsf{done}`$ are valid at the positions of a branch of a corecursor only, a state of several components, $`\mathsf{next}\ e_1\ e_2`$, is packed by the elaboration, and the recursive result of a nested recursive field, whose type packs the liftings of the motives, is presented by a construct of the surface language, whose form the RFC of the surface language fixes.
The pairs and the unit that a program declares are its own declarations, generative as every declared type, and the [rationale](#rationale-and-alternatives) says why the prelude is hidden.

#### Liftings

A recursion over a type of the block must reach its occurrences nested in the types declared before, as the children of a tree stored in a list, or given by a function: the recursive result of such a field states that the motive holds at every position of the block in it, which a lifting of the motive through the nesting type expresses, after the unary parametricity translation of [Bernardy, Jansson and Paterson](https://doi.org/10.1145/1863543.1863592).
The positions of a type $`G`$ are its occurrences of the types of the block; a type has positions only where the [positivity](#positivity) allows, directly or at strictly positive type parameters of the types declared before.

The lifting $`\mathsf{lift}_G[\bar P](w)`$ of predicates $`\bar P`$ on the types of the block, one predicate $`P_j : (\bar x_{\mathsf{nu}} : \Delta_{\mathsf{nu}},\ z : T_j[\bar x_{\mathsf{nu}}] \vdash \kappa_P)`$ per type, through a type $`G`$ with positions, at a term $`w : G`$, is a type that states that the predicates hold at every position of $`w`$; it is defined by the structure of $`G`$:

```math
\begin{aligned}
\mathsf{lift}_{T_j[\bar b]}[\bar P](w) &= P_j[\bar b,\ w] &&(\mathsf{lift}_D) \\
\mathsf{lift}_{D'\ \bar b}[\bar P](w) &= \mathsf{lift}_{D'}[\bar x_X.\, v.\, \mathsf{lift}_{G_X}[\bar P](v) \text{ for each } X](\bar b,\ w) &&(\mathsf{lift}_{D'})
\end{aligned}
```

In $`(\mathsf{lift}_{D'})`$, $`D'`$ is a type declared before the block, whose arguments $`\bar b`$ have positions only in the abstractions $`\bar x_X.\, G_X`$ of its strictly positive type parameters $`X`$, and $`\mathsf{lift}_{D'}`$ is the lifting of $`D'`$ at these parameters: a derived operation that every declaration provides for its strictly positive type parameters, as the [contract](https://github.com/sic-lang/rfcs/pull/24) requires, which takes a predicate $`P_X : (\bar x_X : \Theta_X,\ v : X[\bar x_X] \vdash \kappa_P)`$ for each of them.
For a data type $`D'`$, it is defined by its recursor into the sort $`\kappa_P`$, whose branch for each constructor packs the liftings of the fields that have positions, with the grades of these fields, in a telescope, as the [prelude](#prelude) packs a telescope at the sort $`\kappa_P`$; a recursive field of $`D'`$ gets its recursive result, the lifting at the field, and the empty telescope packs into the unit:

```math
\begin{aligned}
\mathsf{lift}_{D'}[\bar P](\bar b,\ w) = {}& \mathsf{rec}_{\mathbb{0}}\ w\ \mathsf{return}\ (z : D'\ \bar b).\, \kappa_P\ \mathsf{with} &&(\mathsf{lift}^{+}) \\
& \quad c_i(\bar x_i;\ \bar y_i) \Rightarrow \langle (v_{il_1} :^{\mathbb{0}}_{p_{il_1}} u_{il_1},\ \dots,\ v_{il_m} :^{\mathbb{0}}_{p_{il_m}} u_{il_m}) \rangle \quad \text{for each } i \\
& \text{where } l_1 < \dots < l_m \text{ are the fields of } c_i \text{ with positions, and} \\
& u_{il} = y_{il} \text{ if } x_{il} \text{ is recursive, and } \mathsf{lift}_{A_{il}}[\bar P](x_{il}) \text{ otherwise}
\end{aligned}
```

For a codata type $`D'`$, it is a derived codata declaration $`D'^{\bar P}`$, declared right after $`D'`$, whose parameters are those of $`D'`$, the predicates and a term $`w`$ of $`D'`$, and whose destructors are those of $`D'`$ that have positions in their result, with the lifting of the result at the observation of $`w`$; the lifting of a recursive destructor of $`D'`$ is an occurrence of $`D'^{\bar P}`$:

```math
\begin{aligned}
\mathsf{codata}.\{\bar s;\ \bar l;\ \bar p\}\ (\Delta',\ \bar P,\ w : D'\ \Delta') : \kappa_P\ \mathsf{where}\ D'^{\bar P} \mathrel{≔} {}& d_{i_1} :^{q_{i_1}}_{p_{i_1}} \Theta_{i_1}[w.\bar d] \to \mathsf{lift}_{B_{i_1}}[\bar P](w.d_{i_1}(\bar x_{i_1})) \mid \dots &&(\mathsf{lift}^{-}) \\
& \text{where } i_1 < \dots \text{ are the destructors of } D' \text{ with positions}
\end{aligned}
```

Here $`[w.\bar d]`$ instantiates the earlier destructors with the observations of $`w`$, as the [destructors](#destructors) define, and the lifting of a type of functions, a codata type with one destructor whose result is a strictly positive parameter, is thus the type of the functions into the lifted result.

The dependent map $`\mathsf{map}_G[\bar P,\ \bar f](w)`$ builds a term of the lifting from proofs $`\bar f`$ of the predicates at every position, one abstraction $`f_j : (\bar x_{\mathsf{nu}},\ z \vdash P_j[\bar x_{\mathsf{nu}}, z])`$ per type of the block; it follows the structure of $`G`$ as the lifting does, and the map of a type declared before is derived from its recursor or its corecursor:

```math
\begin{aligned}
\mathsf{map}_{T_j[\bar b]}[\bar P,\ \bar f](w) &= f_j[\bar b,\ w] &&(\mathsf{map}_D) \\
\mathsf{map}_{D'\ \bar b}[\bar P,\ \bar f](w) &= \mathsf{map}_{D'}[\bar x_X.\, v.\, \mathsf{lift}_{G_X}[\bar P](v),\ \bar x_X.\, v.\, \mathsf{map}_{G_X}[\bar P,\ \bar f](v) \text{ for each } X](\bar b,\ w) &&(\mathsf{map}_{D'}) \\
\mathsf{map}_{D'}[\bar P,\ \bar f](\bar b,\ w) &= \mathsf{rec}_{\mathbb{1}}\ w\ \mathsf{return}\ (z : D'\ \bar b).\, \mathsf{lift}_{D'}[\bar P](\bar b,\ z)\ \mathsf{with}\ c_i(\bar x_i;\ \bar y_i) \Rightarrow \langle u_{il_1},\ \dots,\ u_{il_m} \rangle \quad \text{for each } i &&(\mathsf{map}^{+}) \\
& \text{where } u_{il} = y_{il} \text{ if } x_{il} \text{ is recursive, and } \mathsf{map}_{A_{il}}[\bar P,\ \bar f](x_{il}) \text{ otherwise} \\
\mathsf{map}_{D'}[\bar P,\ \bar f](\bar b,\ w) &= \mathsf{corec}_{\mathbb{1}}\ w\ \mathsf{return}\ (w' :_{\mathbb{1}} D'\ \bar b)\ \mathsf{as}\ w'\ \mathsf{with}\ .d_{i}(\bar x_{i}) \Rightarrow \lceil \mathsf{map}_{B_{i}}[\bar P,\ \bar f](w'.d_{i}(\bar x_{i})) \rceil \quad \text{for each } i \text{ with positions} &&(\mathsf{map}^{-})
\end{aligned}
```

In $`(\mathsf{map}^{+})`$ and $`(\mathsf{map}^{-})`$, $`D'`$ is the data type or the codata type whose map is defined, as in $`(\mathsf{lift}^{+})`$ and $`(\mathsf{lift}^{-})`$; in $`(\mathsf{map}^{-})`$, the corecursor builds a term of $`D'^{\bar P}`$ from the state $`w'`$, and $`\lceil \cdot \rceil`$ puts $`\mathsf{next}\ (w'.d_i(\bar x_i))`$ at the positions of $`D'^{\bar P}`$ that come from the recursive destructors of $`D'`$, so that the map observes $`w'`$ lazily, as the [corecursor](#corecursor) defines.
The liftings and the maps are derived by recursion on the signature: those of a type declared before use those of the types declared before it.

The grades of the positions of $`G`$, written $`\Pi(G)`$, are the grades with which a term of $`G`$ gives access to each position, which the usage of the [recursor](#recursor) reads; a direct position has the grade $`\mathbb{1}`$, and a nested position the product of the grades of the fields or of the destructors on the way to it:

```math
\begin{aligned}
\Pi(T_j[\bar b]) &= \{\mathbb{1}\} &&(\Pi_D) \\
\Pi(D'\ \bar b) &= \{p \cdot \pi \mid X \text{ strictly positive in } D',\ p \in \Pi_{D'}(X),\ \pi \in \Pi(G_X)\} &&(\Pi_{D'}) \\
\Pi_{D'}(X) &= \text{the least set that holds } p \cdot \pi \text{ for each entry of grade } p \text{ of } D' \text{ whose type } A &&(\Pi_X) \\
& \text{has } \pi \in \Pi(A) \text{ at } X, \text{ and } p \cdot \pi \text{ for each recursive entry of grade } p \text{ and } \pi \in \Pi_{D'}(X)
\end{aligned}
```

In $`(\Pi_X)`$, the entries of a data type are the fields of its constructors, and those of a codata type its destructors, whose grade is the grade $`p`$ of the destructor; the set is finite, since the grades are.

### Data Types

A data type is known by its constructors: each of its terms is built by one of them from terms for its fields, and is used by the recursor, which runs a branch for the constructor that built it, with the results of the recursion on its recursive fields.
In the rules of this section, $`\mathcal{D}`$ is a block of data types, written as in the [formation](#formation), of which $`T_j`$ is an instance of each type $`D_j`$, all with the same arguments $`\bar a`$.
The fields of the constructor $`c_{ji}`$ are written as the telescope $`\Theta_{ji}[\bar a_{\mathsf{u}}] = (x_{ji1} :^{q_{ji1}}_{p_{ji1}} A_{ji1},\ \dots,\ x_{jik_{ji}} :^{q_{jik_{ji}}}_{p_{jik_{ji}}} A_{jik_{ji}})`$, in which the uniform arguments are substituted; a field is recursive when its type has positions.

#### Usage of Data Types

The body of a data type uses the variables of each field type as many times as the field is used, checked in the mode of its grade, and the uses of all the constructors added, since the type mentions all of them; a recursive occurrence of a type of the block uses the parameters as the type does, which makes the usage of the block the greatest solution of its constraints.
The usage $`\zeta`$ of the block, which the [formation](#formation) computes, gives each type $`D_j`$ the vector $`\zeta_j`$ over $`\Delta`$ such that, in the signature extended by the block, with the grades $`q`$ of the fields bounding their uses in the types after them:

```math
\begin{aligned}
& \exists (\gamma_{jil})_{j, i, l}.\ (\forall j, i, l.\ \Sigma,\ \mathcal{D};\ \gamma_{jil} \mathrel{▶_{\mathbb{1}\mathbb{1}^{\mathsf{m}} \odot p_{jil}}} A_{jil}) \text{ and} &&(\zeta^{+}) \\
& \quad (\forall j, i.\ \zeta_j \bullet q_{ji1} \bullet \dots \bullet q_{jik_{ji}} \le^{\mathsf{c}} p_{ji1} \cdot^{\mathsf{c}} \gamma_{ji1} +^{\mathsf{c}} \dots +^{\mathsf{c}} p_{jik_{ji}} \cdot^{\mathsf{c}} \gamma_{jik_{ji}}) \\
& \text{where an occurrence } T_{j'}[\bar b] \text{ in a field type uses the variables as } \zeta_{j'} \text{ says of its arguments}
\end{aligned}
```

The vector $`\gamma_{jil}`$ has a grade for each parameter and each field before $`x_{jil}`$, extended by $`\mathbb{0}`$ for the fields from $`x_{jil}`$ on; the usage of an occurrence of a type of the block is that of its instance by the rule $`(D^{+}_{\mathsf{m}})`$ below with $`\zeta_{j'}`$, so that the constraints are circular for a recursive block, and $`\zeta`$ is their greatest solution, which the greatest lower bounds of the [grades](https://github.com/sic-lang/rfcs/pull/33) give.
A type then uses the variables of its arguments as many times as its body uses its parameters, each argument checked in the mode of its grade, as the application of a second-order variable uses its arguments:

```math
\frac{\Sigma;\ \delta_i \mathrel{▶_{m \odot \zeta_j(x_i)}} a_i \quad \text{for each parameter } x_i \text{ of } \Delta}{\Sigma;\ \textstyle\sum^{\mathsf{c}}_i \zeta_j(x_i) \cdot^{\mathsf{c}} \delta_i \mathrel{▶_m} T_j}\;(D^{+}_{\mathsf{m}})
```

The sum $`\sum^{\mathsf{c}}`$ adds the vectors of all the parameters, and is $`\mathbb{0}^{\mathsf{c}}`$ for a type without parameters; a second-order argument $`\bar x.\, B`$ is checked as the abstraction of its body, in the context extended by its telescope, whose variables it uses within their grades, as the [core](https://github.com/sic-lang/rfcs/pull/24) substitutes a second-order variable.
A parameter that no field type uses is not used by the type, and the grades $`q`$ of a declaration are checked once, for each instantiation of its grade variables.

#### Constructors

A term of a data type is built by one of its constructors from a term for each of its fields, whose type takes the terms of the fields before it.
The constructor $`D_j.c_{ji}`$ carries the instance, written $`T_j.c_{ji}(t_1,\ \dots,\ t_{k_{ji}})`$, so that the type of the term is determined by the term; the term $`t_l`$ uses the variables as many times as the grade of its field, checked in the mode of this grade, and the instance uses none:

```math
\frac{\Sigma;\ \Gamma \vdash T_j \quad 1 \le i \le n_j \quad \Sigma;\ \Gamma \vdash \bar t : \Theta_{ji}[\bar a_{\mathsf{u}}][\bar a_{\mathsf{nu}} / \bar x_{\mathsf{nu}}]}{\Sigma;\ \Gamma \vdash T_j.c_{ji}(\bar t) : T_j}\;(D^{+}_{\mathsf{i}})
\qquad
\frac{\Sigma;\ \gamma_l \mathrel{▶_{m \odot p_{jil}}} t_l \quad \text{for each } l}{\Sigma;\ p_{ji1} \cdot^{\mathsf{c}} \gamma_1 +^{\mathsf{c}} \dots +^{\mathsf{c}} p_{jik_{ji}} \cdot^{\mathsf{c}} \gamma_{k_{ji}} \mathrel{▶_m} T_j.c_{ji}(t_1,\ \dots,\ t_{k_{ji}})}\;(D^{+}_{\mathsf{i}\mathsf{m}})
```

Equality is also a congruence for the instances, their constructors and their recursors, with the premises of their rules.

#### Recursor

A term of a data type is eliminated by the recursor, the only elimination of the data types: a branch for each constructor of each type of the block, in the order of the declaration, which receives the fields $`\bar x_{ji}`$ of its constructor as variables, and a recursive result $`y_{jil}`$ for each recursive field $`x_{jil}`$, the recursion on this field, whose type is the lifting of the motives through the type of the field.
The result type is a motive $`C_j`$ for each type of the block, which may depend on the non-uniform arguments and on the term, bound to the variable $`z`$, as the motives of the recursor of [Lean](https://lean-lang.org/doc/reference/latest/The-Type-System/Inductive-Types/#recursors) depend on the indices and on the major premise; the recursion on a field whose non-uniform arguments differ instantiates its motive with them.
The recursor carries the grade $`r`$ with which it uses the term, and the sort $`\kappa_C`$ of the motives is restricted for the propositions:

```math
\begin{aligned}
& \mathsf{rec}_r\ t\ \mathsf{return}\ D_1 \mapsto (\bar x_{\mathsf{nu}},\ z : T_1[\bar x_{\mathsf{nu}}]).\, C_1,\ \dots,\ D_k \mapsto (\bar x_{\mathsf{nu}},\ z : T_k[\bar x_{\mathsf{nu}}]).\, C_k \\
& \quad \mathsf{with}\ D_1.c_{11}(\bar x_{11};\ \bar y_{11}) \Rightarrow u_{11} \mid \dots \mid D_k.c_{kn_k}(\bar x_{kn_k};\ \bar y_{kn_k}) \Rightarrow u_{kn_k}
\end{aligned}
```

In the rules, $`\mathsf{rec}_r\ t\ \mathsf{return}\ \bar C\ \mathsf{with}\ \bar u`$ abbreviates this term; for a block of one type, the names $`D_j \mapsto`$ and the qualifications $`D_j.`$ are omitted, and so are the non-uniform variables when the type has no non-uniform parameter, and the recursive results, with their semicolon, when the type is not recursive.
The recursive results $`\bar y_{ji}`$ form the telescope $`\Theta^{\bar C}_{ji}`$ of the liftings of the motives at the recursive fields, in the order of the fields, whose grades the usage gives:

```math
\Theta^{\bar C}_{ji} \;=\; (y_{jil_1} : \mathsf{lift}_{A_{jil_1}}[\bar C](x_{jil_1}),\ \dots,\ y_{jil_m} : \mathsf{lift}_{A_{jil_m}}[\bar C](x_{jil_m})) \quad \text{for the recursive fields } l_1 < \dots < l_m \text{ of } c_{ji}
```

```math
\frac{\begin{gathered}{}\Sigma;\ \Gamma,\ \Delta_{\mathsf{nu}}[\bar a_{\mathsf{u}}],\ z : T_j[\bar x_{\mathsf{nu}}] \vdash C_j : \kappa_C \quad \text{for each } j \quad \Sigma;\ \Gamma \vdash t : T_h \\ \Sigma;\ \Gamma,\ \Delta_{\mathsf{nu}}[\bar a_{\mathsf{u}}],\ \Theta_{ji}[\bar a_{\mathsf{u}}],\ \Theta^{\bar C}_{ji} \vdash u_{ji} : C_j[T_j[\bar x_{\mathsf{nu}}].c_{ji}(\bar x_{ji})/z] \quad \text{for each } j, i \\ \kappa_C = \Omega_{l_C} \text{ if } \kappa = \Omega_l \text{ and } (n_j \ge 2 \text{ for some } j \text{ or } \mathcal{D} \text{ is recursive}) \quad \kappa_C \in \{U_{l_C}, \Omega_{l_C}\} \text{ otherwise}\end{gathered}}{\Sigma;\ \Gamma \vdash \mathsf{rec}_r\ t\ \mathsf{return}\ \bar C\ \mathsf{with}\ \bar u : C_h[\bar a_{\mathsf{nu}} / \bar x_{\mathsf{nu}},\ t/z]}\;(D^{+}_{\mathsf{rec}})
```

A data type without constructors is eliminated with no branch, for any result: no term of it is ever built.
A proof of a data type in a universe of propositions is eliminated for any result when its block has at most one constructor per type and is not recursive, and for a proposition only otherwise: since irrelevance equates the proofs built by two different constructors, a recursor returning other terms would equate the terms of their branches, and a recursor on a recursive proof would unfold a proof that never computes, as [Abel and Coquand](https://doi.org/10.23638/LMCS-16(2:14)2020) show of the accessibility predicates in an irrelevant sort.
With no constructor, there is no branch to choose, and with one constructor of a type that is not recursive, the rule $`(D^{+}_\eta)`$ below makes the recursor equal to its branch with the fields of the proof, which need not compute.

The term is used $`r`$ times, and the motives are checked in the mode $`\mathbb{0}\mathbb{0}^{\mathsf{m}}`$, so that they use no variable; the non-uniform variables of a branch are used with $`\mathbb{0}`$, since they come from the instance that the constructor carries, which exists only in types.
Each branch uses a field $`x_{jil}`$ with a grade $`g_{jil}`$ and a recursive result $`y_{jil}`$ with a grade $`q_{jil}`$, which the branch states, and the grade of the field times $`r`$ must allow them: a field that is not recursive is used as the grade of a match allows, and a recursive field is also used through its recursive result, each use of which runs the recursion, which uses the field with $`r`$ again, at every position of the field with the grade $`\pi`$ of the position.
All the branches share the same vector $`\delta`$ for the variables of the context, since only one of them runs, and the recursion as a whole uses them with $`\chi`$, which bounds the uses of every unfolding: the branch that runs, and the branches that its recursive results run, each result $`q`$ times, at every position:

```math
\frac{\begin{gathered}{}\Sigma;\ \mathbb{0}^{\mathsf{c}} \mathrel{▶_{\mathbb{0}\mathbb{0}^{\mathsf{m}}}} C_j \quad \text{for each } j \quad \Sigma;\ \gamma \mathrel{▶_{m \odot r}} t \\ \Sigma;\ \delta \bullet \mathbb{0} \cdots \bullet \mathbb{0} \bullet g_{ji1} \bullet \dots \bullet g_{jik_{ji}} \bullet q_{jil_1} \bullet \dots \bullet q_{jil_m} \mathrel{▶_m} u_{ji} \quad \text{for each } j, i \\ \ulcorner m \urcorner \cdot r \cdot p_{jil} \le g_{jil} \quad \text{for each } j, i \text{ and each field } l \text{ that is not recursive} \\ \ulcorner m \urcorner \cdot r \cdot p_{jil} \cdot \pi \le (g_{jil} + q_{jil} \cdot r) \cdot \pi \quad \text{for each } j, i, \text{ each recursive field } l \text{ and each } \pi \in \Pi(A_{jil}) \\ \chi \le^{\mathsf{c}} \delta +^{\mathsf{c}} \textstyle\sum_{l,\ \pi \in \Pi(A_{jil})} q_{jil} \cdot \pi \cdot^{\mathsf{c}} \chi \quad \text{for each } j, i, \text{ the sum over the recursive fields } l \\ \llcorner r \lrcorner = \mathbb{1}\mathbb{1}^{\mathsf{m}} \text{ if } m = \mathbb{1}\mathbb{1}^{\mathsf{m}} \text{ and } n_j \ge 2 \text{ for some } j\end{gathered}}{\Sigma;\ r \cdot^{\mathsf{c}} \gamma +^{\mathsf{c}} \chi \mathrel{▶_m} \mathsf{rec}_r\ t\ \mathsf{return}\ \bar C\ \mathsf{with}\ \bar u}\;(D^{+}_{\mathsf{rec}\mathsf{m}})
```

The vector $`\delta`$ has a grade for each variable of $`\Gamma`$, followed by $`\mathbb{0}`$ for each non-uniform variable; a field that a branch does not use is discarded, which its grade must allow, so that a branch never loses a linear field.
The constraints on $`\chi`$ have a greatest solution whenever the block has a finite shape, a term built by its constructors, which the [properties](#properties) state: it is the meet, over all the finite shapes of the term, of the uses of the branches that run on that shape, the rule of [Eriksson, Abel and Danielsson](https://doi.org/10.1145/3828677) for the natural numbers generalized to every block; a block without finite shape has no closed term, and its constraints still allow $`\langle \omega, \omega \rangle`$.
For a type that is not recursive, $`\chi`$ is $`\delta`$, and the rule is that of a match.

The condition on $`r`$ forbids, in a term that runs, the recursion on a term without use at run time only when a type of the block has two constructors or more, since the branch to run depends on the constructor, which is absent at run time.
With one constructor and no recursion, there is no branch to choose, and the body uses the fields only in erased positions, since $`r \cdot p_{jil}`$ has no use at run time when $`r`$ has none; the rule $`(D^{+}_\eta)`$ makes the recursor of a neutral term equal to its branch, so that it is never blocked, while the [counterexamples of ADE](https://github.com/graded-type-theory/graded-type-theory/blob/master/Graded/Erasure/Consequences/Soundness.agda) to the soundness of erasure for the erased matches of their pairs and units need types without $`\eta`$.
With no constructor, there is no branch at all, and no closed term of the type exists, so that a closed program never reaches the recursor; ADE allow it with their option `Emptyrec-allowed`, under which they prove the soundness of erasure for the programs that run under consistent hypotheses only.
A proof of an empty proposition, which never exists at run time, thus eliminates the impossible cases of a program that runs.

Eliminating a term that has just been built runs the branch of its constructor, with the terms of its fields substituted for the variables, and the recursion on each recursive field, mapped through the type of the field, for its recursive result:

```math
\frac{\begin{gathered}{}\Sigma;\ \Gamma \vdash \mathsf{rec}_r\ T_h[\bar b].c_{hi}(\bar t)\ \mathsf{return}\ \bar C\ \mathsf{with}\ \bar u : C_h[\bar b / \bar x_{\mathsf{nu}},\ T_h[\bar b].c_{hi}(\bar t)/z] \\ v_l = \mathsf{map}_{A_{hil}}[\bar C,\ \bar f](t_l) \quad \text{for each recursive field } l \quad f_j = \bar x_{\mathsf{nu}}.\, z.\, \mathsf{rec}_r\ z\ \mathsf{return}\ \bar C\ \mathsf{with}\ \bar u \quad \text{for each } j\end{gathered}}{\Sigma;\ \Gamma \vdash \mathsf{rec}_r\ T_h[\bar b].c_{hi}(\bar t)\ \mathsf{return}\ \bar C\ \mathsf{with}\ \bar u \equiv u_{hi}[\bar b / \bar x_{\mathsf{nu}},\ \bar t / \bar x_{hi},\ \bar v / \bar y_{hi}] : C_h[\bar b / \bar x_{\mathsf{nu}},\ T_h[\bar b].c_{hi}(\bar t)/z]}\;(D^{+}_{\mathsf{rec}\beta})
```

For a direct recursive field, the map is the recursor itself applied to the field, by $`(\mathsf{map}_D)`$; for a nested one, the derived map of the nesting type applies it at every position.

#### Extensionality of Data

A data type whose block has one constructor and is not recursive has an extensionality rule: a term that mentions a term $`t`$ of the type is equal to the recursor on $`t`$ whose single branch mentions the constructor applied to the fields, so that the recursor of a neutral term is never stuck, and two terms with equal fields are equal.
The rule is stated for any term $`e`$ that depends on $`z`$, without a projection, and for any grade $`r`$, since equality carries no grade:

```math
\frac{\begin{gathered}{}\Sigma;\ \Gamma,\ z : T \vdash e : C \quad \Sigma;\ \Gamma \vdash t : T \quad n_1 = 1 \quad k = 1 \quad \mathcal{D} \text{ is not recursive}\end{gathered}}{\Sigma;\ \Gamma \vdash e[t/z] \equiv \mathsf{rec}_r\ t\ \mathsf{return}\ (z : T).\, C\ \mathsf{with}\ c_1(\bar x_1) \Rightarrow e[T.c_1(\bar x_1)/z] : C[t/z]}\;(D^{+}_\eta)
```

With $`e = z`$, it makes every term equal to the constructor of its fields, taken by the recursor; with $`(D^{+}_{\mathsf{rec}\beta})`$ and congruence, every recursor on the type is equal to its branch, so that none is neutral.
Since equality carries no grade, the two sides may use their variables differently; the usage of each is checked on its own.

The types with no constructor, with two or more, or in a recursive block have no $`\eta`$ rule, so that their recursor on a neutral term stays neutral; the criterion is that two terms are compared by $`\eta`$ exactly when the comparison ends without guessing anything, as the [rationale](#rationale-and-alternatives) explains.
[Agda](https://agda.readthedocs.io/en/latest/language/record-types.html), [Lean](https://lean-lang.org/doc/reference/latest/The-Type-System/Inductive-Types/#structures) and [Rocq](https://rocq-prover.org/doc/master/refman/language/core/records.html) likewise give $`\eta`$ only to their records and structures, which have a single constructor and no recursion.

### Codata Types

A codata type is known by its destructors: each of its terms is observed by one of them, applied to terms for its arguments, and is built by the corecursor, which gives the result of each observation from a state, and observes itself again at its recursive positions from a new state.
In the rules of this section, $`\mathcal{D}`$ is a block of codata types, written as in the [formation](#formation), of which $`T_j`$ is an instance of each type $`D_j`$, all with the same arguments $`\bar a`$.
The arguments of the destructor $`d_{ji}`$ are written as the telescope $`\Theta_{ji}[\bar a_{\mathsf{u}}] = (x_{ji1} :^{q_{ji1}}_{p_{ji1}} A_{ji1},\ \dots,\ x_{jik_{ji}} :^{q_{jik_{ji}}}_{p_{jik_{ji}}} A_{jik_{ji}})`$, and its result as $`B_{ji}[\bar a_{\mathsf{u}}]`$; a destructor is recursive when its result has positions.
The destructors before $`d_{ji}`$ stay second-order variables of these types, as the [formation](#formation) checks them, and $`[t.\bar d]`$ instantiates each $`d_{ji'}`$ with the abstraction $`\bar x_{ji'}.\, t.d_{ji'}(\bar x_{ji'})`$ of the observation of a term $`t`$ by $`d_{ji'}`$.

#### Usage of Codata Types

The body of a codata type uses the variables of each destructor as many times as the destructor is used, and the uses of all the destructors added, since the type mentions all of them.
A destructor is counted as a single entry whose type gathers its arguments and its result: they are checked in the mode of its grade, each argument type in the mode of the grade of its argument within it, and their uses, each argument type counted as many times as its argument is used, are multiplied by the grade of the destructor, as its branch is in a corecursor.
The grade $`q_{jil}`$ of each argument allows its uses in the types of the arguments after it and in the result, counted before this multiplication, and the grade $`q_{ji}`$ of each destructor its uses in the types of the destructors after it; a recursive occurrence uses the parameters as the type does, as for the data types, and the usage $`\zeta`$ of the block is the greatest solution of:

```math
\begin{aligned}
& \exists (\gamma_{jil})_{j, i, l}, (\beta_{ji})_{j, i}, (\varepsilon_{ji})_{j, i}.\ (\forall j, i, l.\ \Sigma,\ \mathcal{D};\ \gamma_{jil} \mathrel{▶_{(\mathbb{1}\mathbb{1}^{\mathsf{m}} \odot p_{ji}) \odot p_{jil}}} A_{jil}),\ (\forall j, i.\ \Sigma,\ \mathcal{D};\ \beta_{ji} \mathrel{▶_{\mathbb{1}\mathbb{1}^{\mathsf{m}} \odot p_{ji}}} B_{ji}), &&(\zeta^{-}) \\
& \quad (\forall j, i.\ \varepsilon_{ji} \bullet \ulcorner \llcorner p_{ji} \lrcorner \urcorner \cdot q_{ji1} \bullet \dots \bullet \ulcorner \llcorner p_{ji} \lrcorner \urcorner \cdot q_{jik_{ji}} \le^{\mathsf{c}} p_{ji1} \cdot^{\mathsf{c}} \gamma_{ji1} +^{\mathsf{c}} \dots +^{\mathsf{c}} p_{jik_{ji}} \cdot^{\mathsf{c}} \gamma_{jik_{ji}} +^{\mathsf{c}} \beta_{ji}) \\
& \quad \text{and } (\forall j.\ \zeta_j \bullet q_{j1} \bullet \dots \bullet q_{jn_j} \le^{\mathsf{c}} p_{j1} \cdot^{\mathsf{c}} \varepsilon_{j1} +^{\mathsf{c}} \dots +^{\mathsf{c}} p_{jn_j} \cdot^{\mathsf{c}} \varepsilon_{jn_j}) \\
& \text{where an occurrence } T_{j'}[\bar b] \text{ in a type uses the variables as } \zeta_{j'} \text{ says of its arguments}
\end{aligned}
```

The vector $`\gamma_{jil}`$ has a grade for each parameter, each destructor before $`d_{ji}`$ and each argument before $`x_{jil}`$, and $`\beta_{ji}`$ for each parameter, each destructor before $`d_{ji}`$ and each argument of $`d_{ji}`$; both are extended by $`\mathbb{0}`$ for the arguments from $`x_{jil}`$ on, and $`\varepsilon_{ji}`$, which has a grade for each parameter and each destructor before $`d_{ji}`$, by $`\mathbb{0}`$ for the destructors from $`d_{ji}`$ on.
An instance then uses the variables of its arguments as the rule $`(D^{+}_{\mathsf{m}})`$ says, with the vectors $`\zeta_j`$ of the block, which is the rule $`(D^{-}_{\mathsf{m}})`$.

#### Destructors

A term of a codata type is observed by one of its destructors applied to terms $`\bar b = (b_1,\ \dots,\ b_{k_{ji}})`$ for its arguments, written after the term, $`t.d_{ji}(\bar b)`$, as [Agda](https://agda.readthedocs.io/en/latest/language/record-types.html) writes its projections in postfix; the term determines its type, which names the destructor, so that the observation carries no instance.
The types of the arguments and of the result take the observations of $`t`$ by the destructors before $`d_{ji}`$, and a destructor without arguments is written without parentheses:

```math
\frac{\Sigma;\ \Gamma \vdash t : T_j \quad 1 \le i \le n_j \quad \Sigma;\ \Gamma \vdash \bar b : \Theta_{ji}[\bar a_{\mathsf{u}}][\bar a_{\mathsf{nu}} / \bar x_{\mathsf{nu}}][t.\bar d]}{\Sigma;\ \Gamma \vdash t.d_{ji}(\bar b) : B_{ji}[\bar a_{\mathsf{u}}][\bar a_{\mathsf{nu}} / \bar x_{\mathsf{nu}}][t.\bar d][\bar b / \Theta_{ji}]}\;(D^{-}_\pi)
```

An observation uses the term once and gets the result once, which the grade of the destructor must allow, and uses each argument as many times as its grade, checked in the mode of this grade:

```math
\frac{\Sigma;\ \gamma \mathrel{▶_m} t \quad \Sigma;\ \delta_l \mathrel{▶_{m \odot p_{jil}}} b_l \quad \text{for each } l \quad \ulcorner m \urcorner \cdot p_{ji} \le \ulcorner m \urcorner}{\Sigma;\ \gamma +^{\mathsf{c}} p_{ji1} \cdot^{\mathsf{c}} \delta_1 +^{\mathsf{c}} \dots +^{\mathsf{c}} p_{jik_{ji}} \cdot^{\mathsf{c}} \delta_{k_{ji}} \mathrel{▶_m} t.d_{ji}(b_1,\ \dots,\ b_{k_{ji}})}\;(D^{-}_{\pi\mathsf{m}})
```

A result without use at run time, such as a proof, is thus observed only in an erased term: in the mode $`\mathbb{1}\mathbb{1}^{\mathsf{m}}`$, the condition is $`p_{ji} \le \mathbb{1}`$, which fails when the run-time multiplicity of $`p_{ji}`$ is $`0`$, since $`0`$ and $`1`$ are not comparable.
Equality is also a congruence for the observations and the corecursors, with the premises of their rules.

#### Corecursor

A term of a codata type is built by the corecursor, the only introduction of the codata types, as the primitive corecursion of [Basold and Geuvers](https://doi.org/10.1145/2933575.2934514) builds a term from a state: a branch for each destructor of each type of the block, in the order of the declaration, which receives the state as the variables $`\bar w`$ and the arguments $`\bar x_{ji}`$ of its destructor, and gives the result of the observation.
The state of each type of the block is a telescope $`S_j`$, which may depend on the non-uniform parameters, so that a recursion whose parameters vary moves between the states of a family, as the motives of a recursor do; its entries carry the grade with which a new state uses them, and their grades $`q`$, which are all $`\mathbb{0}`$ since the types of a state use its variables in erased positions only, are not written.
A term built by the corecursor at the state $`\bar s`$ is observed by running the branch of the destructor, in which every position of a type of the block holds either a new state, which the corecursor observes again, or a term already built:

```math
\begin{aligned}
& \mathsf{corec}_r\ \bar s\ \mathsf{return}\ D_1 \mapsto (\bar x_{\mathsf{nu}}).\, S_1,\ \dots,\ D_k \mapsto (\bar x_{\mathsf{nu}}).\, S_k\ \mathsf{as}\ \bar w \\
& \quad \mathsf{with}\ D_1.d_{11}(\bar x_{11}) \Rightarrow u_{11} \mid \dots \mid D_k.d_{kn_k}(\bar x_{kn_k}) \Rightarrow u_{kn_k}
\end{aligned}
```

In the rules, $`\mathsf{corec}_r\ \bar s\ \mathsf{return}\ \bar S\ \mathsf{as}\ \bar w\ \mathsf{with}\ \bar u`$ abbreviates this term, with the omissions of the recursor for a block of one type, and the state $`S_j`$ is written $`(w_{j1} :_{r_{j1}} A_{j1},\ w_{j2} :_{r_{j2}} A_{j2},\ \dots)`$; a corecursor whose state is the empty telescope, as every corecursor of a type that is not recursive, is written $`\mathsf{corec}\ T\ \mathsf{with}\ \bar u`$, with the instance it builds.
At a position of $`T_{j}[\bar b]`$, a branch gives a term of the type $`S_j[\bar b] \oplus T_j[\bar b]`$, the type of positions of the [prelude](#prelude), whose grade variable is the grade $`r`$ of the corecursor, written over the telescope $`S_j[\bar b]`$ packed at the least sort in which it lives, $`\Omega_l`$ when its types are all propositions and $`U_l`$ otherwise, at the join $`l`$ of their levels; $`\mathsf{next}\ \bar e`$ and $`\mathsf{done}\ t`$ are its constructors, whose instance the position determines.
The type of positions lives in the join of the sorts of the state and of the type, so that a branch of a codata type in a universe of propositions is a proof only when its state is a telescope of propositions, whose data the non-uniform parameters carry.
The type $`B^\oplus`$ replaces each position of $`B`$ by this type, through the nesting types by their parameters, as the lifting goes through them:

```math
\begin{aligned}
(T_j[\bar b])^\oplus &= S_j[\bar b] \oplus T_j[\bar b] &&(\oplus_D) \\
(D'\ \bar b)^\oplus &= D'\ \bar b[\bar x_X.\, G_X^\oplus / \bar x_X.\, G_X \text{ for each } X] &&(\oplus_{D'})
\end{aligned}
```

Each state is a telescope in some sort $`\kappa_j`$, as the [core](https://github.com/sic-lang/rfcs/pull/24) forms a telescope, so that each of its types is well formed and its proofs carry erased grades; the branch of a destructor is typed at every state, for the variables $`\bar w`$, and the earlier destructors in its types are the observations of the corecursor itself at this state, written $`c_{\bar w}`$:

```math
\frac{\begin{gathered}{}\Sigma;\ \Gamma,\ \Delta_{\mathsf{nu}}[\bar a_{\mathsf{u}}] \vdash S_j : \kappa_j \quad \text{for each } j \quad \Sigma;\ \Gamma \vdash \bar s : S_h[\bar a_{\mathsf{nu}} / \bar x_{\mathsf{nu}}] \\ \Sigma;\ \Gamma,\ \Delta_{\mathsf{nu}}[\bar a_{\mathsf{u}}],\ \bar w : S_j,\ \Theta_{ji}[\bar a_{\mathsf{u}}][c_{\bar w}.\bar d] \vdash u_{ji} : (B_{ji}[\bar a_{\mathsf{u}}][c_{\bar w}.\bar d])^\oplus \quad \text{for each } j, i \\ c_{\bar w} = \mathsf{corec}_r\ \bar w\ \mathsf{return}\ \bar S\ \mathsf{as}\ \bar w\ \mathsf{with}\ \bar u \text{ at the arguments } \bar x_{\mathsf{nu}}\end{gathered}}{\Sigma;\ \Gamma \vdash \mathsf{corec}_r\ \bar s\ \mathsf{return}\ \bar S\ \mathsf{as}\ \bar w\ \mathsf{with}\ \bar u : T_h}\;(D^{-}_{\mathsf{i}})
```

A codata type without destructors is built with no branch, from any state; a proof of a codata type in a universe of propositions is built by a corecursor whose branches are proofs, and a recursive proof unfolds as far as it is observed, which the irrelevance of its observations allows, since a proof never computes.

Since the user of the term observes it by one destructor at each use, the term needs the resources of each branch, but not of all of them together: its uses are bounded by the uses of each branch, counted with the grade of its destructor, and by the uses of the state, each entry counted $`r`$ times its grade.
Each branch is checked in the mode of its destructor, uses each argument with its grade, and uses each entry $`l`$ of the state with a grade $`g_{jil}`$ that it states, which the grade of the destructor must give back $`r`$ times the grade of the entry, since every observation that reaches the state runs the branch from it:

```math
\frac{\begin{gathered}{}\Sigma;\ \gamma_l \mathrel{▶_{m \odot r \odot r_{hl}}} s_l \quad \text{for each } l \quad \Sigma;\ \gamma_{ji} \bullet \mathbb{0} \cdots \bullet \mathbb{0} \bullet \bar g_{ji} \bullet \ulcorner m \odot p_{ji} \urcorner \cdot p_{ji1} \bullet \dots \bullet \ulcorner m \odot p_{ji} \urcorner \cdot p_{jik_{ji}} \mathrel{▶_{m \odot p_{ji}}} u_{ji} \quad \text{for each } j, i \\ \ulcorner m \urcorner \cdot r \cdot r_{jl} \le p_{ji} \cdot g_{jil} \quad \text{for each } j, i, l \quad \chi \le^{\mathsf{c}} p_{ji} \cdot^{\mathsf{c}} \gamma_{ji} \quad \text{for each } j, i \quad \chi \le^{\mathsf{c}} \ulcorner m \urcorner \cdot^{\mathsf{c}} \chi\end{gathered}}{\Sigma;\ r \cdot^{\mathsf{c}} \textstyle\sum^{\mathsf{c}}_l r_{hl} \cdot^{\mathsf{c}} \gamma_l +^{\mathsf{c}} \chi \mathrel{▶_m} \mathsf{corec}_r\ \bar s\ \mathsf{return}\ \bar S\ \mathsf{as}\ \bar w\ \mathsf{with}\ \bar u}\;(D^{-}_{\mathsf{i}\mathsf{m}})
```

The vector $`\gamma_{ji}`$ has a grade for each variable of $`\Gamma`$, followed by $`\mathbb{0}`$ for each non-uniform variable, and $`\bar g_{ji}`$ is the vector of the grades $`g_{jil}`$ of the entries of the state; a new state $`\mathsf{next}\ \bar e`$ uses each $`e_l`$ with $`r \cdot r_{jl}`$, by the rules $`(D^{+}_{\mathsf{i}\mathsf{m}})`$ of its constructor and of the pairs that pack it, so that the uses of the state by the branches that the new state runs are counted, and a choice between $`\mathsf{next}`$ and $`\mathsf{done}`$ that depends on a term is a recursor on it, whose branches share their uses.
For a type with destructors, the greatest $`\chi`$ is the meet $`p_{j1} \cdot^{\mathsf{c}} \gamma_{j1} \wedge^{\mathsf{c}} \dots \wedge^{\mathsf{c}} p_{jn_j} \cdot^{\mathsf{c}} \gamma_{jn_j}`$ over all the branches, so that a variable used once by every branch is used once by the term.
For a type without destructors, the bounds are vacuous, and the term may use any resources, which it never gives back; the last premise keeps the erased uses of a term checked in an erased mode erased.

Observing a term that has just been built runs the branch of its destructor, with the state and the arguments substituted for its variables, and continues at every position: a new state becomes the corecursor at this state, and a term already built stays, which the recursor of the data type of positions does, mapped through the nesting types:

```math
\frac{\begin{gathered}{}\Sigma;\ \Gamma \vdash \mathsf{corec}_r\ \bar s\ \mathsf{return}\ \bar S\ \mathsf{as}\ \bar w\ \mathsf{with}\ \bar u : T_h \quad \Sigma;\ \Gamma \vdash \bar b : \Theta_{hi}[\bar a_{\mathsf{u}}][\bar a_{\mathsf{nu}} / \bar x_{\mathsf{nu}}][c_{\bar s}.\bar d] \\ \lfloor v \rfloor_{T_j[\bar b']} = \mathsf{rec}_{\mathbb{1}}\ v\ \mathsf{return}\ (z : S_j[\bar b'] \oplus T_j[\bar b']).\, T_j[\bar b']\ \mathsf{with}\ \mathsf{next}(\bar e) \Rightarrow c_{\bar e} \mid \mathsf{done}(t) \Rightarrow t \quad \text{with } c_{\bar e} \text{ at the arguments } \bar b' \\ \lfloor v \rfloor_{D'\ \bar b'} = \mathsf{map}_{D'}[\bar x_X.\, v'.\, \lfloor v' \rfloor_{G_X} \text{ for each } X](\bar b',\ v)\end{gathered}}{\Sigma;\ \Gamma \vdash (\mathsf{corec}_r\ \bar s\ \mathsf{return}\ \bar S\ \mathsf{as}\ \bar w\ \mathsf{with}\ \bar u).d_{hi}(\bar b) \equiv \lfloor u_{hi}[\bar a_{\mathsf{nu}} / \bar x_{\mathsf{nu}},\ \bar s / \bar w,\ \bar b / \bar x_{hi}] \rfloor_{B_{hi}[\bar a_{\mathsf{u}}][\bar a_{\mathsf{nu}} / \bar x_{\mathsf{nu}}][c_{\bar s}.\bar d]} : B_{hi}[\bar a_{\mathsf{u}}][\bar a_{\mathsf{nu}} / \bar x_{\mathsf{nu}}][c_{\bar s}.\bar d][\bar b / \Theta_{hi}]}\;(D^{-}_{\pi\beta})
```

Here $`\mathsf{map}_{D'}`$ is the map of $`D'`$ without a predicate, the functorial map that applies a function at every position, derived as $`(\mathsf{map}^{+})`$ and $`(\mathsf{map}^{-})`$ with the type of the result in place of the lifting; the observation of a stream built by the corecursor thus gives back the term put at its tail, as it was.

#### Extensionality of Codata

A codata type whose block is not recursive has an extensionality rule: two terms are equal when all their observations are, on the variables of their arguments, which compares them without guessing anything, since each observation is local:

```math
\frac{\begin{gathered}{}\Sigma;\ \Gamma \vdash t : T_j \quad \Sigma;\ \Gamma \vdash u : T_j \quad \mathcal{D} \text{ is not recursive} \\ \Sigma;\ \Gamma,\ \Theta_{ji}[\bar a_{\mathsf{u}}][\bar a_{\mathsf{nu}} / \bar x_{\mathsf{nu}}][t.\bar d] \vdash t.d_{ji}(\bar x_{ji}) \equiv u.d_{ji}(\bar x_{ji}) : B_{ji}[\bar a_{\mathsf{u}}][\bar a_{\mathsf{nu}} / \bar x_{\mathsf{nu}}][t.\bar d] \quad \text{for each } i\end{gathered}}{\Sigma;\ \Gamma \vdash t \equiv u : T_j}\;(D^{-}_\eta)
```

With $`(D^{-}_{\pi\beta})`$, it makes every term of such a type equal to the corecursor of its observations, and all the terms of a type without destructors equal.
A recursive codata type has no $`\eta`$ rule, since comparing two streams by their observations never ends; the [observational equality](https://github.com/sic-lang/rfcs/pull/35) gives it back as a proposition, the bisimilarity, and [Agda](https://agda.readthedocs.io/en/latest/language/record-types.html) likewise withholds $`\eta`$ from its coinductive records.
Since equality carries no grade, the two sides may use their variables differently; the usage of each is checked on its own.

### Conversion

The head normal forms of the data types are the terms built by their constructors, and those of the codata types the corecursors; a recursor whose term is neutral, and an observation of a neutral term, are neutral.
The reduction of the terms of both kinds is deterministic: a recursor reduces its term to a head normal form, then runs the branch of its constructor by $`(D^{+}_{\mathsf{rec}\beta})`$, and an observation reduces its term to a head normal form, then runs the branch of its destructor by $`(D^{-}_{\pi\beta})`$, which the [conversion](https://github.com/sic-lang/rfcs/pull/24) of the core uses as its computations.
The equality of two terms is then decided at their type: at a data type with one constructor and no recursion, and at a codata type without recursion, the comparison goes through $`\eta`$, by the recursor on each side for the data and by the observations for the codata; at every other type, two head normal forms are compared by their heads, and two neutral terms by their structure.
Comparing two neutral recursors through $`(D^{+}_\eta)`$ needs no projection: a term of a type with one constructor is compared by the recursors that return each of its fields, which an implementation of the conversion does without a rule of its own.

### Erasure

The erasures $`t^\bullet`$ and $`t^\circ`$ of the [core](https://github.com/sic-lang/rfcs/pull/24) extend to the terms of both kinds, which keep their structure in the target language: the fields, arguments and states that an erased position holds become $`\text{↯}`$, and the motives, the state types and the instances disappear.
A position is erased when its grade has no use at run time for $`t^\bullet`$, and no use at all for $`t^\circ`$, as the core says; the table writes the erasure of a position as $`\lfloor t \rfloor`$, which is $`t^\bullet`$ or $`\text{↯}`$ accordingly:

| Term | Erasure |
| --- | --- |
| $`T_j.c_{ji}(t_1,\ \dots,\ t_{k})`$ | $`c_{ji}(\lfloor t_1 \rfloor,\ \dots,\ \lfloor t_{k} \rfloor)`$, the field $`l`$ at the grade $`p_{jil}`$ |
| $`\mathsf{rec}_r\ t\ \mathsf{return}\ \bar C\ \mathsf{with}\ \bar u`$ | $`\mathsf{rec}\ \lfloor t \rfloor\ \mathsf{with}\ \dots \mid c_{ji}(\bar x_{ji};\ \bar y_{ji}) \Rightarrow u_{ji}^\bullet \mid \dots`$, the term at the grade $`r`$ |
| $`t.d_{ji}(b_1,\ \dots,\ b_{k})`$ | $`t^\bullet.d_{ji}(\lfloor b_1 \rfloor,\ \dots,\ \lfloor b_{k} \rfloor)`$, the argument $`l`$ at the grade $`p_{jil}`$ |
| $`\mathsf{corec}_r\ \bar s\ \mathsf{return}\ \bar S\ \mathsf{as}\ \bar w\ \mathsf{with}\ \bar u`$ | $`\mathsf{corec}\ \lfloor \bar s \rfloor\ \mathsf{as}\ \bar w\ \mathsf{with}\ \dots \mid d_{ji}(\bar x_{ji}) \Rightarrow u_{ji}^\bullet \mid \dots`$, the entry $`l`$ of the state at the grade $`r \cdot r_{hl}`$ |

A branch of a recursor whose term is erased, which the rules allow in a term that runs only for a block with one constructor per type and no recursion, receives $`\text{↯}`$ for its fields, which the branch uses in erased positions only; the branches of an erased corecursor are never run.
The target reduces by the same computations as the terms: a recursor on a constructor runs its branch, with the recursion on the fields kept at run time, and an observation of a corecursor runs its branch and continues at its positions, so that the erasure is sound for the computation of the type theory, as the [core](https://github.com/sic-lang/rfcs/pull/24) states; a branch of a corecursor runs only when its destructor is observed, which gives the codata types their laziness without an evaluation order.

### Meaning

The data and codata types complete the [meaning](https://github.com/sic-lang/rfcs/pull/24) of the judgments with the meaning of their declarations and the canonical terms of their instances: a data type is the least fixed point of the sum, over its constructors, of the dependent products of its fields, and a codata type the greatest fixed point of the product, over its destructors, of the dependent functions of their arguments, whose terms are equal when they are bisimilar.
For a closed instance $`T_j`$ of a type of a block of the signature, $`\kappa[T_j]`$ is its sort, $`\Theta_{ji}[T_j]`$ the telescopes of its fields or of its arguments, and $`B_{ji}[T_j]`$ the results of its destructors, in which the sorts, levels, grades and arguments of $`T_j`$ are substituted; the meaning ignores the grades, as the core does for the telescopes.

#### Meaning of the Declarations

A block is meaningful when each of its instantiations is, which gives its variables sorts, natural numbers and grades, as the [levels](https://github.com/sic-lang/rfcs/pull/24) of a judgment are given numbers: its parameters form a meaningful context, and the fields of each constructor, or the arguments and the result of each destructor, live in its sort for every pair of equal arguments, as the rules $`(\mathsf{data})`$ and $`(\mathsf{codata})`$ check, in the signature extended by the block, whose instances the clauses below interpret:

```math
\begin{aligned}
\text{if } \mathcal{D} \text{ is a block of data types, then } \Sigma \vDash \mathcal{D} \iff {}& \Sigma \vDash \Delta \text{ and } \forall (\sigma_1, \sigma_2) \in \mathsf{eq}(\Delta).\ \forall j, i. &&({\vDash}_{\mathsf{data}}) \\
& \quad \Sigma,\ \mathcal{D} \vDash \Theta_{ji}[\sigma_1] \equiv \Theta_{ji}[\sigma_2] : \kappa \\
\text{if } \mathcal{D} \text{ is a block of codata types, then } \Sigma \vDash \mathcal{D} \iff {}& \Sigma \vDash \Delta \text{ and } \forall (\sigma_1, \sigma_2) \in \mathsf{eq}(\Delta).\ \forall j. &&({\vDash}_{\mathsf{codata}}) \\
& \quad \Sigma,\ \mathcal{D} \vDash \Xi_j[\sigma_1] \equiv \Xi_j[\sigma_2] : \kappa
\end{aligned}
```

Here $`\Xi_j = d_{j1} : (\Theta_{j1} \vdash B_{j1}),\ \dots,\ d_{jn_j} : (\Theta_{jn_j} \vdash B_{jn_j})`$ is the context of the destructors of $`D_j`$, second-order variables each of which stands for the results of its destructor on its arguments, and two closed contexts of destructors are equal in a sort $`s_l`$ when the arguments of their first destructors are equal telescopes in $`U_l`$, their results equal in $`s_l`$, as telescopes of one entry, for every pair of equal arguments, and the rest of them equal for every pair of equal abstractions of the first destructor, which $`(\mathsf{eq}_X)`$ relates:

```math
\begin{aligned}
\Sigma \vDash \varepsilon \equiv \varepsilon : s_l \iff {}& \vDash \Sigma &&({\vDash}\mathsf{dtor}_{\kappa\varepsilon}) \\
\Sigma \vDash (d : (\Theta_1 \vdash B_1),\ \Xi_1) \equiv (d : (\Theta_2 \vdash B_2),\ \Xi_2) : s_l \iff {}& \Sigma \vDash \Theta_1 \equiv \Theta_2 : U_l, &&({\vDash}\mathsf{dtor}_{\kappa,}) \\
& \forall (\tau_1, \tau_2) \in \mathsf{eq}(\Theta_1). \\
& \quad \Sigma \vDash (d : B_1[\tau_1]) \equiv (d : B_2[\tau_2]) : s_l, \text{ and} \\
& \forall (\bar x.\, u_1,\ \bar x.\, u_2) \in \mathsf{eq}(d : (\Theta_1 \vdash B_1)). \\
& \quad \Sigma \vDash \Xi_1[\bar x.\, u_1 / d] \equiv \Xi_2[\bar x.\, u_2 / d] : s_l
\end{aligned}
```

The meaning of a recursive block is circular, since its bodies mention its instances: the clauses below define the relations of all the instances of the block together, as a least fixed point for the data types and a greatest one for the codata types, so that the circle is well founded, which the positivity ensures.

#### Meaning of the Data Types

The canonical terms of an instance $`T_j`$ in a universe are built by its constructors, and two of them are equal when they are built by the same constructor from equal terms for its fields, which a telescope relates as the substitutions of the context it forms; the fields are not computed, since a term in constructor form is canonical, and the instances $`T_1`$ and $`T_2`$ that the constructors carry are any instances of $`D_j`$ with the non-uniform arguments of $`T_j`$, since they only determine the type of the term.
In the clauses, $`T_j`$ is a closed instance of a type $`D_j`$ of a block $`\mathcal{D}`$ of the signature, which the kind named by the clause fixes, and $`T_j[\bar b]`$ ranges over the instances of the types of the block with the sorts, levels, grades and uniform arguments of $`T_j`$.
The family of the relations $`\mathsf{eq}(T_j[\bar b])`$, over all the types of the block and all their non-uniform arguments, is the least family that satisfies the clause, so that every term is built in finitely many steps, and the truth of a proposition declared as a data type is the least truth that its constructors give, a proposition being true when one of its constructors has terms for its fields:

```math
\begin{aligned}
\mathsf{eq}(T_j) &= \{(T_1.c_{ji}(\bar t),\ T_2.c_{ji}(\bar u)) \mid T_1, T_2 \text{ instances of } D_j \text{ with the non-uniform arguments of } T_j,\ 1 \le i \le n_j,\ (\bar t,\ \bar u) \in \mathsf{eq}(\Theta_{ji}[T_j])\} &&\text{if } \kappa[T_j] \text{ is a universe} &&(\mathsf{eq}_{\mathsf{con}}) \\
\mathsf{true}(T_j) &\iff \exists i.\ \mathsf{eq}(\Theta_{ji}[T_j]) \ne \varnothing &&\text{if } \kappa[T_j] \text{ is a universe of propositions} &&(\mathsf{true}_{\mathsf{data}}) \\
(\mathsf{eq}(T_j[\bar b]))_{j, \bar b} &\text{ and } (\mathsf{true}(T_j[\bar b]))_{j, \bar b} \text{ are the least families such that } (\mathsf{eq}_{\mathsf{con}}) \text{ and } (\mathsf{true}_{\mathsf{data}}) \text{ hold} &&&&(\mathsf{eq}_\mu)
\end{aligned}
```

The instances in a universe are canonical types of it, and two of them are equal when they are instances of the same type in the same sort, whose fields are equal telescopes; the instances in a universe of propositions are propositions of it, whose fields are telescopes in it, and the [core](https://github.com/sic-lang/rfcs/pull/24) relates two propositions by their truth:

```math
\begin{aligned}
(T_1,\ T_2) \in \mathsf{eq}(U_n) &\quad \text{if } T_1 \text{ and } T_2 \text{ are closed instances of a data type } D_j \text{ of } \Sigma,\ \kappa[T_1] = \kappa[T_2] = U_n, &&(\mathsf{eq}_{\mathsf{data}}) \\
&\quad \text{and } \forall i.\ \Sigma \vDash \Theta_{ji}[T_1] \equiv \Theta_{ji}[T_2] : U_n \\
T \in \mathsf{wf}(\Omega_n) &\quad \text{if } T \text{ is a closed instance of a data type } D_j \text{ of } \Sigma,\ \kappa[T] = \Omega_n, &&(\mathsf{wf}_{\mathsf{data}}) \\
&\quad \text{and } \forall i.\ \Sigma \vDash \Theta_{ji}[T] \equiv \Theta_{ji}[T] : \Omega_n
\end{aligned}
```

The clauses relate the types of the fields in the sorts that the sort of the instance bounds, as the [core](https://github.com/sic-lang/rfcs/pull/24) defines $`\mathsf{eq}(U_n)`$ and $`\mathsf{wf}(\Omega_n)`$ together.
A recursor computes its term to a constructor, then runs its branch, with the recursion on the fields, as the rule $`(D^{+}_{\mathsf{rec}\beta})`$ says, which ends since every canonical term is built in finitely many steps; a recursor on a proof for a proposition is a proof, which need not compute, and a recursor on a proof of a type with one constructor and no recursion for any result is equal to its branch by $`(D^{+}_\eta)`$, so that it never waits for the proof to compute.
The rules $`(\mathsf{data})`$, $`(D^{+}_{\mathsf{i}})`$, $`(D^{+}_{\mathsf{rec}})`$, $`(D^{+}_{\mathsf{rec}\beta})`$ and $`(D^{+}_\eta)`$ are then sound.

#### Meaning of the Codata Types

The canonical terms of an instance $`T_j`$ in a universe are its corecursors, and two of them are equal when they are bisimilar: every observation of the one, by a destructor applied to arguments, is equal to the observation of the other by the same destructor applied to equal arguments, at the type of the result, in which the positions of the block are related by the same relations; the family of the relations $`\mathsf{eq}(T_j[\bar b])`$ is the greatest family that satisfies the clause, so that two streams are equal when all their elements are, however far.
The clause is named after the corecursor, the canonical form it compares; for a block that is not recursive, the greatest family is the only one, and the clause compares the branches of two corecursors as abstractions of the destructors, which $`\Xi_j[T_j]`$ relates.
A proposition declared as a codata type is true when its destructors have proofs of their results for all their arguments, which the greatest family gives even when the proofs unfold forever:

```math
\begin{aligned}
\text{if } \kappa[T_j] \text{ is a universe, then } (v,\ w) \in \mathsf{eq}(T_j) \iff {}& v \text{ and } w \text{ are corecursors of instances of } D_j, \text{ and } \forall i. &&(\mathsf{eq}_{\mathsf{corec}}) \\
& \forall (\bar b_1,\ \bar b_2) \in \mathsf{eq}(\Theta_{ji}[T_j][v.\bar d]). \\
& \quad \Sigma \vDash v.d_{ji}(\bar b_1) \equiv w.d_{ji}(\bar b_2) : B_{ji}[T_j][v.\bar d][\bar b_1 / \Theta_{ji}] \\
\text{if } \kappa[T_j] \text{ is a universe of propositions, then } \mathsf{true}(T_j) \iff {}& \mathsf{eq}(\Xi_j[T_j]) \ne \varnothing &&(\mathsf{true}_{\mathsf{codata}}) \\
(\mathsf{eq}(T_j[\bar b]))_{j, \bar b} &\text{ and } (\mathsf{true}(T_j[\bar b]))_{j, \bar b} \text{ are the greatest families such that } (\mathsf{eq}_{\mathsf{corec}}) \text{ and } (\mathsf{true}_{\mathsf{codata}}) \text{ hold} &&(\mathsf{eq}_\nu)
\end{aligned}
```

The instances in a universe are canonical types of it, and two of them are equal when they are instances of the same type in the same sort, whose destructors are equal; the instances in a universe of propositions are propositions of it, whose destructors are in it:

```math
\begin{aligned}
(T_1,\ T_2) \in \mathsf{eq}(U_n) &\quad \text{if } T_1 \text{ and } T_2 \text{ are closed instances of a codata type } D_j \text{ of } \Sigma,\ \kappa[T_1] = \kappa[T_2] = U_n, &&(\mathsf{eq}_{\mathsf{codata}}) \\
&\quad \text{and } \Sigma \vDash \Xi_j[T_1] \equiv \Xi_j[T_2] : U_n \\
T \in \mathsf{wf}(\Omega_n) &\quad \text{if } T \text{ is a closed instance of a codata type } D_j \text{ of } \Sigma,\ \kappa[T] = \Omega_n, &&(\mathsf{wf}_{\mathsf{codata}}) \\
&\quad \text{and } \Sigma \vDash \Xi_j[T] \equiv \Xi_j[T] : \Omega_n
\end{aligned}
```

An observation computes its term to a corecursor, then runs the branch of its destructor and continues at its positions, as the rule $`(D^{-}_{\pi\beta})`$ says; the observation of a proof is a proof, which need not compute, since the results of a proposition are propositions.
The rules $`(\mathsf{codata})`$, $`(D^{-}_{\mathsf{i}})`$, $`(D^{-}_\pi)`$, $`(D^{-}_{\pi\beta})`$ and $`(D^{-}_\eta)`$ are then sound; the rule $`(D^{-}_\eta)`$ is so for any number of destructors, since the clause $`(\mathsf{eq}_{\mathsf{corec}})`$ compares two corecursors by their observations, and would be so for the recursive types too, where the rules withhold it for the decidability of the conversion.

#### Fidelity

The rules are sound for this meaning, but not complete, and the meaning is not decidable; the [core](https://github.com/sic-lang/rfcs/pull/24) states the soundness and leaves the witnesses to this RFC, since they need terms that compute.
The formulas below take as a premise the hypothesis $`(\mathsf{hyp}_\iota)`$ of the core, which interprets the constants of the signature, since a signature without it may have no meaning.
A term that computes to a term of a type without reaching an ill-typed part is a term of the type in this meaning, but not by the rules: for an instance $`T`$ of a data type with two constructors without fields, a closed term $`t`$ of a closed type $`B`$ and a closed term $`g`$ that no rule types, the recursor on the first constructor computes to $`t`$ without reaching $`g`$:

```math
\begin{aligned}
& (\mathsf{hyp}_\iota),\ T \text{ is a closed instance of a data type of } \Sigma \text{ with two constructors without fields,} &&(\mathsf{incomplete}_{\mathsf{typ}}) \\
& \quad \Sigma;\ \varepsilon \vdash t : B,\ g \text{ is closed, and } \forall \Gamma, C.\ \Sigma;\ \Gamma \nvdash g : C \\
\implies {}& \Sigma \vDash \mathsf{rec}_r\ T.c_1()\ \mathsf{return}\ (z : T).\, B\ \mathsf{with}\ c_1 \Rightarrow t \mid c_2 \Rightarrow g : B \text{ and} \\
& \Sigma;\ \varepsilon \nvdash \mathsf{rec}_r\ T.c_1()\ \mathsf{return}\ (z : T).\, B\ \mathsf{with}\ c_1 \Rightarrow t \mid c_2 \Rightarrow g : B
\end{aligned}
```

The truth of a judgment is not decidable, since it asks whether a computation ends: in a signature that declares a codata type with one destructor whose argument is a type parameter and whose result is a second-order parameter applied to the argument, the type of functions, the corecursors and the observations contain the untyped λ-calculus, in which a term applied to $`U_0`$ may compute to $`U_0`$ or never end, so that whether a closed term is a term of $`U_1`$ in this meaning is not decidable:

```math
\begin{aligned}
& (\mathsf{hyp}_\iota),\ \vdash \Sigma \text{ and } \Sigma \text{ declares a codata type with one destructor, whose argument is a type parameter and whose result is a second-order parameter applied to it} &&(\mathsf{undecidable}_\vDash) \\
\implies {}& \{t \mid \Sigma \vDash t : U_1\} \text{ is not decidable}
\end{aligned}
```

The meaning ignores the grades, which no clause reads, as well as the levels and the arguments that neither the sort nor the bodies use: two instances of a type whose sorts are equal, and whose telescopes of fields, or contexts of destructors, are equal once all their grades are erased, written $`|\Theta|`$ and $`|\Xi|`$, are equal types in this meaning, but not by the rule $`(D_\equiv)`$ of the core when their grades or their levels differ:

```math
\begin{aligned}
& (\mathsf{hyp}_\iota),\ T_1 \text{ and } T_2 \text{ are instances of a data type } D_j \text{ of } \Sigma,\ \Sigma;\ \varepsilon \vdash T_1 \text{ and } \Sigma;\ \varepsilon \vdash T_2, &&(\mathsf{incomplete}^{+}_{D\equiv}) \\
& \kappa[T_1] = \kappa[T_2] \text{ and } \forall i.\ |\Theta_{ji}[T_1]| = |\Theta_{ji}[T_2]| \\
\implies {}& \Sigma \vDash T_1 \equiv T_2 \text{ and} \\
& \Sigma;\ \varepsilon \nvdash T_1 \equiv T_2 \text{ if their grades or their levels differ} \\
& (\mathsf{hyp}_\iota),\ T_1 \text{ and } T_2 \text{ are instances of a codata type } D_j \text{ of } \Sigma,\ \Sigma;\ \varepsilon \vdash T_1 \text{ and } \Sigma;\ \varepsilon \vdash T_2, &&(\mathsf{incomplete}^{-}_{D\equiv}) \\
& \kappa[T_1] = \kappa[T_2] \text{ and } |\Xi_j[T_1]| = |\Xi_j[T_2]| \\
\implies {}& \Sigma \vDash T_1 \equiv T_2 \text{ and} \\
& \Sigma;\ \varepsilon \nvdash T_1 \equiv T_2 \text{ if their grades or their levels differ}
\end{aligned}
```

The meaning validates $`\eta`$ for every type: a closed term of a data type in a universe computes to one of its constructors, so that it is equal to its rebuilding by the recursor, and a closed term of a codata type is equal to the corecursor of its observations, which the clause $`(\mathsf{eq}_{\mathsf{corec}})`$ compares observation by observation; a proof is equal to both by irrelevance.
The rebuilding of an instance $`T`$ of a data type, which uses no recursive result, and the unfolding of an instance of a codata type, whose state is the term itself, are:

```math
\begin{aligned}
\mathsf{rebuild}_T(t) = {}& \mathsf{rec}_{\mathbb{1}}\ t\ \mathsf{return}\ (\bar x_{\mathsf{nu}},\ z : T[\bar x_{\mathsf{nu}}]).\, T[\bar x_{\mathsf{nu}}]\ \mathsf{with}\ c_1(\bar x_1;\ \bar y_1) \Rightarrow T[\bar x_{\mathsf{nu}}].c_1(\bar x_1) \mid \dots \\
\mathsf{unfold}_T(t) = {}& \mathsf{corec}_{\mathbb{1}}\ t\ \mathsf{return}\ (\bar x_{\mathsf{nu}}).\, (w :_{\mathbb{1}} T[\bar x_{\mathsf{nu}}])\ \mathsf{as}\ w\ \mathsf{with}\ .d_1(\bar x_1) \Rightarrow \lceil w.d_1(\bar x_1) \rceil \mid \dots
\end{aligned}
```

In $`\mathsf{unfold}_T`$, $`\lceil \cdot \rceil`$ puts $`\mathsf{done}`$ at every position, so that the unfolding observes the term itself; the rebuilding of a block rebuilds each type of the block with its constructors.

```math
\begin{aligned}
& (\mathsf{hyp}_\iota),\ \Sigma;\ \Gamma \vdash t : T \text{ and } T \text{ is an instance of a data type} &&(\mathsf{valid}^{+}_\eta) \\
\implies {}& \Sigma;\ \Gamma \vDash t \equiv \mathsf{rebuild}_T(t) : T \\
& (\mathsf{hyp}_\iota),\ \Sigma;\ \Gamma \vdash t : T \text{ and } T \text{ is an instance of a codata type} &&(\mathsf{valid}^{-}_\eta) \\
\implies {}& \Sigma;\ \Gamma \vDash t \equiv \mathsf{unfold}_T(t) : T
\end{aligned}
```

The types that have no $`\eta`$ rule lack it for the decidability of the conversion, not because the meaning refutes it: for an instance in a universe of a data type with two constructors or more, or of a recursive block, and for an instance in a universe of a recursive codata type, a variable of the type and its rebuilding, or its unfolding, are equal under every closed substitution, so that they are equal in this meaning, but not by the rules:

```math
\begin{aligned}
& (\mathsf{hyp}_\iota),\ T \text{ is an instance of a type of a block } \mathcal{D} \text{ of data types of } \Sigma,\ \Sigma;\ \varepsilon \vdash T,\ \kappa[T] \text{ is a universe, and } ((\exists j.\ n_j \ge 2) \text{ or } \mathcal{D} \text{ is recursive}) &&(\mathsf{incomplete}^{+}_\eta) \\
\implies {}& \Sigma;\ y : T \vDash y \equiv \mathsf{rebuild}_T(y) : T \text{ and } \Sigma;\ y : T \nvdash y \equiv \mathsf{rebuild}_T(y) : T \\
& (\mathsf{hyp}_\iota),\ T \text{ is an instance of a type of a block } \mathcal{D} \text{ of codata types of } \Sigma,\ \Sigma;\ \varepsilon \vdash T,\ \kappa[T] \text{ is a universe, and } \mathcal{D} \text{ is recursive} &&(\mathsf{incomplete}^{-}_\eta) \\
\implies {}& \Sigma;\ y : T \vDash y \equiv \mathsf{unfold}_T(y) : T \text{ and } \Sigma;\ y : T \nvdash y \equiv \mathsf{unfold}_T(y) : T
\end{aligned}
```

### Properties

The properties below are theorems about the two kinds, each a named formula, which the [core](https://github.com/sic-lang/rfcs/pull/24) requires of every kind as its obligations, and which the formalization has to prove; the first ones discharge the contract, and the last one is the guarantee that the absorbing types give to the programs.

#### Obligations of the Contract

Each rule of both kinds is sound for the meaning above, the computations keep the usage, and the rules of usage project on the two modes of ADE:

```math
\begin{aligned}
& \text{the rules } (\mathsf{data}),\ (D^{+}_{\mathsf{m}}),\ (D^{+}_{\mathsf{i}}),\ (D^{+}_{\mathsf{rec}}),\ (D^{+}_{\mathsf{rec}\beta}) \text{ and } (D^{+}_\eta) \text{ are sound} &&(\mathsf{sound}_{\mathsf{data}}) \\
& \text{the rules } (\mathsf{codata}),\ (D^{-}_{\mathsf{m}}),\ (D^{-}_{\mathsf{i}}),\ (D^{-}_\pi),\ (D^{-}_{\pi\beta}) \text{ and } (D^{-}_\eta) \text{ are sound} &&(\mathsf{sound}_{\mathsf{codata}}) \\
& \Sigma;\ \gamma \mathrel{▶_m} t \text{ and } t \longrightarrow u \text{ by } (D^{+}_{\mathsf{rec}\beta}) \text{ or } (D^{-}_{\pi\beta}) \implies \Sigma;\ \gamma \mathrel{▶_m} u &&(\mathsf{usage}^{\pm}_\beta) \\
& \text{the rules } (D^{\pm}_{\mathsf{m}}),\ (D^{+}_{\mathsf{i}\mathsf{m}}),\ (D^{+}_{\mathsf{rec}\mathsf{m}}),\ (D^{-}_{\pi\mathsf{m}}) \text{ and } (D^{-}_{\mathsf{i}\mathsf{m}}) \text{ project on the two modes of ADE} &&(\mathsf{project}^{\pm})
\end{aligned}
```

The preservation of usage by the computations is the condition under which the usage of the recursor and of the corecursor were designed: the constraints of $`(D^{+}_{\mathsf{rec}\mathsf{m}})`$ on the fields and on $`\chi`$, and those of $`(D^{-}_{\mathsf{i}\mathsf{m}})`$ on the state, are exactly what the rules $`\beta`$ need to keep the usage of a term through every unfolding.

#### Usage of Recursion

The constraints of $`(D^{+}_{\mathsf{rec}\mathsf{m}})`$ on $`\chi`$ have a greatest solution whenever the block has a finite shape, which is the meet, over the finite shapes, of the uses of the branches that run on each shape: the usage of the recursor is then the best grade for the uses of all its unfoldings, in the [meaning](https://github.com/sic-lang/rfcs/pull/33) of the grades, and it is superadditive in the branches and commutes with the multiplication by a grade, by the properties $`(\bigwedge_{+})`$ and $`(\bigwedge_{\cdot})`$ of the grades:

```math
\begin{aligned}
& \mathcal{D} \text{ has a finite shape} \implies \text{the constraints on } \chi \text{ have a greatest solution,} &&(\mathsf{rec}_{\bigwedge}) \\
& \quad \text{the meet over the finite shapes of the uses of the branches that run on each shape}
\end{aligned}
```

The usage of the state of the corecursor is likewise the best grade for the uses of the state by all the paths of observations, since every path runs a branch from the state it reaches.

#### Absorbing Types

A codata type without destructors absorbs any resources, which its terms never give back, as the $`\top`$ of linear logic: within the language, it is the only way a program abandons a resource, since a term that holds a resource with a linear grade is consumed by exactly one elimination, which the term of such a type does not have.
The other way is a constant of the signature that consumes the resource without using it at run time, which the author of the type provides, and whose grade $`\langle 0, 1 \rangle`$ on the resource shows it, as the operation that forgets a resource in the annex on [explicit affinity](0034-data-and-codata-types/explicit-affinity.md).
A resource abandoned in such a term is visible in the type of the program: the term cannot be dropped, since its grade would multiply the grade of the resource, nor passed to a function that uses it any number of times, so that it reaches the result of the program, where its type shows an instance of a codata type without destructors, unless a type computed from a term hides it in a branch that the normal form of the result type does not unfold.
A program whose result type, in normal form, mentions no instance of a codata type without destructors, and no type computed from a term, thus abandons no resource within the language, apart from those that its constants consume: there is a derivation of its usage in which every term of such a type uses no variable at run time, so that the absorbing types absorb nothing:

```math
\begin{aligned}
& \Sigma;\ \varepsilon \vdash t : A,\ \Sigma;\ \mathbb{0}^{\mathsf{c}} \mathrel{▶_{\mathbb{1}\mathbb{1}^{\mathsf{m}}}} t, \text{ and the normal form of } A \text{ holds neither an instance} &&(\top) \\
& \quad \text{of a codata type without destructors nor a neutral term of a sort} \\
\implies {}& \text{there is a derivation of } \Sigma;\ \mathbb{0}^{\mathsf{c}} \mathrel{▶_{\mathbb{1}\mathbb{1}^{\mathsf{m}}}} t \text{ in which every subterm whose type is an instance of a} \\
& \quad \text{codata type without destructors, at a position checked in } \mathbb{1}\mathbb{1}^{\mathsf{m}}, \text{ has a usage whose} \\
& \quad \text{run-time multiplicities are all } 0
\end{aligned}
```

A library that lets a resource be abandoned thus shows it in its types, as a function from a socket to the absorbing type, and the entry point of a program, whose type the runtime fixes, abandons nothing that its type does not show.
The weakness of the property is its condition on the computed types: a type family $`F`$ with $`F\ \mathsf{true} \equiv \top`$ hides the absorbing type from the normal form of every type $`F\ b`$ computed on a variable $`b`$, in the result type and in the type of any subterm, which the [unresolved questions](#unresolved-questions) keep.

### Examples

The examples of this RFC are its annexes: the files of the directory that bears the name of this file, one file per example.
Each annex derives its formulas from the rules of this RFC, of which they are not part.

## Drawbacks

- The recursor and the corecursor are the only recursion, so that every recursive function of the surface language is compiled to them, as the equations of Lean are compiled to its recursors; a function that recurses on a measure goes through an accessibility predicate, a data type in a universe with the grade $`\mathbb{0}`$, which computes for the checker and disappears at run time.
- The branches of a recursor and of a corecursor are written for every constructor or destructor of the block, in order, and carry their recursive results and their states; they are meant to be checked, not written by hand.
- Nested recursion, through the parameters of the types declared before, needs the liftings and the maps, derived for every declaration; their definition is the price of positivity through parameters.
- The recursive types have no $`\eta`$ rule, so that two streams are never equal by their observations, and a tree is not equal to the tree rebuilt from its subtrees, until the [observational equality](https://github.com/sic-lang/rfcs/pull/35) relates them as propositions.
- The usage of the recursor is a system of constraints, whose greatest solution the checker computes; the usage of a term is thus no longer read from its rule alone, as [Eriksson, Abel and Danielsson](https://doi.org/10.1145/3828677) note of their greatest lower bounds.
- The absorbing types let a program abandon a resource, which its type then shows; the property that states it has a condition on the computed types, which its proof has yet to confirm.
- The prelude adds three declarations that every signature holds for the rules alone, which the surface language has to hide.

## Rationale and Alternatives

- The data types are eliminated by a recursor rather than by fixed points with a check of termination: a fixed point is a second mechanism, whose guard condition is syntactic, fragile under the extensionality of propositions, as [Dénès](https://sympa.inria.fr/sympa/arc/coq-club/2013-12/msg00119.html) found Coq's guard condition inconsistent with propositional extensionality, which the observational equality gives; the recursor is one mechanism, the match without recursion being its instance, and the surface language compiles its recursive functions to it, as Lean does, at no cost at run time, since the compiler compiles the source functions.
  Sized types, which make termination a matter of types, were set aside for the same reason: a second mechanism, with annotations on every type.
- The codata types are introduced by a corecursor rather than by cofixed points with a check of productivity: a cofixed point with a dependent match breaks subject reduction in Coq, as [Abel, Pientka, Thibodeau and Setzer](https://doi.org/10.1145/2429069.2429075) recall, and Rocq now recommends its negative coinductive types; the corecursor is primitive, as in the type theory of [Basold and Geuvers](https://doi.org/10.1145/2933575.2934514), and the copatterns of the surface language compile to it.
  The positions of the corecursor hold either a new state or a term already built, so that the tail of a stream put there is given back as it was, which a coiteration alone would only give up to bisimilarity.
- The positivity goes through the parameters of the types declared before, as in Lean and Rocq, rather than through direct occurrences only: the functions are a codata type whose codomain is a strictly positive parameter, so that a tree whose children are given by a function needs the positivity through parameters, as every nested type does.
  Non-strict positivity is excluded, since it makes the theory inconsistent with an impredicative sort, as [Coquand and Paulin](https://doi.org/10.1007/3-540-52335-9_47) show, and gives no type that the strictly positive ones do not give.
  The polarity is computed conservatively: an occurrence of a parameter in a non-uniform argument of a recursive occurrence, in a term, in the arguments of a second-order variable, or with two negative steps on the way is mixed by caution, and a finer analysis may accept these cases later without invalidating any accepted block, since the blocks declared after one rely only on the parameters it declares strictly positive.
- The recursive results of the nested fields have the type of a lifting of the motive, derived for each declaration, rather than the translation of a nested type into a mutual block, as the kernel of Lean does: a mutual block is homogeneous here, while the nesting mostly mixes the polarities, since the functions are a codata type; the liftings follow the unary parametricity translation of [Bernardy, Jansson and Paterson](https://doi.org/10.1145/1863543.1863592), which the [Coq-Elpi](https://doi.org/10.4230/LIPIcs.ITP.2019.29) library of Tassi derives for the inductive types of Coq.
  Giving no recursive result to the nested fields, as the recursors that Rocq generates do, would lose the recursion through lists and functions.
- The pair and the unit that pack a telescope are declarations of a prelude, fixed once, rather than derived declarations declared where they are needed: a derived declaration is generative, so that two packings of one telescope would be two types unless a rule identified them, and the type of positions already needs a place in the signature before the first corecursor; the prelude holds the three together, declared once as every other type.
- Each field of the pair of the prelude, and of its type of positions, has a sort variable of its own, in a type whose sort is the join of the two, rather than one sort for the declaration: the cast of a codata term of the [observational equality](https://github.com/sic-lang/rfcs/pull/35) keeps as its state a term of a universe next to a proof, a codata type in a universe whose states are proofs only packs them in a universe of propositions, which a type of positions of one sort could not receive, since the hierarchies are not cumulative, and a lifting into a universe needs a unit in a universe, which the unit of the sort of the telescope gives.
- The surface language never names the prelude, since the prelude exists for the type system: its declarations are an implementation detail, which may change with the rules, while a name of the surface language is a commitment to its users; the positions of a corecursor are written with keywords, which elaborate to the type of positions, and the states of several components and the recursive results of the nested fields with constructs of the surface language.
- The blocks are homogeneous, and a type inductive in some positions and coinductive in others is declared by nesting, rather than by a mixed block, as Agda allows: the nesting makes the order of the fixed points explicit, which a mixed block leaves to a convention.
- The non-uniform parameters are allowed, and computed, rather than forbidden or declared: an accessibility predicate recurses on another argument than its parameter, and a nested type on another element type, which the recursor handles by instantiating its motives, as the parameters after the bar of Rocq do; computing them spares a declaration that the body already shows.
- The usage of the recursor is the rule of [Eriksson, Abel and Danielsson](https://doi.org/10.1145/3828677) for the natural numbers, generalized to every block, and stated as constraints whose greatest solution is the meet over the shapes: the constraints are what the preservation of usage by the computations needs, and the meet is the best grade for the uses of all the unfoldings, in the meaning of the grades; the earlier rule of ADE for the natural numbers has a counterexample to linearity, which the meet avoids.
  The scrutinee is used with the grade that the recursor carries, as a match is, and each recursive field with the grade of the branch and of its recursive result, so that no annotation is added to the declarations.
- There is no projection in the kernel, neither of a field of a data type with one constructor nor of the results of a codata type at once: an operation for a special case is a second mechanism, and the recursor with a branch that returns a field does the same, with the same usage, the other fields being discarded as their grades allow.
  Borrowing the eliminator of the other polarity, a projection as a destructor of a data type and a match as a recursor of a codata type, was considered and rejected: the two conditions, one constructor and no arguments, are the price of an intuitionistic logic without co-implication, and the surface language gives the projections as sugar for the recursor.
- The $`\eta`$ rules are given exactly to the types at which the comparison of two terms ends without guessing anything: a data type with one constructor and no recursion, whose recursor on a neutral term is equal to its single branch, and a codata type without recursion, whose observations are finitely many and local.
  A data type with two constructors or more would need commuting conversions, which have no known decision procedure with dependent types, as [Scherer](https://doi.org/10.1145/3009837.3009901) shows for sums; a recursive type would compare two terms forever; and the guardedness criterion of Agda for its coinductive records was rejected, since Agda itself stopped inferring it.
  The $`\eta`$ rule of the data types is stated for any term that mentions the eliminated term, rather than by projections, so that it needs no second eliminator, and the conversion compares two neutral terms of such a type by the recursors that return their fields.
- The evaluation order stays outside the type system, as the [core](https://github.com/sic-lang/rfcs/pull/24) explains; the direction of the RFC of the calling convention is the call-by-push-value of [Levy](https://doi.org/10.1007/978-94-007-0954-6), by polarity: the data types are evaluated by value, their constructors building values, and the codata types on observation, their branches running when a destructor is applied, as [Downen, Sullivan, Ariola and Peyton Jones](https://doi.org/10.1007/978-3-030-17184-1_5) compile codata.
- The absorbing types stay, and absorb any resources, since the uses of a codata type are bounded by the uses of each of its branches, which no branch bounds when there is none; restricting them to no resources would make them a second unit type, and forbidding them would make the codata types the only ones that need a destructor.
  A rule that makes their grade $`\mathbb{0}`$ was rejected as a special case, and the property of the [absorbing types](#absorbing-types) states what their presence costs.
- Conscious exclusions, each with what is lost, what remains, and whether it can be added later:
  - Induction-recursion, in the sense of [Dybjer](https://doi.org/10.2307/2586554), where a data type and a function on it are defined together: the universes à la Tarski that need it are not needed, since the universes are built in, and a code for the types that does not depend on its decoding is a data type eliminated into a sort by the recursor; it would be a new kind of declaration, which the contract allows.
  - Induction-induction, in the sense of [Forsberg and Setzer](https://doi.org/10.1007/978-3-642-15205-4_35), where a data type and a family over it are declared together: the types of a block share their parameters, so that a family over another type of the block cannot be declared; an untyped syntax with a typing predicate in $`\Omega`$ remains, and a new kind of declaration could add it.
  - General recursion: every recursion is a recursor or a corecursor, so that the core is total; a partial computation is a codata type of delayed results, as the delay monad of [Capretta](https://doi.org/10.2168/LMCS-1(2:1)2005), whose observation unfolds it one step at a time, and the fixed points with a check of termination are excluded as a second mechanism.

## Prior Art

- The inductive types of [Coquand and Paulin](https://doi.org/10.1007/3-540-52335-9_47) and their [strict positivity](https://rocq-prover.org/doc/master/refman/language/core/inductive.html), the mutual and nested inductive types of [Lean](https://lean-lang.org/doc/reference/latest/The-Type-System/Inductive-Types/), whose kernel translates the nested types into mutual blocks, and the non-uniform parameters of Rocq.
- The codata types of [Abel, Pientka, Thibodeau and Setzer](https://doi.org/10.1145/2429069.2429075), defined by copatterns, and the coinductive records of [Agda](https://agda.readthedocs.io/en/latest/language/coinduction.html), which have no $`\eta`$; the codata of [Downen, Sullivan, Ariola and Peyton Jones](https://doi.org/10.1007/978-3-030-17184-1_5), compiled by their observations.
- The dependent type theory of [Basold and Geuvers](https://doi.org/10.1145/2933575.2934514), built from inductive and coinductive types with a primitive recursor and a primitive corecursor, and the polarity of [Zeilberger](https://noamz.org/thesis.pdf), which the two kinds follow.
- The usage of recursion of [Eriksson, Abel and Danielsson](https://doi.org/10.1145/3828677), the greatest lower bound over the unfoldings of a recursion on the natural numbers, which the usage of the recursor generalizes, and the natural numbers of [Abel, Danielsson and Eriksson](https://doi.org/10.1145/3607862) with their strong and weak pairs and units, which the examples recover.
- The unary parametricity translation of [Bernardy, Jansson and Paterson](https://doi.org/10.1145/1863543.1863592), after the predicate liftings of [Hermida and Jacobs](https://doi.org/10.1006/inco.1998.2725), which the liftings of the motives follow, and its derivation for the inductive types of Coq by [Tassi](https://doi.org/10.4230/LIPIcs.ITP.2019.29).
- The accessibility predicates in an irrelevant sort of [Felicissimo, Leray, Pujet, Tabareau, Tanter and Winterhalter](https://doi.org/10.4230/LIPIcs.LICS.2026.41), whose large elimination this RFC does without, since an accessibility predicate in a universe with the grade $`\mathbb{0}`$ computes for the checker and disappears at run time.
- The delay monad of [Capretta](https://doi.org/10.2168/LMCS-1(2:1)2005), as the codata type of the partial computations.

## Unresolved Questions

- Does the property of the [absorbing types](#absorbing-types) hold, with its condition on the computed types?
  It has to be proved on the rules of this RFC; if the proof fails, the fallback is to forbid the codata types without destructors in every sort, which makes every codata type need a destructor and removes the absorbing types, with the absorbing true proposition that absorbs erased resources.
- Can the condition of the property on the computed types be lifted, by looking inside the type families that a normal form does not unfold, in the result type and in the types of the subterms?
- Can the property be stated semantically, once the RFC of the calling convention gives the resources a meaning at run time, so that abandoning a resource is an event of the program that runs rather than a derivation of its usage?
