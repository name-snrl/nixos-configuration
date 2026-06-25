{
  lib,
  inputs,
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
  };
}
