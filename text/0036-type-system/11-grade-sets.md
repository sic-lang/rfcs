# Grade Sets

This annex defines the sets of grades that a mode does not count, which the erasure replaces, and the condition on a set of grades to erase only what a mode does not count, then states the greatest lower bounds of the sets of grades and the values of the sets that the modes do not count.
It builds on the [grades](04-grades.md) and the [modes](05-modes.md).

## Definitions

A term checked in the mode $`m`$ checks a position of grade $`p`$ in the mode $`{m \odot p}`$, and does not count the uses of the positions that it checks in a more erased mode, whose grades form the set $`S^m`$:

```math
\begin{aligned}
& S^m = \{p \mid m \odot p \ne m\} &&(\mathsf{uncounted}_m)
\end{aligned}
```

A set $`S`$ of grades erases only what the mode $`m`$ does not count when it erases neither the grade $`\ulcorner m \urcorner`$, with which a variable checked in the mode $`m`$ uses itself, nor a grade above one that it keeps, nor a part of a sum that it erases, when it erases the second factor of a product that it erases whose first factor it keeps, and every product of which it erases a factor, and when a grade that it keeps keeps the mode, in which the term of a field of this grade is checked:

```math
\begin{aligned}
& \ulcorner m \urcorner \notin S &&(\mathsf{uncounted}_S.\mathsf{grade}) \\[1em]
& p \le q \text{ and } p \in S \implies q \in S &&(\mathsf{uncounted}_S.{\le}) \\[1em]
& p + q \in S \implies p \in S &&(\mathsf{uncounted}_S.{+}) \\[1em]
& p \notin S \text{ and } p \cdot q \in S \implies q \in S &&(\mathsf{uncounted}_S.{\cdot}) \\[1em]
& p \in S \text{ or } q \in S \implies p \cdot q \in S &&(\mathsf{uncounted}_S.\mathsf{factor}) \\[1em]
& p \notin S \implies m \odot p = m &&(\mathsf{uncounted}_S.{\odot})
\end{aligned}
```

## Properties

Every non-empty decidable set $`S`$ of grades has a greatest lower bound $`\bigwedge S`$, which covers the sets of grades that a rule computes:

```math
\begin{aligned}
& \text{and} &&(\textstyle\bigwedge_p) \\
& \quad \forall p \in S.\ \textstyle\bigwedge S \le p \\
& \quad (\forall p \in S.\ r \le p) \implies r \le \textstyle\bigwedge S
\end{aligned}
```

For all families $`{(p_i)_{i \in I}}`$ and $`{(q_i)_{i \in I}}`$ of grades indexed by a non-empty set $`I`$ whose greatest lower bounds exist, as they do when their sets of values are decidable, the greatest lower bound is superadditive, and the multiplication by a grade commutes with it, as [Eriksson, Abel and Danielsson](https://doi.org/10.1145/3828677) require of well-behaved greatest lower bounds:

```math
\begin{aligned}
& \textstyle\bigwedge_{i \in I} p_i + \bigwedge_{i \in I} q_i \le \bigwedge_{i \in I} (p_i + q_i) &&(\textstyle\bigwedge{+}_p) \\[1em]
& r \cdot \textstyle\bigwedge_{i \in I} p_i = \bigwedge_{i \in I} (r \cdot p_i) &&(\textstyle\bigwedge{\cdot}_p)
\end{aligned}
```

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
