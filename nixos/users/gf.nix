{
  lib,
  ...
}:
{
  users.users.Elizabeth = {
    uid = 1001;
    isNormalUser = true;
    extraGroups = [ "netdev" ];
    hashedPassword = "$6$6US0iMDXE1K7wj9g$2/JKHfX4VfNETELdt4dTlTUzlmZAmvP4XfRNB5ORVPYNmi6.A4EWpSXkpx/5PrPx1J/LaA41n2NDss/R0Utqh/";
  };

  home-manager.users.Elizabeth.imports =
    with lib.fileset;
    toList (fileFilter (f: f.hasExt "nix") ../../home-manager/gf);
}
