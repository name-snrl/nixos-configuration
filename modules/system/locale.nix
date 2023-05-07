{ config, lib, pkgs, ... }: {
  i18n.defaultLocale = "en_GB.UTF-8";
  time = {
    timeZone = "Asia/Yekaterinburg";
    hardwareClockInLocalTime = true;
  };

  # fcitx5
  i18n = {
    inputMethod.enabled = "fcitx5"; # TODO if desktop
    inputMethod.fcitx5.addons = [ pkgs.fcitx5-mozc ];
  };
  environment = with lib;
    {
      sessionVariables = {
        # fix candidate box in firefox
        NIX_PROFILES = concatStringsSep " " (reverseList config.environment.profiles);
        # TODO make pr and change variable to sessionVariable
        # https://github.com/NixOS/nixpkgs/blob/5ed481943351e9fd354aeb557679624224de38d5/nixos/modules/i18n/input-method/fcitx5.nix#L30
        GTK_IM_MODULE = "fcitx";
        QT_IM_MODULE = "fcitx";
        XMODIFIERS = "\\@im=fcitx";
        QT_PLUGIN_PATH =
          [ "${config.i18n.inputMethod.package}/${pkgs.qt6.qtbase.qtPluginPrefix}" ];
      };
      variables = {
        QT_PLUGIN_PATH = mkForce config.environment.sessionVariables.QT_PLUGIN_PATH;
        XMODIFIERS = mkForce "@im=fcitx";
      };
    };
}
