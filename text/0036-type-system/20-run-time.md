# Run Time

This annex defines the relation of run time between the closed terms of a closed type and the values that their erasure computes, which states what the erasure of a term computes when it runs, the validity at run time of a term in a context, which extends it to open terms, the programs that realize a signature, and their properties, among them the fundamental lemma of the run time, by which a term typed and used in the mode $`{11}^{\mathsf{m}}`$ is valid at run time, and the soundness of the extraction, by which the erasure of a closed term computes what the term computes.
It builds on the [usage](12-usage.md), the [typing](14-typing.md), the [erasure](16-erasure.md), the [evaluation](17-evaluation.md) and the [meaning](18-meaning.md), which gives each closed canonical type its [relation of run time](18-meaning.md#relations-of-run-time).

## Definitions

The relation of run time relates a closed term of a closed type to the address of a value of the target language in a heap, when the value is what the erasure by $`S^{{11}^{\mathsf{m}}}`$ of the term computes.
A closed term is related to an address at a closed type when the type computes to a proposition, whose proofs are related to every address without computing, as $`(\mathsf{rt}_\Downarrow)`$ relates the terms of a field, or to a type whose relation relates what the term computes to the address:

```math
\begin{aligned}
& \text{⟺} &&(\circledR_A) \\
& \quad t \circledR_H \ell : A \\
& \quad \exists v. \\
& \qquad \text{and} \\
& \qquad\quad A \Downarrow v \\
& \qquad\quad \text{or} \\
& \qquad\qquad v \text{ is a proposition} \\
& \qquad\qquad (H,\ t,\ \ell) \in \circledR_\Downarrow(\circledR(v))
\end{aligned}
```

A closed substitution $`\theta`$ of a context whose variables are all of the first order is related, with the grades $`\gamma`$, to the addresses $`V`$ of the values of its variables in a heap $`H`$, the last one first, when each variable whose grade is not in $`S^{{11}^{\mathsf{m}}}`$, so that the erasure keeps its uses, is related to its address at its type; the erasure keeps no abstraction, so that a second-order variable has no address:

```math
\begin{aligned}
& (\varepsilon,\ \varepsilon) \in \circledR_H(\varepsilon;\ \varepsilon) &&(\circledR_\varepsilon) \\[1em]
& \text{⟺} &&(\circledR_x) \\
& \quad ((\theta,\ t),\ (V,\ \ell)) \in \circledR_H(\Gamma,\ x : A;\ \gamma \bullet p) \\
& \quad \text{and} \\
& \qquad (\theta,\ V) \in \circledR_H(\Gamma;\ \gamma) \\
& \qquad p \notin S^{{11}^{\mathsf{m}}} \implies t \circledR_H \ell : A[\theta]
\end{aligned}
```

A term is valid at run time with the grades $`\gamma`$ in a context whose variables are all of the first order when, for each closed substitution $`\theta`$ that the meaning relates to itself and each environment whose [cells](17-evaluation.md#definitions) bind, in a heap, addresses related to it, its erasure by $`S^{{11}^{\mathsf{m}}}`$ evaluates, reading some cells, to an address in a heap that extends this heap, to which the substituted term is related at the substituted type:

```math
\begin{aligned}
& \text{⟺} &&({\vDash}^{\circledR}) \\
& \quad \Sigma;\ \gamma;\ \Gamma \vDash^{\circledR} t : A \\
& \quad \forall \theta, H, E, V. \\
& \qquad \text{⟹} \\
& \qquad\quad \text{and} \\
& \qquad\qquad (\theta,\ \theta) \in \mathsf{eq}(\Gamma) \\
& \qquad\qquad H \vdash E \mapsto V \\
& \qquad\qquad (\theta,\ V) \in \circledR_H(\Gamma;\ \gamma) \\
& \qquad\quad \exists \ell, H', R. \\
& \qquad\qquad \text{and} \\
& \qquad\qquad\quad \mathcal{P};\ H;\ E \vdash \lfloor t \rfloor_{S^{{11}^{\mathsf{m}}}} \Downarrow \ell;\ H';\ R \\
& \qquad\qquad\quad H \sqsubseteq H' \\
& \qquad\qquad\quad t[\theta] \circledR_{H'} \ell : A[\theta]
\end{aligned}
```

Closed arguments $`\bar t`$ of a closed telescope are related to addresses $`\bar\ell`$ in a heap at grades $`\bar p`$, one for each argument, when each argument whose grade is not in $`S^{{11}^{\mathsf{m}}}`$, so that the erasure keeps it, is related to its address at the type of its entry, in which the arguments before it are substituted:

```math
\begin{aligned}
& () \circledR_H^{()} () : \varepsilon &&(\circledR_{\bar t\varepsilon}) \\[1em]
& \text{⟺} &&(\circledR_{\bar t,}) \\
& \quad (t,\ \bar t) \circledR_H^{(p,\ \bar p)} (\ell,\ \bar\ell) : (x : A \mathrel{▶} p';\ q \mathrel{◀} r,\ \Theta) \\
& \quad \text{and} \\
& \qquad p \notin S^{{11}^{\mathsf{m}}} \implies t \circledR_H \ell : A \\
& \qquad \bar t \circledR_H^{\bar p} \bar\ell : \Theta[t / x]
\end{aligned}
```

Arguments of a telescope $`\Theta`$, whose entries have the grades $`\bar p`$, are valid at run time with the grades $`\gamma`$ in a context whose variables are all of the first order when, for each closed substitution that the meaning relates to itself and each environment whose cells bind, in a heap, addresses related to it, their erasure at the grades $`\bar p`$ evaluates, the first one first, to addresses in a heap that extends this heap, to which the substituted arguments are related at the substituted telescope:

```math
\begin{aligned}
& \text{⟺} &&({\vDash}^{\circledR}_{\bar t}) \\
& \quad \Sigma;\ \gamma;\ \Gamma \vDash^{\circledR} \bar t : \Theta \\
& \quad \forall \theta, H, E, V. \\
& \qquad \text{⟹} \\
& \qquad\quad \text{and} \\
& \qquad\qquad (\theta,\ \theta) \in \mathsf{eq}(\Gamma) \\
& \qquad\qquad H \vdash E \mapsto V \\
& \qquad\qquad (\theta,\ V) \in \circledR_H(\Gamma;\ \gamma) \\
& \qquad\quad \exists \bar\ell, H', R. \\
& \qquad\qquad \text{and} \\
& \qquad\qquad\quad \mathcal{P};\ H;\ E \vdash \lfloor \bar t \rfloor_{S^{{11}^{\mathsf{m}}}, \bar p} \Downarrow \bar\ell;\ H';\ R \\
& \qquad\qquad\quad H \sqsubseteq H' \\
& \qquad\qquad\quad \bar t[\theta] \circledR_{H'}^{\bar p} \bar\ell : \Theta[\theta]
\end{aligned}
```

A program realizes a signature when it gives each constant that the [program of the signature](17-evaluation.md) erased by $`S^{{11}^{\mathsf{m}}}`$ gives a body the same body, and when each constant declaration of the mode $`{11}^{\mathsf{m}}`$, which has no body, is valid at run time in the empty context at each instance of its variables whose levels have no variables, as an [interpretation interprets a signature](18-meaning.md#interpretations-of-a-signature) in the meaning:

```math
\begin{aligned}
& \text{⟺} &&(\mathsf{hyp}_{\mathcal{P}}) \\
& \quad \mathcal{P} \text{ realizes } \Sigma \\
& \quad \text{and} \\
& \qquad \forall f.\{\bar s';\ \bar p'\}.\ \lfloor \Sigma \rfloor_{S^{{11}^{\mathsf{m}}}}(f.\{\bar s';\ \bar p'\}) = M \implies \mathcal{P}(f.\{\bar s';\ \bar p'\}) = M \\
& \qquad \forall (f.\{\bar s;\ \bar l;\ \bar p\} : A \mathrel{▶} {11}^{\mathsf{m}} \mathrel{◀} p) \in \Sigma.\ \forall \bar s', \bar l', \bar p'. \\
& \qquad\quad \Sigma;\ {00}^{\gamma};\ \varepsilon \vDash^{\circledR} f.\{\bar s';\ \bar l';\ \bar p'\} : A[\bar s' / \bar s,\ \bar l' / \bar l,\ \bar p' / \bar p]
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

A term valid at run time with some grades is valid with lower grades, as the rule $`(\mathsf{sub}_{▶})`$ of the usage gives a term grades lower than its uses, since $`S^{{11}^{\mathsf{m}}}`$ holds each grade above one of its grades:

```math
\begin{aligned}
& \text{⟹} &&(\mathsf{sub}^{\circledR}) \\
& \quad \text{and} \\
& \qquad \delta \le^{\gamma} \gamma \\
& \qquad \Sigma;\ \gamma;\ \Gamma \vDash^{\circledR} t : A \\
& \quad \Sigma;\ \delta;\ \Gamma \vDash^{\circledR} t : A
\end{aligned}
```

A term typed and used in the mode $`{11}^{\mathsf{m}}`$, in a context whose variables are all of the first order, is valid at run time with the grades of its usage, at every assignment of its level variables, when an interpretation interprets its signature, whose entries use their variables as their grades allow, and a program realizes it; so are the arguments of a telescope, at the grades of its entries.
This is the fundamental lemma of the run time: what the erasure of the term computes when it runs is what the term computes, as the relation of run time of its type relates them:

```math
\begin{aligned}
& \text{⟹} &&(\mathsf{fund}_t) \\
& \quad \text{and} \\
& \qquad \iota \text{ interprets } \Sigma \\
& \qquad \mathcal{P} \text{ realizes } \Sigma \\
& \qquad \vdash \Sigma \mathrel{▶} \\
& \qquad \text{the variables of } \Gamma \text{ are all of the first order} \\
& \qquad \Sigma;\ \Gamma \vdash t : A \\
& \qquad \Sigma;\ \gamma \vdash t \mathrel{▶} {11}^{\mathsf{m}} \\
& \quad \forall \rho.\ \Sigma;\ \gamma;\ \Gamma[\rho] \vDash^{\circledR} t[\rho] : A[\rho] \\[1em]
& \text{⟹} &&(\mathsf{fund}_{\bar t}) \\
& \quad \text{and} \\
& \qquad \iota \text{ interprets } \Sigma \\
& \qquad \mathcal{P} \text{ realizes } \Sigma \\
& \qquad \vdash \Sigma \mathrel{▶} \\
& \qquad \text{the variables of } \Gamma \text{ are all of the first order} \\
& \qquad \Sigma;\ \Gamma \vdash \bar t : \Theta \\
& \qquad \Sigma;\ \gamma \vdash \bar t \mathrel{▶} \bar p;\ {11}^{\mathsf{m}} \text{ where } \bar p \text{ are the grades of the entries of } \Theta \\
& \quad \forall \rho.\ \Sigma;\ \gamma;\ \Gamma[\rho] \vDash^{\circledR} \bar t[\rho] : \Theta[\rho]
\end{aligned}
```

The soundness of the extraction is the fundamental lemma for a closed term, run in the empty heap and the empty environment: its erasure by $`S^{{11}^{\mathsf{m}}}`$ evaluates to an address in a heap, to which the term is related at its type; when its type computes to an instance of a data type that is not a proposition, the value at this address is the constructor of the target language of the case of the constructor that the term computes, by $`(\circledR_c)`$, as the relation $`(\circledR_\mu)`$ is the least one closed under it:

```math
\begin{aligned}
& \text{⟹} &&(\mathsf{sound}_{\lfloor\rfloor}) \\
& \quad \text{and} \\
& \qquad \iota \text{ interprets } \Sigma \\
& \qquad \mathcal{P} \text{ realizes } \Sigma \\
& \qquad \vdash \Sigma \mathrel{▶} \\
& \qquad \Sigma;\ \varepsilon \vdash t : A \\
& \qquad \Sigma;\ \varepsilon \vdash t \mathrel{▶} {11}^{\mathsf{m}} \\
& \quad \forall \rho.\ \exists \ell, H, R. \\
& \qquad \text{and} \\
& \qquad\quad \mathcal{P};\ \varepsilon;\ \varepsilon \vdash \lfloor t[\rho] \rfloor_{S^{{11}^{\mathsf{m}}}} \Downarrow \ell;\ H;\ R \\
& \qquad\quad t[\rho] \circledR_H \ell : A[\rho] \\[1em]
& \text{⟹} &&(\mathsf{sound}_c) \\
& \quad \text{and} \\
& \qquad \iota \text{ interprets } \Sigma \\
& \qquad \mathcal{P} \text{ realizes } \Sigma \\
& \qquad \vdash \Sigma \mathrel{▶} \\
& \qquad \Sigma;\ \varepsilon \vdash t : A \\
& \qquad \Sigma;\ \varepsilon \vdash t \mathrel{▶} {11}^{\mathsf{m}} \\
& \qquad D \text{ is a data type of } \Sigma \\
& \qquad A[\rho] \Downarrow D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a \\
& \qquad D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a \text{ is not a proposition} \\
& \quad \exists \ell, H, R, T, c, \bar t, \bar\ell. \\
& \qquad \text{and} \\
& \qquad\quad \mathcal{P};\ \varepsilon;\ \varepsilon \vdash \lfloor t[\rho] \rfloor_{S^{{11}^{\mathsf{m}}}} \Downarrow \ell;\ H;\ R \\
& \qquad\quad T \text{ is an instance of } D \\
& \qquad\quad t[\rho] \Downarrow T.c(\bar t) \\
& \qquad\quad H(\ell) = c_i(\bar\ell) \text{ with } i = \mathsf{case}_\Sigma(D.c)
\end{aligned}
```
