# A Value With a Proof

An example of [RFC 0034: Data and Codata Types](../0034-data-and-codata-types.md), derived from its rules: nothing here is part of the type system, and its formulas are named with the prefix $`\mathsf{ex}`$.
The declarations are written in a signature that holds them in order, each after those it uses, without the empty lists of variables of the declarations that have none; the grades written on an instance instantiate its grade variables.

A value together with a proof that it satisfies a predicate is a pair whose second field is erased.
In a context with a type $`A : U_0`$ and a predicate $`\mathsf{P} : \Pi^{\mathbb{0}}_{\langle 0, \omega \rangle}\, (x : A).\, \Omega_0`$, which uses its argument only in erased positions, the values of $`A`$ that satisfy $`\mathsf{P}`$ form the pair type whose proof has the grade `none / unrestricted`, as a proof that may be used any number of times or dropped:

```math
\begin{aligned}
& R \;=\; {\otimes}.\{U, \Omega;\ 0, 0;\ \mathbb{1}, \langle 0, \omega \rangle, \langle 0, \omega \rangle\}\ (A,\ x.\, \mathsf{P} \circ_{\langle 0, \omega \rangle} x) &&(\mathsf{ex}_{\mathsf{subset}}) \\
& \lambda_{\mathbb{1}}\, (y : R).\, \mathsf{rec}_{\mathbb{1}}\ y\ \mathsf{return}\ (z : R).\, A\ \mathsf{with}\ \mathsf{mk}(x_1,\ x_2) \Rightarrow x_1 \;:\; \Pi^{\mathbb{0}}_{\mathbb{1}}\, (y : R).\, A
\end{aligned}
```

The type of the proof is checked in the mode $`\mathbb{0}\mathbb{1}^{\mathsf{m}}`$, where $`x`$, an argument of grade $`\langle 0, \omega \rangle`$, is used $`\langle 0, \omega \rangle \cdot \langle 0, 1 \rangle = \langle 0, \omega \rangle`$ times, which the grade $`q_1`$ of the first field allows.
The function reads the value and drops the proof, which its grade allows; two such pairs with the same value are equal whatever their proofs, by irrelevance and congruence, so $`R`$ behaves as a subset of $`A`$.
At run time, the proof takes no room: the pair is $`\mathsf{mk}(t^\bullet,\ \text{↯})`$, and the function is $`\mathsf{corec}\ \mathsf{with}\ \mathsf{app}(y) \Rightarrow \mathsf{rec}\ y\ \mathsf{with}\ \mathsf{mk}(x_1,\ x_2) \Rightarrow x_1`$.
