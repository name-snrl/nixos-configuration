{
  lib,
  inputs,
  # deadnix: skip
  __findFile,
  ...
}:
{
  flake.overlays = {
    composite =
      with inputs;
      lib.composeManyExtensions [
        self.overlays.overrides
        self.overlays.gateway
        self.overlays.default
        nvim.overlays.default
      ];
    overrides = import <overlays/overrides.nix> inputs;
    gateway = import <overlays/gateway.nix> inputs;
    default = import <pkgs>;
  };
}
