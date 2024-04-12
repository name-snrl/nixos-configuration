{ pkgs, ... }:
{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    wayland.compositor = "kwin";
    theme = "where_is_my_sddm_theme_qt5";
  };
  environment.systemPackages =
    let
      bg = "#2e3440";
    in
    [
      # TODO take color from config
      (pkgs.where-is-my-sddm-theme.override {
        variants = [ "qt5" ];
        themeConfig.General = {
          background = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          backgroundFill = bg;
          backgroundMode = "none";
          blurRadius = 0;
        };
      })
    ];
}
