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
    tlp-settings = {
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 50;
    };
  };

  system.stateVersion = "24.05";
}
