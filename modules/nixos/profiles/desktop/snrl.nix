{ inputs, importsFromAttrs, ... }:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager.users.default.imports = importsFromAttrs {
    modules = inputs.self.moduleTree.home-manager.profiles.snrl;
  };
}
