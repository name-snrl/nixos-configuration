{ pkgs, ... }:
{
  services = {
    desktopManager.plasma6.enable = true;
    displayManager.plasma-login-manager.enable = true;
  };
  # shift the burden of shaping the user environment to the user
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    konsole
    elisa
    kate
    ktexteditor # provides elevated actions for kate
    krdp
  ];
}
