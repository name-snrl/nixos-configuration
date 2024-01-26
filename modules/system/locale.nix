{
  i18n.defaultLocale = "en_GB.UTF-8";
  time.hardwareClockInLocalTime = true;
  location.provider = "geoclue2";
  systemd.user.services."app-geoclue\\x2ddemo\\x2dagent@autostart".enable = false; # TODO https://github.com/NixOS/nixpkgs/pull/262625
  services.automatic-timezoned.enable = true;
}
