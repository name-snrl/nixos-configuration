{
  description = "My NixOS configurations";

  inputs = {
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nvim-nightly.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-db.inputs.nixpkgs.follows = "nixpkgs";

    dots.flake = false;
    graphite-gtk.flake = false;
    graphite-kde.flake = false;
    flake-registry.flake = false;

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    shlyupa.url = "github:ilya-fedin/nur-repository";
    home-manager.url = "github:nix-community/home-manager/master";

    dots.url = "github:name-snrl/home";
    nvim.url = "github:name-snrl/nvim";
    nvim-nightly.url = "github:neovim/neovim?dir=contrib";

    graphite-gtk.url = "github:vinceliuice/graphite-gtk-theme";
    graphite-kde.url = "github:vinceliuice/graphite-kde-theme";

    flake-registry.url = "github:nixos/flake-registry";
    nix-index-db.url = "github:nix-community/nix-index-database";
  };

  outputs = inputs: with inputs.self.lib;
    rec {
      lib = import ./lib.nix inputs.nixpkgs.lib;

      nixosModules = mkModules ./modules;

      nixosConfigurations = mkHosts ./hosts inputs;

      legacyPackages = forAllSystems (mkPkgs inputs.nixpkgs overlays.default);

      overlays = mkOverlays ./overlays inputs;

      packages = hostsAsPkgs nixosConfigurations;

      formatter = forAllSystems (system: legacyPackages.${system}.nixpkgs-fmt);

      templates.default = { path = ./templates/shell; description = "A minimal flake with a devShell."; };
    };
}
