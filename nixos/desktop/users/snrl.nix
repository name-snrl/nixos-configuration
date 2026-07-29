{
  lib,
  ...
}:
{
  home-manager.users.name_snrl.imports =
    with lib.fileset;
    toList (
      intersection (fileFilter (f: f.hasExt "nix") ../../..) (unions [
        ../../../home-manager/snrl
        ../../../home-manager/firefox-kde-integraion.nix
        ../../../home-manager/plasma
      ])
    );
}
