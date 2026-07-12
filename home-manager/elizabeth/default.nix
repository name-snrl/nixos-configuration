{ pkgs, ... }:
{
  xdg.enable = true;
  programs = {
    firefox = {
      enable = true;
      policies.ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          default_area = "navbar";
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/uBlock0@raymondhill.net/latest.xpi";
        };
      };
    };
  };
  home.packages = with pkgs; [
    haruna
    kdePackages.elisa

    telegram-desktop
    #discord
    zoom-us
  ];
}
