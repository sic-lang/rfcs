# Contributing

These guidelines only describe what no tool checks: the conventions enforced by configuration files or by the checks of pull requests are not restated, and the messages of the checks explain how to fix failures.
AI agents also follow [`AGENTS.md`](AGENTS.md).

## Principles

- Keep every decision auditable: record its rationale once, where it belongs (the RFC for a design decision, the commit message for a change), and link to it elsewhere.
- Before adopting a new approach, check how established projects solve the same problem.
- Cite the source of every claim about other work (papers, documentation, languages, projects) with a link on its name in the text, so that it can be checked.
- Keep everything consistent: file layout, naming, wording and terms.
  When a convention or a term changes, apply it everywhere it is used in the same change.
- Never choose a solution that increases debt of any kind: technical, documentation, consistency or process.
  The extra work a better solution requires is not a reason to settle for a worse one.
  When some debt cannot be avoided, make it explicit in an issue.
- Favor the default configuration of tools and widely established conventions; only deviate from them with a clear reason, documented where the deviation is made.

## Style

- Write in US English: documentation, comments, commit messages, issues and pull requests.
- In Markdown files, write one sentence per line, without wrapping lines at a fixed length, so that editing a sentence only changes its own line.
  A sentence too long to read on one line is probably too long.
- Give every section of a Markdown file, whatever its level, at least one sentence of its own before its first subsection, which tells what the section holds.
- Sort alphabetically the lists whose order has no meaning.
- Start the README with one short sentence saying what the repository is, and copy it verbatim as the description of the repository on GitHub.

## Workflow

Work on a subject goes from a plan to its integration, through iterations that each design, implement, record and adjust a part of it: Plan, then Design, Implement, Record and Adjust, as many times as needed, then Integrate.
The steps outside the repositories are free, and those inside them are constrained:

- Plan, Design and Adjust happen outside the repositories, in whatever way suits the contributors, alone or in a group, with or without tools.
  - Plan gives an overall view of the subject: its scope, its risks and their countermeasures, its decisive problems and their possible solutions.
    It draws on the academic literature, the practice of other projects, experiments and prototypes, and is written down rather than kept in mind.
  - Design does the same for one iteration, sized to be easy to review, but decides instead of exploring what is possible.
  - Adjust revises the plan from the results, the problems and the solutions of the iteration.
    When the iterations do not fit together, go back to Plan.
- Implement, Record and Integrate happen in the repositories, through pull requests that follow this guide and pass the checks.
  - Implement changes one or more repositories, with one pull request per repository, but no RFC.
  - Record writes in an RFC what the implementation of the iteration confirmed, and only that iteration.
    Except to fix an RFC, implement first.
  - Integrate starts when the submitter judges a pull request ready, and only then: they ask an integrator to merge it.
    When the integrator asks for changes, go back to Plan; when they judge the pull request not relevant to the project, it is closed.

Contributors may use AI or any other tool to prepare their pull requests, and bear full responsibility for what they submit, whatever tools they used.
Only an integrator decides to integrate a pull request, never an AI or a tool, which may assist them and perform the merge they decided; the integrator bears full responsibility for accepting or rejecting it.

## Pull Requests

- The merge queue merges a pull request with a merge commit once its merge with `main` passes the checks, and the commits it brings are exactly the ones that were reviewed.
- Never rewrite the history of a pull request once pushed: make every change, including those asked by the review, a new commit, meaningful on its own, so that the review stays readable.
- A pull request needs no update from `main`, since the merge queue checks its merge with `main`.
  When it conflicts with `main`, merge `main` into it (`git merge --signoff origin/main`) and resolve the conflict in that merge commit.

## Development Environment

Install [Nix](https://nixos.org/), with flakes enabled, on Linux (x86_64 or aarch64) or macOS (Apple silicon).
`nix develop` provides every tool the checks use, at the versions of the nixpkgs commit pinned by `flake.lock`.
With [direnv](https://direnv.net/), `.envrc` loads it when entering the repository, once allowed with `direnv allow` after reading it.

For VS Code, `nix run '.#setup-vscode'` writes the recommended extensions and settings to `.vscode/`, which git ignores: the files are then yours to customize.

## Checks

`nix run '.#check'` runs every check of the pull requests, and `nix run '.#check-<name>'` one of them, such as `nix run '.#check-reuse'`.

## Developer Certificate of Origin

By signing off a commit, you certify that you have the right to submit it under the license of the repository, as described by the [Developer Certificate of Origin 1.1](https://developercertificate.org/).

Trailers end the commit message, sorted alphabetically (e.g. `Co-Authored-By`, then `Signed-off-by`): write the other trailers at the end of the message, and let `git commit -s` add the sign-off after them.
