{ inputs, config, ... }: {
  security.pki.certificateFiles = [
    (__fetchurl {
      url =
        "file:///home/${config.users.users.default.name}/nixos-configuration/tawasalca.crt";
      sha256 = "sha256-XokEwCbkPf747dxgw79ZXIs6tB2EW35R9ZaPA6Jd4S4=";
    })
  ];
  programs.openvpn3.enable = true;
}
