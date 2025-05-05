{ vars, ... }:
{
  disko.devices.zpool.zroot.datasets.persistent = {
    mountpoint = vars.fs.impermanence.persistent;
    type = "zfs_fs";
    options.mountpoint = "legacy";
  };

  fileSystems.${vars.fs.impermanence.persistent}.neededForBoot = true;

  chaotic.zfs-impermanence-on-shutdown = {
    # since this option enables the wiping of the root FS, I use it as
    # condition for `environment.persistence` in other modules
    enable = true;
    volume = "zroot/rootfs";
    snapshot = "blank";
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
