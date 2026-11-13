# Evaluation

This annex defines the evaluation of the target language of the erasure, the calling convention of Sic, the extension of the heaps, the demands of the values and of the environments, and their properties.
It builds on the [vectors](10-grade-vectors.md#vectors), the [syntax](08-syntax.md), the [erasure](16-erasure.md) and its [usage](16-erasure.md#definitions), and the [type of positions](19-prelude.md#positions) of the prelude.

## Definitions

The calling convention is the call by value, everywhere: the fields of a constructor, the arguments of an observation, the entries of the state of a corecursor and the recursive results of a branch of a recursor are evaluated before they are bound, so that a variable is bound to the address of a value, and an access to a variable reads it, without computing anything.
Each binding allocates a cell for each of its variables, which holds the address of its value and the multiplicity of its binder, and an access to a variable reads its cell, which the evaluation records, so that the cells read by a run count the uses at run time of each binding while the heap stays immutable.
A value stores each address that it holds, a field of a constructor or an entry of the state of a closure, at the multiplicity of its position, and an observation passes its arguments at theirs: these multiplicities bound the uses of a value through its position, which a closure observed again would otherwise exceed, since each observation runs a branch again.
A recursor and an observation check that the binders of the branch they run are within these multiplicities, the recursor of the multiplicity $`\rho`$ reading each field $`\rho`$ times its multiplicity, and the evaluation is stuck otherwise; for a program that the erasure gives, the [relation of run time](20-run-time.md) shows that the checks pass.
A corecursor computes nothing until it is observed, and each observation runs the branch of its destructor again, without keeping its result: the laziness is explicit, a corecursor that the program builds, and the sharing too, a variable that the program binds.
A constant is unfolded at each of its uses, as the reduction unfolds it, rather than evaluated once, so that a program has no state of its own.

A value is $`\text{↯}`$, the constructor of a case applied to the addresses of its fields, each at a multiplicity, the closure of a corecursor, which holds the environment of its variables, its branches and the addresses of its state, each at a multiplicity, or the cell $`\mathsf{bind}_\pi(\ell)`$ of a variable bound to the address $`\ell`$ by a binder of multiplicity $`\pi`$:

```math
\begin{aligned}
& V \mathrel{::=} \text{↯} \mid c_i(\bar\ell \mathrel{▶} \bar\pi) \mid \langle E;\ \bar P;\ \bar\ell \mathrel{▶} \bar\pi \rangle \mid \mathsf{bind}_\pi(\ell) &&(\mathsf{syntax}_V)
\end{aligned}
```

A heap $`H`$ is a sequence of values, the address $`\ell`$ of a value being its position in it, the first one at $`1`$, so that $`H(\ell)`$ is the value at the address $`\ell`$, and $`{(H,\ V)}`$ allocates $`V`$ at the address $`{|H| + 1}`$, where $`|H|`$ is the number of the values of $`H`$; $`\varepsilon`$ is the empty heap.
An environment $`E`$ gives each variable of a scope the address of its cell, $`E(x)`$, and $`{E,\ \bar x \mapsto \bar\ell}`$ extends it with the addresses $`\bar\ell`$ of the cells of the variables $`\bar x`$, as many; $`\varepsilon`$ is the environment of the empty scope.
A binder of the variables $`\bar x`$, at the multiplicities $`\bar\pi`$, allocates their cells, $`{(H,\ \mathsf{bind}_{\bar\pi}(\bar\ell))}`$, one for each address of $`\bar\ell`$, at the addresses $`{|H| + 1, \dots, |H| + n}`$, where $`n`$ is the number of the addresses of $`\bar\ell`$, which $`{|H| + \bar n}`$ abbreviates; the cells $`E`$ bind the addresses $`\bar\ell`$ in the heap $`H`$, $`{H \vdash E \mapsto \bar\ell}`$, when they are as many and each is the cell of the address at its position:

```math
\begin{aligned}
& (H,\ \mathsf{bind}_{(\pi_1, \dots, \pi_n)}((\ell_1, \dots, \ell_n))) = (H,\ \mathsf{bind}_{\pi_1}(\ell_1),\ \dots,\ \mathsf{bind}_{\pi_n}(\ell_n)) &&(\mathsf{bind}_H) \\[1em]
& H \vdash (c_1, \dots, c_n) \mapsto (\ell_1, \dots, \ell_n) \iff \forall i.\ \exists \pi.\ H(c_i) = \mathsf{bind}_\pi(\ell_i) &&(\mapsto_H)
\end{aligned}
```

A program $`\mathcal{P}`$ gives a constant at the qualities and the grades of an instance, $`{f.\{\bar s;\ \bar p\}}`$, a closed term of the target language, its body.
The program $`\lfloor \Sigma \rfloor_S`$ of a signature $`\Sigma`$, erased by a set of grades $`S`$, gives $`{f.\{\bar s';\ \bar p'\}}`$ the erasure by $`S`$ of the body of $`f`$ at this instance, in the last entry of $`\Sigma`$ that defines $`f`$ with as many sort and grade variables as $`\bar s'`$ and $`\bar p'`$, and nothing when $`\Sigma`$ has no such entry:

```math
\begin{aligned}
& \lfloor \Sigma \rfloor_S(f.\{\bar s';\ \bar p'\}) = \lfloor t[\bar s' / \bar s,\ \bar p' / \bar p] \rfloor_S \text{ if } f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \mathrel{≔} t \text{ is this entry} &&(\mathsf{erase}_\Sigma)
\end{aligned}
```

The judgment $`{\mathcal{P};\ H;\ E \vdash M \Downarrow \ell;\ H';\ R}`$ reads: in the program $`\mathcal{P}`$, the term $`M`$ of the target language, in the environment $`E`$ and the heap $`H`$, evaluates to the address $`\ell`$ of its value in the heap $`H'`$, reading the cells $`R`$, a sequence of addresses in the order of the reads, with an address for each read; $`R_1 \cdot R_2`$ joins two sequences.
The judgment $`{\mathcal{P};\ H;\ E \vdash \bar M \Downarrow \bar\ell;\ H';\ R}`$ reads: the terms $`\bar M`$ evaluate, the first one first, to the addresses $`\bar\ell`$.
A variable reads its cell, which gives the address of its value, a constant evaluates its body in the empty environment, $`\text{↯}`$, a constructor and a corecursor evaluate their fields and their state and allocate their value, which stores them at the [multiplicities](16-erasure.md#definitions) $`\bar\pi(\bar M)`$ of their terms, a recursor evaluates its term and eliminates its value, and an observation evaluates its term and its arguments and observes the value of its term, with the multiplicities of its arguments:

```math
\begin{gathered}
\frac{\begin{gathered}{}E(x) = c \\ H(c) = \mathsf{bind}_\pi(\ell)\end{gathered}}{\mathcal{P};\ H;\ E \vdash x \Downarrow \ell;\ H;\ c}\;(\mathsf{eval}_x) \\[1em]
\frac{\begin{gathered}{}\mathcal{P}(f.\{\bar s;\ \bar p\}) = M \\ \mathcal{P};\ H;\ \varepsilon \vdash M \Downarrow \ell;\ H';\ R\end{gathered}}{\mathcal{P};\ H;\ E \vdash f.\{\bar s;\ \bar p\} \Downarrow \ell;\ H';\ R}\;(\mathsf{eval}_f) \\[1em]
\frac{}{\mathcal{P};\ H;\ E \vdash \text{↯} \Downarrow |H| + 1;\ (H,\ \text{↯});\ ()}\;(\mathsf{eval}_{\text{↯}}) \\[1em]
\frac{\mathcal{P};\ H;\ E \vdash \bar M \Downarrow \bar\ell;\ H';\ R}{\mathcal{P};\ H;\ E \vdash c_i(\bar M) \Downarrow |H'| + 1;\ (H',\ c_i(\bar\ell \mathrel{▶} \bar\pi(\bar M)));\ R}\;(\mathsf{eval}_c) \\[1em]
\frac{\begin{gathered}{}\mathcal{P};\ H_1;\ E \vdash M \Downarrow \ell;\ H_2;\ R_1 \\ \mathcal{P};\ H_2;\ E \vdash \mathsf{rec}_\rho\ \ell\ \mathsf{with}\ \bar N \Downarrow \ell';\ H_3;\ R_2\end{gathered}}{\mathcal{P};\ H_1;\ E \vdash \mathsf{rec}_\rho\ M\ \mathsf{with}\ \bar N \Downarrow \ell';\ H_3;\ R_1 \cdot R_2}\;(\mathsf{eval}_{\mathsf{rec}}) \\[1em]
\frac{\begin{gathered}{}\mathcal{P};\ H_1;\ E \vdash M \Downarrow \ell;\ H_2;\ R_1 \\ \mathcal{P};\ H_2;\ E \vdash \bar M \Downarrow \bar\ell;\ H_3;\ R_2 \\ \mathcal{P};\ H_3 \vdash \ell.d_i(\bar\ell \mathrel{▶} \bar\pi(\bar M)) \Downarrow \ell';\ H_4;\ R_3\end{gathered}}{\mathcal{P};\ H_1;\ E \vdash M.d_i(\bar M) \Downarrow \ell';\ H_4;\ R_1 \cdot R_2 \cdot R_3}\;(\mathsf{eval}_d) \\[1em]
\frac{\mathcal{P};\ H;\ E \vdash \bar M \Downarrow \bar\ell;\ H';\ R}{\mathcal{P};\ H;\ E \vdash \mathsf{corec}\ \mathsf{from}\ \bar M\ \mathsf{with}\ \bar P \Downarrow |H'| + 1;\ (H',\ \langle E;\ \bar P;\ \bar\ell \mathrel{▶} \bar\pi(\bar M) \rangle);\ R}\;(\mathsf{eval}_{\mathsf{corec}}) \\[1em]
\frac{}{\mathcal{P};\ H;\ E \vdash () \Downarrow ();\ H;\ ()}\;(\mathsf{eval}_{\bar M}.\varepsilon) \\[1em]
\frac{\begin{gathered}{}\mathcal{P};\ H_1;\ E \vdash M \Downarrow \ell;\ H_2;\ R_1 \\ \mathcal{P};\ H_2;\ E \vdash \bar M \Downarrow \bar\ell;\ H_3;\ R_2\end{gathered}}{\mathcal{P};\ H_1;\ E \vdash (M \mathrel{▶} \pi,\ \bar M) \Downarrow (\ell,\ \bar\ell);\ H_3;\ R_1 \cdot R_2}\;(\mathsf{eval}_{\bar M}.{,})
\end{gathered}
```

The judgment $`{\mathcal{P};\ H;\ E \vdash \mathsf{rec}_\rho\ \ell\ \mathsf{with}\ \bar N \Downarrow \ell';\ H';\ R}`$ reads: the recursor of the multiplicity $`\rho`$ with the branches $`\bar N`$, in the environment $`E`$, eliminates the value at the address $`\ell`$, a constructor, to the address $`\ell'`$.
The branch of the case of the constructor evaluates, with cells for its fields and for its recursive results, each the recursor on its field, or $`\text{↯}`$ when it is erased, which the judgment $`{\mathcal{P};\ H;\ E \vdash \mathsf{rec}_\rho\ \bar\ell\ \mathsf{with}\ \bar N \leftarrow \bar k \Downarrow \bar\ell';\ H';\ R}`$ gives, in order, for the fields at the addresses $`\bar\ell`$.
The branch must read each field within $`\rho`$ times the multiplicity $`\pi_{0l}`$ at which the constructor stores it: by its cell, at the multiplicity $`\pi_l`$ of its binder, and by the recursions on it, each of which eliminates its value at $`\rho`$ again, and is computed once but read as the binder of its result allows, each read using the value that the recursion builds from the field, $`\mathsf{recursions}(\bar k,\ \bar\pi',\ l)`$ times, which adds the multiplicities of the binders of the recursive results whose field is $`l`$:

```math
\begin{aligned}
& \mathsf{recursions}((k_1, \dots, k_b),\ (\pi'_1, \dots, \pi'_b),\ l) = \pi_1 + \dots + \pi_b \text{ where } \pi_j = \pi'_j \text{ if } k_j = l \text{ and } \pi_j = 0 \text{ otherwise} &&(\mathsf{recursions}_{\bar k, \bar\pi', l})
\end{aligned}
```

```math
\begin{gathered}
\frac{\begin{gathered}{}H_1(\ell) = c_i(\bar\ell \mathrel{▶} \bar\pi_0) \\ \text{the branch } i \text{ of } \bar N \text{ is } (\bar x \mathrel{▶} \bar\pi;\ \bar y \mathrel{▶} \bar\pi' \leftarrow \bar k).\, N \\ \bar\ell \text{ and } \bar x \text{ are as many} \\ \forall l \le |\bar x|.\ \rho \cdot \pi_{0l} \le \pi_l + \rho \cdot \mathsf{recursions}(\bar k,\ \bar\pi',\ l) \\ \mathcal{P};\ H_1;\ E \vdash \mathsf{rec}_\rho\ \bar\ell\ \mathsf{with}\ \bar N \leftarrow \bar k \Downarrow \bar\ell';\ H_2;\ R_1 \\ \mathcal{P};\ (H_2,\ \mathsf{bind}_{\bar\pi, \bar\pi'}(\bar\ell,\ \bar\ell'));\ E,\ \bar x\, \bar y \mapsto |H_2| + \bar n \vdash N \Downarrow \ell';\ H_3;\ R_2\end{gathered}}{\mathcal{P};\ H_1;\ E \vdash \mathsf{rec}_\rho\ \ell\ \mathsf{with}\ \bar N \Downarrow \ell';\ H_3;\ R_1 \cdot R_2}\;(\iota_\Downarrow) \\[1em]
\frac{}{\mathcal{P};\ H;\ E \vdash \mathsf{rec}_\rho\ \bar\ell\ \mathsf{with}\ \bar N \leftarrow () \Downarrow ();\ H;\ ()}\;(\mathsf{results}_\Downarrow.\varepsilon) \\[1em]
\frac{\mathcal{P};\ (H_1,\ \text{↯});\ E \vdash \mathsf{rec}_\rho\ \bar\ell\ \mathsf{with}\ \bar N \leftarrow \bar k \Downarrow \bar\ell';\ H_2;\ R}{\mathcal{P};\ H_1;\ E \vdash \mathsf{rec}_\rho\ \bar\ell\ \mathsf{with}\ \bar N \leftarrow (\bot,\ \bar k) \Downarrow (|H_1| + 1,\ \bar\ell');\ H_2;\ R}\;(\mathsf{results}_\Downarrow.\text{↯}) \\[1em]
\frac{\begin{gathered}{}\ell_j \text{ is the address at the position } j \text{ in } \bar\ell \\ \mathcal{P};\ H_1;\ E \vdash \mathsf{rec}_\rho\ \ell_j\ \mathsf{with}\ \bar N \Downarrow \ell';\ H_2;\ R_1 \\ \mathcal{P};\ H_2;\ E \vdash \mathsf{rec}_\rho\ \bar\ell\ \mathsf{with}\ \bar N \leftarrow \bar k \Downarrow \bar\ell';\ H_3;\ R_2\end{gathered}}{\mathcal{P};\ H_1;\ E \vdash \mathsf{rec}_\rho\ \bar\ell\ \mathsf{with}\ \bar N \leftarrow (j,\ \bar k) \Downarrow (\ell',\ \bar\ell');\ H_3;\ R_1 \cdot R_2}\;(\mathsf{results}_\Downarrow.\mathsf{rec})
\end{gathered}
```

The judgment $`{\mathcal{P};\ H \vdash \ell.d_i(\bar\ell \mathrel{▶} \bar\pi) \Downarrow \ell';\ H';\ R}`$ reads: the observation by the destructor of the case $`i`$, applied to the arguments at the addresses $`\bar\ell`$, at the multiplicities $`\bar\pi`$, of the value at the address $`\ell`$, a closure, evaluates to the address $`\ell'`$.
The branch of the case evaluates in the environment of the closure, with cells for its state and for the arguments, whose binders must be within the multiplicities at which the closure stores its state and the observation passes its arguments, and its value is resumed, which the judgment $`{H \vdash \langle E;\ \bar P \rangle \circlearrowleft_k \ell \Downarrow \ell';\ H'}`$ gives: the value at the address $`\ell`$ itself when the branch resumes no state, $`{k = \bot}`$, a new closure of the same environment and branches from the state of $`n`$ entries that $`\mathsf{next}`$ packs, $`{k = n}`$, each at the multiplicity at which the pack stores it, times that $`\pi`$ of the field of $`\mathsf{next}`$, $`{\pi \cdot \bar\pi}`$ multiplying each multiplicity of $`\bar\pi`$ by $`\pi`$ on the left, or from $`n`$ erased entries, $`{k = \text{↯}_n}`$, which stand at the address $`\ell_1`$ of the new state without reading it, at the multiplicity $`0`$, $`\ell_1^n`$ and $`0^n`$ being $`n`$ times $`\ell_1`$ and $`0`$, or the term already built that $`\mathsf{done}`$ holds, these constructors being the cases $`1`$ and $`2`$ of the type of positions.
The judgment $`{H \vdash \mathsf{unpack}_k(\ell) = \bar\ell \mathrel{▶} \bar\pi}`$ reads: the value at the address $`\ell`$ packs the $`k`$ entries at the addresses $`\bar\ell`$, the first fields of $`k`$ nested pairs, each the case $`1`$ of the pair, at the multiplicities $`\bar\pi`$ at which the pairs store them, each times those of the second fields that hold its pair:

```math
\begin{gathered}
\frac{\begin{gathered}{}H_1(\ell) = \langle E;\ \bar P;\ \bar\ell_1 \mathrel{▶} \bar\pi_1 \rangle \\ \text{the branch } i \text{ of } \bar P \text{ is } (\bar y \mathrel{▶} \bar\pi;\ \bar z \mathrel{▶} \bar\pi' \circlearrowleft k).\, P \\ \bar\ell_1 \text{ and } \bar y \text{ are as many} \\ \bar\ell_2 \text{ and } \bar z \text{ are as many} \\ \forall l \le |\bar y|.\ \pi_{1l} \le \pi_l \\ \forall l \le |\bar z|.\ \pi_{2l} \le \pi'_l \\ \mathcal{P};\ (H_1,\ \mathsf{bind}_{\bar\pi, \bar\pi'}(\bar\ell_1,\ \bar\ell_2));\ E,\ \bar y\, \bar z \mapsto |H_1| + \bar n \vdash P \Downarrow \ell_3;\ H_2;\ R \\ H_2 \vdash \langle E;\ \bar P \rangle \circlearrowleft_k \ell_3 \Downarrow \ell';\ H_3\end{gathered}}{\mathcal{P};\ H_1 \vdash \ell.d_i(\bar\ell_2 \mathrel{▶} \bar\pi_2) \Downarrow \ell';\ H_3;\ R}\;(\beta_\Downarrow) \\[1em]
\frac{}{H \vdash \langle E;\ \bar P \rangle \circlearrowleft_\bot \ell \Downarrow \ell;\ H}\;(\mathsf{resume}_\Downarrow.\bot) \\[1em]
\frac{\begin{gathered}{}H(\ell) = c_1(\ell_1 \mathrel{▶} \pi) \\ H \vdash \mathsf{unpack}_n(\ell_1) = \bar\ell \mathrel{▶} \bar\pi\end{gathered}}{H \vdash \langle E;\ \bar P \rangle \circlearrowleft_n \ell \Downarrow |H| + 1;\ (H,\ \langle E;\ \bar P;\ \bar\ell \mathrel{▶} \pi \cdot \bar\pi \rangle)}\;(\mathsf{resume}_\Downarrow.\mathsf{next}) \\[1em]
\frac{H(\ell) = c_1(\ell_1 \mathrel{▶} \pi)}{H \vdash \langle E;\ \bar P \rangle \circlearrowleft_{\text{↯}_n} \ell \Downarrow |H| + 1;\ (H,\ \langle E;\ \bar P;\ \ell_1^n \mathrel{▶} 0^n \rangle)}\;(\mathsf{resume}_\Downarrow.\text{↯}) \\[1em]
\frac{\begin{gathered}{}k \ne \bot \\ H(\ell) = c_2(\ell_1 \mathrel{▶} \pi)\end{gathered}}{H \vdash \langle E;\ \bar P \rangle \circlearrowleft_k \ell \Downarrow \ell_1;\ H}\;(\mathsf{resume}_\Downarrow.\mathsf{done}) \\[1em]
\frac{}{H \vdash \mathsf{unpack}_0(\ell) = () \mathrel{▶} ()}\;(\mathsf{unpack}_\Downarrow.0) \\[1em]
\frac{\begin{gathered}{}H(\ell) = c_1(\ell_1 \mathrel{▶} \pi_1,\ \ell_2 \mathrel{▶} \pi_2) \\ H \vdash \mathsf{unpack}_k(\ell_2) = \bar\ell \mathrel{▶} \bar\pi\end{gathered}}{H \vdash \mathsf{unpack}_{k + 1}(\ell) = (\ell_1,\ \bar\ell) \mathrel{▶} (\pi_1,\ \pi_2 \cdot \bar\pi)}\;(\mathsf{unpack}_\Downarrow.{,})
\end{gathered}
```

The evaluation only allocates, at the end of the heap, and never changes a value, so that the heap at a later point of a run extends the heap at an earlier point.
A heap $`H'`$ extends a heap $`H`$, written $`{H \sqsubseteq H'}`$, when $`H`$ is a prefix of $`H'`$, which keeps the value at each address of $`H`$:

```math
\begin{aligned}
& H \sqsubseteq H' \iff \exists \bar V.\ H' = (H,\ \bar V) &&(\sqsubseteq_H)
\end{aligned}
```

The guarantees on the uses at run time compare the cells that a run reads with a demand, the reads that remain to be done.
A demand $`D`$ is a vector over the addresses of the heaps whose elements are [multiplicities](03-multiplicities.md), $`D(c)`$ bounding the reads of the cell at the address $`c`$; its zero $`0^D`$ gives each address the multiplicity $`0`$, and its operations and its order are those of the vectors, written $`{+^D}`$, $`{\cdot^D}`$ and $`{\le^D}`$.
The demand $`[c]`$ is one read of the cell at the address $`c`$, and the uses $`\#R`$ of a trace $`R`$ give each address the multiplicity of the number of its reads in $`R`$, $`\omega`$ for more than one:

```math
\begin{aligned}
& D(c) \text{ is a multiplicity for every address } c &&(\mathsf{demand}_D) \\[1em]
& [c](c) = 1 \text{ and } [c](c') = 0 \text{ if } c' \ne c &&(\mathsf{unit}_D) \\[1em]
& \#R(c) = 0,\ 1 \text{ or } \omega \text{ if } c \text{ occurs no time, once or more than once in } R &&(\mathsf{uses}_R)
\end{aligned}
```

The judgment $`{H \vdash \ell \mathrel{▶} D}`$ reads: a use of the value at the address $`\ell`$ of the heap $`H`$ reads the cells as the demand $`D`$ allows.
The judgment $`{H \vdash \bar\ell \mathrel{▶} \bar\pi \mathrel{▶} D}`$ reads: the values at the addresses $`\bar\ell`$, each used as many times as its multiplicity in $`\bar\pi`$, read the cells as $`D`$ allows.
The judgment $`{H \vdash E \mathrel{▶}_\nu D}`$ reads: a term that reads the variables of the environment $`E`$ as the [vector of multiplicities](10-grade-vectors.md#vectors-of-multiplicities) $`\nu`$ allows reads the cells as $`D`$ allows, $`\nu(x)`$ reads of the cell of each variable $`x`$, each using its value.
The value $`\text{↯}`$ reads no cell, a constructor passes on the reads of its fields, each as many times as its multiplicity, and a closure does the reads of its branches, which read the variables of its scope as some $`\delta`$ that the usage of its branches allows, and passes on those of its state, each entry as many times as its multiplicity; a value may have several demands, one for each choice of $`\delta`$ in each closure that it reaches:

```math
\begin{gathered}
\frac{H(\ell) = \text{↯}}{H \vdash \ell \mathrel{▶} 0^D}\;(\mathsf{demand}_\ell.\text{↯}) \\[1em]
\frac{H(\ell) = c_i(\bar\ell \mathrel{▶} \bar\pi) \quad H \vdash \bar\ell \mathrel{▶} \bar\pi \mathrel{▶} D}{H \vdash \ell \mathrel{▶} D}\;(\mathsf{demand}_\ell.c) \\[1em]
\frac{\begin{gathered}{}H(\ell) = \langle E;\ \bar P;\ \bar\ell \mathrel{▶} \bar\pi \rangle \\ \delta \vdash \bar P \mathrel{▶} \\ H \vdash E \mathrel{▶}_\delta D_1 \\ H \vdash \bar\ell \mathrel{▶} \bar\pi \mathrel{▶} D_2\end{gathered}}{H \vdash \ell \mathrel{▶} D_1 +^D D_2}\;(\mathsf{demand}_\ell.\mathsf{corec}) \\[1em]
\frac{}{H \vdash () \mathrel{▶} () \mathrel{▶} 0^D}\;(\mathsf{demand}_{\bar\ell}.\varepsilon) \\[1em]
\frac{H \vdash \ell \mathrel{▶} D_1 \quad H \vdash \bar\ell \mathrel{▶} \bar\pi \mathrel{▶} D_2}{H \vdash (\ell,\ \bar\ell) \mathrel{▶} (\pi,\ \bar\pi) \mathrel{▶} \pi \cdot^D D_1 +^D D_2}\;(\mathsf{demand}_{\bar\ell}.{,}) \\[1em]
\frac{}{H \vdash \varepsilon \mathrel{▶}_\nu 0^D}\;(\mathsf{demand}_E.\varepsilon) \\[1em]
\frac{H(c) = \mathsf{bind}_\pi(\ell) \quad H \vdash \ell \mathrel{▶} D_1 \quad H \vdash E \mathrel{▶}_\nu D_2}{H \vdash (E,\ x \mapsto c) \mathrel{▶}_{\nu \bullet \pi'} \pi' \cdot^D ([c] +^D D_1) +^D D_2}\;(\mathsf{demand}_E.{,})
\end{gathered}
```

## Properties

The evaluation is deterministic: a term evaluates to one address, in one heap, reading the same cells, whatever the program:

```math
\begin{aligned}
& \text{⟹} &&(\mathsf{det}_\Downarrow) \\
& \quad \text{and} \\
& \qquad \mathcal{P};\ H;\ E \vdash M \Downarrow \ell_1;\ H_1;\ R_1 \\
& \qquad \mathcal{P};\ H;\ E \vdash M \Downarrow \ell_2;\ H_2;\ R_2 \\
& \quad \text{and} \\
& \qquad \ell_1 = \ell_2 \\
& \qquad H_1 = H_2 \\
& \qquad R_1 = R_2
\end{aligned}
```

The extension of the heaps keeps the values, and the evaluation extends the heap:

```math
\begin{aligned}
& \text{⟹} &&(\sqsubseteq_H.\mathsf{get}) \\
& \quad \text{and} \\
& \qquad H \sqsubseteq H' \\
& \qquad H(\ell) = V \\
& \quad H'(\ell) = V \\[1em]
& \text{⟹} &&(\mathsf{ext}_\Downarrow) \\
& \quad \mathcal{P};\ H;\ E \vdash M \Downarrow \ell;\ H';\ R \\
& \quad H \sqsubseteq H'
\end{aligned}
```

The uses of a trace add along its parts, and the uses of one read are its demand:

```math
\begin{aligned}
& \#(R_1 \cdot R_2) = \#R_1 +^D \#R_2 &&(\mathsf{uses}_R.{\cdot}) \\[1em]
& \#(c) = [c] &&(\mathsf{uses}_R.\mathsf{unit})
\end{aligned}
```

The demands hold in each heap that extends their heap:

```math
\begin{aligned}
& \text{⟹} &&(\mathsf{demand}_\ell.{\sqsubseteq}) \\
& \quad \text{and} \\
& \qquad H \sqsubseteq H' \\
& \qquad H \vdash \ell \mathrel{▶} D \\
& \quad H' \vdash \ell \mathrel{▶} D \\[1em]
& \text{⟹} &&(\mathsf{demand}_E.{\sqsubseteq}) \\
& \quad \text{and} \\
& \qquad H \sqsubseteq H' \\
& \qquad H \vdash E \mathrel{▶}_\nu D \\
& \quad H' \vdash E \mathrel{▶}_\nu D
\end{aligned}
```

The demand of an environment follows the operations of the usage on its vector, keeping the demands of the values that it chose: the vector $`0^{\nu}`$ has the demand $`0^D`$, and the demand for a sum, a product or a higher vector splits into, factors through or is below a demand for each part, rather than adding two demands, whose choices of the demands of the values may differ:

```math
\begin{aligned}
& \text{⟹} &&(\mathsf{demand}_E.0) \\
& \quad H \vdash E \mathrel{▶}_\nu D \\
& \quad H \vdash E \mathrel{▶}_{0^{\nu}} 0^D \\[1em]
& \text{⟹} &&(\mathsf{demand}_E.{+}) \\
& \quad H \vdash E \mathrel{▶}_{\nu_1 +^{\nu} \nu_2} D \\
& \quad \exists D_1, D_2. \\
& \qquad \text{and} \\
& \qquad\quad D = D_1 +^D D_2 \\
& \qquad\quad H \vdash E \mathrel{▶}_{\nu_1} D_1 \\
& \qquad\quad H \vdash E \mathrel{▶}_{\nu_2} D_2 \\[1em]
& \text{⟹} &&(\mathsf{demand}_E.{\cdot}) \\
& \quad H \vdash E \mathrel{▶}_{\pi \cdot^{\nu} \nu} D \\
& \quad \exists D'. \\
& \qquad \text{and} \\
& \qquad\quad D = \pi \cdot^D D' \\
& \qquad\quad H \vdash E \mathrel{▶}_\nu D' \\[1em]
& \text{⟹} &&(\mathsf{demand}_E.{\le}) \\
& \quad \text{and} \\
& \qquad H \vdash E \mathrel{▶}_\mu D \\
& \qquad \mu \le^{\nu} \nu \\
& \quad \exists D'. \\
& \qquad \text{and} \\
& \qquad\quad D \le^D D' \\
& \qquad\quad H \vdash E \mathrel{▶}_\nu D'
\end{aligned}
```

The evaluation is big-step: a run of a closed term of the core never diverges, and the guarantees on the uses at run time and on the ownership count the uses of a whole run, which the heap at its end gives, rather than the state of an intermediate step.
The machine of [Eriksson, Abel and Danielsson](https://doi.org/10.1145/3828677) has a heap, an environment and a stack, and runs by the call by name, to prove the resource correctness of their usage; the evaluation here is by value, needs no stack, and records the reads of the cells instead of updating the grades of the heap; their machine likewise eliminates a pair only by a continuation of the same grade, [`prodʷₕ`](https://github.com/graded-type-theory/graded-type-theory/blob/1f720ee636cb16aec130cc1ddc1c32acea8809d0/Graded/Heap/Reduction.agda#L147-L150), as the recursor and the observation check the multiplicities here.
