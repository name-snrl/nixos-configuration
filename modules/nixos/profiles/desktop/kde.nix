{
  config,
  lib,
  ...
}:
{
  services = {
    desktopManager.plasma6.enable = true;
    displayManager.sddm.theme = lib.mkForce "breeze";
    power-profiles-daemon.enable = !config.services.tlp.enable;
  };
}
