{ pkgs, byAttrs, ... }: {
  imports = [ ./hw-config.nix ];

  disabledModules = byAttrs {
    profiles.system.servers.openssh = false;
  };

  boot.initrd.kernelModules = [ "i915" ]; # Enable early KMS

  # Firmware
  #services.fwupd.enable = true; # https://fwupd.org/lvfs/devices/

  # CPU
  powerManagement.cpuFreqGovernor = "schedutil";

  # GPU acceleration
  environment.sessionVariables.LIBVA_DRIVER_NAME = "i965";
  hardware.opengl.extraPackages = with pkgs; [ beignet intel-vaapi-driver ];

  host-specs = {
    device-type = "laptop";
    output-name = "eDP-1";
    cores = 4;
    ram = 8;
    wifi = true;
    bluetooth = true;
    battery = true;
    webcam = true;
    als = false;
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "22.05";
}
