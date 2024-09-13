{ pkgs, ... }:
{
  programs.nano.enable = false;
  environment.defaultPackages = with pkgs; [
    pciutils
    usbutils
  ];
}
