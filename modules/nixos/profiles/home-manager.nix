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
          configurations = false;
          profiles = {
            gf = false;
            snrl = false;
          };
        };
      };
    users = {
      root = { };
      default.imports = importsFromAttrs {
        modules = inputs.self.moduleTree.home-manager.profiles.snrl;
      };
    };
  };
}
