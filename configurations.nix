{
  lib,
  inputs,
  getSystem,
  ...
}:
let
  inherit (lib.fileset)
    unions
    intersection
    fileFilter
    toList
    ;
  listNixFiles = u: toList (intersection (fileFilter (f: f.hasExt "nix") ./.) u);
in
{
  flake.homeConfigurations = {
    "yusup@yusupDev" = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = (getSystem "x86_64-linux").legacyPackages;
      extraSpecialArgs = { inherit inputs; };
      modules = [
        { home.username = "yusup"; }
      ]
      ++ listNixFiles (unions [
        home-manager/configurations/basic
        home-manager/common
        home-manager/snrl/git.nix
      ])
      ++ inputs.self.moduleTree.common-profiles { };
    };
  };
}
