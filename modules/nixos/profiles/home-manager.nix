{ inputs, defaultUserName, ... }:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
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
      ${defaultUserName} = { };
    };
  };
}
