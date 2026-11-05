# RFC 0024: Graded Dependent Core

- Pull request: [sic-lang/rfcs#24](https://github.com/sic-lang/rfcs/pull/24)

## Summary

This RFC defines the graded dependent core of Sic: the framework in which every type of the language is declared.
It gives the judgments of typing, equality and usage, the signatures, in which types are declared, terms defined and constants assumed, a predicative hierarchy of universes with prenex universe polymorphism, a sort of strict propositions, the conversion, the erasure, and the properties expected of the whole.
The core names no concrete type: the types come from kinds of declarations, each of which fulfills a contract stated here, as the [data and codata types](https://github.com/sic-lang/rfcs/pull/34) and the [observational equality](https://github.com/sic-lang/rfcs/pull/35) do.
Its rules extend the graded dependent type theory of [Abel, Danielsson and Eriksson](https://doi.org/10.1145/3607862), whose metatheory is [formalized in Agda](https://github.com/graded-type-theory/graded-type-theory), with the [grades](https://github.com/sic-lang/rfcs/pull/33) of Sic.

## Motivation

Sic writes a program and its proofs in the [same language](https://github.com/sic-lang/rfcs/pull/13), which requires types that depend on values, and the [grades](https://github.com/sic-lang/rfcs/pull/16) decide how the core counts the uses of each variable.
A type theory with one mechanism for each need stays small when its types are not built in: the core fixes what every type shares, its declaration, its instances, its place in the sorts, its meaning, its conversion and its erasure, and each kind of declaration brings its own types by fulfilling a contract.
This RFC gives the rules of this framework, on which every later RFC of the core builds, and the properties that the whole has to keep whatever kinds of declarations are added.

## Proposal

The proposal first fixes the notation, the levels, which stratify the sorts, and the judgments of the core, with the signatures in which types are declared, terms defined and constants assumed.
It then states the contract that a kind of declaration fulfills, defines the universes and the strict propositions, the conversion and the erasure, gives the meaning of the judgments and of the sorts, and ends with the properties of the core.

### Notation

The rules of this RFC are those of the graded dependent type theory of [Abel, Danielsson and Eriksson](https://doi.org/10.1145/3607862) (ADE), whose types are replaced by declarations, and they use the notation of its formalization, except where the [correspondence](#correspondence-with-ade) below says otherwise.
This section introduces the conventions of all the rules of the core, which the RFCs of the kinds of declarations share; the symbols of a single construct are introduced with it.

#### Letters

Each letter keeps one kind and one rank, so that the rank of an object (scalar or vector) is read from its letter, as the type of an object tells its rank in Lean:

| Letters | Denote |
| --- | --- |
| $`x, y, z`$ | Variables, $`z`$ being the variable bound to the term that an elimination consumes |
| $`X`$ | Second-order variables, the [parameters](#parameters) that bind variables |
| $`t, u, a`$ | Terms, $`u`$ being a term compared to $`t`$ and $`a`$ a term substituted for a variable |
| $`v, w`$ | Canonical terms, in the [meaning](#meaning) |
| $`A, B, C`$ | Types, $`C`$ being the type of the result of an elimination |
| $`\kappa`$ | Sorts, the universes $`U_l`$ and the universes of [strict propositions](#strict-propositions) $`\Omega_l`$ |
| $`s`$ | Sort variables, which stand for $`U`$ or $`\Omega`$ |
| $`l`$ | [Levels](#levels) |
| $`\Gamma`$ | Contexts, sequences of declarations $`x : A`$ and $`X : (\Theta \vdash A)`$ |
| $`\Theta`$ | Telescopes, the entries of a declaration, whose variables an elimination binds |
| $`\Delta`$ | The parameters of a declaration |
| $`\Xi`$ | A context of second-order variables, in the RFCs of the kinds of declarations |
| $`\Sigma`$ | Signatures |
| $`\mathcal{D}`$ | Declarations, blocks of types declared together |
| $`D, T`$ | The name of a declared type, and an [instance](#instances) of it |
| $`c`$ | Constants, defined or assumed, and the constructors of the kinds of declarations |
| $`d`$ | The destructors of the kinds of declarations |
| $`p, q, r`$ | [Grades](https://github.com/sic-lang/rfcs/pull/33), $`r`$ being the grade of a term that an elimination consumes |
| $`\gamma, \delta`$ | Vectors of grades, one grade per variable of the context |
| $`m`$ | [Modes](https://github.com/sic-lang/rfcs/pull/33), in which a term is checked for its uses |
| $`\rho, \sigma, \tau`$ | Assignments of the level variables, and substitutions of the variables of a context or of a telescope |

A subscript numbers objects of the same kind that come from different premises or different parts of a context, as $`\gamma_1`$ and $`\gamma_2`$, or $`\Gamma_1`$ and $`\Gamma_2`$: an object alone of its kind has none, and several are all numbered; a subscript never selects a component.
A bar marks a sequence, as the arguments $`\bar a`$ of an instance or the variables $`\bar x`$ of a telescope.

The operations on grades are those of the [grades](https://github.com/sic-lang/rfcs/pull/33) of Sic, and the vectors of grades extend them to each component:

```math
p + q \qquad p \cdot q \qquad p \wedge q \qquad \gamma +^{\mathsf{c}} \delta \qquad p \cdot^{\mathsf{c}} \gamma \qquad \gamma \wedge^{\mathsf{c}} \delta \qquad \delta \le^{\mathsf{c}} \gamma
```

The operations marked with $`\mathsf{c}`$ act on each component of the vectors, the multiplication of a vector by a grade multiplying each of its components, and the order compares each component.
The zero vector, whose components are all the zero grade, has as many components as the context, whatever its length, and is written $`\mathbb{0}^{\mathsf{c}}`$.
A vector extended by a grade for a new variable is written $`\gamma \bullet p`$.
The vector $`\gamma`$ in which the grade of the variable $`x`$ is replaced by $`p`$ is written $`(\gamma, x \mathrel{≔} p)`$.

#### Conventions

The rules and the formulas of the core and of the kinds of declarations follow the same conventions:

- A rule is named after its fraction, in parentheses; the rules of usage are named after the rules of typing, with the index $`\mathsf{m}`$.
- A rule that extends a context, a telescope or a signature by one kind of entry is indexed by a comma, and a rule with one case per kind of entry by the letter of the entry: $`x`$ for a variable, $`X`$ for a second-order variable.
- The rules of a kind of declaration are named after the name $`D`$ of the declared type, with an exponent for its polarity when the kind has one, and an index that names the construct: $`\mathsf{i}`$ for an introduction, $`\pi`$ for an observation, $`\beta`$ for a computation and $`\eta`$ for an extensionality.
- In a rule, the conditional premises, written $`\dots \text{ if } \dots`$, come after the others, on a line of their own.
- A formula is named in its last column, as a rule is named after its fraction, and its name has a prefix that says what it states: $`\vDash`$ for the meaning of a judgment, named after the rule it interprets, $`\mathsf{eq}`$ and $`\mathsf{true}`$ for a clause of the equality or of the truth of a canonical type, $`\mathsf{sound}`$ for a soundness, $`\mathsf{incomplete}`$ for a non-completeness, $`\mathsf{exact}`$ for an exactness, $`\mathsf{undecidable}`$ for an undecidability, $`\mathsf{valid}`$ for a rule valid in the meaning but absent from the rules, and $`\mathsf{hyp}`$ for a hypothesis of a property.
- A variable left free in a formula is universally quantified, over the kind that its letter names, as a rule holds for every instance of the schematic variables of its fraction.
- A rule or a formula that the system does not define, but which is derived from its rules, is said so where it appears.

#### Correspondence With ADE

The rules use the notation of the formalization of ADE, which differs slightly from that of its paper, and depart from it only as follows:

| Formalization of ADE | This RFC |
| --- | --- |
| `var x0`, `var x1`, de Bruijn indices | $`x`$, $`y`$, named variables |
| `Γ ⊢ t ∷ A`, `Γ ⊢ t ≡ u ∷ A` | $`\Sigma;\ \Gamma \vdash t : A`$, $`\Sigma;\ \Gamma \vdash t \equiv u : A`$ |
| `Uⱼ`, `U-cong` | $`(U)`$, $`(U_\equiv)`$ |
| `univ` | $`(U_{\mathsf{type}})`$, $`(U_{\mathsf{type}\equiv})`$ |
| `γ ▸[ m ] t` | $`\Sigma;\ \gamma \mathrel{▶_m} t`$ |
| `Π`, `Σ`, `ℕ`, `Unit`, `Empty`, `Id` | Declared types, by the kinds of declarations |

The [grades](https://github.com/sic-lang/rfcs/pull/33) give the correspondence of the modality and of the modes.

### Levels

The sorts $`U_l`$ and $`\Omega_l`$ are indexed by levels, which stratify the [universes](#universes) and the universes of [strict propositions](#strict-propositions) into hierarchies.

#### Syntax of Levels

A level $`l`$ is $`0`$, a successor $`l + 1`$, the larger $`l_1 \sqcup l_2`$ of two levels, or a level variable.
Levels are not terms: they appear only as the subscripts of sorts, and use no variable of the context, unlike the levels of the formalization of ADE, which are terms of a type of levels since [Danielsson, Favier and Kubánek](https://doi.org/10.1145/3776645).

#### Equality and Order of Levels

Since a definition is checked once with its level variables and then used at any levels, two levels are equal when they are equal whatever natural numbers their variables take, and ordered when they are ordered whatever numbers their variables take.
An assignment $`\rho`$ gives a natural number to each level variable, and the value $`\rho(l)`$ of a level $`l`$ under $`\rho`$ follows its syntax:

```math
\begin{aligned}
\rho(0) &= 0 &&(\rho_0) \\
\rho(l + 1) &= \rho(l) + 1 &&(\rho_+) \\
\rho(l_1 \sqcup l_2) &= \max(\rho(l_1),\ \rho(l_2)) &&(\rho_\sqcup)
\end{aligned}
```

```math
\begin{aligned}
l_1 = l_2 &\iff \forall \rho.\ \rho(l_1) = \rho(l_2) &&(=_l) \\
l_1 \le l_2 &\iff \forall \rho.\ \rho(l_1) \le \rho(l_2) &&(\le_l)
\end{aligned}
```

These formulas define the equality and the order of levels by the values of the levels, which are thus their meaning: unlike the grades, levels need no meaning apart from their definition, which is exact for it by construction.
For level variables $`l_1`$ and $`l_2`$, $`l_1 \sqcup l_1`$ equals $`l_1`$, but $`l_1 \sqcup l_2`$ does not equal $`l_1`$, since they agree only when $`l_2 \le l_1`$.
The order is also $`l_1 \le l_2`$ exactly when $`l_1 \sqcup l_2 = l_2`$, and both are decidable, since they are formulas of [Presburger arithmetic](https://en.wikipedia.org/wiki/Presburger_arithmetic).

#### Level Variables

Level polymorphism is prenex, as in [Lean](https://lean-lang.org/doc/reference/latest/The-Type-System/Universes/): level variables are parameters of a [definition](#definitions), of a [constant](#constants) or of a [declaration](#declarations) only, instantiated with levels at each use, and the definition is checked once, with its level variables.
Within the rules, a level variable is a constant; no type quantifies over levels, so no universe beyond the hierarchies is needed, unlike the $`\mathsf{Set}\omega`$ of [Agda](https://agda.readthedocs.io/en/latest/language/universe-levels.html).

### Judgments

The core has the four judgments of Martin-Löf type theory, as [Nordström, Petersson and Smith](https://intuitionistic.wordpress.com/wp-content/uploads/2010/07/nordstrom-et-al-type-theory.pdf) present them, with a judgment for signatures, a judgment for contexts and a judgment for usage:

```math
\vdash \Sigma \qquad \Sigma \vdash \Gamma \qquad \Sigma;\ \Gamma \vdash A \qquad \Sigma;\ \Gamma \vdash A \equiv B \qquad \Sigma;\ \Gamma \vdash t : A \qquad \Sigma;\ \Gamma \vdash t \equiv u : A \qquad \Sigma;\ \gamma \mathrel{▶_m} t
```

| Judgment | Reading |
| --- | --- |
| $`\vdash \Sigma`$ | $`\Sigma`$ is a well-formed [signature](#signatures) |
| $`\Sigma \vdash \Gamma`$ | $`\Gamma`$ is a well-formed context |
| $`\Sigma;\ \Gamma \vdash A`$ | $`A`$ is a type in the context $`\Gamma`$ |
| $`\Sigma;\ \Gamma \vdash A \equiv B`$ | $`A`$ and $`B`$ are equal types |
| $`\Sigma;\ \Gamma \vdash t : A`$ | $`t`$ is a term of type $`A`$ |
| $`\Sigma;\ \Gamma \vdash t \equiv u : A`$ | $`t`$ and $`u`$ are equal terms of type $`A`$ |
| $`\Sigma;\ \gamma \mathrel{▶_m} t`$ | Checked in the [mode](https://github.com/sic-lang/rfcs/pull/33) $`m`$, $`t`$ uses each variable of its context as the grade that $`\gamma`$ gives it allows |

Every other judgment holds in a [signature](#signatures) $`\Sigma`$, the entries that its terms may use, written on its left and unchanged from the premises of a rule to its conclusion.
The judgment for contexts makes explicit the condition that Nordström, Petersson and Smith put on the context of a judgment: each declared type is a type in the context of the declarations before it.

Typing and the equalities are those of Martin-Löf type theory: they carry no grade.
Usage is defined on the term and the signature, whose binders and entries carry the grades, and its vector has a grade for each variable of the context of the term.
A program is a term that is both well typed and well used: typing tells what it computes, and usage how it uses its resources.

Equality is written $`\equiv`$; in the conditions of the rules, $`=`$ is an equality of the metalanguage, which for levels is the one the [levels](#levels) define, not the equality of their syntax.

#### Contexts

A context is either empty, written $`\varepsilon`$, in a well-formed signature, or a context extended by a declaration whose type is a type in it:

```math
\frac{\vdash \Sigma}{\Sigma \vdash \varepsilon}\;(\mathsf{ctx}_\varepsilon)
\qquad
\frac{\Sigma;\ \Gamma \vdash A \quad x \notin \Gamma}{\Sigma \vdash \Gamma,\ x : A}\;(\mathsf{ctx}_x)
```

The variable $`x`$ is fresh, absent from $`\Gamma`$, so that a name designates one declaration; ADE, whose variables are de Bruijn indices, need no such condition.
A context is also extended by a second-order variable, as the [parameters](#parameters) define.

#### Signatures

A signature lists the entries that the terms may use, in order, each checked against the entries before it, as the global environment of [Rocq](https://rocq-prover.org/doc/master/refman/language/cic.html) is an ordered list of declarations.
It is either empty, written $`\varnothing`$, or a signature extended by one of three kinds of entries, which the following sections define: a [declaration](#declarations) $`\mathcal{D}`$, a block of types declared together, a [definition](#definitions), a constant with a body, or a [constant](#constants) without a body.
Each entry is well formed in the signature before it, whose well-formedness it implies, since every judgment implies that its signature is, as the [admissible properties](#admissible-properties) state, and the names it introduces are fresh:

```math
\frac{}{\vdash \varnothing}\;(\mathsf{sig}_\varnothing)
\qquad
\frac{\Sigma \vdash \mathcal{D} \quad D \notin \Sigma \quad \text{for each } D \text{ declared by } \mathcal{D}}{\vdash \Sigma,\ \mathcal{D}}\;(\mathsf{sig}_{\mathcal{D}})
```

```math
\frac{\Sigma \vdash c.\{\bar s;\ \bar l;\ \bar p\} :_{m} A \mathrel{≔} t \quad c \notin \Sigma}{\vdash \Sigma,\ c.\{\bar s;\ \bar l;\ \bar p\} :_{m} A \mathrel{≔} t}\;(\mathsf{sig}_{≔})
\qquad
\frac{\Sigma \vdash c.\{\bar s;\ \bar l;\ \bar p\} :_{m} A \quad c \notin \Sigma}{\vdash \Sigma,\ c.\{\bar s;\ \bar l;\ \bar p\} :_{m} A}\;(\mathsf{sig}_c)
```

An entry refers only to the entries before it, never to itself: a declared type refers to the other types of its block as its kind of declaration allows, and a definition recurses through the eliminations that the kinds of declarations give, not by its name.

#### Declarations

A declaration is a block of types declared together, which share their variables, their parameters and their sort:

```math
\mathcal{D} \;=\; \mathsf{kind}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{≔} \mathcal{B}_1;\ \dots;\ D_n \mathrel{≔} \mathcal{B}_n
```

The kind of the declaration, written in its place, is one of the kinds that the RFCs of the kinds of declarations define, such as the [data and codata types](https://github.com/sic-lang/rfcs/pull/34); the body $`\mathcal{B}_i`$ of each type $`D_i`$ has the form that the kind gives, and the kind says what a body may say of the other types of the block, such as a recursion between them, and under which conditions, such as a positivity.
The core knows a declaration by its header only: the names it declares, its variables, its parameters and its sort, which its rules below use, and the [contract](#the-contract-of-a-kind-of-declaration) that its kind fulfills.
A block with a single type is written without its name when no confusion arises, as $`\mathsf{kind}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ \mathcal{B}`$.

The sort variables $`\bar s`$, the level variables $`\bar l`$ and the grade variables $`\bar p`$ are parameters of the declaration, instantiated at each use with sorts, levels and grades, as the [level variables](#level-variables) of a definition are: a type of functions, for instance, is one declaration for all the grades of its argument and all the sorts of its domain and codomain.
A sort variable $`s`$ stands for $`U`$ or $`\Omega`$, and $`s_l`$ for the sort $`U_l`$ or $`\Omega_l`$, as the sort qualities of the [sort polymorphism of Rocq](https://rocq-prover.org/doc/master/refman/addendum/universe-polymorphism.html) stand for its sorts, whose theory [Bounded Sort Polymorphism with Elimination Constraints](https://doi.org/10.1145/3776732) gives.
The context $`\Delta`$ declares the parameters, which carry no grades and which the bodies use, and $`\kappa`$ is the sort in which the declared types live, written $`s_l`$ where $`s`$ is $`U`$, $`\Omega`$, a sort variable or the join $`s_1 \sqcup s_2`$ of two of them, and $`l`$ a level that may use the level variables.
The join of two sorts is the least sort that bounds both, in the sense of the relation $`\preceq`$ of the [telescopes](#telescopes): a universe of propositions when both are, and a universe otherwise, as the join $`l_1 \sqcup l_2`$ of two levels is the larger of the two:

```math
\Omega \sqcup \Omega = \Omega \qquad U \sqcup s = s \sqcup U = U \qquad (\sqcup_s)
```

The types of the parameters do not bound the level of the declared types, as in Lean, since every use instantiates them: only the bodies live in the sort.
A declaration is checked once with its level variables, which are constants within the rules, and for each sort of each sort variable and each grade of each grade variable, which are finitely many, since the conditions on sorts and grades must hold whatever instantiates them, as Rocq accepts a sort polymorphic declaration when each of its instances is valid; a join of sorts is then one of the two sorts, by $`(\sqcup_s)`$, and bounds each sort it joins.

The declared types are nominal, as a [struct of Rust](https://doc.rust-lang.org/reference/types/struct.html): a type is known by its name, so that two declarations with the same parameters and the same bodies give two different types.
The parts of a body are named within their declaration, a constructor $`c_i`$ of $`D`$ being written $`D.c_i`$ in terms, as in [Lean](https://lean-lang.org/doc/reference/latest/The-Type-System/Inductive-Types/), so that two declarations may name their parts alike.

##### Parameters

A parameter is either a variable $`x : A`$ or a second-order variable $`X : (\Theta \vdash A)`$, which stands for a term of type $`A`$ under the variables of $`\Theta`$, as the contextual types of [Nanevski, Pfenning and Pientka](https://doi.org/10.1145/1352582.1352591) do for their metavariables: the type of the result of a function, for instance, is a parameter that depends on the argument.
A second-order variable is used applied to terms for the variables of its telescope, $`X[\bar t]`$, and appears only in the contexts in which declarations are checked: a use of a declaration instantiates its parameters, so that the terms of a program never contain one.
The arguments $`\bar t = (t_1,\ \dots,\ t_k)`$ are typed by the telescope, whose grades typing ignores, each argument instantiating the types after it:

```math
\frac{\Sigma;\ \Gamma,\ \Theta \vdash A \quad X \notin \Gamma}{\Sigma \vdash \Gamma,\ X : (\Theta \vdash A)}\;(\mathsf{ctx}_X)
\qquad
\frac{X : (\Theta \vdash A) \in \Gamma \quad \Sigma;\ \Gamma \vdash \bar t : \Theta}{\Sigma;\ \Gamma \vdash X[\bar t] : A[\bar t / \Theta]}\;(\mathsf{var}_X)
```

```math
\frac{\Sigma \vdash \Gamma}{\Sigma;\ \Gamma \vdash () : \varepsilon}\;(\mathsf{tel}_\varepsilon)
\qquad
\frac{\Sigma;\ \Gamma \vdash t : A \quad \Sigma;\ \Gamma \vdash \bar t : \Theta[t/x]}{\Sigma;\ \Gamma \vdash (t,\ \bar t) : (x :^{q}_{p} A,\ \Theta)}\;(\mathsf{tel}_{,})
```

Equal arguments give equal applications:

```math
\frac{\Sigma \vdash \Gamma}{\Sigma;\ \Gamma \vdash () \equiv () : \varepsilon}\;(\mathsf{tel}_{\equiv\varepsilon})
\qquad
\frac{\Sigma;\ \Gamma \vdash t \equiv u : A \quad \Sigma;\ \Gamma \vdash \bar t \equiv \bar u : \Theta[t/x]}{\Sigma;\ \Gamma \vdash (t,\ \bar t) \equiv (u,\ \bar u) : (x :^{q}_{p} A,\ \Theta)}\;(\mathsf{tel}_{\equiv,})
\qquad
\frac{X : (\Theta \vdash A) \in \Gamma \quad \Sigma;\ \Gamma \vdash \bar t \equiv \bar u : \Theta}{\Sigma;\ \Gamma \vdash X[\bar t] \equiv X[\bar u] : A[\bar t / \Theta]}\;(\mathsf{var}_{X\equiv})
```

Here $`A[\bar t / \Theta]`$ substitutes the terms $`\bar t`$ for the variables of $`\Theta`$, all at once.
A second-order variable does not know how it uses its arguments, so its telescope says it: the application uses $`X`$ itself as a variable, with the grade of the mode, and each argument $`t_j`$ with the grade $`p_j`$ of its entry, checked in the mode of this grade:

```math
\frac{X : (\Theta \vdash A) \in \Gamma \quad \Theta = (x_1 :^{q_1}_{p_1} A_1,\ \dots,\ x_k :^{q_k}_{p_k} A_k) \quad \Sigma;\ \delta_j \mathrel{▶_{m \odot p_j}} t_j \quad \text{for each } j}{\Sigma;\ (\mathbb{0}^{\mathsf{c}}, X \mathrel{≔} \ulcorner m \urcorner) +^{\mathsf{c}} p_1 \cdot^{\mathsf{c}} \delta_1 +^{\mathsf{c}} \dots +^{\mathsf{c}} p_k \cdot^{\mathsf{c}} \delta_k \mathrel{▶_m} X[\bar t]}\;(\mathsf{var}_{X\mathsf{m}})
```

A use of a declaration instantiates each second-order variable $`X : (\Theta \vdash A)`$ with an abstraction $`\bar x.\, B`$, a term $`B`$ of type $`A`$ under the variables $`\bar x`$ of $`\Theta`$, and the instantiation $`[\bar x.\, B / X]`$ replaces each application $`X[\bar t]`$ by $`B[\bar t / \bar x]`$.

##### Telescopes

A telescope is a sequence of declarations whose types may depend on the declarations before it, as a context, and whose entries carry two grades: $`x :^{q}_{p} A`$ declares an entry used with the grade $`p`$, whose variable the types after it use with the grade $`q`$.
The bodies of the declarations are made of telescopes, as the kinds of declarations define, and so are the arguments of second-order variables:

```math
\Theta \;=\; (x_1 :^{q_1}_{p_1} A_1,\ \dots,\ x_k :^{q_k}_{p_k} A_k)
```

The last entry carries a grade $`q`$ too, so that all have the same form; since no type comes after it, it only has to allow no use.
A telescope lives in a sort $`\kappa`$ when each of its types lives in a sort that $`\kappa`$ bounds, which the relation $`\kappa_1 \preceq \kappa_2`$ defines: both sorts are at levels in the [order](#equality-and-order-of-levels) $`l_1 \le l_2`$, and $`\kappa_1`$ is a universe of propositions when $`\kappa_2`$ is.
An entry whose type is a proposition is a proof, whose grade has no use at run time, as the [strict propositions](#strict-propositions) require:

```math
\frac{\Sigma \vdash \Gamma}{\Sigma;\ \Gamma \vdash \varepsilon : \kappa}\;(\mathsf{tel}_{\kappa\varepsilon})
\qquad
\frac{\begin{gathered}{}\Sigma;\ \Gamma \vdash A : \kappa_1 \quad \kappa_1 \preceq \kappa_2 \quad \Sigma;\ \Gamma,\ x : A \vdash \Theta : \kappa_2 \\ \llcorner p \lrcorner \ne \mathbb{1}\mathbb{1}^{\mathsf{m}} \text{ if } \kappa_1 = \Omega_{l_1}\end{gathered}}{\Sigma;\ \Gamma \vdash (x :^{q}_{p} A,\ \Theta) : \kappa_2}\;(\mathsf{tel}_{\kappa,})
```

The grades $`q`$ of the entries bound the uses in the types after them, which the usage of the declared types checks, as the kinds of declarations define.

##### Instances

A declared type is used through an instance of its declaration $`\mathcal{D}`$, which gives its variables sorts, levels and grades, and its parameters arguments $`\bar a`$: a term for each variable of $`\Delta`$, and an abstraction for each second-order variable.
In the rules of this section and of the kinds of declarations, $`T`$ stands for the instance of a type $`D`$ of the block, in which $`\bar s`$, $`\bar l`$ and $`\bar p`$ now stand for sorts, levels and grades, substituted for the variables of the declaration in its parameters $`\Delta`$, its sort $`\kappa`$, and its bodies:

```math
T \;=\; D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a
```

The arguments are typed by the parameters, each argument instantiating the types after it, as a substitution of the context $`\Delta`$:

```math
\frac{\Sigma \vdash \Gamma}{\Sigma;\ \Gamma \vdash () : \varepsilon}\;(\mathsf{arg}_\varepsilon)
\qquad
\frac{\Sigma;\ \Gamma \vdash \bar a : \Delta \quad \Sigma;\ \Gamma \vdash a : A[\bar a / \Delta]}{\Sigma;\ \Gamma \vdash (\bar a,\ a) : (\Delta,\ x : A)}\;(\mathsf{arg}_x)
```

```math
\frac{\Sigma;\ \Gamma \vdash \bar a : \Delta \quad \Sigma;\ \Gamma,\ \Theta[\bar a / \Delta] \vdash B : A[\bar a / \Delta]}{\Sigma;\ \Gamma \vdash (\bar a,\ \bar x.\, B) : (\Delta,\ X : (\Theta \vdash A))}\;(\mathsf{arg}_X)
```

Here $`[\bar a / \Delta]`$ substitutes the terms of $`\bar a`$ for the variables of $`\Delta`$ and instantiates its second-order variables with the abstractions of $`\bar a`$, as the [parameters](#parameters) define, and $`\bar x`$ are the variables of $`\Theta`$, which the abstraction binds.
Equal arguments are defined by the same rules with equalities:

```math
\frac{\Sigma \vdash \Gamma}{\Sigma;\ \Gamma \vdash () \equiv () : \varepsilon}\;(\mathsf{arg}_{\equiv\varepsilon})
\qquad
\frac{\Sigma;\ \Gamma \vdash \bar a \equiv \bar b : \Delta \quad \Sigma;\ \Gamma \vdash a \equiv b : A[\bar a / \Delta]}{\Sigma;\ \Gamma \vdash (\bar a,\ a) \equiv (\bar b,\ b) : (\Delta,\ x : A)}\;(\mathsf{arg}_{\equiv x})
```

```math
\frac{\Sigma;\ \Gamma \vdash \bar a \equiv \bar b : \Delta \quad \Sigma;\ \Gamma,\ \Theta[\bar a / \Delta] \vdash B_1 \equiv B_2 : A[\bar a / \Delta]}{\Sigma;\ \Gamma \vdash (\bar a,\ \bar x.\, B_1) \equiv (\bar b,\ \bar x.\, B_2) : (\Delta,\ X : (\Theta \vdash A))}\;(\mathsf{arg}_{\equiv X})
```

An instance of a type declared in the signature is a type in the sort of its declaration, and two instances are equal when their arguments are, and their levels too, as the levels of two [universes](#universes):

```math
\frac{\mathcal{D} \in \Sigma \quad D \text{ declared by } \mathcal{D} \quad \Sigma;\ \Gamma \vdash \bar a : \Delta}{\Sigma;\ \Gamma \vdash T : \kappa}\;(D)
\qquad
\frac{\mathcal{D} \in \Sigma \quad D \text{ declared by } \mathcal{D} \quad \Sigma;\ \Gamma \vdash \bar a \equiv \bar b : \Delta \quad \bar l_1 = \bar l_2}{\Sigma;\ \Gamma \vdash D.\{\bar s;\ \bar l_1;\ \bar p\}\ \bar a \equiv D.\{\bar s;\ \bar l_2;\ \bar p\}\ \bar b : \kappa}\;(D_\equiv)
```

In the rule $`(D_\equiv)`$, $`\Delta`$ and $`\kappa`$ are instantiated with the levels $`\bar l_1`$.
No rule equates two instances with different sorts or grades: two types that differ only by a grade are different types, as in ADE.
The usage of an instance, which counts the uses of the variables of its arguments, depends on how the body uses them, which the kind of declaration gives.

#### Definitions

A definition names a closed term, so that a program is written once and used many times, and so that the conversion unfolds it:

```math
c.\{\bar s;\ \bar l;\ \bar p\} :_{m} A \mathrel{≔} t
```

Its sort, level and grade variables are prenex, as those of a [declaration](#declarations), and instantiated at each use.
Its body is checked once, in the empty context, in the [mode](https://github.com/sic-lang/rfcs/pull/33) $`m`$ that the definition states: a definition checked in $`\mathbb{1}\mathbb{1}^{\mathsf{m}}`$ is a program, one checked in $`\mathbb{0}\mathbb{1}^{\mathsf{m}}`$ a proof or a ghost term, which counts all its uses but runs nowhere, and one checked in $`\mathbb{0}\mathbb{0}^{\mathsf{m}}`$ a specification, as the modes of [Verus](https://doi.org/10.1145/3586037) separate executable code, proofs and specifications:

```math
\frac{\Sigma;\ \varepsilon \vdash A : \kappa \quad \Sigma;\ \varepsilon \vdash t : A \quad \Sigma;\ \mathbb{0}^{\mathsf{c}} \mathrel{▶_m} t}{\Sigma \vdash c.\{\bar s;\ \bar l;\ \bar p\} :_{m} A \mathrel{≔} t}\;(\mathsf{def})
```

A definition is used by its name, instantiated with sorts, levels and grades for its variables, written $`[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p]`$ and applied to its type:

```math
\frac{\Sigma \vdash \Gamma \quad c.\{\bar s;\ \bar l;\ \bar p\} :_{m} A \mathrel{≔} t \in \Sigma}{\Sigma;\ \Gamma \vdash c.\{\bar s';\ \bar l';\ \bar p'\} : A[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p]}\;(c)
\qquad
\frac{c.\{\bar s;\ \bar l;\ \bar p\} :_{m} A \mathrel{≔} t \in \Sigma \quad m' \cdot^{\mathsf{m}} m = m'}{\Sigma;\ \mathbb{0}^{\mathsf{c}} \mathrel{▶_{m'}} c.\{\bar s';\ \bar l';\ \bar p'\}}\;(c_{\mathsf{m}})
```

Its body is closed, so a use of a definition uses no variable, any number of times; the mode $`m'`$ of the use must be allowed by the mode of the definition, which the condition $`m' \cdot^{\mathsf{m}} m = m'`$ states: a specification is used in specifications only, a proof in proofs and specifications, and a program anywhere.
A definition unfolds to its body, instantiated likewise:

```math
\frac{\Sigma \vdash \Gamma \quad c.\{\bar s;\ \bar l;\ \bar p\} :_{m} A \mathrel{≔} t \in \Sigma}{\Sigma;\ \Gamma \vdash c.\{\bar s';\ \bar l';\ \bar p'\} \equiv t[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p] : A[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p]}\;(\delta)
```

A definition is transparent: the core has no opaque definition, since a proposition hides the proofs it packs by irrelevance, and the modules of a later RFC may hide what a definition is.
A definition does not refer to itself: recursion goes through the eliminations that the kinds of declarations give, which keeps the core total.

#### Constants

A constant is an entry of the same form as a definition, without a body:

```math
c.\{\bar s;\ \bar l;\ \bar p\} :_{m} A
```

It is typed and used by the rules $`(c)`$ and $`(c_{\mathsf{m}})`$ of the definitions, and no rule unfolds it: it is a hypothesis on which the whole signature depends, as every use of it is typed and checked for its usage.
One mechanism covers three needs, told apart by the sort of the type and the mode of the constant:

| Constant | Sort of $`A`$ | Mode $`m`$ | Stands for |
| --- | --- | --- | --- |
| Axiom | $`\Omega_l`$ | $`\mathbb{0}\mathbb{1}^{\mathsf{m}}`$ | A proposition assumed true, whose proof is never built |
| Ghost constant | $`U_l`$ | $`\mathbb{0}\mathbb{0}^{\mathsf{m}}`$ or $`\mathbb{0}\mathbb{1}^{\mathsf{m}}`$ | A value or a type that specifications and proofs use, absent from the program that runs |
| Foreign constant | $`U_l`$ | $`\mathbb{1}\mathbb{1}^{\mathsf{m}}`$ | A type, a value or a function that the program that runs gets from outside, such as a machine integer or a system call |

```math
\frac{\Sigma;\ \varepsilon \vdash A : \kappa}{\Sigma \vdash c.\{\bar s;\ \bar l;\ \bar p\} :_{m} A}\;(\mathsf{const})
```

A constant is closed, so a use of it uses no variable, any number of times, as a definition: whatever a foreign constant produces is produced from no resource of the program, and may thus be duplicated or discarded freely.
A foreign function that creates a resource to be used exactly once, such as a handle, must therefore consume a resource to do so, a capability that the program holds with a linear grade, as the world token of [Idris 2](https://arxiv.org/abs/2104.00480) threads its effects; otherwise a program binds its result with an unrestricted grade and duplicates it, which the rules accept, since $`\langle \omega, \omega \rangle \cdot \mathbb{0} = \mathbb{0}`$.
The internal representation of a foreign type, such as the digits of an integer, is a matter of the implementation, which the type system ignores as long as the conversion is unchanged.
What a constant assumes enters the [properties](#properties) of the core only as named hypotheses: the consistency of the signature, the soundness of the erasure and the canonicity of the closed terms hold under them.

#### Variables

A variable has the type of its declaration, and, checked in the mode $`m`$, uses itself with the grade $`\ulcorner m \urcorner`$ of the [mode](https://github.com/sic-lang/rfcs/pull/33) and nothing else:

```math
\frac{\Sigma \vdash \Gamma_1,\ x : A,\ \Gamma_2}{\Sigma;\ \Gamma_1,\ x : A,\ \Gamma_2 \vdash x : A}\;(\mathsf{var})
\qquad
\frac{}{\Sigma;\ (\mathbb{0}^{\mathsf{c}}, x \mathrel{≔} \ulcorner m \urcorner) \mathrel{▶_m} x}\;(\mathsf{var}_{\mathsf{m}})
```

#### Equality

The equality of types and the equality of terms are equivalence relations, reflexive, symmetric and transitive:

```math
\frac{\Sigma;\ \Gamma \vdash A}{\Sigma;\ \Gamma \vdash A \equiv A}\;(\mathsf{refl}_{\mathsf{type}})
\qquad
\frac{\Sigma;\ \Gamma \vdash A \equiv B}{\Sigma;\ \Gamma \vdash B \equiv A}\;(\mathsf{sym}_{\mathsf{type}})
\qquad
\frac{\Sigma;\ \Gamma \vdash A_1 \equiv A_2 \quad \Sigma;\ \Gamma \vdash A_2 \equiv A_3}{\Sigma;\ \Gamma \vdash A_1 \equiv A_3}\;(\mathsf{trans}_{\mathsf{type}})
```

```math
\frac{\Sigma;\ \Gamma \vdash t : A}{\Sigma;\ \Gamma \vdash t \equiv t : A}\;(\mathsf{refl})
\qquad
\frac{\Sigma;\ \Gamma \vdash t \equiv u : A}{\Sigma;\ \Gamma \vdash u \equiv t : A}\;(\mathsf{sym})
\qquad
\frac{\Sigma;\ \Gamma \vdash t_1 \equiv t_2 : A \quad \Sigma;\ \Gamma \vdash t_2 \equiv t_3 : A}{\Sigma;\ \Gamma \vdash t_1 \equiv t_3 : A}\;(\mathsf{trans})
```

Each construct adds its own rules of congruence and computation, and two types are also equal when they are equal terms of a [universe](#universes) or of a universe of [strict propositions](#strict-propositions).

#### Type Conversion

Conversion gives a term any type equal to its own, and an equality of two terms as well, which the other rules do not derive, since a rule of computation gives its equality at one type only:

```math
\frac{\Sigma;\ \Gamma \vdash t : A \quad \Sigma;\ \Gamma \vdash A \equiv B}{\Sigma;\ \Gamma \vdash t : B}\;(\mathsf{conv})
\qquad
\frac{\Sigma;\ \Gamma \vdash t \equiv u : A \quad \Sigma;\ \Gamma \vdash A \equiv B}{\Sigma;\ \Gamma \vdash t \equiv u : B}\;(\mathsf{conv}_\equiv)
```

The core has no cumulativity, so conversion checks an equality of types, not a subtyping.

#### Usage

A term may be given grades lower than its uses, in the order of the [grades](https://github.com/sic-lang/rfcs/pull/33) taken on each component:

```math
\frac{\Sigma;\ \gamma \mathrel{▶_m} t \quad \delta \le^{\mathsf{c}} \gamma}{\Sigma;\ \delta \mathrel{▶_m} t}\;(\mathsf{sub})
```

This rule lets an unrestricted variable be used once or not at all, and a variable of grade $`\langle \omega, 1 \rangle`$ be used once, at run time or not.

### The Contract of a Kind of Declaration

A kind of declaration adds types to the core by fulfilling the contract below, so that the rules, the meaning and the properties of the core extend to its types; each item names what the RFC of the kind provides.

1. Formation: the judgment $`\Sigma \vdash \mathcal{D}`$, which checks a block of its kind, with the polarity of each parameter of each type, strictly positive, negative, mixed or unused, computed from its body, for the second-order parameters as well; a type of the block may occur in an argument of an earlier type only at a strictly positive parameter, so that the positivity of a kind extends through the parameters of the others.
2. Liftings: for each strictly positive parameter of a type, a derived lifting, which turns a predicate on the terms of the parameter into a predicate on the terms of the instance, stating that the first holds at every position of the parameter, and a derived map, which builds a proof of the lifted predicate from proofs of the first at every position; the eliminations of recursive declarations use them for the fields nested through other types.
3. Usage of the instances: the rule of usage of an instance $`T`$, which counts the uses of the variables of its arguments by its body, with the grades of its entries.
4. Rules of the terms: the introductions, the eliminations, the computations $`\beta`$ and the extensionalities $`\eta`$ of the terms of its types, each with its rule of usage, and each with its conditions on the sorts, as the [strict propositions](#strict-propositions) restrict what a proof may build.
5. Meaning: the formula $`\Sigma \vDash \mathcal{D}`$, the clauses $`\mathsf{eq}(T)`$ and $`\mathsf{true}(T)`$ that give the equal canonical terms of an instance in a universe and the truth of an instance in a universe of propositions, and the clause that puts the instances in $`\mathsf{eq}(s_n)`$, which the [meaning](#meaning-of-the-universes) of the sorts receives.
6. Conversion: the head normal forms and the neutral terms of its types, and their reduction, which is deterministic, so that the [conversion](#conversion) of the core decides their equality.
7. Erasure: the clauses of $`t^\bullet`$ and $`t^\circ`$ for its terms, as the [erasure](#erasure) of the core defines them, with the forms they add to the target language.
8. Obligations: the soundness of each of its rules for its meaning, the preservation of usage by its rules $`\beta`$, and the compatibility of its rules of usage with the [projection](#projection-lemma) of the modes, so that the properties of the core hold with its types.

A kind may extend the contract for the kinds after it, as the [observational equality](https://github.com/sic-lang/rfcs/pull/35) asks each kind for the equality of its terms and the cast between its instances.

### Universes

A universe is a type whose elements are types.
A universe that contains itself makes the theory inconsistent ([Girard's paradox](https://doi.org/10.1007/BFb0014058)), so the universes form a predicative hierarchy, as in Agda and in the formalization of ADE:

```math
U_0 : U_1 : U_2 : \cdots
```

#### Formation of Universes

A universe is a type in the universe just above it, in any well-formed context, and uses no variable:

```math
\frac{\Sigma \vdash \Gamma}{\Sigma;\ \Gamma \vdash U_l : U_{l + 1}}\;(U)
\qquad
\frac{\Sigma \vdash \Gamma \quad l_1 = l_2}{\Sigma;\ \Gamma \vdash U_{l_1} \equiv U_{l_2} : U_{l_1 + 1}}\;(U_\equiv)
\qquad
\frac{}{\Sigma;\ \mathbb{0}^{\mathsf{c}} \mathrel{▶_m} U_l}\;(U_{\mathsf{m}})
```

The hierarchy is not cumulative: a type of $`U_l`$ is not a type of $`U_{l + 1}`$, as in Agda and Lean, and unlike Rocq.
A declared type lives in the sort of its declaration, which bounds the levels of its body, as the [telescopes](#telescopes) define.

#### Elements of Universes as Types

A term of a universe is a type, and two equal terms of a universe are equal types, as the rule `univ` of the [formalization of ADE](https://github.com/graded-type-theory/graded-type-theory/blob/master/Definition/Typed.agda), which does not write the decoding $`\mathsf{El}`$ of Nordström, Petersson and Smith either:

```math
\frac{\Sigma;\ \Gamma \vdash A : U_l}{\Sigma;\ \Gamma \vdash A}\;(U_{\mathsf{type}})
\qquad
\frac{\Sigma;\ \Gamma \vdash A \equiv B : U_l}{\Sigma;\ \Gamma \vdash A \equiv B}\;(U_{\mathsf{type}\equiv})
```

### Strict Propositions

A proposition is a type whose proofs carry no information but their existence.

#### Formation of Propositions

The propositions live in universes of their own, written $`\Omega_l`$ as the propositions of categorical semantics, which form a second predicative hierarchy, strict as the `Prop` of [Agda](https://agda.readthedocs.io/en/latest/language/prop.html), from [Gilbert, Cockx, Sozeau and Tabareau](https://doi.org/10.1145/3290316):

```math
\frac{\Sigma \vdash \Gamma}{\Sigma;\ \Gamma \vdash \Omega_l : U_{l + 1}}\;(\Omega)
\qquad
\frac{\Sigma \vdash \Gamma \quad l_1 = l_2}{\Sigma;\ \Gamma \vdash \Omega_{l_1} \equiv \Omega_{l_2} : U_{l_1 + 1}}\;(\Omega_\equiv)
\qquad
\frac{}{\Sigma;\ \mathbb{0}^{\mathsf{c}} \mathrel{▶_m} \Omega_l}\;(\Omega_{\mathsf{m}})
```

The `Prop` of Lean and the `SProp` of Rocq are impredicative instead: a proposition that quantifies over all propositions is itself one of them; together with proof irrelevance and the elimination of subsingletons, this makes the conversion of Lean undecidable ([Carneiro](https://github.com/digama0/lean-type-theory)).

#### Elements of Propositions as Types

A sort is a universe $`U_l`$ or a universe of propositions $`\Omega_l`$; a proposition is a type, as a term of a universe is, and two equal propositions are equal types:

```math
\frac{\Sigma;\ \Gamma \vdash A : \Omega_l}{\Sigma;\ \Gamma \vdash A}\;(\Omega_{\mathsf{type}})
\qquad
\frac{\Sigma;\ \Gamma \vdash A \equiv B : \Omega_l}{\Sigma;\ \Gamma \vdash A \equiv B}\;(\Omega_{\mathsf{type}\equiv})
```

#### Proof Irrelevance

Proof irrelevance is definitional: two proofs of the same proposition are equal.

```math
\frac{\Sigma;\ \Gamma \vdash t : A \quad \Sigma;\ \Gamma \vdash u : A \quad \Sigma;\ \Gamma \vdash A : \Omega_l}{\Sigma;\ \Gamma \vdash t \equiv u : A}\;(\mathsf{irr})
```

Since equality carries no grade, two proofs are equal even when they use their hypotheses differently; the usage of each is checked on its own.

A proof cannot be analyzed to build a term that is not a proof, since irrelevance would identify the terms built from two proofs: the eliminations of the kinds of declarations restrict what a proof may build, so that a proof is eliminated for a result that is not a proof only when no analysis of the proof is needed, as the [contract](#the-contract-of-a-kind-of-declaration) requires of their rules.

#### Erased Proofs

A proof exists only in erased positions: every entry whose type is a proposition has a [grade](https://github.com/sic-lang/rfcs/pull/33) without use at run time, as the rule $`(\mathsf{tel}_{\kappa,})`$ of the [telescopes](#telescopes) checks, so that a proof is checked in the mode $`\mathbb{0}\mathbb{0}^{\mathsf{m}}`$ or $`\mathbb{0}\mathbb{1}^{\mathsf{m}}`$.
The erasure of proofs is then the erasure of the grades without use at run time, with no mechanism of its own.

### Conversion

The rule $`(\mathsf{conv})`$ compares types with the [equality of types](#equality), which the core and the kinds of declarations define together, through the equalities of their terms in a sort:

| Equality | Constructs |
| --- | --- |
| Computation, $`\beta`$ | The eliminations of the kinds of declarations applied to their introductions |
| Unfolding, $`\delta`$ | The [definitions](#definitions), $`(\delta)`$ |
| Extensionality, $`\eta`$ | The types to which their kind gives one |
| Irrelevance | Two proofs of the same proposition, $`(\mathsf{irr})`$ |
| Levels | Universes whose levels are equal in Presburger arithmetic, $`(U_\equiv)`$ and $`(\Omega_\equiv)`$, and instances of a declaration, $`(D_\equiv)`$ |
| Congruence | Every construct, with the premises of its rules |

Grades are part of terms and types, but no rule equates two different grades: two instances that differ only by a grade are different types, as the types of two functions whose grades differ in ADE.
Since typing carries no grade otherwise, the modes and the seven grades play no part in equality: what ADE prove about typing holds whatever their modality.

Checking a type needs a decision procedure for equality, whose framework is the algorithm of [Abel, Öhman and Vezzosi](https://doi.org/10.1145/3158111), which the formalization of ADE extends: both terms are reduced to their weak head normal forms, whose heads are compared, and terms are compared by their type, through $`\eta`$, at the types that have it.
The weak head reduction unfolds the definitions by $`(\delta)`$ and applies the computations of the kinds of declarations, each of which says which of its terms are head normal forms, canonical, and which are neutral, stuck on a variable or on a constant, so that the reduction is deterministic.
A type that is a proposition is checked first, and two of its terms are then equal without being compared, which keeps irrelevance decidable, as [Gilbert, Cockx, Sozeau and Tabareau](https://doi.org/10.1145/3290316) show; two levels are compared by deciding their formula of Presburger arithmetic.
The algorithm itself is not part of this RFC: the [properties](#normalization-and-decidability) state that the equality is decidable, and an implementation chooses how.

### Erasure

Erasure compiles a program to an untyped target language, removing every part that has no use at run time.
It is the extraction of ADE, written $`t^\bullet`$ as in their paper, extended to the entries of the signature and to the terms of the kinds of declarations, and doubled by a second erasure $`t^\circ`$, which removes the parts without any use.
A program is a closed term that is well typed and well used in the mode of run time:

```math
\Sigma;\ \varepsilon \vdash t : A \qquad \Sigma;\ \mathbb{0}^{\mathsf{c}} \mathrel{▶_{\mathbb{1}\mathbb{1}^{\mathsf{m}}}} t
```

The two erasures are one translation, parametrized by the grades it erases: $`t^\bullet`$ erases a position whose grade has no use at run time, $`\mathsf{run}(p) = 0`$, and $`t^\circ`$ a position whose grade has no use at all, $`p = \mathbb{0}`$, so that $`t^\circ`$ keeps the proofs, the specifications and the permissions that $`t^\bullet`$ removes, as the ghost code of [Verus](https://doi.org/10.1145/3586037) is checked but never run.
A position is a subterm that a rule of usage checks in a mode of its own: the grade of the position is the grade with which the rule uses it, and the mode in which it is checked is the mode of the term times this grade.
The target language has variables, the constants, and a value $`\text{↯}`$ that stands for what was erased; the kinds of declarations add the forms of their terms.
The translation is defined on the terms of the core, and each kind adds the clauses of its terms:

| Term | $`t^\bullet`$ | $`t^\circ`$ |
| --- | --- | --- |
| $`U_l`$, $`\Omega_l`$, $`T`$ | $`\text{↯}`$ | $`\text{↯}`$ |
| $`x`$ | $`x`$ | $`x`$ |
| $`c.\{\bar s;\ \bar l;\ \bar p\}`$ | $`c`$ | $`c`$ |
| A position of grade $`p`$ | $`\text{↯}`$ if $`\mathsf{run}(p) = 0`$ | $`\text{↯}`$ if $`p = \mathbb{0}`$ |

A definition is extracted with the program, its name standing for its extracted body, and a foreign constant stands for its implementation; a ghost constant and an axiom are never reached by $`t^\bullet`$, since they are used in erased positions only, as their mode requires.
A term that is checked in an erased mode is never extracted: a proof, an erased argument, and the types that the terms carry disappear.
The erasure follows the grades alone, and depends on no evaluation order: it is a translation from terms to terms, whose soundness the [properties](#erasure-properties) state on the computation of the type theory, and the RFC of the calling convention chooses how the target runs.

### Meaning

The judgments of typing mean what the [meaning explanations](https://doi.org/10.1016/S0049-237X(09)70189-2) of Martin-Löf say of them, as Nordström, Petersson and Smith present them: a judgment is true when its terms compute as it says, and the rules are sound for this meaning, but not complete.
This section gives the meaning of the judgments, of the levels, of the signatures and of the sorts; each kind of declaration completes it with the meaning of its declarations and the canonical terms of its instances, as its contract requires.

#### Meaning of the Judgments

The meaning of a judgment is written with $`\vDash`$ in place of $`\vdash`$.
A closed term $`t`$ computes to a canonical term $`v`$, written $`t \Downarrow v`$, when its weak head reduction, the one of the [conversion](#conversion), ends on $`v`$, a head normal form: the meaning explanations evaluate lazily, as Nordström, Petersson and Smith note, and this computation is the one of the type theory, not the evaluation of a program.
A closed canonical type $`A_0`$ is known by its canonical terms and by their equality, a partial equivalence relation $`\mathsf{eq}(A_0)`$, symmetric and transitive, between closed canonical terms, which the sorts and the kinds of declarations give.
The computation, the relations $`\mathsf{eq}`$ and $`\mathsf{true}`$ and the interpretation $`\iota`$ of the constants, which the [meaning of the signatures](#meaning-of-the-signatures) introduces, all depend on the signature $`\Sigma`$ of the judgment, which their notation omits.
A closed judgment requires its signature to be meaningful, as every judgment of the rules implies that its signature is well formed, so that it is the hypothetical judgment in the empty context:

```math
\begin{aligned}
\Sigma \vDash A \equiv B &\iff \vDash \Sigma \text{ and } \exists A_0, B_0.\ A \Downarrow A_0,\ B \Downarrow B_0,\ \mathsf{eq}(A_0) \text{ and } \mathsf{eq}(B_0) \text{ are defined, and } \mathsf{eq}(A_0) = \mathsf{eq}(B_0) &&(\vDash_{\mathsf{type}\equiv}) \\
\Sigma \vDash A &\iff \Sigma \vDash A \equiv A &&(\vDash_{\mathsf{type}}) \\
\text{if } A \text{ does not compute to a proposition, then } \Sigma \vDash t \equiv u : A &\iff \Sigma \vDash A \text{ and } \exists A_0, v, w.\ A \Downarrow A_0,\ t \Downarrow v,\ u \Downarrow w \text{ and } (v, w) \in \mathsf{eq}(A_0) &&(\vDash_\equiv) \\
\Sigma \vDash t : A &\iff \Sigma \vDash t \equiv t : A &&(\vDash)
\end{aligned}
```

The clause $`(\vDash_\equiv)`$ asks the terms to compute, which a proof of a [strict proposition](#strict-propositions) need not, since irrelevance makes all the proofs of a proposition equal: the strict propositions give the clause of the types that compute to a proposition.

A judgment in a context $`\Gamma`$ is hypothetical: its context is meaningful, and it holds under every pair of equal closed substitutions of $`\Gamma`$, which give each variable a closed term of its type, and each second-order variable an abstraction whose instances by equal arguments are equal terms of its type:

```math
\begin{aligned}
\mathsf{eq}(\varepsilon) = {}& \{((),\ ())\} &&(\mathsf{eq}_\varepsilon) \\
\mathsf{eq}(\Gamma,\ x : A) = {}& \{((\sigma_1, v_1),\ (\sigma_2, v_2)) \mid (\sigma_1, \sigma_2) \in \mathsf{eq}(\Gamma),\ \Sigma \vDash v_1 \equiv v_2 : A[\sigma_1]\} &&(\mathsf{eq}_x) \\
\mathsf{eq}(\Gamma,\ X : (\Theta \vdash A)) = {}& \{((\sigma_1, \bar x.\, B_1),\ (\sigma_2, \bar x.\, B_2)) \mid &&(\mathsf{eq}_X) \\
& \quad (\sigma_1, \sigma_2) \in \mathsf{eq}(\Gamma), \\
& \quad \forall (\tau_1, \tau_2) \in \mathsf{eq}(\Theta[\sigma_1]).\ \Sigma \vDash B_1[\tau_1] \equiv B_2[\tau_2] : A[\sigma_1, \tau_1]\}
\end{aligned}
```

```math
\begin{aligned}
\Sigma;\ \Gamma \vDash A \equiv B &\iff \Sigma \vDash \Gamma \text{ and } \forall (\sigma_1, \sigma_2) \in \mathsf{eq}(\Gamma).\ \Sigma \vDash A[\sigma_1] \equiv B[\sigma_2] &&({\vDash}\Gamma_{\mathsf{type}\equiv}) \\
\Sigma;\ \Gamma \vDash A &\iff \Sigma;\ \Gamma \vDash A \equiv A &&({\vDash}\Gamma_{\mathsf{type}}) \\
\Sigma;\ \Gamma \vDash t \equiv u : A &\iff \Sigma;\ \Gamma \vDash A \text{ and } \forall (\sigma_1, \sigma_2) \in \mathsf{eq}(\Gamma).\ \Sigma \vDash t[\sigma_1] \equiv u[\sigma_2] : A[\sigma_1] &&({\vDash}\Gamma_\equiv) \\
\Sigma;\ \Gamma \vDash t : A &\iff \Sigma;\ \Gamma \vDash t \equiv t : A &&({\vDash}\Gamma)
\end{aligned}
```

A telescope has the equal substitutions of the context it forms, whose grades the meaning ignores.
Two closed telescopes are equal in a sort $`\kappa`$ when their first types are equal types of a sort that $`\kappa`$ bounds, and the rest of them equal for every pair of equal terms of these types, as the rule $`(\mathsf{tel}_{\kappa,})`$ checks; the meaning ignores their grades, so that the formulas omit them:

```math
\begin{aligned}
\Sigma \vDash \varepsilon \equiv \varepsilon : \kappa \iff {}& \vDash \Sigma &&({\vDash}\mathsf{tel}_{\kappa\varepsilon}) \\
\Sigma \vDash (x : A_1,\ \Theta_1) \equiv (x : A_2,\ \Theta_2) : \kappa \iff {}& \exists \kappa_1 \preceq \kappa.\ \Sigma \vDash A_1 \equiv A_2 : \kappa_1, \text{ and} &&({\vDash}\mathsf{tel}_{\kappa,}) \\
& \forall v_1, v_2.\ \Sigma \vDash v_1 \equiv v_2 : A_1 \implies \\
& \quad \Sigma \vDash \Theta_1[v_1/x] \equiv \Theta_2[v_2/x] : \kappa
\end{aligned}
```

A context is meaningful when its last type is a type in the context before it, which makes this context meaningful too, as the rule $`(\mathsf{ctx}_x)`$ needs no other premise:

```math
\begin{aligned}
\Sigma \vDash \varepsilon &\iff \vDash \Sigma &&({\vDash}\mathsf{ctx}_\varepsilon) \\
\Sigma \vDash \Gamma,\ x : A &\iff \Sigma;\ \Gamma \vDash A &&({\vDash}\mathsf{ctx}_x) \\
\Sigma \vDash \Gamma,\ X : (\Theta \vdash A) &\iff \Sigma;\ \Gamma,\ \Theta \vDash A &&({\vDash}\mathsf{ctx}_X)
\end{aligned}
```

Usage has no meaning of its own in this RFC, since the uses of a variable that a program makes when it runs depend on its evaluation order, which a later RFC fixes; the [erasure](#erasure) gives its meaning to a run-time multiplicity $`0`$: the term that has it is absent from the program that runs.

#### Meaning of the Levels

A judgment $`\Sigma;\ \Gamma \vdash \mathcal{J}`$ whose levels use level variables is true when it is true for every assignment $`\rho`$ of [natural numbers](#equality-and-order-of-levels) to them, as a definition checked once with its level variables is used at any levels; the instance $`\mathcal{J}[\rho]`$ replaces each level $`l`$ by the level without variables whose value is $`\rho(l)`$, written as this number, and $`\Gamma[\rho]`$ does so in the context, so that the clauses of the meaning of the judgments apply:

```math
\begin{aligned}
\Sigma;\ \Gamma \vDash \mathcal{J} &\iff \forall \rho.\ \Sigma;\ \Gamma[\rho] \vDash \mathcal{J}[\rho] &&(\vDash_\rho)
\end{aligned}
```

#### Meaning of the Signatures

A signature is meaningful when each of its entries is meaningful in the signature before it.
A declaration is meaningful as its kind defines, for each instantiation of its variables, which gives its sort variables sorts, its level variables natural numbers and its grade variables grades, and computes the joins of sorts by $`(\sqcup_s)`$; a definition is meaningful when its body is a term of its type, instantiated likewise.
A constant has no body to compute: the meaning takes an interpretation $`\iota`$, which gives each constant without a body a closed term of its type, built from the entries before it, and the computation $`t \Downarrow v`$ replaces each constant $`c`$ by $`\iota(c)`$, instantiated, before it reduces; a constant is thus meaningful when its interpretation is a term of its type:

```math
\begin{aligned}
\vDash \varnothing & &&({\vDash}\mathsf{sig}_\varnothing) \\
\vDash \Sigma,\ \mathcal{D} &\iff \vDash \Sigma \text{ and } \Sigma \vDash \mathcal{D} &&({\vDash}\mathsf{sig}_{\mathcal{D}}) \\
\vDash \Sigma,\ c.\{\bar s;\ \bar l;\ \bar p\} :_{m} A \mathrel{≔} t &\iff \vDash \Sigma \text{ and } \Sigma \vDash t : A &&({\vDash}\mathsf{sig}_{≔}) \\
\vDash \Sigma,\ c.\{\bar s;\ \bar l;\ \bar p\} :_{m} A &\iff \vDash \Sigma \text{ and } \Sigma \vDash \iota(c) : A &&({\vDash}\mathsf{sig}_c)
\end{aligned}
```

The meaning of a signature with constants is thus relative to an interpretation, and so are the properties that depend on it: an axiom is meaningful only if its proposition is true, and a foreign constant only if some term of the core has its type, which the [properties](#consistency-and-canonicity) state as hypotheses.
The rule $`(\delta)`$ is sound since a definition computes to its body, and the rules $`(c)`$ and $`(\mathsf{const})`$ since a constant computes to its interpretation.

#### Meaning of the Universes

The canonical terms of the universe $`U_n`$ are the canonical types that live in it, and two of them are equal when they are equal types; $`\mathsf{eq}(U_n)`$ is the least relation such that the following holds, together with the clauses that the [strict propositions](#meaning-of-the-strict-propositions) and the kinds of declarations add:

```math
\begin{aligned}
(U_k,\ U_k) \in \mathsf{eq}(U_n) &\quad \text{if } k + 1 = n &&(\mathsf{eq}_U)
\end{aligned}
```

The relation is inductive, since a type of $`U_n`$ may be built from other types of $`U_n`$, such as the types of the entries of a declared type: each of its types is built by finitely many clauses, which define together the equality $`\mathsf{eq}(A_0)`$ of the terms of each type $`A_0`$ it relates, equal to that of every type it relates to $`A_0`$.
The clause of $`U_k`$ needs only the universe below $`U_n`$, so that the universes are defined one level after the other, by induction on $`n`$.
The rules $`(U_{\mathsf{type}})`$ and $`(U_{\mathsf{type}\equiv})`$ are then sound: a term of a universe is a type, and two equal terms of a universe are equal types.

#### Meaning of the Strict Propositions

The strict propositions complete the meaning of the judgments with a denotation of the propositions by truth values, as the setoid model of [Pujet and Tabareau](https://doi.org/10.1145/3498693) interprets them by the sets with at most one element.
A closed canonical type $`A_0`$ is a proposition when it is a term of a universe of propositions, and it is known by its truth $`\mathsf{true}(A_0)`$, which the kinds of declarations give for their instances in a universe of propositions; when it is true, all the closed terms are equal proofs of it, and when it is false, none is:

```math
\begin{aligned}
(A_0,\ A_0) \in \mathsf{eq}(\Omega_k) \text{ and } \mathsf{true}(A_0) &\implies \mathsf{eq}(A_0) = \{(t,\ u) \mid t \text{ and } u \text{ are closed terms}\} &&(\mathsf{eq}_{\mathsf{true}}) \\
(A_0,\ A_0) \in \mathsf{eq}(\Omega_k) \text{ and not } \mathsf{true}(A_0) &\implies \mathsf{eq}(A_0) = \varnothing &&(\mathsf{eq}_{\mathsf{false}})
\end{aligned}
```

A proof carries no information but the truth of its proposition, so that it need not compute, as the proofs of Pujet and Tabareau have no reduction: for a type that computes to a proposition, this relation holds between the terms themselves:

```math
\begin{aligned}
\text{if } A \text{ computes to a proposition, then } \Sigma \vDash t \equiv u : A &\iff \Sigma \vDash A \text{ and } \exists A_0.\ A \Downarrow A_0 \text{ and } (t,\ u) \in \mathsf{eq}(A_0) &&(\vDash_{\equiv\Omega})
\end{aligned}
```

A variable of a proposition then stands for any closed term, which may not compute, so that no computation of a term whose type is not a proposition may wait for a proof to compute: a proof is only used to build other proofs, or eliminated without being inspected.

The universes of propositions are canonical types of the universes, and $`\mathsf{eq}(\Omega_n)`$ is the least relation that the clauses of the kinds of declarations define for their instances in $`\Omega_n`$, as for the universes; two propositions are then equal types when they are both true or both false:

```math
\begin{aligned}
(\Omega_k,\ \Omega_k) \in \mathsf{eq}(U_n) &\quad \text{if } k + 1 = n &&(\mathsf{eq}_\Omega)
\end{aligned}
```

The clauses of a kind relate the entries of its instances in the sorts that $`s_n`$ bounds: in $`s_n`$ itself, which the least relation allows, and in $`\Omega_n`$ for an instance in $`U_n`$, whose relation is defined together with $`\mathsf{eq}(U_n)`$, since the arguments of a proposition may be types of $`U_n`$, as the entries of a type of $`U_n`$ may be propositions.
Both relations are thus defined together, at each level, by a single inductive definition, and the equality of the terms of each type they relate by recursion on the clauses that relate it, as the setoid model of Pujet and Tabareau defines its universes of relevant types and of propositions together by induction-recursion, under an induction on their level.

The denotation is exact for the proofs: two closed terms are equal proofs of a proposition in this meaning exactly when each of them is a proof of it, as the rule $`(\mathsf{irr})`$ says, which is then sound, as the rules $`(\Omega)`$, $`(\Omega_\equiv)`$, $`(\Omega_{\mathsf{type}})`$ and $`(\Omega_{\mathsf{type}\equiv})`$ are:

```math
\begin{aligned}
& \Sigma \vDash A : \Omega_k &&(\mathsf{exact}_\Omega) \\
\implies {}& \Sigma \vDash t \equiv u : A \iff \Sigma \vDash t : A \text{ and } \Sigma \vDash u : A
\end{aligned}
```

#### Soundness

The rules are sound for this meaning: every judgment they derive is true, under the hypothesis $`(\mathsf{hyp}_\iota)`$ that every constant of the signature is interpreted, which the [properties](#consistency-and-canonicity) define:

```math
\begin{aligned}
(\mathsf{hyp}_\iota) \text{ and } \vdash \Sigma &\implies \vDash \Sigma &&(\mathsf{sound}_{\mathsf{sig}}) \\
(\mathsf{hyp}_\iota) \text{ and } \Sigma \vdash \Gamma &\implies \Sigma \vDash \Gamma &&(\mathsf{sound}_{\mathsf{ctx}}) \\
(\mathsf{hyp}_\iota) \text{ and } \Sigma;\ \Gamma \vdash A &\implies \Sigma;\ \Gamma \vDash A &&(\mathsf{sound}_{\mathsf{type}}) \\
(\mathsf{hyp}_\iota) \text{ and } \Sigma;\ \Gamma \vdash A \equiv B &\implies \Sigma;\ \Gamma \vDash A \equiv B &&(\mathsf{sound}_{\mathsf{type}\equiv}) \\
(\mathsf{hyp}_\iota) \text{ and } \Sigma;\ \Gamma \vdash t : A &\implies \Sigma;\ \Gamma \vDash t : A &&(\mathsf{sound}) \\
(\mathsf{hyp}_\iota) \text{ and } \Sigma;\ \Gamma \vdash t \equiv u : A &\implies \Sigma;\ \Gamma \vDash t \equiv u : A &&(\mathsf{sound}_\equiv)
\end{aligned}
```

The rules are not complete, since a true judgment need not be derivable: a term that computes to a term of a type without reaching an ill-typed part is a term of the type in this meaning but not by the rules, and the truth of a judgment is not decidable, since it asks whether a computation ends; both need terms that compute, which the kinds of declarations bring, so the [data and codata types](https://github.com/sic-lang/rfcs/pull/34) state them as formulas.

### Properties

The properties below are not rules: they follow from the rules of the core and of the kinds of declarations, each a named formula or a named statement, which the formalization of the core has to prove, under the obligations that the [contract](#the-contract-of-a-kind-of-declaration) puts on each kind.
The reduction $`t \longrightarrow u`$ is the weak head reduction of the [conversion](#conversion), and $`t \longrightarrow_\beta u`$ its steps that are computations $`\beta`$ or unfoldings $`\delta`$, as opposed to the steps that the extensionalities add.

#### Admissible Properties

The following properties are admissible: they are proved by induction on the derivations.

- Context conversion: a judgment still holds when the type of a declaration of its context is replaced by an equal type.
- Level instantiation: a judgment still holds when its level variables are replaced by levels, so that a definition checked once with its level variables is used at any levels, as the [level variables](#level-variables) require.
- Presuppositions: every judgment implies that its signature and its context are well formed, a typing $`\Sigma;\ \Gamma \vdash t : A`$ implies $`\Sigma;\ \Gamma \vdash A`$, and an equality implies that both its sides are types, or terms of its type.
- Second-order substitution: a judgment still holds when an abstraction of the type of a second-order variable instantiates it, and a usage with the usage of the abstraction scaled by the grade of the variable, when the abstraction uses each variable of the telescope within its grade $`p`$.
- Substitution: a judgment still holds when terms of the types of its variables are substituted for them, and equal terms substituted give equal results; a usage still holds with the usages of the substituted terms, each scaled by the grade of its variable, added together.
- Types in sorts: every type is a term of a [sort](#letters), since the rules that make the terms of a sort types are the only rules that conclude $`\Sigma;\ \Gamma \vdash A`$.
- Weakening: a judgment still holds in a well-formed context that extends its own, and in a well-formed signature that extends its own.

#### Preservation

A term keeps its type when it reduces, and its usage when it reduces by a computation or an unfolding:

```math
\begin{aligned}
\Sigma;\ \Gamma \vdash t : A \text{ and } t \longrightarrow u &\implies \Sigma;\ \Gamma \vdash u : A \text{ and } \Sigma;\ \Gamma \vdash t \equiv u : A &&(\mathsf{subject}) \\
\Sigma;\ \gamma \mathrel{▶_m} t \text{ and } t \longrightarrow_\beta u &\implies \Sigma;\ \gamma \mathrel{▶_m} u &&(\mathsf{usage}_\beta)
\end{aligned}
```

The evaluation of a closed program uses the computations and the unfoldings only, so that it keeps the usage of the program; the steps that the extensionalities add belong to the conversion, which carries no grade, and need not keep it: an equality by $`\eta`$ may use its variables differently on its two sides, and the usage of a program is checked on the program as written.

#### Normalization and Decidability

Every well-typed term reduces to a weak head normal form, and the equality and the typing are decidable:

```math
\begin{aligned}
\Sigma;\ \Gamma \vdash t : A &\implies \exists v.\ t \longrightarrow^{*} v \text{ and } v \text{ is a head normal form} &&(\mathsf{normal}) \\
& \Sigma;\ \Gamma \vdash t \equiv u : A \text{ is decidable,} &&(\mathsf{decidable}_\equiv) \\
& \quad \text{given } \Sigma;\ \Gamma \vdash t : A \text{ and } \Sigma;\ \Gamma \vdash u : A \\
& \vdash \Sigma,\ \Sigma \vdash \Gamma,\ \Sigma;\ \Gamma \vdash t : A \text{ and } \Sigma;\ \gamma \mathrel{▶_m} t \text{ are decidable} &&(\mathsf{decidable}_\vdash)
\end{aligned}
```

The decidability of typing needs the terms to determine their types, which the kinds of declarations ensure by making their terms carry the types they need, as the instance that a constructor carries, and the decidability of usage needs the greatest usage of a term to be computable, which the [grades](https://github.com/sic-lang/rfcs/pull/33) ensure by their greatest lower bounds.

#### Consistency and Canonicity

The signature assumes its constants, so the properties that depend on what the terms compute hold under named hypotheses.
A signature is consistent when some closed proposition has no proof; by soundness, it suffices that the meaning interprets every constant, which the following hypothesis on the signature $`\Sigma`$ and its interpretation $`\iota`$ names, the two being the parameters of the hypothesis rather than its variables:

```math
\begin{aligned}
& \text{an interpretation } \iota \text{ gives each constant } c.\{\bar s;\ \bar l;\ \bar p\} :_{m} A \text{ of } \Sigma &&(\mathsf{hyp}_\iota) \\
& \quad \text{a closed term with } \Sigma \vDash \iota(c) : A \\
& (\mathsf{hyp}_\iota),\ \Sigma \vDash A,\ A \Downarrow A_0 \text{ and } \mathsf{eq}(A_0) = \varnothing &&(\mathsf{consistent}) \\
\implies {}& \Sigma;\ \varepsilon \nvdash t : A \text{ for every } t
\end{aligned}
```

An axiom in $`\Omega_l`$ keeps the signature consistent when the axioms are jointly true in the meaning, and a foreign constant when some term of the core has its type: a foreign constant of a type without canonical terms makes every type inhabited.
Axioms in a universe of propositions do not threaten normalization, since their proofs need not compute, as [Pujet and Tabareau](https://doi.org/10.1145/3498693) note of any consistent proof-irrelevant axiom.

A closed term computes to a canonical term when it depends on no relevant constant, a constant without a body whose type is not a proposition, after the definitions are unfolded:

```math
\begin{aligned}
& \Sigma;\ \varepsilon \vdash t : A \text{ and no relevant constant occurs in } t &&(\mathsf{canonical}) \\
& \quad \text{once its definitions are unfolded} \\
\implies {}& \exists v.\ t \Downarrow v
\end{aligned}
```

A term that depends on a foreign constant computes as far as the constant, which the program that runs gets from outside, and a term that depends on a ghost constant is itself a ghost term, which the program that runs never computes.

#### Erasure Properties

The erasure of a program is sound: a program and its extraction compute the same canonical term, under the hypothesis, on the signature $`\Sigma`$ as its parameter, that the implementation of each foreign constant respects its type and its grades:

```math
\begin{aligned}
& \text{the implementation of each foreign constant } c \text{ of } \Sigma \text{ computes,} &&(\mathsf{hyp}_\bullet) \\
& \quad \text{on extracted arguments of its type, the extraction of a term} \\
& \quad \text{of its result type, using each argument as its grade allows} \\
& (\mathsf{hyp}_\bullet),\ \Sigma;\ \varepsilon \vdash t : A,\ \Sigma;\ \mathbb{0}^{\mathsf{c}} \mathrel{▶_{\mathbb{1}\mathbb{1}^{\mathsf{m}}}} t \text{ and } t \Downarrow v &&(\mathsf{sound}_\bullet) \\
\implies {}& t^\bullet \Downarrow v^\bullet
\end{aligned}
```

The target computes by the weak head reduction that the clauses of the kinds of declarations give it, so that the property depends on no evaluation order; a program whose extraction runs in another order computes the same canonical term, since the core is total, which the RFC of the calling convention has to show for the order it chooses.

A variable without use at run time is absent from the extraction, and a variable without any use from the ghost program, which gives the total multiplicity its meaning: a proof cannot duplicate or drop a permission counted once in total, since the permission occurs in the proof and the proof is checked for it:

```math
\begin{aligned}
\Sigma;\ \gamma \mathrel{▶_m} t \text{ and } \mathsf{run}(\gamma(x)) = 0 &\implies x \text{ does not occur in } t^\bullet &&(\mathsf{absent}_\bullet) \\
\Sigma;\ \gamma \mathrel{▶_m} t \text{ and } \gamma(x) = \mathbb{0} &\implies x \text{ does not occur in } t^\circ &&(\mathsf{absent}_\circ) \\
t^\bullet &= (t^\circ)^\bullet &&(\bullet_\circ)
\end{aligned}
```

#### Projection Lemma

A derivation of usage in the three modes projects on a derivation in the two modes of ADE, with the run-time multiplicities for grades, which the [grades](https://github.com/sic-lang/rfcs/pull/33) define as the homomorphism $`\mathsf{run}`$; the projection $`\Sigma^{\mathsf{run}}`$ of a signature replaces each grade of its entries by its run-time multiplicity, and $`\gamma^{\mathsf{run}}`$ does so in a vector:

```math
\begin{aligned}
\Sigma;\ \gamma \mathrel{▶_m} t &\implies \Sigma^{\mathsf{run}};\ \gamma^{\mathsf{run}} \mathrel{▶_{\mathsf{run}(m)}} t \text{ in the two modes of ADE,} &&(\mathsf{project}) \\
& \quad \text{with the same } t^\bullet
\end{aligned}
```

The mode $`\mathbb{0}\mathbb{1}^{\mathsf{m}}`$ thus changes nothing to what runs: the soundness of erasure for the three modes follows from the one for the two modes of ADE, which their formalization proves for their types, once each kind of declaration shows that its rules of usage project, as its contract requires.

### Examples

The examples of this RFC are its annexes: the files of the directory that bears the name of this file, one file per example.
Each annex derives its formulas from the rules of this RFC, of which they are not part.

## Drawbacks

- Every entry of a telescope carries two grades, among seven, checked in three modes: the core is precise but heavy, and the surface language has to infer most grades, which no RFC designs yet.
- The terms of the core carry the types they need, such as the instance that a constructor carries, so that their types are determined; they are meant to be checked, not written by hand.
- The core alone types no program: every type comes from a kind of declaration, so that the core is read together with the RFC of at least one kind, and its properties are proved kind by kind, under the obligations of the contract.
- Without cumulativity, code polymorphic in its universes writes its levels and their joins explicitly, as in Agda and Lean.
- Without impredicative propositions, the encodings that quantify a proposition over all propositions, which Lean and Rocq accept, are not available.
- Definitions are transparent: a library cannot hide the body of a definition from the conversion, until the modules of a later RFC give a way to hide it.
- The core departs from ADE by its three modes, its strict propositions, its declarations, its definitions and constants, and its level variables, so their proofs do not carry over as they are, and redoing them is a large effort.

## Rationale and Alternatives

- Typing and equality carry no grade, as in ADE, instead of carrying them in the typing judgment as [graded modal dependent type theory](https://arxiv.org/abs/2010.13163) (GrTT, Moon, Eades and Orchard) does.
  GrTT checks every subterm as if it ran, even in an erased position: a specification cannot return an erased field, and a field that does not exist at run time has no observation.
  The usage judgment of ADE, indexed by a mode, checks an erased subterm in a mode of its own, and its metatheory is formalized.
  Equality then compares values, not uses, which removes no guarantee: it only compares types, and the usage of every term is checked.
- The judgments are the four of Martin-Löf type theory, as in ADE and in [Abel, Öhman and Vezzosi](https://doi.org/10.1145/3158111), rather than those of a [pure type system](https://en.wikipedia.org/wiki/Pure_type_system), where a type is a term of a sort and two types are equal as terms of a sort only.
  Two equalities of types in different sorts would then compose only if the two sorts were shown equal, which needs the uniqueness of the type of a term, and thus the injectivity of the declared types for equality: this injectivity follows from the normalization that the formalization has to prove, which itself needs a transitive equality of types.
  The formalization has to show, from normalization, that two equal types are also equal terms of a sort, so that the equality of types adds no equality to those of the sorts.
  The equality of types has its own rules of reflexivity and symmetry, which follow from the other rules, so that the equalities of types and of terms have the same rules, as in the presentation of Nordström, Petersson and Smith.
  A type is still always a term of a sort, unlike in ADE, whose type of levels may lie in no universe, so that the rules that need the level of a type check its sort, and the others check that it is a type.
- The signature is explicit in every judgment, as the global environment $`E[\Gamma]`$ of [Rocq](https://rocq-prover.org/doc/master/refman/language/cic.html), rather than ambient: a rule says which entries it reads, and a judgment is checked against one signature, which the properties quantify over.
- The core names no concrete type, and states a contract instead, so that one framework serves every kind of declaration: the [data and codata types](https://github.com/sic-lang/rfcs/pull/34) bring the functions, the records, the sums, the natural numbers and the streams as declarations, and the [observational equality](https://github.com/sic-lang/rfcs/pull/35) brings the equality and the quotients.
  Built-in types would each need their own rules, meaning and erasure, which the contract asks once; the price is a contract of eight items, which every kind has to fulfill.
- Every term determines its type: the terms of the kinds of declarations carry the types they need, as the instance that a constructor carries, so that the type of a term is computed from the term alone, without the bidirectional checking that ADE need for their abstractions; the terms of the core are checked, not written by hand, and the language infers what they carry.
- Declarations are blocks with a shared header, so that a block of one type and a block of several are checked by one rule of the signature, and the types of a block share their parameters and their sort, as the mutual inductive types of [Lean](https://lean-lang.org/doc/reference/latest/The-Type-System/Inductive-Types/#mutual-inductive-types) share their parameters and their universe; what a type may say of the others is left to the kind, which alone knows the bodies.
- The sort of a declaration may be the join of two sorts, as its level may be the join of two levels: the [data and codata types](https://github.com/sic-lang/rfcs/pull/34) need it for the declarations of their prelude, whose pair holds two fields of independent sorts.
  The sort constraints of the [bounded sort polymorphism](https://rocq-prover.org/doc/master/refman/addendum/universe-polymorphism.html) of Rocq would be one mechanism more, used by the prelude only, and two pairs, one for each sort of their second field, a special case; the join is checked as every sort variable is, instance by instance.
- Definitions are entries of the signature with a mode, rather than let-bindings in terms or inlining: a definition is checked once, with its prenex sort, level and grade variables, and used in the modes it allows, as the modes of [Verus](https://doi.org/10.1145/3586037) separate specifications, proofs and executable code, so that a proof may call a specification and a program may not call a ghost; inlining would check each use again and lose the prenex polymorphism.
  Definitions are transparent: an opaque definition would hide a body from the conversion, which the strict propositions already do for proofs, and which the modules of a later RFC may do for terms.
- Constants without a body cover the axioms, the ghost constants and the foreign functions with one mechanism, told apart by their sort and their mode, rather than three: each is a typed hypothesis, and the properties say what each kind of constant costs, as named hypotheses.
  Primitive types with built-in rules, as the primitive integers and arrays of [Rocq](https://rocq-prover.org/doc/master/refman/language/core/primitive.html), would add rules of their own to the core; here a foreign type is a constant whose representation the implementation chooses, as long as the conversion is unchanged.
- The erasure is a translation that depends on no evaluation order, and its soundness is stated on the computation of the type theory: the guarantees of the core, consistency, normalization, canonicity, the preservation of usage and the absence of the erased variables, hold whatever the order, since the core is total.
  The costs, the order of the foreign effects and the evaluation of the parts of a term that are taken one at a time belong to the RFC of the calling convention, whose direction is the call-by-push-value of [Levy](https://doi.org/10.1007/978-94-007-0954-6), by polarity, as [Downen, Sullivan, Ariola and Peyton Jones](https://doi.org/10.1007/978-3-030-17184-1_5) evaluate data by value and codata on observation; that RFC has to check again, on the machine it chooses, the resource correctness of the usage of recursion, which [Eriksson, Abel and Danielsson](https://doi.org/10.1145/3828677) prove for a call-by-name machine.
- Conscious exclusions, each with what is lost, what remains, and whether it can be added later:
  - Impredicative propositions: a proposition cannot quantify over all propositions; the levels give the quantifications over the propositions of a lower level, which cover the usual encodings, and the sort variables give one declaration for all of them.
    With definitional irrelevance, impredicativity makes the conversion undecidable, as [Abel and Coquand](https://doi.org/10.23638/LMCS-16(2:14)2020) show, so it is excluded rather than deferred.
  - Cumulativity: a type of $`U_l`$ is not a type of $`U_{l + 1}`$, and a term is lifted by a declared type of one entry; it is deferred, since adding it later only accepts more programs, at the cost of a subtyping in the conversion.
  - Quantification over levels: no type quantifies over levels, so that there is no universe beyond the hierarchies, as the $`\mathsf{Set}\omega`$ of Agda; the prenex level variables of the definitions and of the declarations give the polymorphism that programs need.

## Prior Art

- The graded type theory of [Abel, Danielsson and Eriksson](https://doi.org/10.1145/3607862), extended in their [journal version](https://arxiv.org/abs/2603.29716) and [formalized in Agda](https://github.com/graded-type-theory/graded-type-theory), is the base of this RFC: typing without grades, usage indexed by modes, and the soundness of erasure.
  Its formalization extends the proof of decidability of conversion of [Abel, Öhman and Vezzosi](https://doi.org/10.1145/3158111), and [Danielsson, Favier and Kubánek](https://doi.org/10.1145/3776645) add universe levels to it.
- Grades on binders come from [McBride](https://doi.org/10.1007/978-3-319-30936-1_12) and the quantitative type theory of [Atkey](https://doi.org/10.1145/3209108.3209189), which [Idris 2](https://arxiv.org/abs/2104.00480) implements with the multiplicities $`0`$, $`1`$ and $`\omega`$, and threads its effects through a linear world token, as the foreign constants here consume a capability.
- The [graded modal dependent type theory](https://arxiv.org/abs/2010.13163) of Moon, Eades and Orchard carries grades in typing, and [Granule](https://doi.org/10.1145/3341714) is a language built on graded modal types.
- The strict propositions follow the `Prop` of [Agda](https://agda.readthedocs.io/en/latest/language/prop.html) and the `SProp` of Rocq, both from [Gilbert, Cockx, Sozeau and Tabareau](https://doi.org/10.1145/3290316); [Pujet and Tabareau](https://doi.org/10.1145/3498693) build their observational equality on them, and interpret them by the sets with at most one element.
- The universes follow [Lean](https://lean-lang.org/doc/reference/latest/The-Type-System/Universes/) for prenex polymorphism and Agda for a predicative hierarchy without cumulativity; the sort variables follow the [sort polymorphism of Rocq](https://rocq-prover.org/doc/master/refman/addendum/universe-polymorphism.html).
- The signature follows the global environment of [Rocq](https://rocq-prover.org/doc/master/refman/language/cic.html), an ordered list of declarations, definitions and assumptions, and the second-order parameters follow the contextual modal type theory of [Nanevski, Pfenning and Pientka](https://doi.org/10.1145/1352582.1352591).
- [Verus](https://doi.org/10.1145/3586037) separates the code that runs from the specifications and proofs by [modes of variables](https://verus-lang.github.io/verus/guide/reference-var-modes.html), as the modes of the definitions here, and tracks ghost resources linearly, which the grades `none / linear` and `linear / unrestricted` express.
- The meaning follows the [meaning explanations](https://doi.org/10.1016/S0049-237X(09)70189-2) of Martin-Löf, as [Nordström, Petersson and Smith](https://intuitionistic.wordpress.com/wp-content/uploads/2010/07/nordstrom-et-al-type-theory.pdf) present them.

## Unresolved Questions

- Which word names the strict propositions in the language, given that `Prop` is impredicative in Lean and Rocq?
- Does definitional proof irrelevance keep the metatheory of a graded type theory?
  Abel, Danielsson and Eriksson note that their framework cannot model it, and the normalization of [Pujet and Tabareau](https://doi.org/10.1145/3498693) covers a theory without grades.
