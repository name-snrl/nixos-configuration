{ inputs, defaultUserName, ... }:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager.users.${defaultUserName}.imports =
    inputs.self.moduleTree.home-manager.profiles.snrl
      { };
}
