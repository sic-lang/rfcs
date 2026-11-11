# Notation

This annex fixes the letters that name each kind of object and the conventions that all the rules and formulas of the annexes follow; the symbols of a single construct are introduced with it, in the annex that defines it.
It builds on no other annex.

## Letters

Each letter keeps one kind, in every annex, so that the kind of an object, and whether it is one object or a sequence, is read from its letter.
The letters follow the order of the annexes that define their objects, and, within an annex, the order of its definitions; the letters of the objects of later annexes come last, in the order of these annexes:

| Letters | Denote |
| --- | --- |
| $`{n, k}`$ | Natural numbers, such as numbers of uses and values of levels |
| $`\mathcal{M}`$ | Modalities |
| $`\xi`$ | Elements of a modality |
| $`\pi`$ | Multiplicities |
| $`S`$ | Sets of numbers of uses, of pairs of numbers of uses, or of grades |
| $`{p, q, r}`$ | Grades |
| $`I`$ | Sets of indices, which index a family of grades or the elements of a vector |
| $`m`$ | Modes |
| $`l`$ | Levels |
| $`\rho`$ | Assignments of the level variables |
| $`s`$ | Qualities of the sorts, $`U`$ and $`\Omega`$, and the sort variables that stand for them |
| $`\kappa`$ | Sorts |
| $`{x, y, z}`$ | Variables |
| $`X`$ | Second-order variables, which bind variables |
| $`{t, u, a, g}`$ | Terms, $`u`$ being a term compared to $`t`$ or a branch of a recursor, $`a`$ a term substituted for a variable, and $`g`$ a branch of a corecursor |
| $`{A, B}`$ | Types |
| $`\Theta`$ | Telescopes |
| $`\Gamma`$ | Contexts |
| $`\psi`$ | Ownerships of the results of the second-order variables |
| $`\chi`$ | Coefficients of the variables in these ownerships, and their constants $`\chi_0`$ |
| $`e`$ | Entries of a signature |
| $`\Delta`$ | Parameters of a type declaration |
| $`\mathcal{D}`$ | Type declarations, blocks of types declared together |
| $`{D, T}`$ | Names of declared types, and their instances |
| $`c`$ | Constructors of the data types |
| $`d`$ | Destructors of the codata types |
| $`C`$ | Motives of the recursors |
| $`f`$ | Constants, defined or declared |
| $`\Sigma`$ | Signatures |
| $`\iota`$ | Interpretations of the constant declarations |
| $`{\sigma, \tau}`$ | Substitutions of the first order |
| $`\theta`$ | Substitutions of the second order |
| $`\alpha`$ | Renamings, which give variables to variables |
| $`{\mu, \nu}`$ | Vectors of elements of a modality, one element per index |
| $`{\gamma, \delta, \zeta}`$ | Vectors of grades, one grade per variable of a scope, $`\zeta`$ being the grades with which a declared type uses its parameters |
| $`\varphi`$ | Ownerships of the variables of a scope, one grade per variable whose telescope is empty |
| $`o`$ | Ownerships of the arguments of a second-order variable |
| $`{M, N, P}`$ | Terms of the target language of the erasure, $`N`$ being a branch of a recursor and $`P`$ a branch of a corecursor |
| $`V`$ | Values of the evaluation |
| $`H`$ | Heaps |
| $`\ell`$ | Addresses in a heap |
| $`E`$ | Environments, the address of each variable of a scope |
| $`\mathcal{P}`$ | Programs of the target language |
| $`{v, w}`$ | Canonical terms |
| $`R`$ | Relations between closed terms, the equalities of the terms of the closed canonical types |
| $`b`$ | Truth values of the propositions |

No digit is double-struck: the zero and the unit of a modality, a grade, a mode or a vector of grades written with digits has plain digits and, as an exponent, the letter of its kind: $`\xi`$ for a modality, $`\mathsf{p}`$ for a grade and $`\mathsf{m}`$ for a mode, upright, $`\mu`$ for a vector and $`\gamma`$ for a vector of grades.
An operation on the modes, on the vectors or on the vectors of grades carries the same exponent, as $`{\cdot^{\mathsf{m}}}`$, $`{+^{\mu}}`$ and $`{+^{\gamma}}`$, so that it is told apart from the operation of the grades.

## Types, Usage and Ownership

A judgment holds when its rules derive it: $`{\vdash}`$ separates what it assumes, the signature and the context, the grades or the ownerships of the variables, from what it states, and $`\nvdash`$ in its place states that the rules do not derive it.
After a term or a variable, the colon gives its type, $`{\mathrel{▶}}`$ its usage and $`{\mathrel{◀}}`$ its ownership, in this order, each followed by what it states, and the mode in which it is checked comes last, after a semicolon, as $`{x : A \mathrel{▶} p;\ q \mathrel{◀} r}`$ for an entry of a telescope and $`{\Sigma;\ \gamma \vdash \bar t \mathrel{▶} \bar p;\ m}`$ for the usage of arguments.
The three symbols carry no index nor exponent, so that what each states is read in the same place in the entries and in the judgments.

## Sequences and Subscripts

A bar marks a sequence, as the arguments $`\bar a`$ of an instance or the variables $`\bar x`$ of a telescope, and a double bar a sequence of sequences.
A subscript numbers objects of the same kind that come from different premises or from different parts of a context, as $`\gamma_1`$ and $`\gamma_2`$: an object alone of its kind has none, and several are all numbered; a subscript never selects a component.

## Names of Rules and Formulas

Rules and formulas are named as follows:

- A rule is named after its fraction, in parentheses.
- A rule of usage or of ownership is named after the rule of typing of the same construct, with the symbol of its judgment as index, $`▶`$ or $`◀`$, as $`(\mathsf{var}_{X▶})`$ and $`(\mathsf{var}_{X◀})`$.
- A rule of equality that goes with a rule of typing of the same construct is named after it, with the index $`\equiv`$ last.
- A rule that extends a context, a telescope or a signature by one kind of entry is indexed by a comma.
- A rule with one case per kind of entry is indexed by the letter of the entry: $`x`$ for a variable, $`X`$ for a second-order variable.
- A formula is named in its last column.
- The laws of a group, such as the laws of a semiring or the presuppositions of the judgments, and the parts of a definition made of several, such as the operations of the multiplicities or the substitution in each kind of object, are formulas or rules of their own, each named after the group or the definition, then after the law or the part, separated by a dot, as $`{(\mathsf{semiring}_\xi.\mathsf{assoc}_{+})}`$ and $`{(\mathsf{op}_\pi.{+})}`$.
- A formula that defines an object is named after what it defines: $`\mathsf{syntax}`$ for the objects themselves, given by a grammar or by a condition, $`\mathsf{op}`$ for its operations and $`\mathsf{order}`$ for its order.
- The name of a formula is indexed by the letter of the kind of objects it is about: $`\xi`$ for the elements of a modality, $`\pi`$ for the multiplicities, $`p`$ for the grades, $`m`$ for the modes, $`l`$ for the levels, $`s`$ for the qualities, $`\kappa`$ for the sorts, $`t`$ for the terms, $`\bar t`$ and $`\bar a`$ for the arguments of the telescopes and of the instances, $`\bar C`$ and $`\bar u`$ for the motives and the branches of the recursors, $`\bar\Theta`$ and $`\bar g`$ for the states and the branches of the corecursors, $`\Theta`$ for the telescopes, $`\Gamma`$ for the contexts, $`\psi`$ for the ownerships of the results of the second-order variables, $`e`$ for the entries of the signatures, $`\mathcal{D}`$ for the type declarations, $`f`$ for the constants, $`c`$ and $`d`$ for the constructors and the destructors, $`D`$ for the declared types, $`\Sigma`$ for the signatures, $`\sigma`$ and $`\theta`$ for the substitutions of the first and of the second order, $`\mu`$ for the vectors, $`\gamma`$ for the vectors of grades, $`S`$ for the sets of grades, $`M`$ for the terms of the target language of the erasure, and $`\bar M`$, $`\bar N`$ and $`\bar P`$ for its arguments and the branches of its recursors and of its corecursors.
- The name of a formula of a meaning has a prefix that says what it states: $`\vDash`$ for the meaning of a judgment, named after the rule it interprets, and $`\mathsf{eq}`$ for a clause of the equality of a canonical type.
- Every name designates one rule or one formula in all the annexes.

## Variables of Rules and Formulas

A rule holds for every instance of the variables of its fraction, and a variable left free in a formula is universally quantified, over the kind that its letter names.
In a rule, the premises are written one per line, and a premise that holds only under a condition, written $`\dots \text{ if } \dots`$, comes after the others.
A formula too long for one line is written in prefix form: its operator alone on a line, then each of its operands on the lines below, indented, and written the same way when it is itself too long for one line; the argument of an application too long for one line goes on the lines below its opening parenthesis, indented, broken after a comma; a formula made of several statements is their conjunction, written in prefix form under $`\text{and}`$; a formula on one line keeps its operators between their operands.
Two formulas that follow each other are separated by an empty line.
A grammar is written in the [Backus–Naur form](https://doi.org/10.1145/366193.366201) of the report on ALGOL 60: $`{\pi \mathrel{::=} 0 \mid 1 \mid \omega}`$ reads: a multiplicity is $`0`$, $`1`$ or $`\omega`$, and each alternative, separated by $`\mid`$, is a case of the definition.
An operation or a relation defined by cases writes its cases one per line, named on the first line, without a conjunction: the first case that matches the arguments applies, the last one may be written $`\dots \text{ otherwise}`$, for the arguments that no case before it matches, and a case that applies only under a condition is written $`\dots \text{ if } \dots`$.
A relation defined by the ways of deriving it is written as rules, one per way, as the judgments are.
A rule or a formula that the system does not define, but which is derived from its rules, is said so where it appears.
