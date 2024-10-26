{
  inputs,
  defaultUserName,
  importsFromAttrs,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager.users.${defaultUserName}.imports = importsFromAttrs {
    modules = inputs.self.moduleTree.home-manager.profiles.snrl;
  };
}
