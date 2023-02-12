{ lib, pkgs, ... }: {
  imports = [
    ./hw-config.nix
  ];

  boot.initrd.kernelModules = [ "i915" ]; # Enable early KMS

  # Firmware
  services.fwupd.enable = true; # https://fwupd.org/lvfs/devices/

  # CPU
  powerManagement.cpuFreqGovernor = lib.mkDefault "schedutil";

  # GPU acceleration
  environment.sessionVariables.LIBVA_DRIVER_NAME = "i965";
  hardware.opengl.extraPackages = with pkgs; [ beignet vaapiIntel ];

  system.stateVersion = "22.05";
}
