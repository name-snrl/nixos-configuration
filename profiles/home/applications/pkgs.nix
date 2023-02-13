{ pkgs, ... }: {
  environment = with pkgs; {
    defaultPackages = [ rsync perl ];
    systemPackages = [
      # system shit
      pciutils
      usbutils
      inetutils

      # base
      nvim.full
      nvimpager
      difftastic
      gojq-as-jq
      ripgrep
      fd
      exa
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
      scripts.beep
      librespeed-cli

      # GUI
      kotatogram-desktop-with-webkit
      qbittorrent
      anki-bin
      virt-manager

      # DE
      firefox-wayland
      alacritty-as-xterm # https://gitlab.gnome.org/GNOME/glib/-/issues/338
      alacritty
      mpv
      imv
      sioyek
      pcmanfm-qt
      lxqt.pavucontrol-qt

      # themes
      graphite-kde-theme
      graphite-gtk-theme
      papirus-icon-theme
      numix-cursor-theme
      libsForQt5.qtstyleplugin-kvantum
    ];
  };
}
