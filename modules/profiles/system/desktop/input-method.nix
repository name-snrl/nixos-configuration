{ pkgs, ... }:
{
  i18n = {
    inputMethod.enabled = "fcitx5";
    inputMethod.fcitx5.addons = [ pkgs.fcitx5-mozc ];
  };
}
