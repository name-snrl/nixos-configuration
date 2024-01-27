{ pkgs, byAttrs, ... }: {
  imports = [ ./hw-config.nix ];

  disabledModules = byAttrs {
    system.servers.openssh = false;
  };

  boot.initrd.kernelModules = [ "i915" ]; # Enable early KMS

  # Firmware
  #services.fwupd.enable = true; # https://fwupd.org/lvfs/devices/

  # CPU
  powerManagement.cpuFreqGovernor = "schedutil";

  # GPU acceleration
  environment.sessionVariables.LIBVA_DRIVER_NAME = "i965";
  hardware.opengl.extraPackages = with pkgs; [ beignet vaapiIntel ];

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "22.05";
}
