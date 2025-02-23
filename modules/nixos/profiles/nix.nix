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
      package = pkgs.nixVersions.latest;
      channel.enable = false;
      settings = {
        extra-trusted-users = [ defaultUserName ];
        experimental-features = [ "ca-derivations" ];
      };
      registry.self.flake = inputs.self;
    }
  ];
}
