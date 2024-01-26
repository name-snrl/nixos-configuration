{ pkgs, ...}: {
  # wluma
  environment.systemPackages = [ pkgs.wluma ];
  services.udev.packages = [ pkgs.wluma ];
  systemd = {
    packages = [ pkgs.wluma ];
    user.services.wluma.wantedBy = [ "graphical-session.target" ];
    # TODO remove after version with https://github.com/maximbaz/wluma/pull/93
    user.services.wluma.serviceConfig.PrivateMounts = false;
  };
  users.users.default.extraGroups = [ "video" ];
  # clight
  systemd.user.services."app-clight@autostart".enable = false; # TODO https://github.com/NixOS/nixpkgs/pull/262624
  services.clight = {
    enable = true;
    temperature.day = 5700;
    temperature.night = 4000;
    settings = {
      daytime = {
        sunrise = "7:00";
        sunset = "23:00";
      };
      backlight.disabled = true;
      inhibit.disabled = true;
      keyboard.disabled = true;
      dimmer.disabled = true;
      dpms.disabled = true;
      screen.disabled = true;
    };
  };
}
