# Notation

This annex fixes the letters that name each kind of object and the conventions that all the rules and formulas of the annexes follow; the symbols of a single construct are introduced with it, in the annex that defines it.
It builds on no other annex.

## Letters

Each letter keeps one kind, in every annex, so that the kind of an object, and whether it is one object or a sequence, is read from its letter.
The letters follow the order of the annexes that define their objects, and, within an annex, the order of its definitions; the letters of the objects of later annexes come last, in the order of these annexes:

| Letters | Denote |
| --- | --- |
| $`n, k`$ | Natural numbers, such as numbers of uses and values of levels |
| $`\pi`$ | Multiplicities |
| $`S`$ | Sets of numbers of uses, of pairs of numbers of uses, or of grades |
| $`p, q, r`$ | Grades |
| $`I`$ | Sets of indices, which index a family of grades |
| $`m`$ | Modes |
| $`l`$ | Levels |
| $`\rho`$ | Assignments of the level variables |
| $`s`$ | Qualities of the sorts, $`U`$ and $`\Omega`$, and the sort variables that stand for them |
| $`\kappa`$ | Sorts |
| $`x, y`$ | Variables |
| $`X`$ | Second-order variables, which bind variables |
| $`t, u, a`$ | Terms, $`u`$ being a term compared to $`t`$, and $`a`$ a term substituted for a variable |
| $`A, B`$ | Types |
| $`\Theta`$ | Telescopes |
| $`\Gamma`$ | Contexts |
| $`e`$ | Entries of a signature |
| $`\Delta`$ | Parameters of a type declaration |
| $`\mathcal{D}`$ | Type declarations, blocks of types declared together |
| $`\mathcal{K}`$ | Kinds of type declarations |
| $`D, T`$ | Names of declared types, and their instances |
| $`f`$ | Constants, defined or declared |
| $`\Sigma`$ | Signatures |
| $`\sigma, \tau`$ | Substitutions of the first order |
| $`\theta`$ | Substitutions of the second order |
| $`\gamma, \delta`$ | Vectors of grades, one grade per variable of a scope |
| $`v, w`$ | Canonical terms |

No digit is double-struck: a grade, a mode or a vector of grades written with digits has plain digits and, as an exponent, the letter of its kind: $`\mathsf{p}`$ for a grade and $`\mathsf{m}`$ for a mode, upright, and $`\gamma`$ for a vector of grades.
An operation on the modes or on the vectors of grades carries the same exponent, as $`\cdot^{\mathsf{m}}`$ and $`+^{\gamma}`$, so that it is told apart from the operation of the grades.

## Sequences and Subscripts

A bar marks a sequence, as the arguments $`\bar a`$ of an instance or the variables $`\bar x`$ of a telescope.
A subscript numbers objects of the same kind that come from different premises or from different parts of a context, as $`\gamma_1`$ and $`\gamma_2`$: an object alone of its kind has none, and several are all numbered; a subscript never selects a component.

## Names of Rules and Formulas

- A rule is named after its fraction, in parentheses.
- A rule of usage is named after the rule of typing of the same construct, with the index $`\mathsf{m}`$.
- A rule of equality that goes with a rule of typing of the same construct is named after it, with the index $`\equiv`$ last.
- A rule that extends a context, a telescope or a signature by one kind of entry is indexed by a comma.
- A rule with one case per kind of entry is indexed by the letter of the entry: $`x`$ for a variable, $`X`$ for a second-order variable.
- A formula is named in its last column.
- The name of a formula is indexed by the letter of the kind of objects it is about: $`\pi`$ for the multiplicities, $`p`$ for the grades, $`m`$ for the modes, $`l`$ for the levels, $`s`$ for the qualities, $`\kappa`$ for the sorts, $`\Theta`$ for the telescopes, $`\Gamma`$ for the contexts, $`\Sigma`$ for the signatures, and $`\sigma`$ and $`\theta`$ for the substitutions of the first and of the second order.
- The name of a formula of a meaning has a prefix that says what it states: $`\vDash`$ for the meaning of a judgment, named after the rule it interprets, and $`\mathsf{eq}`$ for a clause of the equality of a canonical type.
- Every name designates one rule or one formula in all the annexes.

## Variables of Rules and Formulas

A rule holds for every instance of the variables of its fraction, and a variable left free in a formula is universally quantified, over the kind that its letter names.
In a rule, the premises are written one per line, and a premise that holds only under a condition, written $`\dots \text{ if } \dots`$, comes after the others.
A formula too long for one line is written in prefix form: its operator alone on a line, then each of its operands on the lines below, indented, and written the same way when it is itself too long for one line; the argument of an application too long for one line goes on the lines below its opening parenthesis, indented, broken after a comma; a formula made of several statements is their conjunction, written in prefix form under $`\text{and}`$; a formula on one line keeps its operators between their operands.
Two formulas that follow each other are separated by an empty line.
A rule or a formula that the system does not define, but which is derived from its rules, is said so where it appears.
