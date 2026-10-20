# Contributing

These guidelines only describe what no tool checks: the conventions enforced by configuration files or by the checks of pull requests are not restated, and the messages of the checks explain how to fix failures.
AI agents also follow [`AGENTS.md`](AGENTS.md).

## Principles

- Keep every decision auditable: record its rationale once, where it belongs (the RFC for a design decision, the commit message for a change), and link to it elsewhere.
- Before adopting a new approach, check how established projects solve the same problem.
- Favor the default configuration of tools and widely established conventions; only deviate from them with a clear reason, documented where the deviation is made.

## Style

- Write in US English: documentation, comments, commit messages, issues and pull requests.
- In Markdown files, write one sentence per line, without wrapping lines at a fixed length, so that editing a sentence only changes its own line.
  A sentence too long to read on one line is probably too long.
- Sort alphabetically the lists whose order has no meaning.
- Start the README with one short sentence saying what the repository is, and copy it verbatim as the description of the repository on GitHub.

## Pull Requests

- Pull requests are merged with a merge commit, and the commits they bring are exactly the ones that were reviewed.
  Make every commit meaningful on its own: fold the changes made during review into the relevant commits (`git commit --fixup=<commit>`, then `git rebase --autosquash`) and force-push.
- Keep the history of a pull request linear: rebase it on `main` to update it, with `git rebase` or "Update with rebase" on GitHub, never by merging `main` into it.

## Local Checks

Install [Nix](https://nixos.org/), with flakes enabled.
`nix develop` provides every tool the checks use, at the versions of the nixpkgs commit pinned by `flake.lock`.
Run a check locally with the command of its job in [`.github/workflows/checks.yml`](.github/workflows/checks.yml), for instance:

```sh
nix develop --command reuse lint
```

## Developer Certificate of Origin

By signing off a commit, you certify that you have the right to submit it under the license of the repository, as described by the [Developer Certificate of Origin 1.1](https://developercertificate.org/).

Sign off every commit with a `Signed-off-by` trailer matching its author.
Trailers end the commit message, sorted alphabetically (e.g. `Co-Authored-By`, then `Signed-off-by`): write the other trailers at the end of the message, and let `git commit -s` add the sign-off after them.
