{ pkgs, ... }:
{
  environment = with pkgs; {
    defaultPackages = [
      rsync
      perl
    ];
    systemPackages = [
      # system shit
      pciutils
      usbutils
      inetutils
      tcpdump # tcpdump -i wireCat port 67 or port 68 -n -vv

      # cli
      ffmpeg

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
