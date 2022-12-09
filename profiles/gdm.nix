{ config, lib, pkgs, ... }:
{
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;

  systemd = with lib; {
    defaultUnit = "graphical.target";
    services.display-manager = {
      enable = true;
      script = "${pkgs.gnome.gdm}/bin/gdm";
      restartIfChanged = false;

      after = [
        "acpid.service"
        "systemd-logind.service"
        "systemd-user-sessions.service"
      ];

      environment = config.services.xserver.displayManager.job.environment //
        optionalAttrs config.hardware.opengl.setLdLibraryPath
          { LD_LIBRARY_PATH = makeLibraryPath [ pkgs.addOpenGLRunpath.driverLink ]; };

      serviceConfig = {
        Restart = "always";
        RestartSec = "200ms";
        SyslogIdentifier = "display-manager";
        LogNamespace = "desktop-session";
      };
    };
  };

  environment.etc."systemd/journald@desktop-session.conf".text = ''
    [Journal]
    SystemMaxUse=200M
  '';
}
