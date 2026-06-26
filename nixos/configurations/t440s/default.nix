{
  lib,
  pkgs,
  config,
  ...
}:
{
  networking.hostName = lib.baseNameOf ./.;

  boot.initrd.kernelModules = [ "i915" ]; # Enable early KMS

  # CPU
  powerManagement.cpuFreqGovernor = "schedutil";

  # GPU acceleration
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "i965";
    VDPAU_DRIVER = lib.mkIf config.hardware.graphics.enable (lib.mkDefault "va_gl");
  };
  hardware.graphics.extraPackages = with pkgs; [
    intel-vaapi-driver
    libvdpau-va-gl
  ];

  # RAM-specific
  boot.tmp.useTmpfs = true;
  zramSwap.memoryPercent = 100;

  # other host-specific settings
  services = {
    upower.enable = true;
    tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0 = 40;
        STOP_CHARGE_THRESH_BAT0 = 60;

        START_CHARGE_THRESH_BAT1 = 40;
        STOP_CHARGE_THRESH_BAT1 = 55;
      };
    };
  };

  home-manager.sharedModules = [
    { home.stateVersion = "23.11"; }
  ];

  system.stateVersion = "22.05";
}
