{ options, ... }:
{
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    supportedLocales = options.i18n.supportedLocales.default;
  };
  time.hardwareClockInLocalTime = true;
  location.provider = "geoclue2";
  services.automatic-timezoned.enable = true;
}
