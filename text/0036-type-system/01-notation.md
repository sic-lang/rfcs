# Notation

This annex fixes the letters that name each kind of object and the conventions that all the rules and formulas of the annexes follow; the symbols of a single construct are introduced with it, in the annex that defines it.
It builds on no other annex.

## Letters

Each letter keeps one kind, in every annex, so that the kind of an object, and whether it is one object or a sequence, is read from its letter:

| Letters | Denote |
| --- | --- |
| $`n, k`$ | Natural numbers, such as numbers of uses and values of levels |
| $`\pi`$ | Multiplicities |
| $`p, q, r`$ | Grades |
| $`m`$ | Modes |
| $`S`$ | Sets of numbers of uses, of pairs of numbers of uses, or of grades |
| $`I`$ | Sets of indices, which index a family of grades |
| $`\gamma, \delta`$ | Vectors of grades, one grade per variable of a context |
| $`l`$ | Levels |
| $`\kappa`$ | Sorts |
| $`s`$ | Qualities of the sorts, $`U`$ and $`\Omega`$, and the sort variables that stand for them |
| $`x, y`$ | Variables |
| $`X`$ | Second-order variables, which bind variables |
| $`t, u, a`$ | Terms, $`u`$ being a term compared to $`t`$, and $`a`$ a term substituted for a variable |
| $`v, w`$ | Canonical terms |
| $`A, B`$ | Types |
| $`\Gamma`$ | Contexts |
| $`\Theta`$ | Telescopes |
| $`\Delta`$ | Parameters of a declaration |
| $`\Sigma`$ | Signatures |
| $`e`$ | Entries of a signature |
| $`\mathcal{D}`$ | Declarations, blocks of types declared together |
| $`D, T`$ | Names of declared types, and their instances |
| $`c`$ | Constants |
| $`\rho, \sigma, \tau`$ | Assignments of the level variables, and substitutions of the first order |
| $`\theta`$ | Substitutions of the second order |

No digit is double-struck: a constant written with digits, such as a grade or a mode, has plain digits and an exponent that names its kind.

## Sequences and Subscripts

A bar marks a sequence, as the arguments $`\bar a`$ of an instance or the variables $`\bar x`$ of a telescope.
A subscript numbers objects of the same kind that come from different premises or from different parts of a context, as $`\gamma_1`$ and $`\gamma_2`$: an object alone of its kind has none, and several are all numbered; a subscript never selects a component.

## Names of Rules and Formulas

- A rule is named after its fraction, in parentheses.
- A rule of usage is named after the rule of typing of the same construct, with the index $`\mathsf{m}`$.
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
