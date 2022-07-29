{ config, lib, pkgs, ... }:

let
  userName = "name_snrl";
  nur-no-pkgs = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") { };
in

{

  imports = [
    ./hardware-configuration.nix
    nur-no-pkgs.repos.ilya-fedin.modules.metric-compatible-fonts
    nur-no-pkgs.repos.ilya-fedin.modules.dbus-broker
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

    #kernelPackages = pkgs.linuxPackages_5_15;
    initrd.kernelModules = [ "i915" ];
    supportedFilesystems = [ "ntfs" ];
    kernelModules = [ "acpi_call" ];
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
  };

  # Power management governor
  powerManagement.cpuFreqGovernor = lib.mkDefault "schedutil";

  # Networking
  networking = {
    #firewall.enable = false;
    hostName = "nixos";
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
    wireless.iwd.settings.General.DisablePeriodicScan = false;
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
        obfs4 185.177.207.149:8443 69E9E63C529D8A48D7AD9F7828C02973C4C80042 cert=Ww+My19m46C3iGCKmc9NYd5cjrsDVmJCEzwr0jnrsdsE4w0kj4dPBSzz4vSu276P0sOJHQ iat-mode=0
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
    package = pkgs.bluezFull;
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

  # Keyboard
  environment.etc."interception-tools.yaml".text = ''
    MAPPINGS:
      - KEY: KEY_CAPSLOCK
        TAP: KEY_ESC
        HOLD: KEY_LEFTCTRL
        HOLD_START: BEFORE_CONSUME_OR_RELEASE

      - KEY: KEY_ENTER
        TAP: KEY_ENTER
        HOLD: KEY_LEFTALT
        HOLD_START: BEFORE_CONSUME_OR_RELEASE

      - KEY: KEY_LEFTALT
        TAP: KEY_LEFTMETA
        HOLD: KEY_LEFTMETA
        HOLD_START: BEFORE_CONSUME_OR_RELEASE

      - KEY: KEY_LEFTMETA
        TAP: KEY_LEFTALT
        HOLD: KEY_LEFTALT
        HOLD_START: BEFORE_CONSUME_OR_RELEASE

      - KEY: KEY_RIGHTCTRL
        TAP: KEY_RIGHTMETA
        HOLD: KEY_RIGHTMETA
        HOLD_START: BEFORE_CONSUME_OR_RELEASE

      - KEY: KEY_RIGHTSHIFT
        TAP: KEY_RIGHTCTRL
        HOLD: KEY_RIGHTSHIFT
        HOLD_START: BEFORE_CONSUME_OR_RELEASE
  '';

  services.interception-tools = {
    enable = true;
    plugins = [ pkgs.interception-tools-plugins.dual-function-keys ];
    udevmonConfig = ''
      - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | \
      ${pkgs.interception-tools-plugins.dual-function-keys}/bin/dual-function-keys -c /etc/interception-tools.yaml | \
      ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
        DEVICE:
          EVENTS:
            EV_KEY: [KEY_CAPSLOCK, KEY_ENTER, KEY_LEFTALT, KEY_LEFTMETA, KEY_RIGHTCTRL, KEY_SPACE, KEY_LEFTSHIFT, KEY_RIGHTSHIFT]
    '';
  };

  #---------------------------- ENVIRONMENT N SOFT ----------------------------#

  users.users.${userName} = {
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

    sessionVariables = {
      # XDG base dir
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";

      # set gsettings schemas
      XDG_DATA_DIRS = [ (pkgs.glib.getSchemaDataDirPath pkgs.gsettings-desktop-schemas) ];

      # bash hist
      HISTCONTROL = "ignorespace:erasedups";
      HISTFILESIZE = "-1";
      HISTSIZE = "-1";
      PROMPT_COMMAND = "history -a";

      # overriding vaapi driver
      LIBVA_DRIVER_NAME = "i965";

      # misc
      TERMINAL = "alacritty";
      MENU = "wofi -d";
      BROWSER = "nvim";
    };
  };

  services.dbus-broker.enable = true;

  # Auto login
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.sway}/bin/sway";
        user = "${userName}";
      };
    };
  };

  xdg.portal = {
    enable = true;
    gtkUsePortal = true;
    wlr = {
      enable = true;
      settings.screencast = {
        output_name = "eDP-1";
        max_fps = 60;
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

  # Sway
  programs =
    {
    sway = {
      enable = true;
      wrapperFeatures.gtk = true; # so that gtk works properly
      extraSessionCommands = ''
        export _JAVA_AWT_WM_NONREPARENTING=1
        export ANKI_WAYLAND=1
      '';

      extraPackages = with pkgs; [
        swaylock-effects
        grim slurp flameshot
        wl-clipboard
        wf-recorder
        mako
        imv
        wofi
        alacritty
        (pkgs.runCommand "xterm" {} ''
          mkdir -p "$out/bin"
          ln -sfn "${pkgs.alacritty}/bin/alacritty" "$out/bin/xterm"
        '') # https://gitlab.gnome.org/GNOME/glib/-/issues/338
      ];
    };
  };

  systemd.user.targets.sway-session = {
    description = "sway compositor session";
    documentation = [ "man:systemd.special(7)" ];
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
  };

  systemd.user.services.mako = {
    description = "Mako as systemd service";
    wantedBy = [ "sway-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "dbus";
      BusName = "org.freedesktop.Notifications";
      ExecCondition = ''
        /bin/sh -c '[ -n "$WAYLAND_DISPLAY" ]'
      '';
      ExecStart = "${pkgs.mako}/bin/mako";
      ExecReload = "${pkgs.mako}/bin/makoctl reload";
      RestartSec = 3;
      Restart = "always";
    };
  };

  systemd.user.services.waybar = {
    description = "Waybar as systemd service";
    wantedBy = [ "sway-session.target" ];
    partOf = [ "graphical-session.target" ];
    script = "${pkgs.waybar}/bin/waybar";
    serviceConfig = {
      RestartSec = 3;
      Restart = "always";
    };
    environment.PATH = lib.mkForce null;
  };

  systemd.user.services.swayidle = {
    description = "Swayidle as systemd service";
    wantedBy = [ "sway-session.target" ];
    partOf = [ "graphical-session.target" ];
    script = "${pkgs.swayidle}/bin/swayidle -w";
    serviceConfig = {
      RestartSec = 3;
      Restart = "always";
    };
    environment.PATH = lib.mkForce null;
  };

  systemd.user.services.polkit-agent = {
    description = "Run polkit authentication agent";
    wantedBy = [ "sway-session.target" ];
    script = "${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
    serviceConfig = {
      RestartSec = 3;
      Restart = "always";
    };
    environment.PATH = lib.mkForce null;
  };

  systemd.user.services.swaykbdd = {
    description = "Swaykbdd as systemd service";
    wantedBy = [ "sway-session.target" ];
    partOf = [ "graphical-session.target" ];
    script = "${pkgs.swaykbdd}/bin/swaykbdd";
    serviceConfig = {
      RestartSec = 3;
      Restart = "always";
    };
  };

  systemd.user.services.autotiling = {
    description = "Autotiling as systemd service";
    wantedBy = [ "sway-session.target" ];
    partOf = [ "graphical-session.target" ];
    script = "${pkgs.autotiling}/bin/autotiling";
    serviceConfig = {
      RestartSec = 3;
      Restart = "always";
    };
    environment.PATH = lib.mkForce null;
  };

  systemd.user.services.flameshot = {
    description = "Flameshot as systemd service";
    wantedBy = [ "sway-session.target" ];
    partOf = [ "graphical-session.target" ];
    script = "${pkgs.flameshot }/bin/flameshot";
    serviceConfig = {
      RestartSec = 3;
      Restart = "always";
    };
  };

  systemd.user.services.clipman = {
    description = "Clipman as systemd service";
    wantedBy = [ "sway-session.target" ];
    partOf = [ "graphical-session.target" ];
    script = "${pkgs.wl-clipboard}/bin/wl-paste -t text --watch ${pkgs.clipman}/bin/clipman store --max-items=1";
    serviceConfig = {
      RestartSec = 3;
      Restart = "always";
    };
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

  nixpkgs = {
    # Neovim overlay
    overlays = [
      (import (builtins.fetchTarball {
        #url = https://github.com/nix-community/neovim-nightly-overlay/archive/28de4ebfc0ed628bfdfea83bd505ab6902a5c138.tar.gz;
        url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
      }))

      #(final: prev: {
      #  neovim-nightly = prev.neovim-nightly.overrideAttrs (oa: {
      #    patches = oa.patches or [] ++ [ ./nvim_virt_text.patch ];
      #  });
      #})

      (final: prev: {
        nvimpager = prev.nvimpager.overrideAttrs (oa: {
          version = "dev";
          src = builtins.fetchTarball "https://github.com/lucc/nvimpager/archive/HEAD.tar.gz";
          preBuild = ''
            version=$(bash ./nvimpager -v | sed 's/.* //')
            substituteInPlace nvimpager --replace '/nvimpager/init.vim' '/nvim/pager_init.lua'
          '';
          buildFlags = oa.buildFlags ++ [ "VERSION=\${version}-dev" ];
        });
      })
    ];

    # Allow unfree pkgs
    config = {
      allowUnfree = true;
      joypixels.acceptLicense = true;

    # NUR
      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") { };
      };
    };
  };

  nix.settings.substituters = [
    "https://ilya-fedin.cachix.org"
    "https://nix-community.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "ilya-fedin.cachix.org-1:QveU24a5ePPMh82mAFSxLk1P+w97pRxqe9rh+MJqlag="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];

  # Enable building the man cache
  documentation.man.generateCaches = true;

  # Pkgs what will installed in system profile
  programs = {
    starship = {
      enable = true;
      settings = {
        # Base
        character = {
          success_symbol = "[>](bold green)";
          error_symbol = "[x](bold red)";
        };
        continuation_prompt = "[-](bold yellow) ";

        username = {
          style_user = "bold blue";
          show_always = true;
        };

        directory = {
          truncation_length = 6;
          truncate_to_repo = false;
          read_only = " [RO]";
          truncation_symbol = "../";
          repo_root_style = "bold yellow";
          home_symbol = "~";
        };

        jobs = {
          number_threshold = 1;
          format = "[$symbol $number]($style) ";
          symbol = "bg";
          style = "bold purple";
        };

        nix_shell = {
          format = "via [$state$symbol-$name]($style) ";
          symbol = " nix";
          style = "bold cyan";
        };
      } // builtins.listToAttrs (map (name: {inherit name; value.disabled = true;}) [
        #"username" "hostname" "directory"
        #"git_branch" "git_commit"
        #"git_metrics" "git_state"
        "git_status"
        #"hg_branch" "cmd_duration"
        #"line_break"
        #"jobs" "nix_shell" "character"

        # Sys or builtin
        "battery" "time" "status" "shell"
        "localip" "shlvl" "vcsh" "memory_usage"

        "singularity" "kubernetes" "docker_context" "package"

        "buf" "c" "cmake" "cobol" "container" "dart" "deno"
        "dotnet" "elixir" "elm" "erlang" "golang" "haskell" "helm"
        "java" "julia" "kotlin" "lua" "nim" "nodejs" "ocaml" "perl"
        "php" "pulumi" "purescript" "python" "rlang" "red" "ruby"
        "rust" "scala" "swift" "terraform" "vlang" "vagrant" "zig"
        "conda" "spack" "gcloud"
        "openstack" "crystal"
        "env_var" "sudo"

        "aws"
        "azure"
        #"daml"
      ]);
    };

    bash.interactiveShellInit = ''
      stty -ixon # disable flow control
      bind "set completion-ignore-case on"
      eval "$(zoxide init --cmd j bash)"

      source ${pkgs.complete-alias}/bin/complete_alias
      complete -F _complete_alias usrcfg
      complete -F _complete_alias nboot
      complete -F _complete_alias nswitch
      complete -F _complete_alias nupdate
      complete -F _complete_alias nclear
      complete -F _complete_alias sctl
    '';

    neovim = {
      enable = true;
      package = pkgs.neovim-nightly;
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;
      configure.customRC = ''
        luafile $HOME/.config/nvim/init.lua
      '';
    };

    git = {
      enable = true;
      config = {
        init.defaultBranch = "master";

        user = {
          name = "${userName}";
          email = "Demogorgon-74@ya.ru";
        };

        url = {
          "git@github.com:".pushInsteadOf = "https://github.com/";
          "git@gist.github.com:".pushInsteadOf = "https://gist.github.com/";
        };

        pager.difftool = true;

        diff = {
          tool = "difftastic";
        };

        difftool = {
          prompt = false;
          "difftastic".cmd = ''difft "$LOCAL" "$REMOTE"'';
        };

        alias = {
          st = "status";
          cm = "commit -m";
          dt = "difftool";
        };
      };
    };

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

    # NixOS
    nixos-option

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

    # code
    gnumake gcc
    python310 python310Packages.python-lsp-server
    shellcheck nodePackages.bash-language-server
    rnix-lsp
    sumneko-lua-language-server
    ltex-ls

    # network
    firefox-wayland
    qutebrowser
    elinks
    qbittorrent
    librespeed-cli

    # social
    discord zoom-us
    dino nheko # matrix
    nur.repos.ilya-fedin.kotatogram-desktop-with-webkit

    # mdeia
    mpv gimp
    ffmpeg
    (sioyek.overrideAttrs(oa: {
      buildInputs = oa.buildInputs ++ [ mujs ];
      version = "1.4.0";
      src = builtins.fetchTarball "https://github.com/ahrm/sioyek/archive/refs/tags/v1.4.0.tar.gz";
    }))

    # utilities
    (pkgs.runCommand "less" {} ''
      mkdir -p "$out/bin"
      ln -sfn "${pkgs.nvimpager}/bin/nvimpager" "$out/bin/less"
    '')
    difftastic
    tokei
    tldr
    file tree
    skim # fuzzy finder
    (pkgs.runCommand "jq" {} ''
      mkdir -p "$out/bin"
      ln -sfn "${pkgs.gojq}/bin/gojq" "$out/bin/jq"
    '') # use gojq as jq
    jshon
    pandoc #wkhtmltopdf # doc converter

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
