{ config, lib, ... }: {
  # TODO depends on host spec
  hardware.enableRedistributableFirmware = true;
  zramSwap.enable = true;
  services.fstrim.enable = true;
  programs.light.enable = true;
  users.users.default.extraGroups = [ "video" ];
  hardware.trackpoint = {
    enable = true;
    sensitivity = 130;
    speed = 180;
  };
  # TODO create pr for this fix
  # trigger devices recursively
  system.activationScripts.trackpoint =
    let
      udevadm = "${config.systemd.package}/bin/udevadm";
      cfg = config.hardware.trackpoint;
    in
    lib.mkForce ''
      ${udevadm} trigger "$(${udevadm} trigger -v --dry-run --attr-match=name="${cfg.device}")"
    '';
}
