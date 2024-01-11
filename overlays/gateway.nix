/*
 * Overlay for pkgs from inputs that do not provide overlays.
 */
inputs: final: prev: {

  inherit (inputs.shlyupa.packages.${final.system})
    kotatogram-desktop-with-webkit
    ;

  inherit (inputs.nix-index-db.packages.${final.system})
    nix-index-with-db
    ;

}
