# Evaluation

This annex defines the evaluation of the target language of the erasure, the calling convention of Sic, the extension of the heaps, and its properties.
It builds on the [syntax](08-syntax.md), the [erasure](16-erasure.md) and the [type of positions](19-prelude.md#positions) of the prelude.

## Definitions

The calling convention is the call by value, everywhere: the fields of a constructor, the arguments of an observation, the entries of the state of a corecursor and the recursive results of a branch of a recursor are evaluated before they are bound, so that a variable is bound to the address of a value, and an access to a variable reads it, without computing anything.
A corecursor computes nothing until it is observed, and each observation runs the branch of its destructor again, without keeping its result: the laziness is explicit, a corecursor that the program builds, and the sharing too, a variable that the program binds.
A constant is unfolded at each of its uses, as the reduction unfolds it, rather than evaluated once, so that a program has no state of its own.

A value is $`\text{↯}`$, the constructor of a case applied to the addresses of its fields, or the closure of a corecursor, which holds the environment of its variables, its branches and the addresses of its state:

```math
\begin{aligned}
& V \mathrel{::=} \text{↯} \mid c_i(\bar\ell) \mid \langle E;\ \bar P;\ \bar\ell \rangle &&(\mathsf{syntax}_V)
\end{aligned}
```

A heap $`H`$ is a sequence of values, the address $`\ell`$ of a value being its position in it, the first one at $`1`$, so that $`H(\ell)`$ is the value at the address $`\ell`$, and $`{(H,\ V)}`$ allocates $`V`$ at the address $`{|H| + 1}`$, where $`|H|`$ is the number of the values of $`H`$.
An environment $`E`$ gives each variable of a scope the address of its value, $`E(x)`$, and $`{E,\ \bar x \mapsto \bar\ell}`$ extends it with the addresses $`\bar\ell`$ of the variables $`\bar x`$, as many; $`\varepsilon`$ is the environment of the empty scope.

A program $`\mathcal{P}`$ gives a constant at the qualities and the grades of an instance, $`{f.\{\bar s;\ \bar p\}}`$, a closed term of the target language, its body.
The program $`\lfloor \Sigma \rfloor_S`$ of a signature $`\Sigma`$, erased by a set of grades $`S`$, gives $`{f.\{\bar s';\ \bar p'\}}`$ the erasure by $`S`$ of the body of $`f`$ at this instance, in the last entry of $`\Sigma`$ that defines $`f`$ with as many sort and grade variables as $`\bar s'`$ and $`\bar p'`$, and nothing when $`\Sigma`$ has no such entry:

```math
\begin{aligned}
& \lfloor \Sigma \rfloor_S(f.\{\bar s';\ \bar p'\}) = \lfloor t[\bar s' / \bar s,\ \bar p' / \bar p] \rfloor_S \text{ if } f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \mathrel{≔} t \text{ is this entry} &&(\mathsf{erase}_\Sigma)
\end{aligned}
```

The judgment $`{\mathcal{P};\ H;\ E \vdash M \Downarrow \ell;\ H'}`$ reads: in the program $`\mathcal{P}`$, the term $`M`$ of the target language, in the environment $`E`$ and the heap $`H`$, evaluates to the address $`\ell`$ of its value in the heap $`H'`$.
The judgment $`{\mathcal{P};\ H;\ E \vdash \bar M \Downarrow \bar\ell;\ H'}`$ reads: the terms $`\bar M`$ evaluate, the first one first, to the addresses $`\bar\ell`$.
A variable is the address that the environment gives it, a constant evaluates its body in the empty environment, $`\text{↯}`$, a constructor and a corecursor evaluate their fields and their state and allocate their value, a recursor evaluates its term and eliminates its value, and an observation evaluates its term and its arguments and observes the value of its term:

```math
\begin{gathered}
\frac{E(x) = \ell}{\mathcal{P};\ H;\ E \vdash x \Downarrow \ell;\ H}\;(\mathsf{eval}_x) \\[1em]
\frac{\begin{gathered}{}\mathcal{P}(f.\{\bar s;\ \bar p\}) = M \\ \mathcal{P};\ H;\ \varepsilon \vdash M \Downarrow \ell;\ H'\end{gathered}}{\mathcal{P};\ H;\ E \vdash f.\{\bar s;\ \bar p\} \Downarrow \ell;\ H'}\;(\mathsf{eval}_f) \\[1em]
\frac{}{\mathcal{P};\ H;\ E \vdash \text{↯} \Downarrow |H| + 1;\ (H,\ \text{↯})}\;(\mathsf{eval}_{\text{↯}}) \\[1em]
\frac{\mathcal{P};\ H;\ E \vdash \bar M \Downarrow \bar\ell;\ H'}{\mathcal{P};\ H;\ E \vdash c_i(\bar M) \Downarrow |H'| + 1;\ (H',\ c_i(\bar\ell))}\;(\mathsf{eval}_c) \\[1em]
\frac{\begin{gathered}{}\mathcal{P};\ H_1;\ E \vdash M \Downarrow \ell;\ H_2 \\ \mathcal{P};\ H_2;\ E \vdash \mathsf{rec}\ \ell\ \mathsf{with}\ \bar N \Downarrow \ell';\ H_3\end{gathered}}{\mathcal{P};\ H_1;\ E \vdash \mathsf{rec}\ M\ \mathsf{with}\ \bar N \Downarrow \ell';\ H_3}\;(\mathsf{eval}_{\mathsf{rec}}) \\[1em]
\frac{\begin{gathered}{}\mathcal{P};\ H_1;\ E \vdash M \Downarrow \ell;\ H_2 \\ \mathcal{P};\ H_2;\ E \vdash \bar M \Downarrow \bar\ell;\ H_3 \\ \mathcal{P};\ H_3 \vdash \ell.d_i(\bar\ell) \Downarrow \ell';\ H_4\end{gathered}}{\mathcal{P};\ H_1;\ E \vdash M.d_i(\bar M) \Downarrow \ell';\ H_4}\;(\mathsf{eval}_d) \\[1em]
\frac{\mathcal{P};\ H;\ E \vdash \bar M \Downarrow \bar\ell;\ H'}{\mathcal{P};\ H;\ E \vdash \mathsf{corec}\ \mathsf{from}\ \bar M\ \mathsf{with}\ \bar P \Downarrow |H'| + 1;\ (H',\ \langle E;\ \bar P;\ \bar\ell \rangle)}\;(\mathsf{eval}_{\mathsf{corec}}) \\[1em]
\frac{}{\mathcal{P};\ H;\ E \vdash () \Downarrow ();\ H}\;(\mathsf{eval}_{\bar M}.\varepsilon) \\[1em]
\frac{\begin{gathered}{}\mathcal{P};\ H_1;\ E \vdash M \Downarrow \ell;\ H_2 \\ \mathcal{P};\ H_2;\ E \vdash \bar M \Downarrow \bar\ell;\ H_3\end{gathered}}{\mathcal{P};\ H_1;\ E \vdash (M,\ \bar M) \Downarrow (\ell,\ \bar\ell);\ H_3}\;(\mathsf{eval}_{\bar M}.{,})
\end{gathered}
```

The judgment $`{\mathcal{P};\ H;\ E \vdash \mathsf{rec}\ \ell\ \mathsf{with}\ \bar N \Downarrow \ell';\ H'}`$ reads: the recursor with the branches $`\bar N`$, in the environment $`E`$, eliminates the value at the address $`\ell`$, a constructor, to the address $`\ell'`$.
The branch of the case of the constructor evaluates, with the addresses of its fields and those of its recursive results, each the recursor on its field, or $`\text{↯}`$ when it is erased, which the judgment $`{\mathcal{P};\ H;\ E \vdash \mathsf{rec}\ \bar\ell\ \mathsf{with}\ \bar N \leftarrow \bar k \Downarrow \bar\ell';\ H'}`$ gives, in order, for the fields at the addresses $`\bar\ell`$:

```math
\begin{gathered}
\frac{\begin{gathered}{}H_1(\ell) = c_i(\bar\ell) \\ \text{the branch } i \text{ of } \bar N \text{ is } (\bar x;\ \bar y \leftarrow \bar k).\, N \\ \bar\ell \text{ and } \bar x \text{ are as many} \\ \mathcal{P};\ H_1;\ E \vdash \mathsf{rec}\ \bar\ell\ \mathsf{with}\ \bar N \leftarrow \bar k \Downarrow \bar\ell';\ H_2 \\ \mathcal{P};\ H_2;\ E,\ \bar x \mapsto \bar\ell,\ \bar y \mapsto \bar\ell' \vdash N \Downarrow \ell';\ H_3\end{gathered}}{\mathcal{P};\ H_1;\ E \vdash \mathsf{rec}\ \ell\ \mathsf{with}\ \bar N \Downarrow \ell';\ H_3}\;(\iota_\Downarrow) \\[1em]
\frac{}{\mathcal{P};\ H;\ E \vdash \mathsf{rec}\ \bar\ell\ \mathsf{with}\ \bar N \leftarrow () \Downarrow ();\ H}\;(\mathsf{results}_\Downarrow.\varepsilon) \\[1em]
\frac{\mathcal{P};\ (H_1,\ \text{↯});\ E \vdash \mathsf{rec}\ \bar\ell\ \mathsf{with}\ \bar N \leftarrow \bar k \Downarrow \bar\ell';\ H_2}{\mathcal{P};\ H_1;\ E \vdash \mathsf{rec}\ \bar\ell\ \mathsf{with}\ \bar N \leftarrow (\bot,\ \bar k) \Downarrow (|H_1| + 1,\ \bar\ell');\ H_2}\;(\mathsf{results}_\Downarrow.\text{↯}) \\[1em]
\frac{\begin{gathered}{}\ell_j \text{ is the address at the position } j \text{ in } \bar\ell \\ \mathcal{P};\ H_1;\ E \vdash \mathsf{rec}\ \ell_j\ \mathsf{with}\ \bar N \Downarrow \ell';\ H_2 \\ \mathcal{P};\ H_2;\ E \vdash \mathsf{rec}\ \bar\ell\ \mathsf{with}\ \bar N \leftarrow \bar k \Downarrow \bar\ell';\ H_3\end{gathered}}{\mathcal{P};\ H_1;\ E \vdash \mathsf{rec}\ \bar\ell\ \mathsf{with}\ \bar N \leftarrow (j,\ \bar k) \Downarrow (\ell',\ \bar\ell');\ H_3}\;(\mathsf{results}_\Downarrow.\mathsf{rec})
\end{gathered}
```

The judgment $`{\mathcal{P};\ H \vdash \ell.d_i(\bar\ell) \Downarrow \ell';\ H'}`$ reads: the observation by the destructor of the case $`i`$, applied to the arguments at the addresses $`\bar\ell`$, of the value at the address $`\ell`$, a closure, evaluates to the address $`\ell'`$.
The branch of the case evaluates in the environment of the closure, with the addresses of its state and of the arguments, and its value is resumed, which the judgment $`{H \vdash \langle E;\ \bar P \rangle \circlearrowleft_k \ell \Downarrow \ell';\ H'}`$ gives: the value at the address $`\ell`$ itself when the branch resumes no state, $`{k = \bot}`$, a new closure of the same environment and branches from the state of $`n`$ entries that $`\mathsf{next}`$ packs, $`{k = n}`$, or from $`n`$ erased entries, $`{k = \text{↯}_n}`$, which stand at the address $`\ell_1`$ of the new state without reading it, $`\ell_1^n`$ being $`n`$ times $`\ell_1`$, or the term already built that $`\mathsf{done}`$ holds, these constructors being the cases $`1`$ and $`2`$ of the type of positions.
The judgment $`{H \vdash \mathsf{unpack}_k(\ell) = \bar\ell}`$ reads: the value at the address $`\ell`$ packs the $`k`$ entries at the addresses $`\bar\ell`$, the first fields of $`k`$ nested pairs, each the case $`1`$ of the pair:

```math
\begin{gathered}
\frac{\begin{gathered}{}H_1(\ell) = \langle E;\ \bar P;\ \bar\ell_1 \rangle \\ \text{the branch } i \text{ of } \bar P \text{ is } (\bar y;\ \bar z \circlearrowleft k).\, P \\ \bar\ell_1 \text{ and } \bar y \text{ are as many} \\ \bar\ell_2 \text{ and } \bar z \text{ are as many} \\ \mathcal{P};\ H_1;\ E,\ \bar y \mapsto \bar\ell_1,\ \bar z \mapsto \bar\ell_2 \vdash P \Downarrow \ell_3;\ H_2 \\ H_2 \vdash \langle E;\ \bar P \rangle \circlearrowleft_k \ell_3 \Downarrow \ell';\ H_3\end{gathered}}{\mathcal{P};\ H_1 \vdash \ell.d_i(\bar\ell_2) \Downarrow \ell';\ H_3}\;(\beta_\Downarrow) \\[1em]
\frac{}{H \vdash \langle E;\ \bar P \rangle \circlearrowleft_\bot \ell \Downarrow \ell;\ H}\;(\mathsf{resume}_\Downarrow.\bot) \\[1em]
\frac{\begin{gathered}{}H(\ell) = c_1(\ell_1) \\ H \vdash \mathsf{unpack}_n(\ell_1) = \bar\ell\end{gathered}}{H \vdash \langle E;\ \bar P \rangle \circlearrowleft_n \ell \Downarrow |H| + 1;\ (H,\ \langle E;\ \bar P;\ \bar\ell \rangle)}\;(\mathsf{resume}_\Downarrow.\mathsf{next}) \\[1em]
\frac{H(\ell) = c_1(\ell_1)}{H \vdash \langle E;\ \bar P \rangle \circlearrowleft_{\text{↯}_n} \ell \Downarrow |H| + 1;\ (H,\ \langle E;\ \bar P;\ \ell_1^n \rangle)}\;(\mathsf{resume}_\Downarrow.\text{↯}) \\[1em]
\frac{\begin{gathered}{}k \ne \bot \\ H(\ell) = c_2(\ell_1)\end{gathered}}{H \vdash \langle E;\ \bar P \rangle \circlearrowleft_k \ell \Downarrow \ell_1;\ H}\;(\mathsf{resume}_\Downarrow.\mathsf{done}) \\[1em]
\frac{}{H \vdash \mathsf{unpack}_0(\ell) = ()}\;(\mathsf{unpack}_\Downarrow.0) \\[1em]
\frac{\begin{gathered}{}H(\ell) = c_1(\ell_1,\ \ell_2) \\ H \vdash \mathsf{unpack}_k(\ell_2) = \bar\ell\end{gathered}}{H \vdash \mathsf{unpack}_{k + 1}(\ell) = (\ell_1,\ \bar\ell)}\;(\mathsf{unpack}_\Downarrow.{,})
\end{gathered}
```

The evaluation only allocates, at the end of the heap, and never changes a value, so that the heap at a later point of a run extends the heap at an earlier point.
A heap $`H'`$ extends a heap $`H`$, written $`{H \sqsubseteq H'}`$, when $`H`$ is a prefix of $`H'`$, which keeps the value at each address of $`H`$:

```math
\begin{aligned}
& H \sqsubseteq H' \iff \exists \bar V.\ H' = (H,\ \bar V) &&(\sqsubseteq_H)
\end{aligned}
```

## Properties

The evaluation is deterministic: a term evaluates to one address, in one heap, whatever the program:

```math
\begin{aligned}
& \text{⟹} &&(\mathsf{det}_\Downarrow) \\
& \quad \text{and} \\
& \qquad \mathcal{P};\ H;\ E \vdash M \Downarrow \ell_1;\ H_1 \\
& \qquad \mathcal{P};\ H;\ E \vdash M \Downarrow \ell_2;\ H_2 \\
& \quad \text{and} \\
& \qquad \ell_1 = \ell_2 \\
& \qquad H_1 = H_2
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
& \quad \mathcal{P};\ H;\ E \vdash M \Downarrow \ell;\ H' \\
& \quad H \sqsubseteq H'
\end{aligned}
```

The evaluation is big-step: a run of a closed term of the core never diverges, and the guarantees on the uses at run time and on the ownership count the uses of a whole run, which the heap at its end gives, rather than the state of an intermediate step.
The machine of [Eriksson, Abel and Danielsson](https://doi.org/10.1145/3828677) has a heap, an environment and a stack, and runs by the call by name, to prove the resource correctness of their usage; the evaluation here is by value, needs no stack, and counts no use yet.
