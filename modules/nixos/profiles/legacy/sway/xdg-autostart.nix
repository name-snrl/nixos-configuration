{ defaultUserName, pkgs, ... }:
{
  systemd.user = {
    targets.sway-session = {
      wants = [ "xdg-desktop-autostart.target" ];
      before = [ "xdg-desktop-autostart.target" ];
    };

    tmpfiles.users.${defaultUserName}.rules = with pkgs; [
      "L+ %h/.config/autostart/firefox.desktop - - - - ${firefox-wayland}/share/applications/firefox.desktop"
    ];
  };
}
