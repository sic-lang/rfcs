# Indexed Families

A derived construction of [RFC 0035: Observational Equality](../0035-observational-equality.md), derived from its rules: nothing here is part of the type system, and its formulas are named with the prefix $`\mathsf{ex}`$.
The terms are written in a signature that declares the connectives of the propositions and the data and codata types they use.

An indexed family is a data type whose constructors fix the arguments of the type they build, as the vectors of a given length; the core has no indices, and the surface language elaborates a family into a data type with non-uniform parameters and an equality for each index in each constructor, which is the fording of [McBride](https://era.ed.ac.uk/handle/1842/374), as [Pujet, Leray and Tabareau](https://doi.org/10.1145/3719342) elaborate their indexed inductive types.
A family declared in the surface language with the indices $`\bar \iota : \mathrm{I}`$ and constructors that build the type at the indices $`\bar t_i`$ is elaborated as follows:

```math
\begin{aligned}
& \mathsf{data}\ D\ \Delta : (\bar \iota : \mathrm{I}) \to \kappa\ \mathsf{where}\ c_i : \Theta_i \to D\ \bar \iota'\ \bar t_i \quad \text{elaborates to} &&(\mathsf{ex}_{\mathsf{ford}}) \\
& \mathsf{data}\ (\Delta,\ \bar \iota : \mathrm{I}) : \kappa\ \mathsf{where}\ D \mathrel{≔} c_i : (\Theta_i,\ \bar e :^{\mathbb{0}}_{\mathbb{0}} \bar \iota \sim_{\mathrm{I}} \bar t_i)
\end{aligned}
```

The indices become non-uniform parameters, which the recursive occurrences of $`D`$ in $`\Theta_i`$ instantiate with their own indices, and each constructor gets a telescope of proofs that the parameters are its indices, with the grade $`\mathbb{0}`$, so that the proofs cost nothing and the type is used as the family was.
A recursor on a term of the family at given indices is derived from the recursor of the data type: its branches receive the proofs, and transport their results along them, which computes on open terms by $`(\mathsf{cast}_{\mathsf{refl}})`$; the branch of a constructor whose indices cannot be those of the term receives a proof of $`\bot`$, and is impossible.
A codata type indexed by its observations needs no elaboration: its non-uniform parameters already vary at its positions, as the [data and codata types](https://github.com/sic-lang/rfcs/pull/34) define them.
The [vectors](vectors-by-fording.md) show the elaboration and the derived recursor.
