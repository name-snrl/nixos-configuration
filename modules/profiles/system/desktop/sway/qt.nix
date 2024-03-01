{ pkgs, ... }:
{
  qt = {
    enable = true;
    platformTheme = "qt5ct";
  };
  environment = {
    pathsToLink = [ "/share/Kvantum" ];
    systemPackages = with pkgs; [
      libsForQt5.qtstyleplugin-kvantum
      qt6Packages.qtstyleplugin-kvantum
    ];
  };
  # to unify dialogs
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
}
