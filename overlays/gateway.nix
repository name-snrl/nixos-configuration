/**
  Overlay for pkgs from inputs that do not provide overlays.
*/
inputs: final: _prev: {

  inherit (inputs.nix-index-db.packages.${final.system}) nix-index-with-db;

  inherit (inputs.home-manager.packages.${final.system}) home-manager;
}
