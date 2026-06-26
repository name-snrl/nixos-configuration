{
  lib,
  inputs,
  getSystem,
  ...
}:
let
  inherit (lib.fileset)
    unions
    union
    intersection
    fileFilter
    toList
    ;
  drop = lib.flip lib.fileset.difference;
  listNixFiles = u: toList (intersection (fileFilter (f: f.hasExt "nix") ./.) u);
  nixosCommon = [
    inputs.home-manager.nixosModules.home-manager
    inputs.disko.nixosModules.default
    inputs.impermanence.nixosModules.default
  ];
in
{
  flake = {
    nixosConfigurations = {
      lemp13 = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          { home-manager.sharedModules = listNixFiles home-manager/common; }
        ]
        ++ nixosCommon
        ++ lib.pipe ./nixos [
          (drop nixos/configurations)
          (drop nixos/desktop/work.nix)
          (drop nixos/servers)
          (union nixos/configurations/lemp13)
          (union ./common)
          listNixFiles
        ];
      };

      t440s = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          { home-manager.sharedModules = listNixFiles home-manager/common; }
        ]
        ++ nixosCommon
        ++ lib.pipe ./nixos [
          (drop nixos/configurations)
          (drop nixos/zfs.nix)
          (drop nixos/impermanence.nix)
          (drop nixos/desktop)
          (union nixos/configurations/t440s)
          (union ./common)
          listNixFiles
        ];
      };
    };

    homeConfigurations = {
      "yusup@yusupDev" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = (getSystem "x86_64-linux").legacyPackages;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          { home.username = "yusup"; }
        ]
        ++ listNixFiles (unions [
          home-manager/configurations/basic
          home-manager/common
          home-manager/snrl/git.nix
          ./common
        ]);
      };
    };
  };

}
