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
  # temporarly fix https://github.com/systemd/systemd/issues/28345
  services.udev.extraRules = with config.hardware.trackpoint; ''
    ACTION=="add|change", SUBSYSTEM=="input", ENV{ID_INPUT_POINTINGSTICK}=="1", ENV{ID_BUS}=="i8042", ATTR{device/device/speed}="${toString speed}", ATTR{device/device/sensitivity}="${toString sensitivity}"
  '';
}
