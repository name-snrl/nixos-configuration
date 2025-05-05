{ inputs, vars, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs vars;
    };
    sharedModules =
      [ { home.stateVersion = "23.11"; } ]
      ++ inputs.self.moduleTree.home-manager {
        configurations = false;
        profiles = {
          gf = false;
          snrl = false;
        };
      };
    users = {
      root = { };
      ${vars.users.master.name} = { };
    };
  };
}
