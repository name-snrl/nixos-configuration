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

  hardware.system76 = {
    enableAll = true;
    power-daemon.enable = false;
  };

  # CPU
  nix.settings.cores = 6;

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
