# Run Time

This annex defines the relation of run time between the closed terms of a closed type and the values that their erasure computes, which states what the erasure of a term computes when it runs, and its properties.
It builds on the [erasure](16-erasure.md), the [evaluation](17-evaluation.md) and the [meaning](18-meaning.md), which gives each closed canonical type its [relation of run time](18-meaning.md#relations-of-run-time).

## Definitions

The relation of run time relates a closed term of a closed type to the address of a value of the target language in a heap, when the value is what the erasure by $`S^{{11}^{\mathsf{m}}}`$ of the term computes.
A closed term is related to an address at a closed type when the type computes to a type or a proposition whose relation relates the term to the address:

```math
\begin{aligned}
& t \circledR_H \ell : A \iff \exists v.\ A \Downarrow v \text{ and } (H,\ t,\ \ell) \in \circledR_\Downarrow(\circledR(v)) &&(\circledR_A)
\end{aligned}
```

## Properties

A term related to an address in a heap stays related to it in each heap that extends it, since the relations of the data types read only values that the heap keeps, and those of the codata types relate the observations in each heap that extends it:

```math
\begin{aligned}
& \text{⟹} &&(\mathsf{ext}_\circledR) \\
& \quad \text{and} \\
& \qquad \text{the names of } \Sigma \text{ are distinct} \\
& \qquad H \sqsubseteq H' \\
& \qquad t \circledR_H \ell : A \\
& \quad t \circledR_{H'} \ell : A
\end{aligned}
```
