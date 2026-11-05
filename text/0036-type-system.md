# RFC 0036: Type System

- Pull request: [sic-lang/rfcs#36](https://github.com/sic-lang/rfcs/pull/36)

## Summary

This RFC states the type system of Sic as a whole: what it is made of, why each piece is there, what was set aside and why, and what the whole can and cannot do.
It gives no definition, rule or property itself: the system is defined in the annexes, the files of the directory that bears the name of this file, each on one subject and each built on the ones before it.

## Motivation

The type system of Sic combines dependent types, grades that count the uses of each variable, and the refinement of specifications, as [RFC 13](https://github.com/sic-lang/rfcs/pull/13) requires.
Its pieces are tightly bound: the declared types need an equality to state their indices and their extensionality, and the equality is defined on the declared types, so that the system cannot be split into documents that each stand alone without one of them depending on a later one.
This RFC therefore states the system in one place, and keeps apart the two things a reader looks for: the main document says what the system is made of and why, for a reader who decides or reviews the design, and the annexes say exactly what it is, for a reader who checks or implements it.

## Proposal

The type system is presented in the annexes, in the order in which they build on each other.
This document lists the pieces of the system and the reasons for each of them, and refers to the annex that defines it.

### Annexes

Each annex states one subject, with its definitions, its meaning and its properties, and only them; it names the annexes it builds on, and an annex never builds on a later one.
Its file name starts with a number on two digits, which gives the order of the annexes.
The examples are in the directory `99-examples` of the annexes, one file per example, named after the number of the annex it illustrates: they are derived from the system, and are not part of it.

- [Notation](0036-type-system/01-notation.md): the letters that name each kind of object, and the conventions shared by all the rules and formulas of the annexes.

## Drawbacks

- One RFC for the whole type system is a large document to review, even with the definitions in the annexes; its parts are accepted together, since none of them stands alone.

## Rationale and Alternatives

The design of the type system follows a few principles, which explain most of its choices:

- Soundness first: a program the compiler accepts has the properties its types state, as [RFC 13](https://github.com/sic-lang/rfcs/pull/13) requires, and no other benefit justifies weakening it.
- No two mechanisms for the same thing: a need that an existing piece already meets gets no second piece, so that every piece has one role and the system stays small.
- Few pieces, but powerful ones: a piece is chosen general enough to cover several needs, as a codata type whose destructors take arguments gives both the functions and the additive conjunction $`\&`$ of linear logic.
- Embrace duality where it exists: when a construct has a dual, both are given together and named after each other, as the data types and the codata types.
- No speculative mechanism: a piece enters the system for a use that exists, not for one that might come.
- Conscious exclusions: what the system leaves out is stated with what is lost, what remains, and whether it can be added later.

The type system was first split into four RFCs, the grades, the core, the data and codata types, and the observational equality, linked by a contract that each kind of declaration fulfills.
The split did not hold: the data and codata types kept deferring to the equality what they needed, the indexed families, the extensionality of the recursive types, and the liftings through some nested types, while the equality is defined on the data and codata types.
One RFC with short annexes keeps the definitions readable, one subject at a time, without a cycle between documents.

## Prior Art

- The graded dependent type theory of [Abel, Danielsson and Eriksson](https://doi.org/10.1145/3607862), and its [formalization in Agda](https://github.com/graded-type-theory/graded-type-theory), on which the rules of the type system are built.

## Unresolved Questions

- The annexes are written as the system is settled, subject by subject, so that the list above grows with them.
