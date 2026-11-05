# Natural Numbers

An example of [RFC 0034: Data and Codata Types](../0034-data-and-codata-types.md), derived from its rules: nothing here is part of the type system, and its formulas are named with the prefix $`\mathsf{ex}`$.
The declarations are written in a signature that holds them in order, each after those it uses, without the empty lists of variables of the declarations that have none; the grades written on an instance instantiate its grade variables.

The natural numbers are a recursive data type, whose recursor is the one of ADE; doubling a number uses it once, its predecessor never and the recursive result once, which the condition of $`(D^{+}_{\mathsf{rec}\mathsf{m}})`$ on the recursive field allows, $`\mathbb{1} \cdot \mathbb{1} \le \mathbb{0} + \mathbb{1} \cdot \mathbb{1}`$:

```math
\begin{aligned}
& \mathsf{data}.\{\} : U_0\ \mathsf{where}\ \mathbb{N} \mathrel{≔} \mathsf{zero} : () \mid \mathsf{succ} : (n :^{\mathbb{0}}_{\mathbb{1}} \mathbb{N}) &&(\mathsf{ex}_{\mathbb{N}}) \\
& \mathsf{double}(t) \;=\; \mathsf{rec}_{\mathbb{1}}\ t\ \mathsf{return}\ (z : \mathbb{N}).\, \mathbb{N}\ \mathsf{with}\ \mathsf{zero} \Rightarrow \mathbb{N}.\mathsf{zero}() \mid \mathsf{succ}(n;\ y) \Rightarrow \mathbb{N}.\mathsf{succ}(\mathbb{N}.\mathsf{succ}(y)) &&(\mathsf{ex}_{\mathsf{double}}) \\
& \Sigma;\ \gamma \mathrel{▶_{\mathbb{1}\mathbb{1}^{\mathsf{m}}}} t \implies \Sigma;\ \gamma \mathrel{▶_{\mathbb{1}\mathbb{1}^{\mathsf{m}}}} \mathsf{double}(t)
\end{aligned}
```

The branches use no variable of the context, so $`\chi`$ is $`\mathbb{0}^{\mathsf{c}}`$, and the recursion uses $`\gamma`$ once: the number is consumed, as the natural numbers of [Eriksson, Abel and Danielsson](https://doi.org/10.1145/3828677) are by their linear recursion.
