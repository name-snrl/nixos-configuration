{ pkgs, ... }: {
  environment = with pkgs; {
    defaultPackages = [ rsync perl ];
    systemPackages = [
      # system shit
      pciutils
      usbutils
      inetutils
      tcpdump # tcpdump -i wireCat port 67 or port 68 -n -vv

      # base
      nvim-full
      page
      difftastic
      gojq-as-jq
      ripgrep
      fd
      eza
      bat
      file
      tree
      wget
      scripts.sf

      # cli
      et
      fzf # for zoxide/fzf-bash-complete
      ffmpeg
      syncplay-nogui
      zoxide
      tokei
      tealdeer
      pandoc
      scripts.dict
      librespeed-cli

      # GUI
      kotatogram-desktop-with-webkit
      qbittorrent
      anki

      # DE
      firefox-wayland
      alacritty-as-xterm # https://gitlab.gnome.org/GNOME/glib/-/issues/338
      alacritty
      mpv
      swayimg
      sioyek
      lxqt.pavucontrol-qt

      # themes
      graphite-kde-theme
      graphite-gtk-theme
      (papirus-icon-theme.override { color = "bluegrey"; })
      numix-cursor-theme
      libsForQt5.qtstyleplugin-kvantum
      qt6Packages.qtstyleplugin-kvantum
    ];
  };
}
