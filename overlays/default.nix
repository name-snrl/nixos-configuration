inputs:
with inputs;
nixpkgs.lib.composeManyExtensions [
  self.overlays.overrides
  self.overlays.gateway
  self.overlays.pkgs
  nvim.overlays.default
]
