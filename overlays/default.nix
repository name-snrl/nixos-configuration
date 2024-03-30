{ lib, inputs, ... }:
{
  flake.overlays = {
    default =
      with inputs;
      lib.composeManyExtensions [
        self.overlays.overrides
        self.overlays.gateway
        self.overlays.pkgs
        nvim.overlays.default
      ];
    overrides = import ./overrides.nix inputs;
    gateway = import ./gateway.nix inputs;
  };
}
