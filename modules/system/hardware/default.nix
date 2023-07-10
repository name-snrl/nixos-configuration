{ config, ... }: {
  # TODO depends on host spec
  hardware.enableRedistributableFirmware = true;
  zramSwap.enable = true;
  services.fstrim.enable = true;
  programs.light.enable = true;
  users.users.default.extraGroups = [ "video" ];
  hardware.trackpoint = {
    enable = true;
    sensitivity = 150;
    speed = 250;
  };
  # fix https://github.com/systemd/systemd/issues/28345
  systemd.services.trackpoint = {
    script = config.system.activationScripts.trackpoint;
    serviceConfig.Type = "idle";
    wantedBy = [ "multi-user.target" "suspend.target" ];
  };
}
