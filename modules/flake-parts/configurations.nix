{
  lib,
  inputs,
  # deadnix: skip
  __findFile,
  ...
}:
{
  flake = rec {
    nixosConfigurations = inputs.nixos-ez-flake.mkHosts {
      inherit inputs;
      entryPoint = <hosts>;
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
