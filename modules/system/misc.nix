{ pkgs, ... }: {
  qt.enable = true;
  qt.platformTheme = "qt5ct";
  environment.sessionVariables.QT_QPA_PLATFORMTHEME = "qt5ct"; # TODO create an issue

  programs.adb.enable = true; # TODO if desktop
  users.users.default.extraGroups = [ "adbusers" ]; # TODO if desktop

  networking.wireless.iwd.enable = true; # TODO if wifi is available

  services.dbus.implementation = "broker";
  documentation.man.generateCaches = true;
}
