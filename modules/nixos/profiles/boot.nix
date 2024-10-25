{ lib, ... }:
{
  boot = {
    initrd.systemd.enable = true;
    loader = {
      efi.canTouchEfiVariables = false;
      # still accessible by holding random keys during early boot.
      timeout = lib.mkForce 0;
      systemd-boot = {
        enable = true;
        memtest86.enable = true;
        configurationLimit = 20;
        consoleMode = "max";
      };
    };
  };
}
