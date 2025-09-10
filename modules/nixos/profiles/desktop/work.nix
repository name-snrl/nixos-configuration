{
  vars,
  lib,
  pkgs,
  ...
}:
{
  security.pki.certificateFiles = [
    (builtins.fetchurl {
      url = "file:///home/${vars.users.master.name}/nixos-configuration/tawasalca.crt";
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
  nix.settings = {
    netrc-file = "/etc/nix/netrc";
    extra-substituters = lib.singleton "https://tws-nix-store.cachix.org";
    extra-trusted-public-keys = lib.singleton "tws-nix-store.cachix.org-1:YnG1QOR0dlKEgd1wyuB3mjy5kXMjIPss85B3aYkUJfk=";
  };
}
