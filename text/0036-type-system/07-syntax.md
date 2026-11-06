# Syntax

This annex defines the terms of the type system, their arguments, the telescopes, the contexts and the signatures, with the variables that each of them binds.
It builds on the [grades](03-grades.md), the [modes](04-modes.md), the [levels](05-levels.md) and the [sorts](06-sorts.md).

## Definitions

This section defines the objects in the order in which they build on each other: the variables and their scopes, the terms and their arguments, the telescopes and the contexts, then the entries of the signatures.

### Variables

A variable is named, and an object that binds variables is the same object whatever names its bound variables take, as long as they stay distinct from the names it uses free.
A variable has a telescope, whose entries say how many arguments the variable is applied to: a variable $`x : A`$ of a context has an empty one, and a second-order variable $`X : (\Theta \vdash A)`$ has $`\Theta`$, so that it stands for a term of type $`A`$ under the variables of $`\Theta`$, as the contextual types of [Nanevski, Pfenning and Pientka](https://doi.org/10.1145/1352582.1352591) do for their metavariables.

The scope of a term is the sequence of the variables it may use, each with the grades $`p_1, \dots, p_k`$ of the entries of its telescope, with which the usage of an application of the variable reads the uses of its arguments.
A term uses only the variables of its scope, each applied to an argument for each of these grades.

### Terms

A term in a scope is one of:

- A variable $`x`$ of the scope applied to arguments $`\bar t`$ in the scope, one for each entry of its telescope, written $`x[\bar t]`$, and $`x`$ alone when its telescope is empty.
- A sort $`\kappa`$.
- An instance $`c.\{\bar s;\ \bar l;\ \bar p\}`$ of the definition or of the constant $`c`$, in which $`\bar s`$ are qualities, $`\bar l`$ levels and $`\bar p`$ grades, one for each variable of each kind of the entry.
- An instance $`D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a`$ of the declared type $`D`$, whose arguments $`\bar a`$ are in the scope, one for each parameter of its declaration.

The levels of a term use only the level variables of the entry of the signature in which it appears, and none when it appears in no entry.
The terms that build and use the declared types are given by the kinds of declarations, in their annexes.

The arguments $`\bar t`$ of a telescope are a term for each of its entries, the first one first: they are either empty, written $`()`$, or an argument $`t`$ followed by arguments $`\bar t`$, written $`(t,\ \bar t)`$.

The arguments $`\bar a`$ of an instance are an abstraction for each parameter, the last one last: they are either empty, written $`()`$, or arguments $`\bar a`$ followed by an abstraction $`\bar x.\, B`$, written $`(\bar a,\ \bar x.\, B)`$.
The abstraction for a parameter binds the variables $`\bar x`$, one for each entry of the telescope of the parameter, each with an empty telescope, and its term $`B`$ is in the scope extended by them; for a parameter with an empty telescope, $`\bar x`$ is empty and the abstraction is the term $`B`$.

### Telescopes and Contexts

A telescope in a scope is either empty, written $`\varepsilon`$, or an entry followed by a telescope, written $`(x :^{q}_{p} A,\ \Theta)`$, in which $`A`$ is a term in the scope and $`\Theta`$ a telescope in the scope extended by $`x`$, with an empty telescope.
The entry $`x :^{q}_{p} A`$ is used with the grade $`p`$, and its variable is used with the grade $`q`$ by the types after it; the grades of a telescope are the grades $`p`$ of its entries, in order.

A context is either empty, written $`\varepsilon`$, or a context $`\Gamma`$ extended by a variable, written $`\Gamma,\ x : A`$, or by a second-order variable, written $`\Gamma,\ X : (\Theta \vdash A)`$, in which $`A`$ and $`\Theta`$ are in the scope of $`\Gamma`$, and in $`X : (\Theta \vdash A)`$, $`A`$ is in the scope of $`\Gamma`$ extended by the variables of $`\Theta`$.
The scope of a context is its variables, the last one last, each with the grades of its telescope.
A variable $`x : A`$ and a second-order variable $`X : (\varepsilon \vdash A)`$ both have an empty telescope, and only their entries in the context tell them apart.

### Entries and Signatures

An entry of a signature has sort variables, level variables and grade variables, and an instance of its sort and grade variables gives a quality to each sort variable and a grade to each grade variable.
The sort and grade variables are not part of the terms: since an entry is checked for each instance of them, its type, its body, its parameters and its sort are given for each instance, written with the variables as a rule is written with the variables of its fraction, so that the terms carry qualities and grades only.
The level variables are part of the terms, since an entry is checked once with them.

An entry is one of:

- A definition $`c.\{\bar s;\ \bar l;\ \bar p\} :_m A \mathrel{≔} t`$, which has a name $`c`$, sort variables $`\bar s`$, level variables $`\bar l`$, grade variables $`\bar p`$, the mode $`m`$ in which its body is checked, and, for each instance of $`\bar s`$ and $`\bar p`$, a type $`A`$ and a body $`t`$ in the empty scope.
- A constant $`c.\{\bar s;\ \bar l;\ \bar p\} :_m A`$, an entry of the same form without a body, whose mode $`m`$ is the mode of its uses.
- A declaration $`\mathsf{kind}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ D_1 \mathrel{≔} \dots;\ \dots;\ D_n \mathrel{≔} \dots`$, a block of types declared together, of which the system knows the header only: the names $`D_1, \dots, D_n`$, the sort, level and grade variables, and, for each instance of $`\bar s`$ and $`\bar p`$, the parameters $`\Delta`$, a context, and the sort $`\kappa`$ of the declared types; the bodies of the declared types are given by the kind of the declaration, in its annex.

The names that an entry introduces are $`D_1, \dots, D_n`$ for a declaration, and $`c`$ for a definition or a constant.
A signature is either empty, written $`\varnothing`$, or a signature $`\Sigma`$ extended by an entry $`e`$, written $`\Sigma,\ e`$.
A signature has an entry $`c.\{\bar s;\ \bar l;\ \bar p\} :_m A`$, written $`c.\{\bar s;\ \bar l;\ \bar p\} :_m A \in \Sigma`$, when one of its entries is a definition or a constant with the name $`c`$, these variables, the mode $`m`$ and the type $`A`$, which the rules of the definitions and of the constants share.
A signature has a declared type $`D.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa`$, written $`D.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa \in \Sigma`$, when one of its entries is a declaration that declares $`D`$, with these variables, the parameters $`\Delta`$ and the sort $`\kappa`$, which the rules of the declared types share.
The names of a signature are distinct when each of its entries introduces names that no entry before it introduces.

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
