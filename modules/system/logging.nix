{
  services.journald.extraConfig = "SystemMaxUse=200M";
  systemd.coredump.extraConfig = "Storage=none";
}
