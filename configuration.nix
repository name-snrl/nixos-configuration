{ config, lib, pkgs, inputs, ... }:

with lib;

{
  nix = {
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

    registry = {
      self.flake = inputs.self;
      np.flake = inputs.nixpkgs;
    };

    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" config.userName ];
      substituters = [
        "https://nix-community.cachix.org"
        "https://ilya-fedin.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "ilya-fedin.cachix.org-1:QveU24a5ePPMh82mAFSxLk1P+w97pRxqe9rh+MJqlag="
      ];
    };

    extraOptions = ''
      builders-use-substitutes = true
      # Prevent Nix from fetching the registry every time
      flake-registry = ${inputs.flake-registry}/flake-registry.json
    '';
  };

  system.stateVersion = "22.05";

  #--------------------------- HARDWARE AND SYSTEM ----------------------------#

  boot = {
    loader = {
      efi.canTouchEfiVariables = false;
      timeout = 3;
      systemd-boot = {
        enable = true;
        memtest86.enable = true;
        configurationLimit = 20;
        consoleMode = "max";
      };
    };

    kernelPackages = pkgs.linuxPackages_zen;
    initrd.kernelModules = [ "i915" ];
    supportedFilesystems = [ "ntfs" ];
    kernelModules = [ "acpi_call" ];
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
  };

  services.fstrim.enable = true;
  services.fwupd.enable = true;
  hardware.enableRedistributableFirmware = true;
  powerManagement.cpuFreqGovernor = mkDefault "schedutil";

  # Networking
  networking = {
    #firewall.enable = false;
    hostName = "nixos";
    wireless.iwd.enable = true;
  };

  services.tor = {
    enable = true;
    client.enable = true;
    client.dns.enable = true;
    settings = {
      ExitNodes = "{ua}, {nl}, {gb}";
      ExcludeNodes = "{ru},{by},{kz}";
      UseBridges = true;
      ClientTransportPlugin = "obfs4 exec ${pkgs.obfs4}/bin/obfs4proxy";
      Bridge = ''
        obfs4 172.105.244.195:27792 6ED1F2262D274F126498DF043C9BDD2912E7EA78 cert=6etpbIlfQWMuyW8Sef+ufeE0PeF6kvBxOAiKGUsgcPuXkf+npgOQScXZ4LSyps7u8ibLWg iat-mode=0
      '';
    };
  };
  services.privoxy.enable = true;
  services.privoxy.enableTor = true;

  # GPS
  #services.gpsd.enable = true;
  #services.gpsd.device = "/dev/ttyACM0";
  #services.geoclue2.enable = true;
  location.provider = "geoclue2";

  hardware.bluetooth = {
    enable = true;
    #hsphfpd.enable = true;
    settings.General = {
      Experimental = true;
      MultiProfile = "multiple";
      FastConnectable = true;
    };
  };

  security.rtkit.enable = true;
  #security.sudo.extraConfig = ''
  #  # share wl-clipboard
  #  Defaults env_keep += "XDG_RUNTIME_DIR"
  #  Defaults env_keep += "WAYLAND_DISPLAY"
  #'';

  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = false;
    };
    libvirtd = {
      enable = true;
      onBoot = "ignore";
    };
  };

  # GPU acceleration
  hardware.opengl = {
    extraPackages = with pkgs; [
      beignet
      vaapiIntel
      # I want a new laptop
      # intel-media-driver
      #
      # --my-next-gpu-wont-be-nvidia
      # vaapiVdpau
      # libvdpau-va-gl
    ];
  };

  # Enable sound.
  services.pipewire = {
    config.pipewire = {
      "context.properties" = {
        "default.clock.allowed-rates" = [ 44100 48000 96000 ];
      };
    };
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Battery 
  services.upower.enable = true;
  services.tlp = {
    enable = true;
    settings = {

      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 60;

      START_CHARGE_THRESH_BAT1 = 40;
      STOP_CHARGE_THRESH_BAT1 = 55;

    };
  };

  programs.light.enable = true;

  hardware.trackpoint = {
    enable = true;
    sensitivity = 140;
    speed = 130;
  };

  #---------------------------- ENVIRONMENT N SOFT ----------------------------#

  users.users.${config.userName} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "libvirtd"
      "docker"
      "adbusers"
    ];
  };

  i18n.defaultLocale = "en_GB.UTF-8";
  time = {
    timeZone = "Asia/Yekaterinburg";
    hardwareClockInLocalTime = true;
  };

  console = {
    font = "Lat2-Terminus16";
    colors = [
      "2e3440"
      "d36265"
      "88ce7c"
      "e7e18c"
      "5297cf"
      "bf6ea3"
      "5baebf"
      "cad8e8"
      "3b4252"
      "ec6e71"
      "a1f493"
      "fff796"
      "74b8ef"
      "e28ec5"
      "85d1e2"
      "dfeaf5"
    ];
  };

  environment = {
    pathsToLink = [ "/share" ];
    homeBinInPath = true;

    shellAliases = {
      # NixOS
      jnp = "cd ${pkgs.path}";
      nboot = "sudo nixos-rebuild boot --flake ~/nixos-configuration";
      nswitch = "sudo nixos-rebuild switch --flake ~/nixos-configuration";
      nupdate = "nix flake update ~/nixos-configuration";
      nlock = "nix flake lock ~/nixos-configuration";
      nclear = "sudo nix-collect-garbage --delete-old";

      # system
      sctl = "systemctl";

      # translator
      en = "trans -I -j -t ru";
      ru = ''swaymsg input "*" xkb_switch_layout 1 && trans -I -j -t en'';

      # bluetooth
      btc = "bluetoothctl connect 88:D0:39:65:46:85";
      btd = "bluetoothctl disconnect";

      # use extended regex instead of BRE
      grep = "grep -E";
      sed = "sed -E";

      # misc
      se = "sudoedit";
      pg = "$PAGER";
      ls = "exa";
      rg = "rg --follow --hidden --smart-case --no-messages";
      fd = "fd --follow --hidden";
      dt = "difft";
      tk = "tokei";
      cat = "bat --pager=never --style=changes,rule,numbers,snip";
      sudo = "sudo "; # this will make sudo work with shell aliases/man alias
      usrcfg = "git --git-dir=$HOME/.git_home/ --work-tree=$HOME";
    };

    # fix conflict between modules/programs/environment.nix#L25 and modules/config/shells-environment.nix#L172
    sessionVariables.XDG_CONFIG_DIRS = [ "/etc/xdg" ];
    variables.XDG_CONFIG_DIRS = mkForce config.environment.sessionVariables.XDG_CONFIG_DIRS;

    sessionVariables = {
      # XDG base dir
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";

      # set gsettings schemas
      XDG_DATA_DIRS = [ (pkgs.glib.getSchemaDataDirPath pkgs.gsettings-desktop-schemas) ];

      # overriding vaapi driver
      LIBVA_DRIVER_NAME = "i965";

      # misc
      TERMINAL = "alacritty";
      MENU = "wofi -d";
      EDITOR = "nvim";
      BROWSER = "nvim";
      GTK_USE_PORTAL = "1";
      QT_QPA_PLATFORMTHEME = "qt5ct"; # TODO create an issue
    };
  };

  services = {
    dbus-broker.enable = true;
    udisks2.enable = true;
  };

  # display manager
  services.xserver = {
    enable = true;
    excludePackages = [
      pkgs.xorg.xorgserver.out
      pkgs.xorg.xrandr
      pkgs.xorg.xrdb
      pkgs.xorg.setxkbmap
      pkgs.xorg.iceauth
      pkgs.xorg.xlsclients
      pkgs.xorg.xset
      pkgs.xorg.xsetroot
      pkgs.xorg.xinput
      pkgs.xorg.xprop
      pkgs.xorg.xauth
      pkgs.xterm
      pkgs.xdg-utils
      pkgs.xorg.xf86inputevdev.out
      pkgs.nixos-icons
    ];
    displayManager = {
      gdm = {
        wayland = true;
        enable = true;
      };
    };
  };

  # logging
  services.journald.extraConfig = "SystemMaxUse=200M";
  systemd.coredump.extraConfig = "Storage=none";
  systemd.services.display-manager.serviceConfig.LogNamespace = "desktop-session";
  environment.etc."systemd/journald@desktop-session.conf".text = ''
    [Journal]
    SystemMaxUse=200M
  '';

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

  xdg.mime.defaultApplications = {
    "application/pdf" = "sioyek.desktop";
    "image/jpeg" = "imv.desktop";
    "image/png" = "imv.desktop";
  };

  fonts = {
    enableDefaultFonts = false;
    fontconfig.crOSMaps = true;
    fontconfig.defaultFonts = {
      monospace = [ "JetBrains Mono NL Light" ];
      sansSerif = [ "Exo 2" ];
      serif = [ "Tinos" ];
      emoji = [ "JoyPixels" ];
    };
    fonts = with pkgs; [

      nur.repos.ilya-fedin.exo2
      jetbrains-mono
      unifont
      symbola
      joypixels
      (nerdfonts.override { fonts = [ "Arimo" ]; })

    ];
  };

  qt5 = {
    enable = true;
    platformTheme = "qt5ct";
  };

  # Enable building the man cache
  documentation.man.generateCaches = true;

  security.pki.certificateFiles = [ inputs.CA ];

  # Pkgs what will installed in system profile
  programs = {

    nano.syntaxHighlight = false;
    less.enable = mkForce false;

    openvpn3.enable = true;

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

    adb.enable = true;
  };

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

    # cli
    et
    fzf # for zoxide/fzf-bash-complete
    ffmpeg
    zoxide
    tokei
    tealdeer
    pandoc
    translate-shell
    librespeed-cli

    # GUI
    nur.repos.ilya-fedin.kotatogram-desktop-with-webkit
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
