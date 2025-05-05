{ vars, pkgs, ... }:
{
  systemd.user = {
    targets.sway-session = {
      wants = [ "xdg-desktop-autostart.target" ];
      before = [ "xdg-desktop-autostart.target" ];
    };

    tmpfiles.users.${vars.users.master.name}.rules = with pkgs; [
      "L+ %h/.config/autostart/firefox.desktop - - - - ${firefox-wayland}/share/applications/firefox.desktop"
    ];
  };
}
