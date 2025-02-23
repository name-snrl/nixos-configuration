{
  lib,
  osConfig,
  pkgs,
  config,
  inputs,
  ...
}:
{
  nix = lib.mkIf (osConfig == null) (
    lib.mkMerge [
      (import inputs.self.moduleTree.common.profiles.nix)
      {
        package = pkgs.nixVersions.latest;
        settings.extra-trusted-users = [ config.home.username ];
        registry.self.flake = inputs.self;
      }
    ]
  );
}
