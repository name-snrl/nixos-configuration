{
  config,
  pkgs,
  lib,
  vars,
  ...
}:
{
  disko.devices.zpool.zroot.datasets.persistent = {
    mountpoint = vars.fs.impermanence.persistent;
    type = "zfs_fs";
    options.mountpoint = "legacy";
  };

  fileSystems.${vars.fs.impermanence.persistent}.neededForBoot = true;

  systemd.shutdownRamfs = {
    contents."/etc/systemd/system-shutdown/zpool".source = lib.mkForce (
      pkgs.writeShellScript "zpool-sync-shutdown" ''
        ${config.boot.zfs.package}/bin/zfs rollback -r zroot/rootfs@blank
        exec ${config.boot.zfs.package}/bin/zpool sync
      ''
    );
    storePaths = [ "${config.boot.zfs.package}/bin/zfs" ];
  };

  environment.persistence.${vars.fs.impermanence.persistent} = {
    hideMounts = true;
    files = [
      "/etc/machine-id"
      "/root/.bash_history"
    ];
    directories = [
      "/var/log"
      "/var/lib/systemd/coredump"
      "/var/lib/systemd/pstore"
      "/var/lib/nixos"

      "/root/.config/nvim"
      "/root/.local/state/nvim"
      "/root/.local/share/nvim"
      "/root/.local/share/fish"
      "/root/.local/share/zoxide"
    ];
  };
}
