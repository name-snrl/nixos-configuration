{
  inputs,
  config,
  vars,
  lib,
  ...
}:
{
  imports = inputs.self.moduleTree.home-manager {
    configurations = false;
    profiles = {
      _defaultsRecursive = false;
      common = true;
      snrl.git = true;
    };
  };

  home.homeDirectory = "/home/${config.home.username}";
  home.stateVersion = "23.11";

  home.shellAliases.hmupgrade = "nix run --refresh ${vars.flake-ref}#home-manager -- switch --flake ${vars.flake-ref}";

  programs.htop.settings = lib.mapAttrs (_: lib.mkForce) (
    with config.lib.htop;
    leftMeters [
      (bar "LeftCPUs4")
      (text "Blank")
      (text "DateTime")
      (text "Uptime")
      (text "LoadAverage")
      (text "Tasks")
      (text "Blank")
      (text "Swap")
      (text "Memory")
    ]
    // rightMeters [
      (bar "RightCPUs4")
      (text "Blank")
      (bar "DiskIO")
      (bar "NetworkIO")
    ]
  );
}
