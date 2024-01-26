{ lib, ... }: {
  programs.adb.enable = true; # TODO if desktop
  users.users.default.extraGroups = [ "adbusers" ]; # TODO if desktop

  services = {
    dbus.implementation = "broker";
    udisks2.enable = true;
  };

  documentation.man.generateCaches = true;

  # junk out
  programs.less.enable = lib.mkForce false;
  programs.nano.enable = false;
}
