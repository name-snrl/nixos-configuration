{
  lib,
  inputs,
  ...
}:
{
  systems = lib.systems.flakeExposed;

  flake.overlays = {
    composite =
      with inputs;
      lib.composeManyExtensions [
        self.overlays.overrides
        self.overlays.gateway
        self.overlays.default
        nvim.overlays.default
      ];
    overrides = import overlays/overrides.nix inputs;
    gateway = import overlays/gateway.nix inputs;
    default = import ./pkgs;
  };

  perSystem =
    { pkgs, system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = lib.singleton inputs.self.overlays.composite;
        config.allowUnfree = true;
      };

      legacyPackages = pkgs;
    };
}
