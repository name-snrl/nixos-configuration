# Overlay for pkgs from inputs that do not provide overlays.
inputs: final: _prev: {

  inherit (inputs.nix-index-db.packages.${final.stdenv.hostPlatform.system}) nix-index-with-db;

  inherit (inputs.home-manager.packages.${final.stdenv.hostPlatform.system}) home-manager;
}
