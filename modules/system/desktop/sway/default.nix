{ pkgs, ... }: {
  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
    wrapperFeatures.gtk = true;
    extraSessionCommands = ''
      export _JAVA_AWT_WM_NONREPARENTING=1
      export ANKI_WAYLAND=1
    '';
  };

  # programs launched by sway may have large output, so we create a separate
  # namespace for everything that will be launched by sway
  systemd.services.display-manager.serviceConfig.LogNamespace = "graphical-session";
  environment.etc."systemd/journald@graphical-session.conf".text = ''
    [Journal]
    SystemMaxUse=200M
  '';

  environment = {
    sessionVariables = {
      TERMINAL = "footclient"; # TODO remove when xdg-terminal-exec will be set
    };
    # `systemPackages` takes precedence over `programs.sway.extraPackages`,
    # this may cause packages to be overridden
    systemPackages = with pkgs; [
      swaylock-effects
      wl-clipboard
      xdragon
      xdg-utils # wl-clipboard needs xdg-mime
      wl-screenrec # screencast
      flameshot
      slurp
      grim
      swaynotificationcenter
      foot
      (writeSymlinkBin foot "xterm") # https://gitlab.gnome.org/GNOME/glib/-/issues/338
      fuzzel
      playerctl

      #eww-wayland # TODO
      gojq # needs for move script
      glib # needs for theme script
      (tesseract.override { enableLanguages = [ "eng" ]; }) # get text from screenshot
    ];
  };
}
