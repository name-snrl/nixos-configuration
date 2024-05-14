{ modulesPath, ... }:
{
  programs.home-manager.enable = true;
  home.shellAliases = {
    hm = "home-manager";
    jhm = "cd ${modulesPath}/..";
  };
}
