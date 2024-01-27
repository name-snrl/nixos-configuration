{ pkgs, ... }: {
  systemd.user = {
    targets.sway-session = {
      wants = [ "xdg-desktop-autostart.target" ];
      before = [ "xdg-desktop-autostart.target" ];
    };

    tmpfiles.rules = with pkgs; [
      "L+ %h/.config/autostart/firefox.desktop                 - - - - ${firefox-wayland}/share/applications/firefox.desktop"
      "L+ %h/.config/autostart/org.flameshot.Flameshot.desktop - - - - ${flameshot}/share/applications/org.flameshot.Flameshot.desktop"
    ];
  };
}
