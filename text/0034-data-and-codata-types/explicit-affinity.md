# Explicit Affinity

An example of [RFC 0034: Data and Codata Types](../0034-data-and-codata-types.md), derived from its rules: nothing here is part of the type system, and its formulas are named with the prefix $`\mathsf{ex}`$.
The declarations are written in a signature that holds them in order, each after those it uses, without the empty lists of variables of the declarations that have none; the grades written on an instance instantiate its grade variables.

A resource counted once in total may be used at run time in one branch and dropped in another, when its type comes with an operation that consumes it without using it at run time, a [constant](https://github.com/sic-lang/rfcs/pull/24) of the signature; the resource then has the grade $`\langle \omega, 1 \rangle`$, `affine / linear`, the meet of the uses of the two branches.
In a signature with a foreign type $`\mathsf{Res}`$ of resources, an operation $`\mathsf{use}`$ that consumes a resource at run time and an operation $`\mathsf{forget}`$ that consumes one without running, a program chooses between them on a boolean:

```math
\begin{aligned}
& \mathsf{use}.\{\} :_{\mathbb{1}\mathbb{1}^{\mathsf{m}}} \Pi^{\mathbb{0}}_{\mathbb{1}}\, (x : \mathsf{Res}).\, \mathbb{1} \qquad \mathsf{forget}.\{\} :_{\mathbb{1}\mathbb{1}^{\mathsf{m}}} \Pi^{\mathbb{0}}_{\langle 0, 1 \rangle}\, (x : \mathsf{Res}).\, \mathbb{1} &&(\mathsf{ex}_{\mathsf{forget}}) \\
& \mathsf{rec}_{\mathbb{1}}\ b\ \mathsf{return}\ (z : \mathsf{Bool}).\, \mathbb{1}\ \mathsf{with}\ \mathsf{inl}(u) \Rightarrow \mathsf{use} \circ_{\mathbb{1}} x \mid \mathsf{inr}(u) \Rightarrow \mathsf{forget} \circ_{\langle 0, 1 \rangle} x \qquad \text{uses } x \text{ with } \mathbb{1} \wedge \langle 0, 1 \rangle = \langle \omega, 1 \rangle
\end{aligned}
```

A type without such an operation is never dropped: its resources are consumed exactly once, at run time, on every path of the program.
