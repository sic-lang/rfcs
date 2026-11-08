# Meaning

This annex defines the meaning of the judgments of the typing, with the interpretation of the constant declarations and the equality of the canonical terms of the sorts, and its properties.
It builds on the [levels](05-levels.md), the [sorts](06-sorts.md), the [substitution](08-substitution.md), the [typing](12-typing.md) and the [reduction](13-reduction.md).

The judgments mean what the meaning explanations of Martin-Löf type theory say of them, as [Nordström, Petersson and Smith](https://intuitionistic.wordpress.com/wp-content/uploads/2010/07/nordstrom-et-al-type-theory.pdf) present them: a judgment is true when its terms compute as it says.
The meaning ignores the grades, the modes and the ownerships, as the typing does outside the judgments of usage and of ownership that the rule of the constant definitions reads.
What the usage and the ownership of a term guarantee of its erasure when it runs is not stated here: in the core, every closed term computes to a sort, whose erasure is $`\text{↯}`$, so that these guarantees need the terms that the kinds of type declarations bring, and the evaluation order that the RFC of the calling convention fixes.

## Definitions

This section gives the levels without variables, the interpretation of the constant declarations and the equality of the canonical terms, then the meaning of each judgment of the typing, by the objects it checks, and the interpretations that give each constant declaration a term of its type.
The meaning of a judgment is written with $`\vDash`$ in place of $`\vdash`$.

### Levels Without Variables

A closed term has no level variable, and an assignment $`\rho`$ of natural numbers to the level variables gives a closed instance of an object with level variables.
The level $`\underline{n}`$ is the level without variables whose value is the natural number $`n`$, and the instantiation $`[\rho]`$ of a term, of arguments, of a telescope, of a context or of a sort [instantiates](08-substitution.md) each of its level variables $`l`$ by the level whose value is $`\rho(l)`$:

```math
\begin{aligned}
& \underline{0} = 0 &&(\mathsf{numeral}_l) \\
& \underline{n + 1} = \underline{n} + 1 \\[1em]
& [\rho] = [\underline{\rho(\bar l)} / \bar l] \text{ where } \bar l \text{ are the level variables} &&(\mathsf{inst}_\rho)
\end{aligned}
```

### Interpretation of the Constants

A constant declaration has no body to compute: the meaning takes an interpretation $`\iota`$, which gives each constant declaration $`f`$, at each instance $`\bar s',\ \bar p'`$ of its sort and grade variables, a term $`\iota(f.\{\bar s';\ \bar p'\})`$ without variables, in which its level variables may occur.
The signature $`\iota(\Sigma)`$ is $`\Sigma`$ in which each constant declaration becomes the constant definition whose body is its interpretation, $`\iota(f)`$ being the body whose instance at $`\bar s',\ \bar p'`$ is $`\iota(f.\{\bar s';\ \bar p'\})`$:

```math
\begin{aligned}
& \iota(\varnothing) = \varnothing &&(\mathsf{interpret}_\Sigma) \\
& \iota(\Sigma,\ f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p) = \iota(\Sigma),\ f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \mathrel{≔} \iota(f) \\
& \iota(\Sigma,\ e) = \iota(\Sigma),\ e \text{ otherwise}
\end{aligned}
```

In the meaning, a closed term $`t`$ computes to $`v`$, written $`t \Downarrow v`$, when $`\iota(\Sigma) \vdash t \Downarrow v`$, as the formula $`(\Downarrow)`$ of the [reduction](13-reduction.md) defines it, so that the meaning has the single reduction of the typing.
The computation, the equality $`\mathsf{eq}`$ and the meaning of the judgments all depend on the signature $`\Sigma`$ and on the interpretation $`\iota`$, which their notation omits.

### Equality of the Canonical Terms

A closed canonical type $`v`$ is known by its canonical terms and by their equality $`\mathsf{eq}(v)`$, a relation between closed terms, which the sorts and the kinds of type declarations give.
The value $`[\![l]\!]`$ of a level $`l`$ without variables is its [value](05-levels.md) under any assignment.

The universe of propositions $`\Omega_n`$ relates propositions, each with its truth $`b`$, written $`(A,\ B) \in \mathsf{eq}(\Omega_n) \text{ with } b`$, and $`\mathsf{eq}(\Omega_n)`$ is the least relation with the clauses that the kinds of type declarations add for their instances in $`\Omega_n`$, which relate two propositions when they have the same truth; the core gives it no clause.

The universe $`U_n`$ relates canonical types, each with the equality $`R`$ of its terms, written $`(v,\ w) \in \mathsf{eq}(U_n) \text{ with } R`$, and $`\mathsf{eq}(U_n)`$ is the least relation with the following clauses, and with those that the kinds of type declarations add for their instances in $`U_n`$; a universe is a type of the universe above its level, whose terms are equal when the universe below relates them:

```math
\begin{aligned}
& (U_{l_1},\ U_{l_2}) \in \mathsf{eq}(U_n) \text{ with } \{(A,\ B) \mid \exists R.\ (A,\ B) \in \mathsf{eq}(U_{n - 1}) \text{ with } R\} \text{ if} &&(\mathsf{eq}_U) \\
& \quad \text{and} \\
& \qquad [\![l_1]\!] + 1 = n \\
& \qquad [\![l_2]\!] + 1 = n \\[1em]
& (\Omega_{l_1},\ \Omega_{l_2}) \in \mathsf{eq}(U_n) \text{ with } \{(A,\ B) \mid \exists b.\ (A,\ B) \in \mathsf{eq}(\Omega_{n - 1}) \text{ with } b\} \text{ if} &&(\mathsf{eq}_\Omega) \\
& \quad \text{and} \\
& \qquad [\![l_1]\!] + 1 = n \\
& \qquad [\![l_2]\!] + 1 = n
\end{aligned}
```

The universes are defined one level after the other, since the clauses of $`U_n`$ need only the level below it, and at each level by a least relation, which defines the equality of the terms of each type it relates together with the types themselves.

A closed canonical type has the equality that a universe gives it, and a proposition the equality of its proofs: all the closed terms when it is true, and none when it is false; a closed canonical type is a proposition when a universe of propositions relates it, and a closed type computes to a proposition when its canonical form is one:

```math
\begin{aligned}
& \mathsf{eq}(v) = R \text{ if } (v,\ v) \in \mathsf{eq}(U_n) \text{ with } R &&(\mathsf{eq}_{\mathsf{type}}) \\[1em]
& \mathsf{eq}(v) = \{(t,\ u) \mid t \text{ and } u \text{ are closed terms}\} \text{ if } (v,\ v) \in \mathsf{eq}(\Omega_n) \text{ with a true } b &&(\mathsf{eq}_{\mathsf{true}}) \\[1em]
& \mathsf{eq}(v) = \varnothing \text{ if } (v,\ v) \in \mathsf{eq}(\Omega_n) \text{ with a false } b &&(\mathsf{eq}_{\mathsf{false}}) \\[1em]
& v \text{ is a proposition} \iff \exists n,\ b.\ (v,\ v) \in \mathsf{eq}(\Omega_n) \text{ with } b &&(\mathsf{prop}_v) \\[1em]
& A \text{ computes to a proposition} \iff \exists v.\ A \Downarrow v \text{ and } v \text{ is a proposition} &&(\mathsf{prop}_\Downarrow)
\end{aligned}
```

The relation $`\mathsf{eq}(v)`$ is defined only for the closed canonical types that these clauses give, and is then unique, by $`(\mathsf{unique}_{\mathsf{eq}})`$.

### Closed Judgments

A closed judgment requires its signature to be meaningful, as every judgment of the typing implies that its signature is well formed.
Two closed types are equal when they compute to canonical types with the same equality of terms, and two closed terms are equal terms of a type that does not compute to a proposition when they compute to canonical terms that its equality relates; the terms of a proposition need not compute, since its equality relates the terms themselves:

```math
\begin{aligned}
& \text{⟺} &&(\vDash_{\mathsf{type}\equiv}) \\
& \quad \Sigma \vDash A \equiv B \\
& \quad \text{and} \\
& \qquad \vDash \Sigma \\
& \qquad \exists v_1,\ v_2,\ R.\ A \Downarrow v_1,\ B \Downarrow v_2,\ \mathsf{eq}(v_1) = R \text{ and } \mathsf{eq}(v_2) = R \\[1em]
& \Sigma \vDash A \iff \Sigma \vDash A \equiv A &&(\vDash_{\mathsf{type}}) \\[1em]
& \text{⟺ if } A \text{ does not compute to a proposition} &&(\vDash_\equiv) \\
& \quad \Sigma \vDash t \equiv u : A \\
& \quad \text{and} \\
& \qquad \Sigma \vDash A \\
& \qquad \exists v,\ w_1,\ w_2.\ A \Downarrow v,\ t \Downarrow w_1,\ u \Downarrow w_2 \text{ and } (w_1,\ w_2) \in \mathsf{eq}(v) \\[1em]
& \text{⟺ if } A \text{ computes to a proposition} &&(\vDash_{\equiv\Omega}) \\
& \quad \Sigma \vDash t \equiv u : A \\
& \quad \text{and} \\
& \qquad \Sigma \vDash A \\
& \qquad \exists v.\ A \Downarrow v \text{ and } (t,\ u) \in \mathsf{eq}(v) \\[1em]
& \Sigma \vDash t : A \iff \Sigma \vDash t \equiv t : A &&(\vDash)
\end{aligned}
```

### Signatures and Entries

A signature is meaningful when each of its entries is meaningful in the signature before it, and introduces a name that no entry before it introduces, as the rules of the [signatures](12-typing.md) require:

```math
\begin{aligned}
& \vDash \varnothing &&({\vDash}\mathsf{sig}_\varnothing) \\[1em]
& \text{⟺} &&({\vDash}\mathsf{sig}_{\mathsf{def}}) \\
& \quad \vDash \Sigma,\ f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \mathrel{≔} t \\
& \quad \text{and} \\
& \qquad \Sigma \vDash f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \mathrel{≔} t \\
& \qquad \text{no entry of } \Sigma \text{ introduces } f \\[1em]
& \text{⟺} &&({\vDash}\mathsf{sig}_{\mathsf{decl}}) \\
& \quad \vDash \Sigma,\ f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \\
& \quad \text{and} \\
& \qquad \Sigma \vDash f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \\
& \qquad \text{no entry of } \Sigma \text{ introduces } f
\end{aligned}
```

The type declarations are meaningful by the formulas of their kinds, in their annexes, so that a signature with a type declaration has no meaning in the core.

A constant definition is meaningful when its body is a term of its type, and a constant declaration when its interpretation is, at each instance of their sort and grade variables and each assignment of their level variables:

```math
\begin{aligned}
& \text{⟺} &&({\vDash}\mathsf{def}) \\
& \quad \Sigma \vDash f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \mathrel{≔} t \\
& \quad \forall \bar s',\ \bar p' \text{ as many as } \bar s,\ \bar p.\ \forall \rho. \\
& \qquad \Sigma \vDash t[\bar s' / \bar s,\ \bar p' / \bar p][\rho] : A[\bar s' / \bar s,\ \bar p' / \bar p][\rho] \\[1em]
& \text{⟺} &&({\vDash}\mathsf{decl}) \\
& \quad \Sigma \vDash f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \\
& \quad \forall \bar s',\ \bar p' \text{ as many as } \bar s,\ \bar p.\ \forall \rho. \\
& \qquad \Sigma \vDash \iota(f.\{\bar s';\ \bar p'\})[\rho] : A[\bar s' / \bar s,\ \bar p' / \bar p][\rho]
\end{aligned}
```

The meaning of a signature with constant declarations is thus relative to an interpretation: an axiom is meaningful only if its proposition is true, and a foreign constant only if some term of the core has its type.

### Contexts and Hypothetical Judgments

A judgment in a context $`\Gamma`$ holds under every pair of equal closed substitutions of $`\Gamma`$, of the second order, which give each variable equal closed terms of its type, and each second-order variable abstractions whose instances by equal arguments are equal terms of its type; a telescope $`\Theta`$ and the parameters $`\Delta`$ of a type declaration have the equal substitutions of the contexts they form, and their arguments are the substitutions $`[\bar t / \Theta]`$ and $`[\bar a / \Delta]`$:

```math
\begin{aligned}
& \mathsf{eq}(\varepsilon) = \{((),\ ())\} &&(\mathsf{eq}_\varepsilon) \\[1em]
& = &&(\mathsf{eq}_x) \\
& \quad \mathsf{eq}(\Gamma,\ x : A) \\
& \quad \{((\theta_1,\ a_1),\ (\theta_2,\ a_2)) \mid (\theta_1,\ \theta_2) \in \mathsf{eq}(\Gamma) \text{ and } \Sigma \vDash a_1 \equiv a_2 : A[\theta_1]\} \\[1em]
& = &&(\mathsf{eq}_X) \\
& \quad \mathsf{eq}(\Gamma,\ X : (\Theta \vdash A \mathrel{◀} \psi)) \\
& \quad \{((\theta_1,\ \bar x.\, B_1),\ (\theta_2,\ \bar x.\, B_2)) \mid \\
& \qquad (\theta_1,\ \theta_2) \in \mathsf{eq}(\Gamma) \text{ and} \\
& \qquad \forall (\sigma_1,\ \sigma_2) \in \mathsf{eq}(\Theta[\theta_1]).\ \Sigma \vDash B_1[\sigma_1] \equiv B_2[\sigma_2] : A[\theta_1,\ \sigma_1]\}
\end{aligned}
```

A context is meaningful when its last type is a type in the context before it, which makes this context meaningful too:

```math
\begin{aligned}
& \Sigma \vDash \varepsilon \iff \vDash \Sigma &&({\vDash}\mathsf{ctx}_\varepsilon) \\[1em]
& \Sigma \vDash \Gamma,\ x : A \iff \Sigma;\ \Gamma \vDash A &&({\vDash}\mathsf{ctx}_x) \\[1em]
& \Sigma \vDash \Gamma,\ X : (\Theta \vdash A \mathrel{◀} \psi) \iff \Sigma;\ \Gamma,\ \Theta \vDash A &&({\vDash}\mathsf{ctx}_X)
\end{aligned}
```

A judgment in a context requires the context to be meaningful, and holds under every pair of its equal closed substitutions:

```math
\begin{aligned}
& \text{⟺} &&({\vDash}\Gamma_{\mathsf{type}\equiv}) \\
& \quad \Sigma;\ \Gamma \vDash A \equiv B \\
& \quad \text{and} \\
& \qquad \Sigma \vDash \Gamma \\
& \qquad \forall (\theta_1,\ \theta_2) \in \mathsf{eq}(\Gamma).\ \Sigma \vDash A[\theta_1] \equiv B[\theta_2] \\[1em]
& \Sigma;\ \Gamma \vDash A \iff \Sigma;\ \Gamma \vDash A \equiv A &&({\vDash}\Gamma_{\mathsf{type}}) \\[1em]
& \text{⟺} &&({\vDash}\Gamma_\equiv) \\
& \quad \Sigma;\ \Gamma \vDash t \equiv u : A \\
& \quad \text{and} \\
& \qquad \Sigma;\ \Gamma \vDash A \\
& \qquad \forall (\theta_1,\ \theta_2) \in \mathsf{eq}(\Gamma).\ \Sigma \vDash t[\theta_1] \equiv u[\theta_2] : A[\theta_1] \\[1em]
& \Sigma;\ \Gamma \vDash t : A \iff \Sigma;\ \Gamma \vDash t \equiv t : A &&({\vDash}\Gamma) \\[1em]
& \text{⟺} &&({\vDash}\Gamma_{\mathsf{tel}\equiv}) \\
& \quad \Sigma;\ \Gamma \vDash \bar t \equiv \bar u : \Theta \\
& \quad \text{and} \\
& \qquad \Sigma \vDash \Gamma \\
& \qquad \forall (\theta_1,\ \theta_2) \in \mathsf{eq}(\Gamma).\ ([\bar t[\theta_1] / \Theta[\theta_1]],\ [\bar u[\theta_2] / \Theta[\theta_1]]) \in \mathsf{eq}(\Theta[\theta_1]) \\[1em]
& \Sigma;\ \Gamma \vDash \bar t : \Theta \iff \Sigma;\ \Gamma \vDash \bar t \equiv \bar t : \Theta &&({\vDash}\Gamma_{\mathsf{tel}}) \\[1em]
& \text{⟺} &&({\vDash}\Gamma_{\mathsf{arg}\equiv}) \\
& \quad \Sigma;\ \Gamma \vDash \bar a_1 \equiv \bar a_2 : \Delta \\
& \quad \text{and} \\
& \qquad \Sigma \vDash \Gamma \\
& \qquad \forall (\theta_1,\ \theta_2) \in \mathsf{eq}(\Gamma).\ ([\bar a_1[\theta_1] / \Delta],\ [\bar a_2[\theta_2] / \Delta]) \in \mathsf{eq}(\Delta) \\[1em]
& \Sigma;\ \Gamma \vDash \bar a : \Delta \iff \Sigma;\ \Gamma \vDash \bar a \equiv \bar a : \Delta &&({\vDash}\Gamma_{\mathsf{arg}})
\end{aligned}
```

### Telescopes in a Sort

Two closed telescopes are equal in a sort $`\kappa`$ when their first types are equal types of a sort that $`\kappa`$ bounds, and the rest of them equal for every pair of equal terms of these types, whatever their grades, as the rule $`(\mathsf{tel}_{\kappa,})`$ checks; a telescope lives in a sort in a context when its instances by equal closed substitutions of the context are equal in it:

```math
\begin{aligned}
& \Sigma \vDash \varepsilon \equiv \varepsilon : \kappa \iff \vDash \Sigma &&({\vDash}\mathsf{tel}_{\kappa\varepsilon}) \\[1em]
& \text{⟺} &&({\vDash}\mathsf{tel}_{\kappa,}) \\
& \quad \Sigma \vDash (x : A_1 \mathrel{▶} p_1;\ q_1 \mathrel{◀} r_1,\ \Theta_1) \equiv (x : A_2 \mathrel{▶} p_2;\ q_2 \mathrel{◀} r_2,\ \Theta_2) : \kappa \\
& \quad \text{and} \\
& \qquad \exists \kappa_1 \preceq \kappa.\ \Sigma \vDash A_1 \equiv A_2 : \kappa_1 \\
& \qquad \forall a_1,\ a_2.\ \Sigma \vDash a_1 \equiv a_2 : A_1 \implies \Sigma \vDash \Theta_1[a_1 / x] \equiv \Theta_2[a_2 / x] : \kappa \\[1em]
& \text{⟺} &&({\vDash}\Gamma_{\mathsf{tel}\kappa}) \\
& \quad \Sigma;\ \Gamma \vDash \Theta : \kappa \\
& \quad \text{and} \\
& \qquad \Sigma \vDash \Gamma \\
& \qquad \forall (\theta_1,\ \theta_2) \in \mathsf{eq}(\Gamma).\ \Sigma \vDash \Theta[\theta_1] \equiv \Theta[\theta_2] : \kappa
\end{aligned}
```

### Level Variables

A judgment $`\mathcal{J}`$ in a context $`\Gamma`$ whose objects have level variables is true when it is true at every assignment of its level variables, as an entry checked once with its level variables is used at any levels:

```math
\begin{aligned}
& \Sigma;\ \Gamma \vDash \mathcal{J} \iff \forall \rho.\ \Sigma;\ \Gamma[\rho] \vDash \mathcal{J}[\rho] &&(\vDash_\rho)
\end{aligned}
```

### Interpretations of a Signature

An interpretation $`\iota`$ interprets a signature when it gives each constant declaration of the signature a term of its type, whenever the signature before the declaration is meaningful, so that it is asked nothing in a signature without meaning:

```math
\begin{aligned}
& \iota \text{ interprets } \varnothing &&(\mathsf{hyp}_\iota) \\[1em]
& \text{⟺} \\
& \quad \iota \text{ interprets } \Sigma,\ f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \\
& \quad \text{and} \\
& \qquad \iota \text{ interprets } \Sigma \\
& \qquad \vDash \Sigma \implies \Sigma \vDash f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \\[1em]
& \iota \text{ interprets } \Sigma,\ e \iff \iota \text{ interprets } \Sigma \text{ otherwise}
\end{aligned}
```

## Properties

The equality of the terms of a closed canonical type is a partial equivalence relation, symmetric and transitive, and is unique, so that the notation $`\mathsf{eq}(v)`$ names one relation:

```math
\begin{aligned}
& \mathsf{eq}(v) = R \text{ and } (t_1,\ t_2) \in R \implies (t_2,\ t_1) \in R &&(\mathsf{per}_{\mathsf{eq}}.\mathsf{symm}) \\[1em]
& \mathsf{eq}(v) = R,\ (t_1,\ t_2) \in R \text{ and } (t_2,\ t_3) \in R \implies (t_1,\ t_3) \in R &&(\mathsf{per}_{\mathsf{eq}}.\mathsf{trans}) \\[1em]
& \mathsf{eq}(v) = R_1 \text{ and } \mathsf{eq}(v) = R_2 \implies R_1 = R_2 &&(\mathsf{unique}_{\mathsf{eq}})
\end{aligned}
```

A meaningful signature has [distinct](07-syntax.md) names, as a well-formed one does, so that the computation is deterministic, by $`(\mathsf{det}_{\Downarrow})`$; and the meaning is exact for the proofs: two closed terms are equal proofs of a proposition exactly when each of them is a proof of it, as the rule $`(\mathsf{irr})`$ says:

```math
\begin{aligned}
& \vDash \Sigma \implies \text{the names of } \Sigma \text{ are distinct} &&(\mathsf{distinct}_{\vDash\Sigma}) \\[1em]
& \text{⟹} &&(\mathsf{exact}_\Omega) \\
& \quad \Sigma \vDash A : \Omega_l \\
& \quad \Sigma \vDash t \equiv u : A \iff \Sigma \vDash t : A \text{ and } \Sigma \vDash u : A
\end{aligned}
```

Every judgment of the typing is meaningful under an interpretation that interprets its signature, which is the soundness of the typing; a judgment whose objects have level variables is then meaningful at every assignment of them, by $`(\vDash_\rho)`$:

```math
\begin{aligned}
& \iota \text{ interprets } \Sigma \text{ and } \vdash \Sigma \implies \vDash \Sigma &&(\mathsf{sound}.\Sigma) \\[1em]
& \text{⟹} &&(\mathsf{sound}.\mathsf{def}) \\
& \quad \text{and} \\
& \qquad \iota \text{ interprets } \Sigma \\
& \qquad \Sigma \vdash f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \mathrel{≔} t \\
& \quad \Sigma \vDash f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \mathrel{≔} t \\[1em]
& \text{⟹} &&(\mathsf{sound}.\mathsf{decl}) \\
& \quad \text{and} \\
& \qquad \iota \text{ interprets } \Sigma,\ f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \\
& \qquad \Sigma \vdash f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \\
& \quad \Sigma \vDash f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} m \mathrel{◀} p \\[1em]
& \iota \text{ interprets } \Sigma \text{ and } \Sigma \vdash \Gamma \implies \Sigma \vDash \Gamma &&(\mathsf{sound}.\Gamma) \\[1em]
& \iota \text{ interprets } \Sigma \text{ and } \Sigma;\ \Gamma \vdash A \implies \Sigma;\ \Gamma \vDash A &&(\mathsf{sound}.A) \\[1em]
& \iota \text{ interprets } \Sigma \text{ and } \Sigma;\ \Gamma \vdash A \equiv B \implies \Sigma;\ \Gamma \vDash A \equiv B &&(\mathsf{sound}.A_\equiv) \\[1em]
& \iota \text{ interprets } \Sigma \text{ and } \Sigma;\ \Gamma \vdash t : A \implies \Sigma;\ \Gamma \vDash t : A &&(\mathsf{sound}.t) \\[1em]
& \iota \text{ interprets } \Sigma \text{ and } \Sigma;\ \Gamma \vdash t \equiv u : A \implies \Sigma;\ \Gamma \vDash t \equiv u : A &&(\mathsf{sound}.t_\equiv) \\[1em]
& \iota \text{ interprets } \Sigma \text{ and } \Sigma;\ \Gamma \vdash \bar t : \Theta \implies \Sigma;\ \Gamma \vDash \bar t : \Theta &&(\mathsf{sound}.\bar t) \\[1em]
& \iota \text{ interprets } \Sigma \text{ and } \Sigma;\ \Gamma \vdash \bar t \equiv \bar u : \Theta \implies \Sigma;\ \Gamma \vDash \bar t \equiv \bar u : \Theta &&(\mathsf{sound}.\bar t_\equiv) \\[1em]
& \iota \text{ interprets } \Sigma \text{ and } \Sigma;\ \Gamma \vdash \bar a : \Delta \implies \Sigma;\ \Gamma \vDash \bar a : \Delta &&(\mathsf{sound}.\bar a) \\[1em]
& \iota \text{ interprets } \Sigma \text{ and } \Sigma;\ \Gamma \vdash \bar a_1 \equiv \bar a_2 : \Delta \implies \Sigma;\ \Gamma \vDash \bar a_1 \equiv \bar a_2 : \Delta &&(\mathsf{sound}.\bar a_\equiv) \\[1em]
& \iota \text{ interprets } \Sigma \text{ and } \Sigma;\ \Gamma \vdash \Theta : \kappa \implies \Sigma;\ \Gamma \vDash \Theta : \kappa &&(\mathsf{sound}.\Theta)
\end{aligned}
```

The soundness of a constant declaration rests on the interpretation alone: its typing checks its type but gives it no term, so that a well-formed constant declaration is meaningful only by an interpretation, as $`f : \Omega_0`$ shows, which is well formed while the core gives $`\Omega_0`$ no proposition, hence no term.
