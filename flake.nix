# Tools of the contributors and checks of the CI, pinned by flake.lock: the versions of the
# nixpkgs commit it locks.
{
  description = "Development environment of the Sic RFCs";

  # The stable branch: its tools are in the binary cache (reuse cannot be built on
  # nixpkgs-unstable at the moment); flake.lock pins its commit.
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs =
    { nixpkgs, ... }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      json = pkgs.formats.json { };
      # The recommended VS Code configuration: one extension per tool of the checks.
      vscodeExtensions = json.generate "extensions.json" {
        recommendations = [
          "davidanson.vscode-markdownlint"
          "editorconfig.editorconfig"
          "github.vscode-github-actions"
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
      };
      # Writes the recommended configuration to .vscode/, which git ignores, without overwriting a
      # file that differs from it, unless --force is given.
      setupVscode = pkgs.writeShellApplication {
        name = "setup-vscode";
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
            echo "usage: setup-vscode [--force]" >&2
            exit 2
            ;;
          esac
          dir=$(git rev-parse --show-toplevel)/.vscode
          status=0
          for source in ${vscodeExtensions} ${vscodeSettings}; do
            target=$dir/''${source#*-}
            if [ ! -e "$target" ]; then
              install -D -m 644 "$source" "$target"
              echo "created $target"
            elif cmp -s "$source" "$target"; then
              echo "up to date $target"
            elif $force; then
              install -m 644 "$source" "$target"
              echo "overwritten $target"
            else
              diff -u "$target" "$source" || true
              echo "kept $target, which differs from the recommended one above: merge it by hand, or overwrite it with --force" >&2
              status=1
            fi
          done
          exit "$status"
        '';
      };
    in
    {
      apps.x86_64-linux.setup-vscode = {
        type = "app";
        program = pkgs.lib.getExe setupVscode;
        meta.description = "Write the recommended VS Code configuration to .vscode/";
      };

      # Built by nix flake check, which runs ShellCheck on the script.
      checks.x86_64-linux.setup-vscode = setupVscode;

      devShells.x86_64-linux.default = pkgs.mkShellNoCC {
        packages = [
          pkgs.actionlint
          pkgs.editorconfig-checker
          pkgs.markdownlint-cli2
          pkgs.nixfmt
          pkgs.reuse
          pkgs.shellcheck
          pkgs.shfmt
          pkgs.taplo
          pkgs.typos
          pkgs.yamllint
        ];
      };
    };
}
