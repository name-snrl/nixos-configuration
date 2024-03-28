{
  description = "A minimal flake with a devShell.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { lib, ... }:
      {
        systems = lib.systems.flakeExposed;
        perSystem =
          { pkgs, ... }:
          {
            devShells.default =
              with pkgs;
              mkShellNoCC {
                packages = [
                  # your packages here
                ];
              };
          };
      }
    );
}
