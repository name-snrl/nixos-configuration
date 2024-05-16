{
  lib,
  inputs,
  flake-url,
  ...
}:
{
  systems = lib.systems.flakeExposed;
  perSystem =
    { pkgs, system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = lib.singleton inputs.self.overlays.default;
        config.allowUnfree = true;
      };

      legacyPackages = pkgs // {
        homeConfigurations = with inputs; {
          yusup = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules =
              [
                {
                  home.username = "yusup";
                  home.homeDirectory = "/home/yusup";
                  home.stateVersion = "23.11";
                  home.shellAliases.hmupgrade = "nix run ${flake-url}#home-manager -- switch --flake ${flake-url}";
                }
              ]
              ++ nixos-ez-flake.importsFromAttrs {
                importByDefault = true;
                modules = self.moduleTree.home-manager;
                imports = {
                  profiles.gf = false;
                };
              };
          };
        };
      };
    };
}
