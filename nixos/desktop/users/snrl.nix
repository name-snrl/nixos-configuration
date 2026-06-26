{
  lib,
  ...
}:
{
  home-manager.users.name_snrl.imports =
    with lib.fileset;
    toList (fileFilter (f: f.hasExt "nix") ../../../home-manager/snrl);
}
