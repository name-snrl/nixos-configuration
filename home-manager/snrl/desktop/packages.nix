{ pkgs, ... }:
{
  home.packages = with pkgs; [
    anki
    kotatogram-desktop
    qbittorrent
    remmina

    ffmpeg
  ];
}
