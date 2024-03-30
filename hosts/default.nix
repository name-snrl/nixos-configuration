{ lib, inputs, ... }:
with inputs;
{
  flake = {
    nixosConfigurations = nixos-ez-flake.mkHosts {
      inherit inputs;
      entryPoint = ./.;
    };
    packages =
      with lib;
      let
        cfgs = inputs.self.nixosConfigurations;
      in
      foldAttrs (x: y: x // y) { } (
        concatLists (
          forEach (attrNames cfgs) (
            name:
            with cfgs.${name};
            if name == "liveCD" then
              [ { ${pkgs.system}.${name} = config.system.build.isoImage; } ]
            else
              [ { ${pkgs.system}.${name} = config.system.build.toplevel; } ]
          )
        )
      );
  };
}
