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
    in
    {
      devShells.x86_64-linux.default = pkgs.mkShellNoCC {
        packages = [
          pkgs.markdownlint-cli2
          pkgs.reuse
        ];
      };
    };
}
