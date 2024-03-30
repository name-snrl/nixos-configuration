{
  pkgs,
  inputs,
  importsFromAttrs,
  ...
}:
{
  imports =
    [ ./hw-config.nix ]
    ++ importsFromAttrs {
      importByDefault = true;
      modules = inputs.self.nixosModules;
      imports = {
        profiles.system.servers.openssh = false;
        profiles.system.desktop.work = false;
      };
    };

  #boot.initrd.kernelModules = [ "i915" ]; # Enable early KMS

  # Firmware
  services.fwupd.enable = true; # https://fwupd.org/lvfs/devices/

  # CPU
  powerManagement.cpuFreqGovernor = "schedutil";

  # GPU acceleration
  hardware.opengl.extraPackages = with pkgs; [ intel-media-driver ];

  host-specs = {
    device-type = "laptop";
    output-name = "eDP-1";
    cores = 8;
    ram = 16;
    wifi = true;
    bluetooth = true;
    battery = true;
    webcam = true;
    als = false;
  };

  system.stateVersion = "24.05";
}
