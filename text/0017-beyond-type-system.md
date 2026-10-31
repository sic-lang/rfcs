# RFC 0017: Goals Beyond the Type System

- Pull request: [sic-lang/rfcs#17](https://github.com/sic-lang/rfcs/pull/17)

> **On hold** until the type system built on the [layers](https://github.com/sic-lang/rfcs/pull/13) is defined.
> Meanwhile, the RFCs of the type system may refer to its design axes.

## Summary

This RFC states the goals of Sic beyond its type system: its use cases, the design axes along which every choice is a trade-off, the requirements on the language and its tools, and the non-goals.

## Motivation

The layers fix what the type system must achieve, but most design choices, inside and outside the type system, are trade-offs between properties that the layers do not decide.
Writing these trade-offs down lets every RFC argue its choices from the same reference.

## Proposal

The proposal lists the use cases of Sic, the design axes along which its choices are trade-offs, the requirements on the language and on its tools, and the non-goals.

### Use Cases

Sic targets the following use cases, all but general-purpose programming motivating the [layers](https://github.com/sic-lang/rfcs/pull/13):

- critical systems;
- distributed systems;
- general-purpose programming;
- low-level programming (drivers, firmware);
- systems programming (operating systems).

### Design Axes

Beyond the layers of the type system, every design choice is a trade-off along several axes.
An axis is a spectrum, not a binary choice: Sic leans to one side of each, for the reason given, and every RFC studies its proposal along the axes it touches.
This list is not exhaustive.

#### Implicit and Explicit

Implicitness eases writing and hides details that do not help understanding, but it can hide unexpected behavior and costs.
Explicitness hides nothing and limits the knowledge needed to read code, but it is heavier to write, and too many details can also hinder understanding.

Sic leans to explicitness for what runs: nothing happens at run time that the source code does not show, such as control flow, conversions, allocations or effects.
Every choice to make something implicit must be justified; proofs and specifications, which do not run, can afford more implicitness than executed code.
For example, a type may define operators for itself, but no code may redefine the operators of an existing type, such as `+` on integers.

#### Readability and Writability

Sic leans to readability: most code will be written by AI agents, and humans must be able to check that it does what they want.
Types, which state the specification, must be clear enough for a human to validate them.
Readability does not mean verbosity, which hinders it too.

#### Abstraction and Run-Time Cost

Sic leans to abstractions that cost nothing when they are not used: a feature that a program does not use costs it nothing, at compile time or at run time.
In particular, proofs and specifications are erased from the compiled program.

#### Run-Time and Compile-Time Performance

Some choices speed up compiled programs at the expense of the compiler, or the reverse, such as specializing generic code for each type.
Sic leans to the performance of compiled programs, as long as the compiler and tools stay fast enough for checking proofs to fit in the edit cycle.

#### Expressiveness and Automation

The more expressive types are, the less a compiler can infer and prove by itself: type inference is undecidable with dependent types.
Sic does not trade away the expressiveness that the layers need, and automates inference and proofs wherever it can, without hiding what was inferred.

#### Small Core and Rich Language

Every feature added to the core language enlarges what soundness depends on.
Sic leans to a small core, into which the other features are translated, as [Agda](https://agda.readthedocs.io/en/stable/), [Idris](https://www.idris-lang.org/) and [Lean](https://lean-lang.org/) do, so that the soundness of the whole rests on the core.

### Requirements

The language and its tools provide:

- **Compile-time evaluation**: the compiler evaluates terms, by normalizing them, while it checks types and proofs, so computations and simplifications happen at compile time, as in [Agda](https://agda.readthedocs.io/en/stable/); the same evaluation serves metaprogramming.
- **Generic programming**: functions and types are parameterized by types and values, like [generics in Rust](https://doc.rust-lang.org/book/ch10-00-generics.html) or [templates in C++](https://en.cppreference.com/w/cpp/language/templates); with dependent types, they are ordinary functions over types.
- **Metaprogramming**: programs can inspect and generate programs; hygienic macros, as in [Rust](https://doc.rust-lang.org/reference/macros-by-example.html), may be considered.
- **Performance**: compiled programs are as fast as their equivalent in C.
- **Safe low-level programming**: the layers of the type system make low-level code safe, with control over memory layout and hardware access.
- **Static typing**: every program is statically typed, and types can be inferred.
- **Unicode**: text is Unicode, encoded in UTF-8, as in Rust, whose [strings](https://doc.rust-lang.org/std/string/struct.String.html) are guaranteed to be valid UTF-8, unlike Zig, whose [strings](https://ziglang.org/documentation/master/#String-Literals-and-Unicode-Code-Point-Literals) are arrays of bytes.

### Tooling

- A package manager makes builds reproducible: the same sources and lock file give the same result.
- Each release of Sic comes with a software bill of materials in [SPDX](https://spdx.dev/) format, which [`reuse spdx`](https://reuse.software/) can generate, so that anyone can check what it contains and under which licenses.
- The package manager produces a software bill of materials for every package it builds.

### Non-Goals

- Dynamic typing: it is forbidden.
- Exceptions: they hide control flow, which makes code hard to read; they are forbidden.
- Preprocessors based on text substitution, as in [C and C++](https://en.cppreference.com/w/cpp/preprocessor): they are forbidden.

## Drawbacks

Stating requirements before the type system is defined may commit to features that the type system makes unnecessary or hard.

## Rationale and Alternatives

- Stating the goals as needs rather than mechanisms keeps the later RFCs free to choose the best mechanism for each.

## Prior Art

- [Zig](https://ziglang.org/learn/overview/): no hidden control flow, no hidden memory allocations (functions that allocate take an allocator as a parameter), no preprocessor and no macros, with compile-time evaluation instead.

## Unresolved Questions

- Should the RFC template ask every RFC to discuss its proposal along the design axes?
- May identifiers and operators use Unicode, as in Agda, given readability?
