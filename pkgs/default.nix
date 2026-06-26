{
  inputs,
  config,
  lib,
  ...
}:
{
  imports = [
    inputs.flake-parts.flakeModules.easyOverlay
  ];

  systems = lib.systems.flakeExposed;

  flake.overlays.composite = lib.composeManyExtensions [
    config.flake.overlays.overrides
    config.flake.overlays.gateway
    config.flake.overlays.default

    inputs.nvim.overlays.default
  ];

  perSystem =
    {
      system,
      config,
      final,
      ...
    }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = lib.singleton inputs.nvim.overlays.default;
        config.allowUnfree = true;
      };

      legacyPackages = import inputs.nixpkgs {
        inherit system;
        overlays = lib.singleton inputs.self.overlays.composite;
        config.allowUnfree = true;
      };

      overlayAttrs = config.packages;

      packages = {
        nvim-full = final.callPackage ./nvim-full { };
      };
    };
}
