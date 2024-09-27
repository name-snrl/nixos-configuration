{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
{
  nix = lib.mkMerge [
    (import inputs.self.moduleTree.common.profiles.nix)
    {
      package = pkgs.lix;
      channel.enable = false;
      settings = {
        extra-trusted-users = [ config.users.users.default.name ];
        experimental-features = [ "ca-derivations" ];
      };
      registry.self.flake = inputs.self;
    }
  ];
}
