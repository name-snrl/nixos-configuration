{
  description = "My NixOS configurations";

  inputs = {
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    terranix.inputs.nixpkgs.follows = "nixpkgs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
    #nvimpager.inputs.nixpkgs.follows = "nixpkgs";
    nvim-nightly.inputs.nixpkgs.follows = "nvimpager/nixpkgs";

    dots.flake = false;
    nvim.flake = false;
    hw-config.flake = false;
    CA.flake = false;
    flake-registry.flake = false;
    interception-vimproved.flake = false;

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    shlyupa.url = "github:ilya-fedin/nur-repository";

    dots.url = "github:name-snrl/home";
    home-manager.url = "github:nix-community/home-manager/master";

    terranix.url = "github:terranix/terranix";
    deploy-rs.url = "github:serokell/deploy-rs";

    nvim.url = "github:name-snrl/nvim";
    nvim-nightly.url = "github:neovim/neovim?dir=contrib";
    nvimpager.url = "github:lucc/nvimpager";

    CA.url = "file:///home/name_snrl/nixos-configuration/tawasalca.crt";
    hw-config.url = "file:///etc/nixos/hardware-configuration.nix";
    flake-registry.url = "github:nixos/flake-registry";
    interception-vimproved.url = "github:name-snrl/interception-vimproved";
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
      nixosProfiles = builtins.listToAttrs (findModules ./profiles);

      legacyPackages.x86_64-linux = pkgsFor "x86_64-linux";

      overlay = import ./overlay inputs;

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        pkgs = pkgsFor system;
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          (import inputs.hw-config)

          self.nixosProfiles.keyboard
          self.nixosProfiles.sway
          self.nixosProfiles.gdm
          self.nixosProfiles.fish
          self.nixosProfiles.git
          self.nixosProfiles.starship

          inputs.shlyupa.nixosModules.metric-compatible-fonts
        ];
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    };
}
