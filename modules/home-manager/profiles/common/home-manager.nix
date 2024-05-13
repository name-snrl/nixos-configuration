{ config, modulesPath, ... }:
let
  cfgPath = "${config.home.homeDirectory}/nixos-configuration";
in
{
  programs.home-manager.enable = true;
  home.shellAliases = {
    hm = "home-manager";
    jhm = "cd ${modulesPath}/..";
    hmupgrade = "home-manager switch --flake github:name-snrl/nixos-configuration";
    hmswitch = "home-manager switch --flake ${cfgPath}";
    hmbuild = "home-manager build --no-out-link ${cfgPath}";
    hmupdate = "nix flake update --commit-lock-file ${cfgPath}";
    hmclear = "nix-collect-garbage --delete-old";
  };
}
