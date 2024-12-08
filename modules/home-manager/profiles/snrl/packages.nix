{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kotatogram-desktop
    qbittorrent
    anki
    ffmpeg

    swayimg # TODO remove after migraion to KDE?
    pcmanfm-qt # TODO remove after migraion to KDE
    lxqt.pavucontrol-qt # TODO remove after migraion to KDE?

    # themes
    graphite-kde-theme
    graphite-gtk-theme
    (papirus-icon-theme.override { color = "bluegrey"; })
    numix-cursor-theme
  ];
}
