{
  pkgs,
  lib,
  config,
  vars,
  ...
}:
lib.mkMerge [
  {
    disko.devices = {
      disk.disk0 = {
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "500M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=077" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
      zpool.zroot = {
        type = "zpool";
        options = {
          ashift = "12";
          autotrim = "on";
        };
        rootFsOptions = {
          acltype = "posixacl";
          canmount = "off";
          dnodesize = "auto";
          normalization = "formD";
          relatime = "on";
          xattr = "sa";
          mountpoint = "none";
          compression = "lz4";
          encryption = "on";
          keylocation = "prompt";
          keyformat = "passphrase";
          "com.sun:auto-snapshot" = "false";
        };

        postCreateHook = "zfs snapshot zroot/rootfs@blank";

        # to prevent mounting after multi-user.target, which can lead to mishaps
        # (creating files before mounting), all datasets are mounted declaratively
        # via config. to achieve this we set options.mountpoint = "legacy" and
        # disable zfs-mount.service
        datasets = {
          rootfs = {
            mountpoint = "/";
            type = "zfs_fs";
            options.mountpoint = "legacy";
          };
          nix = {
            mountpoint = "/nix";
            type = "zfs_fs";
            options.mountpoint = "legacy";
            options.compression = "zstd";
          };
        };
      };
    };

    boot = {
      zfs.forceImportRoot = false;
      zfs.package = lib.mkIf (lib.hasInfix "cachyos" config.boot.kernelPackages.kernel.modDirVersion) pkgs.zfs_cachyos;
    };
    services.zfs = {
      trim.enable = false; # we don't need this since autotrim is enabled for zroot
      autoScrub = {
        enable = true;
        interval = "weekly";
      };
    };
    networking.hostId = with builtins; substring 0 8 (hashString "md5" config.networking.hostName);
  }

  (lib.mkIf (config.environment ? persistence && config.environment.persistence != { }) {
    disko.devices.zpool.zroot.datasets = {
      persistent = {
        mountpoint = vars.fs.impermanence.persistent;
        type = "zfs_fs";
        options.mountpoint = "legacy";
      };
      shared = {
        mountpoint = vars.fs.impermanence.shared;
        type = "zfs_fs";
        options.mountpoint = "legacy";
      };
    };
    fileSystems = {
      ${vars.fs.impermanence.persisten}.neededForBoot = true;
      ${vars.fs.impermanence.shared}.neededForBoot = true;
    };
    chaotic.zfs-impermanence-on-shutdown = {
      enable = true;
      volume = "zroot/rootfs";
      snapshot = "blank";
    };
  })
]
