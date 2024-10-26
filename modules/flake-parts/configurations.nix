{
  lib,
  inputs,
  flake-url,
  ...
}:
{
  flake = rec {

    nixosConfigurations = lib.mapAttrs (
      hostName: modules:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit (inputs.nixos-ez-flake) importsFromAttrs;
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
        ] ++ inputs.nixos-ez-flake.importsFromAttrs { inherit modules; };
      }
    ) inputs.self.moduleTree.nixos.configurations;

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
        username: modules:
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs flake-url;
            inherit (inputs.nixos-ez-flake) importsFromAttrs;
          };
          modules = [
            {
              home = {
                inherit username;
              };
            }
          ] ++ inputs.nixos-ez-flake.importsFromAttrs { inherit modules; };
        }
      ) inputs.self.moduleTree.home-manager.configurations;
    };
}
