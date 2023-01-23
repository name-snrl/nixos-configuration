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
      xdg-utils # wl-clipboard needs xdg-mime
      gojq-as-jq # needs for move script
      glib # needs for theme script
      kooha # screencast
      (tesseract5.override { enableLanguages = [ "eng" ]; }) # get text from screenshot
      flameshot
      slurp
      grim
      mako
      wofi
      playerctl

      eww-wayland # TODO
    ];
  };

  systemd.user =
    let
      restartConf = {
        Restart = "always";
        RestartSec = 3;
      };
    in
    {
      targets.sway-session = {
        description = "sway compositor session";
        documentation = [ "man:systemd.special(7)" ];
        bindsTo = [ "graphical-session.target" ];
        wants = [ "graphical-session-pre.target" ];
        after = [ "graphical-session-pre.target" ];
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
        } // restartConf;
        environment.PATH = lib.mkForce null;
      };

      services.waybar = {
        description = "Waybar as systemd service";
        wantedBy = [ "sway-session.target" ];
        partOf = [ "graphical-session.target" ];
        script = "${pkgs.waybar}/bin/waybar";
        serviceConfig = restartConf;
        environment.PATH = lib.mkForce null;
      };

      services.swayidle = {
        description = "Swayidle as systemd service";
        wantedBy = [ "sway-session.target" ];
        partOf = [ "graphical-session.target" ];
        script = "${pkgs.swayidle}/bin/swayidle -w";
        serviceConfig = restartConf;
        environment.PATH = lib.mkForce null;
      };

      services.polkit-agent = {
        description = "Run polkit authentication agent";
        wantedBy = [ "sway-session.target" ];
        script = "${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
        serviceConfig = restartConf;
        environment.PATH = lib.mkForce null;
      };

      services.swaykbdd = {
        description = "Swaykbdd as systemd service";
        wantedBy = [ "sway-session.target" ];
        partOf = [ "graphical-session.target" ];
        script = "${pkgs.swaykbdd}/bin/swaykbdd";
        serviceConfig = restartConf;
      };

      services.autotiling = {
        description = "Autotiling as systemd service";
        wantedBy = [ "sway-session.target" ];
        partOf = [ "graphical-session.target" ];
        script = "${pkgs.autotiling-rs}/bin/autotiling-rs";
        serviceConfig = restartConf;
        environment.PATH = lib.mkForce null;
      };

      services.flameshot = {
        description = "Flameshot as systemd service";
        wantedBy = [ "sway-session.target" ];
        partOf = [ "graphical-session.target" ];
        script = "${pkgs.flameshot}/bin/flameshot";
        serviceConfig = restartConf;
      };

      services.clipman = {
        description = "Clipman as systemd service";
        wantedBy = [ "sway-session.target" ];
        partOf = [ "graphical-session.target" ];
        script = "${pkgs.wl-clipboard}/bin/wl-paste -t text --watch ${pkgs.clipman}/bin/clipman store --max-items=1";
        serviceConfig = restartConf;
      };
    };
}
