{ pkgs, ... }:
{
  services.xserver = {
    enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "where_is_my_sddm_theme";
    };
  };
  environment.systemPackages =
    let
      bg = "#2e3440";
    in
    [
      # TODO take color from config
      (pkgs.where-is-my-sddm-theme.override {
        themeConfig.General = {
          background = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          backgroundFill = bg;
          backgroundMode = "none";
        };
      })
    ];
}
