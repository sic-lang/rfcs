# A Quotient

An example of [RFC 0035: Observational Equality](../0035-observational-equality.md), derived from its rules: nothing here is part of the type system, and its formulas are named with the prefix $`\mathsf{ex}`$.
The terms are written in a signature that declares the connectives of the propositions and the data and codata types they use.

A quotient by any equivalence relation is one declaration, whose relation and proofs are parameters; the class of a term is equal to the class of a related term, and a function out of the quotient is a recursor with a proof that its branch respects the relation:

```math
\begin{aligned}
& \mathsf{quotient}.\{\}\ (A : U_0,\ R : (x : A,\ y : A \vdash \Omega_0),\ r : (x : A \vdash R[x, x]),\ s : (x : A,\ y : A,\ h : R[x, y] \vdash R[y, x]), &&(\mathsf{ex}_{\mathsf{Quot}}) \\
& \quad t : (x : A,\ y : A,\ z : A,\ h_1 : R[x, y],\ h_2 : R[y, z] \vdash R[x, z])) : U_0\ \mathsf{where}\ \mathsf{Quot} \mathrel{≔} c : (x :^{\mathbb{0}}_{\mathbb{1}} A)\ /\ (x,\ y).\, R[x, y]\ \mathsf{by}\ (x).\, r[x],\ (x,\ y,\ h).\, s[x, y, h],\ (x,\ y,\ z,\ h_1,\ h_2).\, t[x, y, z, h_1, h_2] \\
& \mathsf{Quot}\ \bar a.c(u) \sim \mathsf{Quot}\ \bar a.c(v) \equiv R[u, v] \\
& \mathsf{rec}_{\mathbb{1}}\ q\ \mathsf{return}\ (z : \mathsf{Quot}\ \bar a).\, B\ \mathsf{with}\ c(x) \Rightarrow f \circ_{\mathbb{1}} x\ \mathsf{by}\ e \quad \text{for } e : (x : A,\ y : A,\ h : R[x, y] \vdash f \circ_{\mathbb{1}} x \sim_B f \circ_{\mathbb{1}} y)
\end{aligned}
```

The motive $`B`$ does not depend on $`z`$, so that the cast of $`(D^{/}_{\mathsf{rec}})`$ is removed by $`(\mathsf{cast}_{\mathsf{refl}})`$ in the proof of respect; at run time, the class is its term, and the recursor is the application of $`f`$.
