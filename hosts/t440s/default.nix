{
  lib,
  pkgs,
  inputs,
  config,
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
        profiles.system.desktop.kde = false;
        profiles.system.servers.openssh = false;
      };
    };

  boot.initrd.kernelModules = [ "i915" ]; # Enable early KMS

  # CPU
  powerManagement.cpuFreqGovernor = "schedutil";

  # GPU acceleration
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "i965";
    VDPAU_DRIVER = lib.mkIf config.hardware.opengl.enable (lib.mkDefault "va_gl");
  };
  hardware.opengl.extraPackages = with pkgs; [
    intel-vaapi-driver
    libvdpau-va-gl
  ];

  # RAM-specific
  boot.tmp.useTmpfs = true;
  zramSwap.memoryPercent = 100;

  # other host-specific settings
  services.tlp.settings = {
    START_CHARGE_THRESH_BAT0 = 40;
    STOP_CHARGE_THRESH_BAT0 = 60;

    START_CHARGE_THRESH_BAT1 = 40;
    STOP_CHARGE_THRESH_BAT1 = 55;
  };

  xdg.portal.wlr.settings.screencast = {
    output_name = "eDP-1";
    max_fps = 60;
    chooser_type = "none";
  };

  system.stateVersion = "22.05";
}
