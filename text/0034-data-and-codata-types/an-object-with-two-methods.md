# An Object With Two Methods

An example of [RFC 0034: Data and Codata Types](../0034-data-and-codata-types.md), derived from its rules: nothing here is part of the type system, and its formulas are named with the prefix $`\mathsf{ex}`$.
The declarations are written in a signature that holds them in order, each after those it uses, without the empty lists of variables of the declarations that have none; the grades written on an instance instantiate its grade variables.

An object with two methods is a codata type with two destructors without arguments; it is the additive conjunction $`\&`$ of linear logic, since its user observes one method at each use, so that a resource used once by each branch is used once by the object:

```math
\begin{aligned}
& \mathsf{codata}.\{s;\ l;\ p_1, p_2\}\ (A : s_l,\ B : s_l) : s_l\ \mathsf{where}\ {\&} \mathrel{≔} \mathsf{fst} :^{\mathbb{0}}_{p_1} () \to A \mid \mathsf{snd} :^{\mathbb{0}}_{p_2} () \to B &&(\mathsf{ex}_{\&}) \\
& \mathsf{corec}\ (B \mathrel{\&} C)\ \mathsf{with}\ .\mathsf{fst} \Rightarrow f \circ_{\mathbb{1}} x \mid .\mathsf{snd} \Rightarrow g \circ_{\mathbb{1}} x \qquad \text{uses } x \text{ with } \mathbb{1} \wedge \mathbb{1} = \mathbb{1} &&(\mathsf{ex}_{\mathsf{choice}})
\end{aligned}
```

A pair of the same two functions applied to $`x`$ would use it with $`\mathbb{1} + \mathbb{1} = \langle \omega, \omega \rangle`$: the two conjunctions differ by their usage only, and coincide when every field is discarded and duplicated freely.
