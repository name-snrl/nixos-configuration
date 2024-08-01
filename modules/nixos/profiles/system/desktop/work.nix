{ config, pkgs, ... }:
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
  systemd.user.services.ck-client =
    let
      ck-version = "2.9.0";
      ck-client = pkgs.fetchurl {
        url = "https://github.com/cbeuw/Cloak/releases/download/v${ck-version}/ck-client-linux-amd64-v${ck-version}";
        hash = "sha256-0u1QK3AOroUj/8im22ALWRlUcWkmntLJlx4uItpHvm8=";
        executable = true;
      };
    in
    {
      wantedBy = [ "sway-session.target" ];
      partOf = [ "graphical-session.target" ];
      script = "${ck-client} -u -c ~/.openvpn/ckclient.json";
    };
}
