{ vars, inputs, ... }:
{
  users.users.${vars.users.gf.name} = {
    uid = 1001;
    hashedPassword = "$6$6US0iMDXE1K7wj9g$2/JKHfX4VfNETELdt4dTlTUzlmZAmvP4XfRNB5ORVPYNmi6.A4EWpSXkpx/5PrPx1J/LaA41n2NDss/R0Utqh/";
    isNormalUser = true;
    extraGroups = [ "netdev" ];
  };

  # TODO do we really need this?
  i18n.supportedLocales = [
    "ja_JP.UTF-8/UTF-8"
    "ru_RU.UTF-8/UTF-8"
  ];

  home-manager.users.${vars.users.gf.name}.imports =
    inputs.self.moduleTree.home-manager.profiles.gf
      { };
}
