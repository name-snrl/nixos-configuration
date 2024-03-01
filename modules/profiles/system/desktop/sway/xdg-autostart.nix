{
  config,
  lib,
  pkgs,
  ...
}:
{
  xdg.autostart.enable = lib.mkForce false;
  systemd.user = {
    targets.sway-session = {
      wants = [ "xdg-desktop-autostart.target" ];
      before = [ "xdg-desktop-autostart.target" ];
    };

    tmpfiles.rules =
      with pkgs;
      [
        "L+ %h/.config/autostart/firefox.desktop                 - - - - ${firefox-wayland}/share/applications/firefox.desktop"
        "L+ %h/.config/autostart/org.flameshot.Flameshot.desktop - - - - ${flameshot}/share/applications/org.flameshot.Flameshot.desktop"
      ]
      ++
        lib.optional (config.i18n.inputMethod.enabled == "fcitx5")
          "L+ %h/.config/autostart/org.fcitx.Fcitx5.desktop        - - - - ${config.i18n.inputMethod.package}/etc/xdg/autostart/org.fcitx.Fcitx5.desktop";
  };
}
