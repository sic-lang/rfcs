# Constants and a Definition

An example of [RFC 0024: Graded Dependent Core](../0024-graded-dependent-core.md), derived from its rules: nothing here is part of the type system, and its formulas are named with the prefix $`\mathsf{ex}`$.
The constants and the definition are those a program would assume of the machine and of its library.

The rules of the core name no type, so a signature of the core alone declares types and values as constants: a foreign type and its values, a ghost value, an axiom and a definition.

```math
\begin{aligned}
\Sigma_{\mathsf{ex}} = {}& \mathsf{Int}.\{\} :_{\mathbb{1}\mathbb{1}^{\mathsf{m}}} U_0, &&(\mathsf{ex}_{\mathsf{sig}}) \\
& \mathsf{zero}.\{\} :_{\mathbb{1}\mathbb{1}^{\mathsf{m}}} \mathsf{Int}.\{\}, \\
& \mathsf{bound}.\{\} :_{\mathbb{0}\mathbb{1}^{\mathsf{m}}} \mathsf{Int}.\{\}, \\
& \mathsf{Sorted}.\{\} :_{\mathbb{1}\mathbb{1}^{\mathsf{m}}} \Omega_0, \\
& \mathsf{sorted}.\{\} :_{\mathbb{0}\mathbb{1}^{\mathsf{m}}} \mathsf{Sorted}.\{\}, \\
& \mathsf{origin}.\{\} :_{\mathbb{1}\mathbb{1}^{\mathsf{m}}} \mathsf{Int}.\{\} \mathrel{≔} \mathsf{zero}.\{\}
\end{aligned}
```

The type $`\mathsf{Int}`$ and its value $`\mathsf{zero}`$ are foreign: the program that runs gets them from the machine, and uses them in any mode.
The value $`\mathsf{bound}`$ is a ghost: a specification or a proof may use it, as many times as it likes, but a program that runs cannot, since $`\mathbb{1}\mathbb{1}^{\mathsf{m}} \cdot^{\mathsf{m}} \mathbb{0}\mathbb{1}^{\mathsf{m}} \ne \mathbb{1}\mathbb{1}^{\mathsf{m}}`$.
The proposition $`\mathsf{Sorted}`$ is foreign too, as a type, and $`\mathsf{sorted}`$ is an axiom, a proof of it that is never built; the definition $`\mathsf{origin}`$ unfolds to $`\mathsf{zero}`$:

```math
\begin{aligned}
& \Sigma_{\mathsf{ex}};\ \varepsilon \vdash \mathsf{origin}.\{\} \equiv \mathsf{zero}.\{\} : \mathsf{Int}.\{\} \qquad \Sigma_{\mathsf{ex}};\ \mathbb{0}^{\mathsf{c}} \mathrel{▶_{\mathbb{0}\mathbb{1}^{\mathsf{m}}}} \mathsf{bound}.\{\} &&(\mathsf{ex}_{\mathsf{use}}) \\
& \Sigma_{\mathsf{ex}};\ \mathbb{0}^{\mathsf{c}} \mathrel{▶_{\mathbb{1}\mathbb{1}^{\mathsf{m}}}} \mathsf{bound}.\{\} \text{ is not derivable}
\end{aligned}
```

The extraction of the program $`\mathsf{origin}.\{\}`$ is $`\mathsf{origin}`$, which stands for $`\mathsf{zero}`$, the value that the machine provides; $`\mathsf{bound}`$ and $`\mathsf{sorted}`$ never reach the extraction of a program.
