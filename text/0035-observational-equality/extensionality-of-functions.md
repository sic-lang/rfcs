# Extensionality of Functions

An example of [RFC 0035: Observational Equality](../0035-observational-equality.md), derived from its rules: nothing here is part of the type system, and its formulas are named with the prefix $`\mathsf{ex}`$.
The terms are written in a signature that declares the connectives of the propositions and the data and codata types they use.

Two functions are equal when they are equal on every argument, which the bisimilarity of the type of functions states, since the type is not recursive and has one destructor; and a cast between two types of functions casts the argument back, along the first conjunct $`e_1 : A' \sim A`$ of the proof, which $`(\sim_{\mathsf{dtor},})`$ states from the second domain to the first, and the result forward:

```math
\begin{aligned}
f \sim_{\Pi^{q}_{p}\, (x : A).\, B} g &\equiv \Pi^{\sim}\ (A,\ x.\, B,\ f,\ g) \quad \text{whose observation is } \forall (x : A).\, f \circ_{p} x \sim_{B} g \circ_{p} x &&(\mathsf{ex}_{\mathsf{funext}}) \\
\mathsf{cast}(\Pi^{q}_{p}\, (x : A).\, B,\ \Pi^{q}_{p}\, (x : A').\, B',\ e,\ f) &\equiv \lambda_{p}\, (x : A').\, \mathsf{cast}(B[x'/x],\ B',\ e_2[x],\ f \circ_{p} x') \quad \text{where } x' = \mathsf{cast}(A',\ A,\ e_1,\ x) &&(\mathsf{ex}_{\mathsf{cast}\Pi})
\end{aligned}
```

The grades $`p`$ and $`q`$ must be the same on both types: a function of a linear argument is never cast to a function of an unrestricted one, since the two types are unequal by $`(\sim_{D\ne})`$, and the weakening of a function stays explicit, $`\lambda_{\langle \omega, \omega \rangle}\, (x : A).\, f \circ_{\mathbb{1}} x`$.
