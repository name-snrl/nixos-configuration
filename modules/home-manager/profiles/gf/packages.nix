{ pkgs, ... }:
{
  home.packages = with pkgs; [
    telegram-desktop
    #discord
    zoom-us
    whatsapp-for-linux
  ];
}
