{ lib, inputs, ... }:
{
  systems = lib.systems.flakeExposed;

  flake.overlays.pkgs = import ./top-level.nix;

  perSystem =
    { pkgs, system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = lib.singleton inputs.self.overlays.default;
        config.allowUnfree = true;
      };
      legacyPackages = pkgs;
    };
}
