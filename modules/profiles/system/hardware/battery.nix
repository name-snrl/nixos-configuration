{ config, lib, ... }:
lib.mkIf config.host-specs.battery {
  services.upower.enable = true;
  services.tlp = {
    enable = true;
    settings = config.host-specs.tlp-settings;
  };
}
