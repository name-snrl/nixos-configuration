{ pkgs, ... }:
{
  i18n.supportedLocales = [
    "ja_JP.UTF-8/UTF-8"
    "ru_RU.UTF-8/UTF-8"
  ];
  users.users.Elizabeth = {
    hashedPassword = "$6$6US0iMDXE1K7wj9g$2/JKHfX4VfNETELdt4dTlTUzlmZAmvP4XfRNB5ORVPYNmi6.A4EWpSXkpx/5PrPx1J/LaA41n2NDss/R0Utqh/";
    isNormalUser = true;
    extraGroups = [ "netdev" ];
    packages = with pkgs; [
      telegram-desktop
      discord
      skypeforlinux
      zoom-us
      whatsapp-for-linux

      # have to choose one
      wpsoffice
      libreoffice-qt
      onlyoffice-bin_latest
    ];
  };
}
