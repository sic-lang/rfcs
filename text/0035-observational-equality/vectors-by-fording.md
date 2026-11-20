# Vectors by Fording

An example of [RFC 0035: Observational Equality](../0035-observational-equality.md), derived from its rules: nothing here is part of the type system, and its formulas are named with the prefix $`\mathsf{ex}`$.
The terms are written in a signature that declares the connectives of the propositions and the data and codata types they use.

The vectors, indexed by their length, elaborate by [fording](indexed-families.md) to a data type whose length is a non-uniform parameter, with an equality in each constructor:

```math
\begin{aligned}
& \mathsf{data}\ \mathsf{Vec}\ (A : U_0) : (n : \mathbb{N}) \to U_0\ \mathsf{where}\ \mathsf{nil} : () \to \mathsf{Vec}\ A\ \mathsf{zero} \mid \mathsf{cons} : (k : \mathbb{N},\ x : A,\ v : \mathsf{Vec}\ A\ k) \to \mathsf{Vec}\ A\ (\mathsf{succ}\ k) &&(\mathsf{ex}_{\mathsf{Vec}}) \\
& \text{elaborates to } \mathsf{data}.\{\}\ (A : U_0,\ n : \mathbb{N}) : U_0\ \mathsf{where}\ \mathsf{Vec} \mathrel{≔} \mathsf{nil} : (e :^{\mathbb{0}}_{\mathbb{0}} n \sim_{\mathbb{N}} \mathsf{zero}) \\
& \quad \mid \mathsf{cons} : (k :^{\mathbb{0}}_{\mathbb{0}} \mathbb{N},\ x :^{\mathbb{0}}_{\mathbb{1}} A,\ v :^{\mathbb{0}}_{\mathbb{1}} \mathsf{Vec}\ A\ k,\ e :^{\mathbb{0}}_{\mathbb{0}} n \sim_{\mathbb{N}} \mathsf{succ}\ k)
\end{aligned}
```

The head of a vector of length $`\mathsf{succ}\ m`$ is taken by the recursor, whose branch for $`\mathsf{nil}`$ is impossible, since its proof $`e : \mathsf{succ}\ m \sim \mathsf{zero}`$ reduces to $`\bot`$ by $`(\sim^{+}_{\ne})`$, and whose branch for $`\mathsf{cons}`$ returns $`x`$; the equalities cost nothing at run time, where a vector is a list.
