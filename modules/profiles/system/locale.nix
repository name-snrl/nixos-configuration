{ config, lib, ... }:
{
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    supportedLocales =
      with lib;
      unique (
        builtins.map
          (
            l:
            (replaceStrings
              [
                "utf8"
                "utf-8"
                "UTF8"
              ]
              [
                "UTF-8"
                "UTF-8"
                "UTF-8"
              ]
              l
            )
            + "/UTF-8"
          )
          (
            [
              "C.UTF-8"
              "en_US.UTF-8"
              config.i18n.defaultLocale
            ]
            ++ (attrValues (filterAttrs (n: _v: n != "LANGUAGE") config.i18n.extraLocaleSettings))
          )
      );
  };
  time.hardwareClockInLocalTime = true;
  location.provider = "geoclue2";
  services.automatic-timezoned.enable = true;
}
