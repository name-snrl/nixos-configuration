{ config, lib, pkgs, inputs, ... }: {
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    supportedFilesystems = [ "ntfs" ];
    tmpOnTmpfs = true;
  };

  # Networking
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
