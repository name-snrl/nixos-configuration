{
  pkgs,
  vars,
  ...
}:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos;
    supportedFilesystems = [ "ntfs" ];
  };

  i18n.defaultLocale = "en_GB.UTF-8";

  # TODO geoclue doesn't work
  # https://github.com/NixOS/nixpkgs/issues/321121
  #location.provider = "geoclue2";
  #services.automatic-timezoned.enable = true;
  time.timeZone = "Asia/Tokyo";

  # don't need so many logs on desktops
  services.journald.extraConfig = "SystemMaxUse=200M";
  systemd.coredump.extraConfig = "MaxUse=200M";

  programs.adb.enable = true;
  users.users.${vars.users.master.name}.extraGroups = [ "adbusers" ];

  services.udisks2.enable = true;
  environment.defaultPackages = with pkgs; [
    pciutils
    usbutils
  ];
}
