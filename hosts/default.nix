{ lib, inputs, ... }:
{
  flake = {
    nixosConfigurations = inputs.nixos-ez-flake.mkHosts {
      inherit inputs;
      entryPoint = ./.;
    };
    packages =
      let
        cfgs = inputs.self.nixosConfigurations;
      in
      with lib;
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
