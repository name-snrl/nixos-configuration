{ pkgs, lib, ... }: {
  boot = {
    kernelPackages = pkgs.linuxPackages_zen; # TODO if desktop
    initrd.systemd.enable = true;
    initrd.includeDefaultModules = false;
    supportedFilesystems = [ "ntfs" ]; # TODO if desktop
    tmp.useTmpfs = true; # TODO depends on RAM

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
