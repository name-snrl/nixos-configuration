{
  description = "My NixOS configurations";

  outputs =
    inputs@{ nixos-ez-flake, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } rec {
      flake.moduleTree = nixos-ez-flake.mkModuleTree ./modules;
      imports = nixos-ez-flake.importsFromAttrs { modules = flake.moduleTree.flake-parts; };
      _module.args = {
        __findFile = _: s: ./${s};
        flake-url = "github:name-snrl/nixos-configuration";
      };
    };

  inputs = {
    # single lines
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    shlyupa.url = "github:ilya-fedin/nur-repository";
    nixos-ez-flake.url = "github:name-snrl/nixos-ez-flake";

    dots = {
      url = "github:name-snrl/home";
      flake = false;
    };

    # packages
    nvim = {
      url = "github:name-snrl/nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zellij = {
      flake = false;
      url = "github:zellij-org/zellij";
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

    # nixos modules
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # flake modules
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
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
}
