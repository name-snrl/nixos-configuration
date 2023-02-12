{ config, lib, pkgs, inputs, ... }:

with lib;

{
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    supportedFilesystems = [ "ntfs" ];
  };

  # Firmware
  hardware.enableRedistributableFirmware = true;

  # RAM
  zramSwap.enable = true;

  # Storage
  services.fstrim.enable = true;
  boot.tmpOnTmpfs = true;

  # Networking
  networking = {
    #firewall.enable = false;
    hostName = "nixos";
    wireless.iwd.enable = true;
  };

  # GPS
  #services.gpsd.enable = true;
  #services.gpsd.device = "/dev/ttyACM0";
  #services.geoclue2.enable = true;
  location.provider = "geoclue2";

  programs.light.enable = true;
  users.users.default.extraGroups = [ "adbusers" "video" ];

  hardware.trackpoint = {
    enable = true;
    sensitivity = 130;
    speed = 180;
  };

  #---------------------------- ENVIRONMENT N SOFT ----------------------------#


  # work stuff
  security.pki.certificateFiles = [ inputs.CA ];
  programs.openvpn3.enable = true;

  environment = {
    pathsToLink = [ "/share" ];
    sessionVariables = {
      # XDG base dir
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";

      # set gsettings schemas
      XDG_DATA_DIRS = [ (pkgs.glib.getSchemaDataDirPath pkgs.gsettings-desktop-schemas) ];

      # misc
      TERMINAL = "alacritty";
      MENU = "wofi -d";
      EDITOR = "nvim";
      BROWSER = "nvim";
      QT_QPA_PLATFORMTHEME = "qt5ct"; # TODO create an issue
    };
  };

  qt.enable = true;
  qt.platformTheme = "qt5ct";

  services.dbus.implementation = "broker";

  documentation.man.generateCaches = true;

  programs.adb.enable = true;
}
