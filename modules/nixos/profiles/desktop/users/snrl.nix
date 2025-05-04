{ inputs, defaultUserName, ... }:
{
  home-manager.users.${defaultUserName}.imports =
    inputs.self.moduleTree.home-manager.profiles.snrl
      { };
}
