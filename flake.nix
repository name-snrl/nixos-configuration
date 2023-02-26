{
  description = "My NixOS configurations";

  inputs = {
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    terranix.inputs.nixpkgs.follows = "nixpkgs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
    nvimpager.inputs.nixpkgs.follows = "nixpkgs";
    nvim-nightly.inputs.nixpkgs.follows = "nixpkgs";

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

  outputs = inputs: with inputs.self.lib;
    rec {
      lib = import ./lib.nix inputs;

      nixosModules = mkModules ./modules;

      nixosConfigurations = mkHosts ./hosts;

      legacyPackages = forAllSystems pkgsFor;

      overlay = import ./overlay inputs;

      packages = hostsAsPkgs nixosConfigurations;

      formatter = forAllSystems (system: legacyPackages.${system}.nixpkgs-fmt);
    };
}
