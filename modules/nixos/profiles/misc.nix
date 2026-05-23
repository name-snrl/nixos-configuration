{ lib, ... }:
{
  services.dbus.implementation = "broker";

  documentation.man.cache.enable = true; # necessary for programs that search for man pages

  # clear out the junk
  programs.nano.enable = false;
  environment.defaultPackages = lib.mkDefault [ ];
}
