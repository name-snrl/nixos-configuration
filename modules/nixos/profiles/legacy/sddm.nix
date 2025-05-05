{ lib, pkgs, ... }:
{
  services.displayManager.sddm = {
    theme = "where_is_my_sddm_theme";
    package = lib.mkDefault pkgs.kdePackages.sddm;
  };
  environment.systemPackages =
    let
      bg = "#2e3440";
    in
    [
      # TODO take color from config
      (pkgs.where-is-my-sddm-theme.override {
        variants = [ "qt6" ];
        themeConfig.General = {
          background = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          backgroundFill = bg;
          backgroundMode = "none";
          blurRadius = 0;
        };
      })
    ];
}
