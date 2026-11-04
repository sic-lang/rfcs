# Streams

An example of [RFC 0034: Data and Codata Types](../0034-data-and-codata-types.md), derived from its rules: nothing here is part of the type system, and its formulas are named with the prefix $`\mathsf{ex}`$.
The declarations are written in a signature that holds them in order, each after those it uses, without the empty lists of variables of the declarations that have none; the grades written on an instance instantiate its grade variables.

A stream is a recursive codata type, whose corecursor builds it from a state; the stream of the numbers from $`t`$ uses its state once in each branch, which the condition of $`(D^{-}_{\mathsf{i}\mathsf{m}})`$ on the state allows, $`\mathbb{1} \le \mathbb{1} \cdot \mathbb{1}`$, and the tail of a stream built by $`\mathsf{cons}`$ is the stream that was put there:

```math
\begin{aligned}
& \mathsf{codata}.\{\}\ (A : U_0) : U_0\ \mathsf{where}\ \mathsf{Stream} \mathrel{≔} \mathsf{head} :^{\mathbb{0}}_{\mathbb{1}} () \to A \mid \mathsf{tail} :^{\mathbb{0}}_{\mathbb{1}} () \to \mathsf{Stream}\ A &&(\mathsf{ex}_{\mathsf{Stream}}) \\
& \mathsf{from}(t) \;=\; \mathsf{corec}_{\mathbb{1}}\ t\ \mathsf{return}\ (n :_{\mathbb{1}} \mathbb{N})\ \mathsf{as}\ n\ \mathsf{with}\ .\mathsf{head} \Rightarrow n \mid .\mathsf{tail} \Rightarrow \mathsf{next}\ (\mathbb{N}.\mathsf{succ}(n)) &&(\mathsf{ex}_{\mathsf{from}}) \\
& \mathsf{cons}(x,\ s) \;=\; \mathsf{corec}_{\mathbb{1}}\ (x,\ s)\ \mathsf{return}\ (x :_{\mathbb{1}} A,\ s :_{\mathbb{1}} \mathsf{Stream}\ A)\ \mathsf{as}\ (x,\ s)\ \mathsf{with}\ .\mathsf{head} \Rightarrow x \mid .\mathsf{tail} \Rightarrow \mathsf{done}\ s &&(\mathsf{ex}_{\mathsf{cons}}) \\
& \mathsf{cons}(x,\ s).\mathsf{tail} \equiv s : \mathsf{Stream}\ A
\end{aligned}
```

The state of $`\mathsf{cons}`$ holds a stream already built, which the tail gives back by $`\mathsf{done}`$, and its two entries are used once by each new state; a corecursor that only ever unfolds, as $`\mathsf{from}`$, is a coiteration.
