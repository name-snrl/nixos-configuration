{ config, pkgs, ... }: {
  security.pki.certificateFiles = [
    (builtins.fetchurl {
      url = "file:///home/${config.users.users.default.name}/nixos-configuration/tawasalca.crt";
      sha256 = "sha256-XokEwCbkPf747dxgw79ZXIs6tB2EW35R9ZaPA6Jd4S4=";
    })
  ];
  programs.openvpn3.enable = true;
  environment.etc."bazel.bazelrc".text = ''
    startup --max_idle_secs=60
  '';
  systemd.user.services.ck-client =
    let
      ck-client = pkgs.fetchurl {
        url = "https://github.com/cbeuw/Cloak/releases/download/v2.7.0/ck-client-linux-amd64-v2.7.0";
        hash = "sha256-lP8KzK+FuqHpAuH8xKjYI3/AU7EbPDENYq4IEIsINk0=";
        executable = true;
      };
    in
    {
      wantedBy = [ "sway-session.target" ];
      partOf = [ "graphical-session.target" ];
      script = "${ck-client} -u -c ~/.openvpn/ckclient.json";
    };
}
