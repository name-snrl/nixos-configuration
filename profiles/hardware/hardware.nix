{
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
}
