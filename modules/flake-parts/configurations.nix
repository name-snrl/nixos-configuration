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
  };
}
