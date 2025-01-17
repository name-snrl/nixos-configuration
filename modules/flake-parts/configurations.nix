{
  lib,
  inputs,
  flake-url,
  ...
}:
{
  flake = rec {

    nixosConfigurations = lib.mapAttrs (
      hostName: cfgModules:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          {
            networking = {
              inherit hostName;
            };
          }
          inputs.disko.nixosModules.default
          inputs.chaotic.nixosModules.default
          inputs.impermanence.nixosModules.default
        ] ++ cfgModules { };
      }
    ) (lib.removeAttrs inputs.self.moduleTree.nixos.configurations [ "__functor" ]);

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
  };

  perSystem =
    { pkgs, ... }:
    {
      legacyPackages.homeConfigurations = lib.mapAttrs (
        username: cfgModules:
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs flake-url;
          };
          modules = [
            {
              home = {
                inherit username;
              };
            }
          ] ++ cfgModules { };
        }
      ) (lib.removeAttrs inputs.self.moduleTree.home-manager.configurations [ "__functor" ]);
    };
}
