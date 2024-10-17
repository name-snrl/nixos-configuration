{ lib, ... }:
{
  services.dbus.implementation = "broker";

  documentation = {
    man.generateCaches = true; # necessary for programs that search for man pages
    nixos.enable = false; # I never read, but it takes too long to compile
  };

  # clear out the junk
  programs.nano.enable = false;
  environment.defaultPackages = lib.mkDefault [ ];
}
