{ pkgs, ... }: {
  i18n.defaultLocale = "en_GB.UTF-8";
  time = {
    timeZone = "Asia/Yekaterinburg";
    hardwareClockInLocalTime = true;
  };

  i18n = {
    inputMethod.enabled = "fcitx5"; # TODO if desktop
    inputMethod.fcitx5.addons = [ pkgs.fcitx5-mozc ];
  };
}
