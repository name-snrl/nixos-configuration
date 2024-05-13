{ lib, inputs, ... }:
{
  flake = rec {

    nixosConfigurations = inputs.nixos-ez-flake.mkConfigurations {
      inherit inputs;
      inherit (inputs.self.moduleTree.nixos) configurations;
    };

    packages =
      with lib;
      foldAttrs (x: y: x // y) { } (
        concatLists (
          forEach (attrNames nixosConfigurations) (
            name:
            with nixosConfigurations.${name};
            if name == "liveCD" then
              [ { ${pkgs.system}.${name} = config.system.build.isoImage; } ]
            else
              [ { ${pkgs.system}.${name} = config.system.build.toplevel; } ]
          )
        )
      );

    homeConfigurations."yusup@yusup" =
      with inputs;
      home-manager.lib.homeManagerConfiguration {
        pkgs = self.legacyPackages.x86_64-linux;
        modules =
          [
            {
              home.username = "yusup";
              home.homeDirectory = "/home/yusup";
              home.stateVersion = "23.11";
            }
          ]
          ++ nixos-ez-flake.importsFromAttrs {
            importByDefault = true;
            modules = inputs.self.moduleTree.home-manager;
            imports = {
              profiles.gf = false;
            };
          };
      };
  };
}
