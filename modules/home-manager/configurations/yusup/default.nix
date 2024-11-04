{
  importsFromAttrs,
  inputs,
  config,
  flake-url,
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

  programs.htop.settings = (with config.lib.htop; leftMeters [
    (bar "LeftCPUs4")
    (text "Blank")
    (text "DateTime")
    (text "Uptime")
    (text "LoadAverage")
    (text "Tasks")
    (text "Blank")
    (text "Swap")
    (text "Memory")
  ]) // (with config.lib.htop; rightMeters [
    (bar "RightCPUs4")
    (text "Blank")
    (bar "DiskIO")
    (bar "NetworkIO")
  ]);
}
