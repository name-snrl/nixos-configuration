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

  hardware.trackpoint = {
    enable = true;
    sensitivity = 130;
    speed = 180;
  };

  #---------------------------- ENVIRONMENT N SOFT ----------------------------#

  i18n = {
    defaultLocale = "en_GB.UTF-8";
    inputMethod.enabled = "fcitx5";
    inputMethod.fcitx5.addons = [ pkgs.fcitx5-mozc ];
  };

  time = {
    timeZone = "Asia/Almaty";
    hardwareClockInLocalTime = true;
  };

  users = {
    mutableUsers = false;
    users = {
      root.hashedPassword =
        "$6$68YTRwVh7sUS1onf$VwXU4CSQ9/RbbERzYV8TNtfNM8eraZarUZ4oyxXhXHu1j/4ItbSAhuUkkzfc7FF0XKChZnn.hPisvojMSUfM81";
      default = {
        name = "name_snrl";
        hashedPassword =
          "$6$6US0iMDXE1K7wj9g$2/JKHfX4VfNETELdt4dTlTUzlmZAmvP4XfRNB5ORVPYNmi6.A4EWpSXkpx/5PrPx1J/LaA41n2NDss/R0Utqh/";
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "video"
          "adbusers"
        ];
      };
    };
  };

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
      GTK_USE_PORTAL = "1";
      QT_QPA_PLATFORMTHEME = "qt5ct"; # TODO create an issue
    };

    # fix conflict between https://github.com/NixOS/nixpkgs/blob/5ed481943351e9fd354aeb557679624224de38d5/nixos/modules/programs/environment.nix#L25
    # and https://github.com/NixOS/nixpkgs/blob/5ed481943351e9fd354aeb557679624224de38d5/nixos/modules/config/shells-environment.nix#L172
    sessionVariables.XDG_CONFIG_DIRS = [ "/etc/xdg" ];
    variables.XDG_CONFIG_DIRS =
      mkForce config.environment.sessionVariables.XDG_CONFIG_DIRS;

    # fcitx5
    # fix candidate box in firefox
    sessionVariables.NIX_PROFILES =
      concatStringsSep " " (reverseList config.environment.profiles);
    # TODO make pr and change variable to sessionVariable
    # https://github.com/NixOS/nixpkgs/blob/5ed481943351e9fd354aeb557679624224de38d5/nixos/modules/i18n/input-method/fcitx5.nix#L30
    sessionVariables.GTK_IM_MODULE = "fcitx";
    sessionVariables.QT_IM_MODULE = "fcitx";
    sessionVariables.XMODIFIERS = "@im=fcitx";
    sessionVariables.QT_PLUGIN_PATH =
      [ "${config.i18n.inputMethod.package}/${pkgs.qt6.qtbase.qtPluginPrefix}" ];
    variables.QT_PLUGIN_PATH =
      mkForce config.environment.sessionVariables.QT_PLUGIN_PATH;
  };

  fonts = {
    enableDefaultFonts = false;
    fonts = with pkgs; [
      exo2
      jetbrains-mono
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      unifont
      symbola
      joypixels
      nerd-fonts-symbols
    ];
    fontconfig.crOSMaps = true;
    fontconfig.defaultFonts = {
      monospace = [
        "JetBrains Mono NL Light"
        "Noto Sans Mono CJK JP"
        "Symbols Nerd Font"
      ];
      sansSerif = [
        "Exo 2"
        "Noto Sans CJK JP"
        "Symbols Nerd Font"
      ];
      serif = [
        "Tinos"
        "Noto Serif CJK JP"
        "Symbols Nerd Font"
      ];
      emoji = [ "JoyPixels" ];
    };
  };

  qt.enable = true;
  qt.platformTheme = "qt5ct";

  xdg.portal = {
    enable = true;
    # gtkUsePortal = true; # check sessionVariables above
    wlr = {
      enable = true;
      settings.screencast = {
        output_name = "eDP-1";
        max_fps = 60;
        chooser_type = "none";
      };
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-kde
    ];
  };

  services = {
    udisks2.enable = true;
    dbus.implementation = "broker";

    dictd.enable = true;
    dictd.DBs = with pkgs.dictdDBs; [ wiktionary ];
  };

  documentation.man.generateCaches = true;

  xdg.mime.defaultApplications = {
    "application/pdf" = "sioyek.desktop";
    "image/jpeg" = "imv.desktop";
    "image/png" = "imv.desktop";
  };

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
