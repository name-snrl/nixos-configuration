{
  config,
  lib,
  pkgs,
  ...
}:
{
  security.pki.certificateFiles = [
    (builtins.fetchurl {
      url = "file:///home/${config.users.users.default.name}/nixos-configuration/tawasalca.crt";
      sha256 = "sha256-XokEwCbkPf747dxgw79ZXIs6tB2EW35R9ZaPA6Jd4S4=";
    })
  ];
  programs.openvpn3.enable = true;
  environment.etc."bazel.bazelrc".text = ''
    startup --max_idle_secs=6000
  '';
  systemd.user.services.ck-client = {
    wantedBy = [ "sway-session.target" ];
    partOf = [ "graphical-session.target" ];
    script = "${lib.getExe' pkgs.cloak-pt "ck-client"} -u -c ~/.openvpn/ckclient.json";
  };
}
