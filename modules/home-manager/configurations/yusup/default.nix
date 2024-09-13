{
  importsFromAttrs,
  inputs,
  config,
  flake-url,
  lib,
  ...
}:
{
  imports = importsFromAttrs {
    modules = inputs.self.moduleTree.home-manager;
    imports = {
      configurations = false;
      profiles = {
        gf = false;
        snrl = false;
      };
    };
  };

  home.homeDirectory = "/home/${config.home.username}";
  home.stateVersion = "23.11";

  home.shellAliases.hmupgrade = "nix run --refresh ${flake-url}#home-manager -- switch --flake ${flake-url}";

  programs.htop.settings = lib.mkAfter {
    left_meters = "LeftCPUs4 Blank DateTime Uptime LoadAverage Tasks Blank Swap Memory";
    right_meters = "RightCPUs4 Blank DiskIO NetworkIO";
  };
}
