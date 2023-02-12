{ pkgs, ... }: {
  networking = {
    #firewall.enable = false;
    hostName = "nixos";
    wireless.iwd.enable = true;
  };

  qt.enable = true;
  qt.platformTheme = "qt5ct";

  services.dbus.implementation = "broker";
  documentation.man.generateCaches = true;
}
