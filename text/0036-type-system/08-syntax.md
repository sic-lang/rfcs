# Syntax

This annex defines the terms of the type system, their arguments, the telescopes, the contexts and the signatures, with the variables that each of them binds.
It builds on the [grades](04-grades.md), the [modes](05-modes.md), the [levels](06-levels.md) and the [sorts](07-sorts.md).

## Definitions

This section defines the objects in the order in which they build on each other: the variables and their scopes, the terms and their arguments, the telescopes and the contexts, then the entries of the signatures.

### Variables

A variable is named, and an object that binds variables is the same object whatever names its bound variables take, as long as they stay distinct from the names it uses free.
A variable has a telescope, whose entries say how many arguments the variable is applied to: a variable $`x : A`$ of a context has an empty one, and a second-order variable $`X : (\Theta \vdash A \mathrel{◀} \psi)`$ has $`\Theta`$, so that it stands for a term of type $`A`$ under the variables of $`\Theta`$, as the contextual types of [Nanevski, Pfenning and Pientka](https://doi.org/10.1145/1352582.1352591) do for their metavariables.

The scope of a term is the sequence of the variables it may use, each with its signature: the grades $`p_1, \dots, p_k`$ and the requirements $`r_1, \dots, r_k`$ of the entries of its telescope, and the ownership $`\psi`$ of its result, with which the usage and the ownership of an application of the variable read its arguments.
A term uses only the variables of its scope, each applied to an argument for each entry of its telescope.

### Terms

A term in a scope is one of eight cases:

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
& \qquad \mathsf{rec}_r\ (D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a)\ t\ \mathsf{return}\ \bar C\ \mathsf{with}\ \bar u \\
& \qquad t.((D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a).d)(\bar t) \\
& \qquad \mathsf{corec}_r\ (D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a)\ \mathsf{from}\ \bar t\ \mathsf{return}\ \bar\Theta\ \mathsf{with}\ \bar g
\end{aligned}
```

The cases are:

- A variable $`x`$ of the scope applied to arguments $`\bar t`$ in the scope, one for each entry of its telescope, written $`x[\bar t]`$, and $`x`$ alone when its telescope is empty.
- A sort $`\kappa`$.
- An instance $`f.\{\bar s;\ \bar l;\ \bar p\}`$ of the constant $`f`$, defined or declared, in which $`\bar s`$ are qualities, $`\bar l`$ levels and $`\bar p`$ grades, one for each variable of each kind of the entry.
- An instance $`D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a`$ of the declared type $`D`$, whose arguments $`\bar a`$ are in the scope, one for each parameter of its type declaration.
- A constructor $`c`$ of the data type of an instance $`T = D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a`$, applied to arguments $`\bar t`$, a term for each of its fields, written $`T.c(\bar t)`$: the constructor carries its instance, so that the term determines its type.
- A recursor $`\mathsf{rec}_r\ T\ t\ \mathsf{return}\ \bar C\ \mathsf{with}\ \bar u`$, which eliminates the term $`t`$ of the instance $`T = D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a`$, used with the grade $`r`$, with motives $`\bar C`$, one for each type of the block of $`t`$, and branches $`\bar u`$, one for each constructor of each type of the block, in the order of the declaration: the recursor carries the instance of the term it eliminates, so that its usage and its ownership read the grades and the requirements of the fields at this instance.
- An observation $`t.(T.d)(\bar t)`$ of the term $`t`$ of the instance $`T = D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a`$ by its destructor $`d`$, applied to arguments $`\bar t`$, a term for each argument of the destructor, written $`t.(T.d)`$ when the destructor has no argument: the observation carries the instance of its term, as the recursor does, so that its usage and its ownership read the grades and the requirements of the destructor at this instance.
- A corecursor $`\mathsf{corec}_r\ T\ \mathsf{from}\ \bar t\ \mathsf{return}\ \bar\Theta\ \mathsf{with}\ \bar g`$, which builds a term of the instance $`T = D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a`$ from the state $`\bar t`$, used with the grade $`r`$, with states $`\bar\Theta`$, one for each type of the block of $`D`$, and branches $`\bar g`$, one for each destructor of each type of the block, in the order of the declaration: the corecursor carries its instance, as a constructor does, so that the term determines its type.

The levels of a term use only the level variables of the entry of the signature in which it appears, and none when it appears in no entry.

The arguments $`\bar t`$ of a telescope are a term for each of its entries, the first one first: they are either empty, written $`()`$, or an argument $`t`$ followed by arguments $`\bar t`$, written $`(t,\ \bar t)`$:

```math
\begin{aligned}
& \bar t \mathrel{::=} () \mid (t,\ \bar t) &&(\mathsf{syntax}_{\bar t})
\end{aligned}
```

The arguments $`\bar a`$ of an instance are an abstraction for each parameter, the last one last: they are either empty, written $`()`$, or arguments $`\bar a`$ followed by an abstraction $`\bar x.\, B`$, written $`(\bar a,\ \bar x.\, B)`$:

```math
\begin{aligned}
& \bar a \mathrel{::=} () \mid (\bar a,\ \bar x.\, B) &&(\mathsf{syntax}_{\bar a})
\end{aligned}
```

The abstraction for a parameter binds the variables $`\bar x`$, one for each entry of the telescope of the parameter, each with an empty telescope, and its term $`B`$ is in the scope extended by them; for a parameter with an empty telescope, $`\bar x`$ is empty and the abstraction is the term $`B`$.

The motives $`\bar C`$ of a recursor are a motive for each type of the block, the first one first: they are either empty, written $`()`$, or a motive $`(\bar x,\ z).\, C`$ followed by motives $`\bar C`$, written $`((\bar x,\ z).\, C,\ \bar C)`$:

```math
\begin{aligned}
& \bar C \mathrel{::=} () \mid ((\bar x,\ z).\, C,\ \bar C) &&(\mathsf{syntax}_{\bar C})
\end{aligned}
```

The motive of a type binds the variables $`\bar x`$, one for each non-uniform parameter of the type, and the variable $`z`$, the term eliminated, each with an empty telescope, and its term $`C`$ is in the scope extended by them.

The branches $`\bar u`$ of a recursor are a branch for each constructor, the first one first: they are either empty, written $`()`$, or a branch $`(\bar x;\ \bar y \mathrel{▶} \bar e).\, u`$ followed by branches $`\bar u`$, written $`((\bar x;\ \bar y \mathrel{▶} \bar e).\, u,\ \bar u)`$:

```math
\begin{aligned}
& \bar u \mathrel{::=} () \mid ((\bar x;\ \bar y \mathrel{▶} \bar e).\, u,\ \bar u) &&(\mathsf{syntax}_{\bar u})
\end{aligned}
```

The branch of a constructor binds the variables $`\bar x`$, one for each field of the constructor, then the variables $`\bar y`$, one for each recursive result, each with an empty telescope and with the grade $`e`$ of $`\bar e`$ with which the branch uses it, written $`y_1 \mathrel{▶} e_1, \dots, y_n \mathrel{▶} e_n`$, and its term $`u`$ is in the scope extended by them; the branch of the constructor $`c`$ of the type $`D`$ is written $`D.c(\bar x;\ \bar y \mathrel{▶} \bar e) \Rightarrow u`$, without the semicolon when it binds no recursive result.
The branch carries the grades of its recursive results, as a telescope carries the grades of its entries, so that the usage and the ownership read them.

The states $`\bar\Theta`$ of a corecursor are a state for each type of the block, the first one first: they are either empty, written $`()`$, or a state $`\bar x.\, \Theta : \bar\kappa`$ followed by states $`\bar\Theta`$, written $`(\bar x.\, \Theta : \bar\kappa,\ \bar\Theta)`$:

```math
\begin{aligned}
& \bar\Theta \mathrel{::=} () \mid (\bar x.\, \Theta : \bar\kappa,\ \bar\Theta) &&(\mathsf{syntax}_{\bar\Theta})
\end{aligned}
```

The state of a type binds the variables $`\bar x`$, one for each non-uniform parameter of the type, each with an empty telescope, and its telescope $`\Theta`$ is in the scope extended by them; it carries the sorts $`\bar\kappa`$ of the entries of $`\Theta`$, one for each entry, which the [packing](19-prelude.md#packing) of the state needs and the telescope does not give.

The branches $`\bar g`$ of a corecursor are a branch for each destructor, the first one first: they are either empty, written $`()`$, or a branch $`(\bar x;\ \bar y;\ \bar z).\, g`$ followed by branches $`\bar g`$, written $`((\bar x;\ \bar y;\ \bar z).\, g,\ \bar g)`$:

```math
\begin{aligned}
& \bar g \mathrel{::=} () \mid ((\bar x;\ \bar y;\ \bar z).\, g,\ \bar g) &&(\mathsf{syntax}_{\bar g})
\end{aligned}
```

The branch of a destructor binds the variables $`\bar x`$, one for each non-uniform parameter of its type, then the variables $`\bar y`$, one for each entry of the state of its type, then the variables $`\bar z`$, one for each argument of the destructor, each with an empty telescope, and its term $`g`$, the result of the observation, is in the scope extended by them; the branch of the destructor $`d`$ of the type $`D`$ is written $`D.d(\bar x;\ \bar y;\ \bar z) \Rightarrow g`$.

### Telescopes and Contexts

A telescope in a scope is either empty, written $`\varepsilon`$, or an entry followed by a telescope, written $`(x : A \mathrel{▶} p;\ q \mathrel{◀} r,\ \Theta)`$, in which $`A`$ is a term in the scope and $`\Theta`$ a telescope in the scope extended by $`x`$, with an empty telescope:

```math
\begin{aligned}
& \Theta \mathrel{::=} \varepsilon \mid (x : A \mathrel{▶} p;\ q \mathrel{◀} r,\ \Theta) &&(\mathsf{syntax}_\Theta)
\end{aligned}
```

The entry $`x : A \mathrel{▶} p;\ q \mathrel{◀} r`$ is used with the grade $`p`$, requires of its argument the ownership $`r`$, and its variable is used with the grade $`q`$ by the types after it; the grades of a telescope are the grades $`p`$ of its entries, in order, and its requirements their ownerships $`r`$.

A context is either empty, written $`\varepsilon`$, or a context $`\Gamma`$ extended by a variable, written $`\Gamma,\ x : A`$, or by a second-order variable, written $`\Gamma,\ X : (\Theta \vdash A \mathrel{◀} \psi)`$, in which $`A`$ and $`\Theta`$ are in the scope of $`\Gamma`$, and in $`X : (\Theta \vdash A \mathrel{◀} \psi)`$, $`A`$ is in the scope of $`\Gamma`$ extended by the variables of $`\Theta`$:

```math
\begin{aligned}
& \Gamma \mathrel{::=} \varepsilon \mid \Gamma,\ x : A \mid \Gamma,\ X : (\Theta \vdash A \mathrel{◀} \psi) &&(\mathsf{syntax}_\Gamma)
\end{aligned}
```

The ownership $`\psi`$ of the result of $`X : (\Theta \vdash A \mathrel{◀} \psi)`$ is the meet of a grade $`\chi_0`$, its constant, and of factors $`x_j \cdot \chi_j`$, each scaling a variable $`x_j`$ of $`\Theta`$ by its coefficient $`\chi_j`$; the constant and each factor are optional, each variable has one factor at most, in the order of $`\Theta`$, and the factor $`x_j \cdot {11}^{\mathsf{p}}`$ is written $`x_j`$:

```math
\begin{aligned}
& \psi \mathrel{::=} \chi_0 \wedge x_{j_1} \cdot \chi_{j_1} \wedge \dots \wedge x_{j_n} \cdot \chi_{j_n} \mid x_{j_1} \cdot \chi_{j_1} \wedge \dots \wedge x_{j_n} \cdot \chi_{j_n} \text{ if } j_1 < \dots < j_n &&(\mathsf{syntax}_\psi)
\end{aligned}
```

The variables $`x_j`$ stand for the ownerships of the arguments of $`X`$, and $`\psi`$ for the ownership of its result: $`X`$ stands for a term whose value, given arguments of these ownerships, has the ownership $`\psi`$.

The scope of a context is its variables, the last one last, each with its signature.
A variable $`x : A`$ and a second-order variable $`X : (\varepsilon \vdash A \mathrel{◀} \psi)`$ both have an empty telescope, and only their entries in the context tell them apart.

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
& \qquad \mathsf{data}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} c_{11} : \Theta_{11} \mid \dots \mid c_{1 n_1} : \Theta_{1 n_1};\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} c_{k1} : \Theta_{k1} \mid \dots \mid c_{k n_k} : \Theta_{k n_k} \\
& \qquad \mathsf{codata}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} d_{11} : (\Theta_{11} \vdash B_{11} \mathrel{◀} \psi_{11}) \mathrel{▶} p_{11};\ q_{11} \mid \dots;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \dots \mid d_{k n_k} : (\Theta_{k n_k} \vdash B_{k n_k} \mathrel{◀} \psi_{k n_k}) \mathrel{▶} p_{k n_k};\ q_{k n_k}
\end{aligned}
```

The cases are:

- A constant definition $`f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \mathrel{≔} t`$, which defines the constant $`f`$ and has sort variables $`\bar s`$, level variables $`\bar l`$, grade variables $`\bar p`$, the mode $`m`$ in which its body is checked, the ownership $`p`$ of its value, which its body must have, and, for each instance of $`\bar s`$ and $`\bar p`$, a type $`A`$ and a body $`t`$ in the empty scope.
- A constant declaration $`f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p`$, which declares the constant $`f`$ and has the same form without a body, whose mode $`m`$ is the mode of its uses, and whose ownership $`p`$, which no body checks, is the one of the value it stands for.
- A type declaration $`\mathsf{data}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} \dots;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \dots`$, a block of data types declared together, which has sort, level and grade variables, the constraint $`C`$ on the instances of its sort and grade variables, the names $`D_1, \dots, D_k`$ of its types, and, for each instance of $`\bar s`$ and $`\bar p`$ that $`C`$ admits, the parameters $`\Delta`$, a context, the sort $`\kappa`$ of its types and their bodies: each type $`D_j`$ has the grades $`\zeta_j`$ with which it uses the parameters, a vector of grades over the scope of $`\Delta`$, and its constructors $`c_{j1}, \dots, c_{j n_j}`$, in order, and each constructor $`c_{ji}`$ the telescope $`\Theta_{ji}`$ of its fields, in the scope of $`\Delta`$.
- A type declaration $`\mathsf{codata}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} \dots;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \dots`$, a block of codata types declared together, which has the same form, except that each type $`D_j`$ has destructors $`d_{j1}, \dots, d_{j n_j}`$, in order, rather than constructors: the destructor $`d_{ji} : (\Theta_{ji} \vdash B_{ji} \mathrel{◀} \psi_{ji}) \mathrel{▶} p_{ji};\ q_{ji}`$ has the telescope $`\Theta_{ji}`$ of its arguments and its result type $`B_{ji}`$, in the scope of $`\Delta`$ extended by the destructors before it and, for $`B_{ji}`$, by the variables of $`\Theta_{ji}`$; its result has the ownership $`\psi_{ji}`$ and is used with the grade $`p_{ji}`$, and the destructor is used with the grade $`q_{ji}`$ by the types of the destructors after it, in whose scope it is a second-order variable $`d_{ji} : (\Theta_{ji} \vdash B_{ji} \mathrel{◀} \psi_{ji})`$, so that a destructor may depend on the observations before it.

A block is a block of data types or a block of codata types, never both, so that each of its types is known by its constructors or by its destructors alike.

The names of the constructors and of the destructors are not names of the signature: a constructor is named within its type, as $`D.c`$, and a destructor as $`D.d`$, so that two types may have constructors or destructors of the same name, while the constructors or the destructors of one type have distinct names.
The names that an entry introduces are $`D_1, \dots, D_k`$ for a type declaration, and $`f`$ for a constant definition or declaration:

```math
\begin{aligned}
& \mathsf{names}(f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \mathrel{≔} t) = \{f\} &&(\mathsf{names}_e) \\
& \mathsf{names}(f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p) = \{f\} \\
& \mathsf{names}(\mathsf{data}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} \dots;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \dots) = \{D_1, \dots, D_k\} \\
& \mathsf{names}(\mathsf{codata}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{▶} \zeta_1 \mathrel{≔} \dots;\ \dots;\ D_k \mathrel{▶} \zeta_k \mathrel{≔} \dots) = \{D_1, \dots, D_k\}
\end{aligned}
```

A signature is either empty, written $`\varnothing`$, or a signature $`\Sigma`$ extended by an entry $`e`$, written $`\Sigma,\ e`$:

```math
\begin{aligned}
& \Sigma \mathrel{::=} \varnothing \mid \Sigma,\ e &&(\mathsf{syntax}_\Sigma)
\end{aligned}
```

A signature has the entries $`e \in \Sigma`$ that extend it, its last entry and those of the signature it extends:

```math
\begin{gathered}
\frac{}{e \in (\Sigma,\ e)}\;(\in_\Sigma.e) \\[1em]
\frac{e_1 \in \Sigma}{e_1 \in (\Sigma,\ e_2)}\;(\in_\Sigma.e,e)
\end{gathered}
```

A signature has a constant $`f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p`$, written $`f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \in \Sigma`$, when one of its entries is a constant definition or declaration of $`f`$, with these variables, the mode $`m`$, the ownership $`p`$ and the type $`A`$, which the rules of the defined and of the declared constants share:

```math
\begin{aligned}
& \text{⟺} &&(\in_f) \\
& \quad f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \in \Sigma \\
& \quad \text{or} \\
& \qquad \exists t.\ (f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \mathrel{≔} t) \in \Sigma \\
& \qquad (f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p) \in \Sigma
\end{aligned}
```

A signature has a declared type $`D.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa \mathrel{▶} \zeta`$, written $`D.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa \mathrel{▶} \zeta \in \Sigma`$, when one of its entries is a block of data types or of codata types that declares $`D`$, with these variables, the constraint $`C`$, the parameters $`\Delta`$, the sort $`\kappa`$ and the grades $`\zeta`$ of $`D`$, which the rules of the instances share; the rules of the constructors and of the recursors read the block of data types itself:

```math
\begin{aligned}
& \text{⟺} &&(\in_D) \\
& \quad D.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa \mathrel{▶} \zeta \in \Sigma \\
& \quad \text{or} \\
& \qquad (\mathsf{data}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa\ \mathsf{where}\ \dots;\ D \mathrel{▶} \zeta \mathrel{≔} \dots;\ \dots) \in \Sigma \\
& \qquad (\mathsf{codata}.\{\bar s;\ \bar l;\ \bar p \mid C\}\ \Delta : \kappa\ \mathsf{where}\ \dots;\ D \mathrel{▶} \zeta \mathrel{≔} \dots;\ \dots) \in \Sigma
\end{aligned}
```

The names of a signature are distinct when each of its entries introduces distinct names, which no entry before it introduces, and names the constructors or the destructors of each of its types once, so that a type declaration names each of its types and each constructor or destructor of a type once:

```math
\begin{aligned}
& \text{the names of } \varnothing \text{ are distinct} &&(\mathsf{names}_\Sigma) \\
& \text{⟺} \\
& \quad \text{the names of } \Sigma,\ e \text{ are distinct} \\
& \quad \text{and} \\
& \qquad \text{the names of } \Sigma \text{ are distinct} \\
& \qquad e \text{ introduces each of its names once} \\
& \qquad \forall e' \in \Sigma.\ \mathsf{names}(e) \cap \mathsf{names}(e') = \varnothing \\
& \qquad e \text{ names the constructors or the destructors of each of its types once}
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
