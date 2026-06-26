{ pkgs, ... }:
{
  # nixos-containers networking
  networking.nat = {
    enable = true;
    internalInterfaces = [ "ve-+" ];
  };
  environment.systemPackages = [ pkgs.remmina ];
}
