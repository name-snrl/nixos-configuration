{ config, lib, ... }:
let
  isPC = with config.host-specs; device-type == "laptop" || device-type == "desktop";
in
{
  programs.adb.enable = isPC;
  users.users.default.extraGroups = lib.mkIf isPC [ "adbusers" ];

  services = {
    dbus.implementation = "broker";
    udisks2.enable = true;
  };

  documentation.man.generateCaches = true;
}
