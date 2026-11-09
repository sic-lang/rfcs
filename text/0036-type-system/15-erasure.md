# Erasure

This annex defines the erasure, which compiles a term to an untyped target language by replacing with $`\text{↯}`$ the parts whose grade is in a set of grades, the sets of grades that the modes do not count, and their properties.
It builds on the [grades](04-grades.md), the [modes](05-modes.md), the [syntax](08-syntax.md) and the [usage](11-usage.md).

## Definitions

The target language has variables, all of the first order, the constants at the grades of their instances, a value $`\text{↯}`$ that stands for what was erased, the constructors applied to terms for their fields, and the recursors, with a branch for each constructor:

```math
\begin{aligned}
& M \mathrel{::=} x \mid f.\{\bar p\} \mid \text{↯} \mid c(\bar M) \mid \mathsf{rec}\ M\ \mathsf{with}\ \bar N &&(\mathsf{syntax}_M) \\[1em]
& \bar M \mathrel{::=} () \mid (M,\ \bar M) &&(\mathsf{syntax}_{\bar M}) \\[1em]
& \bar N \mathrel{::=} () \mid ((\bar x;\ \bar y).\, N,\ \bar N) &&(\mathsf{syntax}_{\bar N})
\end{aligned}
```

A branch $`(\bar x;\ \bar y).\, N`$ binds the variables $`\bar x`$ of the fields and $`\bar y`$ of the recursive results, as a branch of a recursor does.

The erasure $`\lfloor t \rfloor_S`$ of a term $`t`$ replaces with $`\text{↯}`$ each position of $`t`$ whose grade is in the set $`S`$, a position being a subterm that a rule of usage checks with a grade of its own, as an argument $`t_j`$ of an entry of grade $`p_j`$ in $`(\mathsf{tel}_{,▶})`$.
It is defined on the terms whose scope has no second-order variable: a program is closed, and the motives and the branches of a recursor bind variables only, while a second-order variable exists only in the contexts in which a declaration is checked, so that a variable has no arguments, and the target language no second-order variables.
It is defined in a signature $`\Sigma`$, which gives the grades of the fields of the constructors and which the notation leaves implicit, as the rules of usage read their grades in the signature.

The grades $`\mathsf{grades}_\Sigma(T.c)`$ of the fields of the constructor $`c`$ of an instance $`T = D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a`$ are the grades of its telescope $`\Theta`$ at the instance $`\bar s`$, $`\bar p`$, in the last entry of $`\Sigma`$ that declares a type $`D`$ with a constructor $`c`$ and as many sort and grade variables as $`\bar s`$ and $`\bar p`$, and none when $`\Sigma`$ has no such entry:

```math
\begin{aligned}
& \mathsf{grades}_\Sigma(T.c) = \text{the grades of } \Theta \text{ if } (\mathsf{data}.\{\bar s;\ \bar l;\ \bar p\}\ \Delta : \kappa\ \mathsf{where}\ \dots;\ D \mathrel{▶} \zeta \mathrel{≔} \dots \mid c : \Theta \mid \dots;\ \dots) \text{ is this entry} &&(\mathsf{grades}_c) \\
& \mathsf{grades}_\Sigma(T.c) = () \text{ if } \Sigma \text{ has no such entry}
\end{aligned}
```

The sorts and the instances have no representation in the target language, and are erased.
A constructor keeps its fields, each erased at the grade of its field, and a field whose grade the signature does not give, in a term that no rule types, is erased; a recursor keeps its term, erased at its grade $`r`$, and its branches, and loses its motives, which are types.
The erasure $`\lfloor t \rfloor_{S, p}`$ of a position of grade $`p`$ is $`\text{↯}`$ when $`p \in S`$, and $`\lfloor t \rfloor_S`$ otherwise:

```math
\begin{aligned}
& \lfloor x \rfloor_S = x &&(\mathsf{erase}_t) \\
& \lfloor \kappa \rfloor_S = \text{↯} \\
& \lfloor f.\{\bar s;\ \bar l;\ \bar p\} \rfloor_S = f.\{\bar p\} \\
& \lfloor D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a \rfloor_S = \text{↯} \\
& \lfloor T.c(\bar t) \rfloor_S = c(\lfloor \bar t \rfloor_{S, \mathsf{grades}_\Sigma(T.c)}) \\
& \lfloor \mathsf{rec}_r\ t\ \mathsf{return}\ \bar C\ \mathsf{with}\ \bar u \rfloor_S = \mathsf{rec}\ \lfloor t \rfloor_{S, r}\ \mathsf{with}\ \lfloor \bar u \rfloor_S \\
& \lfloor t \rfloor_{S, p} = \text{↯} \text{ if } p \in S \\
& \lfloor t \rfloor_{S, p} = \lfloor t \rfloor_S \text{ if } p \notin S \\[1em]
& \lfloor () \rfloor_{S, \bar p} = () &&(\mathsf{erase}_{\bar t}) \\
& \lfloor (t,\ \bar t) \rfloor_{S, ()} = (\text{↯},\ \lfloor \bar t \rfloor_{S, ()}) \\
& \lfloor (t,\ \bar t) \rfloor_{S, (p,\ \bar p)} = (\lfloor t \rfloor_{S, p},\ \lfloor \bar t \rfloor_{S, \bar p}) \\[1em]
& \lfloor () \rfloor_S = () &&(\mathsf{erase}_{\bar u}) \\
& \lfloor ((\bar x;\ \bar y).\, u,\ \bar u) \rfloor_S = ((\bar x;\ \bar y).\, \lfloor u \rfloor_S,\ \lfloor \bar u \rfloor_S)
\end{aligned}
```

A constant keeps the grades of its instance and loses its qualities and its levels: the positions of its body that the erasure removes depend on the grades that instantiate its grade variables, and on nothing else, since the erasure follows the grades alone.
The term $`f.\{\bar p\}`$ of the target language thus names the copy of $`f`$ compiled for the grades $`\bar p`$, the erasure of its body for this instance, as the [monomorphization](https://doc.rust-lang.org/book/ch10-01-syntax.html#performance-of-code-using-generics) of Rust compiles a copy of a generic function for each instance of its type parameters, so that no grade remains at run time: if the body of $`f`$ checks with its grade variable $`p`$ a position that computes from its parameter, the extraction erases this position in $`f.\{{00}^{\mathsf{p}}\}`$ and keeps it in $`f.\{{11}^{\mathsf{p}}\}`$.

A term checked in the mode $`m`$ checks a position of grade $`p`$ in the mode $`m \odot p`$, and does not count the uses of the positions that it checks in a more erased mode, whose grades form the set $`S^m`$:

```math
\begin{aligned}
& S^m = \{p \mid m \odot p \ne m\} &&(\mathsf{uncounted}_m)
\end{aligned}
```

The erasure $`\lfloor t \rfloor_{S^{{11}^{\mathsf{m}}}}`$ is thus the extraction $`t^\bullet`$ of [Abel, Danielsson and Eriksson](https://doi.org/10.1145/3607862), which removes what has no use at run time, and $`\lfloor t \rfloor_{S^{{01}^{\mathsf{m}}}}`$ keeps the proofs, the specifications and the permissions that the extraction removes, as the ghost code of [Verus](https://doi.org/10.1145/3586037) is checked but never run.

A set $`S`$ of grades erases only what the mode $`m`$ does not count when it erases neither the grade $`\ulcorner m \urcorner`$, with which a variable checked in the mode $`m`$ uses itself, nor a grade above one that it keeps, nor a part of a sum that it erases:

```math
\begin{aligned}
& \ulcorner m \urcorner \notin S &&(\mathsf{uncounted}_S.\mathsf{grade}) \\[1em]
& p \le q \text{ and } p \in S \implies q \in S &&(\mathsf{uncounted}_S.{\le}) \\[1em]
& p + q \in S \implies p \in S &&(\mathsf{uncounted}_S.{+})
\end{aligned}
```

A variable occurs in a term of the target language when the term is the variable, or when the variable occurs in one of its subterms, a field of a constructor, the term or a branch of a recursor; it occurs in arguments or in branches when it occurs in one of them:

```math
\begin{gathered}
\frac{}{x \text{ occurs in } x}\;(\mathsf{occurs}_M.x) \\[1em]
\frac{x \text{ occurs in } \bar M}{x \text{ occurs in } c(\bar M)}\;(\mathsf{occurs}_M.c) \\[1em]
\frac{x \text{ occurs in } M}{x \text{ occurs in } \mathsf{rec}\ M\ \mathsf{with}\ \bar N}\;(\mathsf{occurs}_M.\mathsf{rec}) \\[1em]
\frac{x \text{ occurs in } \bar N}{x \text{ occurs in } \mathsf{rec}\ M\ \mathsf{with}\ \bar N}\;(\mathsf{occurs}_M.\mathsf{with}) \\[1em]
\frac{x \text{ occurs in } M}{x \text{ occurs in } (M,\ \bar M)}\;(\mathsf{occurs}_{\bar M}.M) \\[1em]
\frac{x \text{ occurs in } \bar M}{x \text{ occurs in } (M,\ \bar M)}\;(\mathsf{occurs}_{\bar M}.\bar M) \\[1em]
\frac{x \text{ occurs in } N}{x \text{ occurs in } ((\bar x;\ \bar y).\, N,\ \bar N)}\;(\mathsf{occurs}_{\bar N}.N) \\[1em]
\frac{x \text{ occurs in } \bar N}{x \text{ occurs in } ((\bar x;\ \bar y).\, N,\ \bar N)}\;(\mathsf{occurs}_{\bar N}.\bar N)
\end{gathered}
```

In $`(\mathsf{occurs}_{\bar N}.N)`$, the variable $`x`$ is not among the variables $`\bar x`$ and $`\bar y`$ that the branch binds, since they take names that $`x`$ does not use.

The judgment $`M \sqsubseteq N`$ reads: the term $`M`$ of the target language is less defined than $`N`$, which is $`M`$ with some of its subterms $`\text{↯}`$ replaced by other terms, as the order of the approximants of the Böhm trees of [Kerinec, Manzonetto and Pagani](https://doi.org/10.23638/LMCS-16(3:6)2020), generated by the undefined value below every value; a constructor and a recursor are less defined than the same constructor and recursor when their subterms are, and arguments and branches when they are one by one:

```math
\begin{gathered}
\frac{}{\text{↯} \sqsubseteq M}\;({\sqsubseteq}.\text{↯}) \\[1em]
\frac{}{x \sqsubseteq x}\;({\sqsubseteq}.x) \\[1em]
\frac{}{f.\{\bar p\} \sqsubseteq f.\{\bar p\}}\;({\sqsubseteq}.f) \\[1em]
\frac{\bar M_1 \sqsubseteq \bar M_2}{c(\bar M_1) \sqsubseteq c(\bar M_2)}\;({\sqsubseteq}.c) \\[1em]
\frac{M_1 \sqsubseteq M_2 \quad \bar N_1 \sqsubseteq \bar N_2}{\mathsf{rec}\ M_1\ \mathsf{with}\ \bar N_1 \sqsubseteq \mathsf{rec}\ M_2\ \mathsf{with}\ \bar N_2}\;({\sqsubseteq}.\mathsf{rec}) \\[1em]
\frac{}{() \sqsubseteq ()}\;({\sqsubseteq}_{\bar M}.\varepsilon) \\[1em]
\frac{M_1 \sqsubseteq M_2 \quad \bar M_1 \sqsubseteq \bar M_2}{(M_1,\ \bar M_1) \sqsubseteq (M_2,\ \bar M_2)}\;({\sqsubseteq}_{\bar M}.{,}) \\[1em]
\frac{}{() \sqsubseteq ()}\;({\sqsubseteq}_{\bar N}.\varepsilon) \\[1em]
\frac{N_1 \sqsubseteq N_2 \quad \bar N_1 \sqsubseteq \bar N_2}{((\bar x;\ \bar y).\, N_1,\ \bar N_1) \sqsubseteq ((\bar x;\ \bar y).\, N_2,\ \bar N_2)}\;({\sqsubseteq}_{\bar N}.{,})
\end{gathered}
```

## Properties

The set $`S^m`$ is, for the mode $`{11}^{\mathsf{m}}`$ of run time, the grades without use at run time, for the mode $`{01}^{\mathsf{m}}`$, the grade without any use, and, for the mode $`{00}^{\mathsf{m}}`$, which counts no use, empty, and it erases only what its mode does not count:

```math
\begin{aligned}
& \text{and} &&(\mathsf{values}_m) \\
& \quad p \in S^{{11}^{\mathsf{m}}} \iff \mathsf{run}(p) = 0 \\
& \quad p \in S^{{01}^{\mathsf{m}}} \iff p = {00}^{\mathsf{p}} \\
& \quad p \notin S^{{00}^{\mathsf{m}}} \\[1em]
& S^m \text{ erases only what } m \text{ does not count} &&(\mathsf{erases}_m)
\end{aligned}
```

A variable whose grade is in a set $`S`$ is absent from the erasure by $`S`$ of a term checked in a mode whose uses $`S`$ does not erase, and the erasure by a larger set is less defined, so that the extraction is the program that the proofs see with more parts erased:

```math
\begin{aligned}
& \text{⟹} &&(\mathsf{absent}_S) \\
& \quad \text{and} \\
& \qquad S \text{ erases only what } m \text{ does not count} \\
& \qquad \Sigma;\ \gamma \vdash t \mathrel{▶} m \\
& \qquad \gamma(x) \in S \\
& \quad x \text{ does not occur in } \lfloor t \rfloor_S \\[1em]
& S_1 \subseteq S_2 \implies \lfloor t \rfloor_{S_2} \sqsubseteq \lfloor t \rfloor_{S_1} &&(\sqsubseteq_S)
\end{aligned}
```

The condition on the mode is needed: the variable $`x`$ checked in the mode $`{01}^{\mathsf{m}}`$ uses itself with the grade $`{01}^{\mathsf{p}}`$, which is in $`S^{{11}^{\mathsf{m}}}`$, but $`\lfloor x \rfloor_{S^{{11}^{\mathsf{m}}}} = x`$; Abel, Danielsson and Eriksson likewise state the absence for their mode `𝟙ᵐ` only, as [`erased-hasX`](https://github.com/graded-type-theory/graded-type-theory/blob/master/Graded/Erasure/Extraction/Properties/Usage.agda).

The erasure states nothing on the ownership: it follows the grades of the usage alone, which the ownership reads without deciding what is erased, and what the ownership of a term guarantees of its erasure, the uses of a value during a run, needs the reduction of the target language, which the meaning of the judgments states.
