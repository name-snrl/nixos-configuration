{ pkgs, lib, ... }: {
  qt.enable = true;
  qt.platformTheme = "qt5ct";
  environment.sessionVariables.QT_QPA_PLATFORMTHEME = "qt5ct"; # TODO create an issue

  programs.adb.enable = true; # TODO if desktop
  users.users.default.extraGroups = [ "adbusers" ]; # TODO if desktop

  services.dbus.implementation = "broker";
  documentation.man.generateCaches = true;

  # junk out
  programs.less.enable = lib.mkForce false;
  programs.nano.syntaxHighlight = false;
}
