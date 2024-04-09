{
  description = "My NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    shlyupa.url = "github:ilya-fedin/nur-repository";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    dots = {
      url = "github:name-snrl/home";
      flake = false;
    };
    nvim = {
      url = "github:name-snrl/nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim-nightly = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    graphite-gtk = {
      url = "github:vinceliuice/graphite-gtk-theme";
      flake = false;
    };
    graphite-kde = {
      flake = false;
      url = "github:vinceliuice/graphite-kde-theme";
    };

    nix-index-db = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    nixos-ez-flake = {
      url = "github:name-snrl/nixos-ez-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks-nix = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixos-ez-flake, flake-parts, ... }:
    (flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./hosts
        ./overlays
        ./pkgs
        ./shell.nix
        ./templates
      ];
    })
    // {
      # Filesystem-based attribute set of module paths
      nixosModules = nixos-ez-flake.mkModuleTree ./modules;
    };
}
