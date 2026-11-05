# Functions

An example of [RFC 0034: Data and Codata Types](../0034-data-and-codata-types.md), derived from its rules: nothing here is part of the type system, and its formulas are named with the prefix $`\mathsf{ex}`$.
The declarations are written in a signature that holds them in order, each after those it uses, without the empty lists of variables of the declarations that have none; the grades written on an instance instantiate its grade variables.

The type of functions is a codata type with a single destructor, the application, whose argument carries the grades of the binder and whose result depends on the argument through a second-order parameter; its sort is that of the codomain, at the larger level, so that a function into a proposition is a proposition:

```math
\begin{aligned}
& \mathsf{codata}.\{s_1, s_2;\ l_1, l_2;\ p, q\}\ (A : s_{1 l_1},\ B : (x : A \vdash s_{2 l_2})) : s_{2 (l_1 \sqcup l_2)}\ \mathsf{where}\ \Pi \mathrel{≔} \mathsf{app} :^{\mathbb{0}}_{\mathbb{1}} (x :^{q}_{p} A) \to B[x] &&(\mathsf{ex}_\Pi) \\
& \Pi^{q}_{p}\, (x : A).\, B \;=\; \Pi.\{s_1, s_2;\ l_1, l_2;\ p, q\}\ (A,\ x.\, B) \\
& \lambda_{p}\, (x : A).\, t \;=\; \mathsf{corec}\ \Pi^{q}_{p}\, (x : A).\, B\ \mathsf{with}\ .\mathsf{app}(x) \Rightarrow t \qquad t \circ_{p} a \;=\; t.\mathsf{app}(a)
\end{aligned}
```

The rules of ADE for the functions are then instances of the rules of the codata types: the usage of the type by $`(D^{-}_{\mathsf{m}})`$ counts the domain $`p`$ times and the argument $`q`$ times in the codomain, the abstraction uses its argument with $`p`$ by $`(D^{-}_{\mathsf{i}\mathsf{m}})`$, the application uses its argument with $`p`$ by $`(D^{-}_{\pi\mathsf{m}})`$, the rule $`(D^{-}_{\pi\beta})`$ computes $`(\lambda_{p}\, (x : A).\, t) \circ_{p} a \equiv t[a/x]`$, and the rule $`(D^{-}_\eta)`$ gives $`t \equiv \lambda_{p}\, (x : A).\, t \circ_{p} x`$, since the type is not recursive.
The constant function uses its first argument once in its body and its second never, and the polymorphic identity takes its type as an argument, which its body never uses and its type uses twice, that is $`\mathbb{1} + \mathbb{1} = \langle \omega, \omega \rangle`$:

```math
\begin{aligned}
& \lambda_{\mathbb{1}}\, (x : A).\, \lambda_{\mathbb{0}}\, (y : B).\, x : \Pi^{\mathbb{0}}_{\mathbb{1}}\, (x : A).\, \Pi^{\mathbb{0}}_{\mathbb{0}}\, (y : B).\, A &&(\mathsf{ex}_{\mathsf{const}}) \\
& \lambda_{\mathbb{0}}\, (A : U_l).\, \lambda_{\mathbb{1}}\, (x : A).\, x : \Pi^{\langle \omega, \omega \rangle}_{\mathbb{0}}\, (A : U_l).\, \Pi^{\mathbb{0}}_{\mathbb{1}}\, (x : A).\, A &&(\mathsf{ex}_{\mathsf{id}})
\end{aligned}
```
