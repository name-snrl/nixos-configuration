{
  lib,
  inputs,
  # deadnix: skip
  __findFile,
  ...
}:
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
    overrides = import <overlays/overrides.nix> inputs;
    gateway = import <overlays/gateway.nix> inputs;
    pkgs = import <pkgs>;
  };
}
