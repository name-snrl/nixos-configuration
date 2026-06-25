{
  lib,
  osConfig,
  config,
  ...
}:
{
  nix = lib.mkIf (osConfig == null) {
    settings.extra-trusted-users = [ config.home.username ];
  };
}
