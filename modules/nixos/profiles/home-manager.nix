{ inputs, importsFromAttrs, ... }:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    sharedModules =
      [ { home.stateVersion = "23.11"; } ]
      ++ importsFromAttrs {
        importByDefault = true;
        modules = inputs.self.moduleTree.home-manager;
        imports = {
          profiles.gf = false;
        };
      };
    users = {
      root = { };
      default = { };
    };
  };
}
