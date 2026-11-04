# Units and the Absorbing Type

An example of [RFC 0034: Data and Codata Types](../0034-data-and-codata-types.md), derived from its rules: nothing here is part of the type system, and its formulas are named with the prefix $`\mathsf{ex}`$.
The declarations are written in a signature that holds them in order, each after those it uses, without the empty lists of variables of the declarations that have none; the grades written on an instance instantiate its grade variables.

The data type without fields is the unit, the data type without constructors is the empty type, and the codata type without destructors is the absorbing type, the $`\top`$ of linear logic, which the [properties](../0034-data-and-codata-types.md#absorbing-types) describe:

```math
\begin{aligned}
& \mathsf{data}.\{s;\ l\} : s_l\ \mathsf{where}\ \mathbb{1} \mathrel{≔} \mathsf{mk} : () &&(\mathsf{ex}_{\mathbb{1}}) \\
& \mathsf{data}.\{s;\ l\} : s_l\ \mathsf{where}\ \mathbb{0} \mathrel{≔} &&(\mathsf{ex}_{\mathbb{0}}) \\
& \mathsf{codata}.\{s;\ l\} : s_l\ \mathsf{where}\ \top \mathrel{≔} &&(\mathsf{ex}_\top)
\end{aligned}
```

A term of the absorbing type is built by a corecursor without branches, from any state, which it never gives back: $`\mathsf{corec}_{\mathbb{1}}\ x\ \mathsf{return}\ (x :_{\mathbb{1}} A)\ \mathsf{as}\ x\ \mathsf{with}`$ absorbs the linear variable $`x`$.
The unit of the prelude of the RFC has the shape of $`\mathbb{1}`$, and is a declaration of its own.
In $`\Omega`$, the unit and the empty type are the true and the false propositions, and the absorbing type a true proposition that absorbs erased resources, such as a permission of grade $`\langle 0, 1 \rangle`$.
