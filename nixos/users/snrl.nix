{
  lib,
  pkgs,
  ...
}:
{
  users.users.name_snrl = {
    uid = 1000;
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "dialout"
    ];
    hashedPassword = "$6$6US0iMDXE1K7wj9g$2/JKHfX4VfNETELdt4dTlTUzlmZAmvP4XfRNB5ORVPYNmi6.A4EWpSXkpx/5PrPx1J/LaA41n2NDss/R0Utqh/";
    openssh.authorizedKeys.keyFiles = [
      (pkgs.fetchurl {
        url = "https://github.com/name-snrl.keys";
        hash = "sha256-6HDroPthJirnLGCDdxnLWnYYyIA/Kf8zQBad05aKYfY=";
      })
    ];
  };

  nix.settings.trusted-users = [ "name_snrl" ];

  home-manager.users.name_snrl.imports =
    with lib.fileset;
    toList (fileFilter (f: f.hasExt "nix") ../../home-manager/snrl);

}
