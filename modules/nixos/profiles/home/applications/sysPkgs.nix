{ pkgs, ... }:
{
  environment = with pkgs; {
    defaultPackages = [
      pciutils
      usbutils
    ];
    systemPackages = [
      # cli
      ffmpeg
      rsync

      # GUI
      kotatogram-desktop-with-webkit
      qbittorrent
      anki

      # DE
      mpv
      swayimg
      sioyek
      pcmanfm-qt
      lxqt.pavucontrol-qt

      # themes
      graphite-kde-theme
      graphite-gtk-theme
      (papirus-icon-theme.override { color = "bluegrey"; })
      numix-cursor-theme
    ];
  };
}
