{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kotatogram-desktop
    qbittorrent
    anki
    ffmpeg
  ];
}
