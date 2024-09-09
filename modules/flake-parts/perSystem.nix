{ lib, inputs, ... }:
{
  systems = lib.systems.flakeExposed;
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
