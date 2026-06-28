{
  inputs,
  pkgs,
  lib,
  config,
  vars,
  ...
}:
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

  # CPU
  nix.settings.cores = 10;
  hardware.cpu.intel.npu.enable = true;
  # services.thermald.enable = true; # add to lemp13?
  services.thinkfan = {
    enable = true;
    levels = [
      [
        1
        0
        66
      ]
      [
        3
        56
        72
      ]
      [
        5
        64
        80
      ]
      [
        7
        76
        32767
      ]
    ];
  };

  # GPU acceleration
  hardware.graphics.extraPackages = [ pkgs.intel-media-driver ];

  # RAM-specific
  boot.tmp.useTmpfs = true;
  zramSwap.memoryPercent = 30;
  boot.kernelParams = [ "zfs.zfs_arc_max=${toString (1024 * 1024 * 1024 * 4)}" ];

  # other
  programs.steam.enable = true;

  environment.persistence = lib.mkIf config.chaotic.zfs-impermanence-on-shutdown.enable {
    ${vars.fs.impermanence.persistent} = {
      directories = [
        {
          directory = "/var/lib/sddm";
          user = "sddm";
          group = "sddm";
          mode = "750";
        }

        {
          directory = "/var/lib/iwd";
          mode = "700";
        }
        {
          directory = "/var/lib/bluetooth";
          mode = "700";
        }
        "/var/lib/upower"
        "/var/lib/power-profiles-daemon"
      ];
    };
  };

  home-manager.sharedModules =
    inputs.self.moduleTree.home-manager {
      configurations = false;
      profiles = {
        gf = false;
        snrl = false;
      };
    }
    ++ [ { home.stateVersion = "25.05"; } ];

  system.stateVersion = "25.05";
}
