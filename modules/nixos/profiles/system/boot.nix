{ lib, ... }:
{
  boot = {
    initrd = {
      systemd.enable = true;
      includeDefaultModules = false;
    };
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
