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
      xdg-utils  # wl-clipboard needs xdg-mime
      gojq-as-jq # needs for move script
      obs-studio # screencast
      (tesseract5.override { enableLanguages = [ "eng" ]; }) # get text from screenshot
      flameshot
      slurp
      grim
      mako
      wofi
      pamixer
      playerctl

      eww-wayland # TODO
    ];
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
    environment.PATH = lib.mkForce null;
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
}
