{
  config,
  pkgs,
  lib,
  ...
}:
{
  services = {
    desktopManager.plasma6.enable = true;
    xserver.displayManager.sddm.theme = lib.mkForce "breeze";
    power-profiles-daemon.enable = !config.services.tlp.enable;
  };
  systemd = {
    packages = [ pkgs.iwgtk ];
    user.services.iwgtk.wantedBy = [ "plasma-workspace.target" ];
    user.services.iwgtk.after = [ "plasma-workspace.target" ];
  };
}
