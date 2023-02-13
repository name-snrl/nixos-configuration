{ pkgs, ... }: {
  qt.enable = true;
  qt.platformTheme = "qt5ct";

  programs.adb.enable = true; # TODO if desktop
  users.users.default.extraGroups = [ "adbusers" ]; # TODO if desktop

  networking.wireless.iwd.enable = true; # TODO if wifi is available

  services.dbus.implementation = "broker";
  documentation.man.generateCaches = true;
}
