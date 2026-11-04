# A Permission Used Once

An example of [RFC 0034: Data and Codata Types](../0034-data-and-codata-types.md), derived from its rules: nothing here is part of the type system, and its formulas are named with the prefix $`\mathsf{ex}`$.
The declarations are written in a signature that holds them in order, each after those it uses, without the empty lists of variables of the declarations that have none; the grades written on an instance instantiate its grade variables.

A permission is a value that exists only to be consumed by an operation, at no cost at run time, so it has the grade `none / linear`.
In a context with a type $`\mathsf{Perm} : U_0`$, a type of results $`B : U_0`$ with a term $`b : B`$, and two operations that consume a permission, $`\mathsf{close} : \Pi^{\mathbb{0}}_{\langle 0, 1 \rangle}\, (x : \mathsf{Perm}).\, B`$ and $`\mathsf{commit} : \Pi^{\mathbb{0}}_{\langle 0, 1 \rangle}\, (x : \mathsf{Perm}).\, \Pi^{\mathbb{0}}_{\mathbb{1}}\, (y : B).\, B`$, which also receives a result, a function that receives a permission must pass it on exactly once:

```math
\begin{aligned}
& \lambda_{\langle 0, 1 \rangle}\, (x : \mathsf{Perm}).\, \mathsf{close} \circ_{\langle 0, 1 \rangle} x \;:\; \Pi^{\mathbb{0}}_{\langle 0, 1 \rangle}\, (x : \mathsf{Perm}).\, B &&(\mathsf{ex}_{\mathsf{perm}})
\end{aligned}
```

The argument of $`\mathsf{close}`$ is checked in the mode $`\mathbb{0}\mathbb{1}^{\mathsf{m}}`$, where $`x`$ uses itself with $`\langle 0, 1 \rangle`$, so the body uses $`x`$ with $`\langle 0, 1 \rangle \cdot \langle 0, 1 \rangle = \langle 0, 1 \rangle`$, the grade of the abstraction.
A body that drops the permission, such as $`b`$, uses $`x`$ with $`\mathbb{0}`$, and one that passes it to both operations, $`(\mathsf{commit} \circ_{\langle 0, 1 \rangle} x) \circ_{\mathbb{1}} (\mathsf{close} \circ_{\langle 0, 1 \rangle} x)`$, uses it with $`\langle 0, 1 \rangle + \langle 0, 1 \rangle = \langle 0, \omega \rangle`$: $`\langle 0, 1 \rangle`$ is below neither of them, so both are rejected, although both are well typed.
At run time, the permission disappears, and the function is $`\mathsf{corec}\ \mathsf{with}\ \mathsf{app}(x) \Rightarrow \mathsf{close}.\mathsf{app}(\text{↯})`$.
