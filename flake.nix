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
    CA.flake = false;
    ssh-keys.flake = false;
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
    ssh-keys.url = "https://github.com/name-snrl.keys";
    flake-registry.url = "github:nixos/flake-registry";
    interception-vimproved.url = "github:name-snrl/interception-vimproved";
  };

  outputs = inputs@{ self, nixpkgs, ... }:
    let
      system = "x86_64-linux";

      pkgs = import inputs.nixpkgs {
        overlays = [ self.overlay ];
        localSystem = { inherit system; };
        config = {
          allowUnfree = true;
          joypixels.acceptLicense = true;
        };
      };

      findModules = with builtins;
        dir: concatLists (attrValues
          (mapAttrs
            (name: type:
              if type == "regular"
              then [{
                name = elemAt (match "(.*)\\.nix" name) 0;
                value = dir + "/${name}";
              }]
              else if (readDir (dir + "/${name}")) ? "default.nix"
              then [{
                inherit name;
                value = dir + "/${name}";
              }]
              else findModules (dir + "/${name}"))
            (readDir dir)));
    in
    {
      nixosProfiles = builtins.listToAttrs (findModules ./profiles);

      nixosRoles = import ./roles;

      nixosConfigurations = nixpkgs.lib.genAttrs
        (builtins.attrNames (builtins.readDir ./hosts))
        (name:
          nixpkgs.lib.nixosSystem {
            inherit system pkgs;
            specialArgs = { inherit inputs; };
            modules = [ ./hosts/${name} { networking.hostName = name; } ];
          });

      legacyPackages.${system} = pkgs;

      overlay = import ./overlay inputs;

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;
    };
}
