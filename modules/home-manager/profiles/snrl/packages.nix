{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kotatogram-desktop-with-webkit
    qbittorrent
    anki
    ffmpeg
    mpv

    swayimg # remove after migraion to KDE?
    sioyek # remove after migraion to KDE?
    pcmanfm-qt # remove after migraion to KDE
    lxqt.pavucontrol-qt # remove after migraion to KDE?

    # themes
    graphite-kde-theme
    graphite-gtk-theme
    (papirus-icon-theme.override { color = "bluegrey"; })
    numix-cursor-theme
  ];
}
