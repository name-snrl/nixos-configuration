{ inputs, ... }:
{
  programs.home-manager.enable = true;
  home.shellAliases = {
    hm = "home-manager";
    jhm = "cd ${inputs.home-manager.outPath}";
  };
}
