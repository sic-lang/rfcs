# RFCs

RFCs for the Sic programming language.
An RFC (request for comments) proposes a substantial change to the language, its tools or the project, and records the decision with its rationale.

## Process

1. Copy [`0000-template.md`](0000-template.md) to `text/0000-short-name.md` and fill it in.
2. Open a pull request: the RFC is discussed in it.
3. Rename the file after the number of the pull request, on four digits (`text/0042-short-name.md`), and link the pull request in its header.
4. The pull request is merged if the RFC is accepted, and closed if it is rejected.

## Changing an Accepted RFC

An accepted RFC is never deleted nor renumbered, and only receives very minor amendments, such as fixing a typo.
A substantial change is a new RFC, which supersedes the old one: a note is added at the top of the old RFC, linking to the new one.

## License

Licensed under the [Apache License, Version 2.0](LICENSES/Apache-2.0.txt) with [LLVM Exceptions](LICENSES/LLVM-exception.txt) (`Apache-2.0 WITH LLVM-exception`).
