{ lib, pkgs, ... }: {
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraSessionCommands = ''
      export _JAVA_AWT_WM_NONREPARENTING=1
      export ANKI_WAYLAND=1
    '';
  };

  programs.light.enable = true; # TODO only if laptop
  users.users.default.extraGroups = [ "video" ];

  qt = {
    enable = true;
    platformTheme = "qt5ct";
  };

  environment = {
    pathsToLink = [ "/share/Kvantum" ];
    systemPackages = with pkgs; [
      libsForQt5.qtstyleplugin-kvantum
      qt6Packages.qtstyleplugin-kvantum

      swaylock-effects
      wl-clipboard
      xdragon
      xdg-utils # wl-clipboard needs xdg-mime
      wl-screenrec # screencast
      flameshot
      slurp
      grim
      mako
      foot
      foot-as-xterm # https://gitlab.gnome.org/GNOME/glib/-/issues/338
      fuzzel
      playerctl

      #eww-wayland # TODO
      gojq-as-jq # needs for move script
      glib # needs for theme script
      (tesseract.override { enableLanguages = [ "eng" ]; }) # get text from screenshot
    ];
    sessionVariables = {
      TERMINAL = "footclient"; # TODO remove when xdg-terminal-exec will be set
    };
  };

  systemd = {
    packages = with pkgs; [ foot polkit-kde-agent ];
    user =
      let
        serviceConf = {
          Slice = "session.slice";
          Restart = "always";
          RestartSec = 2;
        };
      in
      {
        targets.sway-session = {
          description = "sway compositor session";
          documentation = [ "man:systemd.special(7)" ];
          bindsTo = [ "graphical-session.target" ];
          wants = [ "graphical-session-pre.target" "xdg-desktop-autostart.target" ];
          after = [ "graphical-session-pre.target" ];
          before = [ "xdg-desktop-autostart.target" ];
        };

        tmpfiles.rules = with pkgs; [
          "L+ %h/.config/autostart/firefox.desktop                 - - - - ${firefox-wayland}/share/applications/firefox.desktop"
          "L+ %h/.config/autostart/org.flameshot.Flameshot.desktop - - - - ${flameshot}/share/applications/org.flameshot.Flameshot.desktop"
        ];

        services.mako = {
          description = "Lightweight Wayland notification daemon";
          documentation = [ "man:mako(1)" ];
          partOf = [ "graphical-session.target" ];
          after = [ "graphical-session.target" ];
          serviceConfig = {
            Type = "dbus";
            BusName = "org.freedesktop.Notifications";
            ConditionEnvironment = "WAYLAND_DISPLAY";
            ExecStart = "${pkgs.mako}/bin/mako";
            ExecReload = "${pkgs.mako}/bin/makoctl reload";
          };
          environment.PATH = lib.mkForce null;
          wantedBy = [ "sway-session.target" ];
        };

        services.waybar = {
          description = "Highly customizable bar for Sway";
          partOf = [ "graphical-session.target" ];
          after = [ "graphical-session.target" ];
          requisite = [ "graphical-session.target" ];
          script = "${pkgs.waybar}/bin/waybar";
          serviceConfig = serviceConf // {
            ExecReload = "kill -SIGUSR2 $MAINPID";
          };
          environment.PATH = lib.mkForce null;
          wantedBy = [ "sway-session.target" ];
        };

        services.foot-server = {
          serviceConfig = serviceConf;
          environment.PATH = lib.mkForce null;
          wantedBy = [ "sway-session.target" ];
        };
        sockets.foot-server.wantedBy = [ "sway-session.target" ];

        services.swayidle = {
          description = "Idle management daemon";
          partOf = [ "graphical-session.target" ];
          script = "${pkgs.swayidle}/bin/swayidle -w";
          serviceConfig = serviceConf;
          environment.PATH = lib.mkForce null;
          wantedBy = [ "sway-session.target" ];
        };

        services.plasma-polkit-agent = {
          after = [ "graphical-session.target" ];
          serviceConfig = serviceConf;
          environment.PATH = lib.mkForce null;
          wantedBy = [ "sway-session.target" ];
        };

        services.autotiling = {
          description = "Automatically alternates the container layout";
          partOf = [ "graphical-session.target" ];
          script = "${pkgs.autotiling-rs}/bin/autotiling-rs";
          serviceConfig = serviceConf;
          environment.PATH = lib.mkForce null;
          wantedBy = [ "sway-session.target" ];
        };

        services.wl-clip-persist = {
          description = "Keep clipboard even after programs close";
          partOf = [ "graphical-session.target" ];
          script = "${pkgs.wl-clip-persist}/bin/wl-clip-persist -c both";
          serviceConfig = serviceConf;
          environment.PATH = lib.mkForce null;
          wantedBy = [ "sway-session.target" ];
        };

      };
  };
}
