{ config, lib, pkgs, ... }: {
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    extraSessionCommands = ''
      export _JAVA_AWT_WM_NONREPARENTING=1
      export ANKI_WAYLAND=1
    '';

    extraPackages = with pkgs; [
      swaylock-effects
      wl-clipboard
      xdragon
      xdg-utils # wl-clipboard needs xdg-mime
      gojq-as-jq # needs for move script
      glib # needs for theme script
      kooha # screencast
      (tesseract5.override { enableLanguages = [ "eng" ]; }) # get text from screenshot
      flameshot
      slurp
      grim
      mako
      tofi
      playerctl

      eww-wayland # TODO
    ];
  };

  environment.pathsToLink = [ "/share" ];

  services = {
    udisks2.enable = true;
    dictd.enable = true;
    dictd.DBs = with pkgs.dictdDBs; [ wiktionary ];
  };

  systemd.user =
    let
      serviceConf = {
        Slice = "session.slice";
        Restart = "always";
        RestartSec = 3;
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
        "L+ %h/.config/autostart/org.fcitx.Fcitx5.desktop        - - - - ${config.i18n.inputMethod.package}/etc/xdg/autostart/org.fcitx.Fcitx5.desktop"
      ];

      services.sway-assign-cgroups = {
        description = "Automatically assign a dedicated systemd scope to the GUI applications";
        wantedBy = [ "sway-session.target" ];
        partOf = [ "graphical-session.target" ];
        script = "${pkgs.sway-assign-cgroups}/bin/sway-assign-cgroups";
        serviceConfig = serviceConf;
        environment.PATH = lib.mkForce null;
      };

      services.mako = {
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
        } // serviceConf;
        environment.PATH = lib.mkForce null;
      };

      services.waybar = {
        description = "Waybar as systemd service";
        wantedBy = [ "sway-session.target" ];
        partOf = [ "graphical-session.target" ];
        script = "${pkgs.waybar}/bin/waybar";
        serviceConfig = serviceConf;
        environment.PATH = lib.mkForce null;
      };

      services.swayidle = {
        description = "Swayidle as systemd service";
        wantedBy = [ "sway-session.target" ];
        partOf = [ "graphical-session.target" ];
        script = "${pkgs.swayidle}/bin/swayidle -w";
        serviceConfig = serviceConf;
        environment.PATH = lib.mkForce null;
      };

      services.polkit-agent = {
        description = "Run polkit authentication agent";
        wantedBy = [ "sway-session.target" ];
        script = "${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
        serviceConfig = serviceConf;
        environment.PATH = lib.mkForce null;
      };

      services.swaykbdd = {
        description = "Swaykbdd as systemd service";
        wantedBy = [ "sway-session.target" ];
        partOf = [ "graphical-session.target" ];
        script = "${pkgs.swaykbdd}/bin/swaykbdd";
        serviceConfig = serviceConf;
      };

      services.autotiling = {
        description = "Autotiling as systemd service";
        wantedBy = [ "sway-session.target" ];
        partOf = [ "graphical-session.target" ];
        script = "${pkgs.autotiling-rs}/bin/autotiling-rs";
        serviceConfig = serviceConf;
        environment.PATH = lib.mkForce null;
      };

      services.clipman = {
        description = "Clipman as systemd service";
        wantedBy = [ "sway-session.target" ];
        partOf = [ "graphical-session.target" ];
        script = "${pkgs.wl-clipboard}/bin/wl-paste -t text --watch ${pkgs.clipman}/bin/clipman store --max-items=1";
        serviceConfig = serviceConf;
      };

    };
}
