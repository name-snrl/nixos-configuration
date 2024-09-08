{ lib, inputs, ... }:
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
}
