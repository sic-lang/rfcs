# Sums

An example of [RFC 0034: Data and Codata Types](../0034-data-and-codata-types.md), derived from its rules: nothing here is part of the type system, and its formulas are named with the prefix $`\mathsf{ex}`$.
The declarations are written in a signature that holds them in order, each after those it uses, without the empty lists of variables of the declarations that have none; the grades written on an instance instantiate its grade variables.

A sum is a data type with two constructors, each with one field; its recursor is the case analysis, in which the branches share their uses, and the erased-scrutinee condition of $`(D^{+}_{\mathsf{rec}\mathsf{m}})`$ forbids a term that runs to analyze a sum that does not exist at run time:

```math
\begin{aligned}
& \mathsf{data}.\{s;\ l;\ p\}\ (A : s_l,\ B : s_l) : U_l\ \mathsf{where}\ {+} \mathrel{≔} \mathsf{inl} : (x :^{\mathbb{0}}_{p} A) \mid \mathsf{inr} : (y :^{\mathbb{0}}_{p} B) &&(\mathsf{ex}_{+}) \\
& \mathsf{Bool} \;=\; \mathbb{1} + \mathbb{1} \qquad \mathsf{true} \;=\; \mathsf{Bool}.\mathsf{inl}(\mathbb{1}.\mathsf{mk}()) \qquad \mathsf{false} \;=\; \mathsf{Bool}.\mathsf{inr}(\mathbb{1}.\mathsf{mk}())
\end{aligned}
```

The type of positions of the corecursor, $`\oplus`$, is a sum of the same shape, with a sort variable for each of its two arguments and the grades of its two fields fixed to a variable and to $`\mathbb{1}`$.
