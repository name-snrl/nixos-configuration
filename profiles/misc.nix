{ pkgs, ... }: {
  networking = {
    #firewall.enable = false;
    hostName = "nixos";
    wireless.iwd.enable = true;
  };

  qt.enable = true;
  qt.platformTheme = "qt5ct";

  programs.adb.enable = true;
  users.users.default.extraGroups = [ "adbusers" ];

  services.dbus.implementation = "broker";
  documentation.man.generateCaches = true;
}
