{ lib, pkgs, ... }:
{
  systemd = {
    packages = with pkgs; [
      libsForQt5.polkit-kde-agent
    ];
    user = {
      targets.sway-session = {
        description = "sway compositor session";
        documentation = [ "man:systemd.special(7)" ];
        bindsTo = [ "graphical-session.target" ];
        wants = [ "graphical-session-pre.target" ];
        after = [ "graphical-session-pre.target" ];
      };

      # activate the services from the packages
      services.plasma-polkit-agent = {
        environment.PATH = lib.mkForce null; # TODO probably won't be needed in HM
        wantedBy = [ "sway-session.target" ];
      };

      # services written by me
      services.waybar = {
        description = "Highly customizable bar for Sway";
        partOf = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        requisite = [ "graphical-session.target" ];
        script = "${pkgs.waybar}/bin/waybar";
        serviceConfig.ExecReload = "kill -SIGUSR2 $MAINPID";
        environment.PATH = lib.mkForce null; # TODO probably won't be needed in HM
        wantedBy = [ "sway-session.target" ];
      };

      services.swayidle = {
        description = "Idle management daemon";
        partOf = [ "graphical-session.target" ];
        script = "${pkgs.swayidle}/bin/swayidle -w";
        environment.PATH = lib.mkForce null; # TODO probably won't be needed in HM
        wantedBy = [ "sway-session.target" ];
      };

      services.wl-clip-persist = {
        description = "Keep clipboard even after programs close";
        partOf = [ "graphical-session.target" ];
        script = "${pkgs.wl-clip-persist}/bin/wl-clip-persist -c both";
        environment.PATH = lib.mkForce null; # TODO probably won't be needed in HM
        wantedBy = [ "sway-session.target" ];
      };
    };
  };
}
