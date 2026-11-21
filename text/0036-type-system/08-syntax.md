# Syntax

This annex defines the terms of the type system, their arguments, the telescopes, the contexts and the signatures, with the variables that each of them binds, the parameters themselves of a context, and the value of the ownership of the result of a second-order variable, then the nesting of the types, the recursive fields and destructors of a block, and the cases of the constructors and of the destructors in their block, which are read on the syntax.
It builds on the [grades](04-grades.md), the [modes](05-modes.md), the [levels](06-levels.md) and the [sorts](07-sorts.md).

## Definitions

This section defines the objects in the order in which they build on each other: the variables and their scopes, the terms and their arguments, the telescopes and the contexts, then the entries of the signatures, and then the nesting of the types, the recursive fields and destructors of a block, and the cases.

### Variables

A variable is named, and an object that binds variables is the same object whatever names its bound variables take, as long as they stay distinct from the names it uses free.
A variable has a telescope, whose entries say how many arguments the variable is applied to: a variable $`x : A`$ of a context has an empty one, and a second-order variable $`{X : (\Theta \vdash A \mathrel{◀} \psi)}`$ has $`\Theta`$, so that it stands for a term of type $`A`$ under the variables of $`\Theta`$, as the contextual types of [Nanevski, Pfenning and Pientka](https://doi.org/10.1145/1352582.1352591) do for their metavariables.

The scope of a term is the sequence of the variables it may use, each with its signature: the grades $`{p_1, \dots, p_k}`$ and the requirements $`{r_1, \dots, r_k}`$ of the entries of its telescope, and the ownership $`\psi`$ of its result, with which the usage and the ownership of an application of the variable read its arguments.
A term uses only the variables of its scope, each applied to an argument for each entry of its telescope.

### Terms

A term in a scope is one of thirteen cases:

```math
\begin{aligned}
& {\mathrel{::=}} &&(\mathsf{syntax}_t) \\
& \quad t \\
& \quad {\mid} \\
& \qquad x[\bar t] \\
& \qquad \kappa \\
& \qquad f.\{\bar s;\ \bar l;\ \bar p\} \\
& \qquad D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a \\
& \qquad (D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a).c(\bar t) \\
& \qquad \mathsf{rec}_{r;\ \varsigma;\ \chi}\ (D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a)\ t\ \mathsf{return}\ \bar C : \kappa_C\ \mathsf{with}\ \bar u \\
& \qquad t.((D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a).d)(\bar t) \\
& \qquad \mathsf{corec}_r\ (D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a)\ \mathsf{from}\ \bar t\ \mathsf{return}\ \bar\Theta\ \mathsf{with}\ \bar g \\
& \qquad t \mathrel{{\sim}.\{s;\ l\}_A} u \\
& \qquad \mathsf{refl}.\{s;\ l\}_A(t) \\
& \qquad \mathsf{transp}(A,\ t_1,\ t_2,\ x.\, C,\ t,\ u) \\
& \qquad \mathsf{propext}.\{l\}(A,\ B,\ x.\, t,\ y.\, u) \\
& \qquad \mathsf{coind}(D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a,\ t_1,\ t_2,\ (x_1,\ x_2).\, \bar A,\ t,\ \bar g)
\end{aligned}
```

The cases are:

- A variable $`x`$ of the scope applied to arguments $`\bar t`$ in the scope, one for each entry of its telescope, written $`x[\bar t]`$, and $`x`$ alone when its telescope is empty.
- A sort $`\kappa`$.
- An instance $`{f.\{\bar s;\ \bar l;\ \bar p\}}`$ of the constant $`f`$, defined or declared, in which $`\bar s`$ are qualities, $`\bar l`$ levels and $`\bar p`$ grades, one for each variable of each kind of the entry.
- An instance $`{D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a}`$ of the declared type $`D`$, whose arguments $`\bar a`$ are in the scope, one for each parameter of its type declaration.
- A constructor $`c`$ of the data type of an instance $`{T = D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a}`$, applied to arguments $`\bar t`$, a term for each of its fields, written $`T.c(\bar t)`$: the constructor carries its instance, so that the term determines its type.
- A recursor $`{\mathsf{rec}_{r;\ \varsigma;\ \chi}\ T\ t\ \mathsf{return}\ \bar C : \kappa_C\ \mathsf{with}\ \bar u}`$, which eliminates the term $`t`$ of the instance $`{T = D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a}`$, used with the grade $`r`$, with motives $`\bar C`$ of the sort $`\kappa_C`$, one for each type of the block of $`t`$, and branches $`\bar u`$, one for each constructor of each type of the block, in the order of the declaration: the recursor carries the instance of the term it eliminates, so that its usage and its ownership read the grades and the requirements of the fields at this instance, the sort of its motives, and the ownerships $`\varsigma`$ and $`\chi`$ that it gives the liftings of the types of the nested fields of the block, the one that their destructors require of the value that they observe and the one of their results, so that the term determines the results of these fields.
- An observation $`t.(T.d)(\bar t)`$ of the term $`t`$ of the instance $`{T = D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a}`$ by its destructor $`d`$, applied to arguments $`\bar t`$, a term for each argument of the destructor, written $`t.(T.d)`$ when the destructor has no argument: the observation carries the instance of its term, as the recursor does, so that its usage and its ownership read the grades and the requirements of the destructor at this instance.
- A corecursor $`{\mathsf{corec}_r\ T\ \mathsf{from}\ \bar t\ \mathsf{return}\ \bar\Theta\ \mathsf{with}\ \bar g}`$, which builds a term of the instance $`{T = D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a}`$ from the state $`\bar t`$, used with the grade $`r`$, with states $`\bar\Theta`$, one for each type of the block of $`D`$, and branches $`\bar g`$, one for each destructor of each type of the block, in the order of the declaration: the corecursor carries its instance, as a constructor does, so that the term determines its type.
- An equality $`{t \mathrel{{\sim}.\{s;\ l\}_A} u}`$ of the terms $`t`$ and $`u`$ of the type $`A`$, whose sort has the quality $`s`$ and the level $`l`$: the equality carries the type of its terms and the quality and the level of the sort of this type, so that the term determines its type and its sort.
- A proof $`{\mathsf{refl}.\{s;\ l\}_A(t)}`$ of the equality of the term $`t`$ of the type $`A`$ with itself, which carries the type of its term and the quality and the level of the sort of this type, as the equality does, so that the term determines its type.
- A transport $`{\mathsf{transp}(A,\ t_1,\ t_2,\ x.\, C,\ t,\ u)}`$ of the term $`u`$ along the proof $`t`$ of the equality of the terms $`t_1`$ and $`t_2`$ of the type $`A`$, with the motive $`{x.\, C}`$, which binds the variable $`x`$, with an empty telescope, and whose term $`C`$ is in the scope extended by it: the transport carries the type and the two terms of the equality, so that the term determines its type.
- A proof $`{\mathsf{propext}.\{l\}(A,\ B,\ x.\, t,\ y.\, u)}`$ of the equality of the propositions $`A`$ and $`B`$ of the level $`l`$, from two terms, each over a new variable, the hypothesis, with an empty telescope: the term $`t`$, a proof of $`B`$ over a proof $`x`$ of $`A`$, and the term $`u`$, a proof of $`A`$ over a proof $`y`$ of $`B`$, each in the scope extended by its variable; the proof carries the level and the two propositions, so that the term determines its type.
- A proof $`{\mathsf{coind}(T,\ t_1,\ t_2,\ (x_1,\ x_2).\, \bar A,\ t,\ \bar g)}`$ by coinduction of the equality of the terms $`t_1`$ and $`t_2`$ of the instance $`{T = D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a}`$ of a codata type, with the relations $`\bar A`$, a term for each type of the block of $`D`$, the first one first, as the arguments $`\bar t`$ are, each a proposition in the scope extended by two new variables $`x_1`$ and $`x_2`$, with empty telescopes, the two terms that it relates, the proof $`t`$ that the relation of $`D`$ relates $`t_1`$ and $`t_2`$, and the branches $`\bar g`$ of the destructors, one for each destructor of each type of the block, in the order of the declaration, each over two terms of the type of its destructor, the hypothesis that its relation relates them and the arguments of the destructor: the proof carries its instance and its two terms, so that the term determines its type.

The levels of a term use only the level variables of the entry of the signature in which it appears, and none when it appears in no entry.

The arguments $`\bar t`$ of a telescope are a term for each of its entries, the first one first: they are either empty, written $`()`$, or an argument $`t`$ followed by arguments $`\bar t`$, written $`{(t,\ \bar t)}`$:

```math
\begin{aligned}
& \bar t \mathrel{::=} () \mid (t,\ \bar t) &&(\mathsf{syntax}_{\bar t})
\end{aligned}
```

The arguments $`\bar a`$ of an instance are an abstraction for each parameter, the last one last: they are either empty, written $`()`$, or arguments $`\bar a`$ followed by an abstraction $`{\bar x.\, B}`$, written $`{(\bar a,\ \bar x.\, B)}`$:

```math
\begin{aligned}
& \bar a \mathrel{::=} () \mid (\bar a,\ \bar x.\, B) &&(\mathsf{syntax}_{\bar a})
\end{aligned}
```

The abstraction for a parameter binds the variables $`\bar x`$, one for each entry of the telescope of the parameter, each with an empty telescope, and its term $`B`$ is in the scope extended by them; for a parameter with an empty telescope, $`\bar x`$ is empty and the abstraction is the term $`B`$.

The motives $`\bar C`$ of a recursor are a motive for each type of the block, the first one first: they are either empty, written $`()`$, or a motive $`{(\bar x,\ z).\, C}`$ followed by motives $`\bar C`$, written $`{((\bar x,\ z).\, C,\ \bar C)}`$:

```math
\begin{aligned}
& \bar C \mathrel{::=} () \mid ((\bar x,\ z).\, C,\ \bar C) &&(\mathsf{syntax}_{\bar C})
\end{aligned}
```

The motive of a type binds the variables $`\bar x`$, one for each non-uniform parameter of the type, and the variable $`z`$, the term eliminated, each with an empty telescope, and its term $`C`$ is in the scope extended by them.

The branches $`\bar u`$ of a recursor are a branch for each constructor, the first one first: they are either empty, written $`()`$, or a branch $`{(\bar x;\ \bar y \mathrel{▶} \bar e).\, u}`$ followed by branches $`\bar u`$, written $`{((\bar x;\ \bar y \mathrel{▶} \bar e).\, u,\ \bar u)}`$:

```math
\begin{aligned}
& \bar u \mathrel{::=} () \mid ((\bar x;\ \bar y \mathrel{▶} \bar e).\, u,\ \bar u) &&(\mathsf{syntax}_{\bar u})
\end{aligned}
```

The branch of a constructor binds the variables $`\bar x`$, one for each field of the constructor, then the variables $`\bar y`$, one for each recursive result, each with an empty telescope and with the grade $`e`$ of $`\bar e`$ with which the branch uses it, written $`{y_1 \mathrel{▶} e_1, \dots, y_n \mathrel{▶} e_n}`$, and its term $`u`$ is in the scope extended by them; the branch of the constructor $`c`$ of the type $`D`$ is written $`{D.c(\bar x;\ \bar y \mathrel{▶} \bar e) \Rightarrow u}`$, without the semicolon when it binds no recursive result.
The branch carries the grades of its recursive results, as a telescope carries the grades of its entries, so that the usage and the ownership read them.

The states $`\bar\Theta`$ of a corecursor are a state for each type of the block, the first one first: they are either empty, written $`()`$, or a state $`{\bar x.\, \Theta : \bar\kappa}`$ followed by states $`\bar\Theta`$, written $`{(\bar x.\, \Theta : \bar\kappa,\ \bar\Theta)}`$:

```math
\begin{aligned}
& \bar\Theta \mathrel{::=} () \mid (\bar x.\, \Theta : \bar\kappa,\ \bar\Theta) &&(\mathsf{syntax}_{\bar\Theta})
\end{aligned}
```

The state of a type binds the variables $`\bar x`$, one for each non-uniform parameter of the type, each with an empty telescope, and its telescope $`\Theta`$ is in the scope extended by them; it carries the sorts $`\bar\kappa`$ of the entries of $`\Theta`$, one for each entry, which the packing of the state needs and the telescope does not give.

The branches $`\bar g`$ of the destructors, those of a corecursor or of a proof by coinduction, are a branch for each destructor of each type of a block, the first one first: they are either empty, written $`()`$, or a branch $`{(\bar x;\ \bar y;\ \bar z).\, g}`$ followed by branches $`\bar g`$, written $`{((\bar x;\ \bar y;\ \bar z).\, g,\ \bar g)}`$:

```math
\begin{aligned}
& \bar g \mathrel{::=} () \mid ((\bar x;\ \bar y;\ \bar z).\, g,\ \bar g) &&(\mathsf{syntax}_{\bar g})
\end{aligned}
```

The branch of a destructor binds the variables $`\bar x`$, then the variables $`\bar y`$, then the variables $`\bar z`$, each with an empty telescope, and its term $`g`$ is in the scope extended by them; the branch of the destructor $`d`$ of the type $`D`$ is written $`{D.d(\bar x;\ \bar y;\ \bar z) \Rightarrow g}`$.
In a corecursor, $`\bar x`$ are a variable for each non-uniform parameter of the type of the destructor, $`\bar y`$ a variable for each entry of the state of this type and $`\bar z`$ a variable for each argument of the destructor, and $`g`$ is the result of the observation.
In a proof by coinduction, $`\bar x`$ is empty, $`\bar y`$ are a variable for each of two terms of the type of the destructor and a variable for the hypothesis that the relation of this type relates them, $`\bar z`$ a variable for each argument of the destructor, and $`g`$ is the proof that the observations of the two terms by the destructor are equal, or that the relation of the type of its result relates them if the destructor is recursive.

### Telescopes and Contexts

A telescope in a scope is either empty, written $`\varepsilon`$, or an entry followed by a telescope, written $`{(x : A \mathrel{▶} p;\ q \mathrel{◀} r,\ \Theta)}`$, in which $`A`$ is a term in the scope and $`\Theta`$ a telescope in the scope extended by $`x`$, with an empty telescope:

```math
\begin{aligned}
& \Theta \mathrel{::=} \varepsilon \mid (x : A \mathrel{▶} p;\ q \mathrel{◀} r,\ \Theta) &&(\mathsf{syntax}_\Theta)
\end{aligned}
```

The entry $`{x : A \mathrel{▶} p;\ q \mathrel{◀} r}`$ is used with the grade $`p`$, requires of its argument the ownership $`r`$, and its variable is used with the grade $`q`$ by the types after it; the grades of a telescope are the grades $`p`$ of its entries, in order, its requirements their ownerships $`r`$, and its parameters the grade and the requirement of each entry, in order, written $`{\bar p \mathrel{◀} \bar r}`$.

A context is either empty, written $`\varepsilon`$, or a context $`\Gamma`$ extended by a variable, written $`{\Gamma,\ x : A}`$, or by a second-order variable, written $`{\Gamma,\ X : (\Theta \vdash A \mathrel{◀} \psi)}`$, in which $`A`$ and $`\Theta`$ are in the scope of $`\Gamma`$, and in $`{X : (\Theta \vdash A \mathrel{◀} \psi)}`$, $`A`$ is in the scope of $`\Gamma`$ extended by the variables of $`\Theta`$:

```math
\begin{aligned}
& \Gamma \mathrel{::=} \varepsilon \mid \Gamma,\ x : A \mid \Gamma,\ X : (\Theta \vdash A \mathrel{◀} \psi) &&(\mathsf{syntax}_\Gamma)
\end{aligned}
```

The ownership $`\psi`$ of the result of $`{X : (\Theta \vdash A \mathrel{◀} \psi)}`$ is the meet of a grade $`\chi_0`$, its constant, and of factors $`{x_j \cdot \chi_j}`$, each scaling a variable $`x_j`$ of $`\Theta`$ by its coefficient $`\chi_j`$; the constant and each factor are optional, each variable has one factor at most, in the order of $`\Theta`$, and the factor $`{x_j \cdot {11}^{\mathsf{p}}}`$ is written $`x_j`$:

```math
\begin{aligned}
& {\mathrel{::=}} &&(\mathsf{syntax}_\psi) \\
& \quad \psi \\
& \quad {\mid} \\
& \qquad \chi_0 \wedge x_{j_1} \cdot \chi_{j_1} \wedge \dots \wedge x_{j_n} \cdot \chi_{j_n} \\
& \qquad x_{j_1} \cdot \chi_{j_1} \wedge \dots \wedge x_{j_n} \cdot \chi_{j_n} \\
& \quad \text{if}\ j_1 < \dots < j_n
\end{aligned}
```

The variables $`x_j`$ stand for the ownerships of the arguments of $`X`$, and $`\psi`$ for the ownership of its result: $`X`$ stands for a term whose value, given arguments of these ownerships, has the ownership $`\psi`$.

The value of the ownership $`\psi`$ of the result of a second-order variable, given the ownerships $`\bar o`$ of its arguments, written $`\psi[\bar o / \bar x]`$ where $`\bar x`$ are the variables of its telescope, is the meet of its constant and of its factors, each variable taking the ownership of its argument.
The constant and the factors being optional, the value may be undefined: a meet with an undefined operand is its other operand, and an absent constant is undefined.
The variables are read in order, and $`\psi'`$ is $`\psi`$ without the factor of $`x`$:

```math
\begin{aligned}
& \psi[(o,\ \bar o) / (x,\ \bar x)] = o \cdot \chi \wedge \psi'[\bar o / \bar x] \text{ if } x \text{ has the coefficient } \chi \text{ in } \psi &&(\mathsf{value}_\psi) \\
& \psi[(o,\ \bar o) / (x,\ \bar x)] = \psi[\bar o / \bar x] \\
& \psi[\bar o / \bar x] = \chi_0 \text{ otherwise}
\end{aligned}
```

The scope of a context is its variables, the last one last, each with its signature.
A variable $`x : A`$ and a second-order variable $`{X : (\varepsilon \vdash A \mathrel{◀} \psi)}`$ both have an empty telescope, and only their entries in the context tell them apart.

The parameters themselves $`\bar x_\Delta`$ of a context $`\Delta`$, the parameters of a type declaration, are the arguments of an instance that give each parameter itself: the variable $`x`$ for a parameter $`x : A`$, and the abstraction $`{\bar x.\, X[\bar x]}`$ for a second-order parameter $`{X : (\Theta \vdash A \mathrel{◀} \psi)}`$, which applies it to the variables $`\bar x`$ of its telescope, so that an instance at them is the type at its own parameters:

```math
\begin{aligned}
& \bar x_\varepsilon = () &&(\mathsf{args}_\Delta) \\
& \bar x_{(\Delta,\ x : A)} = (\bar x_\Delta,\ x) \\
& \bar x_{(\Delta,\ X : (\Theta \vdash A \mathrel{◀} \psi))} = (\bar x_\Delta,\ \bar x.\, X[\bar x]) \\
& \quad \text{where } \bar x \text{ are the variables of } \Theta
\end{aligned}
```

### Entries and Signatures

An entry of a signature has sort variables, level variables and grade variables, and an instance of its sort and grade variables gives a quality to each sort variable and a grade to each grade variable.
The sort and grade variables are not part of the terms: since an entry is checked for each instance of them, its type, its body, its parameters and its sort are given for each instance, written with the variables as a rule is written with the variables of its fraction, so that the terms carry qualities and grades only.
The level variables are part of the terms, since an entry is checked once with them.
A type declaration also has a constraint $`C`$, any predicate on the instances of its sort and grade variables, which are finitely many, that gives the instances at which its types exist.

An entry is one of three cases, the last of which, a type declaration $`\mathcal{D}`$, is a block of data types or a block of codata types:

```math
\begin{aligned}
& {\mathrel{::=}} &&(\mathsf{syntax}_e) \\
& \quad e \\
& \quad {\mid} \\
& \qquad f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \mathrel{≔} t \\
& \qquad f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \\
& \qquad \mathcal{D} \\[1em]
& {\mathrel{::=}} &&(\mathsf{syntax}_{\mathcal{D}}) \\
& \quad \mathcal{D} \\
& \quad {\mid} \\
& \qquad \mathsf{data}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa \\
& \qquad \quad \mathsf{where} \\
& \qquad \qquad D_1 \mathrel{▶} \zeta_1 \oplus \Pi_1 \mathrel{≔} \\
& \qquad \qquad \quad c_{11} : \Theta_{11} \mid \dots \mid c_{1 n_1} : \Theta_{1 n_1}; \\
& \qquad \qquad \dots; \\
& \qquad \qquad D_k \mathrel{▶} \zeta_k \oplus \Pi_k \mathrel{≔} \\
& \qquad \qquad \quad c_{k1} : \Theta_{k1} \mid \dots \mid c_{k n_k} : \Theta_{k n_k} \\
& \qquad \mathsf{codata}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa \\
& \qquad \quad \mathsf{where} \\
& \qquad \qquad D_1 \mathrel{▶} \zeta_1 \oplus \Pi_1 \mathrel{≔} \\
& \qquad \qquad \quad {\mid} \\
& \qquad \qquad \qquad d_{11} : (\Theta_{11} \vdash B_{11} \mathrel{◀} \psi_{11}) \mathrel{▶} p_{11};\ q_{11} \mathrel{◀} \varsigma_{11} \\
& \qquad \qquad \qquad \dots \\
& \qquad \qquad \qquad d_{1 n_1} : (\Theta_{1 n_1} \vdash B_{1 n_1} \mathrel{◀} \psi_{1 n_1}) \mathrel{▶} p_{1 n_1};\ q_{1 n_1} \mathrel{◀} \varsigma_{1 n_1}; \\
& \qquad \qquad \dots; \\
& \qquad \qquad D_k \mathrel{▶} \zeta_k \oplus \Pi_k \mathrel{≔} \\
& \qquad \qquad \quad {\mid} \\
& \qquad \qquad \qquad d_{k1} : (\Theta_{k1} \vdash B_{k1} \mathrel{◀} \psi_{k1}) \mathrel{▶} p_{k1};\ q_{k1} \mathrel{◀} \varsigma_{k1} \\
& \qquad \qquad \qquad \dots \\
& \qquad \qquad \qquad d_{k n_k} : (\Theta_{k n_k} \vdash B_{k n_k} \mathrel{◀} \psi_{k n_k}) \mathrel{▶} p_{k n_k};\ q_{k n_k} \mathrel{◀} \varsigma_{k n_k}
\end{aligned}
```

The cases are:

- A constant definition $`{f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \mathrel{≔} t}`$, which defines the constant $`f`$ and has sort variables $`\bar s`$, level variables $`\bar l`$, grade variables $`\bar p`$, the mode $`m`$ in which its body is checked, the ownership $`p`$ of its value, which its body must have, and, for each instance of $`\bar s`$ and $`\bar p`$, a type $`A`$ and a body $`t`$ in the empty scope.
- A constant declaration $`{f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p}`$, which declares the constant $`f`$ and has the same form without a body, whose mode $`m`$ is the mode of its uses, and whose ownership $`p`$, which no body checks, is the one of the value it stands for.
- A type declaration $`{\mathsf{data}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \oplus \Pi_1 \mathrel{≔} \dots;\ \dots;\ D_k \mathrel{▶} \zeta_k \oplus \Pi_k \mathrel{≔} \dots}`$, a block of data types declared together, which has sort, level and grade variables, the constraint $`C`$ on the instances of its sort and grade variables, the names $`{D_1, \dots, D_k}`$ of its types, and, for each instance of $`\bar s`$ and $`\bar p`$ that $`C`$ admits, the parameters $`\Delta`$, a context, the sort $`\kappa`$ of its types and their bodies: each type $`D_j`$ has the grades $`\zeta_j`$ with which it uses the parameters, a vector of grades over the scope of $`\Delta`$, the set $`\Pi_j`$ of the parameters of $`\Delta`$ in which it is strictly positive, the same at every instance, and its constructors $`{c_{j1}, \dots, c_{j n_j}}`$, in order, and each constructor $`c_{ji}`$ the telescope $`\Theta_{ji}`$ of its fields, in the scope of $`\Delta`$.
- A type declaration $`{\mathsf{codata}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \oplus \Pi_1 \mathrel{≔} \dots;\ \dots;\ D_k \mathrel{▶} \zeta_k \oplus \Pi_k \mathrel{≔} \dots}`$, a block of codata types declared together, which has the same form, except that each type $`D_j`$ has destructors $`{d_{j1}, \dots, d_{j n_j}}`$, in order, rather than constructors: the destructor $`{d_{ji} : (\Theta_{ji} \vdash B_{ji} \mathrel{◀} \psi_{ji}) \mathrel{▶} p_{ji};\ q_{ji} \mathrel{◀} \varsigma_{ji}}`$ has the telescope $`\Theta_{ji}`$ of its arguments and its result type $`B_{ji}`$, in the scope of $`\Delta`$ extended by the destructors before it and, for $`B_{ji}`$, by the variables of $`\Theta_{ji}`$; its result has the ownership $`\psi_{ji}`$ and is used with the grade $`p_{ji}`$, and the destructor is used with the grade $`q_{ji}`$ by the types of the destructors after it, in whose scope it is a second-order variable $`{d_{ji} : (\Theta_{ji} \vdash B_{ji} \mathrel{◀} \psi_{ji})}`$, so that a destructor may depend on the observations before it; the destructor requires the ownership $`\varsigma_{ji}`$ of the value that it observes, a grade, as an entry of a telescope requires one of its argument.

A block is a block of data types or a block of codata types, never both, so that each of its types is known by its constructors or by its destructors alike.

The names of the constructors and of the destructors are not names of the signature: a constructor is named within its type, as $`D.c`$, and a destructor as $`D.d`$, so that two types may have constructors or destructors of the same name, while the constructors or the destructors of one type have distinct names.
The names that an entry introduces are $`{D_1, \dots, D_k}`$ for a type declaration, and $`f`$ for a constant definition or declaration:

```math
\begin{aligned}
& \mathsf{names}(f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \mathrel{≔} t) = \{f\} &&(\mathsf{names}_e) \\
& \mathsf{names}(f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p) = \{f\} \\[1em]
& {=} \\
& \quad \mathsf{names}( \\
& \qquad \mathsf{data}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa \\
& \qquad \quad \mathsf{where} \\
& \qquad \qquad D_1 \mathrel{▶} \zeta_1 \oplus \Pi_1 \mathrel{≔} \dots; \\
& \qquad \qquad \dots; \\
& \qquad \qquad D_k \mathrel{▶} \zeta_k \oplus \Pi_k \mathrel{≔} \dots) \\
& \quad \{D_1, \dots, D_k\} \\[1em]
& {=} \\
& \quad \mathsf{names}( \\
& \qquad \mathsf{codata}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa \\
& \qquad \quad \mathsf{where} \\
& \qquad \qquad D_1 \mathrel{▶} \zeta_1 \oplus \Pi_1 \mathrel{≔} \dots; \\
& \qquad \qquad \dots; \\
& \qquad \qquad D_k \mathrel{▶} \zeta_k \oplus \Pi_k \mathrel{≔} \dots) \\
& \quad \{D_1, \dots, D_k\}
\end{aligned}
```

A signature is either empty, written $`\varnothing`$, or a signature $`\Sigma`$ extended by an entry $`e`$, written $`{\Sigma,\ e}`$:

```math
\begin{aligned}
& \Sigma \mathrel{::=} \varnothing \mid \Sigma,\ e &&(\mathsf{syntax}_\Sigma)
\end{aligned}
```

A signature has the entries $`{e \in \Sigma}`$ that extend it, its last entry and those of the signature it extends:

```math
\begin{gathered}
\frac{}{e \in (\Sigma,\ e)}\;(\in_\Sigma.e) \\[2em]
\frac{e_1 \in \Sigma}{e_1 \in (\Sigma,\ e_2)}\;(\in_\Sigma.e,e)
\end{gathered}
```

A signature has a constant $`{f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p}`$, written $`{f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \in \Sigma}`$, when one of its entries is a constant definition or declaration of $`f`$, with these variables, the mode $`m`$, the ownership $`p`$ and the type $`A`$, which the rules of the defined and of the declared constants share:

```math
\begin{aligned}
& \text{⟺} &&(\in_f) \\
& \quad f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \in \Sigma \\
& \quad \text{or} \\
& \qquad \exists t.\ (f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \mathrel{≔} t) \in \Sigma \\
& \qquad (f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p) \in \Sigma
\end{aligned}
```

A signature has a declared type $`{D.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa \mathrel{▶} \zeta}`$, written $`{D.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa \mathrel{▶} \zeta \in \Sigma}`$, when one of its entries is a block of data types or of codata types that declares $`D`$, with these variables, the constraint $`C`$, the parameters $`\Delta`$, the sort $`\kappa`$ and the grades $`\zeta`$ of $`D`$, which the rules of the instances share; the rules of the constructors and of the recursors read the block of data types itself:

```math
\begin{aligned}
& \text{⟺} &&(\in_D) \\
& \quad D.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa \mathrel{▶} \zeta \in \Sigma \\
& \quad \text{or} \\
& \qquad (\mathsf{data}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa\ \mathsf{where}\ \dots;\ D \mathrel{▶} \zeta \oplus \Pi \mathrel{≔} \dots;\ \dots) \in \Sigma \\
& \qquad (\mathsf{codata}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa\ \mathsf{where}\ \dots;\ D \mathrel{▶} \zeta \oplus \Pi \mathrel{≔} \dots;\ \dots) \in \Sigma
\end{aligned}
```

The names of a signature are distinct when each of its entries introduces distinct names, which no entry before it introduces, and names the constructors or the destructors of each of its types once, so that a type declaration names each of its types and each constructor or destructor of a type once:

```math
\begin{aligned}
& \text{the names of } \varnothing \text{ are distinct} &&(\mathsf{names}_\Sigma) \\[1em]
& \text{⟺} \\
& \quad \text{the names of } \Sigma,\ e \text{ are distinct} \\
& \quad \text{and} \\
& \qquad \text{the names of } \Sigma \text{ are distinct} \\
& \qquad e \text{ introduces each of its names once} \\
& \qquad \forall e' \in \Sigma.\ \mathsf{names}(e) \cap \mathsf{names}(e') = \varnothing \\
& \qquad e \text{ names the constructors or the destructors of each of its types once}
\end{aligned}
```

### Nesting

The nesting of a type gives the positions at which the types of a block occur in it, below the instances of other declared types: a nesting $`\lambda`$ is no position, $`\bot`$, a position that holds an object $`h`$, such as the name of a type of the block, or the nestings of the arguments of an instance:

```math
\begin{aligned}
& \lambda \mathrel{::=} \bot \mid h \mid (\bar\lambda) &&(\mathsf{syntax}_\lambda)
\end{aligned}
```

The nesting $`\mathsf{nest}_\Lambda(A)`$ of a type $`A`$ is read on its syntax, where $`\Lambda`$ gives a nesting to each variable, $`\bot`$ to those it does not name, and the object that a position holds to each type of the block: the nesting of a variable applied to arguments is that of the variable, the nesting of an instance of a type of the block is the position that holds its object, and the nesting of an instance of another declared type is the nestings of its arguments, each under the variables that its abstraction binds, which have no position, or $`\bot`$ when none of them has a position; any other type has no position:

```math
\begin{aligned}
& \mathsf{nest}_\Lambda(x[\bar t]) = \Lambda(x) &&(\mathsf{nest}_A) \\
& \mathsf{nest}_\Lambda(D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a) = \Lambda(D) \text{ if } \Lambda \text{ gives an object to } D \\
& \mathsf{nest}_\Lambda(D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a) = \mathsf{nest}(\mathsf{nest}_\Lambda(\bar a)) \text{ otherwise} \\
& \mathsf{nest}_\Lambda(A) = \bot \text{ for any other type } A \\[1em]
& \mathsf{nest}_\Lambda(()) = () &&(\mathsf{nest}_{\bar a}) \\
& \mathsf{nest}_\Lambda((\bar a,\ \bar x.\, B)) = (\mathsf{nest}_\Lambda(\bar a),\ \mathsf{nest}_\Lambda(B)) \\[1em]
& \mathsf{nest}(\bar\lambda) = \bot \text{ if each of } \bar\lambda \text{ is } \bot &&(\mathsf{nest}_{\bar\lambda}) \\
& \mathsf{nest}(\bar\lambda) = (\bar\lambda) \text{ otherwise}
\end{aligned}
```

The nestings $`\bar\lambda`$ of the arguments of an instance give their nestings to the parameters $`\Delta`$ of its type, in order, written $`{\Delta \mapsto \bar\lambda}`$:

```math
\begin{aligned}
& (\Delta \mapsto \bar\lambda)(x) = \lambda_i \text{ if } x \text{ is the parameter of } \Delta \text{ at the position } i &&(\mathsf{nest}_\Delta)
\end{aligned}
```

A nesting whose positions hold the names of the types of a block gives, for an object $`h_D`$ given for each type $`D`$ of the block, the nesting with the same positions, which hold these objects, written $`{\lambda \mapsto h_D}`$, and $`{\bar\lambda \mapsto h_D}`$ for each of several nestings:

```math
\begin{aligned}
& (\bot \mapsto h_D) = \bot &&(\mathsf{map}_\lambda) \\
& (D \mapsto h_D) = h_D \\
& ((\bar\lambda) \mapsto h_D) = (\bar\lambda \mapsto h_D)
\end{aligned}
```

The nesting reads the instances alone, and neither the terms nor the parameters in which a declared type is strictly positive, which the strict positivity checks; a substitution keeps the instances of a type, so that the nesting of a type of a declaration is also that of its instances.

### Fields of a Block

A field of a constructor of a block of data types $`\mathcal{D}`$ is recursive when its type is an instance of a type of the block; $`\mathsf{rec}_{\mathcal{D}}(A)`$ names this type, $`\bot`$ when there is none, and $`\mathsf{rec}_{\mathcal{D}}(\Theta)`$ gives it for each field of a telescope, in order:

```math
\begin{aligned}
& \mathsf{rec}_{\mathcal{D}}(D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a) = D \text{ if } D \text{ is a type of } \mathcal{D} &&(\mathsf{recursive}_A) \\
& \mathsf{rec}_{\mathcal{D}}(A) = \bot \text{ otherwise} \\[1em]
& \mathsf{rec}_{\mathcal{D}}(\varepsilon) = () &&(\mathsf{recursive}_\Theta) \\
& \mathsf{rec}_{\mathcal{D}}(x : A \mathrel{▶} p;\ q \mathrel{◀} r,\ \Theta) = (\mathsf{rec}_{\mathcal{D}}(A),\ \mathsf{rec}_{\mathcal{D}}(\Theta))
\end{aligned}
```

The [nesting](#nesting) $`\mathsf{nest}_{\mathcal{D}}(A)`$ of the type of a field gives the positions of the types of the block in it, each of which holds the name of its type, and no position to the variables; $`\mathsf{nest}_{\mathcal{D}}(\Theta)`$ gives it for each field of a telescope, in order.
A recursive field of the type $`D`$ has the nesting $`D`$, and a field is nested when its nesting is that of an instance, $`(\bar\lambda)`$, the types of the block occurring below an instance of another declared type:

```math
\begin{aligned}
& \mathsf{nest}_{\mathcal{D}}(A) = \mathsf{nest}_\Lambda(A) &&(\mathsf{nest}_{\mathcal{D}}) \\
& \quad \text{where } \Lambda \text{ gives its name to each type of } \mathcal{D} \text{, and names no variable} \\[1em]
& \mathsf{nest}_{\mathcal{D}}(\varepsilon) = () &&(\mathsf{nest}_\Theta) \\
& \mathsf{nest}_{\mathcal{D}}(x : A \mathrel{▶} p;\ q \mathrel{◀} r,\ \Theta) = (\mathsf{nest}_{\mathcal{D}}(A),\ \mathsf{nest}_{\mathcal{D}}(\Theta))
\end{aligned}
```

### Destructors of a Block

A destructor of a codata type of a block of codata types $`\mathcal{D}`$ is recursive when its result is an instance of a type of the block, as a field is; $`\mathsf{rec}_{\mathcal{D}}(\bar d)`$ gives the type of the result of each destructor, in order:

```math
\begin{aligned}
& \mathsf{rec}_{\mathcal{D}}(\varepsilon) = () &&(\mathsf{recursive}_{\bar d}) \\
& \mathsf{rec}_{\mathcal{D}}(d : (\Theta \vdash B \mathrel{◀} \psi) \mathrel{▶} p;\ q \mathrel{◀} \varsigma \mid \bar d) = (\mathsf{rec}_{\mathcal{D}}(B),\ \mathsf{rec}_{\mathcal{D}}(\bar d))
\end{aligned}
```

The [nesting](#nesting) $`\mathsf{nest}_\Pi(B)`$ of the result of a destructor of a codata type that is strictly positive in the parameters $`\Pi`$ gives the positions of these parameters in it, each of which holds its parameter, and no position to the other variables.
The nesting $`\mathsf{nest}_{\mathcal{D};\ \Pi}(B)`$ of the result of a destructor is the type of the block if the destructor is recursive, and the nesting of its result otherwise; $`\mathsf{nest}_{\mathcal{D};\ \Pi}(\bar d)`$ gives it for each destructor, in order:

```math
\begin{aligned}
& \mathsf{nest}_\Pi(B) = \mathsf{nest}_\Lambda(B) &&(\mathsf{nest}_\Pi) \\
& \quad \text{where } \Lambda \text{ gives a position that holds it to each parameter of } \Pi \text{ alone} \\[1em]
& \mathsf{nest}_{\mathcal{D};\ \Pi}(B) = \mathsf{rec}_{\mathcal{D}}(B) \text{ if } \mathsf{rec}_{\mathcal{D}}(B) \ne \bot &&(\mathsf{nest}_B) \\
& \mathsf{nest}_{\mathcal{D};\ \Pi}(B) = \mathsf{nest}_\Pi(B) \text{ otherwise} \\[1em]
& \mathsf{nest}_{\mathcal{D};\ \Pi}(\varepsilon) = () &&(\mathsf{nest}_{\bar d}) \\
& \mathsf{nest}_{\mathcal{D};\ \Pi}(d : (\Theta \vdash B \mathrel{◀} \psi) \mathrel{▶} p;\ q \mathrel{◀} \varsigma \mid \bar d) = (\mathsf{nest}_{\mathcal{D};\ \Pi}(B),\ \mathsf{nest}_{\mathcal{D};\ \Pi}(\bar d))
\end{aligned}
```

### Cases

The case $`\mathsf{case}_\Sigma(D.c)`$ of the constructor $`c`$ of the type $`D`$ is its position $`i`$ among the constructors of the types of its block, in the order of the declaration, which is that of the branches of a recursor, in the last entry of $`\Sigma`$ that declares a type $`D`$ with a constructor $`c`$, and none when $`\Sigma`$ has no such entry; the case $`\mathsf{case}_\Sigma(D.d)`$ of a destructor is its position among the destructors of the types of its block, likewise:

```math
\begin{aligned}
& \mathsf{case}_\Sigma(D.c) = i &&(\mathsf{case}_c) \\
& \quad \text{if} \\
& \qquad c_i \text{ is the constructor } c \text{ of } D \text{ in} \\
& \qquad \quad \mathsf{data}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa \\
& \qquad \qquad \mathsf{where} \\
& \qquad \qquad \quad D_1 \mathrel{▶} \zeta_1 \oplus \Pi_1 \mathrel{≔} c_1 : \Theta_1 \mid \dots; \\
& \qquad \qquad \quad \dots; \\
& \qquad \qquad \quad D_k \mathrel{▶} \zeta_k \oplus \Pi_k \mathrel{≔} \dots \mid c_n : \Theta_n \\[1em]
& \mathsf{case}_\Sigma(D.d) = i &&(\mathsf{case}_d) \\
& \quad \text{if} \\
& \qquad d_i \text{ is the destructor } d \text{ of } D \text{ in} \\
& \qquad \quad \mathsf{codata}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa \\
& \qquad \qquad \mathsf{where} \\
& \qquad \qquad \quad D_1 \mathrel{▶} \zeta_1 \oplus \Pi_1 \mathrel{≔} d_1 : \dots \mid \dots; \\
& \qquad \qquad \quad \dots; \\
& \qquad \qquad \quad D_k \mathrel{▶} \zeta_k \oplus \Pi_k \mathrel{≔} \dots \mid d_n : \dots
\end{aligned}
```

## Properties

A name is introduced by one entry at most of a signature whose names are distinct:

```math
\begin{aligned}
& \text{⟹} &&(\mathsf{unique}_\Sigma) \\
& \quad \text{and} \\
& \qquad \text{the names of } \Sigma \text{ are distinct} \\
& \qquad e_1 \in \Sigma \text{ and } e_2 \in \Sigma \\
& \qquad e_1 \text{ and } e_2 \text{ introduce the same name} \\
& \quad e_1 = e_2
\end{aligned}
```
