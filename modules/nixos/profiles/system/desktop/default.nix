{ pkgs, ... }:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    supportedFilesystems = [ "ntfs" ];
  };
  programs.adb.enable = true;
  users.users.default.extraGroups = [ "adbusers" ];
}
