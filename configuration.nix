{ config, lib, pkgs, inputs, ... }:

with lib;

{
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    supportedFilesystems = [ "ntfs" ];
  };

  # Firmware
  hardware.enableRedistributableFirmware = true;

  # RAM
  zramSwap.enable = true;

  # Storage
  services.fstrim.enable = true;
  boot.tmpOnTmpfs = true;

  # Networking
  networking = {
    #firewall.enable = false;
    hostName = "nixos";
    wireless.iwd.enable = true;
  };

  # GPS
  #services.gpsd.enable = true;
  #services.gpsd.device = "/dev/ttyACM0";
  #services.geoclue2.enable = true;
  location.provider = "geoclue2";

  programs.light.enable = true;
  users.users.default.extraGroups = [ "adbusers" "video" ];

  hardware.trackpoint = {
    enable = true;
    sensitivity = 130;
    speed = 180;
  };

  #---------------------------- ENVIRONMENT N SOFT ----------------------------#


  # work stuff
  security.pki.certificateFiles = [ inputs.CA ];
  programs.openvpn3.enable = true;

  environment = {
    pathsToLink = [ "/share" ];
    sessionVariables = {
      # XDG base dir
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";

      # set gsettings schemas
      XDG_DATA_DIRS = [ (pkgs.glib.getSchemaDataDirPath pkgs.gsettings-desktop-schemas) ];

      # misc
      TERMINAL = "alacritty";
      MENU = "wofi -d";
      EDITOR = "nvim";
      BROWSER = "nvim";
      QT_QPA_PLATFORMTHEME = "qt5ct"; # TODO create an issue
    };
  };

  qt.enable = true;
  qt.platformTheme = "qt5ct";

  services.dbus.implementation = "broker";

  documentation.man.generateCaches = true;

  programs = {
    nano.syntaxHighlight = false;
    less.enable = mkForce false;

    adb.enable = true;

    htop = {
      enable = true;
      settings = {
        column_meters_0 = "System DateTime Uptime LoadAverage Tasks Blank Swap Memory";
        column_meter_modes_0 = "2 2 2 2 2 2 2 2";
        column_meters_1 = "AllCPUs DiskIO NetworkIO Blank Blank";
        column_meter_modes_1 = "1 1 1 2 2";

        fields = "4 0 48 17 18 46 39 2 49 1";
        tree_view = 1;
        tree_sort_key = 39;
        tree_sort_direction = -1;
        hide_kernel_threads = 1;
        hide_userland_threads = 1;
        show_program_path = 0;
        highlight_base_name = 1;
        show_cpu_frequency = 1;
        cpu_count_from_one = 1;
        color_scheme = 6;

        "screen:Mem" = ''
          PGRP PID USER M_VIRT M_SHARE M_RESIDENT M_SWAP Command
          .sort_key=M_RESIDENT
          .tree_sort_key=M_RESIDENT
          .tree_view=1
          .sort_direction=-1
          .tree_sort_direction=-1
        '';
      };
    };
  };

  environment.defaultPackages = with pkgs; [ rsync perl ];
  environment.systemPackages = with pkgs; [
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
}
