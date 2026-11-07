# Pairs

An example of [RFC 0034: Data and Codata Types](../0034-data-and-codata-types.md), derived from its rules: nothing here is part of the type system, and its formulas are named with the prefix $`\mathsf{ex}`$.
The declarations are written in a signature that holds them in order, each after those it uses, without the empty lists of variables of the declarations that have none; the grades written on an instance instantiate its grade variables.

A pair is a data type with one constructor and two fields, the second depending on the first; it is the multiplicative conjunction $`\otimes`$ of linear logic, since its user gets both fields, and a record of any number of fields is nested pairs, as the prelude of the RFC packs a telescope with a pair of the same shape, which is a declaration of its own:

```math
\begin{aligned}
& \mathsf{data}.\{s_1, s_2;\ l_1, l_2;\ p_1, q_1, p_2\}\ (A : s_{1 l_1},\ B : (x : A \vdash s_{2 l_2})) : U_{l_1 \sqcup l_2}\ \mathsf{where}\ {\otimes} \mathrel{≔} \mathsf{mk} : (x :^{q_1}_{p_1} A,\ y :^{\mathbb{0}}_{p_2} B[x]) &&(\mathsf{ex}_\otimes)
\end{aligned}
```

Its recursor is the match of a pair, and the rule $`(D^{+}_\eta)`$ makes every pair equal to the pair of its fields; the first field is read by the recursor whose branch returns it, which the usage allows when the grade of the second field lets the branch discard it:

```math
\begin{aligned}
& \mathsf{fst}(t) \;=\; \mathsf{rec}_{\mathbb{1}}\ t\ \mathsf{return}\ (z : A \otimes B).\, A\ \mathsf{with}\ \mathsf{mk}(x,\ y) \Rightarrow x &&(\mathsf{ex}_{\mathsf{fst}}) \\
& \Sigma;\ \gamma \mathrel{▶_{\mathbb{1}\mathbb{1}^{\mathsf{m}}}} t \text{ and } p_2 \le \mathbb{0} \implies \Sigma;\ \gamma \mathrel{▶_{\mathbb{1}\mathbb{1}^{\mathsf{m}}}} \mathsf{fst}(t)
\end{aligned}
```

A pair whose fields are propositions, in $`\Omega`$, is the conjunction of propositions, which the sort variables give with the sort $`\Omega_{l_1 \sqcup l_2}`$ in place of $`U_{l_1 \sqcup l_2}`$ and erased grades on its fields.
