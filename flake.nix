{
  description = "My NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-22.05";
    shlyupa.url = "github:ilya-fedin/nur-repository";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nvimpager.url = "github:lucc/nvimpager";
    nvim-nightly.url = "github:nix-community/neovim-nightly-overlay";

    nvim = {
      url = "github:name-snrl/nvim";
      flake = false;
    };
    dots = {
      url = "github:name-snrl/home";
      flake = false;
    };
    hw-config = {
      url = "file:///etc/nixos/hardware-configuration.nix";
      flake = false;
    };
    CA = {
      url = "file:///home/name_snrl/nixos-configuration/tawasalca.crt";
      flake = false;
    };
    flake-registry = {
      url = "github:nixos/flake-registry";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, ... }:
    let
      findModules = dir:
        builtins.concatLists (builtins.attrValues (builtins.mapAttrs
          (name: type:
            if type == "regular" then [{
              name = builtins.elemAt (builtins.match "(.*)\\.nix" name) 0;
              value = dir + "/${name}";
            }] else if (builtins.readDir (dir + "/${name}"))
              ? "default.nix" then [{
              inherit name;
              value = dir + "/${name}";
            }] else
              findModules (dir + "/${name}"))
          (builtins.readDir dir)));

      pkgsFor = system:
        import inputs.nixpkgs {
          overlays = [ self.overlay ];
          localSystem = { inherit system; };
          config = {
            allowUnfree = true;
            joypixels.acceptLicense = true;
          };
        };
    in
    {
      nixosModules = builtins.listToAttrs (findModules ./modules);

      nixosProfiles = builtins.listToAttrs (findModules ./profiles);

      legacyPackages.x86_64-linux = pkgsFor "x86_64-linux";

      overlay = import ./overlay.nix inputs;

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        pkgs = pkgsFor system;
        specialArgs.inputs = inputs;
        modules = [
          ./configuration.nix
          (import inputs.hw-config)

          self.nixosModules.global_variables

          self.nixosProfiles.keyboard
          self.nixosProfiles.sway
          self.nixosProfiles.gdm
          self.nixosProfiles.fish
          self.nixosProfiles.git
          self.nixosProfiles.starship

          inputs.shlyupa.nixosModules.metric-compatible-fonts
          inputs.shlyupa.nixosModules.dbus-broker
        ];
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    };
}
