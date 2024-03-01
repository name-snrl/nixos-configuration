{
  config,
  pkgs,
  lib,
  ...
}:
let
  isPC = with config.host-specs; device-type == "laptop" || device-type == "desktop";
in
{
  boot = {
    kernelPackages = lib.mkIf isPC pkgs.linuxPackages_zen;
    initrd.systemd.enable = true;
    initrd.includeDefaultModules = false;
    supportedFilesystems = lib.mkIf isPC [ "ntfs" ];
    tmp.useTmpfs = with config.host-specs; if lib.isInt ram && ram > 7 then true else false;

    loader = {
      efi.canTouchEfiVariables = false;
      timeout = lib.mkForce 3;
      systemd-boot = {
        enable = true;
        memtest86.enable = true;
        configurationLimit = 20;
        consoleMode = "max";
      };
    };
  };
}
