{ pkgs, ... }:
{
  home.packages = with pkgs; [
    telegram-desktop
    discord
    skypeforlinux
    zoom-us
    whatsapp-for-linux
    onlyoffice-bin_latest
  ];
}
