{
  description = "My NixOS configurations";

  inputs = {
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nvim-nightly.inputs.nixpkgs.follows = "nixpkgs";

    dots.flake = false;
    nvim.flake = false;
    graphite-gtk.flake = false;
    graphite-kde.flake = false;
    flake-registry.flake = false;
    interception-vimproved.flake = false;

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    shlyupa.url = "github:ilya-fedin/nur-repository";

    dots.url = "github:name-snrl/home";
    home-manager.url = "github:nix-community/home-manager/master";

    nvim.url = "github:name-snrl/nvim";
    nvim-nightly.url = "github:neovim/neovim?dir=contrib";

    graphite-gtk.url = "github:vinceliuice/graphite-gtk-theme";
    graphite-kde.url = "github:vinceliuice/graphite-kde-theme";

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

      templates.default = { path = ./templates/shell; description = "A minimal flake with a devShell."; };
    };
}
