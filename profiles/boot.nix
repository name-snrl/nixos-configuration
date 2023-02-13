{ pkgs, ... }: {
  boot = {
    kernelPackages = pkgs.linuxPackages_zen; # TODO if desktop
    initrd.includeDefaultModules = false;
    supportedFilesystems = [ "ntfs" ]; # TODO if desktop
    tmpOnTmpfs = true; # TODO depends on RAM

    loader = {
      efi.canTouchEfiVariables = false;
      timeout = 3;
      systemd-boot = {
        enable = true;
        memtest86.enable = true;
        configurationLimit = 20;
        consoleMode = "max";
      };
    };
  };
}
