{ pkgs, ... }:
{
  programs.firefox = {
    nativeMessagingHosts = [ pkgs.kdePackages.plasma-browser-integration ];
    policies.ExtensionSettings."plasma-browser-integration@kde.org" = {
      default_area = "menupanel";
      installation_mode = "normal_installed";
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/plasma-browser-integration@kde.org/latest.xpi";
    };
  };
  home.packages = [ pkgs.kdePackages.plasma-browser-integration ];
}
