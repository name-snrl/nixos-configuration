{
  lib,
  inputs,
  pkgs,
  defaultUserName,
  ...
}:
{
  nix = lib.mkMerge [
    (import inputs.self.moduleTree.common.profiles.nix)
    {
      package = pkgs.lix;
      channel.enable = false;
      settings = {
        extra-trusted-users = [ defaultUserName ];
        experimental-features = [ "ca-derivations" ];
      };
      registry.self.flake = inputs.self;
    }
  ];
}
