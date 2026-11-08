# Substitution

This annex defines the substitutions of the first order, which give terms to variables, the substitutions of the second order, which give abstractions to variables, the closed substitutions, the instantiation of the level variables, and their properties.
It builds on the [syntax](07-syntax.md).

## Definitions

This section defines the substitutions of the first order, then those of the second order, which apply them to the abstractions they give, the closed substitutions, and the instantiation of the level variables.
A substitution of the first order and one of the second order are defined apart, as the substitution of the variables and the substitution of the metavariables of [Nanevski, Pfenning and Pientka](https://doi.org/10.1145/1352582.1352591), since the second one substitutes the arguments of each application in the abstraction it gives, which is not a part of the term.
Under the variables that an abstraction or a telescope binds, a substitution gives each of them itself, and they take names that the terms it gives do not use.

### Substitutions of the First Order

A substitution $`\sigma`$ of the first order gives a term $`\sigma(x)`$ to each variable $`x`$ of a scope whose telescope is empty, and leaves the other variables, only substituting their arguments:

```math
\begin{aligned}
& x[\sigma] = \sigma(x) \text{ if the telescope of } x \text{ is empty} &&(\mathsf{subst}_\sigma.t) \\
& x[\bar t][\sigma] = x[\bar t[\sigma]] \text{ if the telescope of } x \text{ is not empty} \\
& \kappa[\sigma] = \kappa \\
& f.\{\bar s;\ \bar l;\ \bar p\}[\sigma] = f.\{\bar s;\ \bar l;\ \bar p\} \\
& (D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a)[\sigma] = D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a[\sigma] \\[1em]
& ()[\sigma] = () &&(\mathsf{subst}_\sigma.\bar t) \\
& (t,\ \bar t)[\sigma] = (t[\sigma],\ \bar t[\sigma]) \\[1em]
& ()[\sigma] = () &&(\mathsf{subst}_\sigma.\bar a) \\
& (\bar a,\ \bar x.\, B)[\sigma] = (\bar a[\sigma],\ \bar x.\, B[\sigma]) \\[1em]
& \varepsilon[\sigma] = \varepsilon &&(\mathsf{subst}_\sigma.\Theta) \\
& (x :^{q}_{p} A,\ \Theta)[\sigma] = (x :^{q}_{p} A[\sigma],\ \Theta[\sigma])
\end{aligned}
```

The identity gives each variable with an empty telescope itself, and the substitution $`[t / x]`$ gives the term $`t`$ to the variable $`x`$ and each other variable itself:

```math
\begin{aligned}
& \mathsf{id}(x) = x &&(\mathsf{identity}_\sigma) \\[1em]
& [t / x](x) = t &&(\mathsf{single}_\sigma) \\
& [t / x](y) = y \text{ if } y \ne x
\end{aligned}
```

The substitution $`B[\bar t / \bar x]`$ of arguments $`\bar t`$ for variables $`\bar x`$ with empty telescopes substitutes the first argument for the first variable, then the others, and is written $`B[\bar t / \Theta]`$ when $`\bar x`$ are the variables of the telescope $`\Theta`$:

```math
\begin{aligned}
& B[() / ()] = B &&(\mathsf{subst}_\Theta) \\
& B[(t,\ \bar t) / (x,\ \bar x)] = B[t / x][\bar t / \bar x]
\end{aligned}
```

### Substitutions of the Second Order

A substitution $`\theta`$ of the second order gives each variable $`x`$ of a scope an abstraction $`\theta(x)`$, over a variable for each entry of the telescope of $`x`$, which is a term when the telescope is empty, and replaces each application of a variable by its abstraction, in which it substitutes the arguments:

```math
\begin{aligned}
& x[\bar t][\theta] = B[\bar t[\theta] / \bar x] \text{ if } \theta(x) = \bar x.\, B &&(\mathsf{subst}_\theta.t) \\
& \kappa[\theta] = \kappa \\
& f.\{\bar s;\ \bar l;\ \bar p\}[\theta] = f.\{\bar s;\ \bar l;\ \bar p\} \\
& (D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a)[\theta] = D.\{\bar s;\ \bar l;\ \bar p\}\ \bar a[\theta] \\[1em]
& ()[\theta] = () &&(\mathsf{subst}_\theta.\bar t) \\
& (t,\ \bar t)[\theta] = (t[\theta],\ \bar t[\theta]) \\[1em]
& ()[\theta] = () &&(\mathsf{subst}_\theta.\bar a) \\
& (\bar a,\ \bar x.\, B)[\theta] = (\bar a[\theta],\ \bar x.\, B[\theta]) \\[1em]
& \varepsilon[\theta] = \varepsilon &&(\mathsf{subst}_\theta.\Theta) \\
& (x :^{q}_{p} A,\ \Theta)[\theta] = (x :^{q}_{p} A[\theta],\ \Theta[\theta])
\end{aligned}
```

Under the variables $`\bar x`$ that it binds, $`\theta`$ gives each of them itself, as a term, since their telescopes are empty.
The identity gives each variable $`x`$ the abstraction $`\bar x.\, x[\bar x]`$:

```math
\begin{aligned}
& \mathsf{id}(x) = \bar x.\, x[\bar x] &&(\mathsf{identity}_\theta)
\end{aligned}
```

The substitution $`[\bar a / \Delta]`$ of the arguments of an instance for the parameters $`\Delta`$ of its type declaration is of the second order: $`[(\bar a,\ \bar x.\, B) / (\Delta,\ X : (\Theta \vdash A))]`$ gives the abstraction $`\bar x.\, B`$ to $`X`$, and to each parameter of $`\Delta`$ what $`[\bar a / \Delta]`$ gives it, and likewise when the last parameter is a variable $`x : A`$, whose abstraction is a term:

```math
\begin{aligned}
& [(\bar a,\ \bar x.\, B) / (\Delta,\ X : (\Theta \vdash A))](X) = \bar x.\, B &&(\mathsf{params}_\theta) \\
& [(\bar a,\ \bar x.\, B) / (\Delta,\ X : (\Theta \vdash A))](y) = [\bar a / \Delta](y) \text{ if } y \ne X \\
& [(\bar a,\ B) / (\Delta,\ x : A)](x) = B \\
& [(\bar a,\ B) / (\Delta,\ x : A)](y) = [\bar a / \Delta](y) \text{ if } y \ne x
\end{aligned}
```

A context $`\Gamma`$ extended by a telescope $`\Theta`$ in its scope, written $`\Gamma,\ \Theta`$, is extended by a variable for each entry of $`\Theta`$, whose grades it drops:

```math
\begin{aligned}
& \Gamma,\ \varepsilon = \Gamma &&(\mathsf{append}_\Gamma) \\
& \Gamma,\ (x :^{q}_{p} A,\ \Theta) = (\Gamma,\ x : A),\ \Theta
\end{aligned}
```

### Closed Substitutions

A substitution of the second order is closed when the abstractions it gives are in the empty scope extended by their variables:

```math
\begin{aligned}
& \theta \text{ is closed} \iff \forall x.\ \exists \bar x,\ B.\ \theta(x) = \bar x.\, B \text{ and } B \text{ is in the scope } \bar x &&(\mathsf{closedness}_\theta)
\end{aligned}
```

The closed substitution $`(\theta_1,\ \theta_2)`$ of the scope of $`\Gamma`$ extended by variables $`\bar x`$ with empty telescopes gives each variable of $`\Gamma`$ what the closed substitution $`\theta_1`$ gives it, and each variable of $`\bar x`$ what the closed substitution $`\theta_2`$ of $`\bar x`$ gives it:

```math
\begin{aligned}
& (\theta_1,\ \theta_2)(y) = \theta_1(y) \text{ if } y \text{ is a variable of } \Gamma &&(\mathsf{pair}_\theta) \\
& (\theta_1,\ \theta_2)(y) = \theta_2(y) \text{ if } y \text{ is a variable of } \bar x
\end{aligned}
```

The closed substitution of closed arguments $`\bar t`$ for variables $`\bar x`$ with empty telescopes gives the first argument to the first variable, then the others: $`(t,\ \bar t)`$ gives $`t`$ to $`x`$, and to $`\bar x`$ what $`\bar t`$ gives them:

```math
\begin{aligned}
& (t,\ \bar t)(x) = t &&(\mathsf{args}_\theta) \\
& (t,\ \bar t)(y) = \bar t(y) \text{ if } y \text{ is a variable of } \bar x
\end{aligned}
```

### Instantiation of the Level Variables

The instantiation $`[\bar l' / \bar l]`$ of the level variables $`\bar l`$ by the levels $`\bar l'`$, as many, replaces each variable by its level:

```math
\begin{aligned}
& 0[\bar l' / \bar l] = 0 &&(\mathsf{subst}_l) \\
& (l + 1)[\bar l' / \bar l] = l[\bar l' / \bar l] + 1 \\
& (l_1 \sqcup l_2)[\bar l' / \bar l] = l_1[\bar l' / \bar l] \sqcup l_2[\bar l' / \bar l] \\
& l_i[\bar l' / \bar l] = l'_i
\end{aligned}
```

It instantiates the level of a sort, and the levels of every term, argument, telescope and context, which it leaves the same otherwise:

```math
\begin{aligned}
& (s_l)[\bar l' / \bar l] = s_{l[\bar l' / \bar l]} &&(\mathsf{inst}_l.\kappa) \\[1em]
& x[\bar t][\bar l' / \bar l] = x[\bar t[\bar l' / \bar l]] &&(\mathsf{inst}_l.t) \\
& f.\{\bar s;\ \bar l_1;\ \bar p\}[\bar l' / \bar l] = f.\{\bar s;\ \bar l_1[\bar l' / \bar l];\ \bar p\} \\
& (D.\{\bar s;\ \bar l_1;\ \bar p\}\ \bar a)[\bar l' / \bar l] = D.\{\bar s;\ \bar l_1[\bar l' / \bar l];\ \bar p\}\ \bar a[\bar l' / \bar l] \\[1em]
& ()[\bar l' / \bar l] = () &&(\mathsf{inst}_l.\bar t) \\
& (t,\ \bar t)[\bar l' / \bar l] = (t[\bar l' / \bar l],\ \bar t[\bar l' / \bar l]) \\[1em]
& ()[\bar l' / \bar l] = () &&(\mathsf{inst}_l.\bar a) \\
& (\bar a,\ \bar x.\, B)[\bar l' / \bar l] = (\bar a[\bar l' / \bar l],\ \bar x.\, B[\bar l' / \bar l]) \\[1em]
& \varepsilon[\bar l' / \bar l] = \varepsilon &&(\mathsf{inst}_l.\Theta) \\
& (x :^{q}_{p} A,\ \Theta)[\bar l' / \bar l] = (x :^{q}_{p} A[\bar l' / \bar l],\ \Theta[\bar l' / \bar l]) \\[1em]
& \varepsilon[\bar l' / \bar l] = \varepsilon &&(\mathsf{inst}_l.\Gamma) \\
& (\Gamma,\ x : A)[\bar l' / \bar l] = \Gamma[\bar l' / \bar l],\ x : A[\bar l' / \bar l] \\
& (\Gamma,\ X : (\Theta \vdash A))[\bar l' / \bar l] = \Gamma[\bar l' / \bar l],\ X : (\Theta[\bar l' / \bar l] \vdash A[\bar l' / \bar l])
\end{aligned}
```

## Properties

The identities change nothing:

```math
\begin{aligned}
& t[\sigma] = t \text{ if } \sigma(x) = x \text{ for each } x &&(\mathsf{id}_\sigma.t) \\[1em]
& \Theta[\sigma] = \Theta \text{ if } \sigma(x) = x \text{ for each } x &&(\mathsf{id}_\sigma.\Theta) \\[1em]
& t[\theta] = t \text{ if } \theta(x) = \bar x.\, x[\bar x] \text{ for each } x &&(\mathsf{id}_\theta)
\end{aligned}
```

A substitution followed by another one is a single one, which substitutes the second in what the first gives each variable, whatever the orders of the two:

```math
\begin{aligned}
& t[\sigma][\tau] = t[\sigma'] \text{ if } \sigma'(x) = \sigma(x)[\tau] \text{ for each } x &&(\mathsf{comp}_\sigma) \\[1em]
& t[\theta_1][\theta_2] = t[\theta_3] \text{ if } \theta_3(x) = \bar x.\, B[\theta_2] \text{ for each } x \text{ such that } \theta_1(x) = \bar x.\, B &&(\mathsf{comp}_\theta.t) \\[1em]
& \Theta[\theta_1][\theta_2] = \Theta[\theta_3] \text{ if } \theta_3(x) = \bar x.\, B[\theta_2] \text{ for each } x \text{ such that } \theta_1(x) = \bar x.\, B &&(\mathsf{comp}_\theta.\Theta) \\[1em]
& \text{⟹} &&(\mathsf{comp}_{\sigma\theta}.t) \\
& \quad \text{and} \\
& \qquad \theta_2(x) = \sigma(x)[\theta_1] \text{ for each } x \text{ whose telescope is empty} \\
& \qquad \theta_2(x) = \theta_1(x) \text{ for each } x \text{ whose telescope is not empty} \\
& \quad t[\sigma][\theta_1] = t[\theta_2] \\[1em]
& \text{⟹} &&(\mathsf{comp}_{\sigma\theta}.\Theta) \\
& \quad \text{and} \\
& \qquad \theta_2(x) = \sigma(x)[\theta_1] \text{ for each } x \text{ whose telescope is empty} \\
& \qquad \theta_2(x) = \theta_1(x) \text{ for each } x \text{ whose telescope is not empty} \\
& \quad \Theta[\sigma][\theta_1] = \Theta[\theta_2]
\end{aligned}
```

The substitution of arguments for the variables of a telescope commutes with the substitutions of both orders, and is, for closed arguments, the closed substitution of these arguments:

```math
\begin{aligned}
& B[\bar t / \bar x][\sigma] = B[\sigma][\bar t[\sigma] / \bar x] &&(\mathsf{inst}_\sigma) \\[1em]
& B[\bar t / \bar x][\theta] = B[\theta][\bar t[\theta] / \bar x] &&(\mathsf{inst}_\theta) \\[1em]
& \text{⟹} &&(\mathsf{closed}_\theta) \\
& \quad \text{and} \\
& \qquad B \text{ is in the empty scope extended by } \bar x \\
& \qquad \bar t \text{ are closed} \\
& \qquad \theta \text{ is the closed substitution of } \bar t \text{ for } \bar x \\
& \quad B[\bar t / \bar x] = B[\theta]
\end{aligned}
```

The value of an instantiated level is the value of the level under the values of the levels that replace its variables, the instantiations compose, and they commute with the substitutions of the first order:

```math
\begin{aligned}
& [\![l[\bar l' / \bar l]]\!]_\rho = [\![l]\!]_{\rho'} \text{ if } \rho'(l_i) = [\![l'_i]\!]_\rho \text{ for each } i &&(\mathsf{instance}_l) \\[1em]
& l[\bar l_1 / \bar l][\bar l_2 / \bar l'] = l[\bar l_1[\bar l_2 / \bar l'] / \bar l] &&(\mathsf{comp}_l.l) \\[1em]
& t[\bar l_1 / \bar l][\bar l_2 / \bar l'] = t[\bar l_1[\bar l_2 / \bar l'] / \bar l] &&(\mathsf{comp}_l.t) \\[1em]
& t[\sigma][\bar l' / \bar l] = t[\bar l' / \bar l][\sigma'] \text{ if } \sigma'(x) = \sigma(x)[\bar l' / \bar l] \text{ for each } x &&(\mathsf{comm}_l.t) \\[1em]
& \Theta[\sigma][\bar l' / \bar l] = \Theta[\bar l' / \bar l][\sigma'] \text{ if } \sigma'(x) = \sigma(x)[\bar l' / \bar l] \text{ for each } x &&(\mathsf{comm}_l.\Theta) \\[1em]
& B[\bar t / \bar x][\bar l' / \bar l] = B[\bar l' / \bar l][\bar t[\bar l' / \bar l] / \bar x] &&(\mathsf{comm}_l.\bar t) \\[1em]
& (\Gamma,\ \Theta)[\bar l' / \bar l] = \Gamma[\bar l' / \bar l],\ \Theta[\bar l' / \bar l] &&(\mathsf{comm}_l.\Gamma)
\end{aligned}
```

In $`(\mathsf{comp}_l)`$, $`\bar l'`$ are the level variables of the levels $`\bar l_1`$.
