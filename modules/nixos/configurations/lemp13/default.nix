{ inputs, pkgs, ... }:
{
  imports = inputs.self.moduleTree.nixos {
    configurations = false;
    profiles = {
      desktop.work = false;
      legacy = false;
      servers = false;
    };
  };

  disko.devices.disk.disk0.device = "/dev/disk/by-id/nvme-Samsung_SSD_990_PRO_2TB_S7KHNU0X911162F";

  hardware.system76 = {
    enableAll = true;
    power-daemon.enable = false;
  };

  # Firmware
  # system76 support said that they have made some fixes to the microcode
  # so disable microcode updates
  hardware.cpu.intel.updateMicrocode = false;

  # CPU
  nix.settings.cores = 6;

  # GPU acceleration
  hardware.graphics.extraPackages = [ pkgs.intel-media-driver ];

  # RAM-specific
  boot.tmp.useTmpfs = true;
  zramSwap.memoryPercent = 30;

  # other
  programs.steam.enable = true;
  boot.kernelPackages = with pkgs; lib.mkForce linuxPackages;

  system.stateVersion = "25.05";
}
