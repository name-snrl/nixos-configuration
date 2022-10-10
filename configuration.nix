{ config, lib, pkgs, inputs, system, ... }:

with lib;

let
  nur-no-pkgs = import inputs.nur {
    nurpkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [];
    };

    repoOverrides = {
      ilya-fedin = import inputs.nur-repo-override {};
    };
  };

  nurOverlay = self: super: {
    nur = import inputs.nur {
      nurpkgs = super;
      pkgs = super;
      repoOverrides = {
        ilya-fedin = import inputs.nur-repo-override {
          pkgs = super;
        };
      };
    };
  };
in

{
  imports = [
    nur-no-pkgs.repos.ilya-fedin.modules.metric-compatible-fonts
    nur-no-pkgs.repos.ilya-fedin.modules.dbus-broker
  ];

  nix = {
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" "nixos-config=${inputs.self}" ];

    registry = {
      nixpkgs.flake = inputs.nixpkgs;
      self.flake = inputs.self;
      np.flake = inputs.nixpkgs;
    };

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      substituters = [
        "https://nix-community.cachix.org"
        "https://ilya-fedin.cachix.org"
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "ilya-fedin.cachix.org-1:QveU24a5ePPMh82mAFSxLk1P+w97pRxqe9rh+MJqlag="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
    joypixels.acceptLicense = true;
  };

  nixpkgs.overlays = [
    nurOverlay

    inputs.nvim-nightly.overlay
    inputs.nvimpager.overlay

    (final: prev: {
      nvimpager = prev.nvimpager.overrideAttrs (oa: {
        postInstall = ''
          runHook preBuild

          mv $out/bin/nvimpager $out/bin/less
          sed -E -i "s#(RUNTIME=.*)(')#\1,${inputs.nvim}\2#" $out/bin/less
          sed -i 's#rc=.*#rc=${inputs.nvim}/pager_init.lua#' $out/bin/less

          runHook postBuild
        '';
      });
    })
  ];

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

  # Power management governor
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
        obfs4 207.148.108.221:443 7259F29EC35E385B25D1DD56A3B39B76BBE63940 cert=aMu33DOPGFQsjgLZ7JtKB6Eysn9kaN4ubcWbi2zsO+rAORC1eKDrDiGqXqkJD8ZLgY25QA iat-mode=0
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
      "wheel" "networkmanager" "video"
      "libvirtd" "docker"
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
    keyMap = "us";
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
    homeBinInPath = true;

    shellAliases = {
      # system
      nboot = "sudo nixos-rebuild boot";
      nswitch = "sudo nixos-rebuild switch";
      nupdate = "sudo nixos-rebuild boot --upgrade-all && nix-channel --update";
      nclear = "sudo nix-collect-garbage --delete-old && sudo nix-store --optimise";
      reboot = "read -p 'Are you sure? ' i;[[ $i == y ]] && reboot";
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
    variables.XDG_CONFIG_DIRS = mkForce config.environment.sessionVariables.XDG_CONFIG_DIRS;

    sessionVariables = {
      # XDG base dir
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";

      # set gsettings schemas
      XDG_DATA_DIRS = [ (pkgs.glib.getSchemaDataDirPath pkgs.gsettings-desktop-schemas) ];

      # fix conflict between modules/programs/environment.nix#L25 and modules/config/shells-environment.nix#L172
      XDG_CONFIG_DIRS = [ "/etc/xdg" ];

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

  # Pkgs what will installed in system profile
  programs = {

    nano.syntaxHighlight = false;
    less.enable = lib.mkForce false;

    tmux = {
      enable = true;
      keyMode = "vi";
    };

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
    xdg-utils glib
    pamixer
    lxqt.pavucontrol-qt
    playerctl
    pciutils
    usbutils
    inetutils
    virt-manager

    # NixOS
    #nixos-option

    # themes
    nordic
    papirus-icon-theme
    numix-cursor-theme
    libsForQt5.qtstyleplugin-kvantum

    # soft
    htop translate-shell
    wget
    pcmanfm-qt gptfdisk
    rclone jmtpfs
    unzip

    python310 # calculator

    # network
    firefox-wayland
    qutebrowser
    elinks
    qbittorrent
    librespeed-cli
    gns3-gui gns3-server

    # social
    discord zoom-us
    dino nheko # matrix
    nur.repos.ilya-fedin.kotatogram-desktop-with-webkit

    # mdeia
    obs-studio
    ffmpeg
    mpv
    gimp
    sioyek

    # utilities
    nvimpager
    difftastic
    tokei
    tealdeer
    file tree
    fzf
    (pkgs.runCommand "jq" {} ''
      mkdir -p "$out/bin"
      ln -sfn "${pkgs.gojq}/bin/gojq" "$out/bin/jq"
    '') # use gojq as jq
    jshon
    pandoc #wkhtmltopdf # doc converter
    tesseract5

    # GNU replacement
    exa fd bat
    ripgrep
    zoxide

    # misc
    et
    anki-bin
    neofetch
  ];
}
