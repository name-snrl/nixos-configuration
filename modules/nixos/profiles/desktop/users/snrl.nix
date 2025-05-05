{ inputs, vars, ... }:
{
  home-manager.users.${vars.users.master.name}.imports =
    inputs.self.moduleTree.home-manager.profiles.snrl
      { };
}
