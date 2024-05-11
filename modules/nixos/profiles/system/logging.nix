{
  services.journald.extraConfig = "SystemMaxUse=200M";
  systemd.coredump.extraConfig = "MaxUse=200M";
}
