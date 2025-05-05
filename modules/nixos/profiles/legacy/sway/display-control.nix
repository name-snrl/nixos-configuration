# TODO this module must be reduced to the size of 3 lines:
#
# programs.wluma.enable = true;
# users.users.default.extraGroups = [ "video" ];
# environment.systemPackages = [ pkgs.wl-gammarelay-rs ];
#
# and then can be completely moved to `sway`.
{ vars, ... }:
{
  hardware.brillo.enable = true;
  # TODO move module in upstream
  # wluma
  #environment.systemPackages = [ pkgs.wluma ];
  #services.udev.packages = [ pkgs.wluma ];
  #systemd = {
  #  packages = [ pkgs.wluma ];
  #  user.services.wluma.wantedBy = [ "sway-session.target" ];
  #  # TODO remove after version with https://github.com/maximbaz/wluma/pull/93
  #  user.services.wluma.serviceConfig.PrivateMounts = false;
  #};
  users.users.${vars.users.master.name}.extraGroups = [ "video" ];
  # TODO replace with `wl-gammarelay-rs`
  # clight
  #systemd.user.services."app-clight@autostart".enable = false; # TODO https://github.com/NixOS/nixpkgs/pull/262624
  #services.clight = {
  #  enable = true;
  #  temperature.day = 6500;
  #  temperature.night = 5500;
  #  settings = {
  #    daytime = {
  #      sunrise = "7:00";
  #      sunset = "23:00";
  #    };
  #    backlight = {
  #      no_auto_calibration = true;
  #      no_smooth_transition = true;
  #    };
  #    inhibit.disabled = true;
  #    keyboard.disabled = true;
  #    dimmer.disabled = true;
  #    dpms.disabled = true;
  #    screen.disabled = true;
  #  };
  #};
}
