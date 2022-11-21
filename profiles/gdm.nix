{ pkgs, ... }:
{
  systemd.services.display-manager.serviceConfig.LogNamespace = "desktop-session";
  environment.etc."systemd/journald@desktop-session.conf".text = ''
    [Journal]
    SystemMaxUse=200M
  '';
  services.xserver = {
    displayManager = {
      gdm = {
        wayland = true;
        enable = true;
      };
    };
    enable = true;
    excludePackages = with pkgs; with xorg; [
      xorgserver.out
      xrandr
      xrdb
      setxkbmap
      iceauth
      xlsclients
      xset
      xsetroot
      xinput
      xprop
      xauth
      xf86inputevdev.out
      xterm
      xdg-utils
      nixos-icons
    ];
  };
}
