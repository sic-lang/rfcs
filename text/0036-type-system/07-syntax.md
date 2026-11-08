# Syntax

This annex defines the terms of the type system, their arguments, the telescopes, the contexts and the signatures, with the variables that each of them binds.
It builds on the [grades](03-grades.md), the [modes](04-modes.md), the [levels](05-levels.md) and the [sorts](06-sorts.md).

## Definitions

This section defines the objects in the order in which they build on each other: the variables and their scopes, the terms and their arguments, the telescopes and the contexts, then the entries of the signatures.

### Variables

A variable is named, and an object that binds variables is the same object whatever names its bound variables take, as long as they stay distinct from the names it uses free.
A variable has a telescope, whose entries say how many arguments the variable is applied to: a variable $`x : A`$ of a context has an empty one, and a second-order variable $`X : (\Theta \vdash A \mathrel{◀} \psi)`$ has $`\Theta`$, so that it stands for a term of type $`A`$ under the variables of $`\Theta`$, as the contextual types of [Nanevski, Pfenning and Pientka](https://doi.org/10.1145/1352582.1352591) do for their metavariables.

The scope of a term is the sequence of the variables it may use, each with its signature: the grades $`p_1, \dots, p_k`$ and the requirements $`r_1, \dots, r_k`$ of the entries of its telescope, and the ownership $`\psi`$ of its result, with which the usage and the ownership of an application of the variable read its arguments.
A term uses only the variables of its scope, each applied to an argument for each entry of its telescope.

### Terms

A term in a scope is one of four cases:

```math
\begin{aligned}
& t \mathrel{::=} x[\bar t] \mid \kappa \mid f.\{\bar s;\ \bar l;\ \bar p\} \mid D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a &&(\mathsf{syntax}_t)
\end{aligned}
```

The cases are:

- A variable $`x`$ of the scope applied to arguments $`\bar t`$ in the scope, one for each entry of its telescope, written $`x[\bar t]`$, and $`x`$ alone when its telescope is empty.
- A sort $`\kappa`$.
- An instance $`f.\{\bar s;\ \bar l;\ \bar p\}`$ of the constant $`f`$, defined or declared, in which $`\bar s`$ are qualities, $`\bar l`$ levels and $`\bar p`$ grades, one for each variable of each kind of the entry.
- An instance $`D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a`$ of the declared type $`D`$, whose arguments $`\bar a`$ are in the scope, one for each parameter of its type declaration.

The levels of a term use only the level variables of the entry of the signature in which it appears, and none when it appears in no entry.
The terms that build and use the declared types are given by the kinds of type declarations, in their annexes.

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

An entry is one of three cases:

```math
\begin{aligned}
& {\mathrel{::=}} &&(\mathsf{syntax}_e) \\
& \quad e \\
& \quad {\mid} \\
& \qquad f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \mathrel{≔} t \\
& \qquad f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \\
& \qquad \mathcal{K}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{≔} \dots;\ \dots;\ D_n \mathrel{≔} \dots
\end{aligned}
```

The cases are:

- A constant definition $`f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \mathrel{≔} t`$, which defines the constant $`f`$ and has sort variables $`\bar s`$, level variables $`\bar l`$, grade variables $`\bar p`$, the mode $`m`$ in which its body is checked, the ownership $`p`$ of its value, which its body must have, and, for each instance of $`\bar s`$ and $`\bar p`$, a type $`A`$ and a body $`t`$ in the empty scope.
- A constant declaration $`f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p`$, which declares the constant $`f`$ and has the same form without a body, whose mode $`m`$ is the mode of its uses, and whose ownership $`p`$, which no body checks, is the one of the value it stands for.
- A type declaration $`\mathcal{K}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{≔} \dots;\ \dots;\ D_n \mathrel{≔} \dots`$, a block of types declared together, of the kind $`\mathcal{K}`$, of which the system knows the header only: the names $`D_1, \dots, D_n`$, the sort, level and grade variables, and, for each instance of $`\bar s`$ and $`\bar p`$, the parameters $`\Delta`$, a context, and the sort $`\kappa`$ of the declared types; the bodies of the declared types are given by $`\mathcal{K}`$, in its annex.

The names that an entry introduces are $`D_1, \dots, D_n`$ for a type declaration, and $`f`$ for a constant definition or declaration:

```math
\begin{aligned}
& \mathsf{names}(f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \mathrel{≔} t) = \{f\} &&(\mathsf{names}_e) \\
& \mathsf{names}(f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p) = \{f\} \\
& \mathsf{names}(\mathcal{K}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{≔} \dots;\ \dots;\ D_n \mathrel{≔} \dots) = \{D_1, \dots, D_n\}
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

A signature has a declared type $`D.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa`$, written $`D.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa \in \Sigma`$, when one of its entries is a type declaration that declares $`D`$, with these variables, the parameters $`\Delta`$ and the sort $`\kappa`$, which the rules of the declared types share:

```math
\begin{aligned}
& \text{⟺} &&(\in_D) \\
& \quad D.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa \in \Sigma \\
& \quad \exists \mathcal{K}.\ (\mathcal{K}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ \dots;\ D \mathrel{≔} \dots;\ \dots) \in \Sigma
\end{aligned}
```

The names of a signature are distinct when each of its entries introduces names that no entry before it introduces:

```math
\begin{aligned}
& \text{the names of } \varnothing \text{ are distinct} &&(\mathsf{names}_\Sigma) \\
& \text{⟺} \\
& \quad \text{the names of } \Sigma,\ e \text{ are distinct} \\
& \quad \text{and} \\
& \qquad \text{the names of } \Sigma \text{ are distinct} \\
& \qquad \forall e' \in \Sigma.\ \mathsf{names}(e) \cap \mathsf{names}(e') = \varnothing
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
