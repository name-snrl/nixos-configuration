{ pkgs, ... }:
{
  qt.enable = true;
  environment = {
    pathsToLink = [ "/share/Kvantum" ];
    systemPackages = with pkgs; [
      libsForQt5.qt5ct
      libsForQt5.qtstyleplugin-kvantum
      qt6Packages.qt6ct
      qt6Packages.qtstyleplugin-kvantum
    ];
  };
  programs.sway.extraSessionCommands = ''
    export QT_QPA_PLATFORMTHEME=qt5ct
  '';
  # to unify dialogs
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
}
