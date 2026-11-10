# Tools of the contributors and checks of the CI, pinned by flake.lock: the versions of the
# nixpkgs commit it locks.
{
  description = "Development environment of the Sic RFCs";

  # The unstable branch, for the latest releases of the tools; flake.lock pins its commit.
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      # The popular systems whose tools are all in the binary cache of nixpkgs: Linux on x86_64 and
      # aarch64, and macOS on Apple silicon.
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
      outputs = nixpkgs.lib.genAttrs systems (system: perSystem nixpkgs.legacyPackages.${system});
      perSystem =
        pkgs:
        let
          inherit (pkgs) lib;
          json = pkgs.formats.json { };
          # A command of the flake, in two variants of the same script: nix run builds the one that
          # skips ShellCheck, quickly, and nix flake check, run by the flake check, the one that runs it.
          command = args: {
            run = pkgs.writeShellApplication (args // { checkPhase = ":"; });
            checked = pkgs.writeShellApplication args;
          };
          app = program: description: {
            type = "app";
            program = lib.getExe program.run;
            meta = { inherit description; };
          };
          # The checks of the files: their tools, also provided by the development shell, and their
          # command, run from the root of the repository.
          fileChecks = {
            actionlint = {
              tools = [ pkgs.actionlint ];
              command = "actionlint";
            };
            editorconfig = {
              tools = [ pkgs.editorconfig-checker ];
              command = "editorconfig-checker";
            };
            # Runs the Nix of the environment, which builds the checked variants of the commands.
            flake = {
              tools = [ ];
              command = "nix flake check --quiet";
            };
            # Checks the names of the formulas and of the rules of the RFCs (CONTRIBUTING.md).
            names = {
              tools = [ ];
              command = lib.getExe checkNames.run;
            };
            markdownlint = {
              tools = [ pkgs.markdownlint-cli2 ];
              command = "markdownlint-cli2 '**/*.md'";
            };
            nixfmt = {
              tools = [
                pkgs.findutils
                pkgs.nixfmt
              ];
              command = "git ls-files -z '*.nix' | xargs -0 nixfmt --check";
            };
            reuse = {
              tools = [ pkgs.reuse ];
              command = "reuse lint";
            };
            shellcheck = {
              tools = [
                pkgs.findutils
                pkgs.shellcheck
              ];
              command = "git ls-files -z .envrc '*.sh' | xargs -0 shellcheck";
            };
            shfmt = {
              tools = [
                pkgs.findutils
                pkgs.shfmt
              ];
              command = "git ls-files -z .envrc '*.sh' | xargs -0 shfmt --diff";
            };
            # Builds the site, which GitHub Pages serves.
            site = {
              tools = [
                pkgs.mdbook
                pkgs.mdbook-katex
                pkgs.mdbook-mermaid
              ];
              command = lib.getExe buildSite.run;
            };
            taplo = {
              tools = [ pkgs.taplo ];
              command = "taplo fmt --check";
            };
            typos = {
              tools = [ pkgs.typos ];
              command = "typos";
            };
            yamllint = {
              tools = [ pkgs.yamllint ];
              command = "yamllint --strict .";
            };
          };
          # Builds the RFC book into book/: src/ links the README as the introduction and every entry
          # of text/, and its SUMMARY.md lists the RFCs in the order of their file names, that is of
          # their numbers, which never change: an accepted RFC is never renumbered. The annexes of an
          # RFC, in the directory named after it, are its subchapters, in the order of their file
          # names, which start with their numbers.
          buildSite = command {
            name = "build-site";
            runtimeInputs = [
              pkgs.coreutils
              pkgs.git
              pkgs.mdbook
              pkgs.mdbook-katex
              pkgs.mdbook-mermaid
            ];
            text = ''
              cd "$(git rev-parse --show-toplevel)"
              rm -rf src
              mkdir src
              ln -s ../README.md src/introduction.md
              ln -s ../LICENSES src/LICENSES
              for entry in text/*; do
                ln -s "../$entry" "src/''${entry#text/}"
              done
              # An RFC without annexes has no directory, whose pattern then matches nothing.
              shopt -s nullglob
              {
                printf '[Introduction](introduction.md)\n\n'
                for file in text/*.md; do
                  name=''${file#text/}
                  printf -- '- [%s](%s)\n' "''${name%.md}" "$name"
                  for annex in "''${file%.md}"/*.md; do
                    annexName=''${annex#text/}
                    annexTitle=''${annexName##*/}
                    printf -- '  - [%s](%s)\n' "''${annexTitle%.md}" "$annexName"
                  done
                done
              } >src/SUMMARY.md
              # The JavaScript files of mdbook-mermaid, which its install command writes next to the
              # book.toml it rewrites: a temporary one, which keeps that of the repository as it is.
              mermaid=$(mktemp -d)
              trap 'rm -rf "$mermaid"' EXIT
              touch "$mermaid/book.toml"
              RUST_LOG=warn mdbook-mermaid install "$mermaid"
              cp "$mermaid"/*.js .
              mdbook build
            '';
          };
          # Checks that a formula is named in its last column and a rule after its fraction, as the
          # names are extracted, and that every name designates one formula or rule of the RFCs.
          checkNames = command {
            name = "check-names";
            runtimeInputs = [
              pkgs.coreutils
              pkgs.git
              pkgs.gnugrep
            ];
            text = ''
              cd "$(git rev-parse --show-toplevel)"
              mapfile -d "" files < <(git ls-files -z 'text/*.md')
              if [ ''${#files[@]} -eq 0 ]; then
                exit 0
              fi
              # A name, then the end of its line, which may break the formula with \\ or \\[1em].
              name='\([^()]*\)(?=\s*(\\\\(\[1em\])?)?\s*$)'
              status=0
              if grep -nP '&&' "''${files[@]}" | grep -vP "&&$name"; then
                echo 'A column && of a formula must end its line with the name of the formula, as &&(\mathsf{op}_p).' >&2
                status=1
              fi
              if grep -nP '^\s*\\frac' "''${files[@]}" | grep -vP "\\\;$name"; then
                echo 'A rule must end its line with its name after its fraction, as \frac{…}{…}\;(\mathsf{def}).' >&2
                status=1
              fi
              duplicates=$({ grep -hoP "(&&|\\\;)\K$name" "''${files[@]}" || true; } | sort | uniq -d)
              if [ -n "$duplicates" ]; then
                printf '%s\n' "$duplicates"
                echo 'Each of these names designates several formulas or rules: give each its own name.' >&2
                status=1
              fi
              exit "$status"
            '';
          };
          # Checks the commits after a base, origin/main by default, up to a head, HEAD by default: each
          # one is signed off by its author (CONTRIBUTING.md), and a merge commit only merges the base,
          # to resolve a conflict.
          checkCommits = command {
            name = "check-commits";
            runtimeInputs = [
              pkgs.coreutils
              pkgs.git
              pkgs.gnugrep
            ];
            text = ''
              base=''${1:-origin/main}
              head=''${2:-HEAD}
              status=0
              for commit in $(git rev-list --merges "$base..$head"); do
                for parent in $(git log -1 --format='%P' "$commit" | cut -d ' ' -f 2-); do
                  if ! git merge-base --is-ancestor "$parent" "$base"; then
                    echo "$(git log -1 --format='%h %s' "$commit"): merges another branch than $base" >&2
                    status=1
                  fi
                done
              done
              for commit in $(git rev-list "$base..$head"); do
                author=$(git log -1 --format='%an <%ae>' "$commit")
                if ! git log -1 --format='%(trailers:key=Signed-off-by,valueonly)' "$commit" |
                  grep -qxF "$author"; then
                  echo "$(git log -1 --format='%h %s' "$commit"): no Signed-off-by: $author" >&2
                  status=1
                fi
              done
              exit "$status"
            '';
          };
          # Every check, as a command check-<name>: each job of the CI runs one of them, listed in the
          # matrix of .github/workflows/checks.yml, where a new check must be added too.
          checkCommands =
            lib.mapAttrs (
              name: check:
              command {
                name = "check-${name}";
                runtimeInputs = [ pkgs.git ] ++ check.tools;
                text = ''
                  cd "$(git rev-parse --show-toplevel)"
                  ${check.command}
                '';
              }
            ) fileChecks
            // {
              commits = checkCommits;
            };
          # Runs every check, and shows the output of those that fail.
          checkAll = command {
            name = "check";
            text = ''
              status=0
              run() {
                local name=$1 output
                shift
                if output=$("$@" 2>&1); then
                  echo "ok    $name"
                else
                  echo "FAIL  $name"
                  echo "$output"
                  status=1
                fi
              }
              ${lib.concatMapStrings (name: "run ${name} ${lib.getExe checkCommands.${name}.run}\n") (
                lib.attrNames checkCommands
              )}
              exit "$status"
            '';
          };
          # The recommended VS Code configuration: one extension per tool of the checks, and the one
          # that reviews the pull requests in the editor.
          vscodeExtensions = json.generate "extensions.json" {
            recommendations = [
              "davidanson.vscode-markdownlint"
              "editorconfig.editorconfig"
              "github.vscode-github-actions"
              "github.vscode-pull-request-github"
              "jnoortheen.nix-ide"
              "mkhl.direnv"
              "mkhl.shfmt"
              "redhat.vscode-yaml"
              "tamasfe.even-better-toml"
              "tekumara.typos-vscode"
              "timonwong.shellcheck"
            ];
          };
          vscodeSettings = json.generate "settings.json" {
            # Lines are not wrapped at a fixed length.
            "[markdown]"."editor.wordWrap" = "on";
            # The binaries of the development shell, loaded by direnv, instead of the bundled ones.
            "evenBetterToml.taplo.bundled" = false;
            "shellcheck.executablePath" = "shellcheck";
            # The nixd language server, which then formats with nixfmt instead of nix.formatterPath.
            "nix.enableLanguageServer" = true;
            "nix.serverPath" = "nixd";
            "nix.serverSettings".nixd.formatting.command = [ "nixfmt" ];
          };
          # The recommended Git hooks: commit-msg rejects a commit without the sign-off of its author,
          # which the commits check requires, before it exists. It runs the Bash and the Git of the
          # contributor, since its copy cannot depend on paths of the Nix store, which may be collected:
          # two variants, as for the commands, the one of nix flake check runs ShellCheck.
          hook = args: {
            run = pkgs.writeTextFile (args // { executable = true; });
            checked = pkgs.writeTextFile (
              args
              // {
                executable = true;
                checkPhase = ''${lib.getExe pkgs.shellcheck} "$target"'';
              }
            );
          };
          commitMsgHook = hook {
            name = "commit-msg";
            text = ''
              #!/usr/bin/env bash
              set -euo pipefail
              author=$(git var GIT_AUTHOR_IDENT | sed 's/ [0-9]* [-+][0-9]*$//')
              if ! git interpret-trailers --parse "$1" | grep -qxF "Signed-off-by: $author"; then
                echo "no Signed-off-by: $author, which git commit -s adds" >&2
                exit 1
              fi
            '';
          };
          # A setup: writes recommended files to a directory, each under the name of its source in the
          # Nix store, without overwriting a file that differs from it, unless --force is given.
          setup =
            {
              name,
              dir,
              mode,
              sources,
            }:
            command {
              inherit name;
              runtimeInputs = [
                pkgs.coreutils
                pkgs.diffutils
                pkgs.git
              ];
              text = ''
                force=false
                case "$*" in
                "") ;;
                --force) force=true ;;
                *)
                  echo "usage: ${name} [--force]" >&2
                  exit 2
                  ;;
                esac
                dir=${dir}
                sources=(${lib.concatStringsSep " " sources})
                status=0
                for source in "''${sources[@]}"; do
                  target=$dir/''${source#*-}
                  if [ ! -e "$target" ]; then
                    install -D -m ${mode} "$source" "$target"
                    echo "created $target"
                  elif cmp -s "$source" "$target"; then
                    echo "up to date $target"
                  elif $force; then
                    install -m ${mode} "$source" "$target"
                    echo "overwritten $target"
                  else
                    diff -u --color=auto "$target" "$source" || true
                    echo "kept $target, which differs from the recommended one above: merge it by hand, or overwrite it with --force" >&2
                    status=1
                  fi
                done
                exit "$status"
              '';
            };
          # Every setup, as a command setup-<name>, with the description of its app.
          setups = {
            # Copies the hooks to the directory where Git looks for them, .git/hooks unless
            # core.hooksPath says otherwise.
            hooks = {
              description = "Copy the recommended Git hooks to the hooks of the clone";
              command = setup {
                name = "setup-hooks";
                dir = "$(git rev-parse --path-format=absolute --git-path hooks)";
                mode = "755";
                sources = [ commitMsgHook.run ];
              };
            };
            # Writes the configuration to .vscode/, which git ignores.
            vscode = {
              description = "Write the recommended VS Code configuration to .vscode/";
              command = setup {
                name = "setup-vscode";
                dir = "$(git rev-parse --show-toplevel)/.vscode";
                mode = "644";
                sources = [
                  vscodeExtensions
                  vscodeSettings
                ];
              };
            };
          };
          # Runs every setup, with the same arguments.
          setupAll = command {
            name = "setup";
            text = ''
              status=0
              ${lib.concatMapStrings (
                name: ''${lib.getExe setups.${name}.command.run} "$@" || status=1'' + "\n"
              ) (lib.attrNames setups)}
              exit "$status"
            '';
          };
        in
        {
          apps =
            lib.mapAttrs' (
              name: command: lib.nameValuePair "check-${name}" (app command "Run the ${name} check")
            ) checkCommands
            // {
              build-site = app buildSite "Build the site that GitHub Pages serves into book/";
              check = app checkAll "Run every check";
              setup = app setupAll "Run every setup";
            }
            // lib.mapAttrs' (
              name: setup: lib.nameValuePair "setup-${name}" (app setup.command setup.description)
            ) setups;

          # Built by nix flake check, which runs ShellCheck on their scripts and on the hooks.
          checks =
            lib.mapAttrs' (name: command: lib.nameValuePair "check-${name}" command.checked) checkCommands
            // {
              build-site = buildSite.checked;
              check = checkAll.checked;
              hook-commit-msg = commitMsgHook.checked;
              setup = setupAll.checked;
            }
            // lib.mapAttrs' (name: setup: lib.nameValuePair "setup-${name}" setup.command.checked) setups;

          # The tools of the checks, and the language servers of the editors.
          devShells.default = pkgs.mkShellNoCC {
            packages = lib.unique (lib.concatMap (check: check.tools) (lib.attrValues fileChecks)) ++ [
              pkgs.nixd
            ];
          };
        };
    in
    {
      apps = nixpkgs.lib.mapAttrs (system: outputs: outputs.apps) outputs;
      checks = nixpkgs.lib.mapAttrs (system: outputs: outputs.checks) outputs;
      devShells = nixpkgs.lib.mapAttrs (system: outputs: outputs.devShells) outputs;
    };
}
