{
  vars,
  lib,
  ...
}:
{
  users.users.${vars.users.gf.name} = {
    inherit (vars.users.gf) uid;
    hashedPassword = "$6$6US0iMDXE1K7wj9g$2/JKHfX4VfNETELdt4dTlTUzlmZAmvP4XfRNB5ORVPYNmi6.A4EWpSXkpx/5PrPx1J/LaA41n2NDss/R0Utqh/";
    isNormalUser = true;
    extraGroups = [ "netdev" ];
  };

  home-manager.users.${vars.users.gf.name}.imports =
    with lib.fileset;
    toList (fileFilter (f: f.hasExt "nix") ../../../../../home-manager/gf);

  environment.persistence = {
    ${vars.fs.impermanence.persistent}.users.${vars.users.gf.name}.directories = [ "" ];
  };
}
