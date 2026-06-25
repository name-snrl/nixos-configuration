{
  lib,
  inputs,
  config,
  ...
}:
{
  flake = {
    nixosConfigurations = lib.mapAttrs (
      hostName: cfgModules:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          { networking = { inherit hostName; }; }

          inputs.home-manager.nixosModules.home-manager
          inputs.disko.nixosModules.default
          inputs.impermanence.nixosModules.default
        ]
        ++ inputs.self.moduleTree.common-profiles { }
        ++ cfgModules { };
      }
    ) (lib.removeAttrs inputs.self.moduleTree.nixos.configurations [ "__functor" ]);

    packages = lib.foldl (
      acc: nixos:
      let
        inherit (nixos.config.nixpkgs.hostPlatform) system;
        inherit (nixos.config.networking) hostName;
        inherit (nixos.config.system.build) toplevel;
      in
      acc // { ${system} = lib.mergeAttrs acc.${system} or { } { ${hostName} = toplevel; }; }
    ) { } (lib.attrValues config.flake.nixosConfigurations);
  };
}
