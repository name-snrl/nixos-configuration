{
  pkgs,
  inputs,
  importsFromAttrs,
  ...
}:
{
  imports =
    [ ./hw-config.nix ]
    ++ importsFromAttrs {
      importByDefault = true;
      modules = inputs.self.nixosModules;
      imports = {
        profiles.system.servers.openssh = false;
        profiles.system.desktop.work = false;
      };
    };

  # Firmware
  services.fwupd.enable = true; # https://fwupd.org/lvfs/devices/

  # CPU
  powerManagement.cpuFreqGovernor = "schedutil";

  # GPU acceleration
  hardware.opengl.extraPackages = with pkgs; [ intel-media-driver ];

  # RAM-specific
  boot.tmp.useTmpfs = true;
  zramSwap.memoryPercent = 50;

  # other host-specific settings
  services.tlp.settings = {
    START_CHARGE_THRESH_BAT0 = 40;
    STOP_CHARGE_THRESH_BAT0 = 50;
  };

  xdg.portal.wlr.settings.screencast = {
    output_name = "eDP-1";
    max_fps = 60;
    chooser_type = "none";
  };

  users.users.Elizabeth = {
    hashedPassword = "$6$6US0iMDXE1K7wj9g$2/JKHfX4VfNETELdt4dTlTUzlmZAmvP4XfRNB5ORVPYNmi6.A4EWpSXkpx/5PrPx1J/LaA41n2NDss/R0Utqh/";
    isNormalUser = true;
  };

  system.stateVersion = "24.05";
}
